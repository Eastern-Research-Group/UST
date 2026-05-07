import os
from pathlib import Path
import sys
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import pandas as pd

from python.util import utils
from python.util.logger_factory import logger


upload_file_path = r"C:\Users\erguser\OneDrive - Eastern Research Group\Projects\UST\Chemical List 40CFR302-2024-12-12.xlsx"
schema = 'public'
table_name = 'chemical_list' 
overwrite_existing = False 


def upload(upload_file_path, schema, table_name, overwrite_existing=False):
	conn = utils.connect_db()
	cur = conn.cursor()

	df = pd.read_excel(upload_file_path)   
	engine = utils.get_engine(schema=schema)    
	if overwrite_existing:    
		df.to_sql(table_name, engine, index=False, if_exists='replace')
		logger.info('Created table %s', table_name)
	else:
		try:
			df.to_sql(table_name, engine, index=False)
			logger.info('Created table %s', table_name)       
		except error as e:
			logger.error('Unable to load file: %s', e)

	cur.close()
	conn.close()


if __name__ == '__main__':   
	upload(upload_file_path, schema, table_name, overwrite_existing)

