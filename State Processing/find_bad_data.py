import utils
import psycopg2.errors


def find_too_long_col(col_length, organization_id, ust_or_lust='ust', view_name=None):
	if not view_name:
		view_name = utils.get_view_name(organization_id, ust_or_lust)

	conn = utils.connect_db()
	cur = conn.cursor()

	sql = f"""select column_name from information_schema.columns 
	         where table_name = %s and data_type in ('character varying','text') 
	         and character_maximum_length = %s and column_name in
			 	(select column_name from information_schema.columns 
			 	 where table_schema = '{organization_id}_{ust_or_lust.upper()}' and table_name = %s)
	         order by ordinal_position"""
	cur.execute(sql, (ust_or_lust.lower(), col_length, view_name))
	rows = cur.fetchall()
	
	for row in rows:
		column_name = row[0]
		print('Checking ' + column_name)
		sql2 = f"""select "FacilityID", "{column_name}" 
		           from {utils.get_view_name(organization_id, ust_or_lust, view_name)} 
		           where length("{column_name}") > %s """
		# print(sql2)
		cur.execute(sql2, (col_length,))
		rows2 = cur.fetchall()

		for row2 in rows2:
			print(row2[0], f'{column_name}:', row2[1])

	cur.close()
	conn.close()


def find_bad_floats(organization_id, ust_or_lust='ust', view_name=None):
	""" View name defaults to v_l/ust_base """

	if not view_name:
		view_name = utils.get_view_name(organization_id, ust_or_lust)
	# else:
	# 	view_name = '"' + utils.get_schema_name(organization_id, ust_or_lust) + '".' + view_name

	view_info = utils.get_view_info(organization_id, ust_or_lust, view_name)
	from_sql = view_info[1]
	col_defs = view_info[0]

	conn = utils.connect_db()
	cur = conn.cursor()

	sql = f"""select column_name from information_schema.columns 
			 where table_name = %s and data_type = 'double precision' and column_name in
			 	(select column_name from information_schema.columns 
			 	 where table_schema = '{organization_id}_{ust_or_lust.upper()}' and table_name = %s)
			 order by ordinal_position"""
	cur.execute(sql, (ust_or_lust, view_name))
	cols = [r[0] for r in cur.fetchall()]

	for col in cols:
		col_def = col_defs[col]
		if col_def[:4] != 'NULL':
			print('-----------------------------------------------------------------------------')
			print(col)
			sql = "select " + col_def + ' ' + from_sql + ' order by 1'
			cur.execute(sql)
			rows = [r[0] for r in cur.fetchall()]
			for row in rows:
				try:
					float(row)
				except:
					print(row)

	cur.close()
	conn.close()


def find_bad_ints(organization_id, ust_or_lust='ust', view_name=None):
	""" View name defaults to v_l/ust_base """

	if not view_name:
		view_name = utils.get_view_name(organization_id, ust_or_lust)
	# else:
	# 	view_name = '"' + utils.get_schema_name(organization_id, ust_or_lust) + '".' + view_name

	view_info = utils.get_view_info(organization_id, ust_or_lust, view_name)
	from_sql = view_info[1]
	col_defs = view_info[0]

	conn = utils.connect_db()
	cur = conn.cursor()

	sql = f"""select column_name from information_schema.columns 
			 where table_name = %s and data_type = 'integer' 
			 and column_name not in ('id','control_id') and column_name in
			 	(select column_name from information_schema.columns 
			 	 where table_schema = '{organization_id}_{ust_or_lust.upper()}' and table_name = %s)
			 order by ordinal_position"""
	cur.execute(sql, (ust_or_lust, view_name))
	cols = [r[0] for r in cur.fetchall()]

	for col in cols:
		col_def = col_defs[col]
		if col_def[:4] != 'NULL':
			print('-----------------------------------------------------------------------------')
			print(col)
			sql = "select distinct " + col_def + ' ' + from_sql + ' order by 1'
			cur.execute(sql)
			rows = [r[0] for r in cur.fetchall()]
			for row in rows:
				try:
					int(row)
				except:
					print(row)

	cur.close()
	conn.close()


