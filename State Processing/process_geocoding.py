from logger_factory import logger
import config
import utils
import export_template

import pandas.io.sql as sqlio
import pandas as pd
from psycopg2.errors import DuplicateSchema, UndefinedTable


def upload_geocoded_data(ust_or_lust, file_path, state=None):
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
	
	if state:
		schema = utils.get_schema_name(state, ust_or_lust)
		table_name = state.lower() + '_' + ust_or_lust.lower() + '_geocoded'
	else:
		schema = 'public'
		table_name = ust_or_lust.lower() + '_geocoded_temp'

	engine = utils.get_engine(schema=schema)    
	df.to_sql(table_name, engine, index=False, if_exists='replace')
	logger.info('Created table %s.%s', schema, table_name)

	cur.close()
	conn.close()

	return schema + '.' + table_name


def get_table_name(ust_or_lust, state=None):
	conn = utils.connect_db()
	cur = conn.cursor()		
	
	if state: 
		schema = utils.get_schema_name(state, ust_or_lust)
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


def update_geo_table(ust_or_lust, state=None, table_name=None):
	if not table_name:
		 table_name = get_table_name(ust_or_lust, state)

	conn = utils.connect_db()
	cur = conn.cursor()			

	if ust_or_lust.lower == 'ust':
		sql = f"""update ust_geocode c set (gc_latitude, gc_longitude, gc_coordinate_source, gc_address_type) =
					(select distinct a.gc_latitude, a.gc_longitude, a.gc_coordinate_source, a.gc_address_type
					from {table_name} a join v_ust_control b on a.orgid = b.state
					where  b.control_id = c.control_id and a.facid = c."FacilityID")
				where exists 
					(select 1 from {table_name} a join v_ust_control b on a.orgid = b.state
					where  b.control_id = c.control_id and a.facid = c."FacilityID")"""
	else:
		sql = f"""update lust_geocode c set (gc_latitude, gc_longitude, gc_coordinate_source, gc_address_type) =
					(select distinct a.gc_latitude, a.gc_longitude, a.gc_coordinate_source, a.gc_address_type
					from {table_name} a join v_lust_control b on a.orgid = b.state
					where  b.control_id = c.control_id and a.lustid = c."LUSTID")
				where exists 
					(select 1 from {table_name} a join v_lust_control b on a.orgid = b.state
					where  b.control_id = c.control_id and a.lustid = c."LUSTID")"""		
	cur.execute(sql)
	logger.info('Updated %s rows in %s', cur.rowcount, table_name)

	if ust_or_lust.lower == 'ust':
		sql = f"""insert into ust_geocode (control_id, state, "FacilityID", gc_latitude, gc_longitude, gc_coordinate_source, gc_address_type)
				select distinct b.control_id, b.state, a.facid, a.gc_latitude, a.gc_longitude, a.gc_coordinate_source, a.gc_address_type
				from {table_name} a join v_ust_control b on a.orgid = b.state
				where not exists (select 1 from ust_geocode c where b.control_id = c.control_id and a.facid = c."FacilityID")"""
	else:
		sql = f"""insert into lust_geocode (control_id, state, "LUSTID", gc_latitude, gc_longitude, gc_coordinate_source, gc_address_type)
				select distinct b.control_id, b.state, a.facid, a.gc_latitude, a.gc_longitude, a.gc_coordinate_source, a.gc_address_type
				from {table_name} a join v_ust_control b on a.orgid = b.state
				where not exists (select 1 from ust_geocode c where b.control_id = c.control_id and a.lustid = c."LUSTID")"""		
	cur.execute(sql)
	logger.info('Inserted %s rows into %s', cur.rowcount, table_name)

	cur.close()
	conn.close()



def main(ust_or_lust, file_path=None, state=None):
	logger.info('Starting process...')
	if file_path:
		table_name = upload_geocoded_data(ust_or_lust, file_path, state)
	else:
		table_name = None

	update_geo_table(ust_or_lust, state=None, table_name=None):


	logger.info('Script complete')


if __name__ == '__main__':   
	state = None
	ust_or_lust = 'ust'

	# Set file_path to None if file is already uploaded
	file_name = 'need_geocoding_20230611.csv'
	# file_path = config.local_ust_path + state.upper() + '/AL_UST_template_data_only_20230110/' + file_name
	file_path = config.local_ust_path + 'need_geocoding_20230611/' + file_name
	
	main(ust_or_lust, file_path=file_path, state=state)
