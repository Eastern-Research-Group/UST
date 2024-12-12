from datetime import datetime
import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

from python.util import utils
from python.util.dataset import Dataset 
from python.util.logger_factory import logger


ust_or_release = 'ust' 			# valid values are 'ust' or 'release'
control_id = 0                  # Enter an integer that is the ust_control_id or release_control_id
only_incomplete = True   		# Boolean, set to True to restrict the output to EPA columns that have not yet been value mapped or False to output mapping for all columns

# These variables can usually be left unset. This script will general a SQL file in the appropriate state folder in the repo under /ust/sql/states
export_file_path = None         
export_file_dir = None
export_file_name = None


class DeaggCode:
	deagg_sql = '' 
	
	def __init__(self, 
				 dataset, 
				 only_incomplete=False):
		self.dataset = dataset
		self.only_incomplete = only_incomplete
		self.generate_sql()
		if self.deagg_sql:
			self.write_sql()
		else:
			logger.info('No state values found that appear to need to be deaggregated. This script will not generate a file.')
	

	def generate_sql(self):
		conn = utils.connect_db()
		cur = conn.cursor()

		sql = f"""select epa_table_name, epa_column_name, organization_table_name, organization_column_name
				from public.v_{self.dataset.ust_or_release}_needed_mapping a join public.{self.dataset.ust_or_release}_element_table_sort_order b 
					on a.epa_table_name = b.table_name
				where {self.dataset.ust_or_release}_control_id = %s and db_lookup = 'Y'"""
		if self.only_incomplete:
			sql = sql + " and mapping_complete = 'N'"
		sql = sql + " order by sort_order, epa_column_name"""
		cur.execute(sql, (self.dataset.control_id,))
		rows = cur.fetchall()
		for row in rows:
			epa_table_name = row[0]
			epa_column_name = row[1] 
			org_table_name = row[2]
			org_column_name = row[3]

			logger.info('Checking %s."%s"."%s" to see if it may need to be deaggregated', self.dataset.schema, org_table_name, org_column_name)
	
			sql2 = f"""select distinct "{org_column_name}" from {self.dataset.schema}."{org_table_name}" where "{org_column_name}" is not null order by 1"""

			cur.execute(sql2)
			rows2 = cur.fetchall()
			deagg_flag = False
			delimiter = None 
			for row2 in rows2:
				org_value = row2[0]
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
				self.deagg_sql = self.deagg_sql + '------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n'
				logger.info("It appears possible we may need to deaggregate the organization values for %s; generating deagg code...\n", epa_column_name)

				self.deagg_sql = self.deagg_sql + f'/* ORGANIZATION VALUES MAY NEED TO BE DEAGGREGATED for {epa_table_name}.{epa_column_name}!\n * \n'
				self.deagg_sql = self.deagg_sql + f' * Schema = "{self.dataset.schema}"\n'
				self.deagg_sql = self.deagg_sql + f' * Organization table name = "{org_table_name}"\n'
				self.deagg_sql = self.deagg_sql + f' * Organization column name = "{org_column_name}"\n'
				self.deagg_sql = self.deagg_sql + ' * Review the organization values below. If there are multiple values in a single row, the values need to be deaggregated before proceeding.\n */\n\n'
				self.deagg_sql = self.deagg_sql + f'--{sql2};\n/* Organization values:\n'
				for row2 in rows2:
					org_value = row2[0]
					self.deagg_sql = self.deagg_sql + repr(org_value) + '\n'
				self.deagg_sql = self.deagg_sql + ' */\n\n'

				self.deagg_sql = self.deagg_sql + '/* IF after reviewing the organization values, you determine that there are in fact multiple values per row,\n'
				self.deagg_sql = self.deagg_sql + ' * run deagg.py, setting the variables below.\n'
				self.deagg_sql = self.deagg_sql + ' * Setting variable deagg_rows to the default value of True will run deagg_rows.py after running\n'
				self.deagg_sql = self.deagg_sql + ' * deagg.py, which is usually the behavior you will want.\n'
				self.deagg_sql = self.deagg_sql + f' * Both scripts will automatically update public.{self.dataset.ust_or_release}_element_mapping to to map the new deagg table(s).\n\n'

				script_params = f"ust_or_release = '{self.dataset.ust_or_release}' 			# Valid values are 'ust' or 'release'\n"
				script_params = script_params + f"control_id = {self.dataset.control_id}                  # Enter an integer that is the ust_control_id or release_control_id\n"
				script_params = script_params + f"data_table_name = '{org_table_name}' 			# Enter a string containing organization table name\n"
				script_params = script_params + f"column_name = '{org_column_name}'				# Enter a string containing organization column name\n"
				script_params = script_params + f"delimiter = {repr(delimiter)} 				" + "# Defaults to ','; delimiter from the column beging deaggregated in the state table. Use '\n' for hard returns.".encode("unicode_escape").decode("utf-8") + '\n'
				script_params = script_params + f"drop_existing = False 			# Boolean, defaults to False; if True will drop existing deagg table with the same name\n"
				script_params = script_params + f"deagg_rows = True				# Boolean, defaults to True. If True will automatically execute the deagg_rows.py scripts after executing this script.\n"
				self.deagg_sql = self.deagg_sql + script_params + '\n\n'

				# deagg_table_name = utils.get_deagg_table_name(org_column_name)
				# deagg_row_table_name = utils.get_deagg_datarows_table_name(deagg_table_name)
				# self.deagg_sql = self.deagg_sql + '* After running deagg.py, run the SQL below to view the value deagg table:\n*/\n'
				# self.deagg_sql = self.deagg_sql + f'select * from {self.dataset.schema}.{deagg_table_name} order by 2;\n\n'
				# self.deagg_sql = self.deagg_sql + '/* Next, run script deagg_rows.py to crosswalk the deaggreated value to facility, tank, or compartment-level rows.\n'
				# self.deagg_sql = self.deagg_sql + ' * Set the script variables below, substituting XXXXX and ZZZZZ\nfor a list of the columns in the SOURCE data you need to group by (e.g. ["FacilityID","TankID","ComartmentID"]).\n\n'

				# script_params = f"ust_or_release = '{self.dataset.ust_or_release}' 			# Valid values are 'ust' or 'release'\n"
				# script_params = script_params + f"control_id = {self.dataset.control_id}                 # Enter an integer that is the ust_control_id or release_control_id\n"
				# script_params = script_params + f"data_table_name = '{org_table_name}' 			# Enter a string containing organization table name that contains the aggregated data \n" 
				# script_params = script_params + f"data_table_pk_cols = ['XXXXX','ZZZZZ'] 		# Python list of column names FROM THE SOURCE DATA that the new table should be grouped by, for example, in UST, substances may be grouped by ['FacilityID','TankID'] or ['FacilityID','TankID','CompartmentID'] \n"
				# script_params = script_params + f"data_deagg_column_name = '{org_column_name}' 	# Column name FROM THE SOURCE DATA that contains the aggregated values \n"
				# script_params = script_params + f"delimiter = {repr(delimiter)} 				" + "# Defaults to ', '; delimiter from the column beging deaggregated in the source table. Use '\n' for hard returns.".encode("unicode_escape").decode("utf-8") + '\n'
				# script_params = script_params + f"deagg_table_name = '{deagg_table_name}'           # Deagg table name generated by deagg.py. It will begin with an 'erg_' prefix. Check column deagg_table_name in table ust_element_mapping or release_element_mapping if you don't know it. (deagg.py will set this value.)\n"
				# script_params = script_params + f"drop_existing = False 			# Boolean, defaults to False. Set to True to drop the _datarows_deagg table that this script creates before beginning (for example, if you need to rerun this script)\n"

				# self.deagg_sql = self.deagg_sql + script_params + '\n\n'
				# self.deagg_sql = self.deagg_sql + ' * After running deagg_rows.py, run the SQL below to view the rows deagg table:\n */\n'
				# self.deagg_sql = self.deagg_sql + f'select * from {self.dataset.schema}.{deagg_row_table_name} order by 2;\n\n'
				
				self.deagg_sql = self.deagg_sql + '------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n'
	
		cur.close()
		conn.close()
	

	def write_sql(self):
		with open(self.dataset.export_file_path, 'w', encoding='utf-8') as f:
			f.write(self.deagg_sql)



def main(ust_or_release, control_id, only_incomplete=False, export_file_name=None, export_file_dir=None, export_file_path=None):
	dataset = Dataset(ust_or_release=ust_or_release,
				 	  control_id=control_id, 
				 	  base_file_name='deagg.sql',
					  export_file_name=export_file_name,
					  export_file_dir=export_file_dir,
					  export_file_path=export_file_path)

	export = DeaggCode(dataset=dataset, only_incomplete=only_incomplete)



if __name__ == '__main__':   
	main(ust_or_release=ust_or_release,
		 control_id=control_id, 
		 only_incomplete=only_incomplete,
		 export_file_name=export_file_name,
		 export_file_dir=export_file_dir,
		 export_file_path=export_file_path)
