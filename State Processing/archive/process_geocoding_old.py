from logger_factory import logger
import config
import utils
import export_template

import pandas.io.sql as sqlio
import pandas as pd
from psycopg2.errors import DuplicateSchema, UndefinedTable


def upload_geocoded_data(state, ust_or_lust, file_path):
	conn = utils.connect_db()
	cur = conn.cursor()		

	try:
		df = pd.read_excel(file_path)   
	except ValueError as e:
		logger.error('Error opening %s; aborting: %s', file_path, e) 
		exit()
	
	schema = utils.get_schema_name(state, ust_or_lust)
	table_name = state.lower() + '_' + ust_or_lust.lower() + '_geocoded'
	engine = utils.get_engine(schema=schema)    
	df.to_sql(table_name, engine, index=False, if_exists='replace')
	logger.info('Created table %s.%s', schema, table_name)

	cur.close()
	conn.close()


def get_col_position(ust_or_lust):
	conn = utils.connect_db()
	cur = conn.cursor()	

	column_name = 'FacilityLongitude'
	if ust_or_lust.lower() == 'lust':
		column_name = 'Longitude'

	sql = """select ordinal_position 
			 from information_schema.columns 
			 where table_schema = 'public' and table_name = %s
			 and column_name = %s """
	cur.execute(sql, (ust_or_lust.lower(), column_name))
	col_pos = cur.fetchone()[0]

	cur.close()
	conn.close()

	return col_pos


def create_view(state, ust_or_lust):
	schema = utils.get_schema_name(state, ust_or_lust)
	new_view_name = '"' + schema + '".v_' + ust_or_lust.lower() + '_geocode'

	col_pos = get_col_position(ust_or_lust)

	conn = utils.connect_db()
	cur = conn.cursor()

	columns = []
	sql = """select case when table_name = 'ust' and column_name = 'FacilityLatitude' then 'case when gc_latitude is not null then gc_latitude else "FacilityLatitude" end as "FacilityLatitude"' 
						 when table_name = 'ust' and column_name = 'FacilityLongitude' then 'case when gc_longitude is not null then gc_longitude else "FacilityLongitude" end as "FacilityLongitude"' 
						 when table_name = 'lust' and column_name = 'Latitude' then 'case when gc_latitude is not null then gc_latitude else "Latitude" end as "Latitude"' 
						 when table_name = 'lust' and column_name = 'Longitude' then 'case when gc_longitude is not null then gc_longitude else "Longitude" end as "Longitude"' 
					else '"' || column_name || '"' end as column_name, ordinal_position - 3 as ordinal_position
			from information_schema.columns 
			where table_schema = 'public' and table_name = %s
			and column_name not in ('id','control_id','state')
			and ordinal_position <= %s
			order by ordinal_position"""
	cur.execute(sql, (ust_or_lust, col_pos))
	rows = cur.fetchall()
	columns = [x[0] for x in rows]

	columns.append('gc_coordinate_source')
	columns.append('gc_address_type')

	sql = """select '"' || column_name || '"' as column_name, ordinal_position 
			from information_schema.columns 
			where table_schema = 'public' and table_name = %s
			and column_name not like 'gc_%%'
			and ordinal_position > %s
			order by ordinal_position"""

	cur.execute(sql, (ust_or_lust, col_pos))
	rows = cur.fetchall()
	for row in rows:
		columns.append(row[0])

	view_sql = 'create view ' + new_view_name + ' as \nselect distinct '
	for col_name in columns:
		view_sql = view_sql + col_name + ',\n'
	view_sql = view_sql[:-2] + '\n'
	from_sql = ' from public.' + ust_or_lust.lower() + " where state = '" + state.upper() + "' and control_id = "
	from_sql = from_sql + '(select max(control_id) from public.' + ust_or_lust.lower() + "_control where state = '" + state.upper() + "')"
	view_sql = view_sql + from_sql

	try:
		cur.execute('drop view ' + new_view_name)
		logger.info('Dropped %s', new_view_name)
	except UndefinedTable:
		pass

	cur.execute(view_sql)
	logger.info('Created %s', new_view_name)

	cur.close()
	conn.close()


