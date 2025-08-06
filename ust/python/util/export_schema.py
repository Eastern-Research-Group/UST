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
exclude_erg_tables = True  	# Boolean; defaults to True If True, will exclude all tables with an "erg_" prefix to their name.
export_dir = None           # Optional. Defaults to '../../python/exports/other/[schema]'

class ExportSchema:
	def __init__(self, 
				 schema,
				 exclude_erg_tables=True,
				 export_dir=None):
		self.schema = schema
		self.exclude_erg_tables = exclude_erg_tables
		if export_dir:
			self.export_dir = export_dir 
		else:
			self.export_dir = '../../python/exports/other/' + self.schema + '/'


	def export(self):
		conn = utils.connect_db()
		cur = conn.cursor()
		sql = """select table_name from information_schema.tables 
		        where table_schema = %s and table_type = 'BASE TABLE' """
		if self.exclude_erg_tables:
			sql = sql + " and table_name not like 'erg_%%' "
		sql = sql + "order by 1"
		utils.process_sql(conn, cur, sql, params=(schema,))
		rows = cur.fetchall()
		tables_to_export = [r[0] for r in rows]
		cur.close()
		conn.close()
		engine = utils.get_engine()
		Path(self.export_dir).mkdir(parents=True, exist_ok=True)	
		for row in rows:
			table = row[0]
			logger.info('Working on %s', table)
			df = pd.read_sql_table(table, con=engine, schema=schema)
			logger.info('Loaded table "%s" from database', table)
			export_file_path = self.export_dir + table + '.csv'
			df.to_csv(export_file_path, index=False)
			logger.info('Exported table "%s" to %s', table, export_file_path)



def main(schema, exclude_erg_tables=True, export_dir=None):
	ExportSchema(schema=schema, 
		         exclude_erg_tables=exclude_erg_tables,
				 export_dir=export_dir).export()


if __name__ == '__main__':   
	main(schema=schema,
		 exclude_erg_tables=exclude_erg_tables,
		 export_dir=export_dir)		