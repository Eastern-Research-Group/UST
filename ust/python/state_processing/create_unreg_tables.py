import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import psycopg2

from python.state_processing.insert_control import ControlTable
from python.util import utils
from python.util.dataset import Dataset 
from python.util.logger_factory import logger


ust_or_release = 'ust'                  	# Valid values are 'ust' or 'release'
control_id = 0
organization_id = 'ok'                  	# Enter the two-character code for the state, or "TRUSTD" for the tribes database 
drop_existing = True					# Boolean; defaults to False. If True, will drop existing tables if possible (will error if there are dependent objects). If False, will rename tables if they already exist. 

class UnregTables:
	conn = None 
	cur = None 
	
	unreg_parent_table = None
	unreg_parent_col = None  
	unreg_substance_table = None 
	substance_join_view = None 
	unreg_tank_table = None 

	def __init__(self, dataset, drop_existing=False):
		self.dataset = dataset
		self.drop_existing = drop_existing
		self.set_variables()


	def set_variables(self):
		if self.dataset.ust_or_release == 'release':
			self.unreg_parent_table = f'{self.dataset.schema}.erg_unregulated_releases'
			self.unreg_parent_col = 'release_id'
			self.substance_join_view = f'{self.dataset.schema}.v_ust_release_substance'
		else:
			self.unreg_parent_table = f'{self.dataset.schema}.erg_unregulated_facilities'
			self.unreg_parent_col = 'facility_id'
			self.substance_join_view = f'{self.dataset.schema}.v_ust_tank_substance'
			self.unreg_tank_table = f'{self.dataset.schema}.erg_unregulated_tanks'
		self.unreg_substance_table = f'{self.dataset.schema}.erg_unregulated_substances'


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


	def truncate_table(self, table):
		sql = f"truncate table {table}"
		utils.process_sql(self.conn, self.cur, sql)
		logger.info('Truncated table %s', table)


	def backup_table(self, table):
		backup_table = f'{table}_bkup_{utils.get_timestamp_str()}'
		sql = f"select * into {backup_table} from {table}"
		utils.process_sql(self.conn, self.cur, sql)
		logger.info('Created backup of table %s, named %s', table, backup_table)


	def drop_table(self, table):
		if self.drop_existing:
			try:
				sql = f"drop table if exists {table}"
				self.cur.execute(sql)
			except psycopg2.errors.DependentObjectsStillExist as e:
				logger.warning('Table %s exists but it has dependencies, so creating a backup and truncating the original table instead of creating a new one.', self.table)
				self.backup_table(table)
				self.truncate_table(table)
		else:
			sql = f"""select count(*) from information_schema.tables 
					  where table_schema = %s and table_name = %s"""
			utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.schema, table.replace(self.dataset.schema + '.','')))
			cnt = self.cur.fetchone()[0]
			if cnt > 0:
				logger.warning('drop_tables = False but table %s already exists. Exiting...', table)
				self.disconnect_db()
				exit()


	def execute(self):
		self.connect_db()

		if self.dataset.ust_or_release == 'ust':
			self.drop_table(self.unreg_tank_table)
			sql = f"""create table {self.unreg_tank_table}
						 ({self.unreg_parent_col} varchar(50) not null, 
						 tank_id int not null, 
						 unregulated_reason varchar(1000),
						 primary key ({self.unreg_parent_col}, tank_id))"""
			utils.process_sql(self.conn, self.cur, sql)
			logger.info('Created table %s', self.unreg_tank_table)	

		self.drop_table(self.unreg_substance_table)
		sql = f"""create table {self.unreg_substance_table} 
					({self.unreg_parent_col} varchar(50) not null, 
					substance_id int not null, 
					unregulated_reason varchar(1000),
					primary key ({self.unreg_parent_col}, substance_id))"""
		utils.process_sql(self.conn, self.cur, sql)
		logger.info('Created table %s', self.unreg_substance_table)	

		self.drop_table(self.unreg_parent_table)
		sql = f"""create table {self.unreg_parent_table} 
					({self.unreg_parent_col} varchar(50) not null primary key, 
					unregulated_reason varchar(1000))"""
		utils.process_sql(self.conn, self.cur, sql)
		logger.info('Created table %s', self.unreg_parent_table)	

		self.disconnect_db()



def main(ust_or_release, control_id=0, organization_id=None, drop_existing=False):
	if not control_id or control_id == 0:
		control_id = utils.get_control_id(ust_or_release, organization_id.upper())

	dataset = Dataset(ust_or_release=ust_or_release,
					  control_id=control_id,
					  requires_export=False)

	UnregTables(dataset, drop_existing=drop_existing).execute()



if __name__ == '__main__':   
	main(ust_or_release=ust_or_release,
		 control_id=control_id,
		 organization_id=organization_id,
		 drop_existing=drop_existing)

