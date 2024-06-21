import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))
from datetime import date
import ntpath

from python.util.logger_factory import logger
from python.util import utils, config

### WARNING! THIS SCRIPT CURRENTLY ONLY WORKS FOR RELEASES. DO NOT USE FOR UST. 

ust_or_release = 'release' # valid values are 'ust' or 'release'
control_id = 2
delete_existing = True 


def main(control_id, ust_or_release, delete_existing=False):
	ust_or_release = ust_or_release.lower()
	if ust_or_release not in ['ust','release']:
		logger.error('Invalid value %s for ust_or_release. Valid values are ust or release. Exiting...', ust_or_release)
		exit()

	schema = utils.get_schema_from_control_id(control_id, ust_or_release)

	conn = utils.connect_db()
	cur = conn.cursor()

	if delete_existing:
		if ust_or_release == 'release':
			utils.delete_all_release_data(control_id)
		else:
			utils.delete_all_ust_data(control_id) 
	else:
		if ust_or_release == 'release':
			table_name = 'ust_release'
		else:
			table_name = 'ust_facility'

		sql = f"select count(*) from public.{table_name} where {ust_or_release}_control_id = %s"
		cur.execute(sql, (control_id,))
		cnt = cur.fetchone()[0]
		if cnt > 0:
			logger.warning('Data found in %s for %s_control_id %s. To proceed, set the delete_existing variable to True.', table_name, ust_or_release, control_id)
			exit()

	table_name = ust_or_release + '_template_data_tables'
	sql = f"""select table_name, view_name, sort_order
			from {table_name}
			order by sort_order"""
	cur.execute(sql)
	rows = cur.fetchall()
	for row in rows:
		column_list = ''
		table_name = row[0]
		view_name = row[1]
		sort_order = row[2]
		logger.info('Working on %s', table_name)

		sql2 = f"""select column_name from information_schema.columns 
				where table_schema = %s and table_name = %s 
				order by ordinal_position"""
		cur.execute(sql2, (schema, view_name))
		rows2 = cur.fetchall()
		for row2 in rows2:
			column_list = column_list + row2[0] + ', '
		if column_list:
			if sort_order == 1:
				column_list = column_list + ust_or_release + '_control_id'
				insert_sql = 'insert into public.' + table_name + ' (' + column_list + """) 
				select """ + column_list.replace(ust_or_release + '_control_id', str(control_id)) + " from " + schema + '.' + view_name 
				print(insert_sql)
				cur.execute(insert_sql)

			else: #TODO: Currently this only works for releases!!
				if ust_or_release == 'release':
					column_list = 'ust_release_id, ' + column_list[:-2]
					column_list = column_list.replace(', release_id','')
					parent_table = 'ust_release'
					join_col = 'release_id'
					epa_col = 'ust_release_id'
				else:
					column_list = 'ust_facility_id, ' + column_list[:-2] # TODO: this won't work!!
					column_list = column_list.replace(', facility_id','')
					parent_table = 'ust_facility' # TODO: for ust, this needs to be dynamic!
					join_col = 'facility_id' # TODO: for ust, this needs to be dynamic!
					epa_col = 'ust_facility_id' # TODO: for ust, this needs to be dynamic!
				insert_sql = 'insert into public.' + table_name + ' (' + column_list + """) 
				select """ + column_list + " from " + schema + "." + view_name + """ a join 
				(select """ + epa_col + ', ' + join_col + " from public.""" + parent_table + " where " + ust_or_release + """_control_id = %s) b 
				on a.""" + join_col + " = b." + join_col
				print(insert_sql)
				cur.execute(insert_sql, (control_id, ))

			rows_inserted = cur.rowcount
			conn.commit()
			logger.info('Inserted %s rows into %s', rows_inserted, table_name)

	cur.close()
	conn.close()


if __name__ == '__main__':   
	main(control_id, ust_or_release, delete_existing)
