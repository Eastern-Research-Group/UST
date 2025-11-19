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


ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = 0                  # Enter an integer that is the ust_control_id or release_control_id


class OustValueMapping:
	conn = None  
	cur = None  

	def __init__(self, 
				 ust_or_release,
				 control_id):
		self.dataset = Dataset(ust_or_release=ust_or_release,
						 	  control_id=control_id,
							  requires_export=False)


	def connect_db(self):
		if not self.conn:
			self.conn = utils.connect_db()
			self.cur = self.conn.cursor()
			logger.info('Connected to database')



	def disconnect_db(self):
		if self.conn:
			self.conn.commit()
			self.cur.close()
			self.conn.close()
			self.conn = None 
			logger.info('Disconnected from database')		


	def validate_oust_table(self):
		self.connect_db()

		# Check that all organization table names are populated
		sql = f"""select distinct excel_tab_name from public.oust_{self.dataset.ust_or_release}_value_mapping
				  where {self.dataset.ust_or_release}_control_id = %s and (organization_table_name is null or length(organization_table_name) = 0)
				  order by 1"""
		utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id,))
		rows = self.cur.fetchall()
		if rows:
			logger.warning('Please update the organization_table_name and organization_column_name in table public.oust_%s_value_mapping for the following tab names where %s_control_id = %s:', self.dataset.ust_or_release, self.dataset.ust_or_release, self.dataset.control_id)
			logger.warning('')
			for row in rows:
				logger.warning(row[0])
			print('\n\nHere is the SQL you can use:\n')
			for row in rows:
				print(f"\nupdate public.oust_{self.dataset.ust_or_release}_value_mapping\nset organization_table_name = '', organization_column_name = ''\nwhere {self.dataset.ust_or_release}_control_id = {self.dataset.control_id} and excel_tab_name = '{row[0]}';")
			print('\n\n')
			self.disconnect_db()
			exit()

		# Check that all organization column names are populated
		sql = f"""select distinct excel_tab_name, organization_table_name, organization_value
		 		  from public.oust_{self.dataset.ust_or_release}_value_mapping
				  where {self.dataset.ust_or_release}_control_id = %s and (organization_column_name is null or length(organization_table_name) = 0)
				  order by 2, 3"""
		utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id,))
		rows = self.cur.fetchall()
		if rows:
			logger.warning('Please update the organization_column_name in table public.oust_%s_value_mapping for the following rwos where %s_control_id = %s:', self.dataset.ust_or_release, self.dataset.ust_or_release, self.dataset.control_id)
			logger.warning('')
			for row in rows:
				tab_name = row[0]
				table_name = row[1]
				org_value = row[2]
				logger.warning('Excel Tab Name: %s; Organization Table Name: %s, Organization Value: %s', tab_name, table_name, org_value)
			print('\n\nHere is the SQL you can use:\n')
			for row in rows:
				tab_name = row[0]
				table_name = row[1]
				org_value = row[2]
				print(f"\nupdate public.oust_{self.dataset.ust_or_release}_value_mapping\nset organization_column_name = ''\nwhere {self.dataset.ust_or_release}_control_id = {self.dataset.control_id} and excel_tab_name = '{tab_name}' and organization_table_name = '{table_name}' and organization_value = '{org_value}';")
			print('\n\n')
			self.disconnect_db()
			exit()

		# Check that all organization table names are valid
		sql = f"""select distinct organization_table_name 
				from public.oust_{self.dataset.ust_or_release}_value_mapping
				where {self.dataset.ust_or_release}_control_id = %s and organization_table_name not in
					(select distinct organization_table_name from public.{self.dataset.ust_or_release}_element_mapping
					 where {self.dataset.ust_or_release}_control_id = %s)
				order by 1"""
		utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id, self.dataset.control_id))
		rows = self.cur.fetchall()
		if rows:
			logger.warning('The following organization_table_name values in public.oust_%s_value_mapping do not exist in public.%s_element_mapping for %s_control_id %s', self.dataset.ust_or_release, self.dataset.ust_or_release, self.dataset.ust_or_release, self.dataset.control_id)
			logger.warning('')
			for row in rows:
				logger.warning(row[0])
			print('\n\nHere is the SQL you can use:\n')
			for row in rows:
				print(f"\nupdate public.oust_{self.dataset.ust_or_release}_value_mapping\nset organization_table_name = ''\nwhere {self.dataset.ust_or_release}_control_id = {self.dataset.control_id} and organization_table_name = '{row[0]}';")
			print('\n\n')
			self.disconnect_db()
			exit()

		# Check that all organization column names are valid
		sql = f"""select a.excel_tab_name, a.organization_table_name, a.organization_column_name
				from public.oust_{self.dataset.ust_or_release}_value_mapping a join 
					(select distinct {self.dataset.ust_or_release}_control_id, organization_table_name from public.{self.dataset.ust_or_release}_element_mapping) b 
					on a.{self.dataset.ust_or_release}_control_id = b.{self.dataset.ust_or_release}_control_id and a.organization_table_name = b.organization_table_name 
				where a.{self.dataset.ust_or_release}_control_id = %s and not exists 
					(select 1 from public.{self.dataset.ust_or_release}_element_mapping b 
					where a.{self.dataset.ust_or_release}_control_id = b.{self.dataset.ust_or_release}_control_id 
					and a.organization_table_name = b.organization_table_name and a.organization_column_name = b.organization_column_name)
					order by 2, 3"""
		utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id,))
		rows = self.cur.fetchall()
		if rows:
			logger.warning('The following organization_table_name values in public.oust_%s_value_mapping do not exist in public.%s_element_mapping for %s_control_id %s', self.dataset.ust_or_release, self.dataset.ust_or_release, self.dataset.ust_or_release, self.dataset.control_id)
			logger.warning('')
			for row in rows:
				tab_name = row[0]
				org_table = row[1]
				org_col = row[2]
				logger.warning('Excel Tab Name: %s; Organization Table Name: %s, Organization Column Name: %s', tab_name, org_table, org_col)
			print('\n\nHere is the SQL you can use:\n')
			for row in rows:
				tab_name = row[0]
				org_table = row[1]
				org_col = row[2]				
				print(f"\nupdate public.oust_{self.dataset.ust_or_release}_value_mapping\nset organization_column_name = ''\nwhere {self.dataset.ust_or_release}_control_id = {self.dataset.control_id} and organization_table_name = '{org_table}' and organization_column_name = '{org_col}';")
			print('\n\n')
			self.disconnect_db()
			exit()

		# Check that all organization values exist in state data
		sql = f"""select distinct a.organization_table_name, a.organization_column_name, epa_table_name, epa_column_name, 
					database_lookup_table, c.database_lookup_column, case when d.column_name is not null then 'Y' else 'N' end as allowed_values,
					table_sort_order, column_sort_order
				from public.oust_{self.dataset.ust_or_release}_value_mapping a left join public.v_{self.dataset.ust_or_release}_element_mapping b
					on a.{self.dataset.ust_or_release}_control_id = b.{self.dataset.ust_or_release}_control_id
					and a.organization_table_name = b.organization_table_name and a.organization_column_name = b.organization_column_name
					left join public.{self.dataset.ust_or_release}_elements c on b.epa_column_name = c.database_column_name 
					left join (select column_name from public.{self.dataset.ust_or_release}_element_allowed_values) d on b.epa_column_name = d.column_name
				where a.{self.dataset.ust_or_release}_control_id = %s
				order by table_sort_order, column_sort_order"""
		utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id,))
		rows = self.cur.fetchall()
		for row in rows:
			org_table = row[0]
			org_col = row[1]

			logger.info('Working on organization values for %s.%s.%s', self.dataset.schema, org_table, org_col)
			sql = f"""select organization_value
					from public.oust_{self.dataset.ust_or_release}_value_mapping a
					where {self.dataset.ust_or_release}_control_id = %s 
					and organization_table_name = %s and organization_column_name = %s
					and organization_value not in  
						(select {org_col} from {self.dataset.schema}.{org_table})
					order by 1"""
			utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id, org_table, org_col))
			rows2 = self.cur.fetchall()
			if rows2: 
				logger.warning('The following organization values do not appear in the state data in %s.%s.%s', self.dataset.schema, org_table, org_col)
				logger.warning('')
				for row2 in rows2:
					logger.warning(row2[0])
				print('\n\nHere is SQL you can use to fix them:')
				for row2 in rows2:
					print(f"\nupdate public.oust_{self.dataset.ust_or_release}_value_mapping\nset organization_value = ''\nwhere {self.dataset.ust_or_release}_control_id = {self.dataset.control_id}\nand organization_table_name = '{org_table}' and organization_column_name = '{org_col}'\nand organization_value = '{row2[0]}';")
				print('\n\n')
				self.disconnect_db()
				exit()

		# Check that all EPA values are valid
		for row in rows:
			org_table = row[0]
			org_col = row[1]
			epa_table = row[2]
			epa_col = row[3]
			lookup_table = row[4]
			lookup_col = row[5]
			allowed_values = row[6]

			logger.info('Working on mapped EPA values for %s.%s.%s', self.dataset.schema, org_table, org_col)

			if lookup_col:
				sql = f"""select distinct epa_value
						from public.oust_{self.dataset.ust_or_release}_value_mapping a
						where {self.dataset.ust_or_release}_control_id = %s 
						and organization_table_name = %s and organization_column_name = %s
						and epa_value not in  
							(select {lookup_col} from public.{lookup_table})
						order by 1"""
				utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id, org_table, org_col))
				rows2 = self.cur.fetchall()
				if rows2: 
					logger.warning('The following EPA values do not appear in the lookup table public.%s.%s', lookup_table, lookup_col)
					logger.warning('')
					for row2 in rows2:
						logger.warning(row2[0])
					print('\n\nHere is SQL you can use to fix them:')
					for row2 in rows2:
						print(f"\nupdate public.oust_{self.dataset.ust_or_release}_value_mapping\nset epa_value = ''\nwhere {self.dataset.ust_or_release}_control_id = {self.dataset.control_id}\nand organization_table_name = '{org_table}' and organization_column_name = '{org_col}'\nand epa_value = '{row2[0]}';")
					print('\n\n')
					self.disconnect_db()
					exit()

			elif allowed_values:
				sql = f"""select distinct epa_value
					from public.oust_{self.dataset.ust_or_release}_value_mapping a
					where {self.dataset.ust_or_release}_control_id = %s 
					and organization_table_name = %s and organization_column_name = %s
					and epa_value not in  
						(select allowed_value from public.{self.dataset.ust_or_release}_element_allowed_values)
					order by 1"""			
				utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id, org_table, org_col))
				rows2 = self.cur.fetchall()
				if rows2: 
					logger.warning('The following EPA values do not appear in table public.%s_element_allowed_values', self.dataset.ust_or_release)
					logger.warning('')
					for row2 in rows2:
						logger.warning(row2[0])
					print('\n\nHere is SQL you can use to fix them:')
					for row2 in rows2:
						print(f"\nupdate public.oust_{self.dataset.ust_or_release}_value_mapping\nset epa_value = ''\nwhere {self.dataset.ust_or_release}_control_id = {self.dataset.control_id}\nand organization_table_name = '{org_table}' and organization_column_name = '{org_col}'\nand epa_value = '{row2[0]}';")
					print('\n\n')
					self.disconnect_db()
					exit()

			else:
				logger.warning('The EPA values for %s.%s.%s do not appear to either be in a lookup table or in the list of allowed values!', self.dataset.schema, org_table, org_col)
				continue

	def insert_oust_value_mapping(self):
		self.connect_db()
		sql = f"""insert into public.{self.dataset.ust_or_release}_element_value_mapping
					({self.dataset.ust_or_release}_element_mapping_id, organization_value, epa_value, programmer_comments)	
				select a.{self.dataset.ust_or_release}_element_mapping_id, 
					b.organization_value, b.epa_value, 'OUST key vocabulary mapping'	
				from public.{self.dataset.ust_or_release}_element_mapping a join public.oust_{self.dataset.ust_or_release}_value_mapping b 
					on a.{self.dataset.ust_or_release}_control_id = b.{self.dataset.ust_or_release}_control_id
					and a.organization_table_name = b.organization_table_name 
					and a.organization_column_name = b.organization_column_name 
				where a.{self.dataset.ust_or_release}_control_id = %s"""
		utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id,))
		logger.info('Inserted %s rows into public.%s_element_mapping_value', self.cur.rowcount, self.dataset.ust_or_release)
		self.conn.commit()
		self.disconnect_db()


	def process(self):
		self.validate_oust_table()
		self.insert_oust_value_mapping()


def main(ust_or_release=None, control_id=None,):
	v = OustValueMapping(ust_or_release=ust_or_release,
				   		 control_id=control_id)
	# v.process()
	v.insert_oust_value_mapping()


if __name__ == '__main__':   
	main(ust_or_release=ust_or_release, control_id=control_id)		