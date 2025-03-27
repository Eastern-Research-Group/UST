import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

from python.util.dataset import Dataset 
from python.util import utils
from python.util.logger_factory import logger


ust_or_release = 'ust' 			 # Valid values are 'ust' or 'release' 
control_id = 36                   # Enter an integer that is the ust_control_id
table_name = None                # Optional; enter the table name that contains the missing ID column. If None, the script will identify all tables that require an ID column.
drop_existing = False 		     # Boolean, defaults to False. Set to True to drop the table if it exists before creating it new.
write_sql = True                 # Boolean, defaults to True. If True, writes a SQL script recording the queries it ran to generate the tables.
overwrite_sql_file = False       # Boolean, defaults to False. Set to True to overwrite an existing SQL file if it exists. This parameter has no effect if write_sql = False. 

# These variables can usually be left unset. This script will general a SQL file in the appropriate state folder in the repo under /ust/sql/states
export_file_path = None         
export_file_dir = None
export_file_name = None


child_tables = {'ust_tank': ['ust_tank_substance','ust_compartment','ust_tank_dispenser','ust_piping','ust_compartment_dispenser'],
                'ust_compartment': ['ust_piping','ust_compartment_dispenser']}
id_table_names = {'ust_tank': 'erg_tank_id', 
				  'ust_compartment': 'erg_compartment_id', 
				  'ust_piping': 'erg_piping_id', 
				  'ust_facility_dispenser': 'erg_dispenser_id',
				  'ust_tank_dispenser': 'erg_dispenser_id',
				  'ust_compartment_dispenser': 'erg_dispenser_id',}


