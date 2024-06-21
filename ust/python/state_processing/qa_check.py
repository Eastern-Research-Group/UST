import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))
from datetime import datetime

import psycopg2.errors
import openpyxl as op
from openpyxl.styles import Alignment, Font, PatternFill
from openpyxl.styles.borders import Border, Side

from python.util.logger_factory import logger
from python.util import utils


ust_or_release = 'release' # valid values are 'ust' or 'release'
control_id = 2
export_file_path = None
export_file_dir = None
export_file_name = None


# TODO: THIS HAS NOT BEEN TESTED FOR UST; ONLY RELEASES


def get_export_path(ust_or_release, organization_id, export_file_path=None, export_file_dir=None, export_file_name=None):
	if not export_file_path and not export_file_path and not export_file_name:
		export_file_name = organization_id.upper() + '_' + ust_or_release + '_QAQC_' + utils.get_timestamp_str() + '.xlsx'
		export_file_dir = '../exports/QAQC/' + organization_id.upper() + '/'
		export_file_path = export_file_dir + export_file_name
		Path(export_file_dir).mkdir(parents=True, exist_ok=True)
	elif export_file_path:
		fp = ntpath.split(export_file_path)
		export_file_dir = fp[0]
		export_file_name = fp[1]
	elif export_file_dir and export_file_name:
		if export_file_name[-5:] != '.xlsx':
			export_file_name = export_file_name + '.xlsx'
		export_file_path = os.path.join(export_file_dir, export_file_name)
	logger.debug('export_file_name = %s; export_file_dir = %s; export_file_path = %s', export_file_name, export_file_dir, export_file_path)
	return export_file_path


