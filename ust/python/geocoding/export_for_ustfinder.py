import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import pandas as pd 

from python.util.logger_factory import logger
from python.util import utils

ust_control_ids = [16]
release_control_ids = [8,13]

class GeocodeExport:
	elements_df = None 
	
	def __init__(self, ust_control_ids=None, release_control_ids=None):
		if not ust_control_ids and not release_control_ids:
			raise ValueError('Either ust_control_ids and/or release_control_ids must be passed.')
		self.ust_control_ids = ust_control_ids
		self.release_control_ids = release_control_ids
		self.timestamp_str = utils.get_timestamp_str()
		self.output_dir = '../../python/exports/geocoding/ustfinder/'


	def get_elements(self, ust_or_release):
		if ust_or_release not in ('ust','release'):
			raise ValueError(f'Unknown value "{ust_or_release}" for ust_or_release. Allowed values are "ust" and "release"')
		sql = f"""select a.table_name as view_name, b.element_name, b.table_sort_order, b.column_sort_order 
				from information_schema.columns a join public.v_{ust_or_release}_ustfinder_elements b 
					on replace(a.table_name,'v_','') = b.table_name and a.column_name = b.element_name
				where a.table_schema = 'public' 
				order by b.table_sort_order, b.column_sort_order"""
		return pd.read_sql(sql, con=utils.get_engine())


	def export_data(self, ust_or_release):
		if ust_or_release not in ('ust','release'):
			raise ValueError(f'Unknown value "{ust_or_release}" for ust_or_release. Allowed values are "ust" and "release"')
		
		os.makedirs(self.output_dir + ust_or_release + '/', exist_ok=True)
			
		if ust_or_release == 'ust':
			if not self.ust_control_ids:
				return
			control_ids = utils.list_nums_to_string(self.ust_control_ids)
			pk_col = 'ust_facility_id'
			join_sql = """\njoin public.ust_facility c on a.ust_control_id = c.ust_control_id and a."FacilityID" = c.facility_id\n"""
			# geo_where_sql = """\nfrom public.ust_facility a\njoin public.ust_control b on a.ust_control_id = b.ust_control_id\nleft join public.ust_facility_geocode c on a.ust_facility_id = c.ust_facility_id\n"""
			# geo_col_prefix = "facility_"
			order_sql = f'order by organization_id, "FacilityID"'
		else:
			if not self.release_control_ids:
				return
			control_ids = utils.list_nums_to_string(self.release_control_ids)
			pk_col = 'ust_release_id'
			join_sql = """\njoin public.ust_release c on a.release_control_id = c.release_control_id and a."ReleaseID" = c.release_id\n"""
			# geo_where_sql = """\nfrom public.ust_release a\njoin public.release_control b on a.release_control_id = b.release_control_id\nleft join public.ust_release_geocode c on a.ust_release_id = c.ust_release_id\n"""
			# geo_col_prefix = ""
			order_sql = f'order by organization_id, "ReleaseID"'
		
		self.elements_df = self.get_elements(ust_or_release)
		# utils.pretty_print_df(self.elements_df)
		views = self.elements_df['view_name'].unique().tolist()
		sql_prefix = f"""select a.{ust_or_release}_control_id, organization_id, c.{pk_col}, """
		
		for view in views:
			logger.info('Working on %s', view)
			if view == 'v_ust_tank':
				sql_prefix += 'd.ust_tank_id, '
				join_sql += """left join public.ust_tank d on c.ust_facility_id = d.ust_facility_id\n"""
				order_sql += ', "TankID", "TankName"'
			elif view == 'v_ust_compartment':
				sql_prefix += 'e.ust_compartment_id, '
				join_sql += """left join public.ust_compartment e on d.ust_tank_id = e.ust_tank_id\n"""
				order_sql += ', "CompartmentID", "CompartmentName"'
			elif view == 'v_ust_piping':
				sql_prefix +=  'f.ust_piping_id, '
				join_sql += """left join public.ust_piping f on e.ust_compartment_id = f.ust_compartment_id\n"""
				order_sql += ', "PipingID"'
			filtered_df = self.elements_df[self.elements_df['view_name'] == view]
			cols = filtered_df['element_name'].tolist()
			sql = sql_prefix
			for col in cols:
				if col == 'FacilityName' or col == 'SiteName':
					sql += f"""case when "CuiFlag" = 'Y' then '[REDACTED]' else "{col}" end as "{col}",\n"""
				else:
					sql += '"' + col + '",\n'
			sql = sql[:-2]
			sql += f"""\nfrom public.{view} a\njoin public.{ust_or_release}_control b on a.{ust_or_release}_control_id = b.{ust_or_release}_control_id"""
			sql += f"""{join_sql}where a.{ust_or_release}_control_id in ({control_ids})\n{order_sql}"""
			# print(sql)
			# print('\n\n')
			data_df = pd.read_sql(sql, con=utils.get_engine())
			file_name = view.replace('v_','') + '_' + self.timestamp_str + '.csv'
			output_path = self.output_dir + ust_or_release + '/' + file_name
			data_df.to_csv(output_path, index=False)
			logger.info('Exported %s', output_path)


	def export_geo_data(self, ust_or_release):
		if ust_or_release == 'ust':
			if not self.ust_control_ids:
				return
			control_ids = utils.list_nums_to_string(self.ust_control_ids)
			pk_col = 'ust_facility_id'
			geo_from_sql = """from public.ust_facility a\njoin public.ust_control b on a.ust_control_id = b.ust_control_id\nleft join public.ust_facility_geocode c on a.ust_facility_id = c.ust_facility_id\n"""
			geo_col_prefix = "facility_"
			file_name = 'ust_facility_geo_locations_' + self.timestamp_str + '.csv'
		else:
			if not self.release_control_ids:
				return
			control_ids = utils.list_nums_to_string(self.release_control_ids)
			pk_col = 'ust_release_id'
			geo_from_sql = """from public.ust_release a\njoin public.release_control b on a.release_control_id = b.release_control_id\nleft join public.ust_release_geocode c on a.ust_release_id = c.ust_release_id\n"""
			geo_col_prefix = ""
			file_name = 'ust_release_geo_locations_' + self.timestamp_str + '.csv'
			
		logger.info('Working on %s location export', ust_or_release)
		if ust_or_release == 'ust':
			col = 'a.facility_id as "FacilityID",\n'
		else:
			col = 'a.release_id as "ReleaseID",\n'
		sql = f"""select a.{ust_or_release}_control_id, organization_id, c.{pk_col}, {col}\n"""		
		sql = sql + f"""case when c.latitude is not null then c.latitude else a.{geo_col_prefix}latitude end as latitude,\n"""
		sql = sql + f"""case when c.longitude is not null then c.longitude else a.{geo_col_prefix}longitude end as longitude,\n"""
		sql = sql + """case when c.latitude is not null then 'derived' else 'organization' end as coordinate_source\n"""	
		sql = sql + geo_from_sql + f"where a.{ust_or_release}_control_id in ({control_ids})\norder by organization_id, 4"
		data_df = pd.read_sql(sql, con=utils.get_engine())
		output_path = self.output_dir + ust_or_release + '/' + file_name
		data_df.to_csv(output_path, index=False)
		logger.info('Exported %s', output_path)


	def process(self):
		self.export_data('ust')
		self.export_geo_data('ust')
		self.export_data('release')
		self.export_geo_data('release')


def main(ust_control_ids=None, release_control_ids=None):
	g = GeocodeExport(ust_control_ids=ust_control_ids, release_control_ids=release_control_ids)
	g.process()


if __name__ == '__main__':   
	main(ust_control_ids=ust_control_ids, release_control_ids=release_control_ids)		