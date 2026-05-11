import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import psycopg2.errors

from python.util import utils, config
from python.util.logger_factory import logger


schema = 'co_ust'
table_name = 'facs_tanks_comps'
column_name = 'Products'
delimiter = '/'
drop_existing = True


def main(schema, table_name, column_name, delimiter, drop_existing=True):
	conn = utils.connect_db()
	cur = conn.cursor()

	deagg_table_name = 'erg_' + table_name.lower() + '_' + column_name.lower() + '_deagg'

	if drop_existing:
		sql = f'drop table if exists {schema}."{deagg_table_name}"'
		utils.process_sql(conn, cur, sql)
	
	sql = f"""create table {schema}."{deagg_table_name}" ("{column_name}" text not null primary key)"""
	try:
		utils.process_sql(conn, cur, sql)
	except psycopg2.errors.DuplicateTable as e:
		logger.error('Table %s.%s already exists; set drop_existing to True to overwrite', schema, deagg_table_name)
	logger.info('Created deagg table %s.%s', schema, deagg_table_name)

	sql = f"""select distinct "{column_name}" from {schema}."{table_name}" 
	          where "{column_name}" is not null order by 1"""
	utils.process_sql(conn, cur, sql)
	rows = cur.fetchall()
	for row in rows:
		col_text = row[0]
		logger.info('Working on %s', col_text)
		col_text = col_text.strip()
		parts = col_text.split(delimiter)
		for part in parts:
			sql = f"""insert into {schema}.{deagg_table_name} ("{column_name}") 
			           values (%s) on conflict("{column_name}") do nothing"""
			utils.process_sql(conn, cur, sql, params=(part,))
		conn.commit()

	cur.close()
	conn.close()

	logger.info('Column %s has been deaggregated in table %s.%s', column_name, schema, deagg_table_name)


if __name__ == '__main__':   
	main(schema=schema, table_name=table_name, column_name=column_name, delimiter=delimiter, drop_existing=drop_existing)
