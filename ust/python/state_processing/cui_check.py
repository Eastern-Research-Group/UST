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

'''
This script runs several checks against a specified database column in an attempt to identify rows that are likely NOT CUI. 
If the data have already been mapped, you can just set the ust_or_release, and control_id or organization_id variables and 
the script will use the mapping tables to identify the column to check. 
If the data are not already mapped, use the schema/table_name/column_name variables. 
'''


ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = 14                 	# Enter an integer that is the ust_control_id or release_control_id
organization_id = ''			# Optional; only used if control_id is not passed. If control_id == 0 or None, the script will retrieve the most recent control_id for the organization. 

schema = None              		# Enter the schema name
table_name = None             	# Enter the table name that contains the column(s) with possible CUI
column_names = []         	# Enter a list of column names that contain possible CUI    

drop_existing = True            # Boolean; defaults to True. If True, will drop the erg_%_clean_cui table if it exists. 
maybe_as_true = True            # Boolean. Set to True to mark stopwords with the "maybe flag" to TRUE instead of MAYBE


# Set the following variables if the data to be checked for CUI is not yet in the database and you need to upload a file first:
# upload_file_path = r"C:\Users\erguser\Downloads\MD_UST_template_20240925160404_OUST notes_10-18-24.xlsx"			# Path to Excel, CSV, or text file to upload. 
# upload_schema = 'md_ust'		# Schema to upload the file to. 
# upload_table_name = 'erg_facility'  		# Only used if single tab Excel spreadsheet or CSV. Multi-tab Excel files use tab names as table names.
# upload_overwrite_table = False  # Boolean. Set to True to overwrite table(s) if exists. 
# upload_excel_tabs = ['Facility']     

upload_file_path = r""				# Path to Excel, CSV, or text file to upload. 
upload_schema = ''			        # Schema to upload to. 
upload_table_name = None  			# Only used if single tab Excel spreadsheet or CSV. Multi-tab Excel files use tab names as table names.
upload_overwrite_table = False      # Boolean. Set to True to overwrite table(s) if exists. 
upload_excel_tabs = None            # For multi-tab Excel files, enter a string or list containing the sheet names to export. Leave as None to export all tabs.



