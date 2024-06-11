import sys
import os
sys.path = [os.path.join(os.path.dirname(__file__), "..", "..")] + sys.path
from ust.python.util.logger_factory import logger
from ust.python.util import config, utils


def main():
	conn = utils.connect_db(config.db_name)
	cur = conn.cursor()

	sql = """select element_id, database_column_name from release_elements 
			where database_column_name not in ('substance_released',
												'quantity_released',
												'unit',
												'source_of_release',
												'cause_of_release',
												'corrective_action_strategy',
												'corrective_action_strategy_start_date')
			order by element_id"""
	cur.execute(sql)
	rows = cur.fetchall()
	i = 1
	for row in rows:
		sql2 = "insert into release_elements_tables (element_id, table_name, sort_order) values (%s, %s, %s)"
		cur.execute(sql2, (row[0], 'ust_release', i))
		conn.commit()
		i += 1


	sql = """select element_id, database_column_name from release_elements 
			where database_column_name in ('substance_released',
											'quantity_released',
											'unit')
			order by element_id"""
	cur.execute(sql)
	rows = cur.fetchall()
	i = 1
	for row in rows:
		sql2 = "insert into release_elements_tables (element_id, table_name, sort_order) values (%s, %s, %s)"
		cur.execute(sql2, (row[0], 'ust_release_substance', i))
		conn.commit()
		i += 1


	sql = """select element_id, database_column_name from release_elements 
			where database_column_name in ('source_of_release')
			order by element_id"""
	cur.execute(sql)
	rows = cur.fetchall()
	i = 1
	for row in rows:
		sql2 = "insert into release_elements_tables (element_id, table_name, sort_order) values (%s, %s, %s)"
		cur.execute(sql2, (row[0], 'ust_release_source', i))
		conn.commit()
		i += 1


	sql = """select element_id, database_column_name from release_elements 
			where database_column_name in ('cause_of_release')
			order by element_id"""
	cur.execute(sql)
	rows = cur.fetchall()
	i = 1
	for row in rows:
		sql2 = "insert into release_elements_tables (element_id, table_name, sort_order) values (%s, %s, %s)"
		cur.execute(sql2, (row[0], 'ust_release_cause', i))
		conn.commit()
		i += 1


	sql = """select element_id, database_column_name from release_elements 
			where database_column_name in ('corrective_action_strategy',
											'corrective_action_strategy_start_date')
			order by element_id"""
	cur.execute(sql)
	rows = cur.fetchall()
	i = 1
	for row in rows:
		sql2 = "insert into release_elements_tables (element_id, table_name, sort_order) values (%s, %s, %s)"
		cur.execute(sql2, (row[0], 'ust_release_corrective_action_strategy', i))
		conn.commit()
		i += 1


	cur.close()
	conn.close()




if __name__ == '__main__':       
	main()

