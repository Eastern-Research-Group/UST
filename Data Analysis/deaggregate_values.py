from logger_factory import logger
import config, constants, utils

from psycopg2.errors import DuplicateTable, UndefinedTable
from datetime import datetime
import pandas as pd
import os.path

state = 'CA'
ust_or_lust = 'LUST'
key_column = 'GLOBAL_ID'

class Analyzer:
	def __init__(self, state, ust_or_lust, key_column):
		self.state = state.upper()
		self.ust_or_lust = ust_or_lust.upper()
		self.schema = self.state.upper() + '_' + self.ust_or_lust.upper() 
		self.table_name = None
		self.column_name = None
		self.key_column = key_column
		self.db_mapping_id = None
		self.deagg_table_name = None
		self.conn = utils.connect_db(config.db_name, self.schema)
		self.cur = self.conn.cursor()
		self.ust_conn = utils.connect_db(config.db_name, 'public')
		self.ust_cur = self.ust_conn.cursor()


	def get_table_info(self, element_name):
		sql = f"""select max(id) from {self.ust_or_lust.lower()}_element_db_mapping
		          where state = %s and element_name = %s"""
		self.ust_cur.execute(sql, (self.state, element_name))
		self.db_mapping_id = self.ust_cur.fetchone()[0]
		
		sql = f"""select state_table_name, state_column_name
		          from {self.ust_or_lust.lower()}_element_db_mapping
		          where id = %s"""
		self.ust_cur.execute(sql, (self.db_mapping_id,))
		row = self.ust_cur.fetchone()
		self.table_name = row[0]
		self.column_name = row[1]	


	def create_deagg_table(self):
	    sql = f'drop table "{self.deagg_table_name}"'
	    try:
	        self.cur.execute(sql)
	        logger.info('Table %s dropped', self.deagg_table_name)
	    except UndefinedTable:
	        pass 

	    sql = f"""create table "{self.deagg_table_name}" (
	                id int generated always as identity not null primary key,
	                "{self.key_column}" text,
	                "{self.column_name}" text)"""
	    self.cur.execute(sql)
	    logger.info('Table %s created', self.deagg_table_name)

	    sql = f'select "{self.key_column}", "{self.column_name}" from sites order by 1'
	    self.cur.execute(sql)
	    rows = self.cur.fetchall()
	    for row in rows:
	        key = row[0]
	        values = row[1]
	        if values:
	            value_list = values.split(',')
	            value_list = [v.replace('*','').strip() for v in value_list]
	            for value in value_list:
	                sql2 = f'insert into {self.deagg_table_name} ("{self.key_column}", "{self.column_name}") values (%s, %s)'
	                self.cur.execute(sql2, (key, value))
	                print(f'{key}: {value}')
	            self.conn.commit()

	    sql = f'select count(*) from "{self.deagg_table_name}"'
	    self.cur.execute(sql)
	    cnt = self.cur.fetchone()[0]
	    logger.info('There are %s rows in table %s', cnt, self.deagg_table_name)


	def disconnect_db(self):
		self.ust_cur.close()
		self.ust_conn.close()
		self.cur.close()
		self.conn.close()
	

	def deagg(self, element_name):
		self.get_table_info(element_name)

		self.deagg_table_name = constants.ELEMENT_TO_DB_COL[element_name] + 's_deagg'

		sql = f"""insert into {self.ust_or_lust.lower()}_deagg_tables 
					(element_db_mapping_id, deagg_table_name)
				  values (%s, %s)"""
		self.ust_cur.execute(sql, (self.db_mapping_id, self.deagg_table_name))

		self.create_deagg_table()



if __name__ == '__main__':
	a = Analyzer(state, ust_or_lust, key_column)
	elements_to_check = ['SubstanceReleased1','CauseOfRelease1','SourceOfRelease1','RemediationStrategy1']
	for e in elements_to_check:
		a.deagg(e)
	a.disconnect_db()