class IdColumns:
	conn = None  
	cur = None  
	sql_text = ''
	organization_join_table = None
	organization_join_column = None
	organization_join_column2 = None
	organization_join_column3 = None
	organization_join_fk = None
	organization_join_fk2 = None
	organization_join_fk3 = None
	child_table = None

	def __init__(self, 
				 dataset, 
				 table_name, 
				 drop_existing=False, 
				 write_sql=True, 
				 overwrite_sql_file=False):
		self.dataset = dataset
		self.table_name = table_name 
		self.drop_existing = drop_existing
		self.write_sql = write_sql
		self.overwrite_sql_file = overwrite_sql_file
		self.connect_db()
		self.column_name = self.get_column_name()
		self.compartment_flag = self.get_compartment_flag()
		self.erg_table_name = 'erg_' + self.column_name
		self.drop_existing_table()
		self.create_table()
		self.disconnect_db()
		self.write_self()	


	def connect_db(self):
		self.conn = utils.connect_db()
		self.cur = self.conn.cursor()
		logger.info('Connected to database')


	def disconnect_db(self):
		self.conn.commit()
		self.cur.close()
		self.conn.close()
		logger.info('Disconnected from database')


	def get_column_name(self):
		sql = f"""select column_name from public.{self.dataset.ust_or_release}_required_view_columns 
				  where auto_create = 'Y' and table_name = %s"""
		utils.process_sql(self.conn, self.cur, sql, params=(self.table_name,))
		return self.cur.fetchone()[0]


	def get_compartment_flag(self):
		if self.dataset.ust_or_release == 'release':
			return None 
		sql = "select organization_compartment_flag from public.ust_control where ust_control_id = %s"
		utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id,))
		return self.cur.fetchone()[0]


	def write_self(self):
		if self.overwrite_sql_file:
			wora = 'w'
		else:
			wora = 'a'
		if self.write_sql:
			with open(self.dataset.export_file_path, wora, encoding='utf-8') as f:
				f.write(self.sql_text.replace('\t',''))


	def check_existing(self, schema, table_name):
		sql = f"select count(*) from information_schema.tables where table_schema = %s and table_name = %s"
		utils.process_sql(self.conn, self.cur, sql, params=(schema, table_name))
		return self.cur.fetchone()[0]


	def drop_existing_table(self):
		cnt = self.check_existing(self.dataset.schema, self.erg_table_name)
		if cnt > 0 and self.drop_existing == True:
			sql = f"drop table {self.dataset.schema}.{self.erg_table_name}"
			utils.process_sql(self.conn, self.cur, sql)
		elif cnt > 0 and self.drop_existing == False:
			logger.error('Table %s.%s already exists and drop_existing is set to False', self.dataset.schema, self.erg_table_name)
			sys.exit()


	def get_org_col_name(self, table_name, column_name):
		sql = f"""select organization_table_name, organization_column_name 
				  from public.{self.dataset.ust_or_release}_element_mapping 
				  where {self.dataset.ust_or_release}_control_id = %s 
				  and epa_table_name = %s and epa_column_name = %s"""
		utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id, table_name, column_name))
		return self.cur.fetchone()


	def get_tank_table_name(self):
		sql = f"""select epa_column_name, epa_table_name, b.sort_order 
				from public.ust_element_mapping a join public.ust_element_table_sort_order b 
					on a.epa_table_name = b.table_name
				where ust_control_id = %s and epa_column_name in ('tank_id','tank_name')
				order by epa_column_name desc, b.sort_order """
		utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id,))
		return self.cur.fetchone()[1]


	def get_mapping_existence(self, table_name, column_name=None):
		sql = f"""select count(*) from public.{self.dataset.ust_or_release}_element_mapping 
				  where {self.dataset.ust_or_release}_control_id = %s and epa_table_name = %s """
		if column_name:
			sql = sql + f" and epa_column_name = '{column_name}'"
		utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id, table_name))
		return self.cur.fetchone()[0]


	def record_element_mapping(self, table_name, column_name):
		if table_name != 'ust_compartment' and not self.get_mapping_existence(table_name):
			# Table is an optional child table with no other element mapping so do not map anything to it
			return

		self.sql_text = self.sql_text + '--' + table_name + '.' + column_name + '\n'
		if self.get_mapping_existence(table_name, column_name):
			logger.warning('A mapping already existed for table %s, column %s; it will be deleted and replaced with the ERG-created table', table_name, column_name)
			sql = f"""delete from public.{self.dataset.ust_or_release}_element_mapping
					  where {self.dataset.ust_or_release}_control_id = %s and epa_table_name = %s and epa_column_name = %s"""
			utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id, table_name, column_name))
			logger.info('Deleted mapping info for table %s, column %s from public.%s_element_mapping', table_name, column_name, self.dataset.ust_or_release)
			self.sql_text = self.sql_text + utils.get_pretty_query(self.cur) + '\n\n' 
		
		if table_name == self.table_name:
			org_join_table = self.organization_join_table
			org_join_col = self.organization_join_column
			org_join_fk = self.organization_join_fk
			org_join_col2 = self.organization_join_column2
			org_join_fk2 = self.organization_join_fk2
			org_join_col3 = self.organization_join_column3
			org_join_fk3 = self.organization_join_fk3
		else:
			join_info = self.get_child_join_info(column_name, table_name)
			org_join_table = join_info['organization_join_table']
			org_join_col = join_info['organization_join_column']
			org_join_fk = None 
			org_join_col2 = None 
			org_join_fk2 = None 
			org_join_col3 = None 
			org_join_fk3 = None 
			
		sql = f"""insert into public.{self.dataset.ust_or_release}_element_mapping ({self.dataset.ust_or_release}_control_id, epa_table_name, epa_column_name,
					 organization_table_name, organization_column_name, programmer_comments, organization_join_table,
					 organization_join_column, organization_join_fk, organization_join_column2, organization_join_fk2,
					 organization_join_column3, organization_join_fk3)
				  values (%s, %s, %s, %s, %s, %s,\n%s, %s, %s, %s, %s, %s, %s)"""
		if column_name == self.column_name:
			comment = 'This required field is not present in the source data. Table ' + self.erg_table_name + ' was created by ERG so the data can conform to the EPA template structure.'
		else:
			comment = 'Row inserted automatically to map a required field from a child table.'
		utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id, table_name, column_name, self.erg_table_name, column_name, 
						  comment, org_join_table, org_join_col, org_join_fk, org_join_col2, org_join_fk2, org_join_col3, org_join_fk3))
		logger.info('Inserted mapping from %s.%s to %s.%s', table_name, column_name, self.erg_table_name, column_name)
		self.sql_text = self.sql_text + utils.get_pretty_query(self.cur) + '\n\n' 
		self.conn.commit()


	def element_mapping(self):
		self.sql_text = self.sql_text + '--Record new mapping in public.' + self.dataset.ust_or_release + '_element_mapping\n'
		self.record_element_mapping(self.table_name, self.column_name)

		try:
			for child_table in child_tables[self.table_name]:
				logger.info('Checking for existing mapping for %s', child_table)
				self.record_element_mapping(child_table, self.column_name)
		except KeyError:
			pass 

		if self.table_name in ['ust_compartment','ust_tank_substance', 'ust_tank_dispenser']:
			sql = f"select count(*) from public.{self.dataset.ust_or_release}_element_mapping where epa_table_name = %s and epa_column_name = %s"
			utils.process_sql(self.conn, self.cur, sql, params=(self.table_name, 'tank_id'))
			cnt = self.cur.fetchone()[0]
			if cnt == 0:
				self.record_element_mapping(self.table_name, 'tank_id')

		if self.table_name in ['ust_piping','ust_compartment_dispenser']:
			sql = f"select count(*) from public.{self.dataset.ust_or_release}_element_mapping where epa_table_name = %s and epa_column_name = %s"
			utils.process_sql(self.conn, self.cur, sql, params= (self.table_name, 'compartment_id'))
			cnt = self.cur.fetchone()[0]
			if cnt == 0:
				self.record_element_mapping(self.table_name, 'compartment_id')


	def get_join_table(self, col_name, table_name=None):
		if not table_name:
			table_name = self.table_name
		sql = f"""select distinct organization_table_name from public.{self.dataset.ust_or_release}_element_mapping
		          where {self.dataset.ust_or_release}_control_id = %s and epa_table_name = %s and epa_column_name = %s"""
		utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id, table_name, col_name))     
		utils.pretty_print_query(self.cur)    
		try:
			return self.cur.fetchone()[0]
		except:
			return None 


	def get_join_column(self, col_name, table_name=None):
		if not table_name:
			table_name = self.table_name
		sql = f"""select distinct organization_column_name from public.{self.dataset.ust_or_release}_element_mapping
		          where {self.dataset.ust_or_release}_control_id = %s and epa_table_name = %s and epa_column_name = %s"""
		utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id, table_name, col_name))  
		try:
			return self.cur.fetchone()[0]
		except:
			return None 


	def get_child_join_info(self, col_name, table_name):
		if col_name == 'tank_id':
			epa_col_name = "'tank_id','tank_name'"
		elif col_name == 'compartment_id':
			epa_col_name = "'compartment_id','compartment_name'"
		else:
			epa_col_name = col_name
		sql = f"""select organization_table_name, organization_column_name
				from public.{self.dataset.ust_or_release}_element_mapping 
				where  {self.dataset.ust_or_release}_control_id = %s 
				and epa_table_name = %s and epa_column_name in ({epa_col_name})
				order by epa_column_name desc"""
		utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id, table_name))
		# utils.pretty_print_query(self.cur)
		row = self.cur.fetchone()	
		join_info = {}	
		if not row:
			join_info['organization_join_table'] = None
			join_info['organization_join_column'] = None
		else:
			join_info['organization_join_table'] = row[0]
			join_info['organization_join_column'] = row[1] 
		return join_info


	def create_table(self):
		logger.info('Working on %s.%s', self.table_name, self.column_name)
		self.sql_text = self.sql_text + '------------------------------------------------------------------------------------------------------------------------------------------------\n'
		self.sql_text = self.sql_text + '------------------------------------------------------------------------------------------------------------------------------------------------\n'
		self.sql_text = self.sql_text + '------------------------------------------------------------------------------------------------------------------------------------------------\n'
		self.sql_text = self.sql_text + '--Create table ' + self.dataset.schema + '.' + self.erg_table_name + '\n'

		if self.table_name == 'ust_tank' or self.table_name == 'ust_facility_dispenser':
			if self.table_name == 'ust_tank':
				sql = f"create table {self.dataset.schema}.{self.erg_table_name} (facility_id varchar(50), tank_name varchar(50), tank_id int generated always as identity)"
			else:
				sql = f"create table {self.dataset.schema}.{self.erg_table_name} (facility_id varchar(50), tank_name varchar(50), dispenser_id int generated always as identity)"
			utils.process_sql(self.conn, self.cur, sql)
			logger.info('Created table %s.%s', self.dataset.schema, self.erg_table_name)
			self.sql_text = self.sql_text + utils.get_pretty_query(self.cur) + '\n\n' 

			sql = f"insert into {self.dataset.schema}.{self.erg_table_name} (facility_id, tank_name)\nselect distinct "
			select_cols = ''
			facility_id_info = self.get_org_col_name(self.table_name, 'facility_id')
			tank_name_info = self.get_org_col_name(self.table_name, 'tank_name')
			if facility_id_info:
				facility_id_table = '"' + facility_id_info[0] + '"'
				facility_id_col = '"' + facility_id_info[1] + '"'					
				select_cols = facility_id_col + "::varchar(50)"
			else:
				logger.error('Enter a row in public.ust_element_mapping for epa_table_name = "%s" and epa_column_name = "facility_id", then re-run this script', self.table_name)
				sys.exit()
			if tank_name_info:
				tank_name_table = '"' + tank_name_info[0] + '"'
				tank_name_col = '"' + tank_name_info[1] + '"'
				select_cols = select_cols + ", " + tank_name_col + "::varchar(50)"
			else: 
				select_cols = select_cols + ", null"
			sql = sql + select_cols + '\nfrom ' + self.dataset.schema + '.' + facility_id_table
			utils.process_sql(self.conn, self.cur, sql)
			logger.info('Inserted %s rows into %s.%s', self.cur.rowcount, self.dataset.schema, self.erg_table_name)
			self.sql_text = self.sql_text + '--Populate table ' + self.dataset.schema + '.' + self.erg_table_name + '\n'
			self.sql_text = self.sql_text + utils.get_pretty_query(self.cur) + '\n\n' 

			self.organization_join_table = self.get_join_table('facility_id')
			self.organization_join_column = self.get_join_column('facility_id')
			if self.table_name == 'ust_tank':
				self.organization_join_column2 = self.get_join_column('tank_name')
			else:
				self.organization_join_column2 = None
			self.organization_join_column3 = None
			self.organization_join_fk = 'facility_id'
			if self.table_name == 'ust_tank' and tank_name_info:
				self.organization_join_fk2 = 'tank_name'
			else:
				self.organization_join_fk2 = None
			self.organization_join_fk3 = None
			
			self.element_mapping()

		elif self.table_name == 'ust_compartment' or self.table_name == 'ust_tank_dispenser':
			if self.table_name == 'ust_compartment':
				sql = f"create table {self.dataset.schema}.{self.erg_table_name} (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int generated always as identity)"
			else:
				sql = f"create table {self.dataset.schema}.{self.erg_table_name} (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), dispenser_id int generated always as identity)"
			utils.process_sql(self.conn, self.cur, sql)
			logger.info('Created table %s.%s', self.dataset.schema, self.erg_table_name)
			self.sql_text = self.sql_text + utils.get_pretty_query(self.cur) + '\n\n' 

			compartment_table_name = self.table_name
			if self.compartment_flag == 'N':
				compartment_table_name = self.get_tank_table_name()

			v_sql = f"insert into {self.dataset.schema}.{self.erg_table_name} (facility_id, tank_name, tank_id, compartment_name)\nselect distinct "
			select_cols = ''

			sql = f"""select count(*) from public.ust_element_mapping 
					  where ust_control_id = %s and organization_table_name = 'erg_tank_id'"""
			utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id,))
			cnt = self.cur.fetchone()[0]
			if cnt > 0: # We already created erg_tank_id; use it for the select columns instead of the source table
				# next, figure out if compartment_name is in source_data
				compartment_name_info = self.get_org_col_name('ust_compartment', 'compartment_name')

				if compartment_name_info: # get the organization column names to build the join
					facility_id_info = self.get_org_col_name('ust_compartment', 'facility_id')
					tank_id_info = self.get_org_col_name('ust_compartment', 'tank_id')

					# print('facility_id_info = ' + str(facility_id_info))
					# print('tank_id_info = ' + str(tank_id_info))

					v_sql = v_sql + 'a.facility_id, a.tank_name, a.tank_id, b.compartment_name\nfrom ' 
					v_sql = v_sql + self.dataset.schema + '.erg_tank_id a left join ' + self.dataset.schema + '.' + compartment_name_info[0] + ' b '
					v_sql = v_sql + ' on a.facility_id = b."' + facility_id_info[1] + '" and a.tank_id = b."' + tank_id_info[1] + '"'
				else: # just enter null for compartment name because it's not in the source data 
					v_sql = v_sql + 'facility_id, tank_name, tank_id, null\nfrom ' + self.dataset.schema + '.erg_tank_id'

				# build the join columns assuming we had to create erg_tank_id because no Tank ID in source data
				self.organization_join_table = 'erg_tank_id'
				self.organization_join_column = 'facility_id'
				self.organization_join_column2 = 'tank_id'
				self.organization_join_column3 = self.get_join_column('compartment_name')
				self.organization_join_fk = 'facility_id'
				self.organization_join_fk2 = 'tank_id'
				if self.table_name == 'ust_compartment' and compartment_name_info:
					self.organization_join_fk3 = 'compartment_name'
				else:
					self.organization_join_fk3 = None

			else: # Source data had Tank ID; get the select columns from the source table
				facility_id_info = self.get_org_col_name(compartment_table_name, 'facility_id')
				tank_name_info = self.get_org_col_name(compartment_table_name, 'tank_name')
				tank_id_info = self.get_org_col_name(compartment_table_name, 'tank_id')
				compartment_name_info = self.get_org_col_name(compartment_table_name, 'compartment_name')

				if facility_id_info:
					facility_id_table = '"' + facility_id_info[0] + '"'
					facility_id_col = '"' + facility_id_info[1] + '"'					
					select_cols = facility_id_col + "::varchar(50)"
				else:
					logger.error('Enter a row in public.ust_element_mapping for epa_table_name = "%s" and epa_column_name = "facility_id", then re-run this script', self.table_name)
					sys.exit()
				if tank_name_info:
					tank_name_table = '"' + tank_name_info[0] + '"'
					tank_name_col = '"' + tank_name_info[1] + '"'
					select_cols = select_cols + ", " + tank_name_col + "::varchar(50)"
				else: 
					select_cols = select_cols + ", null"
				if tank_id_info:
					tank_id_table = '"' + tank_id_info[0] + '"'
					tank_id_col = '"' + tank_id_info[1] + '"'
					select_cols = select_cols + ", " + tank_id_col + "::int"
				else: 
					select_cols = select_cols + ", null"
				if compartment_name_info:
					compartment_name_table = '"' + compartment_name_info[0] + '"'
					compartment_name_col = '"' + compartment_name_info[1] + '"'
					select_cols = select_cols + ", " + compartment_name_col + "::varchar(50)"
				else: 
					select_cols = select_cols + ", null"
				v_sql = v_sql + select_cols + ' from ' + self.dataset.schema + '.' + tank_id_table

				# State supplied Tank IDs, but not compartments, so get join info
				# TODO: not sure if this will work!!
				self.organization_join_table = self.get_join_table('tank_id')
				self.organization_join_column = self.get_join_column('facility_id')
				self.organization_join_column2 = self.get_join_column('tank_id')
				if self.table_name == 'ust_compartment':
					self.organization_join_column3 = self.get_join_column('compartment_name')
				else:
					self.organization_join_column3 = None
				self.organization_join_fk = 'facility_id'
				self.organization_join_fk2 = 'tank_id'
				if self.table_name == 'ust_compartment' and compartment_name_info:
					self.organization_join_fk3 = 'compartment_name'

			# print(v_sql)
			utils.process_sql(self.conn, self.cur, v_sql)
			logger.info('Inserted %s rows into %s.%s', self.cur.rowcount, self.dataset.schema, self.erg_table_name)
			self.sql_text = self.sql_text + '--Populate table ' + self.dataset.schema + '.' + self.erg_table_name + '\n\n'
			self.sql_text = self.sql_text + utils.get_pretty_query(self.cur) + '\n\n' 

			self.element_mapping()

		elif self.table_name == 'ust_piping' or self.table_name == 'ust_compartment_dispenser':
			if self.table_name == 'ust_piping':
				sql = f"create table {self.dataset.schema}.{self.erg_table_name} (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int, piping_id int generated always as identity)"
			else: 
				sql = f"create table {self.dataset.schema}.{self.erg_table_name} (facility_id varchar(50), tank_name varchar(50), tank_id int, compartment_name varchar(50), compartment_id int, dispenser_id int generated always as identity)"
			utils.process_sql(self.conn, self.cur, sql)
			logger.info('Created table %s.%s)', self.dataset.schema, self.erg_table_name)
			self.sql_text = self.sql_text + utils.get_pretty_query(self.cur) + '\n\n' 

			compartment_table_name = self.table_name
			if self.compartment_flag == 'N':
				compartment_table_name = self.get_tank_table_name()

			v_sql = f"insert into {self.dataset.schema}.{self.erg_table_name} (facility_id, tank_name, tank_id, compartment_name, compartment_id)\nselect distinct "
			select_cols = ''

			sql = f"""select count(*) from public.ust_element_mapping 
					  where ust_control_id = %s and organization_table_name = 'erg_compartment_id'"""
			utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id,))
			cnt = self.cur.fetchone()[0]

			if cnt > 0: # We already created erg_compartment_id; use it for the select columns instead of the source table
				# next, figure out if compartment_name is in source_data
				compartment_name_info = self.get_org_col_name('ust_compartment', 'compartment_name')
				if compartment_name_info: # get the organization column names to build the join
					facility_id_info = self.get_org_col_name('ust_compartment', 'facility_id')
					tank_id_info = self.get_org_col_name('ust_compartment', 'tank_id')
					compartment_id_info = self.get_org_col_name('ust_compartment', 'compartment_id')
					v_sql = v_sql + 'a.facility_id, a.tank_name, a.tank_id, b.compartment_name, b.compartment_id from ' 
					v_sql = v_sql + self.dataset.schema + '.erg_tank_id a left join ' + self.dataset.schema + '.' + compartment_name_info[0] + ' b '
					v_sql = v_sql + ' on a.facility_id = b."' + facility_id_info[1] + '" and a.tank_id = b."' + tank_id_info[1] + '"'
					v_sql = v_sql + ' and a.compartment_id = b."' + compartment_id_info[1] + '"'
				else: # just enter null for compartment name because it's not in the source data 
					v_sql = v_sql + 'facility_id, tank_name, tank_id, null, compartment_id from ' + self.dataset.schema + '.erg_compartment_id'

				# build the join columns assuming we had to create erg_tank_id because no Tank ID in source data
				self.organization_join_table = 'erg_compartment_id'
				self.organization_join_column = 'facility_id'
				self.organization_join_column2 = 'tank_id'
				self.organization_join_column3 = 'compartment_id'
				self.organization_join_fk = 'facility_id'
				self.organization_join_fk2 = 'tank_id'
				self.organization_join_fk3 = 'compartment_id'

			else: # Source data had Compartment ID; get the select columns from the source table
				facility_id_info = self.get_org_col_name(compartment_table_name, 'facility_id')
				tank_name_info = self.get_org_col_name(compartment_table_name, 'tank_name')
				tank_id_info = self.get_org_col_name(compartment_table_name, 'tank_id')
				compartment_name_info = self.get_org_col_name(compartment_table_name, 'compartment_name')
				compartment_id_info = self.get_org_col_name(compartment_table_name, 'compartment_id')

				if not compartment_name_info and not compartment_id_info:
					logger.error('Enter a row in public.ust_element_mapping for epa_table_name = "%s", and epa_column_name = "compartment_id" and/or epa_column_name = "compartment_name", then re-run this script', self.table_name)
					sys.exit()
			
				if facility_id_info:
					facility_id_table = '"' + facility_id_info[0] + '"'
					facility_id_col = '"' + facility_id_info[1] + '"'					
					select_cols = facility_id_col + "::varchar(50)"
				else:
					logger.error('Enter a row in public.ust_element_mapping for epa_table_name = "%s" and epa_column_name = "facility_id", then re-run this script', self.table_name)
					sys.exit()
				if tank_name_info:
					tank_name_table = '"' + tank_name_info[0] + '"'
					tank_name_col = '"' + tank_name_info[1] + '"'
					select_cols = select_cols + ", " + tank_name_col + "::varchar(50)"
				else: 
					select_cols = select_cols + ", null"
				if tank_id_info:
					tank_id_table = '"' + tank_id_info[0] + '"'
					tank_id_col = '"' + tank_id_info[1] + '"'
					select_cols = select_cols + ", " + tank_id_col + "::int"
				else: 
					select_cols = select_cols + ", null"
				if compartment_name_info:
					compartment_table = '"' + compartment_name_info[0] + '"'
					compartment_name_col = '"' + compartment_name_info[1] + '"'
					select_cols = select_cols + ", " + compartment_name_col + "::varchar(50)"
				else: 
					select_cols = select_cols + ", null"
				if compartment_id_info:
					compartment_table = '"' + compartment_id_info[0] + '"'
					compartment_id_col = '"' + compartment_id_info[1] + '"'
					select_cols = select_cols + ", " + compartment_id_col + "::int"
				else: 
					select_cols = select_cols + ", null"
				v_sql = v_sql + select_cols + ' from ' + self.dataset.schema + '.' + compartment_table
			utils.process_sql(self.conn, self.cur, v_sql)
			logger.info('Inserted %s rows into %s.%s', self.cur.rowcount, self.dataset.schema, self.erg_table_name)
			self.sql_text = self.sql_text + '--Populate table ' + self.dataset.schema + '.' + self.erg_table_name + '\n\n'
			self.sql_text = self.sql_text + utils.get_pretty_query(self.cur) + '\n\n' 

			self.element_mapping()



