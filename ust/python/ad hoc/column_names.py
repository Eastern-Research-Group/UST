import sys
import os
sys.path = [os.path.join(os.path.dirname(__file__), "..", "..")] + sys.path
from ust.python.util.logger_factory import logger
from ust.python.util import utils


table_name = 'ust_elements'

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
	new_col_name = new_col_name.replace('n_f_a','nfa')
	new_col_name = new_col_name.replace('u_r_l','url')
	new_col_name = new_col_name.replace('u_s_t','ust')
	new_col_name = new_col_name.replace('f_r_p','frp')
	new_col_name = new_col_name.replace('do_d','dod')
	new_col_name = new_col_name.replace('c_a_s_n_o','casno')
	return new_col_name


def main():
	conn = utils.connect_db()
	cur = conn.cursor()

	sql = f"""select element_id, element_name
			 from {table_name} order by element_id"""

	cur.execute(sql)
	rows = cur.fetchall()
	for row in rows:
		element_id = row[0]
		element_name = row[1]
		db_col_name = convert_column_name(element_name)
		if db_col_name in ('facility_id','tank_id','compartment_id','piping_id','ust_release_id'):
			db_col_name = 'org_' + db_col_name
		sql2 = f"update {table_name} set database_column_name = %s where element_id = %s"
		cur.execute(sql2, (db_col_name, element_id))
		conn.commit()
		logger.info('Set database_column_name to %s for %s', db_col_name, element_name)

	cur.close()
	conn.close()



if __name__ == '__main__':
	main()