import utils

from psycopg2.errors import DuplicateDatabase

conn = utils.connect_db()
cur = conn.cursor()

sql = "create database pust"
try:
	cur.execute(sql)
except DuplicateDatabase:
	pass