def get_tables_with_missing_cols(dataset):
	conn = utils.connect_db()
	cur = conn.cursor()
	sql = f"""select distinct a.table_name, sort_order
			from public.{dataset.ust_or_release}_required_view_columns a join public.{dataset.ust_or_release}_template_data_tables b on a.table_name = b.table_name  
			where auto_create = 'Y' and not exists 
				(select 1 from public.{dataset.ust_or_release}_element_mapping c
				where {dataset.ust_or_release}_control_id = %s and a.table_name = c.epa_table_name and a.column_name = c.epa_column_name)
			and (a.table_name = 'ust_compartment' or exists 
				(select 1 from public.{dataset.ust_or_release}_element_mapping c
				where {dataset.ust_or_release}_control_id = %s and a.table_name = c.epa_table_name))
			order by sort_order"""
	utils.process_sql(conn, cur, sql, params=(dataset.control_id, dataset.control_id))
	rows = cur.fetchall()
	cur.close()
	conn.close()
	return [r[0] for r in rows]


def drop_table(dataset, table_name, cursor=None):
	import psycopg2

	if cursor:
		cur = cursor
	else:
		conn = utils.connect_db()
		cur = conn.cursor()

	sql = f"""delete from public.{dataset.ust_or_release}_element_mapping
	           where organization_table_name = %s"""
	utils.process_sql(conn, cur, sql, params=(table_name,))
	logger.info('Deleted %s rows from %s.%s_element_mapping where organization_table_name = %s', cur.rowcount, dataset.schema, dataset.ust_or_release, table_name)
	conn.commit()

	sql = f"drop table {dataset.schema}.{table_name}"
	try:
		cur.execute(sql)
	except psycopg2.errors.UndefinedTable:
		pass
	logger.info('Dropped table %s.%s', dataset.schema, table_name)

	if not cursor:
		cur.close()
		conn.close()


