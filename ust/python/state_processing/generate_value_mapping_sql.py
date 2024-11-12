from datetime import datetime
import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

from python.util import utils
from python.util.dataset import Dataset 
from python.util.logger_factory import logger


ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = 24                  # Enter an integer that is the ust_control_id or release_control_id
only_incomplete = True   		# Boolean, defaults to True. Set to False to output mapping for all columns regardless if mapping was previously done. 
overwrite_existing = False      # boolean, defaults to False. Set to True to overwrite existing generated SQL file. If False, will append an existing file.

# These variables can usually be left unset. This script will general a SQL file in the appropriate state folder in the repo under /ust/sql/states
export_file_path = None
export_file_dir = None
export_file_name = None


class ValueMapper:
	value_mapping_sql = '------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n'
	organization_compartment_flag = None 	

	def __init__(self, 
				 dataset, 
				 only_incomplete=True,
				 overwrite_existing=False):
		self.dataset = dataset
		self.only_incomplete = only_incomplete
		self.overwrite_existing = overwrite_existing
		self.set_compartment_flag()
		self.generate_sql()
		self.write_sql()


	def set_compartment_flag(self):
		if self.dataset.ust_or_release == 'ust':
			conn = utils.connect_db()
			cur = conn.cursor()
			sql = "select organization_compartment_flag from public.ust_control where ust_control_id = %s"
			cur.execute(sql, (self.dataset.control_id,))
			self.organization_compartment_flag = cur.fetchone()[0]
			cur.close()
			conn.close()
	

	def generate_sql(self):
		conn = utils.connect_db()
		cur = conn.cursor()

		sql = f"""select epa_column_name from 
				(select distinct epa_table_name, epa_column_name, table_sort_order, column_sort_order
				from public.v_{self.dataset.ust_or_release}_needed_mapping 
				where {self.dataset.ust_or_release}_control_id = %s """
		if self.only_incomplete:
			sql = sql + "and mapping_complete = 'N'"
		sql = sql + "order by table_sort_order, column_sort_order) x"
		cur.execute(sql, (self.dataset.control_id,))
		rows = cur.fetchall()
		for row in rows:
			epa_column_name = row[0]
			logger.info('Generating mapping SQL for %s', epa_column_name)

			self.value_mapping_sql = self.value_mapping_sql + '------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n'
			self.value_mapping_sql = self.value_mapping_sql + '--' + epa_column_name + '\n\n'
		
			if epa_column_name == 'compartment_status_id' and self.organization_compartment_flag == 'N':
				self.value_mapping_sql = self.value_mapping_sql + f'/*\n{self.dataset.organization_id} does not report at the Compartment level, but CompartmentStatus is required.\n'
				self.value_mapping_sql = self.value_mapping_sql + f'\nCopy the tank status mapping down to the compartment!\n'
				self.value_mapping_sql = self.value_mapping_sql + 'The lookup tables for compartment_statuses and tank_stasuses are the same.\n */\n\n'
				
			sql2 = f"""select {self.dataset.ust_or_release}_element_mapping_id, organization_table_name, organization_column_name, deagg_table_name, deagg_column_name 
					from public.{self.dataset.ust_or_release}_element_mapping 
					where {self.dataset.ust_or_release}_control_id = %s and epa_column_name = %s"""
			cur.execute(sql2, (self.dataset.control_id, epa_column_name))
			row2 = cur.fetchone()
			element_mapping_id = row2[0]
			org_table_name = row2[1]
			org_column_name = row2[2]
			deagg_table_name = row2[3]
			deagg_column_name = row2[4]

			select_table = org_table_name
			select_col = org_column_name
			if deagg_table_name:
				select_table = deagg_table_name
				select_col = deagg_column_name

			sql3 = f"""select distinct "{select_col}" from {self.dataset.schema}."{select_table}" where "{select_col}" is not null order by 1"""
			self.value_mapping_sql = self.value_mapping_sql + '--' + sql3 + ';\n/* Organization values are:\n\n'
			cur.execute(sql3)
			rows3 = cur.fetchall()
			for row3 in rows3:
				org_value = row3[0]
				self.value_mapping_sql = self.value_mapping_sql + org_value + '\n'			
			self.value_mapping_sql = self.value_mapping_sql + ' */\n\n'
			self.value_mapping_sql = self.value_mapping_sql + '/*\n * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.\n'
			self.value_mapping_sql = self.value_mapping_sql + ' * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.\n */\n'
				
			sql4 = f"""select database_lookup_table, database_lookup_column 
						from public.{self.dataset.ust_or_release}_element_mapping a join public.{self.dataset.ust_or_release}_elements b on a.epa_column_name = b.database_column_name 
						where {self.dataset.ust_or_release}_control_id = %s and epa_column_name = %s"""
			cur.execute(sql4, (self.dataset.control_id, epa_column_name))
			row4 = cur.fetchone()
			db_lookup_table = row4[0]
			db_lookup_col = row4[1]	

			sql4 = f"""select distinct "{select_col}" from {self.dataset.schema}."{select_table}" where "{select_col}" is not null order by 1"""	
			cur.execute(sql4)
			rows4 = cur.fetchall()
			for row4 in rows4:
				org_value = row4[0]
				sql5 = f"""select {db_lookup_col} from public.{db_lookup_table} where replace(lower({db_lookup_col}),'-',' ') = %s"""
				cur.execute(sql5, (org_value.lower().replace('-',' '),))
				try:
					epa_value = cur.fetchone()[0]
				except:
					epa_value = None

				self.value_mapping_sql = self.value_mapping_sql + f'insert into public.{self.dataset.ust_or_release}_element_value_mapping ({self.dataset.ust_or_release}_element_mapping_id, organization_value, epa_value, programmer_comments)\n'
				if epa_value:
					self.value_mapping_sql = self.value_mapping_sql + f"values ({element_mapping_id}, {repr(org_value)}, '{epa_value}', null);\n"
				else:
					self.value_mapping_sql = self.value_mapping_sql + f"values ({element_mapping_id}, {repr(org_value)}, '', null);\n"

			if epa_column_name == 'substance_id':
				sql6 = "select substance from public.substances order by substance_group, substance"
			else:
				sql6 = f"""select {db_lookup_col} from public.{db_lookup_table}"""

			self.value_mapping_sql = self.value_mapping_sql + f'\n--{sql6};\n/* Valid EPA values are:\n\n'
			cur.execute(sql6)
			rows6 = cur.fetchall()
			for row6 in rows6:
				epa_val = row6[0]
				self.value_mapping_sql = self.value_mapping_sql + f"{epa_val}\n"

			self.value_mapping_sql = self.value_mapping_sql + '\n * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.\n'
			self.value_mapping_sql = self.value_mapping_sql + ' * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.\n\n'

			self.value_mapping_sql = self.value_mapping_sql + "select distinct organization_value, epa_value\n"
			self.value_mapping_sql = self.value_mapping_sql + f"from public.v_{self.dataset.ust_or_release}_element_mapping\n"
			self.value_mapping_sql = self.value_mapping_sql + f"where epa_column_name = '{epa_column_name}'\n"
			self.value_mapping_sql = self.value_mapping_sql + "and lower(organization_value) like lower('%XXXX%')\n"
			self.value_mapping_sql = self.value_mapping_sql + "order by 1, 2;\n\n"

			archive_view_name = f"archive.v_{self.dataset.ust_or_release.replace('release','lust')}_element_mapping"
			self.value_mapping_sql = self.value_mapping_sql + f' * You can also review the mapping from the pilot using a query similar to the above, looking in {archive_view_name}.\n'
			self.value_mapping_sql = self.value_mapping_sql + f' * Beware, however, that some of the lookup values have changed since the pilot so if you do use {archive_view_name}\n'
			self.value_mapping_sql = self.value_mapping_sql + f' * to do mapping, check public.{db_lookup_table} to find the updated epa_value.\n */\n\n'
		
		cur.close()
		conn.close()
		self.value_mapping_sql = self.value_mapping_sql + '------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n'
	

	def write_sql(self):
		wora = 'a'
		if self.overwrite_existing:
			wora = 'w'
		with open(self.dataset.export_file_path, wora, encoding='utf-8') as f:
			f.write(self.value_mapping_sql)



def main(ust_or_release, control_id, only_incomplete=False, export_file_name=None, export_file_dir=None, export_file_path=None):
	dataset = Dataset(ust_or_release=ust_or_release,
				 	  control_id=control_id, 
				 	  base_file_name='value_mapping.sql',
					  export_file_name=export_file_name,
					  export_file_dir=export_file_dir,
					  export_file_path=export_file_path)

	export = ValueMapper(dataset=dataset, only_incomplete=only_incomplete)



if __name__ == '__main__':   
	main(ust_or_release=ust_or_release,
		 control_id=control_id, 
		 only_incomplete=only_incomplete,
		 export_file_name=export_file_name,
		 export_file_dir=export_file_dir,
		 export_file_path=export_file_path)
