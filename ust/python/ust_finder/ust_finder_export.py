import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import pandas as pd
import zipfile

from python.util import utils
from python.util.logger_factory import logger


export_file_path = r'C:\Users\renae\Documents\Work\UST\UST Finder inputs'
exclude_invalid_coords = True   # invalid means null or less than 3-digit precision
ust_exclude_orgs = ['HI','MO']
release_exclude_orgs = []


class Export:
	ust_views = {
				 'v_ust_facility': ['"FacilityID"'],
	             'v_ust_tank': ['"FacilityID"','"TankID"'],
	             'v_ust_tank_substance': ['"FacilityID"','"TankID"','"Substance"'],
	             'v_ust_compartment': ['"FacilityID"','"TankID"','"CompartmentID"'],
	             'v_ust_compartment_substance': ['"FacilityID"','"TankID"','"CompartmentID"','"Substance"'],
	             'v_ust_piping': ['"FacilityID"','"TankID"','"CompartmentID"'],
	             'v_ust_facility_dispenser': ['"FacilityID"','"DispenserID"'],
	             'v_ust_tank_dispenser': ['"FacilityID"','"TankID"','"DispenserID"'],
	             'v_ust_compartment_dispenser': ['"FacilityID"','"TankID"','"CompartmentID"','"DispenserID"']
	             }
	release_views = {
	                 'v_ust_release': ['"ReleaseID"'],
	                 'v_ust_release_substance': ['"ReleaseID"','"SubstanceReleased"'],
	                 'v_ust_release_source': ['"ReleaseID"','"SourceOfRelease"'],
	                 'v_ust_release_cause': ['"ReleaseID",'"CauseOfRelease"''],
	                 'v_ust_release_corrective_action_strategy': ['"ReleaseID"','"CorrectiveActionStrategy"']
	                 }

	def __init__(self, 
				 export_file_path,
				 exclude_invalid_coords=True,
				 ust_exclude_orgs=[],
				 release_exclude_orgs=[]):
		self.export_file_path = export_file_path
		self.exclude_invalid_coords = exclude_invalid_coords
		self.ust_exclude_orgs = ust_exclude_orgs 
		self.release_exclude_orgs = release_exclude_orgs
		self.build_id_tables()
		self.get_views()


	def build_id_tables(self):
		conn = utils.connect_db()
		cur = conn.cursor()

		sql = 'drop table if exists public.temp_facids'
		cur.execute(sql)
		sql = 'select distinct a.ust_control_id, "FacilityID" into public.temp_facids\n' + self.build_id_sql('ust')
		cur.execute(sql)
		sql = 'alter table public.temp_facids add constraint temp_facids_pk primary key (ust_control_id, "FacilityID")'
		cur.execute(sql)
		logger.info('Created table public.temp_facids')

		sql = 'drop table if exists public.temp_releaseids'
		cur.execute(sql)
		sql = 'select distinct a.release_control_id, "ReleaseID" into public.temp_releaseids\n' + self.build_id_sql('release')
		cur.execute(sql)
		sql = 'alter table public.temp_releaseids add constraint temp_releaseids_pk primary key (release_control_id, "ReleaseID")'
		cur.execute(sql)
		logger.info('Created table public.temp_releaseids')

		cur.close()
		conn.close()


	def build_id_sql(self, ust_or_release):
		if ust_or_release == 'ust':
			lat_col = '"FacilityLatitude"'
			long_col = '"FacilityLongitude"'
			sql = """from public.v_ust_facility a join public.ust_control b on a.ust_control_id = b.ust_control_id """
		else:
			lat_col = '"Latitude"'
			long_col = '"Longitude"'
			sql = """from public.v_ust_release a join public.release_control b on a.release_control_id = b.release_control_id  """

		where_sql = ''
		if self.ust_exclude_orgs:
			where_sql = '\nwhere b.organization_id not in ('
			for org in self.ust_exclude_orgs:
				where_sql = where_sql + "'" + org + "',"
			where_sql = where_sql[:-1] + ')'
		if self.exclude_invalid_coords:
			if where_sql:
				where_sql = where_sql + '\nand '
			else:
				where_sql = '\nwhere '
			where_sql = where_sql + f'scale(cast({lat_col} as numeric)) > 2'
			where_sql = where_sql + f'\nand scale(cast({long_col} as numeric)) > 2'

		if where_sql:
			return sql + where_sql
		else:
			return sql 


	def build_sql(self, view_name, ust_or_release):
		sql = f"from public.{view_name} a join public.{ust_or_release}_control b on a.{ust_or_release}_control_id = b.{ust_or_release}_control_id\n"
		if ust_or_release == 'ust':
			sql = sql + 'where not exists (select 1 from public.temp_facids c where a."FacilityID" = c."FacilityID" and a.ust_control_id = b.ust_control_id)' + ';\n\n'
		else:
			sql = sql + 'where not exists (select 1 from public.temp_releaseids c where a."ReleaseID" = c."ReleaseID" and a.release_control_id = c.release_control_id)' + ';\n\n'
		return sql


	def build_temp_table(self, view_name, pk_columns, ust_or_release):
		conn = utils.connect_db()
		cur = conn.cursor()
		temp_table_name = 'temp_' + view_name
		sql = "drop table if exists public." + temp_table_name
		cur.execute(sql)
		sql = f"select b.organization_id, a.*\ninto {temp_table_name}\n{self.build_sql(view_name, ust_or_release)}"
		cur.execute(sql)
		logger.info('Created table %s', temp_table_name)
		# sql = f'alter table {temp_table_name} add constraint {temp_table_name}_pk primary key (organization_id,'
		sql = f'create index {temp_table_name}_idx on public.{temp_table_name} ('
		for pk_col in pk_columns:
			sql = sql + pk_col + ','
		sql = sql[:-1] + ')'
		cur.execute(sql)
		logger.info('Added index on %s', temp_table_name)
		cur.close()
		conn.close()


	def export_view(self, view_name, ust_or_release):
		temp_table_name = 'temp_' + view_name

		try:
			df = pd.read_sql(f'select * from public.{temp_table_name}', utils.get_engine())
		except Exception as e:
			logger.error('Unable to export query to a dataframe. Error message: %s', e)
			return
		logger.info('Query exported to dataframe')

		file_name = view_name.replace('v_','') + '.csv'
		dir_path = self.export_file_path + '\\' + ust_or_release + '\\' 
		if not os.path.exists(dir_path):
		    os.mkdir(dir_path)
		full_path = dir_path + file_name
		try:
			df.to_csv(full_path, index=False)
		except Exception as e:
			logger.error('Unable to export query results to CSV. Error message: %s', e)
			return
		logger.info('Exported %s to %s', view_name, full_path)


	def get_views(self):
		for view_name, pk_cols in self.ust_views.items():
			logger.info('Working on %s', view_name)
			self.build_temp_table(view_name, pk_cols, 'ust')
			self.export_view(view_name, 'ust')

		for view_name, pk_cols in self.release_views.items():
			logger.info('Working on %s', view_name)
			self.build_temp_table(view_name, pk_cols, 'release')
			self.export_view(view_name, 'release')


	def zip_file(self):
		pass
		# with ZipFile(zip_file_path, 'w') as zf:
		#     zf.write(full_path, compress_type=compression)
		# logger.info('Zip file saved to %s', zip_file_path)




def main(export_file_path, 
		 exclude_invalid_coords=True, 
		 ust_exclude_orgs=[],
		 release_exclude_orgs=[]):

	export = Export(export_file_path=export_file_path,
  				    exclude_invalid_coords=exclude_invalid_coords,
				    ust_exclude_orgs=ust_exclude_orgs,
				    release_exclude_orgs=release_exclude_orgs)
	

if __name__ == '__main__':   
	main(export_file_path=export_file_path,
		 exclude_invalid_coords=exclude_invalid_coords,
		 ust_exclude_orgs=ust_exclude_orgs,
		 release_exclude_orgs=release_exclude_orgs)

