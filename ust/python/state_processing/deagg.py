
from ust.python.state_processing.deagg_rows import deaggRows
from ust.python.util import utils
from ust.python.util.dataset import Dataset
from ust.python.util.logger_factory import logger

# THIS SCRIPT DEAGGREGATES SINGLE COLUMN LOOKUP VALUES (for example, SUBSTANCES)
# USE deagg_rows.py TO CREATE DEAGG TABLES AT THE FACILITY/TANK/COMPARTMENT LEVEL
# THAT USE THE TABLES THIS SCRIPT CREATES

ust_or_release = ''             # Valid values are 'ust' or 'release'
control_id = 0                  # Enter an integer that is the ust_control_id or release_control_id
data_table_name = ''             # Enter a string containing organization table name
column_name = ''                # Enter a string containing organization column name
delimiters =  [', ']            # List of delimiters; defaults to [', ']. Put the most prevelant first. Put characters padded by spaces in list before those without spaces. Use '\n' for hard returns.
exclude_values = []                # Python list. Values that contain the delimiter but should not be deaggregated
drop_existing = True             # Boolean, defaults to False. If True will drop existing deagg table with the same name
deagg_rows = False                # Boolean, defaults to True. If True will automatically execute the deagg_rows.py scripts after executing this script.


class Deagg:
    conn = None  
    cur = None  
    nonagged = 0

    def __init__(self, 
                 dataset,
                 data_table_name,
                 column_name,
                 delimiters,
                 exclude_values=None,
                 drop_existing=False,
                 deagg_rows=True):
        self.dataset = dataset
        self.data_table_name = data_table_name 
        self.column_name = column_name 
        self.delimiters = utils.string_to_list(delimiters)
        self.exclude_values = exclude_values
        self.drop_existing = drop_existing 
        self.deagg_rows = deagg_rows
        self.deagg_table_name = utils.get_deagg_table_name(column_name)
        self.id_column_name = self.deagg_table_name + '_id'


    def connect_db(self):
        if not self.conn:
            self.conn = utils.connect_db()
            self.cur = self.conn.cursor()
            logger.info('Connected to database')


    def disconnect_db(self):
        if self.conn:
            self.conn.commit()
            self.cur.close()
            self.conn.close()
            self.conn = None 
            logger.info('Disconnected from database')


    def create_deagg_table(self):
        # delimiter = self.delimiters[0]

        control_table_name = self.dataset.ust_or_release.lower() + '_control'
        control_column_name = control_table_name + '_id'
        sql = f"""select organization_id from public.{control_table_name} 
                 where {control_column_name} = %s"""
        utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id,))
        logger.info('Deagg table name = %s', self.deagg_table_name)

        sql = """select count(*) from information_schema.tables 
                 where table_schema = %s and table_name = %s"""
        utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.schema, self.deagg_table_name))

        cnt =  self.cur.fetchone()[0]
        if cnt > 0 and self.drop_existing:
            sql = f"drop table {self.dataset.schema}.{self.deagg_table_name}"
            utils.process_sql(self.conn, self.cur, sql)
            logger.info('Dropped existing table %s', self.deagg_table_name)
        elif cnt > 0 and not self.drop_existing:
            logger.warning('Table %s.%s already exists. To drop and replace, pass drop_existing=True to this function. Exiting...', self.dataset.schema, self.deagg_table_name)
            self.disconnect_db()
            raise RuntimeError(
                f'Table {self.dataset.schema}.{self.deagg_table_name} already exists; rerun with drop_existing=True to replace it.'
            )

        sql = f"""create table {self.dataset.schema}.{self.deagg_table_name}
             ({self.id_column_name} int not null generated always as identity primary key,
             "{self.column_name}" text,
             constraint {self.deagg_table_name}_unique unique ("{self.column_name}"))"""
        utils.process_sql(self.conn, self.cur, sql)
        logger.info('Created table %s.%s with primary key %s', self.dataset.schema, self.deagg_table_name, self.id_column_name) 


    def insert_nonagged(self):
        like_delimiters = ['%' + d + '%' for d in self.delimiters]
        sql = f"""insert into {self.dataset.schema}.{self.deagg_table_name} ("{self.column_name}") 
                  select distinct "{self.column_name}" from {self.dataset.schema}.{self.data_table_name}
                  where "{self.column_name}" is not null and "{self.column_name}" not like all(%s)
                  on conflict("{self.column_name}") do nothing"""
        utils.process_sql(self.conn, self.cur, sql, params=(like_delimiters,))
        self.nonagged = self.cur.rowcount
        logger.info('Inserted %s non-aggregated rows', self.nonagged)
        

    def deagg(self, delimiter):
        logger.info('Working on delimiter "%s"', delimiter)
        n = 1
        extrawheresql = ""
        params = None 
        if self.exclude_values:
            extrawheresql = f' and "{self.column_name}" <> any(%s) '
            params = (self.exclude_values,)

        sql = f"""select distinct "{self.column_name}" from {self.dataset.schema}."{self.data_table_name}" 
                  where "{self.column_name}" is not null and "{self.column_name}" like '%%{delimiter}%%'
                  {extrawheresql}
                  order by 1"""
        utils.process_sql(self.conn, self.cur, sql, params=params, print_sql=False)
        rows = self.cur.fetchall()
        for row in rows:
            col_text = row[0]
            logger.info('Working on %s', col_text)    
            col_text = col_text.strip()
            if col_text in self.exclude_values:
                logger.info('%s is in exclude_values, ignoring...', col_text)
                continue
            parts = col_text.split(delimiter)
            for part in parts:
                sql2 = f"""insert into {self.dataset.schema}.{self.deagg_table_name} ("{self.column_name}") 
                           values (%s) on conflict("{self.column_name}") do nothing"""
                utils.process_sql(self.conn, self.cur, sql2, params=(part.strip(),))
                n += self.cur.rowcount
        self.conn.commit()
        logger.info('Finished deagging %s."%s"."%s" for delimiter "%s" into %s; inserted %s rows', self.dataset.schema, self.data_table_name, self.column_name, delimiter, self.deagg_table_name, n)

        if self.data_table_name.startswith('erg_') and self.data_table_name.endswith('_deagg'):
            sql = f"""delete from {self.dataset.schema}.{self.data_table_name} 
                      where "{self.column_name}" like '%%{delimiter}%%' 
                      and "{self.column_name}" <> any(%s)"""
            utils.process_sql(self.conn, self.cur, sql, params=(self.exclude_values,))
            logger.info('Deleted %s existing rows in %s."%s"."%s" that contained the delimiter "%s"', self.cur.rowcount, self.dataset.schema, self.data_table_name, delimiter, self.exclude_values)
        

    def update_element_mapping(self):
        sql = f"""update public.{self.dataset.ust_or_release}_element_mapping 
                  set deagg_table_name = %s, deagg_column_name = %s
                  where {self.dataset.ust_or_release}_control_id = %s 
                  and organization_table_name = %s and organization_column_name = %s"""
        utils.process_sql(self.conn, self.cur, sql, params=(self.deagg_table_name, self.column_name, self.dataset.control_id, self.data_table_name, self.column_name))
        self.conn.commit()
        logger.info('Updated %s_element_mapping; set deagg_table_name to %s, deagg_column_name to %s for %s.%s', self.dataset.ust_or_release, self.deagg_table_name, self.column_name, self.data_table_name, self.column_name)


    def run_deagg_rows(self):
        if not self.deagg_rows:
            return

        sql = f"""select distinct epa_table_name
                from public.{self.dataset.ust_or_release}_element_mapping 
                where {self.dataset.ust_or_release}_control_id = %s
                and organization_table_name = %s and organization_column_name = %s"""
        utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id, self.data_table_name, self.column_name), print_sql=False)
        epa_table_name = self.cur.fetchone()[0]

        sql = f"""select organization_column_name
                from public.{self.dataset.ust_or_release}_element_mapping  
                where {self.dataset.ust_or_release}_control_id = %s and epa_table_name = %s
                and organization_column_name <> %s and organization_table_name = %s"""
        utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id, epa_table_name, self.column_name, self.data_table_name))
        rows = self.cur.fetchall()
        data_table_pk_cols = [r[0] for r in rows]
        
        drows = deaggRows(dataset=self.dataset, 
                 data_table_name=self.data_table_name, 
                 data_table_pk_cols=data_table_pk_cols,
                 data_deagg_column_name=self.column_name,
                 deagg_table_name=self.deagg_table_name,
                 delimiters=self.delimiters,
                 exclude_values=self.exclude_values,
                 drop_existing=self.drop_existing)
        drows.process()
        self.disconnect_db()


    def process(self):
        self.connect_db()
        self.create_deagg_table()
        self.insert_nonagged()
        delimiters = self.delimiters
        if self.nonagged == 0:
            self.deagg(delimiters[0])
            delimiters.pop(0)
        for delimiter in delimiters:
            self.deagg(delimiter)        
        self.update_element_mapping()
        self.run_deagg_rows()
        self.disconnect_db()


