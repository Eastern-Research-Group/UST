import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import pandas as pd
import re

from python.state_processing.find_unregulated import Unregulated
from python.util import utils
from python.util.dataset import Dataset 
from python.util.logger_factory import logger

ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = 0                	# Enter an integer that is the ust_control_id or release_control_id
find_regulated = True          	# Boolean; defauls to True. Set to False if the unregulated tanks and facilites tables already exist in the state schema and do not need to be updated. 
execute_sql = False            	# Boolean; defaults to False. Set to True to execute the SQL that replaces the views in the database; False to export the new view SQL to file without executing it in the database. 
export_sql = True              	# Boolean; defaults to True. If True will generate a SQL file containing the 'create or replace view' statements.
view_name = None                # String; defaults to None. To limit output to a single view, enter view name (e.g. "v_ust_tank_substance").

# These variables can usually be left unset. This script will general a SQL file in the appropriate state folder in the repo under /ust/sql/states
export_file_path = None
export_file_dir = None
export_file_name = None

class Exclude:
	conn = None 
	cur = None 
	df = None 
	view_def = None 
	value_mapping_sql = '------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
	facility_id_column = None 
	child_id_column = None 
	facility_table_alias = None 
	child_table_alias = None 	

	def __init__(self, 
				 dataset,
				 find_regulated=True,
				 execute_sql=False,
				 export_sql=True,
				 view_name=None):
		self.dataset = dataset
		self.find_regulated = find_regulated
		self.execute_sql = execute_sql
		self.export_sql = export_sql
		self.view_name = view_name


	def execute(self):
		self.connect_db()

		if self.find_regulated:
			Unregulated(self.dataset, drop_existing=True).execute()

		self.df = self.get_columns()
		views = ['v_' + v for v in self.df['epa_table_name'].unique()]
		for view in views:
			logger.info('Working on view %s', view)
			self.view_def = self.get_new_view_def(view)
			if self.execute_sql:
				utils.process_sql(self.conn, self.cur, self.view_def)
				logger.info('Replaced view %s.%s', self.dataset.schema, view)

			self.value_mapping_sql = self.value_mapping_sql + '\n\n' + self.view_def

		self.disconnect_db()

		if self.export_sql:
			self.write_sql()


	def get_columns(self):
		sql = f"""select a.epa_table_name, a.epa_column_name, b.table_name, b.column_name, table_sort_order, column_sort_order
				 from public.{self.dataset.ust_or_release}_element_mapping a left join information_schema.columns b 
					on lower(a.organization_table_name) = lower(b.table_name) and lower(a.organization_column_name) = lower(b.column_name)
					left join public.v_{self.dataset.ust_or_release}_element_metadata c on a.epa_table_name = c.table_name and a.epa_column_name = c.column_name
				 where a.{self.dataset.ust_or_release}_control_id = {self.dataset.control_id} 
				 and b.table_schema = '{self.dataset.schema}' and a.epa_column_name in ('facility_id','tank_id','release_id') """
		if self.view_name:
			sql = sql + f""" and epa_table_name = '{self.view_name.replace("v_","")}' """
		sql = sql + " order by c.table_sort_order, c.column_sort_order"
		df = pd.read_sql(sql, con=utils.get_engine())
		return df 


	def get_view_def(self, view_name):
		sql = "select public.get_view_def(%s, %s)"
		utils.process_sql(self.conn, self.cur, sql, params=(view_name, self.dataset.schema))
		view_def = f'\n\ncreate or replace view {self.dataset.schema}.{view_name} as\n' 
		view_def = view_def + self.cur.fetchone()[0].replace(';','')
		return view_def


	def get_new_view_def(self, view_name):
		table = view_name.replace('v_','')
		view_def = self.get_view_def(view_name)
		if 'WHERE' in view_def:
			view_def = view_def + '\n and '
		else:
			view_def = view_def + '\n where '
		filtered_df = self.df.query(f"epa_table_name == '{table}' & epa_column_name == 'facility_id'")

		if view_name == 'v_ust_facility' or view_name == 'v_ust_release' or view_name == 'v_ust_facility_dispenser':
			self.facility_id_column = filtered_df['column_name'].iloc[0]
			from_table = self.dataset.schema + '.' + str(filtered_df['table_name'].iloc[0])
			self.facility_table_alias = get_table_alias(self.get_view_def(view_name), from_table)
			view_def = view_def + f'{self.facility_table_alias}."{self.facility_id_column}"::varchar(50) not in (select facility_id from {self.dataset.schema}.erg_unregulated_facilities)'
		else:
			if len(filtered_df) > 0:
				self.facility_id_column = filtered_df['column_name'].iloc[0]
				from_table =  self.dataset.schema + '.' + str(filtered_df['table_name'].iloc[0])
				self.facility_table_alias = get_table_alias(self.get_view_def(view_name), from_table)
			
			if self.dataset.ust_or_release == 'ust':
				epa_column_name = 'tank_id'
				type = 'tanks'
				data_type = 'int'
			else:
				epa_column_name = 'release_id'
				type = 'releases'
				data_type = 'varchar(50)'
			filtered_df = self.df.query(f"epa_table_name == '{table}' & epa_column_name == '{epa_column_name}'")

			if len(filtered_df) > 0:
				self.child_id_column = filtered_df['column_name'].iloc[0]
				from_table = self.dataset.schema + '.' + str(filtered_df['table_name'].iloc[0])
				self.child_table_alias = get_table_alias(self.get_view_def(view_name), from_table)		

				
			view_def = view_def + f"not exists\n\t(select 1 from {self.dataset.schema}.erg_unregulated_{type} unreg"
			view_def = view_def + f'\n\twhere {self.facility_table_alias}."{self.facility_id_column}"::varchar(50) = unreg.facility_id and {self.child_table_alias}."{self.child_id_column}"::{data_type} = unreg.{epa_column_name})'
		if view_def[:-1] != ';':
			view_def = view_def + ';'

		return view_def   


	def write_sql(self):
		with open(self.dataset.export_file_path, 'w', encoding='utf-8') as f:
			f.write(self.value_mapping_sql)
		logger.info('Write SQL file to %s', self.dataset.export_file_path)


	def connect_db(self):
		self.conn = utils.connect_db()
		self.cur = self.conn.cursor()
		logger.info('Connected to database')
		

	def disconnect_db(self):
		self.cur.close()
		self.conn.close()
		logger.info('Disconnected from database')



