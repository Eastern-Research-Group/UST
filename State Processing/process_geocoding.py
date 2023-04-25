from logger_factory import logger
import config
import utils

import pandas.io.sql as sqlio


def get_col_position(ust_or_lust):
	conn = utils.connect_db()
	cur = conn.cursor()	

	column_name = 'FacilityLongitude'
	if ust_or_lust.lower() == 'lust':
		column_name = 'Longitude'

	sql = """select ordinal_position 
			 from information_schema.columns 
			 where table_schema = 'public' and table_name = %s
			 and column_name = %s """
	cur.execute(sql, (ust_or_lust.lower(), column_name))
	col_pos = cur.fetchone()[0]

	cur.close()
	conn.close()

	return col_pos


def create_view(state, ust_or_lust):
	schema = state.upper() + '_' + ust_or_lust.upper()
	new_view_name = '"' + schema + '".v_' + ust_or_lust.lower() + '_geocode'

	col_pos = get_col_position(ust_or_lust)

	conn = utils.connect_db()
	cur = conn.cursor()

	columns = []
	sql = """select case when table_name = 'ust' and column_name = 'FacilityLatitude' then 'case when gc_latitude is not null then gc_latitude else "FacilityLatitude" end as "FacilityLatitude"' 
			             when table_name = 'ust' and column_name = 'FacilityLongitude' then 'case when gc_longitude is not null then gc_longitude else "FacilityLongitude" end as "FacilityLongitude"' 
			             when table_name = 'lust' and column_name = 'Latitude' then 'case when gc_latitude is not null then gc_latitude else "Latitude" end as "Latitude"' 
			             when table_name = 'lust' and column_name = 'Longitude' then 'case when gc_longitude is not null then gc_longitude else "Longitude" end as "Longitude"' 
			        else '"' || column_name || '"' end as column_name, ordinal_position - 3 as ordinal_position
			from information_schema.columns 
			where table_schema = 'public' and table_name = %s
			and column_name not in ('id','control_id','state')
			and ordinal_position <= %s
			order by ordinal_position"""
	cur.execute(sql, (ust_or_lust, col_pos))
	rows = cur.fetchall()
	columns = [x[0] for x in rows]

	columns.append('gc_coordinate_source')
	columns.append('gc_address_type')

	sql = """select '"' || column_name || '"' as column_name, ordinal_position 
		    from information_schema.columns 
			where table_schema = 'public' and table_name = %s
			and column_name not like 'gc_%%'
			and ordinal_position > %s
			order by ordinal_position"""

	cur.execute(sql, (ust_or_lust, col_pos))
	rows = cur.fetchall()
	for row in rows:
		columns.append(row[0])

	view_sql = 'create view ' + new_view_name + ' as \nselect distinct '
	for col_name in columns:
		view_sql = view_sql + col_name + ',\n'
	view_sql = view_sql[:-2] + '\n'
	from_sql = ' from public.' + ust_or_lust.lower() + " where state = '" + state.upper() + "' and control_id = "
	from_sql = from_sql + '(select max(control_id) from public.' + ust_or_lust.lower() + "_control where state = '" + state.upper() + "')"
	view_sql = view_sql + from_sql

	try:
		cur.execute('drop view ' + new_view_name)
		logger.info('Dropped %s', new_view_name)
	except psycopg2.errors.UndefinedTable:
		pass

	cur.execute(view_sql)
	logger.info('Created %s', new_view_name)

	cur.close()
	conn.close()


def update_data(state, ust_or_lust, data_table=None):
	schema = state.upper() + '_' + ust_or_lust.upper()

	conn = utils.connect_db()
	cur = conn.cursor()


	if not data_table:
		sql = """select table_name from information_schema.tables 
		         where table_schema = %s and table_type = 'BASE TABLE'
		         and lower(table_name) like '%%geocod%%'"""
		cur.execute(sql, (schema,))
		data_table = cur.fetchone()[0]

	sql = f"""update public.{ust_or_lust.lower()} x
			set gc_latitude = y.gc_latitude::float, 
			gc_longitude = y.gc_longitude::float, 
			gc_coordinate_source = y.gc_coordinate_source, 
			gc_address_type = y.gc_address_type
		from "{schema}".{data_table} y """

	if ust_or_lust.lower() == 'ust':
		sql = sql + ' where x."FacilityID" = y.facilityid and x."TankID" = y.tankid and x."CompartmentID" = y.compartmentid \n'
	else:
		sql = sql + ' where x."FacilityID" = y.facilityid and x."LUSTID" = y.lustid  \n'

	sql = sql + f" and x.state = %s and x.control_id = (select max(control_id) from public.{ust_or_lust.lower()}_control where state = %s)"
	# logger.debug(sql)

	cur.execute(sql, (state, state))
	logger.info('Updated %s rows in public.%s for state %s', cur.rowcount, ust_or_lust.lower(), state)

	cur.close()
	conn.close()


def export(state, ust_or_lust):
	schema = state.upper() + '_' + ust_or_lust.upper()

	conn = utils.connect_db()
	cur = conn.cursor()

	sql = f'select * from "{schema}".v_{ust_or_lust.lower()}_geocode'
	if ust_or_lust.lower() == 'ust':
		sql = sql + ' order by "FacilityID", "TankID", "CompartmentID"'
	else:
		sql = sql + ' order by "FacilityID", "LUSTID"'

	df = sqlio.read_sql_query(sql, utils.get_engine())
	file_path = config.local_ust_path + state.upper() + '/' 
	file_name = state.upper() + '_' + ust_or_lust.upper() + '_geocoded.xlsx'
	sheet_name = state.upper() + '_' + ust_or_lust.upper()
	df.to_excel(file_path + file_name, sheet_name=sheet_name, index=False, freeze_panes=(1,0))

	cur.close()
	conn.close()


def main(state, ust_or_lust, base_table):
	# create_view(state, ust_or_lust)
	# update_data(state, ust_or_lust, base_table)
	export(state, ust_or_lust)


if __name__ == '__main__':   
	state = 'TX'
	ust_or_lust = 'ust'
	base_table = 'tx_ust'
	main(state, ust_or_lust, base_table)
