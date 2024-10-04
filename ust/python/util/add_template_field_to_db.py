from datetime import date
import ntpath
import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import psycopg2.errors

from python.util import utils
from python.util.logger_factory import logger

"""
 MANUAL INSTRUCTIONS BELOW!!!!

"""

# Variables that will need to be set every time 
new_column_name = ''	                	# database column name (lowercase/underscores; no spaces or capital letters)
table_name = '' 		    		        # database table name 
data_type = ''      					    # options are varchar, int, float, date, etc. 
max_char_size = None						# If data_type == varchar, must be an integer. Otherwise set to None (will be ignored if data_type != varchar)
element_description = ''					# Element definition for the related EPA template that contains the new column 
sql_only = False                            # If True, will write SQL statements to file but will not change anything in the database. If False, will perform db changes. 

# Variables that are less likely to need to be changed 
sql_export_path = '../../sql/misc/'			# Directory where SQL file will be written. 
column_sort_order = None                    # Sort order the new element should appear in the template tab associated with the table the column has been added to. If None, will sort to last. 
schema = 'public'							# Schema the table and column above are located in. Will almost always be 'public'.
template_element_name = None   				# If None, will default to a camelcase version of the new_column_name variable with no spaces
displayed_in_ustfinder = 'N'                # Y/N column of EPA template for whether the element is to be displayed in the UST Finder app. Defaults to N for No. 
required = 'N'								# Required column of EPA template. Defaults to 'N' since it's very unlikely we'll add a required field. 
allowed_values = None 						# Populates the Allowed Values column of the EPA template (Y/N field where only Y is populated and null is assumed N). 
lookup_table = None 						# Populates the Lookup Table column of the EPA template (template tab name containing list of allowed values). 
business_rule = None 						# Populates the Business Rule column of the EPA template (This is a small list of values that is not large enough to put in a lookup table. If used, you must manually add a check constraint on new column making sure it adheres to this business rule.)
notes = None 								# Populates the Notes column of the EPA template (generally used to explain conditionally required fields, etc.)
database_lookup_table = None 				# Name of the lookup table in the database. If lookup_table is populated, this should be too. You should create the database table first. 
database_lookup_column = None 				# Column name of the database_lookup_table that contains the value descriptions.
generic_template = 'Y'                      # If 'Y', the new column will be included when a blank (non-populated) EPA template is created using the export_template.py script. 


""" 
To add a new field to the UST Finder tables manually in the database: 

1) Add column to appropriate data table (e.g ust_facility).
2) Insert a row into public.ust_elements or public.release_elements. 
3) Insert a row into public.ust_elements_tables or public.release_elements_tables, including the sort_order for the column. 
4) Update the related data table population view (e.g. v_ust_facility for columns added to table ust_facility)

"""

