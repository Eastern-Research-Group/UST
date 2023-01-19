from logger_factory import logger
import utils

from psycopg2.errors import DuplicateTable


def create_deagg_table(cur, deagg_table_name, deagg_column_name):
	sql = f"create table {deagg_table_name} ({deagg_column_name} varchar(200) not null primary key)"
	try:
		cur.execute(sql)
		logger.info('Created table %s', deagg_table_name)
	except DuplicateTable:
		pass


def get_unique_values(cur, table_name, column_name):
	unique_values = []
	sql = f'select distinct "{column_name}" from "{table_name}" where "{column_name}" is not null order by 1'
	cur.execute(sql)
	rows = cur.fetchall()
	for row in rows:
		# print(row[0])
		values = row[0].split(',')
		for value in values:
			v = value.replace('*','').strip()
			if v not in unique_values:
				unique_values.append((v,))
	# print(unique_values)
	return unique_values


def insert_values(cur, unique_values, deagg_table_name, deagg_column_name):
	args = ','.join(cur.mogrify('(%s)', i).decode('utf-8') for i in unique_values)
	cur.execute(f"insert into {deagg_table_name} values " + args + f" on conflict ({deagg_column_name}) do nothing")
	rowcount = cur.rowcount
	logger.info('Inserted %s rows into table %s', rowcount, deagg_table_name)


def main(db_name, table_name, column_name, deagg_table_name, deagg_column_name, mapping_table):
	conn = utils.connect_db(db_name)
	cur = conn.cursor()

	# create_deagg_table(cur, deagg_table_name, deagg_column_name)
	# unique_values = get_unique_values
	# insert_values(cur, unique_values, deagg_table_name, deagg_column_name)
	# conn.commit()

	sql = f"""select {deagg_column_name} from {deagg_table_name} 
	          where {deagg_column_name} not in (select state_value from {mapping_table}) order by 1"""
	cur.execute(sql)
	rows = cur.fetchall()
	for row in rows:
		print(row[0])


	cur.close()
	conn.close()


if __name__ == '__main__':
	state = 'CA'
	ust_or_lust = 'LUST'
	db_name = state + '_' + ust_or_lust

	table_name = 'sites' 
	column_name = 'POTENTIAL_CONTAMINANTS_OF_CONCERN'
	deagg_table_name = 'substances'
	deagg_column_name = 'state_substance'
	mapping_table = 'substance_xwalk'
 
	main(db_name, table_name, column_name, deagg_table_name, deagg_column_name, mapping_table)