from logger_factory import logger
import utils
import make_template_view
import export_template, export_template_for_geoprocessing

import psycopg2.errors


def main(state, ust_or_lust, control_id=None):
	logger.info('Working on %s %s', state, ust_or_lust.upper())

	make_template_view.main(state, ust_or_lust)

	schema = utils.get_schema_name(state, ust_or_lust)
	view_name = '"' + schema + '".v_' + ust_or_lust.lower() 

	conn = utils.connect_db()
	cur = conn.cursor()

	if not control_id:
		sql = "select count(*) from " + ust_or_lust.lower() + '_control where state = %s'
		cur.execute(sql, (state, ))
		cnt = cur.fetchone()[0]
		if cnt == 0:
			logger.error('No data in %s_control; unable to proceed.', ust_or_lust.lower())
			exit()
		sql = "select max(control_id) from " + ust_or_lust.lower() + '_control where state = %s'
		cur.execute(sql, (state, ))
		control_id = cur.fetchone()[0]

		if cnt > 1:
			logger.info('Found multiple Control IDs in %s_control; using newest one (%s)', ust_or_lust.lower(), str(control_id) )
		else:
			logger.info('Setting Control ID to %s', str(control_id))

	sql = "delete from " + ust_or_lust.lower() + ' where state = %s and control_id = %s'
	cur.execute(sql, (state, control_id))
	logger.info('Deleted %s existing rows from %s', cur.rowcount, ust_or_lust.lower())

	sql = """select column_name from information_schema.columns 
	         where table_schema = 'public' and table_name = %s
	         and column_name not in ('id', 'control_id', 'state')
	         order by ordinal_position"""
	cur.execute(sql, (ust_or_lust,))
	cols = [r[0] for r in cur.fetchall()]
	
	col_string = ''
	for col in cols:
		col_string = col_string + '"' + col + '", '
	col_string = col_string[:-2] 

	sql = f'insert into {ust_or_lust.lower()} (control_id, state, ' + col_string + ') '
	sql = sql + 'select ' + str(control_id) + ", '" + state + "'," + col_string + ' from ' + view_name
	cur.execute(sql)
	logger.info('Inserted %s rows into table %s', cur.rowcount, ust_or_lust)


	if ust_or_lust.lower() == 'ust':
		lat_col = '"FacilityLatitude"'
		long_col = '"FacilityLongitude"'
	elif ust_or_lust.lower() == 'lust':
		lat_col = '"Latitude"'
		long_col = '"Longitude"'

	sql = f"""select count(*) 
			  from {ust_or_lust.lower()} where control_id = %s and 
				({lat_col} is null  or {long_col} is null
			    or length(split_part({lat_col} ::text, '.', 2)::text) < 3
			    or length(split_part({long_col}::text, '.', 2)::text) < 3)"""
	cur.execute(sql, (control_id,))
	cnt = cur.fetchone()[0]
	logger.info('There are %s rows with insufficient lat/long data.', cnt)
	if cnt > 0:
		logger.info('Exporting to spreadsheet for geoprocessing; send it to Paul')
		export_template_for_geoprocessing.main(state, ust_or_lust)

	conn.commit()
	cur.close()
	conn.close()

	export_template.main(state, ust_or_lust)
	logger.info('Processing for %s %s complete', state, ust_or_lust.upper())


def multiple_states(states, ust_or_lust):
	for state in states:
		main(state, ust_or_lust)


if __name__ == '__main__':
	state = 'AL'
	ust_or_lust = 'ust'
	main(state, ust_or_lust)

	# states = ['AL','CA','NC','NE','NY','OR','SC','TN','TRUSTD','TX']
	# ust_or_lust = 'ust'

	# states = ['SD']
	# ust_or_lust = 'lust'
	# multiple_states(states, ust_or_lust)