from datetime import date
import ntpath
import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

from python.state_processing.cui_update import CuiUpdate 
from python.util import utils, config
from python.util.dataset import Dataset 
from python.util.logger_factory import logger


ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = 0               	# Enter an integer that is the ust_control_id or release_control_id
organization_id = ''      		# Optional; if control_id = 0 or None, will find the most recent control_id
delete_existing = False 		# Boolean, defaults to False. Set to True to delete existing data. Script will return an error if this variable is False and data exists in the EPA data tables for the control_id.			


class Populate:
	def __init__(self, dataset, delete_existing=False):
		self.dataset = dataset
		self.delete_existing = delete_existing


	def execute(self):
		conn = utils.connect_db()
		cur = conn.cursor()
		logger.info('Connected to database')

		if self.delete_existing:
			if self.dataset.ust_or_release == 'release':
				utils.delete_all_release_data(self.dataset.control_id)
			else:
				utils.delete_all_ust_data(self.dataset.control_id) 
		else:
			if self.dataset.ust_or_release == 'release':
				table_name = 'ust_release'
			else:
				table_name = 'ust_facility'

			sql = f"select count(*) from public.{table_name} where {self.dataset.ust_or_release}_control_id = %s"
			utils.process_sql(conn, cur, sql, params=(self.dataset.control_id,))
			cnt = cur.fetchone()[0]
			if cnt > 0:
				logger.warning('Data found in %s for %s_control_id %s. To proceed, set the delete_existing variable to True.', table_name, self.dataset.ust_or_release, self.dataset.control_id)
				exit()

		table_name = self.dataset.ust_or_release + '_template_data_tables'
		sql = f"""select table_name, view_name, sort_order
				from {table_name}
				order by sort_order"""
		utils.process_sql(conn, cur, sql)
		rows = cur.fetchall()
		for row in rows:
			org_column_list = ''
			table_name = row[0]
			view_name = row[1]
			sort_order = row[2]
			logger.info('Working on #%s: %s, %s', sort_order, table_name, view_name)

			sql = f"""select column_name from information_schema.columns 
					where table_schema = %s and table_name = %s 
					order by ordinal_position"""
			utils.process_sql(conn, cur, sql, params=(self.dataset.schema, view_name))
			rows2 = cur.fetchall()
			for row2 in rows2:
				org_column_list = org_column_list + row2[0] + ', '
			if org_column_list:
				if sort_order == 1:
					org_column_list = org_column_list + self.dataset.ust_or_release + '_control_id'
					select_column_list = org_column_list.replace(self.dataset.ust_or_release + '_control_id', str(self.dataset.control_id))
					insert_sql = f"""insert into public.{table_name} ({org_column_list}) 
									select {select_column_list} from {self.dataset.schema}.{view_name}"""
					utils.process_sql(conn, cur, insert_sql)
				else: 
					if self.dataset.ust_or_release == 'release':
						column_list = 'ust_release_id, ' + org_column_list[:-2]
						column_list = column_list.replace(', release_id','')
						parent_table = 'ust_release'
						join_col = 'release_id'
						epa_col = 'ust_release_id'
					else:
						column_list = 'ust_facility_id, ' + org_column_list[:-2] 
						column_list = column_list.replace(', facility_id','')
						parent_table = 'ust_facility' 
						join_col = 'facility_id' 
						epa_col = 'ust_facility_id' 
					if self.dataset.ust_or_release == 'release' or view_name in ('v_ust_facility','v_ust_tank','v_ust_facility_dispenser'):
						insert_sql = f"""insert into public.{table_name} ({column_list})
										select distinct {column_list} from {self.dataset.schema}.{view_name} a 
											join (select {epa_col}, {join_col} from public.{parent_table} where {self.dataset.ust_or_release}_control_id = %s) b
												on a.{join_col} = b.{join_col}"""
					elif view_name == 'v_ust_tank_substance':
						column_list = 'ust_tank_id, ' + org_column_list[:-2] 
						column_list = column_list.replace(', facility_id','').replace(', tank_id','')
						insert_sql = f"""insert into public.ust_tank_substance ({column_list})
										select distinct {column_list} from {self.dataset.schema}.v_ust_tank_substance a 
											join (select ust_facility_id, facility_id from public.ust_facility where ust_control_id = %s) b
												on a.facility_id = b.facility_id
											join public.ust_tank c on b.ust_facility_id = c.ust_facility_id and a.tank_id = c.tank_id"""
					elif view_name == 'v_ust_tank_dispenser':
						column_list = 'ust_tank_id, ' + org_column_list[:-2] 
						column_list = column_list.replace(', facility_id','').replace(', tank_id','')
						insert_sql = f"""insert into public.ust_tank_dispenser ({column_list})
										select distinct {column_list} from {self.dataset.schema}.v_ust_tank_dispenser a 
											join (select ust_facility_id, facility_id from public.ust_facility where ust_control_id = %s) b
												on a.facility_id = b.facility_id
											join public.ust_tank c on b.ust_facility_id = c.ust_facility_id and a.tank_id = c.tank_id"""
					elif view_name == 'v_ust_compartment':
						column_list = 'ust_tank_id, ' + org_column_list[:-2] 
						column_list = column_list.replace(', facility_id','').replace(', tank_id','')
						insert_sql = f"""insert into public.ust_compartment ({column_list})
										select distinct {column_list} from {self.dataset.schema}.v_ust_compartment a 
											join (select ust_facility_id, facility_id from public.ust_facility where ust_control_id = %s) b
												on a.facility_id = b.facility_id
											join public.ust_tank c on b.ust_facility_id = c.ust_facility_id and a.tank_id = c.tank_id"""
					elif view_name == 'v_ust_compartment_substance':
						column_list = 'ust_tank_substance_id, ust_compartment_id'
						sql2 = """select count(*) from information_schema.columns 
						          where table_schema = %s and table_name = 'v_ust_compartment_substance' and column_name = 'substance_comment'"""
						utils.process_sql(conn, cur, sql2, params=(self.dataset.schema,))
						cnt = cur.fetchone()[0]
						if cnt > 0:
							column_list = column_list + ', substance_comment'
						insert_sql = f"""insert into public.ust_compartment_substance ({column_list})
										select distinct {column_list.replace('substance_comment','a.substance_comment')} from {self.dataset.schema}.v_ust_compartment_substance a 
											join (select ust_facility_id, facility_id from public.ust_facility where ust_control_id = %s) b
												on a.facility_id = b.facility_id
											join public.ust_tank c on b.ust_facility_id = c.ust_facility_id and a.tank_id = c.tank_id
											join ust_compartment d on c.ust_tank_id = d.ust_tank_id and a.compartment_id = d.compartment_id
											join public.ust_tank_substance e on c.ust_tank_id = e.ust_tank_id and a.substance_id = e.substance_id """
					elif view_name == 'v_ust_piping':
						column_list = 'ust_compartment_id, ' + org_column_list[:-2] 
						column_list = column_list.replace(', facility_id','').replace(', tank_id','').replace(', compartment_id','')
						insert_sql = f"""insert into public.ust_piping ({column_list})
										select distinct {column_list} from {self.dataset.schema}.v_ust_piping a 
											join (select ust_facility_id, facility_id from public.ust_facility where ust_control_id = %s) b
												on a.facility_id = b.facility_id
											join public.ust_tank c on b.ust_facility_id = c.ust_facility_id and a.tank_id = c.tank_id
											join public.ust_compartment d on c.ust_tank_id = d.ust_tank_id and a.compartment_id = d.compartment_id"""
					elif view_name == 'v_ust_compartment_dispenser':
						column_list = 'ust_compartment_id, ' + org_column_list[:-2] 
						column_list = column_list.replace(', facility_id','').replace(', tank_id','').replace(', compartment_id','')
						insert_sql = f"""insert into public.ust_compartment_dispenser ({column_list})
										select distinct {column_list} from {self.dataset.schema}.v_ust_compartment_dispenser a 
											join (select ust_facility_id, facility_id from public.ust_facility where ust_control_id = %s) b
												on a.facility_id = b.facility_id
											join public.ust_tank c on b.ust_facility_id = c.ust_facility_id and a.tank_id = c.tank_id
											join public.ust_compartment d on c.ust_tank_id = d.ust_tank_id and a.compartment_id = d.compartment_id"""
					# print(insert_sql)
					utils.process_sql(conn, cur, insert_sql, params=(self.dataset.control_id,))

				rows_inserted = cur.rowcount
				conn.commit()
				logger.info('Inserted %s rows into %s', rows_inserted, table_name)

		cur.close()
		conn.close()
		logger.info('Disconnected from database')

		CuiUpdate(ust_or_release=self.dataset.ust_or_release, control_id=self.dataset.control_id).process()


def main(ust_or_release, control_id=0, organization_id=None, delete_existing=False):
	if not control_id or control_id == 0:
		control_id = utils.get_control_id(ust_or_release, organization_id)

	dataset = Dataset(ust_or_release=ust_or_release,
				 	  control_id=control_id,
				 	  requires_export=False)

	Populate(dataset, delete_existing).execute()



if __name__ == '__main__':   
	main(ust_or_release=ust_or_release,
		 control_id=control_id,
		 organization_id=organization_id,
		 delete_existing=delete_existing)
