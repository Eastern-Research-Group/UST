from logger_factory import logger
import utils
import psycopg2.errors


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


def main(state, ust_or_lust, base_view_name=None):
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

	print(view_sql)

	try:
		cur.execute('drop view ' + new_view_name)
		logger.info('Dropped %s', new_view_name)
	except psycopg2.errors.UndefinedTable:
		pass

	cur.execute(view_sql)
	logger.info('Created %s', new_view_name)

	cur.close()
	conn.close()


if __name__ == '__main__':   
	state = 'TX'
	ust_or_lust = 'ust'
	main(state, ust_or_lust)
