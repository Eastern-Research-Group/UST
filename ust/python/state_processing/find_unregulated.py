import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import psycopg2

from python.util import utils
from python.util.dataset import Dataset 
from python.util.logger_factory import logger

ust_or_release = '' 			# Valid values are 'ust' or 'release'
control_id = 0                  # Enter an integer that is the ust_control_id or release_control_id
organization_id = ''          # Optional; if control_id = 0 or None, will find the most recent control_id
drop_existing = True            # Boolean; defaults to True. If True, will drop existing erg_ unregulated table(s). 


class Unregulated:
	conn = None 
	cur = None 
	tables_exist = False

	def __init__(self, 
				 dataset,
				 drop_existing=True):
		self.dataset = dataset
		self.drop_existing = drop_existing
		if self.dataset.ust_or_release == 'release':
			self.unreg_parent_table = 'erg_unregulated_releases'
			self.parent_col = 'release_id'
			self.join_view = 'v_ust_release_substance'
		else:
			self.unreg_parent_table = 'erg_unregulated_facilities'
			self.parent_col = 'facility_id'
			self.join_view = 'v_ust_tank_substance'
		self.unreg_child_table = 'erg_unregulated_substances'


	def check_for_substances(self):
		self.connect_db()

		if self.dataset.ust_or_release == 'ust':
			view_name = 'v_ust_tank_substance'
		else:
			view_name = 'v_ust_release_substance'

		sql = """select count(*) from information_schema.tables 
		         where table_schema = %s and table_type = 'VIEW' and table_name = %s"""
		utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.schema, view_name))
		cnt = self.cur.fetchone()[0]

		self.disconnect_db()		

		if cnt > 0:
			return True 
		return False 


	def execute(self):
		if not self.check_for_substances():
			logger.info('No substance data for %s %s, no need to check for unregulated %s.', self.dataset.organization_id, utils.get_pretty_ust_or_release(self.dataset.ust_or_release), self.data_type)
			exit()

		self.connect_db()

		if self.drop_existing:
			self.drop_existing_tables()
		else:
			existing_tables = self.get_existing_tables()
			if existing_tables:
				logger.warning('The following tables already exist in schema %s: %s; set drop_existing to True to drop and replace them', self.dataset.schema, str(existing_tables))
				self.disconnect_db()
				exit()

		if not self.tables_exist:
			self.create_tables()
	
		self.insert_heating_oil()
		self.insert_small_tank()
		self.insert_parents()

		self.disconnect_db()		


	def drop_existing_tables(self):
		try:
			sql = f"drop table if exists {self.dataset.schema}.{self.unreg_child_table}"
			self.cur.execute(sql)
		except psycopg2.errors.DependentObjectsStillExist as e:
			logger.warning('Table %s.%s exists but the views that depend on it have already been written, so truncating it instead of creating it.', self.dataset.schema, self.unreg_child_table)
			sql = f"truncate table {self.dataset.schema}.{self.unreg_child_table}"
			utils.process_sql(self.conn, self.cur, sql)
			logger.info('Truncated table %s.%s', self.dataset.schema, self.unreg_child_table)
			self.tables_exist = True 

		try:
			sql = f"drop table if exists {self.dataset.schema}.{self.unreg_parent_table}"
			self.cur.execute(sql)
		except psycopg2.errors.DependentObjectsStillExist as e:
			logger.warning('Table %s.%s exists but the views that depend on it have already been written, so truncating it instead of creating it.', self.dataset.schema, self.unreg_parent_table)
			sql = f"truncate table {self.dataset.schema}.{self.unreg_parent_table}"
			utils.process_sql(self.conn, self.cur, sql)
			logger.info('Truncated table %s.%s', self.dataset.schema, self.unreg_parent_table)
			self.tables_exist = True 


	def get_existing_tables(self):
		sql = """select table_name from information_schema.tables
		         where table_schema = %s and table_name in (%s,%s) order by 1 """
		utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.schema, self.unreg_child_table, self.unreg_parent_table))
		rows = self.cur.fetchall()
		if rows:
			existing_tables = [r[0] for r in rows]
			return existing_cols
		else:
			return None 


	def create_tables(self):		
		sql = f"create table {self.dataset.schema}.{self.unreg_parent_table} ({self.parent_col} varchar(50) not null primary key, unregulated_reason varchar(1000))"
		utils.process_sql(self.conn, self.cur, sql)
		logger.info('Created table %s.%s', self.dataset.schema, self.unreg_parent_table)	

		sql = f"create table {self.dataset.schema}.{self.unreg_child_table} ({self.parent_col} varchar(50) not null, substance_id int not null, unregulated_reason varchar(1000))"
		utils.process_sql(self.conn, self.cur, sql)
		sql = f"alter table {self.dataset.schema}.{self.unreg_child_table} add constraint {self.unreg_child_table}_pk primary key ({self.parent_col}, substance_id);"		
		utils.process_sql(self.conn, self.cur, sql)
		logger.info('Created table %s.%s', self.dataset.schema, self.unreg_child_table)
		
		self.conn.commit()


	def build_ust_facility_type_sql(self, fac_type):
		if self.dataset.ust_or_release == 'ust':
			view_name =  'v_ust_facility'
		else:
			view_name = 'v_ust_release'
		sql = """select column_name from information_schema.columns 
				where table_schema = %s and table_name = %s
				and column_name like 'facility_type%%'
				order by column_name"""
		utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.schema, view_name))
		rows = self.cur.fetchall()
		if not rows:
			return None  
		column_name = rows[0][0]
		try:
			column_name2 = rows[1][0]
		except:
			column_name2 = None 
		if fac_type == 'heating':
			wheresql = f"where {column_name} <> 4 "
		else:
			wheresql = f"where {column_name} in (1,12) "

		fsql = f"\nand {self.parent_col} in (select {self.parent_col} from {self.dataset.schema}.{view_name} {wheresql}"
		if len(rows) > 1:
			fsql += f"""\nunion all\n\tselect {self.parent_col} from {self.dataset.schema}.{view_name} {wheresql.replace(column_name, column_name2)}"""
		fsql += ") " 
		return fsql 


	def insert_heating_oil(self):
		fac_sql = self.build_ust_facility_type_sql('heating')
		if not fac_sql:
			logger.info('No facility type data so not inserting unregulated heating oil rows.')
			return

		if self.dataset.ust_or_release == 'ust':
			substance_table = 'v_ust_tank_substance'
		else:
			substance_table = 'v_ust_release_substance'

		sql = f"""insert into {self.dataset.schema}.{self.unreg_child_table}
			      select distinct {self.parent_col}, ts.substance_id, 'Heating oil' 
			      from {self.dataset.schema}.{substance_table} ts 
			      	join public.substances s on ts.substance_id = s.substance_id 
			      where s.substance_group = 'Heating' {fac_sql}
			      on conflict do nothing"""
		utils.process_sql(self.conn, self.cur, sql)
		logger.info('Inserted %s rows into %s.%s due presence of heating oil in a non-bulk distributor facility', self.cur.rowcount, self.dataset.schema, self.unreg_child_table)
		self.conn.commit()


	def insert_small_tank(self):
		if self.dataset.ust_or_release == 'release':
			return 

		fac_sql = self.build_facility_type_sql('farm/residence')
		sql = f"""insert into {self.dataset.schema}.{self.unreg_child_table}
				select x.facility_id, ts.substance_id, 'Small tank at farm/residence'
				from (select facility_id, tank_id, sum(compartment_capacity_gallons) as tank_capacity_gallons 
					from {self.dataset.schema}.v_ust_compartment group by facility_id, tank_id) x join 
					{self.dataset.schema}.v_ust_tank_substance ts on x.facility_id = ts.facility_id and x.tank_id = ts.tank_id  
					join public.substances s on ts.substance_id = s.substance_id
				where tank_capacity_gallons < 1100 and substance_group in ('Diesel','Gasoline')
				{fac_sql}"""
		# sql = f"""insert into {self.dataset.schema}.{self.unreg_child_table}
		# 		select x.facility_id, x.tank_id 
		# 		from (select facility_id, tank_id, sum(compartment_capacity_gallons) as tank_capacity_gallons 
		# 			  from {self.dataset.schema}.v_ust_compartment group by facility_id, tank_id) x 
		# 			join {fac_sql} on x.facility_id = f.facility_id	  
		# 			join {self.dataset.schema}.v_ust_tank_substance s on x.facility_id = s.facility_id and x.tank_id = s.tank_id 
		# 			join public.substances sub on s.substance_id = sub.substance_id
		# 		where tank_capacity_gallons < 1100 and substance_group in ('Diesel','Gasoline')
		# 		on conflict do nothing"""
		utils.process_sql(self.conn, self.cur, sql)
		logger.info('Inserted %s rows into %s.%s due to tank capacity <1100 gallons in a farm or residence facility', self.cur.rowcount, self.dataset.schema, self.unreg_child_table)
		self.conn.commit()


	def insert_parents(self):

		sql = f"""insert into {self.dataset.schema}.{self.unreg_parent_table}
					select v.{self.parent_col}, string_agg(distinct eus.unregulated_reason, '; ' order by eus.unregulated_reason) as unregulated_reason
					from {self.dataset.schema}.{self.join_view} v
						join  {self.dataset.schema}.{self.unreg_child_table} eus 
							on v.{self.parent_col} = eus.{self.parent_col} and v.substance_id = eus.substance_id
					where not exists (
					    select 1
					    from  {self.dataset.schema}.{self.join_view} v2
					    where v2.{self.parent_col} = v.{self.parent_col}
					      and not exists (
					          select 1
					          from  {self.dataset.schema}.{self.unreg_child_table} eus
					          where eus.{self.parent_col} = v2.{self.parent_col}
					            and eus.substance_id = v2.substance_id))
					group by v.{self.parent_col}
					on conflict do nothing"""
		utils.process_sql(self.conn, self.cur, sql)
		logger.info('Inserted %s rows into %s.%s', self.cur.rowcount, self.dataset.schema, self.unreg_parent_table)
		self.conn.commit()


	def connect_db(self):
		if not self.conn:
			self.conn = utils.connect_db()
			self.cur = self.conn.cursor()
			logger.info('Connected to database')
		

	def disconnect_db(self):
		if self.conn:
			self.cur.close()
			self.conn.close()
			self.conn = None 
			logger.info('Disconnected from database')



def main(ust_or_release, control_id=0, organization_id=None, drop_existing=True):
	if not control_id or control_id == 0:
		control_id = utils.get_control_id(ust_or_release, organization_id)

	dataset = Dataset(ust_or_release=ust_or_release,
				 	  control_id=control_id,
				 	  requires_export=False)

	Unregulated(dataset, drop_existing).execute()



if __name__ == '__main__':   
	main(ust_or_release=ust_or_release,
		 control_id=control_id,
		 organization_id=organization_id,
		 drop_existing=drop_existing)

