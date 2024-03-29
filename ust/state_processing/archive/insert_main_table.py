import sys
import os
sys.path = [os.path.join(os.path.dirname(__file__), "..", "..")] + sys.path
from ust.util.logger_factory import logger
<<<<<<<< HEAD:ust/state_processing/insert_main_table.py
from ust.util import utils, config
from ust.state_processing import make_template_view, export_template, export_needed_geocode
========
from ust.util import utils
import make_template_view, export_template, export_needed_geocode
>>>>>>>> origin/main:ust/state_processing/archive/insert_main_table.py
import psycopg2.errors


def col_list_to_string(col_list, quote_type='"'):
	col_string = ''
	for col in col_list:
		col_string = col_string + quote_type + col + quote_type + ', '
	col_string = col_string[:-2] 	
	return col_string 


def add_table_prefix_to_cols(col_string):
	col_list = col_string.split(', ')
	col_list = ['a.' + c for c in col_list]
	return col_list_to_string(col_list, quote_type="'")


class Inserter:
	location_table = None 
	location_column = None 
	lat_col = None 
	long_col = None 
	geo_table = None
	join_sql = None

	def __init__(self, organization_id, ust_or_lust, state_data_table=None, control_id=None, main_table_only=False, export=True):
		self.organization_id = organization_id
		self.ust_or_lust = ust_or_lust
		if state_data_table:
			self.state_data_table = state_data_table
		else:
			self.state_data_table = 'v_' + ust_or_lust.lower() + '_base'
		if control_id:
			self.control_id = control_id 
		else:
			self.control_id = utils.get_control_id(ust_or_lust, organization_id)
		self.main_table_only = main_table_only
		self.export = export
		self.schema = self.organization_id.upper() + '_' + self.ust_or_lust.upper() 
		self.qualified_state_data_table = '"' + self.schema + '"."' + self.state_data_table + '"'
		self.set_supporting_tables()
		self.conn = utils.connect_db()
		self.cur = self.conn.cursor()
		self.build_join_sql()


	def set_supporting_tables(self):
		self.geo_table = ust_or_lust.lower() + '_geocode'
		if self.ust_or_lust.lower() == 'ust':
			self.location_table = 'ust_facilities'
			self.location_column = 'ust_facilities_id'
			self.lat_col = 'FacilityLatitude'
			self.long_col = 'FacilityLongitude'
		elif self.ust_or_lust.lower() == 'lust':
			self.location_table = 'lust_locations'
			self.location_column = 'lust_location_id'
			self.lat_col = 'Latitude'
			self.long_col = 'Longitude'
		else:
			logger.error('Bad value passed for ust_or_lust: %s; must be UST or LUST', self.ust_or_lust)
			exit()


	def get_col_string(self, table_name):
		state_cols_clause = f""" and column_name in 
			(select column_name from information_schema.columns
			where table_schema = '{self.schema}' and table_name = '{self.state_data_table}') """

		sql = f"""select column_name from information_schema.columns 
				 where table_schema = 'public' and table_name = %s
				 {state_cols_clause}
				 order by ordinal_position"""
		self.cur.execute(sql, (table_name, ))
		cols = [r[0] for r in self.cur.fetchall()]

		return col_list_to_string(cols,'"')


	def build_join_sql(self):
		if self.ust_or_lust.lower() == 'ust':
			join_sql =  f' a join {self.location_table} b on a."FacilityID" = b."FacilityID"'
		else:
			join_sql =  f' a join {self.location_table} b on a."LUSTID" = b."LUSTID"'
		
		sql = """select column_name from information_schema.columns 
				 \nwhere table_schema = %s and table_name = %s 
				 \nand column_name in ('FacilityName', 'FacilityAddress1', 'FacilityAddress2', 'FacilityCity',
				 \n					 'FacilityCounty', 'FacilityZipCode', 'FacilityLatitude', 'FacilityLongitude',
				 \n					 'SiteName', 'SiteAddress', 'SiteAddress2', 'SiteCity', 'Zipcode', 'County', 'State',
				 \n					 'Latitude', 'Longitude') 
				 \norder by ordinal_position"""
		self.cur.execute(sql, (self.schema, self.state_data_table))
		rows = self.cur.fetchall()
		for row in rows:	
			row[0]
			if self.main_table_only and ('Latitude' in row[0] or 'Longitude' in row[0]):
				continue 
			elif  ('Latitude' in row[0] or 'Longitude' in row[0]):
				join_sql = join_sql + f""" \nand coalesce(a."{row[0]}",0) = coalesce(b."{row[0]}",0) """
			else:
				join_sql = join_sql + f""" \nand coalesce(a."{row[0]}",'X') = coalesce(b."{row[0]}",'X') """
		self.join_sql = join_sql


	def delete_old(self, table_name):
		sql = "delete from " + table_name + ' where organization_id = %s and control_id = %s'
		self.cur.execute(sql, (self.organization_id, self.control_id))
		logger.info('Deleted %s existing rows from %s', self.cur.rowcount, table_name)


	def insert_location_table(self):
		col_string = self.get_col_string(self.location_table)
		print(col_string)
		sql = f'insert into {self.location_table} (control_id, organization_id, ' + col_string + ') '
		sql = sql + '\nselect distinct ' + str(self.control_id) + ", '" + self.organization_id + "'," + col_string 
		sql = sql + '\nfrom ' + self.qualified_state_data_table
		self.cur.execute(sql)
		logger.info('Inserted %s rows into table %s', self.cur.rowcount, self.location_table)


	def insert_main_table(self):
		col_string = self.get_col_string(ust_or_lust.lower())
		sql = f'insert into {ust_or_lust.lower()} (control_id, organization_id, ' + self.location_column + ',' + col_string + ')'
		sql = sql + '\nselect ' + str(self.control_id) + ", '" + self.organization_id + "', b." + self.location_column + ', ' 
		sql = sql + add_table_prefix_to_cols(col_string).replace("'","") 
		sql = sql + '\nfrom ' + self.qualified_state_data_table + self.join_sql 
		sql = sql + '\nwhere b.control_id = %s'
		self.cur.execute(sql, (self.control_id,))
		logger.info('Inserted %s rows into table %s', self.cur.rowcount, self.ust_or_lust.lower())


	def insert_geo_table(self):
		sql = f"""insert into {self.geo_table} (control_id, organization_id, {self.location_column}, gc_coordinate_source)
				\nselect distinct %s, %s, {self.location_column}, 'State'
				\nfrom {self.location_table}
				\nwhere "{self.lat_col}" is not null and length(right("{self.lat_col}"::text, length("{self.lat_col}"::text) - position('.' in "{self.lat_col}"::text))) >= 3
				\nand "{self.long_col}" is not null and length(right("{self.long_col}"::text, length("{self.long_col}"::text) - position('.' in "{self.long_col}"::text))) >= 3
				\nand "{self.location_column}" not in (select "{self.location_column}" from {self.geo_table})"""
		self.cur.execute(sql, (self.control_id, self.organization_id))
		logger.info('Inserted %s rows into table %s where state lat/longs are sufficient', self.cur.rowcount, self.geo_table)


	def missing_geo(self):
		sql = f"""select count(*) from {self.location_table}
				  \nwhere control_id = %s and {self.location_column} not in (select {self.location_column} from {self.geo_table})"""
		self.cur.execute(sql, (self.control_id,))
		cnt = self.cur.fetchone()[0]
		logger.info('There are %s rows with insufficient lat/long data.', cnt)
		if cnt > 0:
			logger.info('Exporting to spreadsheet for geoprocessing; send it to Paul')
			export_needed_geocode.main(self.ust_or_lust, self.organization_id, self.control_id)


	def process(self):
		logger.info('Working on %s %s', self.organization_id, self.ust_or_lust.upper())

		make_template_view.update_col_names(self.organization_id, self.ust_or_lust, view_name=self.state_data_table)

		# delete existing data from main data table, if it exists	
		self.delete_old(self.ust_or_lust.lower())	
		if not self.main_table_only:
			# delete from geo table, if exists
			self.delete_old(self.geo_table)
			# delete existing data from UST Facilities/LUST Locations table, if it exists	
			self.delete_old(self.location_table)	

		if not self.main_table_only:
			# build and execute SQL to insert rows into UST Facilities or LUST Locations table
			self.insert_location_table()
		# build and execute SQL to insert rows into main data table
		self.insert_main_table()
		if not self.main_table_only:
			# insert rows with sufficient lat/long data into geocoding table with State as the gc coordinate source
			self.insert_geo_table()
			# determine if state needs additional geocoding and export a CSV file for Paul if so
			self.missing_geo()

		self.conn.commit()
		self.cur.close()
		self.conn.close()

		if self.export:
			export_template.main(self.organization_id, self.ust_or_lust)
		logger.info('Processing for %s %s complete', self.organization_id, self.ust_or_lust.upper())



if __name__ == '__main__':
	organization_id = 'NC'
	ust_or_lust = 'ust'
	state_data_table = 'ust_base'
	main_table_only = False
	export = False
	
	i = Inserter(organization_id, ust_or_lust, state_data_table=state_data_table, main_table_only=main_table_only, export=export)
	i.process()

