import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))
from datetime import date
import ntpath

from python.util.logger_factory import logger
from python.util import utils, config


ust_or_release = 'release' # valid values are 'ust' or 'release'
control_id = 2


def main(control_id, ust_or_release):
	ust_or_release = ust_or_release.lower()
	schema = utils.get_schema_from_control_id(control_id, ust_or_release)

	if ust_or_release == 'release':
		utils.delete_all_release_data(control_id)
	elif ust_or_release == 'ust':
		utils.delete_all_ust_data(control_id) #TODO! THIS DOESN'T EXIST YET!!
	else:
		logger.error('Invalid value %s for ust_or_release. Valid values are ust or release. Exiting...', ust_or_release)

	conn = utils.connect_db()
	cur = conn.cursor()

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
		if sort_order == 1:
			column_list = column_list + ust_or_release + '_control_id'
		else:
			column_list = column_list[:-2]

		insert_sql = 'insert into public.' + table_name + ' (' + column_list + """) 
		select """ + column_list.replace(ust_or_release + '_control_id', str(control_id)) + " from " + schema + '.' + view_name 
		print(insert_sql)

		cur.execute(insert_sql)
		rows_inserted = cur.rowcount
		conn.commit()
		logger.info('Inserted %s rows into %s', rows_inserted, table_name)


	cur.close()
	conn.close()


if __name__ == '__main__':   
	main(control_id, ust_or_release)
