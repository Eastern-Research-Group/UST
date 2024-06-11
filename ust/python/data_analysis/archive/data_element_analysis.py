import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import pandas as pd

from python.util.logger_factory import logger
from python.util import config, utils 


def main(ust_or_lust):
	view_name = 'v_' + ust_or_lust.lower()

	df = pd.DataFrame(columns=['Column Name', 'Total Rows', 'Null Rows', 'Percent Null', 'States with Data'])

	conn = utils.connect_db()
	cur = conn.cursor()


	sql = f"select count(*) from {view_name}"
	cur.execute(sql)
	total_rows = cur.fetchone()[0]

	logger.info('Total number of rows in %s is %s', view_name, total_rows)

	sql = """select column_name 
			from information_schema.columns 
			where table_name = %s and table_schema = 'public'
			order by ordinal_position"""

	cur.execute(sql, (view_name,))
	rows = cur.fetchall()
	for row in rows:
		column_name = row[0]
		sql2 = f'select count(*) from {view_name} where "{column_name}" is null'
		cur.execute(sql2)
		null_rows = cur.fetchone()[0]
		percent_null = round((null_rows / total_rows)*100,4)
		states_with_data = '' 
		if total_rows > null_rows:
			sql3 = f'select distinct state from {view_name} where "{column_name}" is not null'
			cur.execute(sql3)
			rows3 = cur.fetchall()
			for row in rows3:
				states_with_data = states_with_data + row[0] + ', '
			states_with_data = states_with_data[:-2]
		logger.info('%s: Null rows = %s, Percent null = %s, States with data = %s', column_name, null_rows, percent_null, states_with_data)
		df.loc[len(df.index)] = [column_name, total_rows, null_rows, percent_null, states_with_data] 

	print(df)

	file_name = ust_or_lust.upper() + '_data_element_analysis_' + utils.get_today_string() + '.xlsx'
	file_path = config.local_ust_path + file_name 
	df.to_excel(file_path, index=False)

	cur.close()
	conn.close()




if __name__ == '__main__':
	ust_or_lust = 'lust'
	main(ust_or_lust.lower())