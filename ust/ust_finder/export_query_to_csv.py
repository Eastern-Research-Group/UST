import sys
import os
sys.path = [os.path.join(os.path.dirname(__file__), "..", "..")] + sys.path
from ust.util import utils
from ust.util.logger_factory import logger, error_logger
import pandas as pd
import zipfile
from pathlib import Path


file_path = r'C:\Users\erguser\OneDrive - Eastern Research Group\Other Projects\UST\UST Finder\Exports\\'
subfolder = r'Tanks Export\\'
file_name = 'tanks.csv'
full_path = file_path + subfolder + file_name

def zip_file():
	zip_file_path = full_path + r'\UST Finder export.zip'
	with ZipFile(zip_file_path, 'w') as zf:
	    zf.write(full_path, compress_type=compression)
	logger.info('Zip file saved to %s', zip_file_path)


def main(query):
	Path(file_path + subfolder).mkdir(parents=True, exist_ok=True)

	conn = utils.connect_db()
	cur = conn.cursor()		

	logger.info('Query = %s', query)
	logger.info('Preparing to export')
	try:
		df = pd.read_sql(query, utils.get_engine(schema='ust_finder_prod'))
	except Exception as e:
		logger.error('Unable to export query to a dataframe. Error message: %s', e)
	logger.info('Query exported to dataframe')
	try:
		df.to_csv(full_path, index=False)
	except Exception as e:
		logger.error('Unable to export query results to CSV. Error message: %s', e)
	logger.info('Export complete')

	cur.close()
	conn.close()

	zip_file()

if __name__ == '__main__':   
	query = """select f."Facility_ID", f."Name", f."Address", f."City", f."State", f."Zip_Code",
					t."Tank_ID", t."Tank_Status", t."Capacity"
				from facilities f join usts t on f."Facility_ID" = t."Facility_ID"
				order by f."Facility_ID", t."Tank_ID" """
	main(query)

