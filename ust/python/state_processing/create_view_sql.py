import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

from python.util import utils
from python.util.dataset import Dataset 
from python.util.logger_factory import logger


ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = 0                  # Enter an integer that is the ust_control_id or release_control_id
table_name = None               # Enter EPA table name we are writing the view to populate. Set to None to generate all required views. 
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
		self.connect_db()
		self.required_cols = self.get_required_cols()
		self.existing_cols = self.get_existing_cols()
		self.required_col_ids = [n for n in self.required_col_ids if n not in self.existing_col_ids]
		self.all_col_ids = sorted(self.required_col_ids + self.existing_col_ids)
		self.generate_sql()		
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


	def get_required_cols(self):
		sql = f"""select ordinal_position, a.column_name, a.data_type, a.character_maximum_length
				from information_schema.columns a join public.{self.dataset.ust_or_release}_required_view_columns b 
					on a.table_name = b.table_name and a.column_name = b.column_name
				where table_schema = 'public' and a.table_name = %s 
				and b.column_name not in 
					(select epa_column_name from public.v_{self.dataset.ust_or_release}_table_population_sql
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
			

	def get_existing_cols(self):
		sql = f"""select epa_column_name, 
				   data_type, character_maximum_length,
				   organization_table_name, organization_column_name,
				   selected_column, 
				   organization_join_table, organization_join_column, organization_join_fk,
				   database_lookup_table, database_lookup_column,
				   deagg_table_name, deagg_column_name,
				   column_sort_order, programmer_comments, primary_key
			from public.v_{self.dataset.ust_or_release}_table_population_sql
			where {self.dataset.ust_or_release}_control_id = %s and epa_table_name = %s
			order by column_sort_order """
		self.cur.execute(sql, (self.dataset.control_id, self.table_name))
		existing_col_info = self.cur.fetchall()
		if not existing_col_info:
			logger.warning('No elements have been mapped for EPA table %s. Exiting...', self.table_name)
			self.disconnect_db()
			exit()
		self.existing_col_ids = [c[13] for c in existing_col_info]
		existing_cols = {}
		for existing_col in existing_col_info:
			column_id = existing_col[13]
			column_name = existing_col[0]
			selected_column = existing_col[5]
			programmer_comments = existing_col[14]
			if programmer_comments:
				programmer_comments = '	  -- ' + programmer_comments
			else:
				programmer_comments = ''
			existing_cols[column_id] = {'column_name': column_name, 
			                            'selected_column': selected_column, 
			                            'programmer_comments': programmer_comments}		
		return existing_cols


	def get_join_info(self, organization_table_name):
		sql = f"""select organization_column_name, organization_join_table, organization_join_column, organization_join_fk
           from public.v_{self.dataset.ust_or_release}_table_population_sql
           where {self.dataset.ust_or_release}_control_id = %s 
           and epa_table_name = %s and organization_table_name = %s"""
		self.cur.execute(sql, (self.dataset.control_id, self.table_name, organization_table_name))		
		# utils.pretty_print_query(self.cur)	
		cols = self.cur.fetchone()
		join_info = {}
		join_info['organization_column_name'] = cols[0]
		join_info['organization_join_table'] = cols[1]
		join_info['organization_join_column'] = cols[2]
		join_info['organization_join_fk'] = cols[3]
		return join_info


	def build_select_query(self):
		self.view_sql = self.view_sql + 'select distinct\n'
		region_next = False 
		for i in range(len(self.all_col_ids)):
			# deal with EPARegion column if in ust_facility and the last column was FacilityState
			if region_next:
				epa_region = None 
				selected_column = str(utils.get_epa_region(self.dataset.organization_id)) + '::integer as facility_epa_region,'
				self.view_sql = self.view_sql + '\t' + selected_column + '\n'
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
		sql = f"""select * from (
					   select distinct organization_table_name table_name, 'org_table' as table_type, 1 as sort_order
					  from public.v_{self.dataset.ust_or_release}_table_population_sql
					  where {self.dataset.ust_or_release}_control_id = %s and epa_table_name = %s and primary_key = 'Y'
					  union all 
					  select distinct organization_table_name table_name, 'org_table' as table_type, 2 as sort_order
					  from public.v_{self.dataset.ust_or_release}_table_population_sql
					  where {self.dataset.ust_or_release}_control_id = %s and epa_table_name = %s and primary_key is null 
					  and organization_table_name not in 
					  	(select organization_table_name from public.v_ust_table_population_sql
					  	where {self.dataset.ust_or_release}_control_id = %s and epa_table_name = %s and primary_key = 'Y')
			          union all 
			          select distinct deagg_table_name, 'deagg_table' as table_type, 2 as sort_order  
			          from public.v_{self.dataset.ust_or_release}_table_population_sql
			          where {self.dataset.ust_or_release}_control_id = %s and epa_table_name = %s 
			          union all 
			          select distinct organization_join_table, 'join_table' as table_type, 3 as sort_order  
			          from public.v_{self.dataset.ust_or_release}_table_population_sql
			          where {self.dataset.ust_or_release}_control_id = %s and epa_table_name = %s 
			          union all 
			          select distinct database_lookup_table, 'lookup_table' as table_type, 4 as sort_order  
			          from public.v_{self.dataset.ust_or_release}_table_population_sql
			          where {self.dataset.ust_or_release}_control_id = %s and epa_table_name = %s) x
		          where table_name is not null 
		          order by sort_order"""
		self.cur.execute(sql, (self.dataset.control_id, self.table_name, self.dataset.control_id, self.table_name, self.dataset.control_id, self.table_name, self.dataset.control_id, self.table_name, self.dataset.control_id, self.table_name, self.dataset.control_id, self.table_name))
		# utils.pretty_print_query(self.cur)
		rows = self.cur.fetchall()
		aliases = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']
		i = 0 
		from_sql = ''
		first_org_table = True
		tables_used = []
		for row in rows:
			from_table_name = row[0]
			from_table_type = row[1]
			if from_table_name in tables_used:
				continue
			logger.info('Working on from_table_name %s, which is a %s', from_table_name, from_table_type)
			alias = aliases[i]
			if from_table_type == 'org_table':
				if not first_org_table:
					from_sql = from_sql + '\tleft join '				
				from_sql = from_sql + self.dataset.schema + '.' + '"' + from_table_name + '" ' + alias
				if not first_org_table:
					join_info = self.get_join_info(from_table_name)
					from_sql = from_sql + ' on ' + aliases[i-1] + '."' + join_info['organization_join_column'] + '" = ' + alias + '."' + join_info['organization_join_fk'] + '"'
				else:
					first_org_table = False
				from_sql = from_sql  + '\n'
			elif from_table_type == 'deagg_table':
				sql = f"""select deagg_column_name, organization_column_name from public.v_{self.dataset.ust_or_release}_table_population_sql
				           where {self.dataset.ust_or_release}_control_id = %s and epa_table_name = %s and deagg_table_name = %s """
				cur.execute(sql, (self.dataset.control_id, self.table_name, from_table_name))
				cols = self.cur.fetchone()
				deagg_column_name = cols[0]
				organization_column_name = cols[1]
				from_sql = from_sql + '\tjoin ' + self.dataset.schema + '.' + from_table_name + ' ' + alias + ' on a."' + organization_column_name + '" = ' + alias + '."' + deagg_column_name + '"\n'
			elif from_table_type == 'join_table': 
				join_info = self.get_join_info()
				from_sql = from_sql + '\tleft join ' + self.dataset.schema + '."' + from_table_name + '" ' 
				from_sql = from_sql + alias + ' on a."' + join_info['organization_column_name'] + '" = ' 
				from_sql = from_sql + alias + '."' + join_info['organization_join_column'] + '"\n'
			elif from_table_type == 'lookup_table':
				sql = f"""select database_lookup_column, organization_column_name from public.v_{self.dataset.ust_or_release}_table_population_sql
				           where {self.dataset.ust_or_release}_control_id = %s and epa_table_name = %s and database_lookup_table = %s """
				self.cur.execute(sql, (self.dataset.control_id, self.table_name, from_table_name))
				cols = self.cur.fetchone()
				database_lookup_column = cols[0]
				organization_column_name = cols[1]
				xwalk_view_name = 'v_' + database_lookup_column + '_xwalk'
				if database_lookup_column == 'facility_type1' or database_lookup_column == 'facility_type2':
					database_lookup_column == 'facility_type_id'
				from_sql = from_sql + '\tleft join ' + self.dataset.schema + '.' + xwalk_view_name + ' ' + alias + ' on a."' + organization_column_name + '" = ' + alias + '.organization_value\n'
			i += 1
			tables_used.append(from_table_name)
		self.view_sql = self.view_sql + from_sql[:-1] + ';\n\n'


	def generate_sql(self):
		self.view_sql = self.view_sql + f'create view {self.dataset.schema}.{self.view_name} as\n'
		self.build_select_query()
		self.build_from_query()
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
