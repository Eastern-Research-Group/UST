# TODO: when creating v_ust_tank_substance and v_ust_compartment_substance, include substance_comment and populate with organization value

import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import pandas as pd

from python.util.dataset import Dataset 
from python.util import utils
from python.util.logger_factory import logger


ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = 17                  # Enter an integer that is the ust_control_id or release_control_id
table_name = 'ust_tank'       		# Enter EPA table name we are writing the view to populate. Set to None to generate all required views. 
overwrite_sql_file = False      # Boolean, defaults to False. Set to True to overwrite an existing SQL file if it exists. 

# These variables can usually be left unset. This script will general a SQL file in the appropriate state folder in the repo under /ust/sql/states
export_file_path = None         
export_file_dir = None
export_file_name = None

class ViewSql:
	conn = None  
	cur = None  
	required_cols = None 
	existing_cols = None
	required_col_ids = None
	existing_col_ids = None
	all_col_ids = None
	epa_column_name = None
	join_info = {}
	select_sql = ''
	from_sql = ''
	view_sql = '----------------------------------------------------------------------------------------------------------\n\n'
	table_aliases = {}

	def __init__(self, 
				 dataset,
				 table_name,
				 drop_existing=False, 
				 overwrite_sql_file=False):
		self.dataset = dataset
		self.table_name = table_name 
		self.overwrite_sql_file = overwrite_sql_file
		self.view_name = 'v_' + self.table_name
		self.connect_db()
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


	def connect_db(self):
		self.conn = utils.connect_db()
		self.cur = self.conn.cursor()
		logger.info('Connected to database')


	def disconnect_db(self):
		self.conn.commit()
		self.cur.close()
		self.conn.close()
		logger.info('Disconnected from database')


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
		logger.info('Wrote SQL to %s', self.dataset.export_file_path)


	def get_required_cols(self):
		sql = f"""select column_sort_order, a.column_name, a.data_type, a.character_maximum_length
				from information_schema.columns a join public.{self.dataset.ust_or_release}_required_view_columns b 
					on a.table_name = b.information_schema_table_name and a.column_name = b.column_name
				where table_schema = 'public' and b.table_name = %s 
				and b.column_name not in 
					(select epa_column_name from public.v_{self.dataset.ust_or_release}_element_mapping_joins
					where {self.dataset.ust_or_release}_control_id = %s and epa_table_name = %s)
				order by column_sort_order"""
		self.cur.execute(sql, (self.table_name, self.dataset.control_id, self.table_name))
		# utils.pretty_print_query(self.cur)
		req_col_info = self.cur.fetchall()
		self.required_col_ids = [c[0] for c in req_col_info]
		req_cols = {}
		for req_col in req_col_info:
			column_id = req_col[0]
			column_name = req_col[1]
			data_type = req_col[2]
			character_maximum_length = req_col[3]
			req_cols[column_id] = {'column_name': column_name, 'data_type': data_type, 'character_maximum_length':character_maximum_length}
		# print(req_cols)
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
					epa_column_name, organization_column_name, 
					selected_column, query_logic,
					organization_table_name
			from public.v_{self.dataset.ust_or_release}_table_population_sql
			where {self.dataset.ust_or_release}_control_id = %s and epa_table_name = %s
			and column_sort_order is not null
			order by column_sort_order """
		self.cur.execute(sql, (self.dataset.control_id, self.table_name))
		# utils.pretty_print_query(self.cur)
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
			organization_column_name = existing_col[2]
			selected_column = existing_col[3]
			query_logic = existing_col[4]
			organization_table_name = existing_col[5]
			if not selected_column:
				selected_column = self.get_column_select_sql(epa_column_name, organization_column_name)
				try:
					selected_column = self.table_aliases[organization_table_name] + '.' + selected_column
				except KeyError:
					pass
			if query_logic:
				query_logic = utils.comment_every_line(query_logic)
			else:
				query_logic = ''
			if column_id == max(self.existing_col_ids):
				selected_column = selected_column[:-1]
			existing_cols[column_id] = {'column_name': epa_column_name, 
			                            'selected_column': selected_column, 
			                            'query_logic': query_logic,
			                            'organization_table_name': organization_table_name}		
		return existing_cols


	# def print_join_info(self):
	# 	print(self.join_info)


	# def set_join_info(self, org_table_name, where_table='organization_table_name', epa_table_name=None):
	# 	if not epa_table_name:
	# 		epa_table_name = self.table_name
	# 	sql = f"""select distinct organization_table_name, organization_join_table, 
	# 				organization_join_column, organization_join_fk,
	# 				organization_join_column2, organization_join_fk2,
	# 				organization_join_column3, organization_join_fk3,
	# 				organization_column_name
	# 			from public.v_{self.dataset.ust_or_release}_element_mapping_joins
	# 			where {self.dataset.ust_or_release}_control_id = %s and epa_table_name = %s 
	# 			and {where_table} = %s
	# 			order by 1, 2, 3"""
	# 	self.cur.execute(sql, (self.dataset.control_id, epa_table_name, org_table_name))
	# 	utils.pretty_print_query(self.cur)
	# 	rows = self.cur.fetchall()	
	# 	self.join_info = {}
	# 	for row in rows:
	# 		self.join_info['organization_table_name'] = row[0]
	# 		self.join_info['organization_join_table'] = row[1]
	# 		self.join_info['organization_join_column'] = row[2]
	# 		self.join_info['organization_join_fk'] = row[3]
	# 		self.join_info['organization_join_column2'] = row[4]
	# 		self.join_info['organization_join_fk2'] = row[5]
	# 		self.join_info['organization_join_column3'] = row[6]
	# 		self.join_info['organization_join_fk3'] = row[7]	
	# 		self.join_info['organization_column_name'] = row[8]				


	def build_from_sql(self, from_table, alias, join_alias):
		if self.join_info['table_type'] == 'lookup':
			self.from_sql = self.from_sql + '\n\tleft join ' + self.dataset.schema + '.' + from_table + ' ' + alias + ' on ' + join_alias + '."' + self.join_info['organization_join_column'] + '" = ' + alias + '.organization_value'
		else:
			if self.join_info['organization_join_column'] and self.join_info['organization_join_fk']:
				self.from_sql = self.from_sql + '\n\tleft join ' + self.dataset.schema + '."' + from_table + '" ' + alias + ' on ' + join_alias + '."' + self.join_info['organization_join_column'] + '" = ' + alias + '."' + self.join_info['organization_join_fk'] + '" '
			if self.join_info['organization_join_column2'] and self.join_info['organization_join_fk2']:
				self.from_sql = self.from_sql + 'and ' + join_alias + '."' + self.join_info['organization_join_column2'] + '" = ' + alias + '."' + self.join_info['organization_join_fk2'] + '" '
			if self.join_info['organization_join_column3'] and self.join_info['organization_join_fk3']:
				self.from_sql = self.from_sql + 'and ' + join_alias + '."' + self.join_info['organization_join_column3'] + '" = ' + alias + '."' + self.join_info['organization_join_fk3'] + '" '


	def build_from_query(self):
		self.from_sql = 'from '

		df = pd.DataFrame(utils.get_join_tables(self.dataset, self.table_name))
		df.set_index('organization_table_name', inplace=True)
		print(df.to_string())
		print('----------------------------------------------------------------------------------------------------------------------\n')
		# exit()

		for from_table, row in df.iterrows():
			logger.info('Working on table %s', from_table)
			self.join_info = row
			alias = row['alias']
			table_type = row['table_type']

			if alias == 'a':
				self.from_sql = self.from_sql + self.dataset.schema + '.' + '"' + from_table + '" ' + alias
				self.table_aliases[from_table] = alias

			else:
				try:
					join_alias = df.loc[self.join_info['organization_join_table']]['alias']
				except:
					join_alias = 'a'
				# print('alias = ' + alias)
				# print('join_alias = ' + join_alias)
				self.build_from_sql(from_table, alias, join_alias)
				self.table_aliases[from_table] = alias

			print('__________________________________________________________________________________________________________________\n')

		self.from_sql = self.from_sql + '\nwhere -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE\n;\n'

	# def build_from_query(self):
	# 	self.from_sql = 'from '

	# 	# sql = f"""select organization_table_name, table_type,
	# 	# 				chr(96 + row_number() over (partition by 'a' order by x.sort_order, z.sort_order)::int) as alias
	# 	# 		from 
	# 	# 			(select organization_table_name, min(sort_order) as sort_order 
	# 	# 			from public.v_{self.dataset.ust_or_release}_mapped_table_types a join public.mapped_table_types b on a.table_type = b.table_type
	# 	# 			where {self.dataset.ust_or_release}_control_id = {self.dataset.control_id} and epa_table_name = '{self.table_name}'
	# 	# 			group by organization_table_name) x 
	# 	# 			join public.mapped_table_types y on x.sort_order = y.sort_order 
	# 	# 			left join public.generated_table_sort_order z on x.organization_table_name = z.table_name
	# 	# 		order by alias"""
	# 	# print(sql)
	# 	# exit()
	# 	# df = pd.read_sql(sql, utils.get_engine(), index_col='organization_table_name')
		
	# 	self.join_info = utils.get_join_tables(self.dataset, self.table_name)
	# 	df = pd.DataFrame(self.join_info)
	# 	df.set_index('organization_table_name', inplace=True)
	# 	print(df)
	# 	print('----------------------------------------------------------------------------------------------------------------------\n')
	# 	# exit()

	# 	# deagg_rows_alias = None 
	# 	for index, row in df.iterrows():
	# 		logger.info('Working on table %s', index)
	# 		alias = row['alias']
	# 		print('alias = ' + alias)
	# 		print("table_type = " + row['table_type'])

	# 		if alias == 'a':
	# 			self.from_sql = self.from_sql + self.dataset.schema + '.' + '"' + index + '" ' + alias
	# 			self.table_aliases[index] = alias

	# 		elif row['table_type'] == 'id' or row['table_type'] == 'org':
	# 			from_table = index

	# 			# self.set_join_info(from_table)
	# 			try:
	# 				join_alias = df.loc[self.join_info['organization_join_table']]['alias']
	# 			except:
	# 				join_alias = 'a'
	# 			print('from_table = ' + from_table)
	# 			print('alias = ' + alias)
	# 			print('join_alias = ' + join_alias)
	# 			self.build_from_sql(from_table, alias, join_alias)
	# 			self.table_aliases[index] = alias

	# 		elif row['table_type'] == 'join' or row['table_type'] == 'id-join':
	# 			from_table = index

	# 			if self.table_name == 'ust_compartment':
	# 				epa_table_name = 'ust_tank'
	# 				search_table = 'organization_table_name'
	# 			# elif self.table_name == 'ust_piping':
					
	# 			# 	epa_table_name = 'ust_compartment'
	# 			# 	search_table = 'organization_table_name'
	# 			else:
	# 				epa_table_name = self.table_name
	# 				search_table = 'organization_join_table'
	# 			print('from_table = ' + from_table)
	# 			print('search_table = ' + search_table)
	# 			print('epa_table_name = ' + epa_table_name)
	# 			self.set_join_info(from_table, search_table, epa_table_name)
	# 			self.print_join_info()
	# 			try:
	# 				join_alias = df.loc[self.join_info['organization_table_name']]['alias']
	# 			except:
	# 				join_alias = 'a'
	# 			if alias == join_alias:
	# 				try:
	# 					join_alias = df.loc[self.join_info['organization_join_table']]['alias']
	# 				except KeyError:
	# 					join_alias = 'a'
	# 			self.build_from_sql(from_table, alias, join_alias)
	# 			self.table_aliases[index] = alias

	# 		elif row['table_type'] == 'deagg':
	# 			self.set_join_info(index, 'deagg_table_name')
	# 			sql = f"""select distinct deagg_column_name 
	# 					from public.v_{self.dataset.ust_or_release}_element_mapping_joins
	# 					where {self.dataset.ust_or_release}_control_id = %s and epa_table_name = %s 
	# 					and deagg_table_name = %s"""
	# 			self.cur.execute(sql, (self.dataset.control_id, self.table_name, index))
	# 			# utils.pretty_print_query(self.cur)
	# 			rows = self.cur.fetchall()
	# 			db_lookup_col = None
	# 			for row in rows:
	# 				db_lookup_col = row[0]
	# 			from_table = index
	# 			try:
	# 				join_alias = df.loc[self.join_info['organization_join_table']]['alias']
	# 			except:
	# 				join_alias = 'a'
	# 			self.build_from_sql(from_table, alias, join_alias)
	# 			self.table_aliases[index] = alias
	# 			if 'datarows' in from_table:
	# 				deagg_rows_alias = alias

	# 		elif row['table_type'] == 'lookup':
	# 			self.set_join_info(index, 'database_lookup_table')
	# 			sql = f"""select distinct database_lookup_column 
	# 					from public.v_{self.dataset.ust_or_release}_element_mapping_joins
	# 					where {self.dataset.ust_or_release}_control_id = %s and epa_table_name = %s and database_lookup_table = %s"""
	# 			self.cur.execute(sql, (self.dataset.control_id, self.table_name, index))
	# 			# utils.pretty_print_query(self.cur)
	# 			rows = self.cur.fetchall()
	# 			db_lookup_col = None
	# 			for row in rows:
	# 				db_lookup_col = row[0]
	# 			from_table = 'v_' + db_lookup_col + '_xwalk'	
	# 			if deagg_rows_alias:
	# 				join_alias = deagg_rows_alias
	# 			else:
	# 				try:
	# 					join_alias = df.loc[self.join_info['organization_table_name']]['alias']
	# 				except:
	# 				 	join_alias = 'a'
	# 			self.from_sql = self.from_sql + '\n\tleft join ' + self.dataset.schema + '.' + from_table + ' ' + alias + ' on ' + join_alias + '."' + self.join_info['organization_column_name'] + '" = ' + alias + '.organization_value'
	# 			self.table_aliases[index] = alias
	# 		# print(self.from_sql) 
	# 		print('__________________________________________________________________________________________________________________\n')
	# 	self.from_sql = self.from_sql + '\nwhere -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE\n;\n'


	def build_select_query(self):
		self.select_sql = self.select_sql + 'select distinct\n'
		region_next = False 
		for i in range(len(self.all_col_ids)):
			# deal with EPARegion column if in ust_facility and the last column was FacilityState
			if region_next:
				epa_region = None 
				selected_column = str(utils.get_epa_region(self.dataset.organization_id)) + '::integer as facility_epa_region,'
				self.select_sql = self.select_sql + '\t' + selected_column + '\n'
				region_next = False

			# build the select columns component of the query
			column_id = self.all_col_ids[i]
			if self.all_col_ids[i] in self.existing_col_ids: # the column we are working on was mapped in the element_mapping table
				self.epa_column_name = self.existing_cols[column_id]['column_name']
				# logger.info('Working on column %s', self.epa_column_name)
				selected_column = self.existing_cols[column_id]['selected_column'].replace('""','????')
				if 'facility_type' in self.epa_column_name and '_id' not in self.epa_column_name:
					selected_column = selected_column.replace('facility_type1 as','facility_type_id as').replace('facility_type2 as','facility_type_id as')
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
			if self.existing_cols[column_id]['query_logic']:
				selected_column = '  !!! ' + selected_column
			self.select_sql = self.select_sql + '\t' + selected_column + ' ' + self.existing_cols[column_id]['query_logic'] + '\n'


	def generate_sql(self):
		self.build_from_query()
		self.required_cols = self.get_required_cols()
		self.existing_cols = self.get_existing_cols()
		# print(self.required_cols)
		# print(self.existing_cols)
		# for k, v in self.existing_cols.items():
		# 	print('k = ' + str(k) + '; v = ' + str(v))
		# exit()
		self.required_col_ids = [n for n in self.required_col_ids if n not in self.existing_col_ids]
		self.all_col_ids = sorted(self.required_col_ids + self.existing_col_ids, key=lambda x: x or 0)		
		self.build_select_query()
		self.view_sql = self.view_sql + f'create view {self.dataset.schema}.{self.view_name} as\n'
		self.view_sql = self.view_sql + self.select_sql + self.from_sql
		# print(self.view_sql)
		return self.view_sql 



