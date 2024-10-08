import glob
import ntpath
import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import pandas as pd

from python.util import utils, config
from python.util.dataset import Dataset 
from python.util.logger_factory import logger


ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = 0                  # Enter an integer that is the ust_control_id or release_control_id
all_tables = True               # Boolean, defaults to True. If True will export all source data tables; if False will only export those referenced in ust_element_mapping or release_element_mapping.
tables_to_exclude = []          # Python list of strings; defaults to empty list. Populate with table names in the organization schema that should be excluded from the export. (NOTE: ERG-created tables will not be exported regardless of the values in this list.)
empty_export_dir = True         # Boolen, defaults to True. If True, will delete all files in the export directory before proceeding. If False, will not delete any files, but will overwrite any that have the same name as the generated file name. 

# This variable can usually be left unset. This script will generate CSV files named with the table name, in the appropriate state folder in the repo under /ust/python/exports/source_data/. 
# This file directory and its contents are excluded from pushes to the repo by .gitignore.
# You are responsible for uploading the exported files to the "Documents / General / 01 - UST Source Data" folder of the EPA Teams site: 
# https://usepa.sharepoint.com/:f:/r/sites/USTFinder2ASTSWMO/Shared%20Documents/General/01%20-%20UST%20Source%20Data?csf=1&web=1&e=7GtcsH
export_file_dir = None


class SourceData:
	conn = None  
	cur = None  
	table_list = None 

	def __init__(self, 
				 dataset,
				 all_tables=True,
				 tables_to_exclude=None,
				 empty_export_dir=None,
				 export_file_dir=None):
		self.dataset = dataset
		self.all_tables = all_tables
		self.tables_to_exclude = tables_to_exclude	
		self.empty_export_dir = empty_export_dir
		self.export_file_dir = export_file_dir	
		if not self.export_file_dir:
			self.set_export_file_dir()
		Path(self.export_file_dir).mkdir(parents=True, exist_ok=True)	
		if self.empty_export_dir:
			self.clean_export_dir()	
		self.connect_db()
		self.set_table_list()
		self.export_tables()
		self.disconnect_db()


	def set_export_file_dir(self):
		if not self.export_file_dir:
			export_file_dir = '../../python/exports/source_data/' + self.dataset.organization_id + '/' 
			export_file_dir = export_file_dir + utils.get_pretty_ust_or_release(self.dataset.ust_or_release) + '/'
			self.export_file_dir = export_file_dir
			logger.info('Export directory set to %s', self.export_file_dir)


	def connect_db(self):
		self.conn = utils.connect_db()
		self.cur = self.conn.cursor()
		logger.info('Connected to database')


	def disconnect_db(self):
		self.conn.commit()
		self.cur.close()
		self.conn.close()
		logger.info('Diconnected from database')


	def clean_export_dir(self):
		files = glob.glob(self.export_file_dir + '*')
		for f in files:
			os.remove(f)
			logger.info('Deleted %s', f)


	def set_table_list(self):
		if all_tables:
			sql = f"""select table_name from information_schema.tables
			          where table_schema = %s and table_type = 'BASE TABLE'
			          and table_name not like 'erg_%%'
			          order by 1"""
		else:
			sql = f"""select table_name from information_schema.tables a
			          where table_schema = %s and table_type = 'BASE TABLE'
			          and table_name not like 'erg_%%' 
			          and exists 
			          	(select 1 from public.v_{self.dataset.ust_or_release}_used_source_tables b
			          	where a.table_name = b.table_name 
			          	and b.{self.dataset.ust_or_release}_control_id = {self.dataset.control_id})
			          order by 1"""			
		self.cur.execute(sql, (self.dataset.schema,))
		# utils.pretty_print_query(self.cur)
		self.table_list = [r[0] for r in self.cur.fetchall()]
		if not self.table_list:
			logger.info('No non-ERG-created tables found in schema %s; exiting.', self.dataset.schema)
			self.disconnect_db()
			exit()
		for exclude_table in self.tables_to_exclude:
			try:
				self.table_list.remove(exclude_table)
				logger.warning('Table "%s" exists in the database but will not be exported because it was found in the tables_to_exclude variable', exclude_table)
			except ValueError:
				pass
		logger.info('The following tables were found in schema %s and will be exported:', self.dataset.schema)
		for table in self.table_list:
			logger.info(table)
		

	def export_tables(self):
		for table in self.table_list:
			logger.info('Working on table "%s"', table)
			file_name = table + '.csv'
			logger.info('Exporting to file named %s in %s', file_name, self.export_file_dir)
			export_file_path = self.export_file_dir + file_name

			df = pd.read_sql_table(table, con=utils.get_engine(), schema=self.dataset.schema)
			logger.info('Loaded table "%s" into database', table)
			df.to_csv(export_file_path, index=False)
			logger.info('Wrote table "%s" to %s', table, export_file_path)



def main(ust_or_release, control_id, all_tables=True, tables_to_exclude=None, empty_export_dir=True, export_file_dir=None):
	dataset = Dataset(ust_or_release=ust_or_release,
				 	  control_id=control_id, 
				 	  requires_export=False)

	source_data = SourceData(dataset=dataset,
							all_tables=all_tables,
							tables_to_exclude=tables_to_exclude,
							empty_export_dir=empty_export_dir,
							export_file_dir=export_file_dir)


if __name__ == '__main__':   
	main(ust_or_release=ust_or_release,
		 control_id=control_id, 
		 all_tables=all_tables, 
		 tables_to_exclude=tables_to_exclude,
		 empty_export_dir=empty_export_dir,
		 export_file_dir=export_file_dir)		