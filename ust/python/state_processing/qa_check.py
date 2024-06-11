import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))
from datetime import datetime

import psycopg2.errors

from python.util.logger_factory import logger
from python.util import utils



def main():
	conn = utils.connect_db()
	cur = conn.cursor()


	cur.close()
	conn.close()


if __name__ == '__main__':
	main()
	
