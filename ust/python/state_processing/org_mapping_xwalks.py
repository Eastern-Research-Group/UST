import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))
from datetime import datetime

from python.util.logger_factory import logger
from python.util import utils


ust_or_release = 'ust' # valid values are 'ust' or 'release'
control_id = 11


def main(control_id, ust_or_release):
	ust_or_release = ust_or_release.lower()
	schema = utils.get_schema_from_control_id(control_id, ust_or_release)

	conn = utils.connect_db()
	cur = conn.cursor()

	pop_view_name = 'v_' + ust_or_release.lower() + '_table_population '
	control_id_col = ust_or_release.lower() + '_control_id'
	sql = f"""select epa_column_name, organization_table_name, organization_column_name,
					database_lookup_table, database_lookup_column 
			from {pop_view_name} 
			where {control_id_col} = %s and database_lookup_table is not null
			order by table_sort_order, column_sort_order"""
	cur.execute(sql, (control_id, ))
	rows = cur.fetchall()
	for row in rows:
		epa_column_name = row[0]
		database_lookup_table = row[3]
		database_lookup_column = row[4]
		view_name = schema + '.v_' + database_lookup_column + '_xwalk'
		if epa_column_name == 'facility_type1' or epa_column_name == 'facility_type2':
			epa_column_name2 = 'facility_type_id'
		else:
			epa_column_name2 = epa_column_name

		# print('epa_column_name = ' + epa_column_name)
		# print('database_lookup_table = ' + database_lookup_table)
		# print('database_lookup_column = ' + database_lookup_column)
		# print('view_name = ' + view_name)

		sql = f"""create or replace view {view_name} as 
				select a.organization_value, a.epa_value, b.{epa_column_name2}
				from v_{ust_or_release}_element_mapping a left join {database_lookup_table} b on a.epa_value = b.{database_lookup_column}
				where a.{control_id_col} = %s and a.epa_column_name = %s"""
		# print(sql)
		try:
			cur.execute(sql, (control_id, epa_column_name))
		except:
			sql2 = f"drop view {view_name}"
			cur.execute(sql2)
			cur.execute(sql, (control_id, epa_column_name))

		logger.info('Created view %s', view_name)

	cur.close()
	conn.close()


if __name__ == '__main__':
	main(control_id, ust_or_release)
	
