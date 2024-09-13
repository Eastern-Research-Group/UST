import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

from python.util import utils
from python.util.dataset import Dataset 
from python.util.logger_factory import logger


ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = 11                 # Enter an integer that is the ust_control_id or release_control_id
table_name = 'ust_facility'     # Enter EPA table name we are writing the view to populate. 
drop_existing = False           # Boolean, defaults to False. Set to True to drop the view if it exists before creating it new. 


class ViewSql:
	view_name = None 
	view_sql = None  

	def __init__(self, 
				 dataset,
				 table_name,
				 drop_existing=False):
		self.dataset = dataset
		self.table_name = table_name 
		self.drop_existing = drop_existing
		self.generate_sql()


	def generate_sql(self):
		conn = utils.connect_db()
		cur = conn.cursor()

		self.view_name = 'v_' + self.table_name
		sql = """select count(*) from information_schema.tables 
		         where table_schema = %s and table_name = %s and table_type = 'VIEW'"""
		cur.execute(sql, (self.dataset.schema, self.view_name))
		cnt = cur.fetchone()[0]
		if cnt > 0 and self.drop_existing:
			sql = f"drop view {self.dataset.schema}.{view_name}"
			cur.execute(sql)
			logger.info('Dropped existing view %s.%s', self.dataset.schema, view_name)
		elif cnt > 0:
			logger.warning('View %s.%s already exists. Set variable drop_existing = True to drop it before creating a new one. Exiting...', self.dataset.schema, view_name)

		sql = f"""select a.column_name, a.data_type, a.character_maximum_length, ordinal_position  
				from information_schema.columns a join public.{self.dataset.ust_or_release}_required_view_columns b 
					on a.table_name = b.table_name and a.column_name = b.column_name
				where table_schema = 'public' and a.table_name = %s 
				and b.column_name not in 
					(select epa_column_name from public.v_{self.dataset.ust_or_release}_table_population_sql
					where {self.dataset.ust_or_release}_control_id = %s and epa_table_name = %s)
				order by ordinal_position"""
		cur.execute(sql, (self.table_name, self.dataset.control_id, self.table_name))
		req_col_info = cur.fetchall()
		req_col_ids = [c[3] for c in req_col_info]
		req_cols = {}
		for req_col in req_col_info:
			column_id = req_col[3]
			column_name = req_col[0]
			data_type = req_col[1]
			character_maximum_length = req_col[2]
			req_cols[column_id] = {'column_name': column_name, 'data_type': data_type, 'character_maximum_length':character_maximum_length}

		sql = f"""select epa_column_name, 
				   data_type, character_maximum_length,
				   organization_table_name, organization_column_name,
				   selected_column, 
				   organization_join_table, organization_join_column, 
				   database_lookup_table, database_lookup_column,
				   deagg_table_name, deagg_column_name,
				   column_sort_order
			from public.v_{self.dataset.ust_or_release}_table_population_sql
			where {self.dataset.ust_or_release}_control_id = %s and epa_table_name = %s
			order by column_sort_order """
		cur.execute(sql, (self.dataset.control_id, self.table_name))
		existing_col_info = cur.fetchall()
		if not existing_col_info:
			logger.warning('No elements have been mapped for EPA table %s. Exiting...', self.table_name)
			cur.close()
			conn.close()
			exit()
		existing_col_ids = [c[12] for c in existing_col_info]
		existing_cols = {}
		for existing_col in existing_col_info:
			column_id = existing_col[12]
			column_name = existing_col[0]
			selected_column = existing_col[5]
			existing_cols[column_id] = {'column_name': column_name, 'selected_column': selected_column}

		req_col_ids = [n for n in req_col_ids if n not in existing_col_ids]
		all_col_ids = sorted(req_col_ids + existing_col_ids)

		self.view_sql = f'create view {self.dataset.schema}.{self.view_name} as 	\nselect distinct\n'

		region_next = False 
		for i in range(len(all_col_ids)):
			if region_next:
				epa_region = None 
				selected_column = str(utils.get_epa_region(self.dataset.organization_id)) + '::integer as facility_epa_region,'
				self.view_sql = self.view_sql + '\t' + selected_column + '\n'
				region_next = False

			column_id = all_col_ids[i]
			# print('Working on column_id ' + str(column_id))
			if all_col_ids[i] in existing_col_ids:	
				epa_column_name = existing_cols[column_id]['column_name']
				logger.info('Working on column %s', epa_column_name)
				selected_column = existing_cols[column_id]['selected_column']
			else:
				epa_column_name = req_cols[column_id]['column_name']
				logger.info('Working on column %s', epa_column_name)
				data_type = req_cols[column_id]['data_type']
				character_maximum_length = req_cols[column_id]['character_maximum_length']
				org_col = '??'
				if epa_column_name == 'facility_state':
					org_col = f"'{self.dataset.organization_id}'"
					if self.dataset.ust_or_release == 'ust' and self.table_name == 'ust_facility' and 13 not in existing_col_ids:
						region_next = True
				selected_column = org_col + '::' + utils.get_datatype_sql(data_type, character_maximum_length) + ' as ' + epa_column_name + ','
			self.view_sql = self.view_sql + '\t' + selected_column + '\n'
		self.view_sql = self.view_sql[:-2] + '\nfrom '

		sql = f"""select * from (
					  select distinct organization_table_name table_name, 'org_table' as table_type, 1 as sort_order
					  from public.v_{self.dataset.ust_or_release}_table_population_sql
			          where {self.dataset.ust_or_release}_control_id = %s and epa_table_name = %s 
			          union all 
			          select distinct deagg_table_name, 'deagg_table' as table_type, 2 as sort_order  
			          from public.v_{self.dataset.ust_or_release}_table_population_sql
			          where {self.dataset.ust_or_release}_control_id = %s and epa_table_name = %s 
			          union all 
			          select distinct organization_join_table, 'join_table' as table_type, 3 as sort_order  
			          from public.v_{self.dataset.ust_or_release}_table_population_sql
			          where {self.dataset.ust_or_release}_control_id = %s and epa_table_name = %s 
			          union all 
			          select distinct database_lookup_table, 'lookup_table' as table_type, 4 as sort_order  
			          from public.v_{self.dataset.ust_or_release}_table_population_sql
			          where {self.dataset.ust_or_release}_control_id = %s and epa_table_name = %s) x
		          where table_name is not null 
		          order by sort_order"""
		cur.execute(sql, (self.dataset.control_id, self.table_name, self.dataset.control_id, self.table_name, self.dataset.control_id, self.table_name, self.dataset.control_id, self.table_name))
		rows = cur.fetchall()
		aliases = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']
		i = 0 
		from_sql = ''
		first_org_table = True
		for row in rows:
			from_table_name = row[0]
			from_table_type = row[1]
			logger.info('Working on from_table_name %s, which is a %s', from_table_name, from_table_type)
			alias = aliases[i]
			if from_table_type == 'org_table':
				if not first_org_table:
					from_sql = from_sql + ' left join '				
				from_sql = from_sql + self.dataset.schema + '.' + '"' + from_table_name + '" ' + alias + '\n'
				if not first_org_table:
					from_sql = from_sql + ' on ' + aliases[i-1] + '."???"' + aliases + '."???"\n'
				else:
					first_org_table = False
			elif from_table_type == 'deagg_table':
				sql2 = f"""select deagg_column_name, organization_column_name from public.v_{self.dataset.ust_or_release}_table_population_sql
				           where {self.dataset.ust_or_release}_control_id = %s and epa_table_name = %s and deagg_table_name = %s """
				cur.execute(sql2, (self.dataset.control_id, self.table_name, from_table_name))
				cols = cur.fetchone()
				deagg_column_name = cols[0]
				organization_column_name = cols[1]
				from_sql = from_sql + '\tjoin ' + self.dataset.schema + '.' + from_table_name + ' ' + alias + ' on a."' + organization_column_name + '" = ' + alias + '."' + deagg_column_name + '"\n'
			elif from_table_type == 'left join_table': 
				sql2 = f"""select organization_join_column, organization_column_name from public.v_{self.dataset.ust_or_release}_table_population_sql
				           where {self.dataset.ust_or_release}_control_id = %s and epa_table_name = %s and organization_join_table = %s """
				cur.execute(sql2, (self.dataset.control_id, self.table_name, from_table_name))			
				cols = cur.fetchone()
				join_column_name = cols[0]
				organization_column_name = cols[1]
				from_sql = from_sql + '\tleft join ' + self.dataset.schema + '."' + from_table_name + '" ' + alias + ' on a."' + organization_column_name + '" = ' + alias + '."' + join_column_name + '"\n'
			elif from_table_type == 'lookup_table':
				sql2 = f"""select database_lookup_column, organization_column_name from public.v_{self.dataset.ust_or_release}_table_population_sql
				           where {self.dataset.ust_or_release}_control_id = %s and epa_table_name = %s and database_lookup_table = %s """
				cur.execute(sql2, (self.dataset.control_id, self.table_name, from_table_name))
				cols = cur.fetchone()
				database_lookup_column = cols[0]
				organization_column_name = cols[1]
				xwalk_view_name = 'v_' + database_lookup_column + '_xwalk'
				if database_lookup_column == 'facility_type1' or database_lookup_column == 'facility_type2':
					database_lookup_column == 'facility_type_id'
				from_sql = from_sql + '\tleft join ' + self.dataset.schema + '.' + xwalk_view_name + ' ' + alias + ' on a."' + organization_column_name + '" = ' + alias + '.organization_value\n'
			i += 1
		self.view_sql = self.view_sql + from_sql[:-1] + ';\n'
		# print(self.view_sql)

		cur.close()
		conn.close()

		return self.view_sql 


def main(ust_or_release, control_id, table_name, drop_existing):
	dataset = Dataset(ust_or_release=ust_or_release,
				 	  control_id=control_id,
				 	  requires_export=False)

	sql = ViewSql(dataset=dataset, 
		          table_name=table_name, 
		          drop_existing=drop_existing)

	print(sql.view_sql)


if __name__ == '__main__':   
	main(ust_or_release=ust_or_release,
		 control_id=control_id,
		 table_name=table_name,
		 drop_existing=drop_existing)
