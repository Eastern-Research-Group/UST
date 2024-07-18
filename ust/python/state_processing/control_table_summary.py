import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))
from datetime import date
import ntpath

import openpyxl as op

from python.util.logger_factory import logger
from python.util import utils

ust_or_release = 'ust' # valid values are 'ust' or 'release'
control_id = 11
organization_id = None

export_file_path = None
export_file_dir = None
export_file_name = None


class Summary:
	wb = None     

	def __init__(self, 
				 ust_or_release,
				 organization_id=None,
				 control_id=None, 
				 export_file_name=None, 
				 export_file_dir=None,
				 export_file_path=None):
		self.ust_or_release = ust_or_release.lower()
		if self.ust_or_release not in ['ust','release']:
			logger.error("Unknown value '%s' for ust_or_release; valid values are 'ust' and 'release'. Exiting...", ust_or_release)
			exit()
		self.organization_id = organization_id
		self.control_id = control_id
		self.export_file_name = export_file_name
		self.export_file_dir = export_file_dir
		self.export_file_path = export_file_path
		self.populate_org_control()
		self.populate_export_vars()
		self.wb = op.Workbook()
		self.wb.save(self.export_file_path)
		self.export_summary()
		self.cleanup_wb()
		logger.info('Summary exported to %s', self.export_file_path)


	def print_self(self):
		print('ust_or_release = ' + str(self.ust_or_release))
		print('organization_id = ' + str(self.organization_id))
		print('control_id = ' + str(self.control_id))
		print('export_file_name = ' + str(self.export_file_name))
		print('export_file_dir = ' + str(self.export_file_dir))
		print('export_file_path = ' + str(self.export_file_path))


	def populate_org_control(self):
		self.print_self()
		conn = utils.connect_db()
		cur = conn.cursor()	
		if not self.organization_id and not self.control_id:
			logger.error("Either organization_id or control_id must be passed. Exiting...")
			exit()
		elif not self.control_id:
			sql = f"select max({self.ust_or_release}_control_id) from {self.ust_or_release}_control where organization_id = %s"
			cur.execute(sql, (self.organization_id,))
			self.control_id = cur.fetchone()[0]
		else:
			sql = f"select organization_id from {self.ust_or_release}_control where {self.ust_or_release}_control_id = %s"
			cur.execute(sql, (self.control_id,))
			org_id = cur.fetchone()[0]
			if self.organization_id and org_id != self.organization_id:
				logger.warning('%s_control_id %s is %s, but %s was passed. Exiting.', self.ust_or_release, self.control_id, org_id, self.organization_id)
				exit()
			self.organization_id = org_id
		cur.close()
		conn.close()
		logger.debug('control_id = %s, organization_id = %s', self.control_id, self.organization_id)


	def populate_export_vars(self):
		if not self.export_file_path and not self.export_file_path and not self.export_file_name:
			if self.ust_or_release == 'ust':
				uor = 'UST'
			elif self.ust_or_release == 'release':
				uor = 'Releases'
			self.export_file_name = self.organization_id.upper() + '_' + uor + '_control_summary_' + utils.get_timestamp_str() + '.xlsx'
			self.export_file_dir = '../exports/control_table_summaries/' + self.organization_id.upper() + '/'
			self.export_file_path = self.export_file_dir + self.export_file_name
			Path(self.export_file_dir).mkdir(parents=True, exist_ok=True)
		elif self.export_file_path:
			fp = ntpath.split(self.export_file_path)
			self.export_file_dir = fp[0]
			self.export_file_name = fp[1]
		elif self.export_file_dir and self.export_file_name:
			if self.export_file_name[-5:] != '.xlsx':
				self.export_file_name = self.export_file_name + '.xlsx'
			self.export_file_path = os.path.join(self.export_file_dir, self.export_file_name)
		logger.debug('export_file_name = %s; export_file_dir = %s; export_file_path = %s', self.export_file_name, self.export_file_dir, self.export_file_path)


	def cleanup_wb(self):
		try:
			self.wb.remove(self.wb['Sheet'])
		except:
			pass
		self.wb.save(self.export_file_path)


	def export_summary(self):
		ws = self.wb.create_sheet(self.organization_id.upper() + ' ' + self.ust_or_release.upper() + ' Summary')

		conn = utils.connect_db()
		cur = conn.cursor()
 
		sql = f"""select summary_item, summary_detail 
				from public.v_{self.ust_or_release}_control_summary
				where {self.ust_or_release}_control_id = %s
				order by sort_order"""
		cur.execute(sql, (self.control_id,))
		data = cur.fetchall()
		for rowno, row in enumerate(data, start=1):
			for colno, cell_value in enumerate(row, start=1):
				ws.cell(row=rowno, column=colno).value = cell_value

		utils.autowidth(ws)

		cur.close()
		conn.close()

		logger.info('Exported %s_control_table summary for control_id %s to %s', self.ust_or_release, self.control_id, self.export_file_path)



def main(ust_or_release, organization_id=None, control_id=None, export_file_name=None, export_file_dir=None, export_file_path=None):
	template = Summary(ust_or_release=ust_or_release,
					    organization_id=organization_id, 
						control_id=control_id,
						export_file_name=export_file_name,
						export_file_dir=export_file_dir,
						export_file_path=export_file_path)


if __name__ == '__main__':   
	main(ust_or_release=ust_or_release,
		 organization_id=organization_id, 
		 control_id=control_id, 
		 export_file_name=export_file_name,
		 export_file_dir=export_file_dir,
		 export_file_path=export_file_path)
