from datetime import datetime
import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import pandas as pd

from python.util import utils
from python.util.logger_factory import logger


query = """select ust_element_value_mapping_id, 
ust_element_mapping_id, 
ust_control_id, 
organization_id, 
epa_table_name, 
epa_column_name, 
organization_value, 
epa_value, 
programmer_comments, 
epa_comments, 
organization_comments, 
exclude_from_query
from public.v_base_ust_element_value_mapping
order by organization_id, table_sort_order, column_sort_order, organization_value;""" 		# Text of query to be exported, Parameters are not accepted. 
export_file_name = 'ust_element_value_mapping.xlsx'		# Optional. If None, file name will be 'query_output_YYYY-MM-DD.xlsx'


class ExportQuery:
	def __init__(self, query, export_file_name=None):
		self.query = query
		if '.xlsx' in export_file_name:
			self.export_file_name = export_file_name
		elif not export_file_name:
			self.export_file_name = 'query_output_' + utils.get_today_string() + '.xlsx'
		else:
			self.export_file_name = export_file_name + '.xlsx'
		self.export_dir = '../../python/exports/other/'
		os.makedirs(self.export_dir, exist_ok=True)
		self.export_file_path = self.export_dir + self.export_file_name
		self.export()


	def export(self):
		df = pd.read_sql(self.query, con=utils.get_engine())
		with pd.ExcelWriter(self.export_file_path, engine='openpyxl') as writer:
			df.to_excel(writer, index=False, freeze_panes=(1,0), sheet_name='Sheet1')	
			wb = writer.book
			ws = writer.sheets['Sheet1']
		utils.autowidth(ws)
		logger.info('Wrote %s rows to %s', len(df), self.export_file_path)



def main(query, export_file_name=None):
	e = ExportQuery(query=query, export_file_name=export_file_name)


if __name__ == '__main__':   
	main(query=query, export_file_name=export_file_name)		