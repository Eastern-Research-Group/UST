from datetime import date
import ntpath
import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

from python.util import utils, config
from python.util.logger_factory import logger


schema = 'public'
object_name = None # If None, will export all tables, views, and functions 
# TODO: passing an object_name is not yet supported
export_path = '../../sql/ddl/'


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