import os
from pathlib import Path
import sys
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

from python.util import utils


def find_bad_col_value():
	conn = utils.connect_db()
	cur = conn.cursor()

	sql = """select "FacilityID", "TankID", "CompartmentID" from de_ust.piping order by 1, 2, 3"""
	cur.execute(sql)
	rows = cur.fetchall()
	for row in rows:
		compartment_id = row[2]
		try:
			integer = int(compartment_id)
		except ValueError:
			print("""Bad row at "FacilityID" = '""" + row[0] + """' and "TankID" = '""" + str(row[1]) + """' and "CompartmentID" = '""" + compartment_id + "'")


	cur.close()
	conn.close()


find_bad_col_value()

