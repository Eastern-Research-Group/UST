from datetime import date
import ntpath
import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import pandas as pd

from python.util import utils, config
from python.util.logger_factory import logger


upload_file_path = r""			# Path to Excel, CSV, or text file to upload. 
schema = 'public'				# Schema to upload to. 
table_name = None  				# Only used if single tab Excel spreadsheet or CSV. Multi-tab Excel files use tab names as table names.
overwrite_table = False       	# Boolean. Set to True to overwrite table(s) if exists. 
excel_tabs = None               # For multi-tab Excel files, enter a string or list containing the sheet names to export. Leave as None to export all tabs.


class Importer:
	existing_tables = None 

	def __init__(self, upload_file_path, schema='public', table_name=None, overwrite_table=False, excel_tabs=None):
		self.upload_file_path = upload_file_path
		self.schema = schema
		if table_name:
			self.table_name = table_name  
		else:
			self.table_name = self.get_table_name_from_file_name()
		self.overwrite_table = overwrite_table
		if excel_tabs:
			self.excel_tabs = utils.string_to_list(excel_tabs)
		else:
			self.excel_tabs = []
		self.set_existing_tables()


	def get_table_name_from_file_name(self):
		table_name = self.upload_file_path.rsplit('\\', 1)[1]
		table_name = table_name.replace(' ','_').replace('.xlsx','').replace('.xls','').replace('.csv','').replace('.txt','')
		return table_name
		

	def set_existing_tables(self):
		conn = utils.connect_db()
		cur = conn.cursor()
		sql = "select table_name from information_schema.tables where table_schema = %s order by 1"
		utils.process_sql(conn, cur, sql, params=(self.schema,))
		self.existing_tables = [r[0] for r in cur.fetchall()]
		cur.close()
		conn.close()

		
	def save_table_to_db(self, df, new_table_name):
		if new_table_name in self.existing_tables and not self.overwrite_table:
			logger.warning('Table %s already exists in the database and will not be imported because the overwrite_table flag is set to False', new_table_name)
			return True
		logger.info('New table name will be %s', new_table_name)    
		engine = utils.get_engine(schema=self.schema)    
		if self.overwrite_table:    
			df.to_sql(new_table_name, engine, index=False, if_exists='replace')
			logger.info('Created table %s', new_table_name)
		else:
			try:
				df.to_sql(new_table_name, engine, index=False)
				logger.info('Created table %s', new_table_name)       
			except error as e:
				self.bad_file_list.append(new_table_name)
				logger.error('Unable to load table %s; adding to bad_file_list: %s: %s', new_table_name, e)
		return True


	def save_file_to_db(self):
		if utils.is_excel(self.upload_file_path):
			xls = pd.ExcelFile(self.upload_file_path)
			sheet_names = xls.sheet_names
			if len(sheet_names) > 1:
				for sheet_name in sheet_names:
					if not self.excel_tabs or sheet_name in self.excel_tabs:
						df = pd.read_excel(self.upload_file_path, sheet_name=sheet_name)
						logger.debug('%s, worksheet %s read into dataframe', self.upload_file_path, sheet_name)
						if len(self.excel_tabs) == 1 and self.table_name:
							new_table_name = self.table_name
						else:
							new_table_name = sheet_name 
						self.save_table_to_db(df, new_table_name=new_table_name)
			else:
				try:
					df = pd.read_excel(self.upload_file_path)   
					logger.debug('%s read into dataframe', self.upload_file_path)
				except ValueError as e:
					logger.error('Error opening %s; skipping: %s', self.upload_file_path, e) 
					self.bad_file_list.append(table_name)
					return False
				self.save_table_to_db(df, new_table_name=self.table_name)
		elif self.upload_file_path[-3:] == 'csv':
			df = pd.read_csv(self.upload_file_path, encoding='ansi', low_memory=False)
			logger.debug('%s read into dataframe', self.upload_file_path)
			self.save_table_to_db(df, new_table_name=self.table_name)
		elif self.upload_file_path[-3:] == 'txt':
			df = pd.read_csv(self.upload_file_path, sep='\t', encoding='ansi', low_memory=False)
			logger.debug('%s read into dataframe', self.upload_file_path)
			self.save_table_to_db(df, new_table_name=self.table_name)
		else:
			logger.info('%s is not an .xlsx, .csv, or .txt file so aborting...', self.upload_file_path)
			sys.exit()

		return True



def main(upload_file_path, schema='public', table_name=None, overwrite_table=False, excel_tabs=None):
	t = Importer(upload_file_path, schema=schema, table_name=table_name, overwrite_table=overwrite_table, excel_tabs=excel_tabs)
	t.save_file_to_db()


if __name__ == '__main__':  
	main(upload_file_path=upload_file_path, schema=schema, table_name=table_name, overwrite_table=overwrite_table, excel_tabs=excel_tabs)