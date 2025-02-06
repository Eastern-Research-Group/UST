from datetime import date
import ntpath
import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

from python.util import utils
from python.util.logger_factory import logger


schema = 'ut_ust' 			# Set to the schema name
table_name = None 		# If None, will check all tables in the specified schema. Set variable to a single table name to check a specific table. 


def check_table(schema, table_name, cur, conn):
	sql = "select column_name from (\n"
	sql2 = f"""select 'select ' || ordinal_position || ' as sort_order,''' || column_name || ''' as column_name, count(*) from {schema}."' || 
				table_name || '" where "' || column_name || '" is not null union' as vsql 
			from information_schema.columns 
			where lower(table_schema) = lower(%s) and lower(table_name) = lower(%s)
			order by ordinal_position"""
	utils.process_sql(conn, cur, sql2, params=(schema, table_name))
	rows = cur.fetchall()
	if not rows:
		logger.warning('No columns exist in table %s.%s', schema, table_name)
		return
	for row in rows:
		sql = sql + row[0] + "\n"
	sql = sql[:-6] + "\n) a where count = 0 order by sort_order;"
	utils.process_sql(conn, cur, sql)
	rows = cur.fetchall()
	if not rows:
		logger.info('All columns in table %s.%s contain data', schema, table_name)
	else:
		logger.info('The following columns in table %s.%s are null for all rows:\n', schema, table_name)
	for row in rows:
		logger.info(row[0])
	logger.info('\n------------------------------------------------------------------------------------------------------------------\n')



def main(schema, table_name=None):
	conn = utils.connect_db()
	cur = conn.cursor()

	if not table_name:
		sql = """select table_name from information_schema.tables where lower(table_schema) = lower(%s) order by 1"""
		utils.process_sql(conn, cur, sql, params=(schema,))
		rows = cur.fetchall()
		for row in rows:
			table_name = row[0]
			logger.info('Working on table %s.%s', schema, table_name)
			check_table(schema, table_name, cur, conn)
	else:
		sql = """select count(*) from information_schema.tables 
          where lower(table_schema) = lower(%s) and lower(table_name) = lower(%s)"""
		utils.process_sql(conn, cur, sql, params=(schema, table_name))
		cnt = cur.fetchone()[0]
		if cnt == 0:
			logger.warning('No table named %s exists in schema %s', table_name, schema)
			exit()
		check_table(schema, table_name, cur, conn)

	cur.close()
	conn.close()



if __name__ == '__main__':   
	main(schema=schema,
		 table_name=table_name)