class NewColumn:
	ust_or_release = None 
	export_file_path = None 
	conn = None  
	cur = None 
	sql = '----------------------------------------------------------------------------------------------------------\n\n' 
	element_type = None 
	element_id = None 
	element_table_id = None 
	view_name = None 

	def __init__(self, 
				 new_column_name,
				 table_name,
				 data_type,
				 max_char_size=None,
				 element_description=None,
				 sql_only=False,
				 sql_export_path='../../sql/misc/',
				 column_sort_order=None,
				 schema='public',
				 template_element_name=None,
				 displayed_in_ustfinder='N',
				 required='N',
				 allowed_values=None,
				 lookup_table=None,
				 business_rule=None,
				 notes=None,
				 database_lookup_table=None,
				 database_lookup_column=None,
				 generic_template='Y'):
		self.new_column_name = new_column_name
		self.table_name = table_name	
		self.data_type = data_type	
		self.max_char_size = max_char_size
		self.element_description = element_description
		self.sql_only = sql_only
		self.sql_export_path = sql_export_path
		self.column_sort_order = column_sort_order
		self.schema = schema
		self.template_element_name = template_element_name
		self.displayed_in_ustfinder = displayed_in_ustfinder
		self.required = required
		self.allowed_values = allowed_values
		self.lookup_table = lookup_table
		self.business_rule = business_rule
		self.notes = notes
		self.database_lookup_table = database_lookup_table
		self.database_lookup_column = database_lookup_column
		self.generic_template = generic_template
		self.set_db_connection()
		self.check_existing()
		self.set_export_path()
		self.set_ust_or_release()
		self.add_column()
		self.insert_element_info()
		self.insert_element_table_info()
		self.update_view()
		self.disconnect_db()
		self.write_sql()


	def set_db_connection(self):
		self.conn = utils.connect_db()
		self.cur = self.conn.cursor()


	def disconnect_db(self):
		self.conn.commit()
		self.cur.close()
		self.conn.close()


	def check_existing(self):
		sql = "select count(*) from information_schema.columns where table_schema = %s and table_name = %s and table_schema = %s"
		self.cur.execute(sql, (self.schema, self.table_name, self.new_column_name))
		cnt = self.cur.fetchone()[0]
		if cnt > 0:
			logger.error('Column %s already exists on table %s.%s; exiting.', self.new_column_name, self.schema, self.table_name)
			self.disconnect_db()
			exit()


	def set_export_path(self):
		Path(self.sql_export_path).mkdir(parents=True, exist_ok=True)
		file_name = 'add_db_column_' + self.new_column_name + '_' + utils.get_timestamp_str() + '.sql'
		self.export_file_path = self.sql_export_path + '/' + file_name 	
		logger.info('Export path for SQL file is %s', self.export_file_path)	


	def set_ust_or_release(self):
		sql = "select count(*) from public.ust_template_data_tables where table_name = %s"
		self.cur.execute(sql, (self.table_name,))
		cnt = self.cur.fetchone()[0]
		if cnt > 0:
			self.ust_or_release = 'ust'
		else:
			sql = "select count(*) from public.release_template_data_tables where table_name = %s"
			self.cur.execute(sql, (self.table_name,))
			cnt = self.cur.fetchone()[0]
			if cnt > 0:
				self.ust_or_release = 'release'
			else:
				logger.error('Unable to determine if table %s.%s is an UST or Release table. Check table_name and try again', self.schema, self.table_name)
				self.disconnect_db()
				exit()


	def add_column(self):
		if self.data_type in ['varchar','character varying','text']:
			if not self.max_char_size:
				logger.error('If data_type == varchar, max_char_size must be set.')
				self.disconnect_db()
				exit()
			self.element_type = 'string'
			self.data_type = self.data_type + '(' + str(self.max_char_size) + ')'
		elif self.data_type in ['int','integer','bigint']:
			self.element_type = 'integer'
		elif self.data_type in ['float','double precision']:
			self.element_type = 'decimal'
		elif self.data_type == 'date':
			self.element_type = 'date'
		else:
			logger.error('Unknown data_type: %s', self.data_type)

		sql =  f'alter table {self.schema}."{self.table_name}" add "{self.new_column_name}" {self.data_type};'
		if not self.sql_only:
			self.cur.execute(sql)
			logger.info('Added column %s to table %s.%s', self.new_column_name, self.schema, self.table_name)

		self.sql = self.sql + sql + '\n\n'		


	def insert_element_info(self):		
		if not self.template_element_name:
			self.template_element_name = utils.get_element_name_from_colname(self.new_column_name)
		if not self.max_char_size:
			self.max_char_size = 'null'
		if not self.required:
			self.required = 'null'
		else:
			self.required = "'" + self.required + "'"
		if not self.allowed_values:
			self.allowed_values = 'null'
		else:
			self.allowed_values = "'" + self.allowed_values + "'"
		if not self.lookup_table:
			self.lookup_table = 'null'
		else:
			self.lookup_table = "'" + self.lookup_table + "'"
		if not self.business_rule:
			self.business_rule = 'null'
		else:
			self.business_rule = "'" + self.business_rule + "'"
		if not self.notes:
			self.notes = 'null'
		else:
			self.notes = "'" + self.notes + "'"
		if not self.database_lookup_table:
			self.database_lookup_table = 'null'
		else:
			self.database_lookup_table = "'" + self.database_lookup_table + "'"
		if not self.database_lookup_column:
			self.database_lookup_column = 'null'
		else:
			self.database_lookup_column = "'" + self.database_lookup_column + "'"

		sql = f"""insert into {self.schema}.{self.ust_or_release}_elements (element_name, element_description, displayed_in_ustfinder, 
						  element_type, element_size, required, allowed_values, 
						  lookup_table, business_rule, notes,  
						  database_column_name, database_lookup_table, database_lookup_column,
						  generic_template)
				  values ('{self.template_element_name}', '{self.element_description}', '{self.displayed_in_ustfinder}', 
						  '{self.element_type}', {self.max_char_size}, {self.required}, {self.allowed_values}, {self.lookup_table}, {self.business_rule}, {self.notes}, 
						  '{self.new_column_name}', {self.database_lookup_table}, {self.database_lookup_column}, '{self.generic_template}')
				  returning element_id;"""

		if not self.sql_only:
			self.cur.execute(sql)
			self.element_id = self.cur.fetchone()[0]
			logger.info('Inserted a row into %s_elements, returning new element_id %s', self.ust_or_release, self.element_id)
		else:
			self.element_id = '?? --replace with element_id from above query\n'

		self.sql = self.sql + sql + '\n\n'


	def insert_element_table_info(self):
		if not self.column_sort_order:
			sql = f"""select max(sort_order) + 1 from {self.schema}.{self.ust_or_release}_elements_tables 
					  where table_name = %s"""
			self.cur.execute(sql, (self.table_name,))
			self.column_sort_order = self.cur.fetchone()[0]
			logger.info('Set column sort order to %s', self.column_sort_order)


		sql = f"""insert into {self.schema}.{self.ust_or_release}_elements_tables (element_id, table_name, sort_order, primary_key) 
				  values ({self.element_id}, '{self.table_name}', {self.column_sort_order}, null)
				  returning element_table_id;"""

		if not self.sql_only:
			self.cur.execute(sql)
			self.element_table_id = self.cur.fetchone()[0]
			logger.info('Inserted a row into %s_element_tables, returning new element_table_id %s', self.ust_or_release, self.element_table_id)

		self.sql = self.sql + sql + '\n\n'


	def update_view(self):
		self.view_name = 'v_' + self.table_name 
		if not self.template_element_name:
			self.template_element_name = utils.get_element_name_from_colname(self.new_column_name)

		view_sql = utils.get_view_sql(self.view_name)
		view_info = utils.process_view_sql(view_sql)
		select_sql = view_info[0]
		from_sql = view_info[1]

		new_view_sql = 'create or replace view ' + self.schema + '.' + self.view_name + ' as\n'
		new_view_sql = new_view_sql + 'select distinct ' + select_sql.strip().rstrip('\n') + ',\n\t' + self.new_column_name + ' as "' + self.template_element_name + '"\n' 
		new_view_sql = new_view_sql + from_sql 

		if not self.sql_only:
			try:
				self.cur.execute(new_view_sql)
			except psycopg2.errors.DuplicateColumn:
				logger.warning('Column %s already exists in %s.%s', self.template_element_name, self.schema, self.view_name)
				return 

			logger.info('Updated view %s.%s to add column %s as %s', self.schema, self.view_name, self.new_column_name, self.template_element_name)

		self.sql = self.sql + new_view_sql + '\n\n'		


	def write_sql(self):
		with open(self.export_file_path, 'w', encoding='utf-8') as f:
			f.write(self.sql)
		logger.info('Wrote SQL file to %s', self.export_file_path)


