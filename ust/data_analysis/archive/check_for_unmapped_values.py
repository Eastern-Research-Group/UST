import sys
import os
sys.path = [os.path.join(os.path.dirname(__file__), "..", "..")] + sys.path
from ust.util.logger_factory import logger
from ust.util import config, utils
import constants
from psycopg2.errors import DuplicateTable
from datetime import datetime
import pandas as pd
import os.path

state = 'CA'
ust_or_lust = 'LUST'


class Analyzer:
	def __init__(self, state, ust_or_lust, element_name=None):
		self.state = state.upper()
		self.ust_or_lust = ust_or_lust.lower()
		self.schema = self.state.upper() + '_' + self.ust_or_lust.upper() 
		self.table_name = None
		self.column_name = None
		self.values_table = None
		self.element_name = element_name
		self.db_mapping_id = None
		self.report_file_path = self.get_report_path()
		self.conn = utils.connect_db(config.db_name, self.schema)
		self.cur = self.conn.cursor()
		self.ust_conn = utils.connect_db(config.db_name, 'public')
		self.ust_cur = self.ust_conn.cursor()


	def get_report_path(self):
		file_name = state + '_' + self.ust_or_lust + '_data_refresh_analysis_' + datetime.now().strftime('%Y%m%d') + '.xlsx'
		file_path = config.file_path + state + '/' + file_name
		return file_path


	def get_db_mapping_id(self):
		sql = f"""select max(mapping_date) from {self.ust_or_lust}_element_db_mapping
		          where state = %s and element_name = %s"""
		self.ust_cur.execute(sql, (self.state, self.element_name))
		mapping_date = self.ust_cur.fetchone()[0]

		sql = f"""select min(id) from {self.ust_or_lust}_element_db_mapping
		          where state = %s and element_name = %s and mapping_date = %s"""
		self.ust_cur.execute(sql, (self.state, self.element_name, mapping_date))
		self.db_mapping_id = self.ust_cur.fetchone()[0]


	def create_values_table(self):
		sql = f"create table {self.values_table} (state_value varchar(200) not null primary key)"
		try:
			self.cur.execute(sql)
			logger.info('Created table %s', self.values_table)
		except DuplicateTable:
			logger.info('Table %s already exists', self.values_table)
			pass


	def get_unique_values(self):
		unique_values = []
		sql = f'select distinct "{self.column_name}" from "{self.table_name}" where "{self.column_name}" is not null order by 1'
		self.cur.execute(sql)
		rows = self.cur.fetchall()
		for row in rows:
			values = row[0].split(',')
			for value in values:
				v = value.replace('*','').strip()
				if v not in unique_values:
					unique_values.append((v,))
		# print(unique_values)
		return unique_values


	def insert_values(self, unique_values):
		args = ','.join(self.cur.mogrify('(%s)', i).decode('utf-8') for i in unique_values)
		self.cur.execute(f"insert into {self.values_table} values " + args + f" on conflict (state_value) do nothing")
		rowcount = self.cur.rowcount
		logger.info('Inserted %s rows into table %s', rowcount, self.values_table)
		self.conn.commit()


	def disconnect_db(self):
		self.ust_cur.close()
		self.ust_conn.close()
		self.cur.close()
		self.conn.close()


	def analyze(self, element_name):
		self.element_name = element_name
		self.get_db_mapping_id()
		
		sql = f"""select state_table_name, state_column_name 
		          from {self.ust_or_lust.lower()}_element_db_mapping
		          where id = %s"""
		self.ust_cur.execute(sql, (self.db_mapping_id,))
		row = self.ust_cur.fetchone()
		self.table_name = row[0]
		self.column_name = row[1]

		self.values_table = constants.ELEMENT_TO_DB_COL[element_name] + 's'
		self.create_values_table()

		unique_values = self.get_unique_values()
		self.insert_values(unique_values)

		sql = f"""select state_value from {self.values_table} 
				  where state_value not in
				  	 (select state_value from public.{self.ust_or_lust}_element_value_mappings
				  	  where element_db_mapping_id = %s) 
				  order by 1"""
		self.cur.execute(sql, (self.db_mapping_id, ))
		df = pd.DataFrame(self.cur.fetchall(), columns=['state_value'])
		df['mapping'] = ''

		if len(df) > 0:
			sheet_name = 'New ' + self.values_table + ' to map'
			if os.path.exists(self.report_file_path):
			    with pd.ExcelWriter(self.report_file_path, mode='a', if_sheet_exists='replace') as writer:
			        df.to_excel(writer, index=False, sheet_name=sheet_name) 
			else:
			    with pd.ExcelWriter(self.report_file_path, mode='w') as writer:
			        df.to_excel(writer, index=False, sheet_name=sheet_name) 
			logger.info('Wrote data to %s on worksheet %s; %s rows inserted', self.report_file_path, sheet_name, len(df))


if __name__ == '__main__':
	a = Analyzer(state, ust_or_lust)
	elements_to_check = ['SubstanceReleased1','CauseOfRelease1','SourceOfRelease1']
	for e in elements_to_check:
		a.analyze(e)
	a.disconnect_db()