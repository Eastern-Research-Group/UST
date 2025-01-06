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


upload_file_path = r"C:\Users\erguser\OneDrive - Eastern Research Group\Projects\UST\Chemical List 40CFR302-2024-12-12.xlsx"
schema = 'public'
table_name = 'chemical_list' # Only used if single tab Excel spreadsheet or CSV. Multi-tab Excel files use tab names as table names.


class Importer:
    def __init__(self, upload_file_path, schema='public', table_name=None):
        self.upload_file_path = upload_file_path
        self.schema = schema
        if table_name:
        	self.table_name = table_name  
        else:
	        self.table_name = self.get_table_name_from_file_name()


    def get_table_name_from_file_name(self):
        table_name = self.upload_file_path.rsplit('\\', 1)[1]
        table_name = table_name.replace(' ','_').replace('.xlsx','').replace('.xls','').replace('.csv','').replace('.txt','')
        return table_name
        
        
    def save_table_to_db(self, df):
        if self.table_name in self.existing_tables and not self.overwrite_table:
            logger.warning('Table %s already exists in the database and will not be imported because the overwrite_table flag is set to False', table_name)
            return True
        logger.info('New table name will be %s', table_name)    
        engine = utils.get_engine(schema=self.schema)    
        if self.overwrite_table:    
            df.to_sql(table_name, engine, index=False, if_exists='replace')
            logger.info('Created table %s', table_name)
        else:
            try:
                df.to_sql(table_name, engine, index=False)
                logger.info('Created table %s', table_name)       
            except error as e:
                self.bad_file_list.append(table_name)
                logger.error('Unable to load table %s; adding to bad_file_list: %s: %s', table_name, e)
        return True

    def save_file_to_db(self):
        if utils.is_excel(self.upload_file_path):
            xls = pd.ExcelFile(self.upload_file_path)
            sheet_names = xls.sheet_names
            if len(sheet_names) > 1:
                for sheet_name in sheet_names:
                    df = pd.read_excel(self.upload_file_path, sheet_name=sheet_name)
                    logger.debug('%s, worksheet %s read into dataframe', file_path, sheet_name)
                    self.save_table_to_db(df, table_name=sheet_name)
            else:
                try:
                    df = pd.read_excel(self.upload_file_path)   
                    logger.debug('%s read into dataframe', self.upload_file_path)
                except ValueError as e:
                    logger.error('Error opening %s; skipping: %s', self.upload_file_path, e) 
                    self.bad_file_list.append(table_name)
                    return False
                self.save_table_to_db(df, table_name=self.get_table_name_from_file_name(self.upload_file_path))
        elif self.upload_file_path[-3:] == 'csv':
            df = pd.read_csv(self.upload_file_path, encoding='ansi', low_memory=False)
            logger.debug('%s read into dataframe', self.upload_file_path)
            self.save_table_to_db(df, table_name=self.get_table_name_from_file_name(self.upload_file_path))
        elif self.upload_file_path[-3:] == 'txt':
            df = pd.read_csv(self.upload_file_path, sep='\t', encoding='ansi', low_memory=False)
            logger.debug('%s read into dataframe', self.upload_file_path)
            self.save_table_to_db(df, table_name=self.get_table_name_from_file_name(self.upload_file_path))
        else:
            logger.info('%s is not an .xlsx, .csv, or .txt file so aborting...', self.upload_file_path)
            sys.exit()

        return True



def main(schema, upload_file_path, table_name=None):
	conn = utils.connect_db()
	cur = conn.cursor()

	# views
	sql = """select table_name from information_schema.tables
			where table_schema = %s and table_type = 'VIEW'
			order by 1"""
	cur.execute(sql, (schema,))
	rows = cur.fetchall()
	for row in rows:
		view_name = row[0]
		file_name = view_name + '.sql'
		file_path = export_path + 'view/' + file_name
		ddl_sql = 'create or replace view "' + schema + '"."' + view_name + '" as\n'
		sql2 = f"""select pg_get_viewdef('"{schema}"."{view_name}"')"""
		cur.execute(sql2)
		ddl_sql = ddl_sql + cur.fetchone()[0]
		with open(file_path, 'w') as f:
			f.write(ddl_sql)
		logger.info('Saved view %s DDL to %s', view_name, file_path)

	# tables
	sql = """select table_name from information_schema.tables
			where table_schema = %s and table_type like '%%TABLE'
			order by 1"""
	cur.execute(sql, (schema,))
	rows = cur.fetchall()
	for row in rows:
		table_name = row[0]
		file_name = table_name + '.sql'
		file_path = export_path + 'table/' + file_name
		sql2 = f"""select generate_create_table_statement('{schema}','{table_name}')"""
		cur.execute(sql2)
		ddl_sql = cur.fetchone()[0]

		# constraints
		sql2 = """select con.conname from pg_catalog.pg_constraint con
					join pg_catalog.pg_class rel on rel.oid = con.conrelid
					join pg_catalog.pg_namespace nsp on nsp.oid = connamespace
				where nsp.nspname = 'public' and rel.relname = %s"""
		cur.execute(sql2, (table_name,))
		rows2 = cur.fetchall()
		for row2 in rows2:
			constraint_name = row2[0]
			sql3 = """select format('ALTER TABLE %%I.%%I ADD CONSTRAINT %%I %%s;', 
							connamespace::regnamespace,
							conrelid::regclass,
							conname,
							pg_get_constraintdef(oid))
					from pg_constraint where conname = %s"""
			cur.execute(sql3, (constraint_name,))
			rows3 = cur.fetchall()
			for row3 in rows3:
				ddl_sql = ddl_sql + '\n\n' + row3[0]

		# indexes 
		sql3 = """select indexdef from pg_indexes
				where schemaname = 'public' and tablename = %s"""
		cur.execute(sql3, (table_name,))
		rows2 = cur.fetchall()
		for row2 in rows2:
			ddl_sql = ddl_sql + '\n\n' + row2[0]

		with open(file_path, 'w') as f:
			f.write(ddl_sql)
		logger.info('Saved table %s DDL to %s', table_name, file_path)

	# functions
	sql = """select p.proname, p.oid
			from pg_proc p join pg_namespace ns on (p.pronamespace = ns.oid)
			where ns.nspname = %s
			order by 1"""
	cur.execute(sql, (schema,))
	rows = cur.fetchall()
	for row in rows:
		function_name = row[0]
		oid = row[1]
		file_name = function_name + '.sql'
		file_path = export_path + 'function/' + file_name
		ddl_sql = 'create or replace function "' + schema + '"."' + function_name + '" as\n'
		sql2 = f"""select pg_get_functiondef({oid})"""
		cur.execute(sql2)
		ddl_sql = ddl_sql + cur.fetchone()[0]
		with open(file_path, 'w') as f:
			f.write(ddl_sql)
		logger.info('Saved function %s DDL to %s', function_name, file_path)

	cur.close()
	conn.close()




if __name__ == '__main__':  
	main(schema=schema, object_name=object_name)