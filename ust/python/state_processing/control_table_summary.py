import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))
from datetime import date
import ntpath

import openpyxl as op
from openpyxl.styles import Alignment, Font

from python.util.logger_factory import logger
from python.util import utils

ust_or_release = 'release' # valid values are 'ust' or 'release'
control_id = 7
organization_id = None

export_file_path = None
export_file_dir = None
export_file_name = None


yellow_cell_fill = 'FFFF00' # yellow

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
		self.export_row_counts()
		self.performance_measure_comparison()
		self.mapped_element_summary()
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
			self.export_file_name = self.organization_id.upper() + '_' + utils.get_pretty_ust_or_release(self.ust_or_release) + '_control_summary_' + utils.get_timestamp_str() + '.xlsx'
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
		ws = self.wb.create_sheet(self.organization_id.upper() + ' ' + utils.get_pretty_ust_or_release(self.ust_or_release) + ' Summary')
		conn = utils.connect_db()
		cur = conn.cursor() 
		sql = f"""select summary_item, summary_detail 
				from public.v_{self.ust_or_release}_control_summary
				where {self.ust_or_release}_control_id = %s
				order by sort_order"""
		cur.execute(sql, (self.control_id,))
		data = cur.fetchall()
		cur.close()
		conn.close()
		for rowno, row in enumerate(data, start=1):
			for colno, cell_value in enumerate(row, start=1):
				ws.cell(row=rowno, column=colno).value = cell_value
				if colno == 2 and ws.cell(row=rowno, column=colno-1).value == 'organization_compartment_flag' and ws.cell(row=rowno, column=colno).value == None:
					 ws.cell(row=rowno, column=colno).fill = utils.get_fill_gen(yellow_cell_fill)
		utils.autowidth(ws)
		logger.info('Exported %s_control_table summary for control_id %s to %s', self.ust_or_release, self.control_id, self.export_file_path)


	def export_row_counts(self):
		ws = self.wb.create_sheet(self.organization_id.upper() + ' ' + utils.get_pretty_ust_or_release(self.ust_or_release) + ' Row Count')
		headers = ['Table Name', 'Number of Rows']
		for colno, header in enumerate(headers, start=1):
			ws.cell(row=1, column=colno).value = header
		header_range = ws["A1:Z1"]
		for row in header_range:
			for cell in row:
				cell.font = Font(bold=True)

		conn = utils.connect_db()
		cur = conn.cursor() 
		sql = f"""select table_name, num_rows 
				from public.v_{self.ust_or_release}_row_count_summary
				where {self.ust_or_release}_control_id = %s
				order by sort_order"""
		cur.execute(sql, (self.control_id,))
		data = cur.fetchall()
		cur.close()
		conn.close()
		for rowno, row in enumerate(data, start=2):
			for colno, cell_value in enumerate(row, start=1):
				ws.cell(row=rowno, column=colno).value = cell_value
				if colno == 2:
					ws.cell(row=rowno, column=colno).number_format = '#,##0'
		utils.autowidth(ws)
		logger.info('Exported table row counts for control_id %s to %s', self.control_id, self.export_file_path)


	def performance_measure_comparison(self):
		ws = self.wb.create_sheet('Performance Measure Comparison')
		conn = utils.connect_db()
		cur = conn.cursor() 
		
		if self.ust_or_release == 'ust':
			headers = ['Performance Measure', 'Total UST']
			for colno, header in enumerate(headers, start=1):
				ws.cell(row=1, column=colno).value = header
			header_range = ws["A1:Z1"]
			for row in header_range:
				for cell in row:
					cell.font = Font(bold=True)

			sql = """select total_type, total_ust
					from public.v_ust_performance_measures
					where organization_id = %s
					order by sort_order"""
			cur.execute(sql, (self.organization_id,))
			data = cur.fetchall()
			for rowno, row in enumerate(data, start=2):
				for colno, cell_value in enumerate(row, start=1):
					ws.cell(row=rowno, column=colno).value = cell_value
					if colno == 2:
						ws.cell(row=rowno, column=colno).number_format = '#,##0'
			ws.cell(row=rowno, column=1).font = Font(bold=True)			
			ws.cell(row=rowno, column=2).font = Font(bold=True)		

			rowno = rowno + 2			
			ws.cell(row=rowno, column=1).value = 'EPA Template'		
			ws.cell(row=rowno, column=1).font = Font(bold=True, underline='single')

			rowno = rowno + 1
			ws.cell(row=rowno, column=1).value = 'EPA Compartment Status'		
			ws.cell(row=rowno, column=1).font = Font(bold=True)
			ws.cell(row=rowno, column=2).value = 'Total UST'		
			ws.cell(row=rowno, column=2).font = Font(bold=True)

			sql = """select "CompartmentStatus", count(*) from public.v_ust_compartment
					where public.ust_control_id = %s group by "CompartmentStatus" """
			cur.execute(sql, (self.control_id,))
			data = cur.fetchall()
			for rowno, row in enumerate(data, start=rowno+1):
				for colno, cell_value in enumerate(row, start=1):
					ws.cell(row=rowno, column=colno).value = cell_value
					if colno == 2:
						ws.cell(row=rowno, column=colno).number_format = '#,##0'

			rowno = rowno + 1
			sql = "select count(*) from public.v_ust_compartment where public.ust_control_id = %s" 
			cur.execute(sql, (self.control_id,))
			cnt = cur.fetchone()[0]
			ws.cell(row=rowno, column=1).value = 'Total UST EPA Template'
			ws.cell(row=rowno, column=1).font = Font(bold=True)
			ws.cell(row=rowno, column=2).value = cnt 
			ws.cell(row=rowno, column=2).font = Font(bold=True)
			ws.cell(row=rowno, column=2).number_format = '#,##0'

		else: # release
			headers = ['Performance Measure', 'Total Releases']
			for colno, header in enumerate(headers, start=1):
				ws.cell(row=1, column=colno).value = header
			header_range = ws["A1:Z1"]
			for row in header_range:
				for cell in row:
					cell.font = Font(bold=True)

			sql = f"""select total_type, total_cumulative_releases
					from public.v_release_performance_measures
					where organization_id = %s
					order by sort_order"""
			cur.execute(sql, (self.organization_id,))
			data = cur.fetchall()
			for rowno, row in enumerate(data, start=2):
				for colno, cell_value in enumerate(row, start=1):
					ws.cell(row=rowno, column=colno).value = cell_value
					if colno == 2:
						ws.cell(row=rowno, column=colno).number_format = '#,##0'
			ws.cell(row=rowno, column=1).font = Font(bold=True)			
			ws.cell(row=rowno, column=2).font = Font(bold=True)		

			rowno = rowno + 2
			ws.cell(row=rowno, column=1).value = 'EPA Template'		
			ws.cell(row=rowno, column=1).font = Font(bold=True, underline='single')

			rowno = rowno + 1
			ws.cell(row=rowno, column=1).value = 'Release Status'		
			ws.cell(row=rowno, column=1).font = Font(bold=True)
			ws.cell(row=rowno, column=2).value = 'Total Releases'		
			ws.cell(row=rowno, column=2).font = Font(bold=True)
			sql = f"""select "USTReleaseStatus", count(*) from public.v_ust_release
					where release_control_id = %s group by "USTReleaseStatus" """
			cur.execute(sql, (self.control_id,))
			data = cur.fetchall()
			for rowno, row in enumerate(data, start=rowno+1):
				for colno, cell_value in enumerate(row, start=1):
					ws.cell(row=rowno, column=colno).value = cell_value
					if colno == 2:
						ws.cell(row=rowno, column=colno).number_format = '#,##0'	

			rowno = rowno + 1			
			sql = "select count(*) from public.v_ust_release where release_control_id = %s" 
			cur.execute(sql, (self.control_id,))
			cnt = cur.fetchone()[0]
			ws.cell(row=rowno, column=1).value = 'Total Releases EPA Template'
			ws.cell(row=rowno, column=1).font = Font(bold=True)
			ws.cell(row=rowno, column=2).value = cnt 
			ws.cell(row=rowno, column=2).font = Font(bold=True)
			ws.cell(row=rowno, column=2).number_format = '#,##0'

		cur.close()
		conn.close()
		
		utils.autowidth(ws)
		logger.info('Exported performance measure summary information for control_id %s to %s', self.control_id, self.export_file_path)


	def mapped_element_summary(self):
		ws = self.wb.create_sheet('Mapped Element Summary')
		conn = utils.connect_db()
		cur = conn.cursor() 

		rowno = 1 
		ws.cell(row=rowno, column=1).value = 'Mapped Data Elements'
		ws.cell(row=rowno, column=1).font = Font(bold=True, underline='single')
		ws.cell(row=rowno, column=4).value = 'Unmapped Data Elements'
		ws.cell(row=rowno, column=4).font = Font(bold=True, underline='single')
		
		rowno = 2
		ws.cell(row=rowno, column=1).value = 'Table Name'
		ws.cell(row=rowno, column=1).font = Font(bold=True)
		ws.cell(row=rowno, column=2).value = 'Column Name'
		ws.cell(row=rowno, column=2).font = Font(bold=True)

		ws.cell(row=rowno, column=4).value = 'Table Name'
		ws.cell(row=rowno, column=4).font = Font(bold=True)
		ws.cell(row=rowno, column=5).value = 'Column Name'
		ws.cell(row=rowno, column=5).font = Font(bold=True)

		start = 3
		sql = f"""select table_name, element_name 
				from public.v_{self.ust_or_release}_element_mapping_for_export
				where {self.ust_or_release}_control_id = %s
				order by table_sort_order, column_sort_order"""
		cur.execute(sql, (self.control_id,))
		data = cur.fetchall()
		for rowno, row in enumerate(data, start=start):
			for colno, cell_value in enumerate(row, start=1):
				ws.cell(row=rowno, column=colno).value = cell_value

		start = 3
		sql = f"""select template_tab_name, element_name from
					(select template_tab_name, element_name, d.sort_order as table_sort_order, c.sort_order as column_sort_order
					from public.{self.ust_or_release}_elements a join public.{self.ust_or_release}_elements_tables b on a.element_id = b.element_id 
						join {self.ust_or_release}_elements_tables c on b.element_id = c.element_id and c.table_name = b.table_name
						join {self.ust_or_release}_template_data_tables d on b.table_name = d.table_name
					where not exists 
						(select 1 from public.v_{self.ust_or_release}_element_mapping_for_export x 
						where x.{self.ust_or_release}_control_id = %s
						and b.table_name = x.epa_table_name and a.database_column_name = x.epa_column_name)) a
				where not (template_tab_name in ('Facility Dispenser','Tank Dispenser','Compartment Dispenser','Piping','Compartment Substance')
							and element_name in ('FacilityID','TankID','TankName','CompartmentID','CompartmentName'))
				and not (template_tab_name in ('Compartment','Tank Substance') and element_name in  ('FacilityID','TankID','TankName'))
				and not (template_tab_name = 'Tank' and element_name = 'FacilityID')
				and not (template_tab_name in ('Substance','Source','Cause','Corrective Action Strategy') and element_name = 'ReleaseID')
				and element_name not like '%%Comment'
				order by table_sort_order, column_sort_order"""
		cur.execute(sql, (self.control_id,))
		data = cur.fetchall()
		for rowno, row in enumerate(data, start=start):
			for colno, cell_value in enumerate(row, start=4):
				ws.cell(row=rowno, column=colno).value = cell_value

		cur.close()
		conn.close()				
		utils.autowidth(ws)
		logger.info('Exported mapped element summary for control_id %s to %s', self.control_id, self.export_file_path)



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