def update_data(state, ust_or_lust, geo_table=None):
	schema = utils.get_schema_name(state, ust_or_lust)

	conn = utils.connect_db()
	cur = conn.cursor()


	if not geo_table:
		sql = """select table_name from information_schema.tables 
				 where table_schema = %s and table_type = 'BASE TABLE'
				 and lower(table_name) like '%%geocod%%'"""
		cur.execute(sql, (schema,))
		geo_table = cur.fetchone()[0]

	sql = f"""update public.{ust_or_lust.lower()} x
			set gc_latitude = y.gc_latitude::float, 
			gc_longitude = y.gc_longitude::float, 
			gc_coordinate_source = y.gc_coordinate_source, 
			gc_address_type = y.gc_address_type
		from "{schema}".{geo_table} y \n"""

	if ust_or_lust.lower() == 'ust':
		sql = sql + """ where x."FacilityID" = y."FacilityID" and x."TankID" = y."TankID"::text and coalesce(x."CompartmentID",'X') = coalesce(y."CompartmentID"::text,'X') \n"""
	else:
		sql = sql + ' where x."FacilityID" = y."FacilityID" and x."LUSTID" = y."LUSTID"  \n'

	sql = sql + f" and x.state = %s and x.control_id = (select max(control_id) from public.{ust_or_lust.lower()}_control where state = %s)"
	# logger.debug(sql)

	cur.execute(sql, (state, state))
	logger.info('Updated %s rows in public.%s for state %s', cur.rowcount, ust_or_lust.lower(), state)

	cur.close()
	conn.close()


def export(state, ust_or_lust):
	schema = utils.get_schema_name(state, ust_or_lust)

	conn = utils.connect_db()
	cur = conn.cursor()

	sql = f'select * from "{schema}".v_{ust_or_lust.lower()}_geocode'
	if ust_or_lust.lower() == 'ust':
		sql = sql + ' order by "FacilityID", "TankID", "CompartmentID"'
	else:
		sql = sql + ' order by "FacilityID", "LUSTID"'

	cur.execute(sql)
	num_rows = cur.rowcount	

	cur.close()
	conn.close()

	df = sqlio.read_sql_query(sql, utils.get_engine())
	file_path = config.local_ust_path + state.upper() + '/' 
	file_name = state.upper() + '_' + ust_or_lust.upper() + '_geocoded.xlsx'
	sheet_name = state.upper() + '_' + ust_or_lust.upper()
	try:
		df.to_excel(file_path + file_name, sheet_name=sheet_name, index=False, freeze_panes=(1,0))
	except ValueError:
		with pd.ExcelWriter(file_path) as writer:  
			df.to_excel(file_path + file_name, sheet_name=sheet_name, index=False, freeze_panes=(1,0))
		# logger.warning('Unable to write to Excel spreadsheet %s, writing to CSV instead', file_path + file_name)
		# file_name = file_name.replace('xlsx','csv')
		# df.to_csv(file_path + file_name, index=False)
	logger.info('Exported %s rows to file %s', num_rows, file_path + file_name)


def main(state, ust_or_lust, file_path=None, geo_table=None):
	logger.info('Starting process...')
	if file_path:
		upload_geocoded_data(state, ust_or_lust, file_path)
	update_data(state, ust_or_lust, geo_table)
	create_view(state, ust_or_lust)
	export(state, ust_or_lust)
	export_template.main(state, ust_or_lust)
	logger.info('Script complete')


if __name__ == '__main__':   
	state = 'AL'
	ust_or_lust = 'ust'
	geo_table = None # If there are multiple tables in the schema like '%geocod%', specify correct one here

	# Set file_path to None if file is already uploaded
	file_name = 'AL_UST_template_data_only_20230110.xlsx'
	# file_path = config.local_ust_path + state.upper() + '/AL_UST_template_data_only_20230110/' + file_name
	file_path = None
	
	main(state, ust_or_lust, file_path=file_path, geo_table=geo_table)
