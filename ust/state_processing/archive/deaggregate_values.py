import sys
import os
sys.path = [os.path.join(os.path.dirname(__file__), "..", "..")] + sys.path
from ust.util.logger_factory import logger
from ust.util import utils


def main(state, ust_or_lust, element_name, data_name, key_column, value_column, delimiter=','):
	schema = utils.get_schema_name(state, ust_or_lust)

	conn = utils.connect_db()
	cur = conn.cursor()

	deagg_table_name = f'"{schema}"."{element_name}_deagg"'
	sql = f'drop table {deagg_table_name}'
	try:
		cur.execute(sql)
		logger.info('Dropped table %s', deagg_table_name)
	except:
		pass 

	sql = f'create table {deagg_table_name} ("{key_column}" text, "{value_column}" text, rownumber int)'
	cur.execute(sql)
	logger.info('Created table %s', deagg_table_name)

	sql = f"""select distinct "{key_column}", "{value_column}"
			  from "{schema}"."{data_table}"
			  where "{value_column}" is not null 
			  order by 1, 2"""
	cur.execute(sql)
	rows = cur.fetchall()
	for row in rows:
		i = 1
		vals = row[1].split(delimiter)
		for val in vals:
			sql2 = f"insert into {deagg_table_name} values (%s, %s, %s)"
			cur.execute(sql2, (row[0], val.strip(), i))
			print(f'{row[0]} : {val.strip()} ({i})')
			i += 1
		conn.commit()

	sql = f'select count(*) from {deagg_table_name}'
	cur.execute(sql)
	cnt = cur.fetchone()[0]
	logger.info('There are %s rows in table %s', cnt, deagg_table_name)

	cur.close()
	conn.close()



if __name__ == '__main__':
	state = 'NE'
	ust_or_lust = 'LUST'
	element_name = 'SubstanceReleased1'
	data_table = 'ne_lust'
	key_column = 'LUSTID'
	value_column = 'SubstanceReleased1'
	delimiter = ', '
	main(state, ust_or_lust, element_name, data_table, key_column, value_column, delimiter)