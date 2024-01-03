import utils
from logger_factory import logger, error_logger
import pandas as pd
import os
import zipfile


file_path = r'C:\Users\erguser\OneDrive - Eastern Research Group\Other Projects\UST\UST Finder\Exports\\'
subfolder = r'Tanks Export\\'
file_name = 'tanks.csv'

def main(query):

	conn = utils.connect_db()
	cur = conn.cursor()		

	df = pd.read_sql(query, utils.get_engine(schema='ust_finder_prod'))
	df.to_csv(file_path + subfolder + file_name, index=False)

	cur.close()
	conn.close()


if __name__ == '__main__':   
	query = """select f."Facility_ID", f."Name", f."Address", f."City", f."State", f."Zip_Code",
					t."Tank_ID", t."Tank_Status", t."Capacity"
				from facilities f join usts t on f."Facility_ID" = t."Facility_ID"
				order by f."Facility_ID", t."Tank_ID" """
	main(query)

