from datetime import date
import ntpath
import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

from python.util import utils, config
from python.util.export_table import ExportTable
from python.util.logger_factory import logger


export_dir = r"K:/PROJECTS/UST/backups/"
schema = 'public'
data_only = True 				# Boolean. If True will backup tables of types data, mapping, and performance measures only. 
table_types_to_process = ['data','mapping']  # Options are data, lookup, mapping, metadata, performance_measures. 
tables = {
	'mapping': ['ust_element_mapping','ust_element_value_mapping','release_element_mapping','release_element_value_mapping'],
	'data': [
		  	'ust_control',
			'ust_facility',
			'ust_tank',
			'ust_tank_substance',
			'ust_compartment',
			'ust_compartment_substance',
			'ust_piping',
			'ust_facility_dispenser',
			'ust_tank_dispenser',
			'ust_compartment_dispenser',
			'release_control',
			'ust_release',
			'ust_release_substance',
			'ust_release_source',
			'ust_release_cause',
			'ust_release_corrective_action_strategy'
			],
	'metadata': [
          	'ust_elements',
          	'ust_elements_tables',
	        'ust_element_table_sort_order',
	        'ust_element_lookup_tables',
	        'ust_element_allowed_values',
	        'ust_required_view_columns',
          	'ust_template_data_tables',
          	'ust_template_lookup_tables',
          	'ust_view_key_columns',
		  	'release_elements',
          	'release_elements_tables',
          	'release_element_table_sort_order',
          	'release_element_allowed_values',
          	'release_required_view_columns',
          	'release_template_data_tables',
          	'release_template_lookup_tables',
          	'release_view_key_columns',
          	'generated_table_sort_order',
          	'mapped_table_types'
          	],
    'lookup': [
      	  'causes',
      	  'cert_of_installations',
      	  'chemical_list',
          'compartment_statuses',
          'coordinate_sources',
          'corrective_action_strategies',
          'cui_exclusions',
          'dispenser_udc_wall_types',
          'epa_regions',
          'facility_types',
          'owner_types',
          'pipe_tank_top_sump_wall_types',
          'piping_styles',
          'piping_wall_types',
          'sources',
          'spill_bucket_wall_types',
          'states',
          'substances',
          'tank_locations',
          'tank_material_descriptions',
          'tank_secondary_containments',
          'tank_statuses'
          ],
    'performance_measures': ['performance_measures_ust','performance_measures_release']
}


class Backup:
	export_dir = None 

	def __init__(self, 
				 export_dir,
				 schema,
				 tables,
				 data_only=False, 
				 table_types_to_process=None):
		self.base_export_dir = export_dir
		self.schema = schema
		self.tables = tables 
		self.data_only = data_only
		if table_types_to_process:
			self.check_table_types(table_types_to_process)
			self.table_types_to_process = table_types_to_process
		elif data_only:
			self.table_types_to_process = ['data','mapping','performance_measures']
		else: 
			self.table_types_to_process = [k for k in tables.keys()]
		

	def check_table_types(self, table_types_to_process):
		for table_type in table_types_to_process:
			if table_type not in tables.keys():
				logger.error('Invalid table type in table_types_to_process: %s; exiting', table_type)
				exit()
		return True 

	def backup(self):
		for table_type in self.table_types_to_process:
			logger.info('--------------------------------------------------------------------')
			logger.info('Working on table type: %s', table_type)
			self.export_dir = self.base_export_dir + self.schema + '/' + table_type + '/'
			os.makedirs(self.export_dir, exist_ok=True)
			for table in self.tables[table_type]:
				logger.info('Working on table %s.%s', self.schema, table)
				ExportTable(schema=self.schema, table_name=table, export_dir=self.export_dir).export()


def main(export_dir, schema, tables, data_only, table_types_to_process):
	b = Backup(export_dir=export_dir, 
				  schema=schema, 
				  tables=tables,
				  data_only=data_only,
				  table_types_to_process=table_types_to_process)
	b.backup()


if __name__ == '__main__':   
	main(export_dir=export_dir,
		 schema=schema,
		 tables=tables,
		 data_only=data_only,
		 table_types_to_process=table_types_to_process)				