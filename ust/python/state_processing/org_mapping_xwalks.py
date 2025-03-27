import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

from python.util import utils
from python.util.dataset import Dataset 
from python.util.logger_factory import logger


ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = 36                  # Enter an integer that is the ust_control_id or release_control_id


def main(dataset):
	conn = utils.connect_db()
	cur = conn.cursor()
	logger.info('Connected to database')

	sql = f"""select epa_column_name, organization_table_name, organization_column_name,
					database_lookup_table, database_lookup_column 
			from public.v_{dataset.ust_or_release}_table_population 
			where {dataset.ust_or_release}_control_id = %s and database_lookup_table is not null
			order by table_sort_order, column_sort_order"""
	utils.process_sql(conn, cur, sql, params=(control_id,))
	rows = cur.fetchall()
	for row in rows:
		epa_column_name = row[0]
		database_lookup_table = row[3]
		database_lookup_column = row[4]
		view_name = dataset.schema + '.v_' + database_lookup_column + '_xwalk'
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
				from public.v_{dataset.ust_or_release}_element_mapping a left join {database_lookup_table} b on a.epa_value = b.{database_lookup_column}
				where a.{dataset.ust_or_release}_control_id = %s and a.epa_column_name = %s"""
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
	logger.info('Disconnected from database')




if __name__ == '__main__':   
	dataset = Dataset(ust_or_release=ust_or_release,
				 	  control_id=control_id,
				 	  requires_export=False)

	main(dataset)

	