def find_bad_dates(organization_id, ust_or_lust='ust', view_name=None):
	""" View name defaults to v_l/ust_base """

	if not view_name:
		view_name = utils.get_view_name(organization_id, ust_or_lust)
	# else:
	# 	view_name = '"' + utils.get_schema_name(organization_id, ust_or_lust) + '".' + view_name

	view_info = utils.get_view_info(organization_id, ust_or_lust, view_name)
	from_sql = view_info[1]
	col_defs = view_info[0]

	conn = utils.connect_db()
	cur = conn.cursor()

	sql = f"""select column_name from information_schema.columns 
			 where table_name = %s and data_type = 'date' and column_name in
			 	(select column_name from information_schema.columns 
			 	 where table_schema = '{organization_id}_{ust_or_lust.upper()}' and table_name = %s)
			 order by ordinal_position"""
	cur.execute(sql, (ust_or_lust, view_name))
	cols = [r[0] for r in cur.fetchall()]

	for col in cols:
		col_def = col_defs[col]
		if col_def[:4] != 'NULL':
			print('-----------------------------------------------------------------------------')
			print(col)
			sql = "select distinct " + col_def + ' ' + from_sql + ' order by 1'
			cur.execute(sql)
			rows = [r[0] for r in cur.fetchall()]
			for row in rows:
				try:
					date(row)
				except:
					print(row)

	cur.close()
	conn.close()


def drop_cols_from_view(organization_id, ust_or_lust, view_name, null_cols):
	schema = organization_id.upper() + '_' + ust_or_lust.upper()

	base_cols = utils.get_view_info(organization_id, ust_or_lust, view_name)
	from_sql = base_cols[1]
	# print(base_cols)
	# print(from_sql)

	new_view_sql = 'select distinct '
	for col in base_cols[0]:
		if col not in null_cols:
			col_def = base_cols[0][col]
			new_view_sql = new_view_sql + col_def + ' as ' + '"' + col + '",'
	new_view_sql = new_view_sql[:-1] + from_sql
	
	conn = utils.connect_db()
	cur = conn.cursor()	

	sql = f'drop view {utils.get_schema_name(organization_id, ust_or_lust)}".{view_name}'
	cur.execute(sql)
	cur.execute(new_view_sql)

	cur.close()
	conn.close()


def find_empty_cols(organization_id, ust_or_lust, view_name, drop_cols=False):
	conn = utils.connect_db()
	cur = conn.cursor()
	
	sql = f"""select column_name from information_schema.columns 
 		 	  where table_schema = '{organization_id}_{ust_or_lust.upper()}' and table_name = %s
		      order by ordinal_position"""
	cur.execute(sql, (view_name,))
	rows = [r[0] for r in cur.fetchall()]
	null_cols = []
	for row in rows:
		sql2 = f'select count(*) from "{utils.get_schema_name(organization_id, ust_or_lust)}".{view_name} where "{row}" is not null'
		cur.execute(sql2)
		cnt = cur.fetchone()[0]
		if cnt == 0:
			# print(row)
			null_cols.append(row)

	cur.close()
	conn.close()

	if drop_cols:
		drop_cols_from_view(organization_id, ust_or_lust, view_name, null_cols)



def find_bad_col_names(organization_id, ust_or_lust, view_name):
	conn = utils.connect_db()
	cur = conn.cursor()
	
	
	schema =  utils.get_schema_name(organization_id, ust_or_lust)
	if not view_name:
		view_name = utils.get_view_name(organization_id, ust_or_lust).replace('"' + schema + '".','')

	sql = """select column_name
			from information_schema.columns 
			where table_name = %s and table_schema = %s and column_name not in 
				(select column_name from information_schema.columns where table_name = %s)
			order by ordinal_position"""
	cur.execute(sql, (view_name, schema, ust_or_lust.lower()))

	rows = cur.fetchall()
	for row in rows:
		print(row[0])

	cur.close()
	conn.close()




	
if __name__ == '__main__':   
	organization_id = 'MO'
	ust_or_lust = 'lust'
	view_name = 'v_' + ust_or_lust + '_base'
	# find_empty_cols(organization_id, ust_or_lust, view_name, drop_cols=True)
	find_too_long_col(43, organization_id, ust_or_lust, view_name)
	# find_bad_dates(organization_id, ust_or_lust, view_name)
	# find_bad_floats(organization_id, ust_or_lust, view_name)
	# find_bad_ints(organization_id, ust_or_lust, view_name)
	# find_bad_col_names(organization_id, ust_or_lust, 'v_ust')

