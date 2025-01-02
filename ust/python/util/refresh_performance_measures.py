r"""
The performance measure numbers are updated semi-annually and published
by OUST in a PDF. Use the following script to delete the previous
numbers from the database and replace with udpated numbers. 

Install Tabula (https://tabula.technology/) on PC and run. 
A browser tab will open. Use it to open the PDF, the select the UST table 
(it may span multiple pages). 
Use the tool to export to CSV, then open the CSV and clean it up to 
remove the Region subtotals and column, and any other mis-alignments, etc.
Delete any non-integer data (ex: "DNA") and leave null instead. 
Repeat for the LUST table. Save both CSVs to the ../imports folder
(or elsewhere). 
Then run the script below to insert into the database.
"""

import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import numpy as np
import pandas as pd

from python.util import utils
from python.util.logger_factory import logger


ust_path = '../imports/perf_measures_ust.csv'
releases_path = '../imports/perf_measures_releases.csv'


def get_df(csv_path):
	df = pd.read_csv(csv_path)
	df.columns = [c.replace('\r', '_').replace(' ','_') for c in df.columns]
	return df 


def convert_int(val):
	int_val = None 
	try:
		int_val = int(val)
	except ValueError:
		pass  
	return int_val


def insert_ust(csv_path):
	df = get_df(csv_path)
	df = df.rename(columns={'State': 'organization_id', 
		                    'Number_of_Active_Petroleum_UST_Systems': 'num_active_petroleum_ust',
		                    'Number_of_Closed_Petroleum_UST_Systems': 'num_closed_petroleum_ust',
		                    'Number_of_Active_Hazardous_Substance_UST_Systems': 'num_active_hazmat_ust',
		                    'Number_of_Closed_Hazardous_Substance_UST_Systems': 'num_closed_hazmat_ust',
		                    'Total_Active_UST_Systems': 'total_active_ust',
		                    'Total_Closed_UST_Systems': 'total_closed_ust'})
	df = df.replace({',':''}, regex=True)

	conn = utils.connect_db()
	cur = conn.cursor()
	sql = "delete from public.performance_measures_ust"
	cur.execute(sql)
	logger.info('Deleted %s rows from performance_measures_ust', cur.rowcount)

	i = 0
	for index, row in df.iterrows():
		organization_id = row['organization_id']
		num_active_petroleum_ust = convert_int(row['num_active_petroleum_ust'])
		num_closed_petroleum_ust = convert_int(row['num_closed_petroleum_ust'])
		num_active_hazmat_ust = convert_int(row['num_active_hazmat_ust'])
		num_closed_hazmat_ust = convert_int(row['num_closed_hazmat_ust'])
		total_active_ust = convert_int(row['total_active_ust'])
		total_closed_ust = convert_int(row['total_closed_ust'])
		total_ust = total_active_ust + total_closed_ust

		sql = "insert into public.performance_measures_ust values (%s, %s, %s, %s, %s, %s, %s, %s)"
		cur.execute(sql, (organization_id, num_active_petroleum_ust, num_closed_petroleum_ust, 
						  num_active_hazmat_ust, num_closed_hazmat_ust, total_active_ust, total_closed_ust, total_ust))
		i += 1

	conn.commit()
	logger.info('Inserted %s rows into performance_measures_ust', i)
	cur.close()
	conn.close()
	


def insert_releases(csv_path):
	df = get_df(csv_path)
	df.drop(columns=['Confirmed_Releases_Actions_This_Period','Cleanups_Completed_Actions_This_Period'])
	df = df.rename(columns={'State': 'organization_id', 
		                    'Confirmed_Releases_Cumulative': 'num_cumulative_releases',
		                    'Cleanups_Initiated_Cumulative': 'num_cumulative_initiated_cleanups',
		                    'Cleanups_Completed_Cumulative': 'num_cumulative_completed_cleanups',
		                    'Cleanups_Backlog': 'num_cleanups_backlog'})
	df = df.replace({',':''}, regex=True)

	conn = utils.connect_db()
	cur = conn.cursor()
	sql = "delete from public.performance_measures_release"
	cur.execute(sql)
	logger.info('Deleted %s rows from performance_measures_release', cur.rowcount)

	i = 0
	for index, row in df.iterrows():
		organization_id = row['organization_id']
		num_cumulative_releases = convert_int(row['num_cumulative_releases'])
		num_cumulative_initiated_cleanups = convert_int(row['num_cumulative_initiated_cleanups'])
		num_cumulative_completed_cleanups = convert_int(row['num_cumulative_completed_cleanups'])
		num_cleanups_backlog = convert_int(row['num_cleanups_backlog'])

		sql = "insert into public.performance_measures_release values (%s, %s, %s, %s, %s)"
		cur.execute(sql, (organization_id, num_cumulative_releases, num_cumulative_initiated_cleanups, 
						  num_cumulative_completed_cleanups, num_cleanups_backlog))
		i += 1

	conn.commit()
	logger.info('Inserted %s rows into performance_measures_release', i)
	cur.close()
	conn.close()


if __name__ == '__main__':   
	# insert_ust(ust_path)
	insert_releases(releases_path)





r"""
Below is an attempt to programmitcally extract the table using tabula-py, using a
JSON template generated using the browser version of Tabula, but the 
line calling read_pdf_with_template runs for a while and then the script ends. 

To set up your machine to be able to run this script:

1) Download 64-bit Java (note: 32-bit is the default and won't work unless your python installation is 32-bit!)
2) Set environmental variable JAVA_HOME = the path to java.exe (up to "java.exe", ex.: C:\Program Files (x86)\Common Files\Oracle\Java\java8path\)
   You can do a "where java" on the cmd line to get this path. 
3) Install the python libraries:
pip install tabula-py[jpype]
pip install tabulate
"""

## THIS DOES NOT WORK FOR UNKNOWN REASONS

# from tabula import read_pdf_with_template
# from tabulate import tabulate

# df = read_pdf_with_template('../imports/fy-2024-mid-year-report-may-2024_0.pdf', '../imports/tabula-fy-2024-mid-year-report-may-2024_0.json')
# print(df)

# print(tabulate(df))



