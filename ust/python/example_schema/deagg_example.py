from datetime import date
import ntpath
import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

from python.example_schema.dataset_example import Dataset 
from python.example_schema.deagg_rows_example import deaggRows
from python.util import utils, config
from python.util.logger_factory import logger


# THIS SCRIPT DEAGGREGATES SINGLE COLUMN LOOKUP VALUES (for example, SUBSTANCES)
# USE deagg_rows_example.py TO CREATE DEAGG TABLES AT THE FACILITY/TANK/COMPARTMENT LEVEL
# THAT USE THE TABLES THIS SCRIPT CREATES

ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = 1                  # Enter an integer that is the ust_control_id or release_control_id
data_table_name = 'Tanks' 				# Enter a string containing organization table name
column_name = 'Tank Substance'				# Enter a string containing organization column name
delimiter = ', ' 				# Defaults to ','; delimiter from the column beging deaggregated in the state table. Use '\n' for hard returns.
drop_existing = True 			# Boolean, defaults to False; if True will drop existing deagg table with the same name
deagg_rows = True				# Boolean, defaults to True. If True will automatically execute the deagg_rows_example.py scripts after executing this script.


class deagg:
	conn = None  
	cur = None  

	def __init__(self, 
				 dataset,
				 data_table_name,
				 column_name,
				 delimiter,
				 drop_existing=False,
				 deagg_rows=True):
		self.dataset = dataset
		self.data_table_name = data_table_name 
		self.column_name = column_name 
		self.delimiter = delimiter 
		self.drop_existing = drop_existing 
		self.deagg_rows = deagg_rows
		self.deagg_table_name = utils.get_deagg_table_name(column_name)
		self.id_column_name = self.deagg_table_name + '_id'
		self.connect_db()
		self.create_deagg_table()
		self.update_element_mapping()
		self.run_deagg_rows()
		self.disconnect_db()


	def connect_db(self):
		self.conn = utils.connect_db()
		self.cur = self.conn.cursor()
		logger.info('Connected to database')


	def disconnect_db(self):
		self.conn.commit()
		self.cur.close()
		self.conn.close()
		logger.info('Diconnected from database')


	def create_deagg_table(self):
		if self.delimiter == None:
			self.delimiter = ','
			
		control_table_name = self.dataset.ust_or_release.lower() + '_control'
		control_column_name = control_table_name + '_id'
		sql = f"""select organization_id from example.{control_table_name} 
				 where {control_column_name} = %s"""
		self.cur.execute(sql, (self.dataset.control_id,))
		logger.info('Deagg table name = %s', self.deagg_table_name)

		sql = """select count(*) from information_schema.tables 
		         where table_schema = %s and table_name = %s"""
		self.cur.execute(sql, (self.dataset.schema, self.deagg_table_name))
		cnt =  self.cur.fetchone()[0]
		if cnt > 0 and self.drop_existing:
			sql = f"drop table {self.dataset.schema}.{self.deagg_table_name}"
			self.cur.execute(sql)
			logger.info('Dropped existing table %s', self.deagg_table_name)
		elif cnt > 0 and not self.drop_existing:
			logger.warning('Table %s.%s already exists. To drop and replace, pass drop_existing=True to this function. Exiting...', self.dataset.schema, self.deagg_table_name)
			self.disconnect_db()
			exit()

		sql = f"""create table {self.dataset.schema}.{self.deagg_table_name}
			 ({self.id_column_name} int not null generated always as identity primary key,
			 "{self.column_name}" text,
			 constraint {self.deagg_table_name}_unique unique ("{self.column_name}"))"""
		self.cur.execute(sql)
		logger.info('Created table %s.%s with primary key %s', self.dataset.schema, self.deagg_table_name, self.id_column_name) 

		sql = f"""select distinct "{self.column_name}" from {self.dataset.schema}."{self.data_table_name}" 
		          where "{self.column_name}" is not null order by 1"""
		self.cur.execute(sql)
		rows = self.cur.fetchall()
		for row in rows:
			col_text = row[0]
			logger.info('Working on %s', col_text)
			col_text = col_text.strip()
			parts = col_text.split(self.delimiter)
			for part in parts:
				sql2 = f"""insert into {self.dataset.schema}.{self.deagg_table_name} ("{self.column_name}") 
				           values (%s) on conflict("{self.column_name}") do nothing"""
				self.cur.execute(sql2, (part,))

		logger.info('Finished deagging %s."%s"."%s" into %s', self.dataset.schema, self.data_table_name, self.column_name, self.deagg_table_name)
		

	def update_element_mapping(self):
		sql = f"""update example.{self.dataset.ust_or_release}_element_mapping 
				  set deagg_table_name = %s, deagg_column_name = %s
		          where {self.dataset.ust_or_release}_control_id = %s 
		          and organization_table_name = %s and organization_column_name = %s"""
		self.cur.execute(sql, (self.deagg_table_name, self.column_name, self.dataset.control_id, self.data_table_name, self.column_name))
		self.conn.commit()
		logger.info('Updated %s_element_mapping; set deagg_table_name to %s, deagg_column_name to %s for %s.%s', self.dataset.ust_or_release, self.deagg_table_name, self.column_name, self.data_table_name, self.column_name)


	def run_deagg_rows(self):
		if not self.deagg_rows:
			return

		sql = f"""select distinct epa_table_name
				from {self.dataset.schema}.{self.dataset.ust_or_release}_element_mapping 
				where {self.dataset.ust_or_release}_control_id = %s
				and organization_table_name = %s and organization_column_name = %s"""
		self.cur.execute(sql, (self.dataset.control_id, self.data_table_name, self.column_name))
		epa_table_name = self.cur.fetchone()[0]

		sql = f"""select organization_column_name
				from {self.dataset.schema}.{self.dataset.ust_or_release}_element_mapping  
				where epa_table_name = %s
				and organization_column_name <> %s and organization_table_name = %s"""
		self.cur.execute(sql, (epa_table_name, self.column_name, self.data_table_name))
		rows = self.cur.fetchall()
		data_table_pk_cols = [r[0] for r in rows]
		
		drows = deaggRows(dataset=self.dataset, 
				 data_table_name=self.data_table_name, 
				 data_table_pk_cols=data_table_pk_cols,
				 data_deagg_column_name=self.column_name,
				 deagg_table_name=self.deagg_table_name,
				 delimiter=self.delimiter,
				 drop_existing=self.drop_existing)


def main(ust_or_release, control_id, data_table_name, column_name, delimiter=',', drop_existing=False, deagg_rows=True):
	dataset = Dataset(ust_or_release=ust_or_release,
				 	  control_id=control_id,
					  requires_export=False)

	deagged = deagg(dataset=dataset, 
  				    data_table_name=data_table_name, 
				    column_name=column_name,
				    delimiter=delimiter,
				    drop_existing=drop_existing,
		 			deagg_rows=deagg_rows)


if __name__ == '__main__':   
	main(ust_or_release=ust_or_release, 
		 control_id=control_id,
		 data_table_name=data_table_name, 
		 column_name=column_name,
		 delimiter=delimiter,
		 drop_existing=drop_existing,
		 deagg_rows=deagg_rows)
