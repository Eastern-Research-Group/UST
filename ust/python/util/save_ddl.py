import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))
from datetime import date
import ntpath

from python.util.logger_factory import logger
from python.util import utils, config


schema = 'public'
object_name = None # If None, will export all tables, views, and functions 
# TODO: passing an object_name is not yet supported
export_path = '../../sql/ddl/'

#TODO: add constraints and indexes to table DDL


def main(schema, object_name=None):
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
		print(sql2)
		cur.execute(sql2)
		ddl_sql = cur.fetchone()[0]

		#TODO: add constraints and indexes

		with open(file_path, 'w') as f:
			f.write(ddl_sql)

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

	# generate_create_table_statement


	cur.close()
	conn.close()




if __name__ == '__main__':  
	main(schema=schema, object_name=object_name)