def get_tables_needed(dataset):
	conn = utils.connect_db()
	cur = conn.cursor()
	sql = f"""select distinct epa_table_name, table_sort_order
			from public.v_{dataset.ust_or_release}_table_population 
			where {dataset.ust_or_release}_control_id = %s
			order by table_sort_order"""
	cur.execute(sql, (dataset.control_id,))
	rows = cur.fetchall()
	cur.close()
	conn.close()
	return [r[0] for r in rows]



def main(ust_or_release, control_id, table_name=None, overwrite_sql_file=False):
	dataset = Dataset(ust_or_release=ust_or_release,
				 	  control_id=control_id,
					  base_file_name='view_creation.sql',
					  export_file_name=export_file_name,
					  export_file_dir=export_file_dir,
					  export_file_path=export_file_path)

	if table_name:
		sql = ViewSql(dataset=dataset, 
			          table_name=table_name,
			          overwrite_sql_file=overwrite_sql_file)
		print(sql.view_sql)
	else:
		tables_needed = get_tables_needed(dataset)
		for table in tables_needed: 
			sql = ViewSql(dataset=dataset, 
				          table_name=table,
				          overwrite_sql_file=overwrite_sql_file)
			# print(sql.view_sql)

	logger.info('Script complete.')


if __name__ == '__main__':   
	main(ust_or_release=ust_or_release,
		 control_id=control_id,
		 table_name=table_name,
		 overwrite_sql_file=overwrite_sql_file)
