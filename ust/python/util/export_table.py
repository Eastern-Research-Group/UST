from datetime import datetime
import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import pandas as pd

from python.util import utils
from python.util.logger_factory import logger


schema = ''              	# Enter the schema name
table_name = ''             # Enter the table name 
column_names = []           # Optional. Enter a list of column names to select. If empty list, all columns will be selected.
export_dir = None           # Optional. Defaults to '../../python/exports/other/'

class ExportTable:
	def __init__(self, 
				 schema,
				 table_name,
				 column_names=None,
				 export_dir='../../python/exports/other/'):
		self.schema = schema
		self.table_name = table_name 
		self.column_names = column_names
		self.file_name = self.schema + '.' + self.table_name  + '.xlsx'
		self.export_dir = export_dir
		os.makedirs(self.export_dir, exist_ok=True)
		self.export_file_path = self.export_dir + self.file_name


	def export(self):
		col_names = '*'
		if self.column_names:
			col_names = ''.join(['"' + c[0] + '", ' for c in self.column_names])[:-2]
		sql = f'select {col_names} from "{self.schema}"."{self.table_name}" order by 1'
		df = pd.read_sql(sql, con=utils.get_engine())
		with pd.ExcelWriter(self.export_file_path, engine='openpyxl') as writer:
			df.to_excel(writer, index=False, freeze_panes=(1,0), sheet_name='Sheet1')	
			wb = writer.book
			ws = writer.sheets['Sheet1']
		utils.autowidth(ws)
		logger.info('Wrote %s rows to %s', len(df), self.export_file_path)



def main(schema, table_name, column_names=None, export_dir=None):
	ExportTable(schema=schema, 
	     	    table_name=table_name, 
				column_names=column_names,
				export_dir=export_dir).export()


if __name__ == '__main__':   
	main(schema=schema,
		 table_name=table_name,
		 column_names=column_names,
		 export_dir=export_dir)		