import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))
from datetime import date
import ntpath

from python.util.logger_factory import logger
from python.util import utils, config


# THIS SCRIPT DEAGGREGATES ENTIRE ROWS OF DATA THAT CONTAIN ROLLED UP DATA
# RUN SCRIPT deagg.py BEFORE THIS ONE TO DEAGGREGATE THE LOOKUP VALUES THEMSELVES. 

ust_or_release = 'ust' # valid values are 'ust' or 'release'
control_id = 11
data_table_name = 'tanks' # state table name containing aggregated data 
data_table_pk_cols = ['Facility ID', 'Tank Id'] # list of column names that the new table should be grouped by 
data_deagg_column_name = 'Substance' # column name that contains the aggregated values 
delimiter = '\n' # defaults to ','; delimiter from the column beging deaggregated in the state table. Use \n for hard returns.
deagg_table_name = 'erg_substance_deagg' 
drop_existing = True # Defaults to False. Set to True to drop the _datarows_deagg table before beginning (if you need to redo it)


def main(control_id, ust_or_release, data_table_name, data_table_pk_cols, data_deagg_column_name, deagg_table_name, delimiter=',', drop_existing=False):
	ust_or_release = ust_or_release.lower()
	if ust_or_release not in ['ust','release']:
		logger.error('Invalid value %s for ust_or_release. Valid values are ust or release. Exiting...', ust_or_release)
		exit()

	schema = utils.get_schema_from_control_id(control_id, ust_or_release)
	data_deagg_table_name = deagg_table_name.replace('_deagg','_datarows_deagg')

	conn = utils.connect_db()
	cur = conn.cursor()

	sql = "select count(*) from information_schema.tables where table_schema = %s and table_name = %s"
	cur.execute(sql, (schema, data_deagg_table_name))
	cnt = cur.fetchone()[0]
	if cnt > 0:
		if drop_existing:
			sql2 = f"drop table {schema}.{data_deagg_table_name}"
			cur.execute(sql2)
		else:
			logger.warning('Table %s.%s already exists but drop_existing flag is False. Set drop_existing to True to continue. Exiting...', schema, data_deagg_table_name)
			exit()

	# convert list of columns into a string and wrap each one in quotes 
	col_str = ''  
	for col in data_table_pk_cols:
		col_str = col_str + '"' + col + '",' 
	
	# create _datarows_deagg table with empty column for deagged values 
	sql = f"""select {col_str} cast(null as varchar(400)) as "{data_deagg_column_name}" 
	          into {schema}.{data_deagg_table_name} 
	          from {schema}.{data_table_name} where 1=2""" 
	cur.execute(sql)

	sql = f"""select distinct {col_str} "{data_deagg_column_name}" from {schema}.{data_table_name} order by 1, 2""" 
	cur.execute(sql)
	rows = cur.fetchall()
	for row in rows: 
		i = len(row)-1
		col_text = row[i]
		try:
			parts = col_text.split(delimiter)
		except AttributeError:
			parts = [None]
		for part in parts:
			# TODO: make this dynamic
			if i == 1:
				sql2 = f"""insert into {schema}.{data_deagg_table_name} ({col_str} "{data_deagg_column_name}") 
				           values (%s, %s)"""
				cur.execute(sql2, (row[0], part))
				logger.info('Inserted %s, %s into %s.%s', row[0], part, schema, data_deagg_table_name)
			elif i == 2:
				sql2 = f"""insert into {schema}.{data_deagg_table_name} ({col_str} "{data_deagg_column_name}") 
				           values (%s, %s, %s)"""
				cur.execute(sql2, (row[0], row[1], part))
				logger.info('Inserted %s, %s, %s into %s.%s', row[0], row[1], part, schema, data_deagg_table_name)
			elif i == 3:
				sql2 = f"""insert into {schema}.{data_deagg_table_name} ({col_str} "{data_deagg_column_name}") 
				           values (%s, %s, %s, %s)"""
				cur.execute(sql2, (row[0], row[1], row[2], part))
				logger.info('Inserted %s, %s, %s, %s into %s.%s', row[0], row[1], row[2], part, schema, data_deagg_table_name)
			elif i == 4:
				sql2 = f"""insert into {schema}.{data_deagg_table_name} ({col_str} "{data_deagg_column_name}") 
				           values (%s, %s, %s, %s, %s)"""
				cur.execute(sql2, (row[0], row[1], row[2], row[3], part))
				logger.info('Inserted %s, %s, %s, %s, %s into %s.%s', row[0], row[1], row[2], row[3], part, schema, data_deagg_table_name)
			elif i == 5:
				sql2 = f"""insert into {schema}.{data_deagg_table_name} ({col_str} "{data_deagg_column_name}") 
				           values (%s, %s, %s, %s, %s, %s)"""
				cur.execute(sql2, (row[0], row[1], row[2], row[3], row[4], part))
				logger.info('Inserted %s, %s, %s, %s, %s, %s into %s.%s', row[0], row[1], row[2], row[3], row[4], part, schema, data_deagg_table_name)
			elif i == 6:
				sql2 = f"""insert into {schema}.{data_deagg_table_name} ({col_str} "{data_deagg_column_name}") 
				           values (%s, %s, %s, %s, %s, %s, %s)"""
				cur.execute(sql2, (row[0], row[1], row[2], row[3], row[4], row[5], part))
				logger.info('Inserted %s, %s, %s, %s, %s, %s, %s into %s.%s', row[0], row[1], row[2], row[3], row[4], row[5], part, schema, data_deagg_table_name)
			else:
				logger.critical('There are more grouped by/pk columns (%s) in data_table_pk_cols (%s) than this script has been coded to handle. Update the loop that does the deagg.', i, data_table_pk_cols)
			
		conn.commit()


	conn.commit()
	cur.close()
	conn.close()

	logger.info('Finished deagging %s."%s"."%s" into %s', schema, data_table_name, data_deagg_column_name, data_deagg_table_name)



if __name__ == '__main__':   
	main(control_id=control_id, 
		 ust_or_release=ust_or_release, 
		 data_table_name=data_table_name, 
		 data_table_pk_cols=data_table_pk_cols,
		 data_deagg_column_name=data_deagg_column_name,
		 deagg_table_name=deagg_table_name,
		 delimiter=delimiter,
		 drop_existing=drop_existing)
