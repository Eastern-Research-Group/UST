import os
from pathlib import Path
import sys
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import pandas as pd
import pyodbc
from sqlalchemy import create_engine

from python.util import utils
from python.util.logger_factory import logger, error_logger


host = '4.36.57.30'
db = 'ERG_UST'
user = 'ergustuser'
password = ''

export_file_dir = '../../python/exports/source_data/OR/' 


def get_tables_to_export():
	conn = utils.connect_oregon_db(host, db, user, password)
	cur = conn.cursor()
	sql = "select table_name from TEMP_erg_tables where exported is null order by 1"
	cur.execute(sql)
	rows = cur.fetchall()
	cur.close()
	conn.close()
	return [r[0] for r in rows]


def export_tables_to_db():
	conn = utils.connect_sqlserver_db()
	cur = conn.cursor()	
	ssengine = utils.get_sqlserver_engine()
	engine = utils.get_engine()

	tables_to_export = get_tables_to_export()
	for table in tables_to_export:
		logger.info('Working on %s', table)
		df = pd.read_sql(f'select * from {table}', ssengine)
		df.to_sql(table, engine, schema='or_ust', index=False)
		logger.info('%s exported', table)
		sql = "update TEMP_erg_tables set exported = 'Y' where table_name = ?"
		cur.execute(sql, table)
		cur.commit()

	cur.close()
	conn.close()


def export_tables_to_csv(schema='or_ust'):
	conn = utils.connect_db()
	cur = conn.cursor()
	sql = """select table_name from information_schema.tables 
	        where table_schema = %s and table_type = 'BASE TABLE' and table_name not like 'erg_%%'
	        order by 1"""
	utils.process_sql(conn, cur, sql, params=(schema,))
	rows = cur.fetchall()
	tables_to_export = [r[0] for r in rows]
	cur.close()
	conn.close()
	engine = utils.get_engine()
	Path(export_file_dir).mkdir(parents=True, exist_ok=True)	
	for row in rows:
		table = row[0]
		logger.info('Working on %s', table)
		df = pd.read_sql_table(table, con=engine, schema=schema)
		logger.info('Loaded table "%s" from database', table)
		export_file_path = export_file_dir + table + '.csv'
		df.to_csv(export_file_path, index=False)
		logger.info('Exported table "%s" to %s', table, export_file_path)


export_tables_to_db()
export_tables_to_csv()

