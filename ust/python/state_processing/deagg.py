import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))
from datetime import date
import ntpath

from python.util.logger_factory import logger
from python.util import utils, config


# THIS SCRIPT DEAGGREGATES SINGLE COLUMN LOOKUP VALUES (for example, SUBSTANCES)
# USE deagg_rows.py TO CREATE DEAGG TABLES AT THE FACILITY/TANK/COMPARTMENT LEVEL
# THAT USE THE TABLES THIS SCRIPT CREATES

ust_or_release = 'release' # valid values are 'ust' or 'release'
control_id = 5
table_name = 'ust_all-tn-environmental-sites'
column_name = 'Productreleased'
delimiter = ', ' # defaults to ','; delimiter from the column beging deaggregated in the state table. Use \n for hard returns.
drop_existing = True # defaults to False; if True will drop existing deagg table with the same name


def main(control_id, ust_or_release, table_name, column_name, delimiter=',', drop_existing=False):
	ust_or_release = utils.verify_ust_or_release(ust_or_release)

	if delimiter == None:
		delimiter = ','
		
	conn = utils.connect_db()
	cur = conn.cursor()

	control_table_name = ust_or_release.lower() + '_control'
	control_column_name = control_table_name + '_id'
	sql = f"""select organization_id from {control_table_name} 
			 where {control_column_name} = %s"""
	cur.execute(sql, (control_id,))
	schema = utils.get_schema_from_control_id(control_id, ust_or_release)
	deagg_table_name = 'erg_' + column_name.lower().replace(' ','_') + '_deagg'

	logger.info('Schema = %s', schema )
	logger.info('Deagg table name = %s', deagg_table_name )

	sql = """select count(*) from information_schema.tables 
	         where table_schema = %s and table_name = %s"""
	cur.execute(sql, (schema, deagg_table_name))
	cnt =  cur.fetchone()[0]
	if cnt > 0 and drop_existing:
		sql = f"drop table {schema}.{deagg_table_name}"
		cur.execute(sql)
		logger.info('Dropped existing table %s', deagg_table_name)
	elif cnt > 0 and not drop_existing:
		logger.warning('Table %s.%s already exists. To drop and replace, pass drop_existing=True to this function. Exiting...', schema, deagg_table_name)
		cur.close()
		conn.close()
		exit()

	id_column_name = deagg_table_name + '_id'
	sql = f"""create table {schema}.{deagg_table_name}
		 ({id_column_name} int not null generated always as identity primary key,
		 "{column_name}" text,
		 constraint {deagg_table_name}_unique unique ("{column_name}"))"""
	cur.execute(sql)
	logger.info('Created table %s.%s with primary key %s', schema, deagg_table_name, id_column_name) 

	sql = f"""select distinct "{column_name}" from {schema}."{table_name}" 
	          where "{column_name}" is not null order by 1"""
	cur.execute(sql)
	rows = cur.fetchall()
	for row in rows:
		col_text = row[0]
		logger.info('Working on %s', col_text)
		col_text = col_text.strip()
		parts = col_text.split(delimiter)
		for part in parts:
			sql2 = f"""insert into {schema}.{deagg_table_name} ("{column_name}") 
			           values (%s) on conflict("{column_name}") do nothing"""
			cur.execute(sql2, (part,))
	conn.commit()
	cur.close()
	conn.close()

	logger.info('Finished deagging %s."%s"."%s" into %s', schema, table_name, column_name, deagg_table_name)



if __name__ == '__main__':   
	main(control_id=control_id, 
		 ust_or_release=ust_or_release, 
		 table_name=table_name, 
		 column_name=column_name,
		 delimiter=delimiter,
		 drop_existing=drop_existing)
