import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))
from datetime import date
import ntpath

from python.util.logger_factory import logger
from python.util import utils, config


ust_or_release = 'release' # valid values are 'ust' or 'release'
control_id = 2
table_name = ''
column_name = ''


def main(control_id, ust_or_release)
	conn = utils.connect_db()
	

	conn = utils.connect_db(db_name)
	cur = conn.cursor()	

	cur.close()
	conn.close()

	logger.info('')



def main(control_id, ust_or_release, table_name, column_name):
	pass

if __name__ == '__main__':   
	main(control_id=control_id, 
		 ust_or_release=ust_or_release, 
		 table_name=table_name, 
		 column_name=column_name)
