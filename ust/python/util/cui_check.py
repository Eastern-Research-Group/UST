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
table_name = ''             # Enter the table name that contains the column(s) with possible CUI
column_names = ['']         # Enter a list of column names that contain possible CUI


class CuiCheck:
	conn = None 
	cur = None 


	def __init__(self, 
				 schema,
				 table_name,
				 column_names):
		self.schema = schema
		self.table_name = table_name 
		self.column_names = column_names
		self.connect_db()
		self.clean_variables()
		self.new_table_name = self.table_name + '_clean_cui'
		self.file_name='CUI_check_' + self.schema + '_' + self.table_name  + '.xlsx'
		self.export_dir = '../../python/exports/cui/'
		os.makedirs(self.export_dir, exist_ok=True)
		self.export_file_path = self.export_dir + self.file_name
		self.duplicate_table()
		self.eliminate_nonchars()
		self.eliminate_multihyphen()
		self.eliminate_stopwords()
		self.eliminate_spaces()
		self.write_data()
		self.disconnect_db()


	def clean_variables(self):
		sql = """select schema_name from information_schema.schemata 
				 where schema_owner = 'ugst_ergone' and lower(schema_name) = lower(%s)"""
		utils.process_sql(self.conn, self.cur, sql, params=(self.schema,))
		self.schema = self.cur.fetchone()[0]
		logger.info('Schema name is %s', self.schema)

		sql = """select table_name from information_schema.tables 
				 where table_schema = %s and lower(table_name) = lower(%s)"""
		utils.process_sql(self.conn, self.cur, sql, params=(self.schema, self.table_name))
		self.table_name = self.cur.fetchone()[0]
		logger.info('Table name is %s', self.table_name)

		col_names = self.column_names
		self.column_names = []
		for col_name in col_names:
			sql = """select column_name from information_schema.columns 
					 where table_schema = %s and table_name = %s
					 and lower(column_name) = lower(%s)"""
			utils.process_sql(self.conn, self.cur, sql, params=(self.schema, self.table_name, col_name))
			self.column_names.append(self.cur.fetchone()[0])
		logger.info('Column names are %s', self.column_names)


	def duplicate_table(self):
		sql = f'drop table if exists "{self.schema}"."{self.new_table_name}"'
		utils.process_sql(self.conn, self.cur, sql)
		logger.info('Dropped table %s.%s if it existed', self.schema, self.new_table_name)

		sql = f"""select generate_create_table_statement('{self.schema}','{self.table_name}')"""
		utils.process_sql(self.conn, self.cur, sql)
		ddl_sql = self.cur.fetchone()[0]
		for col_name in self.column_names:
			i = ddl_sql.find(col_name)
			i2 = i + ddl_sql[i:].find(',\n') + 2
			col_def = ddl_sql[i:i2]
			new_col_def = '\t"' + col_name + '_cui" boolean,\n'
			ddl_sql = ddl_sql[:i] + col_def + new_col_def + ddl_sql[i+len(col_def):]
		ddl_sql = ddl_sql.replace(f'CREATE TABLE {self.schema}.{self.table_name}', f'CREATE TABLE {self.schema}."{self.new_table_name}"')
		utils.process_sql(self.conn, self.cur, ddl_sql)
		logger.info('Created table %s.%s', self.schema, self.new_table_name)

		sql = f"""select column_name from information_schema.columns 
				  where table_schema = %s and table_name = %s 
				  order by ordinal_position"""
		utils.process_sql(self.conn, self.cur, sql, params=(self.schema, self.table_name))
		rows = self.cur.fetchall()
		column_str = ''.join(['"' + r[0] + '", ' for r in rows])[:-2]

		sql = f"""insert into "{self.schema}"."{self.new_table_name}" ({column_str})
				  select {column_str} from "{self.schema}"."{self.table_name}" """
		utils.process_sql(self.conn, self.cur, sql)
		logger.info('Inserted %s rows into %s.%s', self.cur.rowcount, self.schema, self.new_table_name)
		self.conn.commit()


	def eliminate_nonchars(self):
		for colname in self.column_names:
			logger.info('Working on non-char characters in column %s', colname)
			new_colname = colname + '_cui'
			sql = f"""update "{self.schema}"."{self.new_table_name}"
					  set "{new_colname}" = False 
					  where "{new_colname}" is null 
					  and "{colname}" ~ '[^A-Za-z .&-]+'"""
			utils.process_sql(self.conn, self.cur, sql)
			logger.info('Eliminated %s rows due to non-char characters', self.cur.rowcount)
			self.conn.commit()


	def eliminate_multihyphen(self):
		for colname in self.column_names:
			logger.info('Working on multi-hyphens in column %s', colname)
			new_colname = colname + '_cui'
			sql = f"""update "{self.schema}"."{self.new_table_name}"
					  set "{new_colname}" = False 
					  where "{new_colname}" is null 
					  and (char_length("{colname}") - char_length(replace("{colname}",'-',''))) / char_length(' ' ) > 1"""
			utils.process_sql(self.conn, self.cur, sql)
			logger.info('Eliminated %s rows due to multiple hyphens', self.cur.rowcount)
			self.conn.commit()


	def eliminate_stopwords(self):
		for colname in self.column_names:
			logger.info('Working on stopwords in column %s', colname)
			new_colname = colname + '_cui'
			sql = f"""update "{self.schema}"."{self.new_table_name}" a
					set "{new_colname}" = False 
					where "{new_colname}" is null and exists 
						(select 1 from public.cui_exclusions b 
						where ' ' || lower(a."{colname}") || ' '  like '% ' || b.string || ' %')"""
			utils.process_sql(self.conn, self.cur, sql)
			logger.info('Eliminated %s rows due to a stopword', self.cur.rowcount)
			self.conn.commit()


	def eliminate_spaces(self):
		for colname in self.column_names:
			logger.info('Working on number of spaces in column %s', colname)
			new_colname = colname + '_cui'
			sql = f"""update "{self.schema}"."{self.new_table_name}" a
					set "{new_colname}" = False 
					where "{new_colname}" is null 
					and (char_length("{colname}") - char_length(replace("{colname}",' ',''))) / char_length(' ' ) not in (1,2,3)"""
			utils.process_sql(self.conn, self.cur, sql)
			logger.info('Eliminated %s rows due to too many or too few spaces', self.cur.rowcount)
			self.conn.commit()


	def write_data(self):
		sql = f'select * from "{self.schema}"."{self.new_table_name}" order by "{self.column_names[0]}"'
		df = pd.read_sql(sql, con=utils.get_engine())
		with pd.ExcelWriter(self.export_file_path, engine='openpyxl') as writer:
			df.to_excel(writer, index=False, freeze_panes=(1,0), sheet_name='CUI Check')	
			wb = writer.book
			ws = writer.sheets['CUI Check']
			ws = utils.add_ws_filter(ws)
			columns_to_adjust = []
			for col in self.column_names:
				columns_to_adjust.append(col)
				columns_to_adjust.append(col +  '_cui')
			for col in ws.columns:
				if col[0].value in columns_to_adjust:
					utils.autowidth_column(ws, col)
		logger.info('Wrote %s rows to %s', len(df), self.export_file_path)


	def connect_db(self):
		self.conn = utils.connect_db()
		self.cur = self.conn.cursor()
		logger.info('Connected to database')
		

	def disconnect_db(self):
		self.cur.close()
		self.conn.close()
		logger.info('Disconnected from database')



def main(schema, table_name, column_names):
	cui = CuiCheck(schema=schema, 
				   table_name=table_name, 
				   column_names=column_names)


if __name__ == '__main__':   
	main(schema=schema,
		 table_name=table_name,
		 column_names=column_names)		