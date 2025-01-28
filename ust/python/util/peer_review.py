from datetime import datetime
import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

from python.util import utils
from python.util.dataset import Dataset 
from python.util.logger_factory import logger


ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = 0 	           		# Enter an integer that is the ust_control_id or release_control_id
organization_id = 'UT'          # Optional; if control_id = 0 or None, will find the most recent control_id



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


	def __init__(self, 
				 dataset):
		self.dataset = dataset
		self.connect_db()
		self.set_views()
		self.set_tables()
		if not self.views_to_review:
			logger.warning('No %s template views found in schema %s; exiting.', self.dataset.ust_or_release, self.dataset.schema)
			logger.info('Views this script looks for: %s', self.get_view_names())
			self.disconnect_db()
			exit()
		self.compare_row_counts()

		self.disconnect_db()


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
				logger.info('Row counts match between %s.%s and public.%s: (%s)', {self.dataset.schema}, view, view.replace('v_',''), table_rows)
			else:
				logger.warning('Mismatch of row counts between  %s.%s (%s) and public.%s (%s)!!!',  {self.dataset.schema}, view, view_rows, view.replace('v_',''), table_rows)


	def set_table_counts(self):
		for view in self.views_to_review:
			sql = f"select count(*) from public.{view} where {self.dataset.ust_or_release}_control_id = %s"
			utils.process_sql(self.conn, self.cur, sql)
			num_rows = self.cur.fetchone()[0]
			self.view_counts[view_name] = num_rows			



def main(ust_or_release, control_id=None, organization_id=None):
	if not control_id and not organization_id:
		logger.error('Please pass either control_id or organization_id')
		exit()
	elif not control_id:
		control_id = utils.get_control_id(ust_or_release, organization_id)

	dataset = Dataset(ust_or_release=ust_or_release, control_id=control_id)
	review = PeerReview(dataset=dataset)


if __name__ == '__main__':   
	main(ust_or_release=ust_or_release,
		 control_id=control_id, 
		 organization_id=organization_id)
