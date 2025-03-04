import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

from python.util import utils
from python.util.dataset import Dataset 
from python.util.logger_factory import logger

ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = 8                  # Enter an integer that is the ust_control_id or release_control_id
drop_existing = True            # Boolean; defaults to True. If True, will drop existing erg_ unregulated table(s). 


class Unregulated:
	conn = None 
	cur = None 

	def __init__(self, 
				 dataset,
				 drop_existing=True):
		self.dataset = dataset
		self.drop_existing = drop_existing
		self.unreg_tank_table = 'erg_unregulated_tanks'
		self.unreg_fac_table = 'erg_unregulated_facilities'


	def execute(self):
		self.connect_db()

		if self.drop_existing:
			self.drop_existing_tables()
		else:
			existing_tables = self.get_existing_tables()
			if existing_tables:
				logger.warning('The following tables already exist in schema %s: %s; set drop_existing to True to drop and replace them', self.dataset.schema, str(existing_tables))
				self.disconnect_db()
				exit()

		self.create_tables()
		self.insert_heating_oil()
		if self.dataset.ust_or_release == 'ust':
			self.insert_small_tank()
		self.insert_facilities()

		self.disconnect_db()		


	def drop_existing_tables(self):
		sql = f"drop table if exists {self.dataset.schema}.{self.unreg_tank_table}"
		utils.process_sql(self.conn, self.cur, sql)
		sql = f"drop table if exists {self.dataset.schema}.{self.unreg_fac_table}"
		utils.process_sql(self.conn, self.cur, sql)


	def get_existing_tables(self):
		sql = """select table_name from information_schema.tables
		         where table_schema = %s and table_name in (%s,%s) order by 1 """
		utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.schema, self.unreg_tank_table, self.unreg_fac_table))
		rows = self.cur.fetchall()
		if rows:
			existing_tables = [r[0] for r in rows]
			return existing_cols
		else:
			return None 


	def create_tables(self):
		sql = f"create table {self.dataset.schema}.{self.unreg_tank_table} (facility_id varchar(50) not null, tank_id int not null)"
		utils.process_sql(self.conn, self.cur, sql)
		sql = f"alter table {self.dataset.schema}.{self.unreg_tank_table} add constraint {self.unreg_tank_table}_pk primary key (facility_id, tank_id);"
		utils.process_sql(self.conn, self.cur, sql)
		logger.info('Create table %s.%s', self.dataset.schema, self.unreg_tank_table)	

		sql = f"create table {self.dataset.schema}.{self.unreg_fac_table} (facility_id varchar(50) not null primary key)"
		utils.process_sql(self.conn, self.cur, sql)
		logger.info('Create table %s.%s', self.dataset.schema, self.unreg_fac_table)	
		
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
			if self.dataset.ust_or_release:
				fsql = f"""\n\t(select distinct facility_id from 
				(select facility_id, facility_type1 as facility_type_id from {self.dataset.schema}.{view_name} """
				if cnt > 1:
					fsql = fsql + f'union all\n\tselect facility_id, facility_type2 as facility_type_id from {self.dataset.schema}.{view_name} '
				fsql = fsql + """) x """
			else:
				fsql = f'\n\t(select distinct facility_id from {self.dataset.schema}.{view_name} '
		if fac_type == 'heating oil':
			fsql = fsql + "where facility_type_id <> 2) f\n"
		else:
			fsql = fsql + "where facility_type_id in (1,12)) f\n"
		return fsql 


	def insert_heating_oil(self):
		facility_type_sql = self.build_facility_type_sql('heating oil')
		if not facility_type_sql:
			logger.info('No facility types so not inserting heating oil tanks')
			return None 

		if self.dataset.ust_or_release == 'ust':
			view_name = 'v_ust_tank_substance'
		else:
			view_name = 'v_ust_release_substance'

		sql = f"""insert into {self.dataset.schema}.{self.unreg_tank_table}
		          select distinct ts.facility_id, tank_id 
		          from {self.dataset.schema}.{view_name} ts join public.substances s on ts.substance_id = s.substance_id 
					join {facility_type_sql} on ts.facility_id = f.facility_id
				  where s.substance like 'Heating%' 
				  on conflict do nothing"""
		utils.process_sql(self.conn, self.cur, sql)
		logger.info('Inserted %s rows into %s.%s due presence of heating oil in a non-bulk distributor facility', self.cur.rowcount, self.dataset.schema, self.unreg_tank_table)
		self.conn.commit()


	def insert_small_tank(self):
		facility_type_sql = self.build_facility_type_sql('farm/residence')

		sql = f"""insert into {self.dataset.schema}.{self.unreg_tank_table}
				select x.facility_id, tank_id 
				from (select facility_id, tank_id, sum(compartment_capacity_gallons) as tank_capacity_gallons 
					  from va_ust.v_ust_compartment group by facility_id, tank_id) x 
					join {facility_type_sql} on x.facility_id = f.facility_id	  
				where tank_capacity_gallons <1100
				on conflict do nothing"""
		utils.process_sql(self.conn, self.cur, sql)
		logger.info('Inserted %s rows into %s.%s due to tank capacity <1100 gallones in a farm or residence facility', self.cur.rowcount, self.dataset.schema, self.unreg_tank_table)
		self.conn.commit()


	def insert_facilities(self):
		sql = f"""insert into {self.dataset.schema}.{self.unreg_fac_table} 
				select distinct facility_id
				from {self.dataset.schema}.{self.unreg_tank_table} a 
				where not exists 
					(select 1 from {self.dataset.schema}.v_ust_tank b
					where a.facility_id = b.facility_id
					and a.tank_id <> b.tank_id)"""
		utils.process_sql(self.conn, self.cur, sql)
		logger.info('Inserted %s rows into %s.%s because the facility has no regulated tanks', self.cur.rowcount, self.dataset.schema, self.unreg_fac_table)
		self.conn.commit()


	def connect_db(self):
		self.conn = utils.connect_db()
		self.cur = self.conn.cursor()
		logger.info('Connected to database')
		

	def disconnect_db(self):
		self.cur.close()
		self.conn.close()
		logger.info('Disconnected from database')



def main(ust_or_release, control_id, drop_existing=True):
	dataset = Dataset(ust_or_release=ust_or_release,
				 	  control_id=control_id,
				 	  requires_export=False)

	Unregulated(dataset, drop_existing).execute()



if __name__ == '__main__':   
	main(ust_or_release=ust_or_release,
		 control_id=control_id,
		 drop_existing=drop_existing)

