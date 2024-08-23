import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import openpyxl as op
from openpyxl.styles import Alignment, Font

from python.util.logger_factory import logger
from python.util import utils, config


ust_or_release = 'ust' # valid values are 'ust' or 'release'
control_id = 18


def build_ws(ust_or_release, control_id, ws, admin=False):
	logger.info('Working on Element Mapping tab')
	ust_or_release = ust_or_release.lower()
	ws.title = 'Element Mapping'

	if admin:
		headers = ['EPA Table Name','EPA Column Name', 'Organization Table Name', 'Organization Column Name',
				   'Element Mapping ID', 'Programmer Comments', 'EPA Comments', 'Organization Comments']		
	else:
		headers = ['Table Name', 'Element Name', 'Organization Table Name', 'Organization Column Name', 
		           'Programmer Comments', 'EPA Comments', 'Organization Comments']
	for colno, header in enumerate(headers, start=1):
		ws.cell(row=1, column=colno).value = header
	header_range = ws["A1:J1"]
	for row in header_range:
		for cell in row:
			cell.font = Font(bold=True)

	conn = utils.connect_db()
	cur = conn.cursor()
	
	if admin:
		cols = f'epa_table_name, epa_column_name, organization_table_name, organization_column_name, {ust_or_release}_element_mapping_id, programmer_comments, epa_comments, organization_comments'
	else:
		cols = 'table_name, element_name, organization_table_name, organization_column_name, programmer_comments, epa_comments, organization_comments'
	sql = f"""select {cols}
			from v_{ust_or_release}_element_mapping_for_export
			where {ust_or_release}_control_id = %s
			order by table_sort_order, column_sort_order"""
	cur.execute(sql, (control_id,))
	data = cur.fetchall()
	cur.close()
	conn.close()
	
	for rowno, row in enumerate(data, start=2):
		for colno, cell_value in enumerate(row, start=1):
			ws.cell(row=rowno, column=colno).value = cell_value
	utils.autowidth(ws)

	logger.info('Finshed Element Mapping tab')
	return ws


def main(ust_or_release, control_id, wb=None):
	if not wb:
		organization_id = utils.get_org_from_control_id(control_id, ust_or_release)
		if ust_or_release == 'ust':
			uor = 'UST'
		elif ust_or_release == 'release':
			uor = 'Releases'	
		export_file_name = organization_id + '_' + uor + '_Element_Mapping_' + utils.get_timestamp_str() + '.xlsx'
		export_file_dir = '../exports/mapping/' + organization_id + '/'
		export_file_path = export_file_dir + export_file_name
		Path(export_file_dir).mkdir(parents=True, exist_ok=True)
		wb = op.Workbook()
		wb.save(export_file_path)
	ws = wb.create_sheet()
	ws = build_ws(ust_or_release, control_id, ws)
	wb.remove(wb['Sheet'])
	wb.save(export_file_path)



if __name__ == '__main__':   
	main(ust_or_release, control_id)