from datetime import date
import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import pandas as pd

from python.util import utils, config
from python.util.logger_factory import logger


schema_names = None
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


	def get_query_rows(self):
		conn = utils.connect_db()
		cur = conn.cursor()
		self.sql = self.get_sql()
		utils.process_sql(conn, cur, self.sql)
		rows = cur.fetchall()
		cur.close()
		conn.close()
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