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

schema = ''              			# Enter the schema name
upload_file_path = r""				# Path to CUI check spreadsheet.  


class CuiImport:
	conn = None 
	cur = None 

	def __init__(self, 
				 schema,
				 upload_file_path):
		self.schema = schema
		self.upload_file_path = upload_file_path 
		self.connect_db()
		self.cui_table_name = self.get_clean_cui_table_name()
		self.upload_file()
		self.disconnect_db()


	def get_clean_cui_table_name(self):
		sql = "select table_name from information_schema.tables where table_schema = %s and lower(table_name) like '%%clean_cui'"
		utils.process_sql(self.conn, self.cur, sql, params=(self.schema,))
		try:
			table_name = self.cur.fetchone()[0]
			logger.info('A clean_cui table, %s, already exists in schema %s and will be dropped', table_name, self.schema)
			sql = f'drop table {self.schema}."{table_name}"'
			utils.process_sql(self.conn, self.cur, sql)
			self.conn.commit()
			logger.info('Table %s.%s dropped', self.schema, table_name)
		except:
			pass
		return 'erg_' + self.schema + '_clean_cui'
		

	def upload_file(self):
		if self.upload_file_path:
			t = Importer(self.upload_file_path, 
				         schema=self.schema, 
				         table_name=self.cui_table_name, 
				         overwrite_table=True,
				         excel_tabs=None)
			t.save_file_to_db()	
			logger.info('Uploaded %s to table %s in schema %s', self.upload_file_path, self.cui_table_name, self.schema)	


	def connect_db(self):
		self.conn = utils.connect_db()
		self.cur = self.conn.cursor()
		logger.info('Connected to database')
		

	def disconnect_db(self):
		self.conn.commit()
		self.cur.close()
		self.conn.close()
		logger.info('Disconnected from database')



def main(schema, 
     	 upload_file_path=None):
	cui = CuiImport(schema=schema,
				   upload_file_path=upload_file_path)


if __name__ == '__main__':   
	main(schema=schema,
	 	 upload_file_path=upload_file_path)		