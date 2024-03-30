import sys
import os
sys.path = [os.path.join(os.path.dirname(__file__), "..", "..")] + sys.path
from ust.util.logger_factory import logger
from ust.util import utils, config
from ust.state_processing import find_dupes
import psycopg2.errors


def main():
	conn = utils.connect_db()
	cur = conn.cursor()


	cur.close()
	conn.close()


if __name__ == '__main__':
	main()
	
