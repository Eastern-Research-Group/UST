from logger_factory import logger
import utils


def main():
	conn = utils.connect_db()
	cur = conn.cursor()


	cur.close()
	conn.close()


if __name__ == '__main__':
	main()