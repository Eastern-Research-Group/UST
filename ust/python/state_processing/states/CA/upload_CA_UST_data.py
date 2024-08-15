import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import glob
import pandas as pd

from python.util.logger_factory import logger
from python.util import utils, config



def export_data_to_csv(file_path, first_file):
	logger.info('Working on %s', file_path)
	fac_df = pd.read_excel(file_path, sheet_name='UST Facility Info', skiprows=2)
	fac_df.columns = [c.replace('\n', '_') for c in fac_df.columns]
	if first_file:
		fac_df.to_csv('exports/facility.csv', mode='w', index=False, header=True)
	else:
		fac_df.to_csv('exports/facility.csv', mode='a', index=False, header=False)
	logger.info('Facilities saved')

	tank_df = pd.read_excel(file_path, sheet_name='UST Tank & Monitoring Plan Info', skiprows=2)
	tank_df.columns = [c.replace('\n', '_') for c in tank_df.columns]
	if first_file:
		tank_df.to_csv('exports/tank.csv', mode='w', index=False, header=True)
	else:
		tank_df.to_csv('exports/tank.csv', mode='a', index=False, header=False)
	logger.info('Tanks saved')


def combine_files():
	first_file = True
	for file in glob.glob('data_files/*.xlsx'):
		export_data_to_csv(file, first_file)
		first_file = False 
	logger.info('Finished combining Excel files to CSVs')


def main():
	pass


if __name__ == '__main__':       
	combine_files()

