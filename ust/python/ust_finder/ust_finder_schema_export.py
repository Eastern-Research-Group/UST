import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import pandas as pd
import zipfile

from python.util import config, utils
from python.util.logger_factory import logger


file_path = r'C:\Users\erguser\OneDrive - Eastern Research Group\Other Projects\UST\UST Finder\Exports\\'

def zip_files():
	files = os.listdir(file_path)
	compression = zipfile.ZIP_DEFLATED
	with zipfile.ZipFile(file_path + 'UST Finder exports.zip', mode='w') as zf:
		for file in files:
			zf.write(file_path + file, file, compress_type=compression)


def export_table(table_name):
	logger.info('Beginning export for %s', table_name)

	conn = utils.connect_db()
	cur = conn.cursor()		

	sql = """select column_name from information_schema.columns
	         where table_schema = 'ust_finder' and table_name = %s
	         and column_name like '%%ID%%' 
	         order by ordinal_position"""
	cur.execute(sql, (table_name, ))
	rows = cur.fetchall()
	sort_cols = ['"' + r[0] + '"' for r in rows]
	sort = ', '.join(sort_cols)
	if sort:
		sort = ', ' + sort
	
	sql = f"select * from ust_finder.{table_name} order by organization_id {sort}"
	print(sql)
	df = pd.read_sql(sql, utils.get_engine(schema='ust_finder'))

	file_name = table_name + '.csv'
	df.to_csv(file_path + file_name, index=False)

	cur.close()
	conn.close()

	logger.info('Export complete for %s', table_name)


def main():
	# export_table('ust_finder_facility_popup');
	# export_table('ust_finder_tank_pie');
	# export_table('ust_finder_ust_popup');
	# export_table('ust_finder_lust_popup');
	# export_table('ust_finder_facility_attribute');
	# export_table('ust_finder_lust_attribute');
	zip_files()



if __name__ == '__main__':   
	main()


