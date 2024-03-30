import sys
import os
sys.path = [os.path.join(os.path.dirname(__file__), "..", "..")] + sys.path
from ust.util.logger_factory import logger
from ust.util import utils, config
from ust.state_processing import export_template
from ust.util import config, utils
import export_template
import pandas.io.sql as sqlio
import pandas as pd
from psycopg2.errors import DuplicateSchema, UndefinedTable, InvalidTextRepresentation, DatatypeMismatch


def upload_geocoded_data(ust_or_lust, file_path, organization_id=None):
	conn = utils.connect_db()
	cur = conn.cursor()		

	try:
		if file_path[-4:] == 'xlsx':
			df = pd.read_excel(file_path, low_memory=False)   
		elif file_path[-3:] == 'csv':
			df = pd.read_csv(file_path, low_memory=False)
		else:
			logger.warning('File extension is not xlsx or csv; unable to upload to database')
			exit()
	except ValueError as e:
		logger.error('Error opening %s; aborting: %s', file_path, e) 
		exit()
	
	if organization_id:
		schema = utils.get_schema_name(organization_id, ust_or_lust)
		table_name = organization_id.lower() + '_' + ust_or_lust.lower() + '_geocoded'
	else:
		schema = 'public'
		table_name = ust_or_lust.lower() + '_geocoded_temp'

	engine = utils.get_engine(schema=schema)    
	df.to_sql(table_name, engine, index=False, if_exists='replace')
	logger.info('Created table %s.%s', schema, table_name)

	cur.close()
	conn.close()

	return '"' + schema + '".' + table_name


def get_table_name(ust_or_lust, organization_id=None):
	conn = utils.connect_db()
	cur = conn.cursor()		
	
	if organization_id: 
		schema = utils.get_schema_name(organization_id, ust_or_lust)
		sql = """select table_name from information_schema.tables 
			 where table_schema = %s and table_type = 'BASE TABLE'
			 and lower(table_name) like '%%geocod%%'"""
		cur.execute(sql, (schema,))
		geo_table = cur.fetchone()[0]
	else:
		schema = 'public'
		geo_table = ust_or_lust.lower() + '_geocoded_temp'	

	cur.close()
	conn.close()

	return geo_table


def update_geo_table(ust_or_lust, organization_id=None, staging_table_name=None):
	if not staging_table_name:
		 staging_table_name = get_table_name(ust_or_lust, organization_id)

	geo_table = ust_or_lust.lower() + '_geocode'
	if ust_or_lust.lower() == 'ust':
		colname = 'ust_facilities_id'
		join_table = 'ust_facilities'
	else:
		colname = 'lust_location_id'
		join_table = 'lust_locations'


	conn = utils.connect_db()
	cur = conn.cursor()			

	sql = f"""update {geo_table} a 
			set (gc_latitude, gc_longitude, gc_coordinate_source, gc_address_type, gc_status, 
				gc_score, gc_match_address, gc_street_address, gc_city, gc_state, 
				gc_zip, gc_zip4, gc_country, gc_outside_state) =
				(select gc_latitude, gc_longitude, gc_coordinate_source, gc_address_type, gc_status, 
						gc_score, gc_match_address, gc_street_address, gc_city, gc_state, 
						gc_zip, gc_zip4, gc_country, gc_outside_state
				from {staging_table_name} b
				where a.{colname} = b.{colname})
			where exists (select 1 from {staging_table_name}  b
				where a.{colname} = b.{colname})"""
	try:
		cur.execute(sql)
	except (InvalidTextRepresentation, DatatypeMismatch):
		sql = f"""update {geo_table} a 
				set (gc_latitude, gc_longitude, gc_coordinate_source, gc_address_type) =
					(select gc_latitude, gc_longitude, gc_coordinate_source, gc_address_type
					from {staging_table_name} b
					where a.{colname} = b.{colname})
				where exists (select 1 from {staging_table_name}  b
					where a.{colname} = b.{colname})"""
		cur.execute(sql)
	
	conn.commit()
	logger.info('Updated %s rows in %s', cur.rowcount, geo_table)
	
	sql = f"""insert into {geo_table}
				(control_id, organization_id, {colname}, gc_latitude, gc_longitude, gc_coordinate_source, 
				gc_address_type, gc_status, gc_score, gc_match_address, gc_street_address, gc_city, gc_state, 
				gc_zip, gc_zip4, gc_country, gc_outside_state)
			select distinct control_id, a.organization_id, a.{colname}, gc_latitude, gc_longitude, gc_coordinate_source, 
				gc_address_type, gc_status, gc_score, gc_match_address, gc_street_address, gc_city, gc_state, 
				gc_zip, gc_zip4, gc_country, gc_outside_state
			from {staging_table_name} a join {join_table} b on a.{colname} = b.{colname}
			where not exists 
				(select 1 from {geo_table} c where a.{colname} = c.{colname})"""
	try:
		cur.execute(sql)
	except (InvalidTextRepresentation, DatatypeMismatch):
		sql = f"""insert into {geo_table}
					(control_id, organization_id, {colname}, gc_latitude, gc_longitude, gc_coordinate_source, gc_address_type)
				select distinct control_id, a.organization_id, a.{colname}, gc_latitude, gc_longitude,
					 gc_coordinate_source, gc_address_type
				from {staging_table_name} a join {join_table} b on a.{colname} = b.{colname}
				where not exists 
					(select 1 from {geo_table} c where a.{colname} = c.{colname})"""
		cur.execute(sql)

	conn.commit()
	logger.info('Inserted %s rows into %s', cur.rowcount, staging_table_name)

	cur.close()
	conn.close()



def main(ust_or_lust, file_path=None, organization_id=None):
	logger.info('Starting process...')
	if file_path:
		table_name = upload_geocoded_data(ust_or_lust, file_path, organization_id)
	else:
		table_name = None

	update_geo_table(ust_or_lust, organization_id=organization_id, staging_table_name=table_name)

	logger.info('Script complete')


if __name__ == '__main__':   
	organization_id = None
	ust_or_lust = 'ust'

	# Set file_path to None if file is already uploaded
	file_name = 'UST_for_geoprocessing-2023-08-09_20230811.csv'
	# file_path = config.local_ust_path + organization_id.upper() + '/AL_UST_template_data_only_20230110/' + file_name
	# file_path = config.local_ust_path + organization_id.upper() + file_name
	# file_path = config.local_ust_path + 'Geocoding/' + file_name
	file_path = r'C:\Users\renae\Downloads\\' + file_name
	# file_path = None
	
	main(ust_or_lust, file_path=file_path, organization_id=organization_id)