def main(new_column_name,
		 table_name,
		 data_type,
		 max_char_size=None,
		 element_description=None,
		 sql_only=False,
		 sql_export_path='../../sql/misc/',
		 column_sort_order=None,
		 schema='public',
		 template_element_name=None,
		 displayed_in_ustfinder='N',
		 required='N',
		 allowed_values=None,
		 lookup_table=None,
		 business_rule=None,
		 notes=None,
		 database_lookup_table=None,
		 database_lookup_column=None,
		 generic_template='Y'):

	new_column = NewColumn(new_column_name=new_column_name,
							table_name=table_name,
							data_type=data_type,
							max_char_size=max_char_size,
							element_description=element_description,
							sql_only=sql_only,
							sql_export_path=sql_export_path,
							column_sort_order=column_sort_order,
							schema=schema,
							template_element_name=template_element_name,
							displayed_in_ustfinder=displayed_in_ustfinder,
							required=required,
							allowed_values=allowed_values,
							lookup_table=lookup_table,
							business_rule=business_rule,
							notes=notes,
							database_lookup_table=database_lookup_table,
							database_lookup_column=database_lookup_column,
							generic_template=generic_template)


if __name__ == '__main__':   
	main(new_column_name=new_column_name,
		 table_name=table_name,
		 data_type=data_type,
		 max_char_size=max_char_size,
		 element_description=element_description,
		 sql_only=sql_only,
		 sql_export_path=sql_export_path,
		 column_sort_order=column_sort_order,
		 schema=schema,
		 template_element_name=template_element_name,
		 displayed_in_ustfinder=displayed_in_ustfinder,
		 required=required,
		 allowed_values=allowed_values,
		 lookup_table=lookup_table,
		 business_rule=business_rule,
		 notes=notes,
		 database_lookup_table=database_lookup_table,
		 database_lookup_column=database_lookup_column,
		 generic_template=generic_template)		