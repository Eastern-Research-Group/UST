from datetime import date
import ntpath
import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

from python.util import utils, config
from python.util.dataset import Dataset 
from python.util.logger_factory import logger


# THIS SCRIPT DEAGGREGATES SINGLE COLUMN LOOKUP VALUES (for example, SUBSTANCES)
# USE deagg_rows.py TO CREATE DEAGG TABLES AT THE FACILITY/TANK/COMPARTMENT LEVEL
# THAT USE THE TABLES THIS SCRIPT CREATES

ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = 0                  # Enter an integer that is the ust_dataset.control_id or release_dataset.control_id
table_name = '' 				# Enter a string containing organization table name
column_name = ''				# Enter a string containing organization column name
delimiter = ', ' 				# Defaults to ','; delimiter from the column beging deaggregated in the state table. Use \n for hard returns.
drop_existing = False 			# Boolean, defaults to False; if True will drop existing deagg table with the same name


def main(dataset, table_name, column_name, delimiter=',', drop_existing=False):
	if delimiter == None:
		delimiter = ','
		
	conn = utils.connect_db()
	cur = conn.cursor()

	control_table_name = dataset.ust_or_release.lower() + '_control'
	control_column_name = control_table_name + '_id'
	sql = f"""select organization_id from {control_table_name} 
			 where {control_column_name} = %s"""
	cur.execute(sql, (dataset.control_id,))
	deagg_table_name = utils.get_deagg_table_name(column_name)
	logger.info('Deagg table name = %s', deagg_table_name )

	sql = """select count(*) from information_schema.tables 
	         where table_schema = %s and table_name = %s"""
	cur.execute(sql, (dataset.schema, deagg_table_name))
	cnt =  cur.fetchone()[0]
	if cnt > 0 and drop_existing:
		sql = f"drop table {dataset.schema}.{deagg_table_name}"
		cur.execute(sql)
		logger.info('Dropped existing table %s', deagg_table_name)
	elif cnt > 0 and not drop_existing:
		logger.warning('Table %s.%s already exists. To drop and replace, pass drop_existing=True to this function. Exiting...', dataset.schema, deagg_table_name)
		cur.close()
		conn.close()
		exit()

	id_column_name = deagg_table_name + '_id'
	sql = f"""create table {dataset.schema}.{deagg_table_name}
		 ({id_column_name} int not null generated always as identity primary key,
		 "{column_name}" text,
		 constraint {deagg_table_name}_unique unique ("{column_name}"))"""
	cur.execute(sql)
	logger.info('Created table %s.%s with primary key %s', dataset.schema, deagg_table_name, id_column_name) 

	sql = f"""select distinct "{column_name}" from {dataset.schema}."{table_name}" 
	          where "{column_name}" is not null order by 1"""
	cur.execute(sql)
	rows = cur.fetchall()
	for row in rows:
		col_text = row[0]
		logger.info('Working on %s', col_text)
		col_text = col_text.strip()
		parts = col_text.split(delimiter)
		for part in parts:
			sql2 = f"""insert into {dataset.schema}.{deagg_table_name} ("{column_name}") 
			           values (%s) on conflict("{column_name}") do nothing"""
			cur.execute(sql2, (part,))

	sql = f"""update public.{dataset.ust_or_release}_element_mapping 
			  set deagg_table_name = %s, deagg_column_name = %s
	          where {dataset.ust_or_release}_control_id = %s 
	          and organization_table_name = %s and organization_column_name = %s"""
	cur.execute(sql, (deagg_table_name, column_name, dataset.control_id, table_name, column_name))

	conn.commit()
	cur.close()
	conn.close()

	logger.info('Finished deagging %s."%s"."%s" into %s', dataset.schema, table_name, column_name, deagg_table_name)



if __name__ == '__main__':   
	dataset = Dataset(ust_or_release=ust_or_release,
				 	  control_id=control_id,
					  requires_export=False)

	main(dataset=dataset, 
		 table_name=table_name, 
		 column_name=column_name,
		 delimiter=delimiter,
		 drop_existing=drop_existing)
