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
delete_existing = False  		# Boolean, defaults to False. If True, will delete all existing rows from erg_unregulated% tables. Set to False to skip the delete (will likely cause errors if this script has been run before.)


class Unregulated:
	conn = None 
	cur = None 

	def __init__(self, dataset, delete_existing=False):
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


	def insert_nonregulated_substances(self):
		self.connect_db()
		if not utils.get_table_existence(self.unreg.erg_substance_mapping_view, self.dataset.schema):
			logger.warning('No view %s.%s found; will not insert non-regulated substances', self.dataset.schema, self.unreg.erg_substance_mapping_view)
			self.disconnect_db()
			return 
		tanksql = ''
		pk_col = 'release_id'
		if self.dataset.ust_or_release == 'ust':
			tanksql = 'tank_id, '
			pk_col = 'facility_id'
		sql = f"""insert into {self.unreg.unreg_substance_table} 
				select distinct {pk_col}, {tanksql}org_substance, substance_id, epa_substance, 'Non-regulated substance'
				from {self.dataset.schema}.{self.unreg.erg_substance_mapping_view}
				where substance_id is null and org_substance is not null and org_substance <> '' 
				and {pk_col} not in (select {pk_col} from {self.unreg.unreg_parent_table})
				on conflict do nothing"""
		utils.process_sql(self.conn, self.cur, sql)
		logger.info('Inserted %s rows into %s with reason "Non-regulated substance"', self.cur.rowcount, self.unreg.unreg_substance_table)
		self.disconnect_db()


	def insert_unregulated_tanks(self):
		self.connect_db()
		if not utils.get_table_existence(self.unreg.erg_unreg_subs_view, self.dataset.schema):
			logger.warning('%s.%s does not exist; unable to insert unregistered tanks into %s.%s', 
						   self.dataset.schema, self.unreg.erg_unreg_subs_view, 
						   self.dataset.schema, self.unreg.unreg_substance_table)
			self.disconnect_db()
			return 
		tanksql = ''
		pk_col = 'release_id'
		if self.dataset.ust_or_release == 'ust':
			tanksql = 'tank_id, '
			pk_col = 'facility_id'
		sql = f"""insert into {self.unreg.unreg_substance_table} 
				select distinct {pk_col}, {tanksql}org_substance, substance_id, epa_substance, unregulated_reason
				from {self.dataset.schema}.{self.unreg.erg_unreg_subs_view}
				where org_substance is not null and org_substance <> '' 
				and {pk_col} not in (select {pk_col} from {self.unreg.unreg_parent_table})
				on conflict do nothing"""
		utils.process_sql(self.conn, self.cur, sql)
		logger.info('Inserted %s rows into %s due to unregulated heating oil', self.cur.rowcount, self.unreg.unreg_substance_table)
		self.disconnect_db() 


	def insert_parents(self):
		self.connect_db()
		
		extrajoinsql = ""
		if self.dataset.ust_or_release == 'ust':
			extrajoinsql = "\nand v.tank_id::int = eus.tank_id::int "

		sql = f"""insert into {self.unreg.unreg_parent_table}
				 select v.{self.unreg.unreg_parent_col}, string_agg(distinct eus.unregulated_reason, '; ' order by eus.unregulated_reason) as unregulated_reason
				 from {self.dataset.schema}.{self.unreg.erg_substance_mapping_view} v
					join {self.unreg.unreg_substance_table} eus 
				 on v.{self.unreg.unreg_parent_col}::varchar(50) = eus.{self.unreg.unreg_parent_col}::varchar(50) {extrajoinsql} 
				 and v.org_substance::varchar(1000) = eus.organization_substance::varchar(1000)
				 where not exists (
					 select 1
					 from {self.dataset.schema}.{self.unreg.erg_substance_mapping_view} v2
					 where v2.{self.unreg.unreg_parent_col}::varchar(50)  = v.{self.unreg.unreg_parent_col}::varchar(50) 
				 	and not exists (
						 select 1
						 from {self.unreg.unreg_substance_table} eus
						 where eus.{self.unreg.unreg_parent_col}::varchar(50)  = v2.{self.unreg.unreg_parent_col}::varchar(50) {extrajoinsql.replace('v.','v2.')} 
						and v2.org_substance::varchar(1000) = eus.organization_substance::varchar(1000)  
					)
				  )
				 group by v.{self.unreg.unreg_parent_col}
				 on conflict do nothing"""
		
		utils.process_sql(self.conn, self.cur, sql, print_sql=False)
		logger.info('Inserted %s rows into %s', self.cur.rowcount, self.unreg.unreg_parent_table)

		self.disconnect_db()

	def execute(self):
		self.insert_nonregulated_substances()
		self.insert_unregulated_tanks()
		self.insert_parents()


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

	u = Unregulated(dataset, delete_existing=delete_existing)
	u.execute()


if __name__ == '__main__':   
	main(ust_or_release=ust_or_release,
		 control_id=control_id,
		 organization_id=organization_id,
		 delete_existing=delete_existing)

