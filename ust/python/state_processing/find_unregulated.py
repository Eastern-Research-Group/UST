"""
THIS SCRIPT HAS BEEN REPLACED BY create_unreg_tables.py. 
INSTEAD OF RUNNING THIS SCRIPT AFTER CREATING THE SCHEMA DATA VIEWS,
RUN create_unreg_tables.py *BEFORE* CREATING THE VIEWS.

Continue to run export_unregulated.py after writing the views,
unless you manually add the unregulated tables to the where statement. 
"""


import os
from pathlib import Path
import string
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))


import psycopg2

from python.state_processing.create_unreg_tables import UnregTables
from python.util import utils
from python.util.dataset import Dataset 
from python.util.logger_factory import logger

ust_or_release = '' 			# Valid values are 'ust' or 'release'
control_id = 0                  # Enter an integer that is the ust_control_id or release_control_id
organization_id = ''          	# Optional; if control_id = 0 or None, will find the most recent control_id
delete_existing = True  		# Boolean, defaults to True. If True, will delete all existing rows from erg_unregulated% tables. Set to False to skip the delete (will likely cause errors if this script has been run before.)


class Unregulated:
	conn = None 
	cur = None 

	def __init__(self, dataset, delete_existing=True):
		self.dataset = dataset
		self.delete_existing = delete_existing
		self.unreg = UnregTables(self.dataset)
		self.data_type = 'facilities'
		if self.dataset.ust_or_release == 'release':
			self.data_type = 'releases'


	def check_for_substances(self):
		self.connect_db()
		sql = """select count(*) from information_schema.tables 
		         where table_schema = %s and table_type = 'VIEW' and table_name = %s"""
		utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.schema, self.unreg.substance_join_view.replace(self.dataset.schema + '.','')))
		cnt = self.cur.fetchone()[0]
		self.disconnect_db()		
		if cnt > 0:
			return True 
		return False 


	def execute(self):
		if not self.check_for_substances():
			logger.info('No substance data for %s %s, no need to check for unregulated %s.', self.dataset.organization_id, utils.get_pretty_ust_or_release(self.dataset.ust_or_release), self.data_type)
			exit()
		self.connect_db()
		self.create_tables()
		self.insert_nonreg_substances()
		self.insert_heating_oil()
		self.insert_small_tank()
		self.insert_parents()
		self.disconnect_db()		


	def create_tables(self):
		sql = f"select count(*) from information_schema.tables where table_schema = %s and table_name like 'erg_unregulated%%'"
		utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.schema,))
		cnt = self.cur.fetchone()[0]
		if cnt == 0:
			logger.warning('ERG Unregulated tables do not exist; creating....')
			UnregTables(self.dataset, drop_existing=False).execute()
		else:
			UnregTables(self.dataset, drop_existing=delete_existing).execute()


	def insert_nonreg_substances(self):
		# TODO add join table/column for states where there is a join in the view 

		substance_table = self.unreg.substance_join_view.replace('v_','').replace(self.dataset.schema + '.','')
		sql = f"""select epa_column_name, organization_column_name, organization_table_name, a.organization_join_table, a.organization_join_column
				from public.{self.dataset.ust_or_release}_element_mapping a join public.v_{self.dataset.ust_or_release}_sort_order b 
					on a.epa_table_name = b.table_name and a.epa_column_name = b.column_name 
				where {self.dataset.ust_or_release}_control_id = %s
				and epa_table_name = %s
				and epa_column_name in (%s, %s, %s)
				order by b.column_sort_order"""
		utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id, substance_table, self.unreg.unreg_parent_col, 'tank_id', 'substance_id'), print_sql=False)
		rows = self.cur.fetchall()
		tanksql = ''
		if self.dataset.ust_or_release == 'ust':
			tanksql = 'tank_id, '
		vsql = f"insert into {self.unreg.unreg_substance_table} ({self.unreg.unreg_parent_col}, {tanksql} substance, unregulated_reason)\nselect distinct "
		org_table_name = ''
		substance_col_name = ''
		for row in rows:
			org_column_name = row[1]
			epa_column_name = row[0]
			org_table_name = row[2]
			if epa_column_name == 'substance_id':
				substance_col_name = org_column_name
				vsql += '"' + substance_col_name + '", '
			else:
				vsql += '"' + org_column_name + '" as ' + epa_column_name + ", "
		vsql += "'Non-regulated substance'"
		vsql += f"""\nfrom {self.dataset.schema}.{org_table_name} where "{org_column_name}" not in """
		vsql += f"""\n\t(select organization_value from public.v_{self.dataset.ust_or_release}_mapping 
		             where {self.dataset.ust_or_release}_control_id = %s
		             and epa_table_name = %s and epa_column_name = 'substance_id') 
		             order by 1, 2"""
		utils.process_sql(self.conn, self.cur, vsql, params=(self.dataset.control_id, substance_table), print_sql=False)
		num_inserted = self.cur.rowcount
		if num_inserted == 0:
			logger.info('No non-regulated substances')
			return 
		logger.info('Inserted %s rows into %s due non-regulated substance', num_inserted, self.unreg.unreg_substance_table)
		self.conn.commit()


	def build_ust_facility_type_sql(self, fac_type):
		if self.dataset.ust_or_release == 'ust':
			view_name =  'v_ust_facility'
		else:
			view_name = 'v_ust_release'
		sql = """select column_name from information_schema.columns 
				where table_schema = %s and table_name = %s
				and column_name like 'facility_type%%'
				order by column_name"""
		utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.schema, view_name))
		rows = self.cur.fetchall()
		if not rows:
			return None  
		column_name = rows[0][0]
		try:
			column_name2 = rows[1][0]
		except:
			column_name2 = None 
		if fac_type == 'heating':
			wheresql = f"where {column_name} <> 4 "
		else:
			wheresql = f"where {column_name} in (1,12) "

		fsql = f" and ts.{self.unreg.unreg_parent_col} in (select {self.unreg.unreg_parent_col} from {self.dataset.schema}.{view_name} {wheresql}"
		if len(rows) > 1:
			fsql += f"""\nunion all\n\tselect {self.unreg.unreg_parent_col} from {self.dataset.schema}.{view_name} {wheresql.replace(column_name, column_name2)}"""
		fsql += ") " 
		return fsql 


	def insert_heating_oil(self):
		fac_sql = self.build_ust_facility_type_sql('heating')
		if not fac_sql:
			logger.info('No facility type data so not inserting unregulated heating oil rows.')
			return

		if self.dataset.ust_or_release == 'ust':
			substance_table = 'v_ust_tank_substance'
			tanksql = 'tank_id, '
		else:
			substance_table = 'v_ust_release_substance'
			tanksql = ''

		sql = f"""insert into {self.unreg.unreg_substance_table}
			      select distinct {self.unreg.unreg_parent_col}, {tanksql} org.organization_value, ts.substance_id, 'Heating oil' 
			      from {self.unreg.substance_join_view} ts 
			      	join public.substances s on ts.substance_id = s.substance_id 
		      	  	join (select distinct organization_value, epa_value from public.v_ust_mapping 
				  	      where {self.dataset.ust_or_release}_control_id = %s and epa_column_name = 'substance_id') org 
				  		on s.substance = org.epa_value 
			      where s.substance_group = 'Heating' {fac_sql}
			      on conflict do nothing"""
		utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id,), print_sql=False)
		logger.info('Inserted %s rows into %s due presence of heating oil in a non-bulk distributor facility', self.cur.rowcount, self.unreg.unreg_substance_table)
		self.conn.commit()


	def insert_small_tank(self):
		if self.dataset.ust_or_release == 'release':
			return 

		fac_sql = self.build_ust_facility_type_sql('farm/residence')
		sql = f"""insert into {self.unreg.unreg_substance_table}
				select distinct x.facility_id, x.tank_id, org.organization_value, ts.substance_id, 'Small tank at farm/residence'
				from (select facility_id, tank_id, sum(compartment_capacity_gallons) as tank_capacity_gallons 
					from {self.dataset.schema}.v_ust_compartment group by facility_id, tank_id) x join 
					{self.unreg.substance_join_view} ts on x.facility_id = ts.facility_id and x.tank_id = ts.tank_id  
					join public.substances s on ts.substance_id = s.substance_id
		      	  	join (select distinct organization_value, epa_value from public.v_ust_mapping 
				  	      where {self.dataset.ust_or_release}_control_id = %s and epa_column_name = 'substance_id') org 
				  		on s.substance = org.epa_value 					
				where tank_capacity_gallons < 1100 and substance_group in ('Diesel','Gasoline')
				{fac_sql}"""
		utils.process_sql(self.conn, self.cur, sql,  params=(self.dataset.control_id,), print_sql=False)
		logger.info('Inserted %s rows into %s due to tank capacity <1100 gallons in a farm or residence facility', self.cur.rowcount, self.unreg.unreg_substance_table)
		self.conn.commit()


	def insert_parents(self):
		extrajoinsql = ""
		if self.dataset.ust_or_release == 'ust':
			extrajoinsql = " and v.tank_id = eus.tank_id "

		sql = f"""insert into {self.unreg.unreg_parent_table}
			select v.{self.unreg.unreg_parent_col}, string_agg(distinct eus.unregulated_reason, '; ' order by eus.unregulated_reason) as unregulated_reason
			from {self.unreg.substance_join_view} v
				join {self.unreg.unreg_substance_table} eus join public.substances s on eus.substance = s.substance
					on v.{self.unreg.unreg_parent_col} = eus.{self.unreg.unreg_parent_col} and v.substance_id = s.substance_id {extrajoinsql}
			where not exists (
			    select 1
			    from  {self.unreg.substance_join_view} v2
			    where v2.{self.unreg.unreg_parent_col} = v.{self.unreg.unreg_parent_col}
			      and not exists (
			          select 1
			          from {self.unreg.unreg_substance_table} eus join public.substances s on eus.substance = s.substance
			          where eus.{self.unreg.unreg_parent_col} = v2.{self.unreg.unreg_parent_col}
			            and s.substance_id = v2.substance_id {extrajoinsql.replace('v.','v2.')}))
			group by v.{self.unreg.unreg_parent_col}
			on conflict do nothing"""
		
		utils.process_sql(self.conn, self.cur, sql, print_sql=True)
		logger.info('Inserted %s rows into %s', self.cur.rowcount, self.unreg.unreg_parent_table)
		self.conn.commit()


	def connect_db(self):
		if not self.conn:
			self.conn = utils.connect_db()
			self.cur = self.conn.cursor()
			logger.info('Connected to database')
		

	def disconnect_db(self):
		if self.conn:
			self.cur.close()
			self.conn.close()
			self.conn = None 
			logger.info('Disconnected from database')




def main(ust_or_release, control_id=0, organization_id=None, delete_existing=delete_existing):
	if not control_id or control_id == 0:
		control_id = utils.get_control_id(ust_or_release, organization_id.upper())

	dataset = Dataset(ust_or_release=ust_or_release,
				 	  control_id=control_id,
				 	  requires_export=False)

	# Unregulated(dataset, delete_existing=delete_existing).execute()

	u = Unregulated(dataset, delete_existing=delete_existing)
	u.execute()


if __name__ == '__main__':   
	main(ust_or_release=ust_or_release,
		 control_id=control_id,
		 organization_id=organization_id,
		 delete_existing=delete_existing)

