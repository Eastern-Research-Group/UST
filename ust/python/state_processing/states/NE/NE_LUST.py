import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

from python.util import utils



def create_holding_table():
	conn = utils.connect_db()
	cur = conn.cursor()

	sql = """select column_name from information_schema.columns 
	         where table_schema = 'NE_LUST' and table_name = 'lust'
	         order by ordinal_position"""
	cur.execute(sql)
	rows = cur.fetchall()

	populated_cols = []
	for row in rows:
		sql2 = f'select count(*) from "NE_LUST".lust where "{row[0]}" is not null'
		cur.execute(sql2)
		cnt = cur.fetchone()[0]
		if cnt > 0:
			print(row[0])
			populated_cols.append(row[0])

	table_sql = 'create table "NE_LUST".ne_lust ("LUSTID" varchar(50), '
	for col in populated_cols:
		if col == 'Latitude' or col == 'Longitude' or col == 'EPARegion':
			table_sql = table_sql + '"' + col + '" float,'
		else:
			table_sql = table_sql + '"' + col + '" text,'
	table_sql = table_sql[:-1] + ')'
	cur.execute(table_sql)

	cur.close()
	conn.close()


def populate_holding_table():
	conn = utils.connect_db()
	cur = conn.cursor()

	sql = """select '"' || column_name || '", ' as col_name
	         from information_schema.columns 
			 where table_schema = 'NE_LUST' and table_name = 'ne_lust'
			 and column_name <> 'LUSTID'
	         order by ordinal_position"""
	cur.execute(sql)
	rows = cur.fetchall()

	sql = """insert into "NE_LUST".ne_lust
		select case when "SiteName" is not null then 'NE_' || substring("SiteName",1,40) || '_' || nextval('"NE_LUST".seq_lustid')
				     when "FacilityID" is not null then 'NE_' || substring("FacilityID",1,40) || '_' || nextval('"NE_LUST".seq_lustid')
				     when "SiteAddress" is not null then 'NE_' || substring("SiteAddress",1,40) || '_' || nextval('"NE_LUST".seq_lustid')
				     else 'NE_' || nextval('"NE_LUST".seq_lustid') end as "LUSTID", """
	for row in rows:
		sql = sql + row[0]
	sql = sql[:-2] + ' from "NE_LUST".lust'
	print(sql)

	cur.execute(sql)
	conn.commit()

	cur.close()
	conn.close()

if __name__ == '__main__':
	# create_holding_table()
	populate_holding_table()