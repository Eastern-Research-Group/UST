from datetime import date
import ntpath
import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

from python.util import utils
from python.util.logger_factory import logger




def main():
	conn = utils.connect_db()
	cur = conn.cursor()

	sql = "select distinct organization_id from ust_control order by 1"
	cur.execute(sql)
	current_states = [r[0] for r in cur.fetchall()]
	logger.info('Current states are: %s', current_states)


	sql = """select table_schema, table_name, column_name
			from information_schema.columns
			where table_schema not like 'pg%%' and table_schema not like 'info%%'
			and table_schema <> 'public' and table_schema not like '%%ast'
			and lower(column_name) like '%%cas%%'
			and lower(column_name) not like '%%case%%'
			and table_schema not like 'trustd%%' and table_schema not like 'or%%'
			and table_schema not like 'sc%%' and table_schema not like 'mo%%'
			and table_name not like 'v_%%'
			and table_schema like '%%ust'
			order by table_schema, table_name, column_name;"""
	cur.execute(sql)
	rows = cur.fetchall()
	for row in rows:
		table_schema = row[0]
		table_name = row[1]
		column_name = row[2]

		sql = f'select count(*) from {table_schema}."{table_name}" where "{column_name}" is not null'
		cur.execute(sql)
		cnt = cur.fetchone()[0]
		if cnt > 0:
			logger.info('%s."%s"."%s": %s', table_schema, table_name, column_name, cnt)

			sql = f'select distinct "{column_name}" from {table_schema}."{table_name}" where "{column_name}" is not null order by 1'
			cur.execute(sql)
			rows2 = cur.fetchall()
			for row2 in rows2:
				state = table_schema[:2].upper()
				if state not in current_states:
					continue
				casno = row2[0]
				sql = f"insert into state_hazardous_substances (state, casno) values (%s, %s)"
				cur.execute(sql, (state, casno))

	conn.commit()
	cur.close()
	conn.close()



if __name__ == '__main__':   
	main()