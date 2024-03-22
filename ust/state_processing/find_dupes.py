import sys
import os
sys.path = [os.path.join(os.path.dirname(__file__), "..", "..")] + sys.path
from ust.util.logger_factory import logger
from ust.util import utils

import psycopg2.errors


def list_to_string(obj):
	if type(obj) is list:
		return  '"' + '", "'.join(obj) + '"'
	elif type(obj) is str:
		return '"' + obj + '"'


def main(schema, table_name, key_columns):
	conn = utils.connect_db()
	cur = conn.cursor()


	sql = f"""select column_name from information_schema.columns
	          where table_schema = %s and table_name = %s order by ordinal_position"""
	cur.execute(sql, (schema, table_name))
	rows = cur.fetchall()
	nonkey_columns = [row[0] for row in rows if row[0] not in key_columns]

	col_string = list_to_string(key_columns)
	sql = f"""select * from (
			  select {col_string},
			  	row_number() over(partition by {col_string} order by {col_string} asc) as row
			  from "{schema}"."{table_name}") dupes where dupes.row > 1"""

	cur.execute(sql)
	for row in cur.fetchall():
		for ncol in nonkey_columns:
			sql_a = 'select count(distinct "' + ncol + '") from "' + schema + '"."' + table_name + '" where '
			i = 0
			kcol_string = ''
			for kcol in key_columns:
				kcol_string = kcol_string + '"' + kcol + '" = ' + "'" + str(row[i]) + "' and "
				i += 1
			kcol_string = kcol_string[:-5]
			cur.execute(sql_a + kcol_string)
			cnt = cur.fetchone()[0]
			if cnt > 1:
				# sql2 = 'select "' + ncol + '", count(*) from "' + schema + '"."' + table_name + '" where ' + kcol_string
				# sql2 = sql2 + ' group by "' + ncol + '" order by 1'
				# cur.execute(sql2)
				# rows = cur.fetchall()
				# results = ''
				# for r in rows:
				# 	results = results + str(r[0]) + ': ' + str(r[1]) + '; '
				# results = results[:-2]

				ssql = 'select ' + col_string + ', "' + ncol + '" from "' + schema + '"."' + table_name + '" where ' + kcol_string + ';'
				logger.info('%s rows returned for           %s', cnt, ssql)

	cur.close()
	conn.close()

	logger.info('Done dupe search')

if __name__ == '__main__':
	schema = "TRUSTD_LUST"
	table_name = 'v_lust_base'
	key_columns = ["LUSTID"]
	main(schema, table_name, key_columns)
	
