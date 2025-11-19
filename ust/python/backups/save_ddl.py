import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

from python.util import utils, config
from python.util.logger_factory import logger


schema = 'public'
export_path = None # If None, will default to ../../sql/ddl/[schema]
object_name = None # If None, will export all tables, views, and functions 


class Ddl:
	conn = None 
	cur = None 
	object_type = None 

	def __init__(self, 
				 schema,
				 export_path='../../sql/ddl',
				 object_name=None):
		self.schema = schema
		if not export_path:
			export_path = '../../sql/ddl'
		if object_name:
			self.object_type = self.get_object_type(object_name)
			if not self.object_type:
				logger.warning('object_name %s either does not exist in schema %s or is not a table, view, or function', object_name, self.schema)
				exit()
			else:
				self.object_name = object_name
		else:
			self.object_name = None 
		self.export_path = export_path + '/' + self.schema + '/'


	def export(self):
		if self.object_name:
			if self.object_type == 'table':
				self.export_tables()
			elif self.object_type == 'view':
				self.export_views()
			elif self.object_type == 'function':
				self.export_functions()
			elif self.object_type is not null:
				logger.warning('Unknown object_type: %s', self.object_type)
		else:
			self.export_all()


	def export_all(self):
		self.connect_db()
		self.export_views()
		self.export_tables()
		self.export_functions()
		self.disconnect_db()


	def export_views(self):
		os.makedirs(self.export_path + 'view/', exist_ok=True)

		connected = False 
		if not self.conn:
			connected = True 
			self.connect_db()

		sql = """select table_name from information_schema.tables
				where table_schema = %s and table_type = 'VIEW' """
		if self.object_name:
			sql = sql + f"and lower(table_name) = lower('{self.object_name}') "
		sql = sql + "order by 1"
		utils.process_sql(self.conn, self.cur, sql, params=(self.schema,))
		rows = self.cur.fetchall()
		for row in rows:
			view_name = row[0]
			file_name = view_name + '.sql'
			file_path = self.export_path + 'view/' + file_name
			ddl_sql = 'create or replace view "' + self.schema + '"."' + view_name + '" as\n'
			sql2 = f"""select pg_get_viewdef('"{self.schema}"."{view_name}"')"""
			utils.process_sql(self.conn, self.cur, sql2)
			ddl_sql = ddl_sql + self.cur.fetchone()[0]
			with open(file_path, 'w') as f:
				f.write(ddl_sql)
			logger.info('Saved view %s DDL to %s', view_name, file_path)

		if connected:
			self.disconnect_db()


	def export_tables(self):
		os.makedirs(self.export_path + 'table/', exist_ok=True)

		connected = False 
		if not self.conn:
			connected = True 
			self.connect_db()

		sql = """select table_name from information_schema.tables
				where table_schema = %s and table_type like '%%TABLE' """
		if self.object_name:
			sql = sql + f"and lower(table_name) = lower('{self.object_name}') "
		sql = sql + "order by 1"
		utils.process_sql(self.conn, self.cur, sql, params=(self.schema,))
		rows = self.cur.fetchall()
		for row in rows:
			table_name = row[0]
			file_name = table_name + '.sql'
			file_path = self.export_path + 'table/' + file_name
			sql2 = f"""select generate_create_table_statement('{self.schema}','{table_name}')"""
			utils.process_sql(self.conn, self.cur, sql2)
			ddl_sql = self.cur.fetchone()[0]

			# constraints
			sql2 = """select con.conname from pg_catalog.pg_constraint con
						join pg_catalog.pg_class rel on rel.oid = con.conrelid
						join pg_catalog.pg_namespace nsp on nsp.oid = connamespace
					where nsp.nspname = %s and rel.relname = %s"""
			utils.process_sql(self.conn, self.cur, sql2, params=(self.schema, table_name))
			rows2 = self.cur.fetchall()
			for row2 in rows2:
				constraint_name = row2[0]
				sql3 = """select format('ALTER TABLE %%I.%%I ADD CONSTRAINT %%I %%s;', 
								connamespace::regnamespace,
								conrelid::regclass,
								conname,
								pg_get_constraintdef(oid))
						from pg_constraint where conname = %s"""
				utils.process_sql(self.conn, self.cur, sql3, params=(constraint_name,))
				rows3 = self.cur.fetchall()
				for row3 in rows3:
					ddl_sql = ddl_sql + '\n\n' + row3[0]

			# indexes 
			sql3 = """select indexdef from pg_indexes
					where schemaname = %s and tablename = %s"""
			utils.process_sql(self.conn, self.cur, sql3, params=(self.schema, table_name))
			rows2 = self.cur.fetchall()
			for row2 in rows2:
				ddl_sql = ddl_sql + '\n\n' + row2[0]

			with open(file_path, 'w') as f:
				f.write(ddl_sql)
			logger.info('Saved table %s DDL to %s', table_name, file_path)		

		if connected:
			self.disconnect_db()


	def export_functions(self):
		os.makedirs(self.export_path + 'function/', exist_ok=True)

		connected = False 
		if not self.conn:
			connected = True 
			self.connect_db()

		sql = """select p.proname, p.oid
				from pg_proc p join pg_namespace ns on (p.pronamespace = ns.oid)
				where ns.nspname = %s """
		if self.object_name:
			sql = sql + f"and lower(p.proname) = lower('{self.object_name}') "
		sql = sql + "order by 1"
		utils.process_sql(self.conn, self.cur, sql, params=(self.schema,))
		rows = self.cur.fetchall()
		for row in rows:
			function_name = row[0]
			oid = row[1]
			file_name = function_name + '.sql'
			file_path = self.export_path + 'function/' + file_name
			ddl_sql = 'create or replace function "' + self.schema + '"."' + function_name + '" as\n'
			sql2 = f"""select pg_get_functiondef({oid})"""
			utils.process_sql(self.conn, self.cur, sql2)
			ddl_sql = ddl_sql + self.cur.fetchone()[0]
			with open(file_path, 'w') as f:
				f.write(ddl_sql)
			logger.info('Saved function %s DDL to %s', function_name, file_path)

		if connected:
			self.disconnect_db()


	def get_object_type(self, object_name):
		if not self.conn:
			self.connect_db()
		object_type = None 
		sql = """select object_type from public.v_objects
		         where schema_name = %s and lower(object_name) = lower(%s)
		         and object_type in ('table','view','function')"""
		utils.process_sql(self.conn, self.cur, sql, params=(self.schema, object_name))
		try:
			object_type = self.cur.fetchone()[0]
		except:
			pass
		return object_type


	def connect_db(self):
		self.conn = utils.connect_db()
		self.cur = self.conn.cursor()
		logger.info('Connected to database')
		

	def disconnect_db(self):
		self.conn.commit()
		self.cur.close()
		self.conn.close()
		logger.info('Disconnected from database')


def main(schema, export_path=None, object_name=None):
	Ddl(schema=schema, export_path=export_path, object_name=object_name).export()
	

if __name__ == '__main__':  
	if isinstance(object_name, list):
		for obj in object_name:
			main(schema=schema, export_path=export_path, object_name=obj)
	else:
		main(schema=schema, export_path=export_path, object_name=object_name)