import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))
from datetime import datetime

from python.util.logger_factory import logger
from python.util import utils

ust_or_release = 'release' # valid values are 'ust' or 'release'
control_id = 5
only_incomplete = False # Set to true to restrict the output to EPA columns that have not yet been value mapped

export_file_path = None
export_file_dir = None
export_file_name = None


class ValueMapper:
	value_mapping_sql = '------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n'
	organization_compartment_flag = None 
	
	def __init__(self, 
				 ust_or_release, 
				 control_id, 
				 only_incomplete=False,
				 export_file_path=None, 
				 export_file_dir=None, 
				 export_file_name=None):
		self.ust_or_release = ust_or_release.lower()
		if self.ust_or_release not in ['ust','release']:
			logger.error("Unknown value '%s' for ust_or_release; valid values are 'ust' and 'release'. Exiting...", ust_or_release)
			exit()
		self.control_id = control_id
		self.only_incomplete = only_incomplete
		self.organization_id = utils.get_org_from_control_id(self.control_id, self.ust_or_release)
		self.schema = utils.get_schema_from_control_id(self.control_id, self.ust_or_release)
		self.export_file_name = export_file_name
		self.export_file_dir = export_file_dir
		self.export_file_path = export_file_path
		self.populate_export_vars()
		self.set_compartment_flag()	
		self.generate_sql()
		self.write_sql()


	def populate_export_vars(self):
		if not self.export_file_path and not self.export_file_path and not self.export_file_name:
			if self.ust_or_release == 'ust':
				uor = 'UST'
			elif self.ust_or_release == 'release':
				uor = 'Releases'
			self.export_file_name = self.organization_id.upper() + '_' + uor + '_value_mapping.sql'
			self.export_file_dir = '../../sql/states/' + self.organization_id.upper() + '/' + uor + '/'
			self.export_file_path = self.export_file_dir + self.export_file_name
			Path(self.export_file_dir).mkdir(parents=True, exist_ok=True)
		elif self.export_file_path:
			fp = ntpath.split(self.export_file_path)
			self.export_file_dir = fp[0]
			self.export_file_name = fp[1]
		elif self.export_file_dir and self.export_file_name:
			if self.export_file_name[-4:] != '.sql':
				self.export_file_name = self.export_file_name + '.sql'
			self.export_file_path = os.path.join(self.export_file_dir, self.export_file_name)
		logger.debug('export_file_name = %s; export_file_dir = %s; export_file_path = %s', self.export_file_name, self.export_file_dir, self.export_file_path)


	def set_compartment_flag(self):
		if self.ust_or_release == 'ust':
			conn = utils.connect_db()
			cur = conn.cursor()
			sql = "select organization_compartment_flag from public.ust_control where ust_control_id = %s"
			cur.execute(sql, (self.control_id,))
			self.organization_compartment_flag = cur.fetchone()[0]
			cur.close()
			conn.close()
	

	def generate_sql(self):
		conn = utils.connect_db()
		cur = conn.cursor()

		sql = f"""select epa_column_name from 
				(select distinct epa_table_name, epa_column_name, table_sort_order, column_sort_order
				from public.v_{self.ust_or_release}_needed_mapping 
				where {self.ust_or_release}_control_id = %s """
		if self.only_incomplete:
			sql = sql + "and mapping_complete = 'N'"
		sql = sql + "order by table_sort_order, column_sort_order) x"
		cur.execute(sql, (self.control_id,))
		rows = cur.fetchall()
		for row in rows:
			epa_column_name = row[0]
			logger.info('Generating mapping SQL for %s', epa_column_name)

			self.value_mapping_sql = self.value_mapping_sql + '------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n'
			self.value_mapping_sql = self.value_mapping_sql + '--' + epa_column_name + '\n\n'
		
			if epa_column_name == 'compartment_status_id' and self.organization_compartment_flag == 'N':
				self.value_mapping_sql = self.value_mapping_sql + f'/*\n{self.organization_id} does not report at the Compartment level, but CompartmentStatus is required.\n'
				self.value_mapping_sql = self.value_mapping_sql + f'\nCopy the tank status mapping down to the compartment!\n'
				self.value_mapping_sql = self.value_mapping_sql + 'The lookup tables for compartment_statuses and tank_stasuses are the same.\n*/\n\n'
				
			sql2 = f"""select {self.ust_or_release}_element_mapping_id, organization_table_name, organization_column_name 
					from public.{self.ust_or_release}_element_mapping 
					where {self.ust_or_release}_control_id = %s and epa_column_name = %s"""
			cur.execute(sql2, (self.control_id, epa_column_name))
			row2 = cur.fetchone()
			element_mapping_id = row2[0]
			org_table_name = row2[1]
			org_column_name = row2[2]

			sql3 = f"""select distinct "{org_column_name}" from {self.schema}."{org_table_name}" where "{org_column_name}" is not null order by 1"""
			self.value_mapping_sql = self.value_mapping_sql + '--' + sql3 + ';\n/* Organization values are:\n\n'
			cur.execute(sql3)
			rows3 = cur.fetchall()
			deagg_flag = False
			delimiter = None 
			deagg_table_name = None  
			deagg_row_table_name = None 
			for row3 in rows3:
				org_value = row3[0]
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

			self.value_mapping_sql = self.value_mapping_sql + '*/\n\n'
			if deagg_flag:
				logger.info("It appears possible we may need to deaggregate the organization values for %s; generating deagg code...", epa_column_name)

				deagg_table_name = f"erg_{org_column_name.lower().replace(' ','_')}_deagg"
				deagg_row_table_name = f"erg_{org_column_name.lower().replace(' ','_')}_datarows_deagg"

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

				self.value_mapping_sql = self.value_mapping_sql + f"update public.{self.ust_or_release}_element_mapping set deagg_table_name = '{deagg_table_name}', deagg_column_name = '{org_column_name}'\n" 
				self.value_mapping_sql = self.value_mapping_sql + f"where {self.ust_or_release}_control_id = {self.control_id} and epa_column_name = '{epa_column_name}';\n\n"

			self.value_mapping_sql = self.value_mapping_sql + '/*\nGo through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.\n'
			self.value_mapping_sql = self.value_mapping_sql + 'If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.\n*/\n'
				
			
			sql4 = f"""select database_lookup_table, database_lookup_column 
						from public.{self.ust_or_release}_element_mapping a join public.{self.ust_or_release}_elements b on a.epa_column_name = b.database_column_name 
						where {self.ust_or_release}_control_id = %s and epa_column_name = %s"""
			cur.execute(sql4, (self.control_id, epa_column_name))
			row4 = cur.fetchone()
			db_lookup_table = row4[0]
			db_lookup_col = row4[1]	

			s_table_name = org_table_name
			if deagg_table_name:
				sql4 = "select count(*) from information_schema.tables where table_schema = %s and table_name = %s"
				cur.execute(sql4, (self.schema, deagg_table_name))
				if cur.fetchone()[0] > 0:
					s_table_name = deagg_table_name
			sql4 = f"""select distinct "{org_column_name}" from {self.schema}."{s_table_name}" where "{org_column_name}" is not null order by 1"""	
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

				self.value_mapping_sql = self.value_mapping_sql + f'insert into public.{self.ust_or_release}_element_value_mapping ({self.ust_or_release}_element_mapping_id, organization_value, epa_value, programmer_comments)\n'
				if epa_value:
					self.value_mapping_sql = self.value_mapping_sql + f"values ({element_mapping_id}, '{org_value}', '{epa_value}', null);\n"
				else:
					self.value_mapping_sql = self.value_mapping_sql + f"values ({element_mapping_id}, '{org_value}', '', null);\n"

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

			self.value_mapping_sql = self.value_mapping_sql + '\nNeed some additional help with the mapping? See how similar fields have been mapped in other organizations.\n'
			self.value_mapping_sql = self.value_mapping_sql + 'Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.\n\n'

			self.value_mapping_sql = self.value_mapping_sql + "select distinct organization_value, epa_value\n"
			self.value_mapping_sql = self.value_mapping_sql + f"from public.v_{self.ust_or_release}_element_mapping\n"
			self.value_mapping_sql = self.value_mapping_sql + f"where epa_column_name = '{epa_column_name}'\n"
			self.value_mapping_sql = self.value_mapping_sql + "and lower(organization_value) like lower('%XXXX%')\n"
			self.value_mapping_sql = self.value_mapping_sql + "order by 1, 2;\n\n"

			archive_view_name = f"archive.v_{self.ust_or_release.replace('release','lust')}_element_mapping"
			self.value_mapping_sql = self.value_mapping_sql + f'You can also review the mapping from the pilot using a query similar to the above, looking in {archive_view_name}.\n'
			self.value_mapping_sql = self.value_mapping_sql + f'Beware, however, that some of the lookup values have changed since the pilot so if you do use {archive_view_name}\n'
			self.value_mapping_sql = self.value_mapping_sql + f'to do mapping, check public.{db_lookup_table} to find the updated epa_value.\n*/\n\n'
		
		cur.close()
		conn.close()
		self.value_mapping_sql = self.value_mapping_sql + '------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n'
	
		# print(self.value_mapping_sql)


	def write_sql(self):
		with open(self.export_file_path, 'w', encoding='utf-8') as f:
			f.write(self.value_mapping_sql)



def main(ust_or_release, control_id, export_file_name=None, export_file_dir=None, export_file_path=None):
	export = ValueMapper(ust_or_release=ust_or_release,
						 control_id=control_id,
						 export_file_name=export_file_name,
						 export_file_dir=export_file_dir,
						 export_file_path=export_file_path)



if __name__ == '__main__':   
	main(ust_or_release=ust_or_release,
		 control_id=control_id, 
		 export_file_name=export_file_name,
		 export_file_dir=export_file_dir,
		 export_file_path=export_file_path)
