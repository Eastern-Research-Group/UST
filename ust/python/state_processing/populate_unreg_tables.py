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
        if cnt > 0:
            return True 
        return False 


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
            if self.delete_auto_inserts:
                self.delete_existing_auto_inserts()
            else:
                UnregTables(self.dataset, drop_existing=self.delete_all).execute()


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
        if self.dataset.ust_or_release == 'ust':
            tanksql = 'tank_id, '
            pk_col = 'facility_id'
        sql = f"""insert into {self.unreg.unreg_substance_table} 
                select distinct {pk_col}, {tanksql}org_substance, substance_id, epa_substance, 'Non-regulated substance'
                from {self.dataset.schema}.{self.unreg.erg_substance_mapping_view}
                where substance_id is null and org_substance is not null and org_substance <> '' 
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
        if self.dataset.ust_or_release == 'ust':
            tanksql = 'tank_id, '
            pk_col = 'facility_id'
        sql = f"""insert into {self.unreg.unreg_substance_table} 
                select distinct {pk_col}, {tanksql}org_substance, substance_id, epa_substance, unregulated_reason
                from {self.dataset.schema}.{self.unreg.erg_unreg_subs_view}
                where org_substance is not null and org_substance <> '' 
                and {pk_col} not in (select {pk_col} from {self.unreg.unreg_parent_table})
                on conflict do nothing"""
        utils.process_sql(self.conn, self.cur, sql)
        logger.info('Inserted %s rows into %s due to unregulated heating oil', self.cur.rowcount, self.unreg.unreg_substance_table)
        self.disconnect_db() 


    def insert_parents(self):
        self.connect_db()
        
        extrajoinsql = ""
        if self.dataset.ust_or_release == 'ust':
            extrajoinsql = "\nand v.tank_id::int = eus.tank_id::int "

        sql = f"""insert into {self.unreg.unreg_parent_table}
                 select v.{self.unreg.unreg_parent_col}, string_agg(distinct eus.unregulated_reason, '; ' order by eus.unregulated_reason) as unregulated_reason
                 from {self.dataset.schema}.{self.unreg.erg_substance_mapping_view} v
                    join {self.unreg.unreg_substance_table} eus 
                 on v.{self.unreg.unreg_parent_col}::varchar(50) = eus.{self.unreg.unreg_parent_col}::varchar(50) {extrajoinsql} 
                 and v.org_substance::varchar(1000) = eus.organization_substance::varchar(1000)
                 where not exists (
                     select 1
                     from {self.dataset.schema}.{self.unreg.erg_substance_mapping_view} v2
                     where v2.{self.unreg.unreg_parent_col}::varchar(50)  = v.{self.unreg.unreg_parent_col}::varchar(50) 
                     and not exists (
                         select 1
                         from {self.unreg.unreg_substance_table} eus
                         where eus.{self.unreg.unreg_parent_col}::varchar(50)  = v2.{self.unreg.unreg_parent_col}::varchar(50) {extrajoinsql.replace('v.','v2.')} 
                        and v2.org_substance::varchar(1000) = eus.organization_substance::varchar(1000)  
                    )
                  )
                 group by v.{self.unreg.unreg_parent_col}
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
        self.create_tables()
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

