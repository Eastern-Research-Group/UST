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
	ust_views = ['v_ust_facility',
	             'v_ust_tank',
	             'v_ust_tank_substance',
	             'v_ust_compartment',
	             'v_ust_compartment_substance',
	             'v_ust_piping',
	             'v_ust_facility_dispenser',
	             'v_ust_tank_dispenser',
	             'v_ust_compartment_dispenser']
	release_views = ['v_ust_release',
	                 'v_ust_release_substance',
	                 'v_ust_release_source',
	                 'v_ust_release_cause',
	                 'v_ust_release_corrective_action_strategy']

	def __init__(self, 
				 export_file_path,
				 exclude_invalid_coords=True,
				 ust_exclude_orgs=[],
				 release_exclude_orgs=[]):
		self.export_file_path = export_file_path
		self.exclude_invalid_coords = exclude_invalid_coords
		self.ust_exclude_orgs = ust_exclude_orgs 
		self.release_exclude_orgs = release_exclude_orgs
		self.ust_where_sql = self.build_where_sql('ust') 
		self.release_where_sql = self.build_where_sql('release') 
		self.get_views()


	def build_where_sql(self, ust_or_release):
		if ust_or_release == 'ust':
			lat_col = '"FacilityLatitude"'
			long_col = '"FacilityLongitude"'
			sql = """where "FacilityID" in \n\t(select "FacilityID" from public.v_ust_facility """
		else:
			lat_col = '"Latitude"'
			long_col = '"Longitude"'
			sql = """where "ReleaseID" in \n\t(select "ReleaseID" from public.v_ust_release """

		where_sql = ''
		if self.ust_exclude_orgs:
			where_sql = '\n\twhere b.organization_id not in ('
			for org in self.ust_exclude_orgs:
				where_sql = where_sql + "'" + org + "',"
			where_sql = where_sql[:-1] + ')'
		if self.exclude_invalid_coords:
			if where_sql:
				where_sql = where_sql + '\n\tand '
			else:
				where_sql = '\n\twhere '
			where_sql = where_sql + f'scale(cast({lat_col} as numeric)) > 2'
			where_sql = where_sql + f'\n\tand scale(cast({long_col} as numeric)) > 2'

		if where_sql:
			return sql + where_sql + ')'
		else:
			return ''


	def build_sql(self, view_name, ust_or_release):
		sql = "select b.organization_id, a.*\n"
		sql = sql + f"from public.{view_name} a join public.{ust_or_release}_control b on a.{ust_or_release}_control_id = b.{ust_or_release}_control_id\n"
		if ust_or_release == 'ust':
			sql = sql + self.ust_where_sql + ';\n\n'
		else:
			sql = sql + self.release_where_sql + ';\n\n'
		return sql


	def export_view(self, view_name, ust_or_release):
		sql = self.build_sql(view_name, ust_or_release)
		print(sql)
		try:
			df = pd.read_sql(sql, utils.get_engine())
		except Exception as e:
			logger.error('Unable to export query to a dataframe. Error message: %s', e)
			return
		logger.info('Query exported to dataframe')

		file_name = view_name.replace('v_','') + '.csv'
		full_path = self.export_file_path + '\\' + file_name
		try:
			df.to_csv(full_path, index=False)
		except Exception as e:
			logger.error('Unable to export query results to CSV. Error message: %s', e)
			return
		logger.info('Exported %s to %s', view_name, full_path)


	def get_views(self):
		for view_name in self.ust_views:
			logger.info('Working on %s', view_name)
			self.export_view(view_name, 'ust')
			exit()

		for view_name in self.release_views:
			logger.info('Working on %s', view_name)
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

