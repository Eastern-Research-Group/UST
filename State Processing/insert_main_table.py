from logger_factory import logger
import utils
import make_template_view
import export_template, export_needed_geocode

import psycopg2.errors


def col_list_to_string(col_list, quote_type='"'):
	col_string = ''
	for col in col_list:
		col_string = col_string + quote_type + col + quote_type + ', '
	col_string = col_string[:-2] 	
	return col_string 


def get_col_string(cur, table_name, uninclude_cols=[]):
	uninclude_col_clause = ''
	if uninclude_cols:
		uninclude_col_clause = ' and column_name not in (' + col_list_to_string(uninclude_cols, "'") + ') '

	sql = f"""select column_name from information_schema.columns 
	         where table_schema = 'public' and table_name = %s
	         {uninclude_col_clause}
	         order by ordinal_position"""
	cur.execute(sql, (table_name,))
	cols = [r[0] for r in cur.fetchall()]

	return col_list_to_string(cols,'"')


def add_table_prefix_to_cols(col_string):
	col_list = col_string.split(', ')
	col_list = ['a.' + c for c in col_list]
	return col_list_to_string(col_list, quote_type="'")


def make_view(organization_id, ust_or_lust):
	# create the main view in the organization schema that holds the data in template format
	make_template_view.main(organization_id, ust_or_lust)


def delete_old(cur, table_name, organization_id, control_id):
	sql = "delete from " + table_name + ' where organization_id = %s and control_id = %s'
	cur.execute(sql, (organization_id, control_id))
	logger.info('Deleted %s existing rows from %s', cur.rowcount, table_name)


def insert_location_table(cur, location_table, control_id, organization_id, view_name):
	col_string = get_col_string(cur, location_table, uninclude_cols=['ust_facilities_id', 'lust_location_id', 'control_id', 'organization_id'])
	sql = f'insert into {location_table} (control_id, organization_id, ' + col_string + ') '
	sql = sql + 'select distinct ' + str(control_id) + ", '" + organization_id + "'," + col_string + ' from ' + view_name
	cur.execute(sql)
	logger.info('Inserted %s rows into table %s', cur.rowcount, location_table)


def insert_main_table(cur, ust_or_lust, control_id, organization_id, location_column, view_name, join_sql):
	col_string =  get_col_string(cur, ust_or_lust.lower(), uninclude_cols=['ust_id', 'lust_id', 'control_id', 'organization_id', 'ust_facilities_id', 'lust_location_id'])
	sql = f'insert into {ust_or_lust.lower()} (control_id, organization_id, ' + location_column + ',' + col_string + ')'
	sql = sql + '\nselect ' + str(control_id) + ", '" + organization_id + "', b." + location_column + ', ' + add_table_prefix_to_cols(col_string).replace("'","") 
	sql = sql + '\nfrom ' + view_name + join_sql 
	sql = sql + '\nwhere b.control_id = %s'
	print(sql)
	cur.execute(sql, (control_id,))
	logger.info('Inserted %s rows into table %s', cur.rowcount, ust_or_lust.lower())


def insert_geo_table(cur, control_id, organization_id, geo_table, location_table, location_column, lat_col, long_col):
	sql = f"""insert into {geo_table} (control_id, organization_id, {location_column}, gc_coordinate_source)
			select distinct %s, %s, {location_column}, 'State'
			from {location_table}
			where {lat_col} is not null and length(right({lat_col}::text, length({lat_col}::text) - position('.' in {lat_col}::text))) >= 3
			and {long_col} is not null and length(right({long_col}::text, length({long_col}::text) - position('.' in {long_col}::text))) >= 3
			and {location_column} not in (select {location_column} from {geo_table})"""
	cur.execute(sql, (control_id, organization_id))
	logger.info('Inserted %s rows into table %s where state lat/longs are sufficient', cur.rowcount, geo_table)


def missing_geo(cur, ust_or_lust, organization_id, control_id, geo_table, location_table, location_column):
	sql = f"""select count(*) from {location_table}
			  where control_id = %s and {location_column} not in (select {location_column} from {geo_table})"""
	cur.execute(sql, (control_id,))
	cnt = cur.fetchone()[0]
	logger.info('There are %s rows with insufficient lat/long data.', cnt)
	if cnt > 0:
		logger.info('Exporting to spreadsheet for geoprocessing; send it to Paul')
		export_needed_geocode.main(ust_or_lust, organization_id, control_id)


