from logger_factory import logger
import utils
import find_dupes

import psycopg2.errors




def main():
	conn = utils.connect_db()
	cur = conn.cursor()


	cur.close()
	conn.close()


if __name__ == '__main__':
	main()
	
