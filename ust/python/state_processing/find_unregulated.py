import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import psycopg2

from python.util import utils
from python.util.dataset import Dataset 
from python.util.logger_factory import logger

ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = 0                  # Enter an integer that is the ust_control_id or release_control_id
organization_id = None          # Optional; if control_id = 0 or None, will find the most recent control_id
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
		self.unreg_fac_table = 'erg_unregulated_facilities'
		self.unreg_table = 'erg_unregulated_tanks'
		self.data_type = 'tanks'
		if self.dataset.ust_or_release == 'release':
			self.data_type = 'releases'
			self.unreg_table = 'erg_unregulated_releases'


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
		self.insert_facilities()

		self.disconnect_db()		


	def drop_existing_tables(self):
		try:
			sql = f"drop table if exists {self.dataset.schema}.{self.unreg_table}"
			self.cur.execute(sql)
		except psycopg2.errors.DependentObjectsStillExist as e:
			logger.warning('Table %s.%s exists but the views that depend on it have already been written, so truncating it instead of creating it.', self.dataset.schema, self.unreg_table)
			sql = f"truncate table {self.dataset.schema}.{self.unreg_table}"
			utils.process_sql(self.conn, self.cur, sql)
			logger.info('Truncated table %s.%s', self.dataset.schema, self.unreg_table)
			self.tables_exist = True 

		try:
			sql = f"drop table if exists {self.dataset.schema}.{self.unreg_fac_table}"
			self.cur.execute(sql)
		except psycopg2.errors.DependentObjectsStillExist as e:
			logger.warning('Table %s.%s exists but the views that depend on it have already been written, so truncating it instead of creating it.', self.dataset.schema, self.unreg_fac_table)
			sql = f"truncate table {self.dataset.schema}.{self.unreg_fac_table}"
			utils.process_sql(self.conn, self.cur, sql)
			logger.info('Truncated table %s.%s', self.dataset.schema, self.unreg_fac_table)
			self.tables_exist = True 


	def get_existing_tables(self):
		sql = """select table_name from information_schema.tables
		         where table_schema = %s and table_name in (%s,%s) order by 1 """
		utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.schema, self.unreg_table, self.unreg_fac_table))
		rows = self.cur.fetchall()
		if rows:
			existing_tables = [r[0] for r in rows]
			return existing_cols
		else:
			return None 


	def create_tables(self):
		if self.dataset.ust_or_release == 'ust':
			column2 = 'tank_id'
			datatype = 'int'
		else:
			column2 = 'release_id'
			datatype = 'varchar(50)'

		sql = f"create table {self.dataset.schema}.{self.unreg_table} (facility_id varchar(50) not null, {column2} {datatype} not null)"
		utils.process_sql(self.conn, self.cur, sql)
		sql = f"alter table {self.dataset.schema}.{self.unreg_table} add constraint {self.unreg_table}_pk primary key (facility_id, {column2});"
		utils.process_sql(self.conn, self.cur, sql)
		logger.info('Created table %s.%s', self.dataset.schema, self.unreg_table)	

		sql = f"create table {self.dataset.schema}.{self.unreg_fac_table} (facility_id varchar(50) not null primary key)"
		utils.process_sql(self.conn, self.cur, sql)
		logger.info('Created table %s.%s', self.dataset.schema, self.unreg_fac_table)	
		
		self.conn.commit()


	def build_facility_type_sql(self, fac_type):
		if self.dataset.ust_or_release == 'ust':
			view_name = 'v_ust_facility'
		else:
			view_name = 'v_ust_release'

		sql = """select count(*) from information_schema.columns 
				where table_schema = %s and table_name = %s
				and column_name like 'facility_type%%'
				order by 1 """
		utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.schema, view_name))
		cnt = self.cur.fetchone()[0]
		if cnt == 0:
			logger.info('No facility type data mapped in %s', self.dataset.schema)
			return None
		else: 
			if self.dataset.ust_or_release == 'ust':
				fsql = f"""\n\t(select distinct facility_id from 
				(select facility_id, facility_type1 as facility_type_id from {self.dataset.schema}.{view_name} """
				if cnt > 1:
					fsql = fsql + f'union all\n\tselect facility_id, facility_type2 as facility_type_id from {self.dataset.schema}.{view_name} '
				fsql = fsql + """) x """
			else:
				fsql = f'\n\t(select distinct facility_id, release_id, facility_type_id from {self.dataset.schema}.{view_name} '
		if fac_type == 'heating oil':
			fsql = fsql + "where facility_id is not null and facility_type_id <> 4) f\n"
		else:
			fsql = fsql + "where facility_id is not null and facility_type_id in (1,12)) f\n"
		return fsql 


	def insert_heating_oil(self):
		facility_type_sql = self.build_facility_type_sql('heating oil')
		if not facility_type_sql:
			logger.info('No facility types so not inserting heating oil %s', self.data_type)
			return None 

		if self.dataset.ust_or_release == 'ust':
			sql = f"""insert into {self.dataset.schema}.{self.unreg_table}
			          select distinct ts.facility_id, tank_id 
			          from {self.dataset.schema}.v_ust_tank_substance ts join public.substances s on ts.substance_id = s.substance_id 
						join {facility_type_sql} on ts.facility_id = f.facility_id
					  where s.substance like 'Heating%' 
					  on conflict do nothing"""
		else:
			sql = f"""insert into {self.dataset.schema}.{self.unreg_table}
			          select distinct facility_id, release_id
					  from 
						 (select ts.release_id, f.facility_id 
						 from {self.dataset.schema}.v_ust_release_substance ts join public.substances s on ts.substance_id = s.substance_id 
						 	join {facility_type_sql} on ts.release_id = f.release_id
					  where s.substance like 'Heating%') a 
					  on conflict do nothing"""
		utils.process_sql(self.conn, self.cur, sql)
		logger.info('Inserted %s rows into %s.%s due presence of heating oil in a non-bulk distributor facility', self.cur.rowcount, self.dataset.schema, self.unreg_table)
		self.conn.commit()


	def insert_small_tank(self):
		if self.dataset.ust_or_release == 'ust':
			facility_type_sql = self.build_facility_type_sql('farm/residence')

			sql = f"""insert into {self.dataset.schema}.{self.unreg_table}
					select x.facility_id, x.tank_id 
					from (select facility_id, tank_id, sum(compartment_capacity_gallons) as tank_capacity_gallons 
						  from {self.dataset.schema}.v_ust_compartment group by facility_id, tank_id) x 
						join {facility_type_sql} on x.facility_id = f.facility_id	  
						join {self.dataset.schema}.v_ust_tank_substance s on x.facility_id = s.facility_id and x.tank_id = s.tank_id 
						join public.substances sub on s.substance_id = sub.substance_id
					where tank_capacity_gallons < 1100 and substance_group in ('Diesel','Gasoline')
					on conflict do nothing"""
			utils.process_sql(self.conn, self.cur, sql)
			logger.info('Inserted %s rows into %s.%s due to tank capacity <1100 gallones in a farm or residence facility', self.cur.rowcount, self.dataset.schema, self.unreg_table)
			self.conn.commit()


	def insert_facilities(self):
		if self.dataset.ust_or_release == 'ust':
			sql = f"""insert into {self.dataset.schema}.{self.unreg_fac_table} 
					select distinct facility_id
					from {self.dataset.schema}.{self.unreg_table} a 
					where not exists 
						(select 1 from {self.dataset.schema}.v_ust_tank b
						where a.facility_id = b.facility_id
						and a.tank_id <> b.tank_id)"""
		else:
			sql = f"""insert into {self.dataset.schema}.{self.unreg_fac_table} 
			        select distinct facility_id
			        from {self.dataset.schema}.{self.unreg_table} a 
					where not exists 
						(select 1 from {self.dataset.schema}.v_ust_release b
						where b.facility_id is not null 
						and a.facility_id = b.facility_id and a.release_id <> b.release_id)"""
		utils.process_sql(self.conn, self.cur, sql)
		logger.info('Inserted %s rows into %s.%s because the facility has no regulated %s', self.cur.rowcount, self.dataset.schema, self.unreg_fac_table, self.data_type)
		self.conn.commit()


	def connect_db(self):
		self.conn = utils.connect_db()
		self.cur = self.conn.cursor()
		logger.info('Connected to database')
		

	def disconnect_db(self):
		self.cur.close()
		self.conn.close()
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

