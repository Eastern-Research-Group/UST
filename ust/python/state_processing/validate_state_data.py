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
	if ust_or_release not in ['ust','release']:
		logger.error('Invalid value %s for ust_or_release. Valid values are ust or release. Exiting...', ust_or_release)
		exit()

	schema = utils.get_schema_from_control_id(control_id, ust_or_release)

	conn = utils.connect_db()
	cur = conn.cursor()

	sql = f"select view_name from {ust_or_release}_template_data_tables order by sort_order"
	cur.execute(sql)
	rows = cur.fetchall()
	for row in rows:
		view_name = row[0]
		table_name = view_name.replace('v_','')


		sql2 = f"""select b.column_name, b.data_type, b.character_maximum_length, a.data_type, a.character_maximum_length  
				from information_schema.columns a join information_schema.columns b on a.column_name = b.column_name 
				where a.table_schema = '{schema}' and a.table_name = %s
				and b.table_schema = 'public' and b.table_name = %s
				order by b.ordinal_position """
		cur.execute(sql2, (view_name, table_name))
		rows2 = cur.fetchall()

		for row2 in rows2:
			column_name = row2[0]			
			date_type = row2[1]
			max_length = row2[2]

			if data_type == 'character varying':
				sql3 = ""



	cur.close()
	conn.close()


if __name__ == '__main__':   
	main(control_id, ust_or_release)
