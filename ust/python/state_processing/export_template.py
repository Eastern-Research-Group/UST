import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))
from datetime import date
import ntpath

import openpyxl as op
from openpyxl.styles import Alignment, Font, PatternFill
from openpyxl.styles.borders import Border, Side

from python.util.logger_factory import logger
from python.util import utils, config


ust_or_release = 'release' # valid values are 'ust' or 'release'
control_id = 2
organization_id = None
data_only = False
template_only = False
export_file_path = None
export_file_dir = None
export_file_name = None


gray_cell_fill = 'C9C9C9' # gray
green_cell_fill = '92D050' # green
yellow_cell_fill = 'FFFF00' # yellow
orange_cell_fill = 'FFC000' # orange
thin_border = Border(left=Side(style='thin'), 
					 right=Side(style='thin'), 
					 top=Side(style='thin'), 
					 bottom=Side(style='thin'))
left_align = Alignment(horizontal='left', vertical='center', wrap_text=True)
center_align = Alignment(horizontal='center', vertical='center', wrap_text=True)


class Template:
	wb = None     

	def __init__(self, 
				 ust_or_release,
				 organization_id=None,
				 control_id=None, 
				 export_file_name=None, 
				 export_file_dir=None,
				 export_file_path=None,
				 data_only=False,
				 template_only=False):
		self.ust_or_release = ust_or_release.lower()
		if self.ust_or_release not in ['ust','release']:
			logger.error("Unknown value '%s' for ust_or_release; valid values are 'ust' and 'release'. Exiting...", ust_or_release)
			exit()
		self.organization_id = organization_id
		self.control_id = control_id
		self.export_file_name = export_file_name
		self.export_file_dir = export_file_dir
		self.export_file_path = export_file_path
		self.data_only = data_only		
		self.template_only = template_only
		self.populate_org_control()
		self.populate_export_vars()
		self.wb = op.Workbook()
		self.wb.save(self.export_file_path)
		if not self.data_only:
			self.make_reference_tab()
			self.make_lookup_tabs()
			if not self.template_only:
				self.make_mapping_tabs()
		self.make_data_tabs()	
		self.cleanup_wb()
		logger.info('Template exported to %s', self.export_file_path)


	def print_self(self):
		print('ust_or_release = ' + str(self.ust_or_release))
		print('organization_id = ' + str(self.organization_id))
		print('control_id = ' + str(self.control_id))
		print('export_file_name = ' + str(self.export_file_name))
		print('export_file_dir = ' + str(self.export_file_dir))
		print('export_file_path = ' + str(self.export_file_path))
		print('data_only = ' + str(self.data_only))
		print('template_only = ' + str(self.template_only))


	def populate_org_control(self):
		self.print_self()
		conn = utils.connect_db()
		cur = conn.cursor()	
		if self.template_only and not self.organization_id and not self.control_id and not self.export_file_path and not self.export_file_dir and not self.export_file_name:
			logger.error('If you want to export a template only and are not passing an organization_id or control_id, you must pass export_file_name and export_file_dir OR export_file_path. Exiting...')
			exit()
		elif self.template_only and not (self.export_file_path or (self.export_file_dir and self.export_file_name)) and (self.organization_id or self.control_id):
			logger.warning("You requested a template only but didn't pass an export path or directory/file name. The file name and path will be constructed from the organization_id/control_id passed (%s/%s)", self.organization_id, self.control_id)
		elif self.template_only and (self.export_file_path or self.export_file_dir or self.export_file_name):
			if self.export_file_path or (self.export_file_dir and self.export_file_name):
				pass 
			else:  
				logger.error("If you want a template only but don't pass a full path to export_file_path, you must pass both export_file_dir AND export_file_name. Exiting...")
				exit()
		elif not self.organization_id and not self.control_id:
			logger.error("If you don't want a template only, either organization_id or control_id must be passed. Exiting...")
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
			self.export_file_name = self.organization_id.upper() + '_UST_template_' + utils.get_timestamp_str() + '.xlsx'
			self.export_file_dir = '../exports/epa_templates/' + self.organization_id.upper() + '/'
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


	def make_reference_tab(self):
		ws = self.wb.create_sheet('Reference')

		headers = utils.get_headers(f'v_{self.ust_or_release}_elements')
		for colno, header in enumerate(headers, start=1):
			ws.cell(row=1, column=colno).value = header
		conn = utils.connect_db()
		cur = conn.cursor()
		sql = f"select * from public.v_{self.ust_or_release}_elements"	
		cur.execute(sql)
		data = cur.fetchall()
		for rowno, row in enumerate(data, start=2):
			for colno, cell_value in enumerate(row, start=1):
				if (colno == 8 or colno == 7) and cell_value:
					cell_value = cell_value.replace('"','')
				ws.cell(row=rowno, column=colno).value = cell_value
		cur.close()
		conn.close()

		if ust_or_release == 'ust':
			for row in ws[1:ws.max_row]:  
				cell = row[0]            
				cell.alignment = left_align
				cell.border = thin_border
				cell = row[1]            
				cell.alignment = left_align
				cell.border = thin_border
				cell.font = Font(bold=True)
				cell = row[2]            
				cell.alignment = left_align
				cell.border = thin_border
				cell = row[3]            
				cell.alignment = center_align
				cell.border = thin_border
				cell = row[4]            
				cell.alignment = center_align
				cell.border = thin_border
				cell = row[5]            
				cell.alignment = center_align
				cell.border = thin_border
				cell = row[6]            
				cell.alignment = center_align
				cell.border = thin_border
				cell = row[7]            
				cell.alignment = left_align
				cell.border = thin_border
				cell = row[8]            
				cell.alignment = left_align
				cell.border = thin_border
			header_range = ws["A1:I1"]
			for row in header_range:
				for cell in row:
					cell.fill = utils.get_fill_gen(gray_cell_fill)
					cell.alignment = center_align
					cell.font = Font(bold=True)
			element_name_range = ws["B2:B200"]
			green_cells = ['FacilityID','TankID','CompartmentID','PipingID']
			for row in element_name_range:
			    for cell in row:
			        if cell.value in green_cells:
			        	cell.fill = utils.get_fill_gen(green_cell_fill)
			        	if cell.value != 'FacilityID':
				        	cell.offset(row=0, column=1).fill = utils.get_fill_gen(yellow_cell_fill)
			ws.column_dimensions['A'].width = 14
			ws.column_dimensions['B'].width = 69
			ws.column_dimensions['B'].font = Font(bold=True)
			ws.column_dimensions['C'].width = 30
			ws.column_dimensions['D'].width = 15
			ws.column_dimensions['E'].width = 8
			ws.column_dimensions['F'].width = 13
			ws.column_dimensions['G'].width = 13
			ws.column_dimensions['H'].width = 32
			ws.column_dimensions['I'].width = 70
		elif ust_or_release == 'release':
			for row in ws[1:ws.max_row]:  
				cell = row[0]            
				cell.alignment = left_align
				cell.border = thin_border
				cell.font = Font(bold=True)
				cell = row[1]            
				cell.alignment = left_align
				cell.border = thin_border
				cell = row[2]            
				cell.alignment = left_align
				cell.border = thin_border
				cell = row[3]            
				cell.alignment = center_align
				cell.border = thin_border
				cell = row[4]            
				cell.alignment = center_align
				cell.border = thin_border
				cell = row[5]            
				cell.alignment = center_align
				cell.border = thin_border
				cell = row[6]            
				cell.alignment = left_align
				cell.border = thin_border
				cell = row[7]            
				cell.alignment = left_align
				cell.border = thin_border
			header_range = ws["A1:H1"]
			for row in header_range:
				for cell in row:
					cell.fill = utils.get_fill_gen(gray_cell_fill)
					cell.alignment = center_align
					cell.font = Font(bold=True)
			ws.column_dimensions['A'].width = 69
			ws.column_dimensions['A'].font = Font(bold=True)
			ws.column_dimensions['B'].width = 30
			ws.column_dimensions['C'].width = 15
			ws.column_dimensions['D'].width = 8
			ws.column_dimensions['E'].width = 13
			ws.column_dimensions['F'].width = 13
			ws.column_dimensions['G'].width = 32
			ws.column_dimensions['H'].width = 70

		ws.freeze_panes = ws['A2']
		self.wb.save(self.export_file_path)
		logger.info('Created Reference tab')


	def make_lookup_tabs(self):
		lookups = utils.get_lookup_tabs(ust_or_release=self.ust_or_release)
		for lookup in lookups:
			self.make_lookup_tab(lookup)
		self.wb.save(self.export_file_path)


	def make_lookup_tab(self, lookup):
		lookup_table_name = lookup[0]
		lookup_column_name = lookup[1]
		logger.info('Working on lookup table %s, column %s', lookup_table_name, lookup_column_name)
		if lookup_table_name == 'substances':
			ws = self.wb.create_sheet('Substances lookup')
			self.make_substance_lookup_tab(ws)
			logger.info('Created Substances lookup tab')
			return

		if lookup_table_name == 'corrective_action_strategies':
			pretty_name = 'Corrective Actions'
		else:
			pretty_name = lookup_table_name.replace('_',' ').title()
		ws = self.wb.create_sheet(pretty_name + ' lookup')
		
		conn = utils.connect_db()
		cur = conn.cursor()	

		sql = f"select {lookup_column_name} from {lookup_table_name} order by 1"
		cur.execute(sql)
		data = cur.fetchall()
		for rowno, row in enumerate(data, start=2):
			for colno, cell_value in enumerate(row, start=1):
				ws.cell(row=rowno, column=colno).value = cell_value.replace('"','')
		cell = ws.cell(row=1, column=1)
		cell.value = pretty_name
		cell.font = Font(bold=True)
		utils.autowidth(ws)

		cur.close()
		conn.close()
		logger.info('Created %s lookup tab', pretty_name)


	def make_substance_lookup_tab(self, ws):
		cell = ws.cell(row=1, column=1)
		cell.value = 'Substance Group'
		cell.font = Font(bold=True)
		cell.alignment = center_align

		cell = ws.cell(row=1, column=2)
		cell.value = 'Substance'
		cell.font = Font(bold=True)
		cell.alignment = center_align

		conn = utils.connect_db()
		cur = conn.cursor()	

		sql = f"select substance_group, substance from substances order by 1, 2"
		cur.execute(sql)
		data = cur.fetchall()
		for rowno, row in enumerate(data, start=2):
			for colno, cell_value in enumerate(row, start=1):
				cell = ws.cell(row=rowno, column=colno)
				cell.value = cell_value.replace('"','')
		utils.autowidth(ws)


	def get_mapping_tabs(self):
		conn = utils.connect_db()
		cur = conn.cursor()	
		sql = f"""select epa_table_name, epa_column_name, database_lookup_table, database_lookup_column   
				from v_{self.ust_or_release}_available_mapping
				where {self.ust_or_release}_control_id = %s order by 1, 2"""
		cur.execute(sql, (self.control_id,))
		rows = cur.fetchall()
		cur.close()
		conn.close()
		return rows


	def make_mapping_tabs(self):
		mappings = self.get_mapping_tabs()
		for mapping in mappings:
			self.make_mapping_tab(mapping)
		self.wb.save(self.export_file_path)


	def make_mapping_tab(self, mapping):
		mapping_table_name = mapping[0]
		mapping_column_name = mapping[1]
		database_lookup_table = mapping[2]
		database_lookup_column = mapping[3]
		logger.info('Working on mapping table %s, column %s using lookup table %s, column %s',
			 mapping_table_name, mapping_column_name, database_lookup_table, database_lookup_column)
		if database_lookup_table == 'substances':
			self.make_substance_mapping_tab()
			logger.info('Created Substances mapping tab')
			return
		pretty_name = database_lookup_table.replace('_',' ').title()
		ws = self.wb.create_sheet(pretty_name + ' mapping')

		cell = ws.cell(row=1, column=1)
		cell.value = pretty_name
		cell.font = Font(bold=True)

		conn = utils.connect_db()
		cur = conn.cursor()	

		sql = f"select {database_lookup_column} from {database_lookup_table} order by 1"
		cur.execute(sql)
		data = cur.fetchall()
		for rowno, row in enumerate(data, start=2):
			for colno, cell_value in enumerate(row, start=1):
				ws.cell(row=rowno, column=colno).value = cell_value.replace('"','')

		sql = f"""select distinct organization_value, epa_value, programmer_comments, epa_comments, organization_comments
				from public.v_{self.ust_or_release}_element_mapping 
				where {self.ust_or_release}_control_id = %s and epa_column_name = %s
				order by 1, 2"""
		cur.execute(sql, (self.control_id, mapping_column_name))

		if cur.rowcount > 0:
			cell = ws.cell(row=1, column=3)
			cell.value = 'Organization Value'
			cell.font = Font(bold=True)
			cell = ws.cell(row=1, column=4)
			cell.value = 'EPA Value'
			cell.font = Font(bold=True)
			cell = ws.cell(row=1, column=5)
			cell.value = 'Programmer Comments'
			cell.font = Font(bold=True)
			cell = ws.cell(row=1, column=6)
			cell.value = 'EPA Comments'
			cell.font = Font(bold=True)
			cell = ws.cell(row=1, column=7)
			cell.value = 'Organization Comments'
			cell.font = Font(bold=True)

			data = cur.fetchall()
			for rowno, row in enumerate(data, start=2):
				for colno, cell_value in enumerate(row, start=3):
					ws.cell(row=rowno, column=colno).value = cell_value		

		utils.autowidth(ws)

		cur.close()
		conn.close()

		logger.info('Created %s mapping tab', pretty_name)


	def make_substance_mapping_tab(self):
		ws = self.wb.create_sheet('Substances mapping')
		self.make_substance_lookup_tab(ws)

		conn = utils.connect_db()
		cur = conn.cursor()	
		sql = f"""select distinct organization_value, epa_value, programmer_comments, epa_comments, organization_comments
				from public.v_{self.ust_or_release}_element_mapping 
				where {self.ust_or_release}_control_id = %s and epa_column_name = 'substance'
				order by 1, 2"""
		cur.execute(sql, (self.control_id,))

		if cur.rowcount > 0:
			cell = ws.cell(row=1, column=5)
			cell.value = 'Organization Value'
			cell.font = Font(bold=True)
			cell = ws.cell(row=1, column=6)
			cell.value = 'EPA Value'
			cell.font = Font(bold=True)
			cell = ws.cell(row=1, column=7)
			cell.value = 'Programmer Comments'
			cell.font = Font(bold=True)
			cell = ws.cell(row=1, column=8)
			cell.value = 'EPA Comments'
			cell.font = Font(bold=True)
			cell = ws.cell(row=1, column=9)
			cell.value = 'Organization Comments'
			cell.font = Font(bold=True)
			data = cur.fetchall()
			for rowno, row in enumerate(data, start=2):
				for colno, cell_value in enumerate(row, start=5):
					ws.cell(row=rowno, column=colno).value = cell_value		

		utils.autowidth(ws)

		cur.close()
		conn.close()

		logger.info('Created Substances mapping tab')


	def make_data_tabs(self):
		tabs = utils.get_data_tabs(ust_or_release=self.ust_or_release)
		for tab in tabs:
			self.make_data_tab(tab)
		self.wb.save(self.export_file_path)


	def make_data_tab(self, tab):
		view_name = tab[0]
		tab_name = tab[1]
		ws = self.wb.create_sheet(tab_name)
		ws.title = tab_name
		headers = utils.get_headers(view_name)
		green_cells = []
		orange_cells = []
		if self.ust_or_release == 'ust':
			if tab_name == 'Facility':
				green_cells = ['FacilityID']
			elif tab_name == 'Tank':
				green_cells = ['TankID']
				orange_cells = ['FacilityID']
			elif tab_name == 'Compartment':
				green_cells = ['CompartmentID']
				orange_cells = ['FacilityID','TankID','TankName']
			elif tab_name == 'Piping':
				green_cells = ['PipingID']
				orange_cells = ['FacilityID','TankID','TankName','CompartmentID','CompartmentName']
		for colno, header in enumerate(headers, start=1):
			cell = ws.cell(row=1, column=colno)
			cell.value = header
			cell.font = Font(bold=True)
			if cell.value in green_cells:
				cell.fill = utils.get_fill_gen(green_cell_fill)
			if cell.value in orange_cells:
				cell.fill = utils.get_fill_gen(orange_cell_fill)
		utils.autowidth(ws)
		if not self.template_only:
			conn = utils.connect_db()
			cur = conn.cursor()
			sql = f"select * from public.{view_name} where {self.ust_or_release}_control_id = %s"
			cur.execute(sql, (self.control_id,))
			data = cur.fetchall()
			for rowno, row in enumerate(data, start=2):
				for colno, cell_value in enumerate(row, start=1):
					ws.cell(row=rowno, column=colno).value = cell_value
			cur.close()
			conn.close()
		ws.delete_cols(1)
		ws.freeze_panes = ws['A2']
		logger.info('Created %s tab', tab_name)



def main(ust_or_release, organization_id=None, control_id=None, data_only=False, template_only=False, export_file_name=None, export_file_dir=None, export_file_path=None):
	template = Template(ust_or_release=ust_or_release,
					    organization_id=organization_id, 
						control_id=control_id,
						data_only=data_only,
						template_only=template_only,
						export_file_name=export_file_name,
						export_file_dir=export_file_dir,
						export_file_path=export_file_path)


if __name__ == '__main__':   
	main(ust_or_release=ust_or_release,
		 organization_id=organization_id, 
		 control_id=control_id, 
		 data_only=data_only, 
		 template_only=template_only,
						export_file_name=export_file_name,
						export_file_dir=export_file_dir,
						export_file_path=export_file_path)
