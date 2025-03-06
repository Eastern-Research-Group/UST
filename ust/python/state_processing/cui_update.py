from datetime import datetime
import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import pandas as pd

from python.util import utils
from python.util.logger_factory import logger
from python.util.upload_general_file import Importer


ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = 0                  # Enter an integer that is the ust_control_id or release_control_id
organization_id = ''            # State code. Required if control_id is None or 0; ignored otherwise. 


class CuiUpdate:
	conn = None 
	cur = None 
	cui_column_name = None 
	fac_name_column = None 
	data_table_name = None 
	data_column_name = None 

	def __init__(self, 
				 ust_or_release,
				 control_id):
		self.ust_or_release = ust_or_release.lower()
		self.control_id = control_id 
		# logger.info('organization_id is %s', utils.get_org_from_control_id(self.control_id, self.ust_or_release))
		self.schema = utils.get_schema_from_control_id(self.control_id, self.ust_or_release)
		# logger.info('Schema is %s', self.schema)
		self.cui_table_name = 'erg_' + self.schema + '_clean_cui'


	def process(self):
		self.connect_db()
		if self.check_for_cui_table():
			if self.set_data_table_info():
				if self.check_for_table_population():
					self.cui_column_name = self.get_cui_column_name()
					self.fac_name_column = self.cui_column_name.replace('_cui','')
					self.update_data_table()
		self.disconnect_db()

		
	def check_for_cui_table(self):
		sql = "select count(*) from information_schema.tables where table_schema = %s and table_name = %s"
		utils.process_sql(self.conn, self.cur, sql, params=(self.schema, self.cui_table_name))
		if self.cur.fetchone()[0] == 0:
			logger.warning('No table %s exists in schema %s, exiting...', self.cui_table_name, self.schema)
			return False 
		return True


	def set_data_table_info(self):
		if self.ust_or_release == 'ust':
			self.data_table_name = 'ust_facility'
			self.data_column_name = 'facility_name'
		elif self.ust_or_release == 'release':
			self.data_table_name = 'ust_release'
			self.data_column_name = 'site_name'
		else:
			logger.warning('Invalid value for ust_or_release: %s', self.ust_or_release)
			return False 
		return True


	def check_for_table_population(self):
		sql = f"select count(*) from {self.data_table_name} where {self.ust_or_release}_control_id = %s"
		utils.process_sql(self.conn, self.cur, sql, params=(self.control_id,))
		if self.cur.fetchone()[0] == 0:
			logger.warning('No rows exist for %s_control_id in table %s; no CUI flags to update.', self.ust_or_release, self.data_table_name)
			return False 
		return True


	def get_cui_column_name(self):
		sql = f"""select column_name from information_schema.columns 
		         where table_schema = %s and table_name = %s and column_name like '%%_cui'"""
		utils.process_sql(self.conn, self.cur, sql, params=(self.schema, self.cui_table_name))
		try:
			cui_column_name = self.cur.fetchone()[0]
		except:
			logger.warning('No CUI column found in %s.%s; exiting', self.schema, self.cui_table_name)
			self.disconnect_db()
			exit()
		return cui_column_name


	def update_data_table(self):
		sql = f"""update public.{self.data_table_name} a set cui_flag = 'Y' 
				where a.{self.ust_or_release}_control_id = %s and exists 
					(select 1 from {self.schema}.{self.cui_table_name} b 
					where a.{self.data_column_name} = b."{self.fac_name_column}" and b."{self.cui_column_name}" is true)"""
		utils.process_sql(self.conn, self.cur, sql, params=(self.control_id,))
		logger.info('Set cui_flag in table %s to Y for %s rows due to CUI', self.data_table_name, self.cur.rowcount)

		sql = f"""update public.{self.data_table_name} a set cui_flag = 'N' 
				where a.{self.ust_or_release}_control_id = %s and exists 
					(select 1 from {self.schema}.{self.cui_table_name} b 
					where a.{self.data_column_name} = b."{self.fac_name_column}" and b."{self.cui_column_name}" is false)"""
		utils.process_sql(self.conn, self.cur, sql, params=(self.control_id,))
		logger.info('Set cui_flag in table %s to N for %s rows due to lack of CUI', self.data_table_name, self.cur.rowcount)
		self.conn.commit()


	def connect_db(self):
		self.conn = utils.connect_db()
		self.cur = self.conn.cursor()
		logger.info('Connected to database')
		

	def disconnect_db(self):
		self.conn.commit()
		self.cur.close()
		self.conn.close()
		logger.info('Disconnected from database')



def main(ust_or_release, 
     	 control_id=None,
     	 organization_id=None):
	if (control_id == 0 or not control_id) and not organization_id:
		logger.errror('Either control_id or organization_id is required; exiting')
		exit()
	if not control_id:
		control_id = utils.get_control_id(ust_or_release, organization_id)
		logger.info('control_id set to %s', control_id)

	CuiUpdate(ust_or_release=ust_or_release, control_id=control_id)


if __name__ == '__main__':   
	main(ust_or_release=ust_or_release,
	 	 control_id=control_id,
	 	 organization_id=organization_id)		