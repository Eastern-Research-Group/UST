import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

from python.util import utils
from python.util.dataset import Dataset 
from python.util.logger_factory import logger


ust_or_release = 'ust' 			  # The only valid value for this script is 'ust' because it is not needed for releases! 
control_id = 11                   # Enter an integer that is the ust_control_id


class IdColums:
	def __init__(self, 
				 dataset):
		self.dataset = dataset
		self.table_name = table_name 
		self.create_tables()


	def create_tables(self):
		conn = utils.connect_db()
		cur = conn.cursor()

		sql = f"""select a.table_name, a.column_name 
				from public.ust_required_view_columns a join public.ust_template_data_tables b on a.table_name = b.table_name  
				where auto_create = 'Y' and not exists 
					(select 1 from public.ust_element_mapping c
					where ust_control_id = %s and a.table_name = c.epa_table_name and a.column_name = c.epa_column_name)
				and (a.table_name = 'ust_compartment' or exists 
					(select 1 from public.ust_element_mapping c
					where ust_control_id = %s and a.table_name = c.epa_table_name))
				order by sort_order"""
		cur.execute(sql, (self.dataset.control_id, self.dataset.control_id, ))v
		rows = cur.fetchall()
		for row in rows:
			table_name = row[0]
			column_name = row[1]

			if table_name == 'ust_tank':
				erg_table_name = self.dataset.schema + '.erg_tank_id'
				sql2 = f"create table {erg_table_name} (facility_id varchar(50), tank_name varchar(200), tank_id int generated always as identity)"
				sql2 = cur.execute(sql2)

				sql2 = """select epa_column_name, organization_table_name, organization_column_name 
						from public.ust_element_mapping 
						where ust_control_id = %s and epa_table_name = 'ust_tank' and epa_column_name in ('facility_id','tank_name')
						order by 1"""
				cur.execute(sql2, (self.dataset.control_id,))
				rows2 = cur.fetchall()
				select_cols = None
				tank_name = False
				for row2 in rows2:
					epa_column_name = row2[0]
					organization_table_name = row2[1]
					organization_column_name = row2[2]
					select_cols = select_cols + '"' + organization_column_name + '",'
					if epa_column_name == 'tank_name':
						tank_name = True
				select_cols = select_cols[:-1]
				 f"insert into {self.dataset.schema}.erg_tank_id (facility_id"
				if tank_name:
					insert_sql = insert_sql + ', tank_name'
				insert_sql = insert_sql + ') select distinct ' + select_cols + ' from ' + self.dataset.schema + '."' + organization_table_name + '"'
				cur.execute(insert_sql)
				logger.info('Inserted %s rows into %s', cur.rowcount, erg_table_name)

			elif table_name == 'ust_compartment':
				erg_table_name = self.dataset.schema + '.erg_compartment_id'
				sql2 = f"create table {erg_table_name} (facility_id varchar(50), tank_name varchar(200), tank_id int, compartment_name varchar(200), compartment_id generated always as identity)"
				sql2 = cur.execute(sql2)
				



# ust_tank	tank_id
# ust_compartment	compartment_id
# ust_piping	piping_id
# ust_facility_dispenser	dispenser_id
# ust_tank_dispenser	dispenser_id
# ust_compartment_dispenser	dispenser_id


		cur.close()
		conn.close()


def main(ust_or_release, control_id):
	dataset = Dataset(ust_or_release=ust_or_release,
				 	  control_id=control_id,
				 	  requires_export=False)

	columns = IdColums(dataset=dataset, 
		               table_name=table_name, 
		               drop_existing=drop_existing)




if __name__ == '__main__':   
	main(ust_or_release=ust_or_release,
		 control_id=control_id)

