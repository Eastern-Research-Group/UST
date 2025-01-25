from datetime import datetime
import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import openpyxl as op
from openpyxl.styles import Alignment, Font, PatternFill
from openpyxl.styles.borders import Border, Side
import psycopg2.errors

from python.state_processing import element_mapping_to_excel
from python.util import utils
from python.util.dataset import Dataset 
from python.util.logger_factory import logger


ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = 0              	# Enter an integer that is the ust_control_id or release_control_id

# These variables can usually be left unset. This script will general an Excel spreadsheet in the appropriate state folder in the repo under /ust/python/exports/QAQC
# This file directory and its contents are excluded from pushes to the repo by .gitignore.
export_file_path = None
export_file_dir = None
export_file_name = None

join_cols = {}
join_cols['v_ust_facility'] = []
join_cols['v_ust_facility_dispenser'] = ['facility_id']
join_cols['v_ust_tank'] = ['facility_id']
join_cols['v_ust_tank_substance'] = ['facility_id','tank_id']
join_cols['v_ust_tank_dispenser'] = ['facility_id','tank_id']
join_cols['v_ust_compartment'] = ['facility_id','tank_id']
join_cols['v_ust_compartment_substance'] = ['facility_id','tank_id','compartment_id']
join_cols['v_ust_compartment_dispenser'] = ['facility_id','tank_id','compartment_id']
join_cols['v_ust_piping'] = ['facility_id','tank_id','compartment_id']
join_cols['v_ust_release'] = []
join_cols['v_ust_release_source'] = ['release_id'] 
join_cols['v_ust_release_cause'] = ['release_id']
join_cols['v_ust_release_substance'] = ['release_id']
join_cols['v_ust_release_corrective_action_strategy'] = ['release_id']

yellow_cell_fill = 'FFFF00' # yellow