def drop_tables(dataset, table_name=None):
	if table_name:
		erg_table_name = id_table_names[table_name]
		drop_table(dataset, erg_table_name)
		return 
	logger.info('Dropping existing ID generation tables')
	conn = utils.connect_db()
	cur = conn.cursor()
	sql = """select table_name from information_schema.tables 
			where table_schema = %s and table_name like 'erg%%id'
			order by 1"""
	utils.process_sql(conn, cur, sql, params=(dataset.schema,))
	rows = cur.fetchall()
	for row in rows:
		drop_table(dataset, row[0])
	cur.close()
	conn.close()
	logger.info('All existing ID generation tables dropped')



def main(ust_or_release, control_id, table_name=None):
	dataset = Dataset(ust_or_release=ust_or_release,
					  control_id=control_id,
					  base_file_name='id_column_generation.sql',
					  export_file_name=export_file_name,
					  export_file_dir=export_file_dir,
					  export_file_path=export_file_path)

	if drop_existing:
		drop_tables(dataset, table_name)

	if table_name:
		columns = IdColumns(dataset=dataset, 
							table_name=table_name, 
							drop_existing=drop_existing,
							write_sql=write_sql,
							overwrite_sql_file=overwrite_sql_file)		
	else:
		tables_needed = get_tables_with_missing_cols(dataset)
		for table in tables_needed: 
			logger.info('-------------------------------------------------------------------------\nWorking on table %s', table)
			columns = IdColumns(dataset=dataset, 
								table_name=table, 
								drop_existing=drop_existing,
								write_sql=write_sql,
								overwrite_sql_file=overwrite_sql_file)


if __name__ == '__main__':   
	main(ust_or_release=ust_or_release,
		 control_id=control_id,
		 table_name=table_name)

