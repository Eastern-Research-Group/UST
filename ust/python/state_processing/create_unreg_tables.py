import os
from pathlib import Path
import string
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import psycopg2

from python.util import utils
from python.util.dataset import Dataset 
from python.util.logger_factory import logger


ust_or_release = ''                      # Valid values are 'ust' or 'release'
control_id = 0                          # Enter an integer that is the ust_control_id or release_control_id
organization_id = ''                      # Enter the two-character code for the state, or "TRUSTD" for the tribes database 
drop_existing = False                    # Boolean; defaults to False. If True, will drop existing tables if possible (will error if there are dependent objects). If False, will rename tables if they already exist. 
views_only = False                        # Boolean; defaults to False. If True, will not drop or create the "erg_unreg" tables and will only create/replace the "vw_erg" views related to this script.


class UnregTables:
    conn = None 
    cur = None 
    unreg_parent_table = None
    unreg_parent_col = None  
    unreg_substance_table = None 
    unreg_tank_table = None 
    epa_facility_table = None 
    org_facility_table = None 
    epa_substance_table = None 
    org_substance_table = None 
    erg_substance_mapping_view = 'vw_erg_substance_mapping'
    erg_facility_type_mapping_view = 'vw_erg_facility_type_mapping'
    erg_tank_size_view = 'vw_erg_tank_sizes'
    erg_unreg_subs_view = 'vw_erg_unreg_substances'

    def __init__(self, dataset, drop_existing=False, views_only=False):
        self.dataset = dataset
        self.drop_existing = drop_existing
        self.views_only = views_only
        self.set_variables()


    def set_variables(self):
        self.connect_db()

        if self.dataset.ust_or_release == 'release':
            self.unreg_parent_table = f'{self.dataset.schema}.erg_unregulated_releases'
            self.unreg_parent_col = 'release_id'
            self.unreg_substance_table = f'{self.dataset.schema}.erg_unregulated_substances'
            self.epa_facility_table = 'ust_release'
            self.epa_substance_table = 'ust_release_substance'
        else:
            self.unreg_parent_table = f'{self.dataset.schema}.erg_unregulated_facilities'
            self.unreg_parent_col = 'facility_id'
            self.unreg_substance_table = f'{self.dataset.schema}.erg_unregulated_tanks'
            self.epa_facility_table = 'ust_facility'
            self.epa_substance_table = 'ust_tank_substance'

        sql = f"""select distinct organization_table_name 
                  from public.{self.dataset.ust_or_release}_element_mapping 
                  where {self.dataset.ust_or_release}_control_id = %s
                  and epa_column_name like 'facility_type%%' and epa_table_name = %s"""
        utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id, self.epa_facility_table))
        self.org_facility_table = self.cur.fetchone()[0]

        sql = f"""select organization_table_name 
                  from public.{self.dataset.ust_or_release}_element_mapping 
                  where {self.dataset.ust_or_release}_control_id = %s
                  and epa_column_name = 'substance_id' and epa_table_name = %s"""
        utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id, self.epa_substance_table))
        self.org_substance_table = self.cur.fetchone()[0]

        self.disconnect_db()


    def connect_db(self):
        if not self.conn:
            self.conn = utils.connect_db()
            self.cur = self.conn.cursor()
            # logger.info('Connected to database')
        

    def disconnect_db(self):
        if self.conn:
            self.cur.close()
            self.conn.close()
            self.conn = None 
            # logger.info('Disconnected from database')


    def truncate_table(self, table):
        sql = f"truncate table {table}"
        utils.process_sql(self.conn, self.cur, sql)
        logger.info('Truncated table %s', table)


    def backup_table(self, table):
        backup_table = f'{table}_bkup_{utils.get_timestamp_str()}'
        sql = f"select * into {backup_table} from {table}"
        utils.process_sql(self.conn, self.cur, sql)
        logger.info('Created backup of table %s, named %s', table, backup_table)


    def drop_table(self, table):
        if self.views_only:
            return 

        if self.drop_existing:
            try:
                sql = f"drop table if exists {table}"
                self.cur.execute(sql)
                return True
            except psycopg2.errors.DependentObjectsStillExist as e:
                logger.warning('Table %s exists but it has dependencies, so creating a backup and truncating the original table instead of creating a new one. %s', table, e)
                self.backup_table(table)
                self.truncate_table(table)
                return False
        else:
            sql = """select count(*) from information_schema.tables 
                      where table_schema = %s and table_name = %s"""
            utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.schema, table.replace(self.dataset.schema + '.','')))
            cnt = self.cur.fetchone()[0]
            if cnt > 0:
                logger.warning('drop_tables = False but table %s already exists. Exiting...', table)
                self.disconnect_db()
                exit()


    def create_tables(self):
        if self.views_only:
            return

        self.connect_db()

        if self.drop_table(self.unreg_substance_table):
            tanksql = ""
            tanksql2 = ""
            if self.dataset.ust_or_release == 'ust':
                tanksql = "\ntank_id int not null,"
                tanksql2 = "tank_id, "
            sql = f"""create table {self.unreg_substance_table} 
                        ({self.unreg_parent_col} varchar(50) not null, {tanksql} 
                       organization_substance varchar(1000) not null,
                       substance_id int, 
                       epa_substance varchar(200), 
                       unregulated_reason varchar(1000),
                       primary key ({self.unreg_parent_col}, {tanksql2} organization_substance))"""
            utils.process_sql(self.conn, self.cur, sql)
            logger.info('Created table %s', self.unreg_substance_table)    

        if self.drop_table(self.unreg_parent_table):
            sql = f"""create table {self.unreg_parent_table} 
                        ({self.unreg_parent_col} varchar(50) not null primary key, 
                        unregulated_reason varchar(1000))"""
            utils.process_sql(self.conn, self.cur, sql)
            logger.info('Created table %s', self.unreg_parent_table)    

        self.disconnect_db()


    def create_substance_view(self):
        self.connect_db()

        view_name = f'{self.dataset.schema}.{self.erg_substance_mapping_view}'
        
        sql = f"""select count(*) from public.{self.dataset.ust_or_release}_element_mapping 
                  where {self.dataset.ust_or_release}_control_id = %s and epa_column_name = 'substance_id'"""
        utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id,))
        cnt = self.cur.fetchone()[0]
        if cnt == 0:
            logger.warning('No substances mapped; will not create %s', view_name)
            return 

        sql = f"""select epa_column_name,
                    case when deagg_column_name is not null then deagg_column_name else organization_column_name end as organization_column_name, 
                    case when deagg_table_name is not null then deagg_table_name else organization_table_name end as organization_table_name, 
                    organization_join_table, organization_join_column
                from public.{self.dataset.ust_or_release}_element_mapping a join public.v_{self.dataset.ust_or_release}_sort_order b 
                    on a.epa_table_name = b.table_name and a.epa_column_name = b.column_name 
                where {self.dataset.ust_or_release}_control_id = %s
                and epa_table_name = %s
                and epa_column_name in ('facility_id', 'tank_id', 'release_id', 'substance_id')
                order by b.column_sort_order"""
        utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id, self.epa_substance_table), print_sql=False)
        rows = self.cur.fetchall()

        epa_cols, org_cols, org_tables, org_join_tables, org_join_cols = map(list, zip(*rows))
        unique_org_tables = list(dict.fromkeys(org_tables))
        aliases = dict(zip(unique_org_tables, string.ascii_lowercase))
        # print(aliases)

        select_sql = "select "
        from_sql = f'\nfrom {self.dataset.schema}."{unique_org_tables[0]}" {aliases[unique_org_tables[0]]}'
        org_val_col = ''

        for i in range(0, len(epa_cols)):
            if epa_cols[i] == 'substance_id':
                org_val_col = f'{aliases[org_tables[i]]}."{org_cols[i]}"'
                col_alias = 'org_substance'
            else:
                col_alias = epa_cols[i]
            select_sql += f'{aliases[org_tables[i]]}."{org_cols[i]}" as {col_alias}, ' 
            if org_join_tables[i]:
                from_sql += f' join {self.dataset.schema}."{org_tables[i]}" {aliases[org_tables[i]]} '
                from_sql += f' on {aliases[org_join_tables[i]]}."{org_join_cols[i]}" = {aliases[org_tables[i]]}."{org_join_cols[i]}" '

        select_sql += ' s.substance as epa_substance, s.substance_id'
        from_sql += f'\nleft join (select organization_value, epa_value from public.v_{self.dataset.ust_or_release}_mapping where {self.dataset.ust_or_release}_control_id = %s and epa_table_name = %s) x on x.organization_value = {org_val_col} '
        from_sql += '\nleft join public.substances s on x.epa_value = s.substance'
        view_sql = f'create or replace view {view_name} as\n{select_sql}{from_sql} where {org_val_col} is not null'
        utils.process_sql(self.conn, self.cur, view_sql, params=(self.dataset.control_id, self.epa_substance_table))
        logger.info('Created view %s', view_name)

        self.disconnect_db()


    def create_facility_type_view(self):
        self.connect_db()

        view_name = f'{self.dataset.schema}.{self.erg_facility_type_mapping_view}'
        
        sql = f"""select count(*) from public.{self.dataset.ust_or_release}_element_mapping 
                  where {self.dataset.ust_or_release}_control_id = %s and epa_column_name like 'facility_type%%'"""
        utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id,))
        cnt = self.cur.fetchone()[0]
        if cnt == 0:
            logger.warning('No facility types mapped; will not create %s', view_name)
            return 

        sql = f"""select distinct replace(replace(epa_column_name,'1','_id'),'2','_id') as epa_column_name, 
                    organization_column_name, organization_table_name, organization_join_table, organization_join_column,
                    (epa_column_name ilike '%%type%%') as sort_order
                from public.{self.dataset.ust_or_release}_element_mapping 
                where {self.dataset.ust_or_release}_control_id = %s
                and epa_table_name = %s
                and epa_column_name in ('facility_id','facility_type1','facility_type2','release_id','facility_type_id')
                order by (epa_column_name ilike '%%type%%')"""
        utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id, self.epa_facility_table), print_sql=False)
        rows = self.cur.fetchall()

        epa_cols, org_cols, org_tables, org_join_tables, org_join_cols, nulls = map(list, zip(*rows))
        unique_org_tables = list(dict.fromkeys(org_tables))
        aliases = dict(zip(unique_org_tables, string.ascii_lowercase))

        select_sql = "select "
        from_sql = f'\nfrom {self.dataset.schema}."{unique_org_tables[0]}" {aliases[unique_org_tables[0]]}'
        org_val_col = ''

        for i in range(0, len(epa_cols)):
            if epa_cols[i] == 'facility_type_id':
                org_val_col = f'{aliases[org_tables[i]]}."{org_cols[i]}"'
                col_alias = 'org_facility_type'
            else:
                col_alias = epa_cols[i]
            select_sql += f'{aliases[org_tables[i]]}."{org_cols[i]}" as {col_alias}, ' 
            if org_join_tables[i]:
                from_sql += f' join {self.dataset.schema}."{org_tables[i]}" {aliases[org_tables[i]]} '
                from_sql += f' on {aliases[org_join_tables[i]]}."{org_join_cols[i]}" = {aliases[org_tables[i]]}."{org_join_cols[i]}" '

        select_sql += ' ft.facility_type as epa_facility_type, ft.facility_type_id'
        from_sql += f'\nleft join (select organization_value, epa_value from public.v_{self.dataset.ust_or_release}_mapping where {self.dataset.ust_or_release}_control_id = %s and epa_table_name = %s) x on x.organization_value = {org_val_col} '
        from_sql += '\nleft join public.facility_types ft on x.epa_value = ft.facility_type'
        view_sql = f'create or replace view {view_name} as\n{select_sql}{from_sql} where {org_val_col} is not null'
        utils.process_sql(self.conn, self.cur, view_sql, params=(self.dataset.control_id, self.epa_facility_table), print_sql=False)
        logger.info('Created view %s', view_name)

        self.disconnect_db()


    def create_tank_size_view(self):
        if self.dataset.ust_or_release == 'release':
            return

        self.connect_db()

        view_name = f'{self.dataset.schema}.{self.erg_tank_size_view}'

        sql = """select count(*) from public.ust_element_mapping 
              where ust_control_id = %s and epa_column_name = 'compartment_capacity_gallons'"""
        utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id,))
        cnt = self.cur.fetchone()[0]
        if cnt == 0:
            logger.warning('No compartment sizes available; will not create %s', view_name)
            return 

        sql = """select epa_column_name, organization_column_name, organization_table_name, organization_join_table, organization_join_column
                from public.ust_element_mapping a join public.v_ust_sort_order b 
                    on a.epa_table_name = b.table_name and a.epa_column_name = b.column_name 
                where ust_control_id = %s
                and epa_table_name = 'ust_compartment'
                and epa_column_name in ('facility_id', 'tank_id', 'compartment_capacity_gallons')
                order by b.column_sort_order"""
        utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id,), print_sql=False)
        rows = self.cur.fetchall()

        epa_cols, org_cols, org_tables, org_join_tables, org_join_cols = map(list, zip(*rows))
        unique_org_tables = list(dict.fromkeys(org_tables))
        aliases = dict(zip(unique_org_tables, string.ascii_lowercase))
        groupby_cols = [f'"{c}"' for c in epa_cols if c != 'compartment_capacity_gallons']

        select_sql = "select "
        from_sql = f'\nfrom {self.dataset.schema}."{unique_org_tables[0]}" {aliases[unique_org_tables[0]]}'
        groupby_sql = f'\ngroup by {', '.join(groupby_cols)}'

        for i in range(0, len(epa_cols)):
            select_col = f'{aliases[org_tables[i]]}."{org_cols[i]}"'
            if epa_cols[i] == 'compartment_capacity_gallons':
                select_sql += f'sum({select_col}) as tank_capacity_gallons'
            else:
                select_sql += f'{select_col} as {epa_cols[i]}, '
            if org_join_tables[i]:
                from_sql += f' join {self.dataset.schema}."{org_tables[i]}" {aliases[org_tables[i]]} '
                from_sql += f' on {aliases[org_join_tables[i]]}."{org_join_cols[i]}" = {aliases[org_tables[i]]}."{org_join_cols[i]}" '
        
        view_sql = f'create or replace view {view_name} as\n{select_sql}{from_sql}{groupby_sql}'
        utils.process_sql(self.conn, self.cur, view_sql, print_sql=False)
        logger.info('Created view %s', view_name)

        self.disconnect_db()


    def create_unreg_tank_view(self):
        self.connect_db()

        if not utils.get_table_existence(self.erg_substance_mapping_view, self.dataset.schema) or not utils.get_table_existence(self.erg_facility_type_mapping_view, self.dataset.schema):
            logger.warning('%s.%s and/or %s.%s do not exist, so unable to create view %s.%s', 
                           self.dataset.schema, self.erg_substance_mapping_view, 
                           self.dataset.schema, self.erg_facility_type_mapping_view,
                           self.dataset.schema, self.erg_unreg_subs_view)
            self.disconnect_db()
            return 

        if self.dataset.ust_or_release == 'ust':
            join_col = 'facility_id'
        else:
            join_col = 'release_id'
        sql = f"""select a.*, 'Heating oil' as unregulated_reason
                from {self.dataset.schema}.{self.erg_substance_mapping_view} a join {self.dataset.schema}.{self.erg_facility_type_mapping_view} b 
                    on a.{join_col} = b.{join_col}
                    join public.substances s on a.substance_id = s.substance_id
                where s.substance_group = 'Heating' and facility_type_id <> 4 --Bulk plant storage/petroleum distributor """
        
        if self.dataset.ust_or_release == 'ust' and utils.get_table_existence(self.erg_tank_size_view, self.dataset.schema):
            sql += f"""\nunion all
                        select a.*, 'Small tank at farm/residence' as unregulated_reason
                        from {self.dataset.schema}.{self.erg_substance_mapping_view} a join {self.dataset.schema}.{self.erg_facility_type_mapping_view} b 
                            on a.facility_id = b.facility_id
                            join public.substances s on a.substance_id = s.substance_id
                            join {self.dataset.schema}.{self.erg_tank_size_view} c on a.facility_id = c.facility_id and a.tank_id = c.tank_id
                        where s.substance_group in ('Diesel','Gasoline') 
                        and facility_type_id in (1, 12) --Agricultural/farm; Residential
                        and c.tank_capacity_gallons < 1100"""

        sql = f"create or replace view {self.dataset.schema}.{self.erg_unreg_subs_view} as\n{sql}"
        utils.process_sql(self.conn, self.cur, sql)
        logger.info('Created view %s.%s', self.dataset.schema, self.erg_unreg_subs_view)

        self.disconnect_db()


    def create_views(self):
        self.create_substance_view()
        self.create_facility_type_view()
        self.create_tank_size_view()
        self.create_unreg_tank_view()


    def execute(self):
        if not self.views_only:
            self.create_tables()
        self.create_views()


def main(ust_or_release, control_id=0, organization_id=None, drop_existing=False, views_only=False):
    if not control_id or control_id == 0:
        control_id = utils.get_control_id(ust_or_release, organization_id.upper())

    dataset = Dataset(ust_or_release=ust_or_release,
                      control_id=control_id,
                      requires_export=False)

    unreg = UnregTables(dataset, drop_existing=drop_existing, views_only=views_only)
    unreg.execute()



if __name__ == '__main__':   
    main(ust_or_release=ust_or_release,
         control_id=control_id,
         organization_id=organization_id,
         drop_existing=drop_existing,
         views_only=views_only)