def get_table_alias(view_def, from_table):
	table_def = view_def.replace('"','')
	i = table_def.find(from_table)
	i2 = i + table_def[i:].find('\n')
	table_def = table_def[i:i2]
	table_def = table_def.replace(from_table,'').strip()
	i = table_def.find(' ')
	if i > 0:
		table_def = table_def[:i]
	# if not table_def:
	# 	table_def = from_table
	return table_def.strip()



def main(ust_or_release, 
		 control_id, 
		 find_regulated=True, 
		 execute_sql=False,
		 export_sql=True,
		 export_file_path=None, 
		 export_file_dir=None,
		 export_file_name=None,
		 view_name=None):
	dataset = Dataset(ust_or_release=ust_or_release,
					  control_id=control_id,
					  requires_export=True,
		              base_file_name='view_definitions.sql',
					  export_file_path=export_file_path,
					  export_file_dir=export_file_dir,
					  export_file_name=export_file_name)

	Exclude(dataset, find_regulated=find_regulated, execute_sql=execute_sql, export_sql=export_sql, view_name=view_name).execute()


if __name__ == '__main__':   
	main(ust_or_release=ust_or_release,
		 control_id=control_id,
		 find_regulated=find_regulated,
		 execute_sql=execute_sql,
		 export_sql=export_sql,
		 export_file_path=export_file_path,
		 export_file_dir=export_file_dir,
		 export_file_name=export_file_name,
		 view_name=view_name)