class CuiCheck:
	conn = None 
	cur = None 

	def __init__(self, 
			     ust_or_release=None,
			     control_id=None,
			     organization_id=None,
				 schema=None,
				 table_name=None,
				 column_names=None,	   
	     		 drop_existing=True,  
				 maybe_as_true=False,
				 upload_file_path = None,
				 upload_schema = None,
				 upload_table_name = None,
				 upload_overwrite_table = False,
				 upload_excel_tabs = None,
				 perform_check=True):
		self.ust_or_release = ust_or_release
		self.control_id = control_id
		self.organization_id = organization_id
		self.schema = schema
		self.table_name = table_name 
		self.column_names = column_names
		self.drop_existing = drop_existing
		self.maybe_as_true = maybe_as_true
		self.upload_file_path = upload_file_path
		self.upload_schema = upload_schema
		self.upload_table_name = upload_table_name
		self.upload_overwrite_table = upload_overwrite_table
		self.upload_excel_tabs = upload_excel_tabs
		self.parameter_check()
		self.upload_file()
		self.connect_db()
		self.clean_variables()
		self.new_table_name = 'erg_' + self.table_name + '_clean_cui'
		self.file_name='CUI_check_' + self.schema + '_' + self.table_name  + '.xlsx'
		self.export_dir = '../../python/exports/cui/'
		self.export_file_path = self.export_dir + self.file_name
		self.perform_check = perform_check
		self.print_self()
		if self.perform_check:
			self.process()
		self.disconnect_db()


	def parameter_check(self):
		if not self.control_id and not self.organization_id and not self.schema:
			logger.warning('Either control_id/organization_id or schema/table_name/column_name need to be passed; exiting...')
			exit()
		elif self.control_id and self.organization_id:
			if self.control_id != utils.get_control_id(self.ust_or_release, self.organization_id):
				logger.warning('%s_control_id %s for organization %s is %s in the database, but %s was passed.', self.ust_or_release, self.organization_id, utils.get_control_id(self.ust_or_release, self.organization_id), self.control_id)
				exit()
		elif self.control_id and not self.organization_id:
			self.organization_id = utils.get_org_from_control_id(self.control_id, self.ust_or_release)
		elif self.organization_id and not self.control_id:
			self.control_id = utils.get_control_id(self.ust_or_release, self.organization_id)

		if not self.schema or not self.table_name or not self.column_names:
			self.connect_db()
			sql = """select table_schema, organization_table_name, organization_column_name
					from public.v_cui_data_elements
					where ust_or_release = %s and control_id = %s"""
			utils.process_sql(self.conn, self.cur, sql, params=(self.ust_or_release, self.control_id))
			row = self.cur.fetchone()
			self.schema = row[0]
			self.table_name = row[1]
			self.column_names = [row[2]]


	def print_self(self):
		print('ust_or_release = ' + str(self.ust_or_release))
		print('control_id = ' + str(self.control_id))
		print('organization_id = ' + str(self.organization_id))
		print('schema = ' +  str(self.schema))
		print('table_name = ' +  str(self.table_name))
		print('column_names = ' + str( self.column_names))
		print('drop_existing = ' + str( self.drop_existing))
		print('maybe_as_true = ' + str( self.maybe_as_true))
		print('upload_file_path = ' +  str(self.upload_file_path))
		print('upload_schema = ' +  str(self.upload_schema))
		print('upload_table_name = ' +  str(self.upload_table_name))
		print('upload_overwrite_table = ' + str( self.upload_overwrite_table))
		print('upload_excel_tabs = ' + str( self.upload_excel_tabs))
		print('new_table_name = ' +  str(self.new_table_name))
		print('file_name = ' +  str(self.file_name))
		print('export_dir = ' +  str(self.export_dir))
		print('export_file_path = ' +  str(self.export_file_path))
		print('perform_check = ' + str( self.perform_check))


	def clean_variables(self):
		sql = """select schema_name from information_schema.schemata 
				 where schema_owner = 'ugst_ergone' and lower(schema_name) = lower(%s)"""
		utils.process_sql(self.conn, self.cur, sql, params=(self.schema,))
		self.schema = self.cur.fetchone()[0]
		logger.info('Schema name is %s', self.schema)

		sql = """select table_name from information_schema.tables 
				 where table_schema = %s and lower(table_name) = lower(%s)"""
		utils.process_sql(self.conn, self.cur, sql, params=(self.schema, self.table_name))
		# utils.pretty_print_query(self.cur)
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


	def drop_table(self):
		sql = f'drop table "{self.schema}"."{self.new_table_name}"'
		utils.process_sql(self.conn, self.cur, sql)
		logger.info('Dropped table %s.%s', self.schema, self.new_table_name)


	def duplicate_table(self):
		sql = "select count(*) from information_schema.tables where table_schema = %s and table_name = %s"
		utils.process_sql(self.conn, self.cur, sql, params=(self.schema, self.new_table_name))
		cnt = self.cur.fetchone()[0]
		if cnt > 0 and self.drop_existing:
			logger.info('Table %s.%s already exists and will be dropped.', self.schema, self.new_table_name)
			self.drop_table()
			cnt = 0
		elif cnt > 0 and not self.drop_existing:
			logger.warning('Table %s.%s already exists but drop_existing is False; exiting.', self.schema, self.new_table_name)
			exit()

		if cnt == 0:
			sql = f"select generate_create_table_statement('{self.schema}','{self.table_name}')"
			utils.process_sql(self.conn, self.cur, sql)
			utils.pretty_print_query(self.cur)
			ddl_sql = self.cur.fetchone()[0]
			for col_name in self.column_names:
				i = ddl_sql.find(col_name)
				end = ddl_sql[i:].find(',\n')
				if end < 0:
					i2 = len(ddl_sql) - 2
				else:
					i2 = i + end + 2
				col_def = ddl_sql[i:i2]
				new_col_def = '\t"' + col_name + '_cui" varchar(20)' 
				if end > 0:
					new_col_def = new_col_def + ','
				new_col_def = new_col_def + '\n'
				ddl_sql = ddl_sql[:i] + col_def + new_col_def + ddl_sql[i+len(col_def):]
			ddl_sql = ddl_sql.replace(f'CREATE TABLE {self.schema}.{self.table_name}', f'CREATE TABLE {self.schema}."{self.new_table_name}"')
			ddl_sql = ddl_sql.replace(';;',';')
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
					  set "{new_colname}" = 'FALSE' 
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
					  set "{new_colname}" = 'FALSE' 
					  where "{new_colname}" is null 
					  and (char_length("{colname}") - char_length(replace("{colname}",'-',''))) / char_length(' ' ) > 1"""
			utils.process_sql(self.conn, self.cur, sql)
			logger.info('Eliminated %s rows due to multiple hyphens', self.cur.rowcount)
			self.conn.commit()


	def eliminate_stopwords(self):
		for colname in self.column_names:
			logger.info('Working on stopwords in column %s', colname)
			new_colname = colname + '_cui'

			if maybe_as_true:
				maybetrue = 'TRUE'
			else:
				maybetrue = 'MAYBE'

			sql = f"""update "{self.schema}"."{self.new_table_name}" a
					set "{new_colname}" = '{maybetrue}' 
					where "{new_colname}" is null and exists 
						(select 1 from public.cui_exclusions b 
						where b.maybe_flag = 'Y' and ' ' || lower(a."{colname}") || ' '  like '%% ' || b.stopword || ' ')
					and (char_length("{colname}") - char_length(replace("{colname}", ' ', ''))) / char_length(' ') > 1
					and not exists 
						(select 1 from public.cui_exclusions c 
						where c.maybe_flag is null and ' ' || trim(lower(a."{colname}")) || ' '  like '%% ' || c.stopword || ' %%')"""
			utils.process_sql(self.conn, self.cur, sql)
			logger.info('Set %s rows to %s due to a flagged stopword', self.cur.rowcount, maybetrue)
			self.conn.commit()

			sql = f"""update "{self.schema}"."{self.new_table_name}" a
					set "{new_colname}" = 'FALSE' 
					where "{new_colname}" is null and exists 
						(select 1 from public.cui_exclusions b 
						where ' ' || trim(lower(a."{colname}")) || ' '  like '%% ' || b.stopword || ' %%')"""
			utils.process_sql(self.conn, self.cur, sql)
			# utils.pretty_print_query(self.cur)
			logger.info('Eliminated %s rows due to a stopword', self.cur.rowcount)
			self.conn.commit()


	def eliminate_spaces(self):
		for colname in self.column_names:
			logger.info('Working on number of spaces in column %s', colname)
			new_colname = colname + '_cui'
			sql = f"""update "{self.schema}"."{self.new_table_name}" a
					set "{new_colname}" = 'FALSE' 
					where "{new_colname}" is null 
					and (char_length("{colname}") - char_length(replace("{colname}", ' ', ''))) / char_length(' ') not in (1,2,3)"""
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


	def process(self):
		os.makedirs(self.export_dir, exist_ok=True)
		self.duplicate_table()
		self.eliminate_nonchars()
		self.eliminate_multihyphen()
		self.eliminate_stopwords()
		self.eliminate_spaces()
		self.write_data()


	def connect_db(self):
		if not self.conn:
			self.conn = utils.connect_db()
			self.cur = self.conn.cursor()
			logger.info('Connected to database')
		

	def disconnect_db(self):
		if self.conn:
			self.conn.commit()
			self.cur.close()
			self.conn.close()
			logger.info('Disconnected from database')


	def upload_file(self):
		if self.upload_file_path:
			t = Importer(self.upload_file_path, 
				         schema=self.upload_schema, 
				         table_name=self.upload_table_name, 
				         overwrite_table=self.upload_overwrite_table,
				         excel_tabs=self.upload_excel_tabs)
			t.save_file_to_db()		


def main(ust_or_release=None,
		 control_id=None,
		 organization_id=None,
		 schema=None, 
	     table_name=None, 
	     column_names=None, 
	     drop_existing=True,
	     maybe_as_true=False,
	     upload_file_path=None, 
	     upload_schema=None, 
	     upload_table_name=None, 
	     upload_overwrite_table=False,
	     upload_excel_tabs=None):
	cui = CuiCheck(ust_or_release=ust_or_release,
				   control_id=control_id,
				   organization_id=organization_id,
				   schema=schema, 
				   table_name=table_name, 
				   column_names=column_names,
				   drop_existing=drop_existing,
				   maybe_as_true=maybe_as_true,
			 	   upload_file_path=upload_file_path,
				   upload_schema=upload_schema,
				   upload_table_name=upload_table_name,
				   upload_overwrite_table=upload_overwrite_table,
				   upload_excel_tabs=upload_excel_tabs)


if __name__ == '__main__':   
	main(ust_or_release=ust_or_release,
	     control_id=control_id,
		 organization_id=organization_id,
		 schema=schema,
		 table_name=table_name,
		 column_names=column_names,
		 drop_existing=drop_existing,
		 maybe_as_true=maybe_as_true,
	 	 upload_file_path=upload_file_path,
		 upload_schema=upload_schema,
		 upload_table_name=upload_table_name,
		 upload_overwrite_table=upload_overwrite_table,
		 upload_excel_tabs=upload_excel_tabs)		