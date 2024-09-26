import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import pandas as pd

from python.example_schema.dataset_example import Dataset 
from python.util import utils
from python.util.logger_factory import logger


ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = 1                  # Enter an integer that is the ust_control_id or release_control_id
table_name = 'ust_tank'         # Enter EPA table name we are writing the view to populate. Set to None to generate all required views. 
overwrite_sql_file = False      # Boolean, defaults to False. Set to True to overwrite an existing SQL file if it exists. This parameter has no effect if write_sql = False. 

# These variables can usually be left unset. This script will general a SQL file in the appropriate state folder in the repo under /ust/sql/states
export_file_path = None         
export_file_dir = None
export_file_name = None

class ViewSql:
	conn = None  
	cur = None  
	required_col_ids = None
	existing_col_ids = None
	epa_column_name = None
	join_info = {}
	from_sql = ''
	view_sql = '----------------------------------------------------------------------------------------------------------\n\n'  

	def __init__(self, 
				 dataset,
				 table_name,
				 drop_existing=False, 
				 overwrite_sql_file=False):
		self.dataset = dataset
		self.table_name = table_name 
		self.overwrite_sql_file = overwrite_sql_file
		self.view_name = 'v_' + self.table_name
		self.set_db_connection()
		self.required_cols = self.get_required_cols()
		self.existing_cols = self.get_existing_cols()
		self.required_col_ids = [n for n in self.required_col_ids if n not in self.existing_col_ids]
		self.all_col_ids = sorted(self.required_col_ids + self.existing_col_ids)
		try:
			self.generate_sql()	
		except Exception as e:
			print('------------------------------------------------')
			import logging
			logging.error(e, exc_info=True)
			print('------------------------------------------------')

		self.disconnect_db()
		# self.show_existing_cols()
		self.write_self()	


	def set_db_connection(self):
		self.conn = utils.connect_db()
		self.cur = self.conn.cursor()


	def disconnect_db(self):
		self.conn.commit()
		self.cur.close()
		self.conn.close()


	def show_existing_cols(self):
		for k, v in self.existing_cols.items():
			print('column ID = ' + str(k))
			print('column_name = ' + v['column_name'])


	def write_self(self):
		if self.overwrite_sql_file:
			wora = 'w'
		else:
			wora = 'a'
		with open(self.dataset.export_file_path, wora, encoding='utf-8') as f:
			f.write(self.view_sql.replace('\t','    '))


	def get_required_cols(self):
		sql = f"""select ordinal_position, a.column_name, a.data_type, a.character_maximum_length
				from information_schema.columns a join public.{self.dataset.ust_or_release}_required_view_columns b 
					on a.table_name = b.table_name and a.column_name = b.column_name
				where table_schema = 'public' and a.table_name = %s 
				and b.column_name not in 
					(select epa_column_name from example.v_{self.dataset.ust_or_release}_element_mapping_joins
					where {self.dataset.ust_or_release}_control_id = %s and epa_table_name = %s)
				order by ordinal_position"""
		self.cur.execute(sql, (self.table_name, self.dataset.control_id, self.table_name))
		req_col_info = self.cur.fetchall()
		self.required_col_ids = [c[0] for c in req_col_info]
		req_cols = {}
		for req_col in req_col_info:
			column_id = req_col[0]
			column_name = req_col[1]
			data_type = req_col[2]
			character_maximum_length = req_col[3]
			req_cols[column_id] = {'column_name': column_name, 'data_type': data_type, 'character_maximum_length':character_maximum_length}
		return req_cols
			

	def get_column_select_sql(self, epa_column_name, org_column_name):
		epa_table_name = self.table_name
		if epa_column_name == 'facility_id' and self.table_name != 'ust_facility':
			epa_table_name = 'ust_facility'
		elif (epa_column_name == 'tank_id' or epa_column_name == 'tank_name') and self.table_name != 'ust_tank':
			epa_table_name = 'ust_tank'
		elif (epa_column_name == 'compartment_id' or epa_column_name == 'compartment_name') and self.table_name != 'ust_compartment':
			epa_table_name = 'ust_compartment'

		sql = """select data_type, character_maximum_length from information_schema.columns 
		         where table_schema = 'public' and table_name = %s and column_name = %s"""
		self.cur.execute(sql, (epa_table_name, epa_column_name))
		# utils.pretty_print_query(self.cur)
		row = self.cur.fetchone()
		data_type = row[0]
		max_len = row[1]
		selected_column = '"' + org_column_name + '"::' + data_type
		if max_len:
			selected_column = selected_column + '(' + str(max_len) + ')'
		selected_column = selected_column + ' as ' + epa_column_name + ','
		return selected_column 


	def get_existing_cols(self):
		sql = f"""select column_sort_order as column_id, 
					epa_column_name,
					organization_column_name,
					programmer_comments
			from example.v_{self.dataset.ust_or_release}_element_mapping_joins
			where {self.dataset.ust_or_release}_control_id = %s and epa_table_name = %s
			order by column_sort_order """
		self.cur.execute(sql, (self.dataset.control_id, self.table_name))
		existing_col_info = self.cur.fetchall()
		if not existing_col_info:
			logger.warning('No elements have been mapped for EPA table %s. Exiting...', self.table_name)
			self.disconnect_db()
			exit()
		self.existing_col_ids = [c[0] for c in existing_col_info]
		existing_cols = {}
		for existing_col in existing_col_info:
			column_id = existing_col[0]
			epa_column_name = existing_col[1]
			org_column_name = existing_col[2]
			programmer_comments = existing_col[3]
			if programmer_comments:
				programmer_comments = '	  -- ' + programmer_comments
			else:
				programmer_comments = ''
			existing_cols[column_id] = {'column_name': epa_column_name, 
			                            'selected_column': self.get_column_select_sql(epa_column_name, org_column_name), 
			                            'programmer_comments': programmer_comments}		
		return existing_cols


	def print_join_info(self):
		print(self.join_info)

	# 	print(f"organization_column_name = {self.join_info['organization_column_name']}")
	# 	print('organization_join_table = ' + str(self.join_info['organization_join_table']))
	# 	print('organization_join_column = ' + str(self.join_info['organization_join_column']))
	# 	print('organization_join_fk = ' + str(self.join_info['organization_join_fk']))
	# 	print('organization_join_column2 = ' + str(self.join_info['organization_join_column2']))
	# 	print('organization_join_fk2 = ' + str(self.join_info['organization_join_fk2']))
	# 	print('organization_join_column3 = ' + str(self.join_info['organization_join_column3']))
	# 	print('organization_join_fk3 = ' + str(self.join_info['organization_join_fk3']))


	def set_join_info(self, org_table_name):
		sql = f"""select distinct organization_join_table, 
					organization_join_column, organization_join_fk,
					organization_join_column2, organization_join_fk2,
					organization_join_column3, organization_join_fk3,
					organization_column_name
				from example.v_{self.dataset.ust_or_release}_element_mapping_joins
				where {self.dataset.ust_or_release}_control_id = %s and epa_table_name = %s and organization_table_name = %s
				order by 1, 2, 3"""
		self.cur.execute(sql, (self.dataset.control_id, self.table_name, org_table_name))
		rows = self.cur.fetchall()	
		self.join_info = {}
		for row in rows:
			self.join_info['organization_join_table'] = row[0]
			self.join_info['organization_join_column'] = row[1]
			self.join_info['organization_join_fk'] = row[2]
			self.join_info['organization_join_column2'] = row[3]
			self.join_info['organization_join_fk2'] = row[4]
			self.join_info['organization_join_column3'] = row[5]
			self.join_info['organization_join_fk3'] = row[6]	
			self.join_info['organization_column_name'] = row[7]				


	def build_from_sql(self, from_table, alias, join_alias):
		if self.join_info['organization_join_column'] and self.join_info['organization_join_fk']:
			self.from_sql = self.from_sql + '\n\tleft join ' + self.dataset.schema + '."' + from_table + '" ' + alias + ' on ' + join_alias + '."' + self.join_info['organization_join_column'] + '" = ' + alias + '."' + self.join_info['organization_join_fk'] + '" '
		if self.join_info['organization_join_column2'] and self.join_info['organization_join_fk2']:
			self.from_sql = self.from_sql + ' and ' + join_alias + '."' + self.join_info['organization_join_column2'] + '" = ' + alias + '."' + self.join_info['organization_join_fk2'] + '" '
		if self.join_info['organization_join_column3'] and self.join_info['organization_join_fk3']:
			self.from_sql = self.from_sql + ' and ' + join_alias + '."' + self.join_info['organization_join_column3'] + '" = ' + alias + '."' + self.join_info['organization_join_fk3'] + '" '


	def build_select_query(self):
		self.view_sql = self.view_sql + 'select distinct\n'
		region_next = False 
		for i in range(len(self.all_col_ids)):
			# deal with EPARegion column if in ust_facility and the last column was FacilityState
			if region_next:
				epa_region = None 
				selected_column = str(utils.get_epa_region(self.dataset.organization_id)) + '::integer as facility_epa_region,'
				self.view_sql = self.view_sql + '\t--' + selected_column + '\n'
				region_next = False

			# build the select columns component of the query
			column_id = self.all_col_ids[i]
			if self.all_col_ids[i] in self.existing_col_ids: # the column we are working on was mapped in the element_mapping table
				self.epa_column_name = self.existing_cols[column_id]['column_name']
				logger.info('Working on column %s', self.epa_column_name)
				selected_column = self.existing_cols[column_id]['selected_column'].replace('""','????')
				if 'facility_type' in self.epa_column_name and '_id' not in self.epa_column_name:
					selected_column = selected_column.replace('facility_type1 as','facility_type_id as').replace('facility_type2 as','facility_type_id as')
				programmer_comments = self.existing_cols[column_id]['programmer_comments']
			else: # the column we are working on wasn't mapped in the element mapping table but is a required field so add it anyway
				self.epa_column_name = self.required_cols[column_id]['column_name']
				logger.info('Working on column %s', self.epa_column_name)
				data_type = self.required_cols[column_id]['data_type']
				character_maximum_length = self.required_cols[column_id]['character_maximum_length']
				org_col = '????' # print a symbol making it obvious to the developer they need to update the generated SQL
			if self.epa_column_name == 'facility_state':
				# if facility_state wasn't mapped, set it as the organization ID
				if 11 not in self.existing_col_ids:
					org_col = f"'{self.dataset.organization_id}'"
					selected_column = org_col + '::' + utils.get_datatype_sql(data_type, character_maximum_length) + ' as ' + self.epa_column_name + ','
				# if we are working on ust_facility and we are on facility state, set the region_next variable
				if self.dataset.ust_or_release == 'ust' and self.table_name == 'ust_facility' and 12 not in self.existing_col_ids:
					region_next = True
				
			self.view_sql = self.view_sql + '\t' + selected_column + programmer_comments + '\n'
		

	def build_from_query(self):
		self.view_sql = self.view_sql[:-2] + '\nfrom '

		sql = f"""select organization_table_name, table_type,
					chr(96 + row_number() over (partition by 'a' order by x.sort_order)::int) as alias
				  from 
					(select organization_table_name, min(sort_order) as sort_order 
					from example.v_{self.dataset.ust_or_release}_mapped_table_types a join public.mapped_table_types b on a.table_type = b.table_type
					where {self.dataset.ust_or_release}_control_id = {self.dataset.control_id} and epa_table_name = '{self.table_name}'
					group by organization_table_name) x join public.mapped_table_types y on x.sort_order = y.sort_order 
					order by alias"""
		df = pd.read_sql(sql, utils.get_engine(), index_col='organization_table_name')
		print(df)

		from_sql = ''
		for index, row in df.iterrows():
			logger.info('Working on %s', index)
			alias = row['alias']
			
			self.set_join_info(index)
			self.print_join_info()
			organization_join_table = self.join_info['organization_join_table']
			organization_join_column = self.join_info['organization_join_column']
			organization_join_fk = self.join_info['organization_join_fk']
			organization_join_column2 = self.join_info['organization_join_column2']
			organization_join_fk2 = self.join_info['organization_join_fk2']
			organization_join_column3 = self.join_info['organization_join_column3']
			organization_join_fk3 = self.join_info['organization_join_fk3']
			organization_column_name = self.join_info['organization_column_name']
			try:
				join_alias = df.loc[organization_join_table]['alias']
			except:
				join_alias = 'a'
			print('alias = ' + alias)
			print('join_alias = ' + join_alias)

			if row['alias'] == 'a':
				self.from_sql = self.from_sql + self.dataset.schema + '.' + '"' + index + '" ' + alias
			elif row['table_type'] == 'id' or row['table_type'] == 'org' or row['table_type'] == 'join':
				self.build_from_sql(index, alias, join_alias)
			elif row['table_type'] == 'lookup':
				sql = f"""select distinct database_lookup_column 
						from example.v_{self.dataset.ust_or_release}_element_mapping_joins
						where {self.dataset.ust_or_release}_control_id = %s and epa_table_name = %s and database_lookup_table = %s"""
				self.cur.execute(sql, (self.dataset.control_id, self.table_name, index))
				# utils.pretty_print_query(self.cur)
				rows = self.cur.fetchall()
				db_lookup_col = None
				for row in rows:
					db_lookup_col = row[0]
				view_name = 'v_' + db_lookup_col + '_xwalk'
				self.from_sql = self.from_sql + '\n\tleft join ' + self.dataset.schema + '.' + view_name + ' ' + alias + ' on ' + join_alias + '."' + organization_column_name + '" = ' + alias + '.organization_value'
			elif row['table_type'] == 'deagg':
				self.build_from_sql(view_name, alias, join_alias)



		print(self.from_sql)




	def generate_sql(self):
		# self.view_sql = self.view_sql + f'create view {self.dataset.schema}.{self.view_name} as\n'
		# self.build_select_query()
		self.build_from_query()
		# print(self.view_sql)
		return self.view_sql 




def get_tables_needed(dataset):
	conn = utils.connect_db()
	cur = conn.cursor()
	sql = f"""select distinct epa_table_name, table_sort_order
			from example.v_{dataset.ust_or_release}_table_population 
			where {dataset.ust_or_release}_control_id = %s
			order by table_sort_order"""
	cur.execute(sql, (dataset.control_id,))
	rows = cur.fetchall()
	cur.close()
	conn.close()
	return [r[0] for r in rows]



def main(ust_or_release, control_id, table_name=None):
	dataset = Dataset(ust_or_release=ust_or_release,
				 	  control_id=control_id,
					  base_file_name='view_creation.sql',
					  export_file_name=export_file_name,
					  export_file_dir=export_file_dir,
					  export_file_path=export_file_path)
	if table_name:
		sql = ViewSql(dataset=dataset, 
			          table_name=table_name)
		print(sql.view_sql)
	else:
		tables_needed = get_tables_needed(dataset)
		for table in tables_needed: 
			sql = ViewSql(dataset=dataset, 
				          table_name=table)
			# print(sql.view_sql)


if __name__ == '__main__':   
	main(ust_or_release=ust_or_release,
		 control_id=control_id,
		 table_name=table_name)
