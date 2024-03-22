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
		element_id = row[1]



	cur.close()
	conn.close()



if __name__ == '__main__':
	print(convert_column_name('FacilityName'))