from ust.python.state_processing.create_unreg_tables import UnregTables
from ust.python.util import utils
from ust.python.util.dataset import Dataset
from ust.python.util.logger_factory import logger

ust_or_release = ''             # Valid values are 'ust' or 'release'
control_id = 0                  # Enter an integer that is the ust_control_id or release_control_id
organization_id = ''              # Optional; if control_id = 0 or None, will find the most recent control_id
delete_auto_inserts = False      # Boolean, defaults to False. If True, will delete existing rows from erg_unregulated% tables where unregulated_reason is "Non-regulated substance", "Heating oil", or "Small tank at farm/residence". Set to False to skip the delete (will likely cause errors if this script has been run before.)
delete_all = False                 # Boolean, defaults to False. CAUTION! If True, will delete all existing rows from erg_unregulated% tables, INCLUDING any inserted by means other this script. 

class Unregulated:
    conn = None 
    cur = None 

    def __init__(self, dataset, delete_auto_inserts=False, delete_all=False):
        self.dataset = dataset
        self.delete_auto_inserts = delete_auto_inserts
        self.delete_all = delete_all 
        self.unreg = UnregTables(self.dataset)
        self.data_type = 'facilities'
        if self.dataset.ust_or_release == 'release':
            self.data_type = 'releases'


    def check_for_substances(self):
        self.connect_db()
        sql = f"""select count(*) from public.v_{self.dataset.ust_or_release}_mapping
                  where {self.dataset.ust_or_release}_control_id = %s and epa_column_name = 'substance_id'"""
        utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id,))
        cnt = self.cur.fetchone()[0]
        self.disconnect_db()        
        return cnt > 0


    @staticmethod
    def _quote_identifier(identifier):
        return '"' + identifier.replace('"', '""') + '"'


    @staticmethod
    def _quote_literal(value):
        return "'" + value.replace("'", "''") + "'"


    def check_missing_substance_mappings(self):
        self.connect_db()
        mapping_sql = f"""select {self.dataset.ust_or_release}_element_mapping_id,
                                  organization_table_name,
                                  organization_column_name,
                                  deagg_table_name,
                                  deagg_column_name
                           from public.{self.dataset.ust_or_release}_element_mapping
                           where {self.dataset.ust_or_release}_control_id = %s
                             and epa_table_name = 'ust_tank_substance'
                             and epa_column_name = 'substance_id'"""
        utils.process_sql(self.conn, self.cur, mapping_sql, params=(self.dataset.control_id,))
        mapping = self.cur.fetchone()
        if not mapping:
            self.disconnect_db()
            raise RuntimeError('Missing substance_id mapping for ust_tank_substance.')

        mapping_id, source_table, source_column, deagg_table, deagg_column = mapping
        source_table = deagg_table or source_table
        source_column = deagg_column or source_column
        source_relation = f'{self.dataset.schema}.{self._quote_identifier(source_table)}'
        source_field = self._quote_identifier(source_column)
        missing_sql = f"""select distinct trim({source_field}::text) as organization_value
                          from {source_relation}
                          where nullif(trim({source_field}::text), '') is not null
                            and not exists (
                                select 1
                                from public.{self.dataset.ust_or_release}_element_value_mapping value_mapping
                                where value_mapping.{self.dataset.ust_or_release}_element_mapping_id = %s
                                  and value_mapping.organization_value = trim({source_field}::text)
                            )
                          order by organization_value"""
        utils.process_sql(self.conn, self.cur, missing_sql, params=(mapping_id,))
        missing_values = [row[0] for row in self.cur.fetchall()]
        self.disconnect_db()

        if not missing_values:
            return

        insert_sql = '\n'.join(
            f'insert into public.{self.dataset.ust_or_release}_element_value_mapping '
            f'({self.dataset.ust_or_release}_element_mapping_id, organization_value, epa_value, programmer_comments)\n'
            f'values ({mapping_id}, {self._quote_literal(value)}, \'\', null);'
            for value in missing_values
        )
        raise RuntimeError(
            f'Found {len(missing_values)} unmapped substance value(s) in '
            f'{self.dataset.schema}.{source_table}.{source_column}: {", ".join(missing_values)}.\n\n'
            'Add an EPA value to each statement below, run the statements, then rerun populate-unreg:\n\n'
            f'{insert_sql}'
        )


    def create_tables(self):
        self.connect_db()
        sql = "select count(*) from information_schema.tables where table_schema = %s and table_name like 'erg_unregulated%%'"
        utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.schema,))
        cnt = self.cur.fetchone()[0]
        self.disconnect_db()
        if cnt == 0:
            logger.warning('ERG Unregulated tables do not exist; creating....')
            UnregTables(self.dataset, drop_existing=False).execute()
        else:
            if self.delete_all:
                logger.warning('ERG Unregulated tables already exist; recreating because delete_all=True.')
                UnregTables(self.dataset, drop_existing=True).execute()
            else:
                logger.info('ERG Unregulated tables already exist; reusing existing tables.')


    def refresh_unreg_views(self):
        logger.info('Refreshing unregulated helper views for %s control_id=%s.', self.dataset.schema, self.dataset.control_id)
        UnregTables(self.dataset, drop_existing=False, views_only=True).execute()


    def log_unreg_source_counts(self):
        self.connect_db()
        source_objects = [
            self.unreg.erg_substance_mapping_view,
            self.unreg.erg_facility_type_mapping_view,
            self.unreg.erg_tank_size_view,
            self.unreg.erg_unreg_subs_view,
        ]
        for obj in source_objects:
            if not utils.get_table_existence(obj, self.dataset.schema):
                logger.warning('Missing helper view %s.%s', self.dataset.schema, obj)
                continue
            sql = f'select count(*) from {self.dataset.schema}.{obj}'
            utils.process_sql(self.conn, self.cur, sql)
            cnt = self.cur.fetchone()[0]
            logger.info('Rows in %s.%s: %s', self.dataset.schema, obj, cnt)
        self.disconnect_db()


    def delete_existing_auto_inserts(self):
        if not self.delete_auto_inserts:
            return 
        tables = [self.unreg.unreg_substance_table, self.unreg.unreg_parent_table]
        unreg_reasons = ['Non-regulated substance', 'Heating oil', 'Small tank at farm/residence']
        self.connect_db()
        for table in tables:
            sql = f"delete from {table} where unregulated_reason = any(array{unreg_reasons})"
            utils.process_sql(self.conn, self.cur, sql, print_sql=True)
            logger.info('Deleted %s rows from %s', self.cur.rowcount, table)
        self.disconnect_db()


    def insert_nonregulated_substances(self):
        self.connect_db()
        if not utils.get_table_existence(self.unreg.erg_substance_mapping_view, self.dataset.schema):
            logger.warning('No view %s.%s found; will not insert non-regulated substances', self.dataset.schema, self.unreg.erg_substance_mapping_view)
            self.disconnect_db()
            return 
        tanksql = ''
        pk_col = 'release_id'
        tank_id_filter = ''
        if self.dataset.ust_or_release == 'ust':
            tanksql = 'tank_id, '
            pk_col = 'facility_id'
            tank_id_filter = 'and tank_id is not null'
        sql = f"""insert into {self.unreg.unreg_substance_table} 
                select distinct {pk_col}, {tanksql}org_substance, substance_id, epa_substance, 'Non-regulated substance'
                from {self.dataset.schema}.{self.unreg.erg_substance_mapping_view}
                where substance_id is null and org_substance is not null and org_substance <> '' 
                {tank_id_filter}
                and {pk_col} not in (select {pk_col} from {self.unreg.unreg_parent_table})
                on conflict do nothing"""
        utils.process_sql(self.conn, self.cur, sql)
        logger.info('Inserted %s rows into %s with reason "Non-regulated substance"', self.cur.rowcount, self.unreg.unreg_substance_table)
        self.disconnect_db()


    def insert_unregulated_tanks(self):
        self.connect_db()
        if not utils.get_table_existence(self.unreg.erg_unreg_subs_view, self.dataset.schema):
            logger.warning('%s.%s does not exist; unable to insert unregistered tanks into %s.%s', 
                           self.dataset.schema, self.unreg.erg_unreg_subs_view, 
                           self.dataset.schema, self.unreg.unreg_substance_table)
            self.disconnect_db()
            return 
        tanksql = ''
        pk_col = 'release_id'
        tank_id_filter = ''
        if self.dataset.ust_or_release == 'ust':
            tanksql = 'tank_id, '
            pk_col = 'facility_id'
            tank_id_filter = 'and tank_id is not null'
        sql = f"""insert into {self.unreg.unreg_substance_table} 
                select distinct {pk_col}, {tanksql}org_substance, substance_id, epa_substance, unregulated_reason
                from {self.dataset.schema}.{self.unreg.erg_unreg_subs_view}
                where org_substance is not null and org_substance <> '' 
                {tank_id_filter}
                and {pk_col} not in (select {pk_col} from {self.unreg.unreg_parent_table})
                on conflict do nothing"""
        utils.process_sql(self.conn, self.cur, sql)
        logger.info('Inserted %s rows into %s due to unregulated heating oil', self.cur.rowcount, self.unreg.unreg_substance_table)
        self.disconnect_db() 


    def insert_parents(self):
        self.connect_db()

        source_tank_col = ''
        if self.dataset.ust_or_release == 'ust':
            source_tank_col = ', tank_id::int as tank_id'

        def source_join(source_alias):
            if self.dataset.ust_or_release == 'ust':
                return (
                    f'{source_alias}.facility_id = eus.{self.unreg.unreg_parent_col} '
                    f'and {source_alias}.tank_id = eus.tank_id '
                )
            return f'{source_alias}.facility_id = eus.{self.unreg.unreg_parent_col} '

        sql = f"""with source_substances as materialized (
                    select {self.unreg.unreg_parent_col}::varchar(50) as facility_id
                           {source_tank_col},
                           org_substance::varchar(1000) as organization_substance
                    from {self.dataset.schema}.{self.unreg.erg_substance_mapping_view}
                    where org_substance is not null and org_substance <> ''
                 ),
                 fully_unregulated_parents as (
                    select s.facility_id
                    from source_substances s
                    group by s.facility_id
                    having not exists (
                        select 1
                        from source_substances candidate
                        where candidate.facility_id = s.facility_id
                          and not exists (
                              select 1
                              from {self.unreg.unreg_substance_table} eus
                                                            where {source_join('candidate')}
                                and candidate.organization_substance = eus.organization_substance
                          )
                    )
                 )
                 insert into {self.unreg.unreg_parent_table}
                 select s.facility_id,
                        string_agg(distinct eus.unregulated_reason, '; ' order by eus.unregulated_reason)
                 from source_substances s
                 join fully_unregulated_parents p on p.facility_id = s.facility_id
                 join {self.unreg.unreg_substance_table} eus
                                     on {source_join('s')}
                  and s.organization_substance = eus.organization_substance
                 group by s.facility_id
                 on conflict do nothing"""
        
        utils.process_sql(self.conn, self.cur, sql, print_sql=False)
        logger.info('Inserted %s rows into %s', self.cur.rowcount, self.unreg.unreg_parent_table)

        self.disconnect_db()


    def execute(self):
        if not self.check_for_substances():
            logger.info('No substance data for %s %s, no need to check for unregulated %s.', self.dataset.organization_id, utils.get_pretty_ust_or_release(self.dataset.ust_or_release), self.data_type)
            raise RuntimeError(
                f'No substance mapping data found for {self.dataset.organization_id} '
                f'{utils.get_pretty_ust_or_release(self.dataset.ust_or_release)}; '
                f'unregulated {self.data_type} processing cannot continue.'
            )
        self.check_missing_substance_mappings()
        self.create_tables()
        self.refresh_unreg_views()
        self.delete_existing_auto_inserts()
        self.insert_nonregulated_substances()
        self.insert_unregulated_tanks()
        self.insert_parents()


    def connect_db(self):
        if not self.conn:
            self.conn = utils.connect_db()
            self.cur = self.conn.cursor()
        

    def disconnect_db(self):
        if self.conn:
            self.cur.close()
            self.conn.close()
            self.conn = None 




def main(ust_or_release, control_id=0, organization_id=None, delete_auto_inserts=delete_auto_inserts, delete_all=delete_all):
    if not control_id or control_id == 0:
        control_id = utils.get_control_id(ust_or_release, organization_id.upper())

    dataset = Dataset(ust_or_release=ust_or_release,
                       control_id=control_id,
                       requires_export=False)

    u = Unregulated(dataset, delete_auto_inserts=delete_auto_inserts, delete_all=delete_all)
    u.execute()


if __name__ == '__main__':   
    main(ust_or_release=ust_or_release,
         control_id=control_id,
         organization_id=organization_id,
         delete_auto_inserts=delete_auto_inserts,
         delete_all=delete_all)

