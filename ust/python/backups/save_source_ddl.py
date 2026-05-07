import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

from python.backups.save_ddl import Ddl 
from python.util import utils, config
from python.util.logger_factory import logger


schema = '' # If None, will export DDL for all _ust and _release schemas. 


def save_ddl(schema, object_name):
	Ddl(schema=schema, object_name=object_name).export()
	

def get_objects(schema):
	conn = utils.connect_db()
	cur = conn.cursor()

	sql = """select object_name, object_type
			from v_objects 
			where schema_name = %s 
			and ((object_type = 'table' and lower(object_name) like 'erg_%%')
			or object_type in ('view','function'))
			order by 2, 1"""
	utils.process_sql(conn, cur, sql, params=(schema,))
	rows = cur.fetchall()
	for row in rows:
		object_name = row[0]
		logger.info('Working on %s.%s (%s)', schema, object_name, row[1])
		save_ddl(schema, object_name)

	cur.close()
	conn.close()


def main():
	conn = utils.connect_db()
	cur = conn.cursor()

	sql = """select schema_name from information_schema.schemata
			where schema_name like '%_ust' or schema_name like '%_release'
			order by 1"""
	utils.process_sql(conn, cur, sql)
	rows = cur.fetchall()
	for row in rows:
		schema = row[0]
		logger.info('Working on schema %s', schema)
		get_objects(schema)

	cur.close()
	conn.close()
	

if __name__ == '__main__':  
	if schema:
		get_objects(schema)
	else:
		main()