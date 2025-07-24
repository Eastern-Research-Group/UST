from datetime import date
import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import pandas as pd
import psycopg2

from python.util import utils, config
from python.util.logger_factory import logger


schema_names = ['or_ust','or_release']
include_views = False 
export_file_name =  None
export_file_dir = None


class TableRowCounts:	
	sql = None 
	counts = []  
	df = None 

	def __init__(self, 
		         schema_names=None, 
		         include_views=False, 
		         export_file_name=None,
		         export_file_dir=None):
		self.schema_names = schema_names
		self.include_views = include_views 
		if export_file_name:
			self.export_file_name = export_file_name
		else:
			self.export_file_name = f'Db_table_row_counts_{utils.get_timestamp_str()}.xlsx'
		if export_file_dir:
			self.export_file_dir = export_file_dir
		else:
			self.export_file_dir = '../../python/exports/other/'
		Path(self.export_file_dir).mkdir(parents=True, exist_ok=True)
		self.export_file_path = self.export_file_dir + self.export_file_name
		

	def create_view(self):
		conn = utils.connect_db()
		cur = conn.cursor()
		sql = """create or replace view public.vw_database_tables as 
				select t.table_schema, t.table_name, t.table_type
				from information_schema.schemata s join information_schema.tables t on s.schema_name = t.table_schema
				where s.schema_owner <> 'postgres' and t.table_schema <> 'archive' 
				and t.table_schema not like '%%old' and t.table_schema <> 'example'
				and t.table_schema not like 'ust%%' and t.table_schema not like '%%ast'
				and t.table_schema <> 'oust' and t.table_schema <> 'ia_ust_sites_ust'"""
		utils.process_sql(conn, cur, sql)
		cur.close()
		conn.close()
		logger.info('Created view public.vw_database_tables')


	def get_sql(self):
		sql = """select table_schema, table_name, 'select count(*) from ' ||  table_schema || '."' || table_name || '";' as qsql 
		       from public.vw_database_tables """
		wheresql = "\nwhere "
		if not self.include_views:
			wheresql = wheresql + " table_type = 'BASE TABLE' "
		if self.schema_names:
			schemawhere = f" table_schema = any(array{self.schema_names})"
			if wheresql == "\nwhere ":
				wheresql = wheresql + schemawhere
			else:
				wheresql = wheresql + ' and ' + schemawhere 
		sql = sql + wheresql + "\norder by 1, 2"
		return sql


	def print_sql(self):
		if not self.sql:
			self.sql = self.get_sql()
		print(self.sql)


	def get_query_rows(self, num_tries=1):
		if num_tries > 2:
			logger.warning('Unable to generate queries from SQL\n\n%s\n\nExiting...', self.sql)
			exit()
		conn = utils.connect_db()
		cur = conn.cursor()
		self.sql = self.get_sql()
		try:
			cur.execute(self.sql)
		except psycopg2.errors.UndefinedTable as e: 
			num_tries += 1
			self.create_view()
			self.get_query_rows(num_tries)	
			try:
				cur.execute(self.sql)	
			except Exception as e:
				self.get_query_rows(3)
		
		rows = cur.fetchall()
		cur.close()
		conn.close()
		if not rows:
			num_tries += 1
			self.create_view()
			self.get_query_rows(num_tries)
		return rows 


	def get_counts(self):
		if not self.counts:
			conn = utils.connect_db()
			cur = conn.cursor()
			for row in self.get_query_rows():
				schema = row[0]
				table = row[1]
				csql = row[2]
				utils.process_sql(conn, cur, csql)
				num_rows = cur.fetchone()[0]
				self.counts.append({'Schema': schema, 'Table': table, 'Row Count': num_rows})
			cur.close()
			conn.close()		


	def set_dataframe(self):
		if not self.counts:
			self.get_counts()
		self.df = pd.DataFrame(self.counts)


	def export_dataframe(self):
		if not self.df:
			self.set_dataframe()
		self.df.to_excel(self.export_file_path, index=False)



def main(schema_names=None, include_views=False, export_file_name=None, export_file_dir=None):
	c = TableRowCounts(schema_names=schema_names, 
                       include_views=include_views, 
                       export_file_name=export_file_name, 
                       export_file_dir=export_file_dir)
	c.export_dataframe()
	

if __name__ == '__main__':   
	main(schema_names=schema_names, include_views=include_views, export_file_name=export_file_name, export_file_dir=export_file_dir)		