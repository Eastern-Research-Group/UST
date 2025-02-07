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
control_id = 0                  # Enter an integer that is the ust_control_id or release_control_id
only_incomplete = True  		# Boolean, defaults to True. Set to False to output mapping for all columns regardless if mapping was previously done. 
overwrite_existing = False      # Boolean, defaults to False. Set to True to overwrite existing generated SQL file. If False, will append an existing file.

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
		self.inferred_values()
		self.write_sql()


	def set_compartment_flag(self):
		if self.dataset.ust_or_release == 'ust':
			conn = utils.connect_db()
			cur = conn.cursor()
			sql = "select organization_compartment_flag from public.ust_control where ust_control_id = %s"
			utils.process_sql(conn, cur, sql, params=(self.dataset.control_id,))
			self.organization_compartment_flag = cur.fetchone()[0]
			cur.close()
			conn.close()
	

	def generate_sql(self):
		conn = utils.connect_db()
		cur = conn.cursor()

		sql = f"""select epa_table_name, epa_column_name from 
				(select distinct epa_table_name, epa_column_name, table_sort_order, column_sort_order
				from public.v_{self.dataset.ust_or_release}_needed_mapping 
				where {self.dataset.ust_or_release}_control_id = %s """
		sql = sql + "order by table_sort_order, column_sort_order) x"
		utils.process_sql(conn, cur, sql, params=(self.dataset.control_id,))
		rows = cur.fetchall()
		for row in rows:
			epa_table_name = row[0]
			epa_column_name = row[1]
			logger.info('Working on %s', epa_column_name)

			msql =  '------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n'
			msql = msql + '--' + epa_column_name + '\n\n'
		
			if epa_column_name == 'compartment_status_id' and self.organization_compartment_flag == 'N':
				msql = msql + f'/*\n{self.dataset.organization_id} does not report at the Compartment level, but CompartmentStatus is required.\n'
				msql = msql + f'\nCopy the tank status mapping down to the compartment!\n'
				msql = msql + 'The lookup tables for compartment_statuses and tank_stasuses are the same.\n */\n\n'

			if epa_column_name == 'tank_status_id' and self.organization_compartment_flag == 'Y':
				sql = f"""select count(*) from public.ust_element_mapping a join public.ust_element_mapping b on a.ust_control_id = b.ust_control_id 
						and a.epa_column_name = 'tank_status_id' and b.epa_column_name = 'compartment_status_id'
						and a.organization_table_name = b.organization_table_name and a.organization_column_name = b.organization_column_name
						and (lower(b.organization_table_name) like '%%comp%%' or lower(b.organization_column_name) like '%%comp%%')
						and a.ust_control_id = %s"""
				utils.process_sql(conn, cur, sql, params=(self.dataset.control_id,))
				if cur.fetchone()[0] > 0:
					msql = msql + f'/*\nIt looks like it is possible that {self.dataset.organization_id} has compartment statuses but not tank statuses.\n'
					msql = msql + '\nTo roll the compartment status up to the tank level, see the status_hierarchy and status_comment columns of the compartment_statuses lookup table.'
					msql = msql +  '\nUse the SQL MIN() function on the status_hierarchy column to get the status for the tank, but also see the status_comment to rule out "impossible" scenarios\n */\n\n'
				
			sql2 = f"""select {self.dataset.ust_or_release}_element_mapping_id, organization_table_name, organization_column_name, deagg_table_name, deagg_column_name 
					from public.{self.dataset.ust_or_release}_element_mapping 
					where {self.dataset.ust_or_release}_control_id = %s and epa_column_name = %s"""
			utils.process_sql(conn, cur, sql2, params=(self.dataset.control_id, epa_column_name))
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
			msql = msql + '--' + sql3 + ';\n/* Organization values are:\n\n'
			utils.process_sql(conn, cur, sql3)
			rows3 = cur.fetchall()
			for row3 in rows3:
				org_value = str(row3[0])
				msql = msql + org_value + '\n'			
			msql = msql + ' */\n\n'
			msql = msql + '/*\n * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.\n'
			msql = msql + ' * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.\n */\n'
				
			sql4 = f"""select database_lookup_table, database_lookup_column 
						from public.{self.dataset.ust_or_release}_element_mapping a join public.{self.dataset.ust_or_release}_elements b on a.epa_column_name = b.database_column_name 
						where {self.dataset.ust_or_release}_control_id = %s and epa_column_name = %s"""
			utils.process_sql(conn, cur, sql4, params=(self.dataset.control_id, epa_column_name))
			row4 = cur.fetchone()
			db_lookup_table = row4[0]
			db_lookup_col = row4[1]	

			sql4 = f"""select distinct "{select_col}" from {self.dataset.schema}."{select_table}" where "{select_col}" is not null """
			if self.only_incomplete:
				sql4 = sql4 + f"""and "{select_col}"::varchar not in
						(select organization_value from public.v_{self.dataset.ust_or_release}_element_mapping
						where {self.dataset.ust_or_release}_control_id = {self.dataset.control_id} and epa_column_name = '{epa_column_name}'
						and organization_value is not null) """
			sql4 = sql4 + "order by 1"	
			utils.process_sql(conn, cur, sql4)
			rows4 = cur.fetchall()
			if not rows4:
				logger.info('No unmapped organization values for EPA table %s, column %s in organization table and column "%s"."%s"', epa_table_name, epa_column_name, select_table, select_col)
				continue
			logger.info('Generating mapping SQL for %s', epa_column_name)	
			self.value_mapping_sql = self.value_mapping_sql + msql
			for row4 in rows4:
				org_value = str(row4[0])
				sql5 = f"""select {db_lookup_col} from public.{db_lookup_table} where replace(lower({db_lookup_col}),'-',' ') = %s"""
				utils.process_sql(conn, cur, sql5, params=(org_value.lower().replace('-',' '),))
				try:
					epa_value = cur.fetchone()[0]
				except:
					epa_value = None

				if not epa_value and epa_column_name == 'substance_id':
					if org_value.lower() == 'jet fuel':
						epa_value = 'Jet fuel A'
					else:
						sql5 = f"select count(*) from public.v_hazardous_substances where lower(substance) = lower({repr(org_value)})"
						utils.process_sql(conn, cur, sql5)
						if cur.fetchone()[0] > 0:
							epa_value = 'Hazardous substance'

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
			utils.process_sql(conn, cur, sql6)
			rows6 = cur.fetchall()
			for row6 in rows6:
				epa_val = row6[0]
				self.value_mapping_sql = self.value_mapping_sql + f"{epa_val}\n"

			if epa_column_name == 'substance_id':
				self.value_mapping_sql = self.value_mapping_sql + '\n * NOTE: Hazardous substances can be found in view public.v_hazardous_substances.'
				self.value_mapping_sql = self.value_mapping_sql + '\n * If the state included a CAS No., you can also try mapping it to public.v_casno.\n'

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
	

	def inferred_values(self):
		if self.dataset.ust_or_release != 'ust':
			return

		logger.info('Adding SQL for inferred corrosion protection values.')
		self.value_mapping_sql = self.value_mapping_sql + "\n/* If the source data contains tank material information for cathodically protected steel and doesn't"
		self.value_mapping_sql = self.value_mapping_sql + "\n * contain explicit cathodic protection elements, we can infer the cathodic protection, which will default to"
		self.value_mapping_sql = self.value_mapping_sql + "\n * sacraficial anodes because they are more prevelant than impressed current (per OUST)."
		self.value_mapping_sql = self.value_mapping_sql + "\n * Run the SQL below to insert rows into public.ust_element mapping if these conditions apply to this data.\n */\n\n"
		self.value_mapping_sql = self.value_mapping_sql + f"""insert into public.ust_element_mapping
	(ust_control_id, epa_table_name, epa_column_name, 
	organization_table_name, organization_column_name, 
	organization_join_table, organization_join_fk, organization_join_column2, organization_join_fk2, organization_join_column3, organization_join_fk3,
	query_logic, inferred_value_comment)
select ust_control_id, 'ust_tank', 'tank_corrosion_protection_sacrificial_anode', organization_table_name, organization_column_name, 
	organization_join_table, organization_join_fk, organization_join_column2, organization_join_fk2, organization_join_column3, organization_join_fk3,
	'when tank_material_description_id in (5,6) then ''Yes'' else null', 'Inferred from tank material'
from public.ust_element_mapping a
where ust_control_id = {self.dataset.control_id} and epa_column_name = 'tank_material_description_id'
and exists 
	(select 1 from public.ust_element_value_mapping b 
	where a.ust_element_mapping_id = b.ust_element_mapping_id 
	and epa_value like '%athod%')
and not exists 
	(select 1 from public.ust_element_mapping b 
	where a.ust_control_id = b.ust_control_id
	and b.epa_column_name like 'tank_corrosion_protection%')
and not exists
	(select 1 from public.ust_element_mapping b 
	where a.ust_control_id = b.ust_control_id
	and b.epa_column_name = 'tank_corrosion_protection_sacrificial_anode');\n"""

		conn = utils.connect_db()
		cur = conn.cursor()

		sql = """select distinct organization_table_name, organization_column_name   
				from public.ust_element_mapping 
				where ust_control_id = %s
				and epa_table_name = 'ust_piping' and epa_column_name like 'piping%%' and epa_column_name <> 'piping_id'
				order by 1"""
		utils.process_sql(conn, cur, sql, params=(self.dataset.control_id,))
		rows = cur.fetchall()
		if rows:
			self.value_mapping_sql = self.value_mapping_sql + "\n/* There is no generated query we can run to automatically infer Piping corrosion protection, so the following"
			self.value_mapping_sql = self.value_mapping_sql + "\n * inserts need to be carefully reviewed. DELETE any of the SQL statements below that don't make sense and"
			self.value_mapping_sql = self.value_mapping_sql + "\n * ONLY RUN THOSE THAT DEFINITELY REFER TO CORROSION PROTECTION!\n */\n\n"

			for row in rows:
				table_name = row[0]
				column_name = row[1]
				sql = f"""select distinct "{column_name}" 
						from {self.dataset.schema}."{table_name}" 
						where lower("{column_name}"::text) like '%cp%' or lower("{column_name}"::text) like '%cor%pro%'
						order by 1;"""
				utils.process_sql(conn, cur, sql)
				rows2 = cur.fetchall()
				for row2 in rows2:
					value = row2[0]
					sql = f"""--BEFORE RUNNING THIS INSERT STATEMENT, MAKE SURE THE ORGANIZATION VALUE MEANS THAT CORROSION PROTECTION APPLIES TO THE PIPING!
insert into public.ust_element_mapping
	 (ust_control_id, epa_table_name, epa_column_name, 
	 organization_table_name, organization_column_name, 
	 query_logic, inferred_value_comment)
values({self.dataset.control_id}, 'ust_piping', 'piping_corrosion_protection_sacrificial_anode', '{table_name}', '{column_name}', 
	 'when "{column_name}" = ''{value}'' then ''Yes'' else null', 'Inferred from {table_name}.{column_name}')
on conflict (ust_control_id, epa_table_name, epa_column_name) 
do update set organization_table_name = excluded.organization_table_name,
              organization_column_name = excluded.organization_column_name,
              query_logic = excluded.query_logic,
              inferred_value_comment = excluded.inferred_value_comment;\n\n"""
					self.value_mapping_sql = self.value_mapping_sql + sql

		cur.close()
		conn.close()

		self.value_mapping_sql = self.value_mapping_sql + '------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n'



	def write_sql(self):
		wora = 'a'
		if self.overwrite_existing:
			wora = 'w'
		with open(self.dataset.export_file_path, wora, encoding='utf-8') as f:
			f.write(self.value_mapping_sql)



def main(ust_or_release, control_id, only_incomplete=True, overwrite_existing=True, export_file_name=None, export_file_dir=None, export_file_path=None):
	dataset = Dataset(ust_or_release=ust_or_release,
					  control_id=control_id, 
					  base_file_name='value_mapping.sql',
					  export_file_name=export_file_name,
					  export_file_dir=export_file_dir,
					  export_file_path=export_file_path)

	export = ValueMapper(dataset=dataset, only_incomplete=only_incomplete, overwrite_existing=overwrite_existing)



if __name__ == '__main__':   
	main(ust_or_release=ust_or_release,
		 control_id=control_id, 
		 only_incomplete=only_incomplete,
		 overwrite_existing=overwrite_existing,
		 export_file_name=export_file_name,
		 export_file_dir=export_file_dir,
		 export_file_path=export_file_path)
