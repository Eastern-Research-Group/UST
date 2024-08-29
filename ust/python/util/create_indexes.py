from datetime import date
import ntpath
import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

from python.util import utils
from python.util.logger_factory import logger


def lookups():
	conn = utils.connect_db()
	cur = conn.cursor()

	sql = """select table_name from information_schema.tables 
			where table_schema = 'public' 
			and table_name not like 'release%' and table_name not like 'ust%' 
			and table_name <> 'states' 
			and table_name not like 'v_%'
			order by 1"""
	cur.execute(sql)
	rows = cur.fetchall()
	for row in rows:
		table_name = row[0]
		index_name = table_name + '_idx'

		sql2 = """select column_name from information_schema.columns 
				where table_schema = %s and table_name = %s
				and ordinal_position = 2"""
		cur.execute(sql2, ('public', table_name))
		column_name = cur.fetchone()[0]

		sql2 = f"create index {index_name} on public.{table_name}({column_name})"
		cur.execute(sql2)
		logger.info('Created index %s on %s.%s', index_name, table_name, column_name)

	cur.close()
	conn.close()


def data_tables():
	conn = utils.connect_db()
	cur = conn.cursor()

	sql = """select distinct a.table_name, a.column_name 
			from information_schema.columns a left join pg_indexes b 
				on a.table_schema = b.schemaname and a.table_name = b.tablename 
			where a.table_schema = 'public' 
			and (a.table_name like 'release%' or a.table_name like 'ust%')
			and a.column_name like '%_id' 
			and b.indexdef not like '%' || a.column_name || '%'
			order by 1, 2"""
	cur.execute(sql)
	rows = cur.fetchall()
	for row in rows:
		table_name = row[0]
		column_name = row[1]
		index_name = table_name + '_' + column_name + '_idx'
		sql2 = f"create index {index_name} on public.{table_name}({column_name})"
		cur.execute(sql2)
		logger.info('Created index %s on %s.%s', index_name, table_name, column_name)

	cur.close()
	conn.close()



if __name__ == '__main__':  
	# lookups()
	data_tables()