def deagg_only(ust_or_release, control_id, data_table_name, column_name, delimiters, exclude_values=None, drop_existing=False, deagg_rows=False):
    dataset = Dataset(ust_or_release=ust_or_release,
                   control_id=control_id,
                  requires_export=False)

    deagg = Deagg(dataset=dataset, 
                      data_table_name=data_table_name, 
                    column_name=column_name,
                    delimiters=delimiters,
                    exclude_values=exclude_values,
                    drop_existing=drop_existing,
                     deagg_rows=deagg_rows)    
    deagg.connect_db()
    deagg.deagg()
    deagg.disconnect_db()



def main(ust_or_release, control_id, data_table_name, column_name, delimiters, exclude_values=None, drop_existing=False, deagg_rows=True):
    dataset = Dataset(ust_or_release=ust_or_release,
                       control_id=control_id,
                      requires_export=False)

    deagg = Deagg(dataset=dataset, 
                data_table_name=data_table_name, 
                column_name=column_name,
                delimiters=delimiters,
                exclude_values=exclude_values,
                drop_existing=drop_existing,
                 deagg_rows=deagg_rows)
    deagg.process()


if __name__ == '__main__':   
    main(ust_or_release=ust_or_release, 
         control_id=control_id,
         data_table_name=data_table_name, 
         column_name=column_name,
         delimiters=delimiters,
         exclude_values=exclude_values,
         drop_existing=drop_existing,
         deagg_rows=deagg_rows)