def main(organization_id, ust_or_lust, control_id=None, main_table_only=False, export=True):
	logger.info('Working on %s %s', organization_id, ust_or_lust.upper())

	make_view(organization_id, ust_or_lust)

	schema = utils.get_schema_name(organization_id, ust_or_lust)
	view_name = '"' + schema + '".v_' + ust_or_lust.lower() 

	conn = utils.connect_db()
	cur = conn.cursor()

	# if not passed to this function, find the most current control_id for this organization's data
	if not control_id:
		control_id = utils.get_control_id(ust_or_lust, organization_id)

	# get the table and primary key column name of the UST Facilities or LUST Locations table
	location_table = 'ust_facilities'
	location_column = 'ust_facilities_id'
	lat_col = '"FacilityLatitude"'
	long_col = '"FacilityLongitude"'
	geo_table = ust_or_lust.lower() + '_geocode'
	join_sql = f""" a join {location_table} b on a."FacilityID" = b."FacilityID"
		and coalesce(a."FacilityName",'X') = coalesce(b."FacilityName",'X')
		and coalesce(a."FacilityAddress1",'X') = coalesce(b."FacilityAddress1",'X')
		and coalesce(a."FacilityAddress2",'X') = coalesce(b."FacilityAddress2",'X')
		and coalesce(a."FacilityCity",'X') = coalesce(b."FacilityCity",'X')
		and coalesce(a."FacilityCounty",'X') = coalesce(b."FacilityCounty",'X')
		and coalesce(a."FacilityZipCode",'X') = coalesce(b."FacilityZipCode",'X') """
	if not main_table_only:
		join_sql = join_sql + """
		and coalesce(a."FacilityLatitude",0) = coalesce(b."FacilityLatitude",0)
		and coalesce(a."FacilityLongitude",0) = coalesce(b."FacilityLongitude",0) """
	if ust_or_lust.lower() == 'lust':
		location_table = 'lust_locations'
		location_column = 'lust_location_id'
		lat_col = '"Latitude"'
		long_col = '"Longitude"'
		join_sql = f""" a join {location_table} b on a."LUSTID" = b."LUSTID"
			and coalesce(a."SiteName",'X') = coalesce(b."SiteName",'X')
			and coalesce(a."SiteAddress",'X') = coalesce(b."SiteAddress",'X')
			and coalesce(a."SiteAddress2",'X') = coalesce(b."SiteAddress2",'X')
			and coalesce(a."SiteCity",'X') = coalesce(b."SiteCity",'X')
			and coalesce(a."Zipcode",'X') = coalesce(b."Zipcode",'X')
			and coalesce(a."County",'X') = coalesce(b."County",'X')
			and coalesce(a."State",'X') = coalesce(b."State",'X') """
		if not main_table_only:
			join_sql = join_sql + """
			and coalesce(a."Latitude",0) = coalesce(b."Latitude",0)
			and coalesce(a."Longitude",0) = coalesce(b."Longitude",0) """

	# delete existing data from main data table, if it exists	
	delete_old(cur, ust_or_lust.lower(), organization_id, control_id)	
	if not main_table_only:
		# delete from geo table, if exists
		delete_old(cur, ust_or_lust.lower() + '_geocode', organization_id, control_id)
		# delete existing data from UST Facilities/LUST Locations table, if it exists	
		delete_old(cur, location_table, organization_id, control_id)	

	if not main_table_only:
		# build and execute SQL to insert rows into UST Facilities or LUST Locations table
		insert_location_table(cur, location_table, control_id, organization_id, view_name)
	# build and execute SQL to insert rows into main data table
	insert_main_table(cur, ust_or_lust, control_id, organization_id, location_column, view_name, join_sql)
	if not main_table_only:
		# insert rows with sufficient lat/long data into geocoding table with State as the gc coordinate source
		insert_geo_table(cur, control_id, organization_id, geo_table, location_table, location_column, lat_col, long_col)
		# determine if state needs additional geocoding and export a CSV file for Paul if so
		missing_geo(cur, ust_or_lust, organization_id, control_id, geo_table, location_table, location_column)

	conn.commit()
	cur.close()
	conn.close()

	if export:
		export_template.main(organization_id, ust_or_lust)
	logger.info('Processing for %s %s complete', organization_id, ust_or_lust.upper())


def multiple_organization_ids(organization_ids, ust_or_lust):
	for organization_id in organization_ids:
		main(organization_id, ust_or_lust)


if __name__ == '__main__':
	organization_id = 'TRUSTD'
	ust_or_lust = 'ust'
	main_table_only = True
	export = False
	main(organization_id, ust_or_lust, main_table_only=main_table_only, export=export)

	# organization_ids = ['AL','CA','NC','NE','NY','OR','SC','TN','TRUSTD','TX']
	# ust_or_lust = 'ust'
	# multiple_organization_ids(organization_ids, ust_or_lust)