def main(ust_or_release, control_id, export_file_path=None, export_file_dir=None, export_file_name=None):
	ust_or_release = ust_or_release.lower()
	if ust_or_release not in ['ust','release']:
		logger.error('Unknown value %s for ust_or_release. Exiting...', ust_or_release)
	error_dict = {}

	conn = utils.connect_db()
	cur = conn.cursor()

	sql = f"select organization_id from public.{ust_or_release}_control where {ust_or_release}_control_id = %s"
	cur.execute(sql, (control_id,))
	organization_id = cur.fetchone()[0]
	if not organization_id:
		logger.error('No data from in public.%s_control where %s_control_id = %s. Exiting...', ust_or_release, ust_or_release, control_id)
		exit() 

	schema = utils.get_schema_from_control_id(control_id, ust_or_release)
	logger.debug('Schema = %s', schema)

	export_file_path = get_export_path(ust_or_release, organization_id, export_file_path, export_file_dir, export_file_name)
	wb = op.Workbook()	

	sql = f"""select a.table_name 
			from information_schema.tables a join public.{ust_or_release}_template_data_tables b on a.table_name = b.view_name 
			where a.table_schema = %s
			order by b.sort_order"""
	cur.execute(sql, (schema,))
	rows = cur.fetchall()
	for row in rows:
		view_name = row[0]
		sql2 = """select column_name
				from information_schema.columns 
				where table_schema = %s and table_name = %s
				order by ordinal_position"""
		cur.execute(sql2, (schema, view_name))
		rows2 = cur.fetchall()
		col_str = ''
		for row2 in rows2:
			col_str = col_str + row2[0] + ', '
		if col_str:
			col_str = col_str[:-2]

		# check for non-unique (repeating) rows:	
		sql2 = f"select {col_str}, count(*) from {schema}.{view_name} group by {col_str} having count(*) > 1 order by 1, 2"
		cur.execute(sql2)
		data = cur.fetchall()
		num_rows = cur.rowcount 
		error_dict['nonunique rows in ' + schema + '.' + view_name] = num_rows
		logger.info('Number of non-unique rows in %s.%s: %s', schema, view_name, num_rows)
		if data:
			ws = wb.create_sheet(view_name + ' nonunique')
			headers = utils.get_headers(view_name, schema)
			for colno, header in enumerate(headers, start=1):
				ws.cell(row=1, column=colno).value = header
			for rowno, row in enumerate(data, start=2):
				for colno, cell_value in enumerate(row, start=1):
					ws.cell(row=rowno, column=colno).value = cell_value

		# check for failed check constraints:
		table_name = view_name.replace('v_','')
		sql2 = """select cc.constraint_name, check_clause
					from information_schema.check_constraints cc 
						join pg_constraint cons on cc.constraint_name = cons.conname
						join pg_class t on cons.conrelid = t.oid 
					where constraint_schema = 'public' and t.relname = %s
					order by 1, 2"""
		cur.execute(sql2, (table_name,))
		rows2 = cur.fetchall()
		for row2 in rows2:
			constraint_name = row2[0]
			check_clause = row2[1]
			sql3 = f"select * from {schema}.{view_name} where not {check_clause}"
			try:
				cur.execute(sql3)
			except psycopg2.errors.UndefinedColumn:
				continue 
			data2 = cur.fetchall()
			num_rows = cur.rowcount 
			error_dict['failed check constraint ' + constraint_name] = num_rows
			logger.info('Number of failed rows for check constraint %s.%s: %s', table_name, constraint_name, num_rows)
			if data2:
				ws = wb.create_sheet(constraint_name)
				headers = utils.get_headers(view_name, schema)
				for colno, header in enumerate(headers, start=1):
					ws.cell(row=1, column=colno).value = header
				for rowno, row in enumerate(data2, start=2):
					for colno, cell_value in enumerate(row, start=1):
						ws.cell(row=rowno, column=colno).value = cell_value	
				utils.autowidth(ws)

		# check for bad mapping values:
		sql2 = f"""select distinct epa_column_name, epa_value, database_lookup_table, database_column_name 
				from public.v_{ust_or_release}_element_mapping a join public.{ust_or_release}_elements b on a.epa_column_name = b.database_column_name 
				where {ust_or_release}_control_id = %s and epa_table_name = %s and epa_value is not null
				order by 1, 2, 3"""
		cur.execute(sql2, (control_id, table_name))
		rows2 = cur.fetchall()
		for row2 in rows2:
			epa_column_name = row2[0]
			epa_value = row2[1]
			lookup_table = row2[2]
			lookup_column = row2[3].replace('_id','')
			sql3 = f"select count(*) from public.{lookup_table} where {lookup_column} = %s"
			cur.execute(sql3, (epa_value,))
			cnt = cur.fetchone()[0]
			if cnt < 1:
				error_dict['invalid EPA value in ' + epa_column_name] = epa_value 
				logger.info('Invalid EPA value for %s.%s: %s', table_name, epa_column_name, cnt)

	# Print an overview of QA/QC results
	view_counts = {}
	sql = f"select view_name from public.{ust_or_release}_template_data_tables order by sort_order"
	cur.execute(sql)
	rows = cur.fetchall()
	for row in rows:
		view_name = row[0]
		sql2 = f"select count(*) from {schema}.{view_name}"
		try:
			cur.execute(sql2)
		except psycopg2.errors.UndefinedTable:
			continue
		rows = cur.fetchone()
		num_rows = rows[0]
		view_counts[view_name] = num_rows

	ws = wb.create_sheet('Overview')
	rowno = 1
	ws.cell(row=rowno, column=1).value = 'View Name'
	ws.cell(row=rowno, column=2).value = 'Number of Rows'
	rowno +=1 
	for k, v in view_counts.items():
		print('Number of rows in ' + k + ' = ' + str(v))
		ws.cell(row=rowno, column=1).value = k
		ws.cell(row=rowno, column=2).value = v  
		rowno += 1
	rowno += 2
	ws.cell(row=rowno, column=1).value = 'QA Check'
	ws.cell(row=rowno, column=2).value = 'Number of Rows'
	rowno +=1 	
	for k, v in error_dict.items():
		print(k + ' = ' + str(v))
		ws.cell(row=rowno, column=1).value = k
		ws.cell(row=rowno, column=2).value = v  
		rowno += 1
	utils.autowidth(ws)

	cur.close()
	conn.close()

	try:
		wb.remove(wb['Sheet'])
	except:
		pass
	wb.save(export_file_path)



if __name__ == '__main__':
	main(ust_or_release, 
		control_id, 
		export_file_path=export_file_path, 
		export_file_dir=export_file_dir, 
		export_file_name=export_file_name)
	
