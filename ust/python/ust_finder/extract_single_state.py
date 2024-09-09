import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import pandas as pd

from python.util import utils
from python.util.logger_factory import logger

path_to_facilities = r'C:/Users/erguser/Downloads/facilities.csv'
path_to_tanks = r'C:/Users/erguser/Downloads/tanks.csv' 
export_path = r'C:/Users/erguser/Downloads/'


def get_states(file_path, print=False):
	df = pd.read_csv(file_path, low_memory=False)
	df.sort_values(by=['State'], inplace=True)
	states = df['State'].unique().tolist()
	if print:
		for state in states:
			print(state)
	return states 


def extract_state(state_name):
	if state_name not in get_states(path_to_facilities):
		logger.error('Invalid state: %s. For a list of valid states, run get_states([file_path], print=True)', state_name)
	
	logger.info('Working on facilities...')
	df = pd.read_csv(path_to_facilities, low_memory=False)
	logger.info('There are %s total rows in the facilities CSV file', len(df))
	df = df.loc[df['State'] == state_name]
	logger.info('There are %s rows in facilities for %s', len(df), state_name)
	export_file_path = export_path + state_name + '_facilities.csv'
	df.to_csv(export_file_path, index=False)
	logger.info('Facilities exported to %s', export_file_path)

	logger.info('Working on tanks...')
	df = pd.read_csv(path_to_tanks, low_memory=False)
	logger.info('There are %s total rows in the tanks CSV file', len(df))
	df = df.loc[df['State'] == state_name]
	logger.info('There are %s rows in tanks for %s', len(df), state_name)
	export_file_path = export_path + state_name + '_tanks.csv'
	df.to_csv(export_file_path, index=False)
	logger.info('Tanks exported to %s', export_file_path)

	logger.info('Export complete')


if __name__ == '__main__':
	# get_states(path_to_facilities, print=True)
	extract_state('Massachusetts')	