class QualityCheck:
	conn = None 
	cur = None 
	views_to_review = []
	view_name = None 
	table_name = None 
	view_col_str = None 
	error_dict = {}
	error_cnt_dict = {}
	view_counts = {}

	def __init__(self, 
				 dataset):
		self.dataset = dataset
		self.connect_db()
		self.set_views()
		if not self.views_to_review:
			logger.warning('No %s template views found in schema %s; exiting.', self.dataset.ust_or_release, self.dataset.schema)
			logger.info('Views this script looks for: %s', self.get_view_names())
			self.disconnect_db()
			exit()
		self.wb = op.Workbook()	
		self.check_missing_views()
		self.set_view_counts()
		self.check_view_counts()
		for view_name in self.views_to_review:
			self.view_name = view_name
			self.table_name = view_name.replace('v_','')
			self.set_view_col_str()
			self.check_join_cols()
			self.check_required_cols()
			self.check_duplicate_rows()
			self.check_extraneous_cols()
			self.check_nonunique()
			self.check_bad_datatypes()
			self.check_failed_constraints()
			self.check_missing_mapping()
			self.check_bad_mapping()
			if self.dataset.ust_or_release == 'ust':
				self.check_compartment_data_flag()
		self.write_overview()
		element_mapping_to_excel.build_ws(self.dataset, self.wb.create_sheet(), admin=True)
		self.cleanup_wb()
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
		logger.info("The following views will be QC'ed: %s", self.views_to_review)


	def set_view_counts(self):
		sql = f"select view_name from public.{self.dataset.ust_or_release}_template_data_tables order by sort_order"
		utils.process_sql(self.conn, self.cur, sql)
		rows = self.cur.fetchall()
		for row in rows:
			view_name = row[0]
			sql = f"select count(*) from {self.dataset.schema}.{view_name}"
			try:
				self.cur.execute(sql)
			except psycopg2.errors.UndefinedTable:
				continue
			num_rows = self.cur.fetchone()[0]
			self.view_counts[view_name] = num_rows


	def check_view_counts(self):
		if self.dataset.ust_or_release == 'ust':
			if 'v_ust_compartment' in self.views_to_review and 'v_ust_tank' in self.views_to_review:
				if self.view_counts['v_ust_compartment'] < self.view_counts['v_ust_tank']:
					self.error_dict['Fewer rows in child table than expected'] = 'v_compartment_tank should have at least as many rows as v_ust_tank'
			# if 'v_ust_piping' in self.views_to_review and 'v_ust_compartment' in self.views_to_review:
			# 	if self.view_counts['v_ust_piping'] < self.view_counts['v_ust_compartment']:
			# 		self.error_dict['Fewer rows in child table than expected'] = 'v_ust_piping should have at least as many rows as v_ust_compartment'


	def check_missing_views(self):
		# check that all parent 
		missing_views = []
		if self.dataset.ust_or_release == 'ust':
			if 'v_ust_piping' in self.views_to_review:
				if 'v_ust_compartment' not in self.views_to_review:
					missing_views.insert(0, 'v_ust_compartment')
				if 'v_ust_tank' not in self.views_to_review:
					missing_views.insert(0, 'v_ust_tank')
			if 'v_ust_compartment' in self.views_to_review:
				if 'v_ust_tank' not in self.views_to_review and 'v_ust_tank' not in missing_views:
					missing_views.insert(0, 'v_ust_tank')
			for view_name in missing_views:
				self.error_dict['Missing required view (child data present)'] = self.dataset.schema + '.' + view_name  
				logger.warning('Missing required view (child data present) %s.%s', self.dataset.schema, self.view_name)


	def set_view_col_str(self):
		sql = """select column_name
				from information_schema.columns 
				where table_schema = %s and table_name = %s
				order by ordinal_position"""
		utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.schema, self.view_name))
		rows = self.cur.fetchall()
		col_str = ''
		for row in rows:
			col_str = col_str + row[0] + ', '
		if col_str:
			col_str = col_str[:-2]
		self.view_col_str = col_str 


	def write_to_ws(self, data, ws_name):
		if data:
			ws = self.wb.create_sheet(ws_name)
			headers = utils.get_headers(self.view_name, self.dataset.schema)
			for colno, header in enumerate(headers, start=1):
				ws.cell(row=1, column=colno).value = header
			for rowno, row in enumerate(data, start=2):
				for colno, cell_value in enumerate(row, start=1):
					ws.cell(row=rowno, column=colno).value = cell_value
			logger.info('Data written to worksheet %s', ws_name)
		else:
			logger.info('Nothing to write to %s', ws_name)


	def check_join_cols(self):
		# check for missing columns in the view that join child to parent tables 
		req_cols = join_cols[self.view_name]
		sql = f"""select column_name from information_schema.columns 
				where table_schema = %s and table_name = %s
				order by ordinal_position"""
		utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.schema, self.view_name,))
		rows = self.cur.fetchall()
		existing_cols = [r[0] for r in rows]
		for rcol in req_cols:
			if rcol not in existing_cols:
				self.error_dict['Missing join column'] = self.dataset.schema + '.' + self.view_name + '.' + rcol 
				logger.warning('Missing join column %s in view %s.%s', rcol, self.dataset.schema, self.view_name)


	def check_required_cols(self):
		# check for missing columns in the view that are required by EPA 
		sql = """select column_name from information_schema.columns 
				where table_schema = 'public' and table_name = %s 
				and is_nullable = 'NO' and ordinal_position > 1
				and column_name not like 'ust%%id' and column_name not like 'release%%id'
				order by ordinal_position"""
		utils.process_sql(self.conn, self.cur, sql, params=(self.table_name,))
		rows = self.cur.fetchall()
		for row in rows:
			col_name = row[0]
			sql2 = """select count(*) from information_schema.columns 
			         where table_schema = %s and table_name = %s
			         and column_name = %s"""
			utils.process_sql(self.conn, self.cur, sql2, params=(self.dataset.schema, self.view_name, col_name))
			cnt = self.cur.fetchone()[0]
			if cnt < 1:
				self.error_dict['Missing required column'] = self.dataset.schema + '.' + self.view_name + '.' + col_name 
				logger.warning('Missing required column %s in view %s.%s', col_name, self.dataset.schema, self.view_name)
			else:
				sql3 = f"select * from {self.dataset.schema}.{self.view_name} where {col_name} is null"
				utils.process_sql(self.conn, self.cur, sql3)
				data = self.cur.fetchall()
				num_rows = self.cur.rowcount 
				self.error_cnt_dict['Number of null rows for required column ' + self.table_name + '.' + col_name] = num_rows
				logger.warning('Number of null rows for required column %s.%s = %s', self.table_name, col_name, num_rows)
				self.write_to_ws(data, col_name + ' null')


	def check_duplicate_rows(self):
		# check for rows that have duplicate key columns
		sql = f"""select column_name from public.{self.dataset.ust_or_release}_view_key_columns 
		          where view_name = %s order by sort_order"""
		utils.process_sql(self.conn, self.cur, sql, params=(self.view_name,))
		key_cols = [r[0] for r in self.cur.fetchall()]
		key_col_str = ''
		join = ''
		for col in key_cols:
			key_col_str = key_col_str + col + ', '
			join = join + 'a.' + col + ' = b.' + col + ' and ' 
		key_col_str = key_col_str[:-2]
		join = join[:-4]
		sql = f"""select {key_col_str}, count(*) num_rows from {self.dataset.schema}.{self.view_name} 
		          group by {key_col_str} having count(*) > 1"""
		utils.process_sql(self.conn, self.cur, sql)
		num_rows = self.cur.rowcount
		self.error_cnt_dict['Number of duplicated key columns in ' + self.dataset.schema + '.' + self.view_name + ' (' + key_col_str + ')'] = num_rows
		logger.warning('Number of duplicated key columns in %s.%s: %s', self.dataset.schema, self.view_name, num_rows)
		if num_rows > 0:
			sql = f"""select * from {self.dataset.schema}.{self.view_name}  a
					where exists
						(select {key_col_str}
						from {self.dataset.schema}.{self.view_name}  b
						where {join}
						group by {key_col_str}
						having count(*) > 1)
					order by 1, 2, 3"""
			utils.process_sql(self.conn, self.cur, sql)
			data = self.cur.fetchall()
			num_rows = self.cur.rowcount
			self.write_to_ws(data, self.view_name + ' duplicates')
			self.error_dict['Number of rows with duplicated key columns in ' + self.dataset.schema + '.' + self.view_name ] = num_rows


	def get_bad_datatypes(self, data):
		for d in data:
			col_name = d[0]
			table_data_type = d[1]
			table_len = d[2]
			view_data_type = d[3]
			view_len = d[4]
			if view_len and table_len and view_len > table_len:
				sql2 = f"select * from {self.dataset.schema}.{self.view_name} where length({col_name}) > %s"
				utils.process_sql(self.conn, self.cur, sql2, params=(table_len,))
				data = self.cur.fetchall()
				num_rows = self.cur.rowcount 
				self.error_cnt_dict['Number of rows exceeding allowed length of ' + self.table_name + '.' + col_name] = num_rows
				logger.warning('Number of rows exceeding allowed length of %s.%s: %s', self.table_name, col_name, num_rows)
				self.write_to_ws(data, col_name + ' too long')
			elif view_data_type == 'text' and table_data_type == 'character varying':
				sql = f"select * from {self.dataset.schema}.{self.view_name} where length({col_name}) > %s"
				utils.process_sql(self.conn, self.cur, sql, params=(table_len,))
				data = self.cur.fetchall()
				num_rows = self.cur.rowcount 
				if num_rows > 0:
					self.error_cnt_dict['Number of rows exceeding allowed length of ' + self.table_name + '.' + col_name] = num_rows
					logger.warning('Number of rows exceeding allowed length of %s.%s: %s', self.table_name, col_name, num_rows)
					self.write_to_ws(data, col_name + ' too long')
			elif table_data_type != view_data_type:
				self.error_dict['Wrong data type for ' + self.table_name + '.' + col_name] = self.dataset.schema + '.' + self.view_name + '.' + col_name


	def check_bad_datatypes(self):
		# check for columns in the state schema view where the data type doesn't match the EPA table, or 
		# the length of the value in a character column is too long in the state data 
		sql = """select a.column_name, a.data_type, a.character_maximum_length, b.data_type, b.character_maximum_length 
				from information_schema.columns a join information_schema.columns b on a.column_name = b.column_name
				where a.table_schema = 'public' and a.table_name = %s
				and b.table_schema  = %s and b.table_name = %s
				and (a.data_type <> b.data_type or b.character_maximum_length > a.character_maximum_length)
				order by a.ordinal_position"""
		utils.process_sql(self.conn, self.cur, sql, params=(self.table_name, self.dataset.schema, self.view_name))
		data = self.cur.fetchall()
		self.get_bad_datatypes(data)

		# check the data type of the EPA table join columns 
		if self.dataset.ust_or_release == 'ust':
			if self.view_name == 'v_ust_tank':
				epa_table_name = 'ust_facility'
			elif self.view_name == 'v_ust_compartment':
				epa_table_name = 'ust_tank'
			elif self.view_name == 'v_ust_piping':
				epa_table_name = 'ust_compartment'
			else: # no need to check v_ust_facility as it is the parent
				epa_table_name = None 
			if epa_table_name:
				sql = """select a.column_name, a.data_type, a.character_maximum_length, b.data_type, b.character_maximum_length 
						from information_schema.columns a join information_schema.columns b on a.column_name = b.column_name
						where a.table_schema = 'public' and a.table_name = %s
						and b.table_schema = %s and b.table_name = %s
						and (a.data_type <> b.data_type or b.character_maximum_length > a.character_maximum_length)
						order by a.ordinal_position"""
				utils.process_sql(self.conn, self.cur, sql, params=(epa_table_name, self.dataset.schema, self.view_name))
				data = self.cur.fetchall()
				self.get_bad_datatypes(data)


	def check_extraneous_cols(self):
		# check for columns in the state schema view that don't correspond to columns in the EPA template 
		sql = """select column_name from information_schema.columns 
		     	where table_schema = %s and table_name = %s and column_name not in 
		     		(select column_name from information_schema.columns 
		     		where table_schema = 'public' and table_name = %s)
		     	order by column_name"""
		utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.schema, self.view_name, self.table_name))
		rows = self.cur.fetchall()
		for row in rows:
			col_name = row[0]
			if col_name not in join_cols[self.view_name] and not (self.view_name == 'v_ust_compartment_substance' and col_name == 'substance_id'):
				self.error_dict['Extraneous column'] = self.dataset.schema + '.' + self.view_name + '.' + col_name 
				logger.warning('Extraneous column %s in view %s.%s', col_name, self.dataset.schema, self.view_name)


	def check_nonunique(self):
		# check for non-unique (repeating) rows	
		sql = f"select {self.view_col_str}, count(*) from {self.dataset.schema}.{self.view_name} group by {self.view_col_str} having count(*) > 1 order by 1, 2"
		utils.process_sql(self.conn, self.cur, sql)
		data = self.cur.fetchall()
		num_rows = self.cur.rowcount 
		self.error_cnt_dict['nonunique rows in ' + self.dataset.schema + '.' + self.view_name] = num_rows
		logger.warning('Number of non-unique rows in %s.%s: %s', self.dataset.schema, self.view_name, num_rows)
		self.write_to_ws(data, self.view_name + ' nonunique')


	def check_failed_constraints(self):
		# check for failed check constraints
		sql = """select cc.constraint_name, check_clause
					from information_schema.check_constraints cc 
						join pg_constraint cons on cc.constraint_name = cons.conname
						join pg_class t on cons.conrelid = t.oid 
					where constraint_schema = 'public' and t.relname = %s
					order by 1, 2"""
		utils.process_sql(self.conn, self.cur, sql, params=(self.table_name,))
		rows = self.cur.fetchall()
		for row in rows:
			constraint_name = row[0]
			check_clause = row[1]
			sql2 = f"select * from {self.dataset.schema}.{self.view_name} where not {check_clause}"
			try:
				utils.process_sql(self.conn, self.cur, sql2)
			except psycopg2.errors.UndefinedColumn:
				continue 
			data = self.cur.fetchall()
			num_rows = self.cur.rowcount 
			self.error_cnt_dict['failed check constraint ' + self.dataset.schema + '.' + constraint_name] = num_rows
			logger.warning('Number of failed rows for check constraint %s.%s: %s', self.table_name, constraint_name, num_rows)
			self.write_to_ws(data, constraint_name)


	def check_missing_mapping(self):
		sql = f"""select c.column_name 
				from information_schema.columns c 
					join information_schema.tables t 
						on c.table_schema = t.table_schema and c.table_name = t.table_name
					join ust_template_data_tables x on c.table_name = x.view_name
				where c.table_schema = %s and c.table_name = %s 
				and column_name not in ('facility_state', 'facility_epa_region') and not exists 
					(select 1 from public.{self.dataset.ust_or_release}_element_mapping m
					where x.table_name = m.epa_table_name and c.column_name = m.epa_column_name
					and m.{self.dataset.ust_or_release}_control_id = %s)
				order by c.ordinal_position"""
		utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.schema, self.view_name, self.dataset.control_id))
		rows = self.cur.fetchall()
		num_rows = self.cur.rowcount 
		self.error_cnt_dict['Unmapped elements in ' + self.dataset.schema + '.' + self.view_name] = num_rows
		unmapped_cols = ''
		for row in rows:
			unmapped_cols = row[0] + '; '
		if unmapped_cols:
			unmapped_cols = unmapped_cols[:-2]
			self.error_dict['Unmapped elements in ' + self.view_name] = unmapped_cols 
			logger.warning('Unmapped elements in %s: %s', self.view_name, unmapped_cols)
			

	def check_bad_mapping(self):
		# check for bad mapping values
		sql = f"""select distinct epa_column_name, epa_value, database_lookup_table, database_column_name 
				from public.v_{self.dataset.ust_or_release}_element_mapping a join public.{self.dataset.ust_or_release}_elements b on a.epa_column_name = b.database_column_name 
				where {self.dataset.ust_or_release}_control_id = %s and database_lookup_table is not null and epa_table_name = %s and epa_value is not null
				order by 1, 2, 3"""
		utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id, self.table_name))
		rows = self.cur.fetchall()
		for row in rows:
			epa_column_name = row[0]
			epa_value = row[1]
			lookup_table = row[2]
			lookup_column = row[3].replace('_id','')
			if lookup_column == 'facility_type1' or lookup_column == 'facility_type2':
				lookup_column = 'facility_type'
			sql2 = f"select count(*) from public.{lookup_table} where {lookup_column} = %s"
			utils.process_sql(self.conn, self.cur, sql2, params=(epa_value,))
			cnt = self.cur.fetchone()[0]
			if cnt < 1:
				self.error_dict['invalid EPA value in ' + epa_column_name] = epa_value 
				logger.warning('Invalid EPA value for %s.%s: %s', self.table_name, epa_column_name, cnt)


	def check_compartment_data_flag(self):
		sql = "select organization_compartment_flag from ust_control where ust_control_id = %s"
		utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id,))
		org_comp_flag = self.cur.fetchone()[0]
		if not org_comp_flag:
			self.error_dict['Missing organization_compartment_flag in ust_control'] = org_comp_flag 
			logger.warning('Missing organization_compartment_flag in ust_control')
		elif org_comp_flag not in ['Y','N']:
			self.error_dict['Bad value of in organization_compartment_flag in ust_control'] = org_comp_flag
			logger.warning('Bad value of %s in  organization_compartment_flag in ust_control', org_comp_flag)


	def write_overview(self):
		# Print an overview of QA/QC results
		ws = self.wb.create_sheet('Overview')
		rowno = 1
		ws.cell(row=rowno, column=1).value = 'View Name'
		ws.cell(row=rowno, column=1).font = Font(bold=True)
		ws.cell(row=rowno, column=2).value = 'Number of Rows'
		ws.cell(row=rowno, column=2).font = Font(bold=True)
		rowno +=1 
		for k, v in self.view_counts.items():
			print('Number of rows in ' + k + ' = ' + str(v))
			ws.cell(row=rowno, column=1).value = k
			ws.cell(row=rowno, column=2).value = v  
			rowno += 1

		rowno += 2
		ws.cell(row=rowno, column=1).value = 'QA Check'
		ws.cell(row=rowno, column=1).font = Font(bold=True)
		ws.cell(row=rowno, column=2).value = 'Number of Rows'
		ws.cell(row=rowno, column=2).font = Font(bold=True)
		rowno +=1 	
		for k, v in self.error_cnt_dict.items():
			print(k + ' = ' + str(v))
			ws.cell(row=rowno, column=1).value = k
			ws.cell(row=rowno, column=2).value = v  
			if v > 0:
				ws.cell(row=rowno, column=2).fill = utils.get_fill_gen(yellow_cell_fill)
			rowno += 1
	
		utils.autowidth(ws)		
	
		rowno += 2
		ws.cell(row=rowno, column=1).value = 'Bad or Missing Data'
		ws.cell(row=rowno, column=1).font = Font(bold=True)
		ws.cell(row=rowno, column=2).value = 'Details'
		ws.cell(row=rowno, column=2).font = Font(bold=True)
		rowno +=1 	
		bad = False
		for k, v in self.error_dict.items():
			bad = True
			print(k + ' = ' + str(v))
			ws.cell(row=rowno, column=1).value = k
			ws.cell(row=rowno, column=2).value = v  
			rowno += 1
		if not bad: 
			ws.cell(row=rowno, column=1).value = 'No bad or missing data'
			ws.cell(row=rowno, column=1).font = Font(italic=True)


	def cleanup_wb(self):
		try:
			self.wb.remove(self.wb['Sheet'])
			self.wb.active = self.wb['Overview']
		except:
			pass
		self.wb.save(self.dataset.export_file_path)



def main(ust_or_release, control_id=None, export_file_name=None, export_file_dir=None, export_file_path=None):
	dataset = Dataset(ust_or_release=ust_or_release,
				 	  control_id=control_id, 
				 	  base_file_name='QAQC_' + utils.get_timestamp_str() + '.xlsx',
					  export_file_name=export_file_name,
					  export_file_dir=export_file_dir,
					  export_file_path=export_file_path)

	qc = QualityCheck(dataset=dataset)


if __name__ == '__main__':   
	main(ust_or_release=ust_or_release,
		 control_id=control_id, 
		 export_file_name=export_file_name,
		 export_file_dir=export_file_dir,
		 export_file_path=export_file_path)
