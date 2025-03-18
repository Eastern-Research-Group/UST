from datetime import datetime
import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import pandas as pd

from python.util import utils
from python.util.dataset import Dataset 
from python.util.logger_factory import logger


ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = 0 	           		# Enter an integer that is the ust_control_id or release_control_id
organization_id = ''            # Optional; if control_id = 0 or None, will find the most recent control_id
display_bad_data = False  		# Boolean; defaults to False. Set to True to print bad data to the console (note: if there are a lot of rows, this may be very slow).
overwrite_existing = False      # Boolean, defaults to False. Set to True to overwrite existing generated SQL file. If False, will append an existing file.


# These variables can usually be left unset. This script will generate an Excel file in the appropriate state folder in the repo under /ust/sql/states.
# This file directory and its contents are excluded from pushes to the repo by .gitignore.
export_file_path = None
export_file_dir = None
export_file_name = None


class PeerReview:
	conn = None 
	cur = None 
	views_to_review = []
	tables_to_review = []
	view_name = None 
	table_name = None 
	view_col_str = None 
	error_dict = {}
	error_cnt_dict = {}
	error_tables = []
	vsql = '------------------------------------------------------------------------------------------------------------------------\n'


	def __init__(self, 
				 dataset,
				 display_bad_data=False,
				 overwrite_existing=False):
		self.dataset = dataset
		self.display_bad_data = display_bad_data
		self.overwrite_existing = overwrite_existing
		self.connect_db()
		self.set_views()
		self.set_tables()
		if not self.views_to_review:
			logger.warning('No %s template views found in schema %s; exiting.', self.dataset.ust_or_release, self.dataset.schema)
			logger.info('Views this script looks for: %s', self.get_view_names())
			self.disconnect_db()
			exit()
		self.compare_row_counts()
		self.get_sql()
		self.disconnect_db()
		self.write_sql()

	def connect_db(self):
		self.conn = utils.connect_db()
		self.cur = self.conn.cursor()
		logger.info('Connected to database')
		

	def disconnect_db(self):
		self.cur.close()
		self.conn.close()
		logger.info('Disconnected from database')


	def get_view_names(self):
		sql = f"select view_name from public.{self.dataset.ust_or_release}_template_data_tables order by sort_order"
		utils.process_sql(self.conn, self.cur, sql)
		rows = self.cur.fetchall()
		views = [r[0] for r in rows]
		return views 


	def set_views(self):
		sql = f"""select a.table_name as view_name 
					from information_schema.tables a join public.{self.dataset.ust_or_release}_template_data_tables b on a.table_name = b.view_name 
					where a.table_schema = %s
					order by b.sort_order"""
		utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.schema,))
		rows = self.cur.fetchall()		
		self.views_to_review = [r[0] for r in rows]


	def set_tables(self):	
		self.tables_to_review = [t.replace('v_','') for t in self.views_to_review]
		logger.info("The following tables will be reviewed: %s", self.tables_to_review)


	def compare_row_counts(self):
		for view in self.views_to_review:
			sql = f"select count(*) from {self.dataset.schema}.{view}"
			utils.process_sql(self.conn, self.cur, sql)
			view_rows = self.cur.fetchone()[0]
			sql = f"select count(*) from public.{view} where {self.dataset.ust_or_release}_control_id = %s"
			utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id,))
			table_rows = self.cur.fetchone()[0]
			if view_rows == table_rows:
				logger.info('Row counts match between %s.%s and public.%s: (%s)', self.dataset.schema, view, view.replace('v_',''), table_rows)
			else:
				logger.warning('Mismatch of row counts between %s.%s (%s) and public.%s (%s)!!!', self.dataset.schema, view, view_rows, view.replace('v_',''), table_rows)
				self.error_tables.append(view)


	def set_table_counts(self):
		for view in self.views_to_review:
			sql = f"select count(*) from public.{view} where {self.dataset.ust_or_release}_control_id = %s"
			utils.process_sql(self.conn, self.cur, sql)
			num_rows = self.cur.fetchone()[0]
			self.view_counts[view_name] = num_rows			


	def get_sql(self):
		for view in self.error_tables:
			logger.info('Generating SQL for row differences between %s.%s and public.%s', self.dataset.schema, view, view)

			sql = f"""select a.column_name as org_view_col, b.element_name as epa_view_col
					from public.{self.dataset.ust_or_release}_view_key_columns a join public.v_{self.dataset.ust_or_release}_element_metadata b 
						on replace(a.view_name,'v_','') = b.table_name and a.column_name = b.column_name 
					where a.view_name = %s
					order by a.sort_order"""
			utils.process_sql(self.conn, self.cur, sql, params=(view,))
			rows = self.cur.fetchall()
			org_col_str = ''
			epa_col_str = ''
			sql = f"select * from {self.dataset.schema}.{view} a\nwhere not exists"
			if "substance" in view:
				if self.dataset.ust_or_release == 'ust':
					epacol = 'Substance'
				else:
					epacol = 'SubstanceReleased'
				sql = sql + f"""\n\t(select 1 from public.{view} b join public.substances c on b."{epacol}" = c.substance\n\twhere"""
			elif "cause" in view:
				sql = sql + f"""\n\t(select 1 from public.{view} b join public.causes c on b."CauseOfRelease" = c.cause\n\twhere"""
			elif "source" in view:
				sql = sql + f"""\n\t(select 1 from public.{view} b join public.sources c on b."SourceOfRelease" = c.source\n\twhere"""
			elif "corrective_action_strategy" in view:
				sql = sql + f"""\n\t(select 1 from public.{view} b join public.corrective_action_strategies c on b."CorrectiveActionStrategy" = c.corrective_action_strategy\n\twhere"""
			else:
				sql = sql + f"\n\t(select 1 from public.{view} b\n\twhere"
			for row in rows:	
				if row[0] in ['substance_id','cause_id','source_id','corrective_action_strategy_id']:
					sql = sql + ' a.' + row[0] + ' = c."' + row[0] + '" and'
				else:
					sql = sql + ' a.' + row[0] + ' = b."' + row[1] + '" and'
			sql = sql[:-4] + ')\norder by '
			for row in rows:
				sql = sql + 'a.' + row[0] + ','
			sql = sql[:-1] + ';'

			df = pd.read_sql(sql, con=utils.get_engine())
			if self.display_bad_data:
				utils.pretty_print_df(df)

			self.vsql = self.vsql + '\n\n\n/*********** ' + view + ' ***********/\n'
			self.vsql = self.vsql + f'--There are {len(df)} rows in {self.dataset.schema}.{view} that do not exist in public.{view}\n\n'
			self.vsql = self.vsql + sql + f'\n\n--View definition for {self.dataset.schema}.{view}:\n'

			sql = f"select get_view_def('{view}','{self.dataset.schema}')"
			utils.process_sql(self.conn, self.cur, sql)
			self.vsql = self.vsql + self.cur.fetchone()[0]


	def write_sql(self):
		wora = 'a'
		if self.overwrite_existing:
			wora = 'w'
		with open(self.dataset.export_file_path, wora, encoding='utf-8') as f:
			f.write(self.vsql)
		logger.info('SQL exported to %s', self.dataset.export_file_path)



def main(ust_or_release, control_id=None, organization_id=None, display_bad_data=False, overwrite_existing=False):
	if not control_id and not organization_id:
		logger.error('Please pass either control_id or organization_id')
		exit()
	elif not control_id:
		control_id = utils.get_control_id(ust_or_release, organization_id)

	dataset = Dataset(ust_or_release=ust_or_release,
				 	  control_id=control_id, 
				 	  base_file_name='peer_review.sql',
					  export_file_name=export_file_name,
					  export_file_dir=export_file_dir,
					  export_file_path=export_file_path)

	review = PeerReview(dataset=dataset, display_bad_data=display_bad_data, overwrite_existing=overwrite_existing)


if __name__ == '__main__':   
	main(ust_or_release=ust_or_release,
		 control_id=control_id, 
		 organization_id=organization_id,
		 display_bad_data=display_bad_data,
		 overwrite_existing=overwrite_existing)
