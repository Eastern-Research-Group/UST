from datetime import datetime
import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import pandas as pd

from python.util import utils
from python.util.logger_factory import logger


query = """select distinct a."FacilityID", "FacilityName", "FacilityType1", "TankID", "TankStatus",
	case when b."FacilityID" is null then 'Yes' else 'No' end as "Orphaned Tank"
from hi_ust.tank a left join hi_ust.facility b on a."FacilityID" = b."FacilityID" 
where "FederallyRegulated" = True 
order by 1, 3;""" 		# Text of query to be exported, Parameters are not accepted. 
export_file_name = 'hi_ust_federally_regulated_tanks.xlsx'		# Optional. If None, file name will be 'query_output_YYYY-MM-DD.xlsx'


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