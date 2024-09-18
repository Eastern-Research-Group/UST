from datetime import datetime
import ntpath
import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

from python.util import utils
from python.util.logger_factory import logger


class Dataset:
	def __init__(self, 
				 ust_or_release, 
				 control_id, 
				 requires_export=True,
				 base_file_name=None,
				 export_file_path=None, 
				 export_file_dir=None, 
				 export_file_name=None):
			self.ust_or_release = utils.verify_ust_or_release(ust_or_release)
			self.control_id = control_id
			self.organization_id = utils.get_org_from_control_id(self.control_id, self.ust_or_release)
			self.schema = utils.get_schema_from_control_id(self.control_id, self.ust_or_release)
			self.requires_export = requires_export
			self.base_file_name = base_file_name
			self.export_file_name = export_file_name
			self.export_file_dir = export_file_dir
			self.export_file_path = export_file_path
			if self.requires_export:
				self.populate_export_vars()
			# self.print_self()

			
	def populate_export_vars(self):
		if not self.base_file_name:
			self.base_file_name = '_export.sql'
		if not self.export_file_path and not self.export_file_path and not self.export_file_name:
			self.export_file_name = self.organization_id.upper() + '_' + utils.get_pretty_ust_or_release(self.ust_or_release) + '_' + self.base_file_name
			if not self.export_file_dir and self.base_file_name[-4:] == '.sql':
				self.export_file_dir = '../../sql/states/' + self.organization_id.upper() + '/' + utils.get_pretty_ust_or_release(self.ust_or_release) + '/'
			elif not self.export_file_dir and self.base_file_name[-5:] == '.xlsx':
				self.export_file_dir = '../../python/exports/'
				folder = None
				if 'control' in self.base_file_name.lower():
					folder = 'control_table_summaries/'
				elif 'mapping' in self.base_file_name.lower():
					folder = 'mapping/'
				elif 'qaqc' in self.base_file_name.lower():
					folder = 'QAQC/'
				elif 'template' in self.base_file_name:
					folder = 'epa_templates/'
				else:
					folder = 'other/'
				self.export_file_dir = self.export_file_dir + folder + self.organization_id.upper() + '/' + utils.get_pretty_ust_or_release(self.ust_or_release) + '/'
			else:
				logger.error('Please set export_file_dir so I know where to save the export file. Exiting....')

			self.export_file_path = self.export_file_dir + self.export_file_name
			Path(self.export_file_dir).mkdir(parents=True, exist_ok=True)
		elif self.export_file_path:
			fp = ntpath.split(self.export_file_path)
			self.export_file_dir = fp[0]
			self.export_file_name = fp[1]
		elif self.export_file_dir and self.export_file_name:
			if self.export_file_name[-4:] != '.sql':
				self.export_file_name = self.export_file_name + '.sql'
			self.export_file_path = os.path.join(self.export_file_dir, self.export_file_name)
		# logger.debug('export_file_name = %s; export_file_dir = %s; export_file_path = %s', self.export_file_name, self.export_file_dir, self.export_file_path)


	def print_self(self):
		logger.debug('ust_or_release = %s', self.ust_or_release)
		logger.debug('control_id = %s', self.control_id)
		logger.debug('organization_id = %s', self.organization_id)
		logger.debug('schema = %s', self.schema)
		logger.debug('base_file_name = %s', self.base_file_name)
		logger.debug('export_file_name = %s', self.export_file_name)
		logger.debug('export_file_dir = %s', self.export_file_dir)
		logger.debug('export_file_path = %s', self.export_file_path)


