import sys
import os
sys.path = [os.path.join(os.path.dirname(__file__), "..", "..")] + sys.path
from ust.util.logger_factory import logger
from ust.util import utils


def convert_column_name(col_name):
	new_col_name = ''
	for char in col_name:
		if char.isupper():
			new_col_name += '_' + char.lower()
		else:
			new_col_name += char 
	new_col_name = new_col_name[1:]
	new_col_name = new_col_name.replace('_i_d','_id')
	new_col_name = new_col_name.replace('u_d_c','udc')
	new_col_name = new_col_name.replace('e_p_a','epa')
	new_col_name = new_col_name.replace('u_s_t','ust')
	new_col_name = new_col_name.replace('f_r_p','frp')
	new_col_name = new_col_name.replace('c_a_s_n_o','casno')
	return new_col_name


def main():
	conn = utils.connect_db()
	cur = conn.cursor()

	sql = """select element_id, element_name
			 from ust_elements order by element_id"""

	cur.execute(sql)
	rows = cur.fetchall()
	for row in rows:
		element_id = row[0]
		element_name = row[1]
		db_col_name = convert_column_name(element_name)
		if db_col_name in ('facility_id','tank_id','compartment_id','piping_id'):
			db_col_name = 'org_' + db_col_name
		sql2 = "update ust_elements set database_column_name = %s where element_id = %s"
		cur.execute(sql2, (db_col_name, element_id))
		conn.commit()
		logger.info('Set database_column_name to %s for %s', db_col_name, element_name)

	cur.close()
	conn.close()



if __name__ == '__main__':
	# print(convert_column_name('DispenserUDC
	main()