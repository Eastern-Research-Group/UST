from datetime import datetime
import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

from python.util import utils
from python.util.dataset import Dataset 
from python.util.logger_factory import logger


ust_or_release = 'ust' # valid values are 'ust' or 'release'
control_id = 11
only_incomplete = False # Set to True to restrict the output to EPA columns that have not yet been value mapped or False to output mapping for all columns

export_file_path = None
export_file_dir = None
export_file_name = None


class ValueMapper:
	value_mapping_sql = '------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n'
	
	def __init__(self, 
				 dataset, 
				 only_incomplete=False):
		self.dataset = dataset
		self.only_incomplete = only_incomplete
	

		def generate_sql(self):
			conn = utils.connect_db()
			cur = conn.cursor()

			sql = f"""select a.epa_table_name, a.epa_column_name, organization_table_name, organization_column_name, 
					 	database_lookup_table, database_lookup_column, mapping_complete
					from public.{self.dataset.ust_or_release}_element_mapping a join public.{self.dataset.ust_or_release}_elements b
						on a.epa_column_name = b.database_column_name  
						join public.{self.dataset.ust_or_release}_elements_tables c on a.epa_table_name = c.table_name and b.element_id = c.element_id
						join public.{self.dataset.ust_or_release}_element_table_sort_order d on a.epa_table_name = d.table_name
						join public.v_{self.dataset.ust_or_release}_needed_mapping_summary e on a.ust_element_mapping_id = e.ust_element_mapping_id 
					where a.{self.dataset.ust_or_release}_control_id = %s and b.database_lookup_table is not null"""
			if self.only_incomplete:
				sql = sql + " and mapping_complete = 'N'"
			sql = sql + " order by d.sort_order, c.sort_order"""
			cur.execute(sql, (self.dataset.control_id,))
			rows = cur.fetchall()
			for row in rows:
				epa_table_name = row[0]
				epa_column_name = row[1] 
				org_table_name = row[2]
				org_column_name = row[3]
				db_table_name = row[4]
				db_column_name = row[5]

				self.value_mapping_sql = self.value_mapping_sql + '--' + epa_column_name + '\n\n'
		
				sql2 = f"""select distinct "{org_column_name}" from {self.dataset.schema}."{org_table_name}" where "{org_column_name}" is not null order by 1"""
				self.value_mapping_sql = self.value_mapping_sql + '--' + sql2 + ';\n/* Organization values are:\n\n'
				cur.execute(sql2)
				rows2 = cur.fetchall()
				deagg_flag = False
				delimiter = None 
				deagg_table_name = None  
				deagg_row_table_name = None 
				for row2 in rows2:
					org_value = row2[0]
					self.value_mapping_sql = self.value_mapping_sql + org_value + '\n'
					if ',' in org_value or ';' in org_value or ' /' in org_value or '/ ' in org_value or '\n' in org_value or '\r' in org_value:
						deagg_flag = True
						if ', ' in org_value:
							delimiter = ', '
						elif ',' in org_value:
							delimiter = ','
						elif '; ' in org_value:
							delimiter = '; '
						elif ';' in org_value:
							delimiter = ';'
						elif ' / ' in org_value:
							delimiter = ' / '
						elif '/ ' in org_value:
							delimiter = '/ '
						elif ' /' in org_value:
							delimiter = ' /'
						elif '\n\r' in org_value:
							delimiter = '\n\r'
						elif '\n' in org_value:
							delimiter = '\n'
						elif '\r' in org_value:
							delimiter = '\r'

			if deagg_flag:
				logger.info("It appears possible we may need to deaggregate the organization values for %s; generating deagg code...", epa_column_name)

				self.value_mapping_sql = self.value_mapping_sql + '--ORGANIZATION VALUES MAY NEED TO BE DEAGGREGATED!\n'
				self.value_mapping_sql = self.value_mapping_sql + '--Review the organization values above. If there are multiple values in a single row, the values need to be deaggregated before proceeding.\n'
				self.value_mapping_sql = self.value_mapping_sql + '--If there is a space before or after the delimiter in the organization value, INCLUDE the space in your delimiter variable.\n\n/*\n'

				self.value_mapping_sql = self.value_mapping_sql + 'To deaggregate the organization values run deagg.py, setting the variables below:\n\n'

				script_params = f"ust_or_release = '{self.ust_or_release}' # valid values are 'ust' or 'release'\n"
				script_params = script_params + f'control_id = {self.control_id}\n'
				script_params = script_params + f"table_name = '{org_table_name}'\n"
				script_params = script_params + f"column_name = '{org_column_name}' \n"
				script_params = script_params + f"delimiter = '{delimiter}' # defaults to ','; delimiter from the column beging deaggregated in the state table. Use \\n for hard returns.\n"
				script_params = script_params + 'drop_existing = True # defaults to False; if True will drop existing deagg table with the same name\n'

				self.value_mapping_sql = self.value_mapping_sql + script_params + '\n\n'
				self.value_mapping_sql = self.value_mapping_sql + 'After running deagg.py, run the SQL below to view the value deagg table:\n*/\n'
				self.value_mapping_sql = self.value_mapping_sql + f'select * from {self.schema}.{deagg_table_name} order by 2;\n\n'

				self.value_mapping_sql = self.value_mapping_sql + '/*\nNext, run script deagg_rows.py to create deaggregate the facility, tank, or compartment-level rows. Set the script variables below, substituting XXXXX and ZZZZZ\nfor a list of the columns in the source data you need to group by (e.g. ["FacilityID","TankID","ComartmentID"]).\n\n'

				script_params = f"ust_or_release = '{self.ust_or_release}' # valid values are 'ust' or 'release'\n"
				script_params = script_params + f'control_id = {self.control_id}\n'
				script_params = script_params + f"data_table_name = '{org_table_name}'\n"
				script_params = script_params + f"data_table_pk_cols = ['XXXXX','ZZZZZ'] # list of column names that the new table should be grouped by \n"
				script_params = script_params + f"delimiter = '{delimiter}' # defaults to ','; delimiter from the column beging deaggregated in the state table. Use \\n for hard returns.\n"
				script_params = script_params + f"deagg_table_name = '{deagg_table_name}'\n"
				script_params = script_params + 'drop_existing = True # defaults to False. Set to True to drop the _datarows_deagg table before beginning (if you need to redo it)\n'

				self.value_mapping_sql = self.value_mapping_sql + script_params + '\n\n'
				self.value_mapping_sql = self.value_mapping_sql + 'After running deagg_rows.py, run the SQL below to view the rows deagg table:\n*/\n'
				self.value_mapping_sql = self.value_mapping_sql + f'select * from {self.schema}.{deagg_row_table_name} order by 2;\n\n'
				self.value_mapping_sql = self.value_mapping_sql + f'/*\nNow, go back and update table public.{self.ust_or_release}_element_mapping to point to the deaggregated data:\n*/\n'

				# self.value_mapping_sql = self.value_mapping_sql + f"update public.{self.ust_or_release}_element_mapping set deagg_table_name = '{deagg_table_name}', deagg_column_name = '{org_column_name}'\n" 
				# self.value_mapping_sql = self.value_mapping_sql + f"where {self.ust_or_release}_control_id = {self.control_id} and epa_column_name = '{epa_column_name}';\n\n"

			cur.close()
			conn.close()




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
