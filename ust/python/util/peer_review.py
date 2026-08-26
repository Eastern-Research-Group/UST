
import sys

import pandas as pd
import psycopg2

from ust.python.util import utils
from ust.python.util.dataset import Dataset
from ust.python.util.export_view_ddl import ViewDdl
from ust.python.util.logger_factory import logger

ust_or_release = ''             # Valid values are 'ust' or 'release'
control_id = 0                       # Enter an integer that is the ust_control_id or release_control_id
organization_id = ''            # Optional; if control_id = 0 or None, will find the most recent control_id
display_bad_data = False          # Boolean; defaults to False. Set to True to print bad data to the console (note: if there are a lot of rows, this may be very slow).
overwrite_existing = False      # Boolean; defaults to False. Set to True to overwrite existing generated SQL file. If False, will append an existing file.
export_view_ddl = True          # Boolean; defaults to True. If True, will export the data population view DDL to a SQL file for easy review.  


# These variables can usually be left unset. This script will generate an Excel file in the appropriate state folder in the repo under /ust/sql/states.
# This file directory and its contents are excluded from pushes to the repo by .gitignore.
export_file_path = None
export_file_dir = None
export_file_name = None


class PeerReview:
    conn = None 
    cur = None 
    view_name = None 
    table_name = None 
    view_col_str = None 
    vsql = ''

    def __init__(self, 
                 dataset,
                 display_bad_data=False,
                 overwrite_existing=False,
                 export_view_ddl=True):
        self.dataset = dataset
        self.display_bad_data = display_bad_data
        self.overwrite_existing = overwrite_existing
        self.export_view_ddl = export_view_ddl
        self.views_to_review = []
        self.tables_to_review = []
        self.error_dict = {}
        self.error_cnt_dict = {}
        self.error_tables = []
        self.view_counts = {}


    def connect_db(self):
        self.conn = utils.connect_db()
        self.cur = self.conn.cursor()
        logger.info('Connected to database')
        

    def disconnect_db(self):
        try:
            if self.cur:
                self.cur.close()
        except (psycopg2.Error, psycopg2.InterfaceError):
            pass
        try:
            if self.conn:
                self.conn.close()
        except (psycopg2.Error, psycopg2.InterfaceError):
            pass
        self.cur = None
        self.conn = None
        logger.info('Disconnected from database')


    def _reconnect_db(self):
        self.disconnect_db()
        self.connect_db()


    def _fetchone_value(self, sql, params=None):
        try:
            self.cur.execute(sql, params)
            row = self.cur.fetchone()
            return row[0] if row else None
        except (psycopg2.Error, psycopg2.InterfaceError) as exc:
            logger.error('Peer review query failed: %s', exc)
            logger.error('\n\nFailed peer review SQL:\n%s\n', sql)
            self._reconnect_db()
            return None


    def _add_query_failure_section(self, view, sql, context):
        self.vsql += '\n\n\n/*********** ' + view + ' ***********/\n'
        self.vsql += f'--Unable to complete peer review {context} for {self.dataset.schema}.{view}.\n'
        self.vsql += '--The database connection closed while running this SQL; run it manually to diagnose the view performance or definition.\n\n'
        self.vsql += sql.rstrip(';') + ';\n'


    def get_view_names(self):
        sql = f"select view_name from public.{self.dataset.ust_or_release}_template_data_tables order by sort_order"
        utils.process_sql(self.conn, self.cur, sql)
        rows = self.cur.fetchall()
        views = [r[0] for r in rows]
        return views 


    def set_views(self):
        sql = f"""select a.table_name as view_name 
                    from information_schema.tables a join public.{self.dataset.ust_or_release}_template_data_tables b on a.table_name = b.view_name 
                    where a.table_schema = %s
                    order by b.sort_order"""
        utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.schema,))
        rows = self.cur.fetchall()        
        self.views_to_review = [r[0] for r in rows]


    def set_tables(self):    
        self.tables_to_review = [t.replace('v_','') for t in self.views_to_review]
        logger.info("The following tables will be reviewed: %s", self.tables_to_review)


    def compare_row_counts(self):
        for view in self.views_to_review:
            sql = f"select count(*) from {self.dataset.schema}.{view}"
            view_rows = self._fetchone_value(sql)
            if view_rows is None:
                logger.warning('Skipping peer review row-count comparison for %s.%s because the state-view count failed.', self.dataset.schema, view)
                self._add_query_failure_section(view, sql, 'row-count comparison')
                continue
            sql = f"select count(*) from public.{view} where {self.dataset.ust_or_release}_control_id = %s"
            table_rows = self._fetchone_value(sql, params=(self.dataset.control_id,))
            if table_rows is None:
                logger.warning('Skipping peer review row-count comparison for public.%s because the public-view count failed.', view)
                self._add_query_failure_section(view, sql, 'public row-count comparison')
                continue
            if view_rows == table_rows:
                logger.info('Row counts match between %s.%s and public.%s: (%s)', self.dataset.schema, view, view.replace('v_',''), table_rows)
            else:
                logger.warning('Mismatch of row counts between %s.%s (%s) and public.%s (%s)!!!', self.dataset.schema, view, view_rows, view.replace('v_',''), table_rows)
                self.error_tables.append(view)


    def set_table_counts(self):
        for view in self.views_to_review:
            sql = f"select count(*) from public.{view} where {self.dataset.ust_or_release}_control_id = %s"
            utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id,))
            num_rows = self.cur.fetchone()[0]
            self.view_counts[view] = num_rows            


    def _build_row_difference_sql(self, view, key_rows, include_order=True):
        sql = f"select * from {self.dataset.schema}.{view} a\nwhere not exists"
        control_col = f'{self.dataset.ust_or_release}_control_id'
        if "substance" in view:
            if self.dataset.ust_or_release == 'ust':
                epacol = 'Substance'
            else:
                epacol = 'SubstanceReleased'
            sql = sql + f"""\n\t(select 1 from public.{view} b join public.substances c on b."{epacol}" = c.substance\n\twhere"""
        elif "cause" in view:
            sql = sql + f"""\n\t(select 1 from public.{view} b join public.causes c on b."CauseOfRelease" = c.cause\n\twhere"""
        elif "source" in view:
            sql = sql + f"""\n\t(select 1 from public.{view} b join public.sources c on b."SourceOfRelease" = c.source\n\twhere"""
        elif "corrective_action_strategy" in view:
            sql = sql + f"""\n\t(select 1 from public.{view} b join public.corrective_action_strategies c on b."CorrectiveActionStrategy" = c.corrective_action_strategy\n\twhere"""
        else:
            sql = sql + f"\n\t(select 1 from public.{view} b\n\twhere"
        sql = sql + f' b.{control_col} = {self.dataset.control_id} and'
        for row in key_rows:
            if row[0] in ['substance_id','cause_id','source_id','corrective_action_strategy_id']:
                sql = sql + ' a.' + row[0] + ' = c."' + row[0] + '" and'
            else:
                sql = sql + ' a.' + row[0] + ' = b."' + row[1] + '" and'
        sql = sql[:-4] + ')'
        if include_order:
            sql = sql + '\norder by '
            for row in key_rows:
                sql = sql + 'a.' + row[0] + ','
            sql = sql[:-1]
        return sql + ';'


    def _build_row_difference_count_sql(self, view, key_rows):
        detail_sql = self._build_row_difference_sql(view, key_rows, include_order=False).rstrip(';')
        return 'select count(*) from (\n' + detail_sql.replace('select *', 'select 1', 1) + '\n) row_diff'


    def get_sql(self):
        for view in self.error_tables:
            logger.info('Generating SQL for row differences between %s.%s and public.%s', self.dataset.schema, view, view)

            sql = f"""select a.column_name as org_view_col, b.element_name as epa_view_col
                    from public.{self.dataset.ust_or_release}_view_key_columns a join public.v_{self.dataset.ust_or_release}_element_metadata b 
                        on replace(a.view_name,'v_','') = b.table_name and a.column_name = b.column_name 
                    where a.view_name = %s
                    order by a.sort_order"""
            utils.process_sql(self.conn, self.cur, sql, params=(view,))
            rows = self.cur.fetchall()
            sql = self._build_row_difference_sql(view, rows)
            count_sql = self._build_row_difference_count_sql(view, rows)
            row_count = self._fetchone_value(count_sql)
            if self.display_bad_data:
                df = pd.read_sql(sql, con=utils.get_engine())
                utils.pretty_print_df(df)

            self.vsql = self.vsql + '\n\n\n/*********** ' + view + ' ***********/\n'
            if row_count is None:
                self.vsql += f'--Unable to count rows in {self.dataset.schema}.{view} that do not exist in public.{view}; run the SQL below manually.\n\n'
            else:
                self.vsql = self.vsql + f'--There are {row_count} rows in {self.dataset.schema}.{view} that do not exist in public.{view}\n\n'
            self.vsql = self.vsql + sql + f'\n\n--View definition for {self.dataset.schema}.{view}:\n'

            sql = f"select get_view_def('{view}','{self.dataset.schema}')"
            view_def = self._fetchone_value(sql)
            if view_def is None:
                self.vsql += f'--Unable to retrieve view definition for {self.dataset.schema}.{view}.\n'
            else:
                self.vsql = self.vsql + view_def


    def write_sql(self):
        if self.vsql:
            wora = 'a'
            if self.overwrite_existing:
                wora = 'w'
            with open(self.dataset.export_file_path, wora, encoding='utf-8') as f:
                f.write(self.vsql)
            logger.info('SQL exported to %s\n\n', self.dataset.export_file_path)
        else:
            logger.info('No mismatched counts between the data population views and the EPA data tables; no SQL exported.')


    def process(self):
        # Compare row counts:
        self.connect_db()
        self.set_views()
        self.set_tables()
        if not self.views_to_review:
            logger.warning('No %s template views found in schema %s; exiting.', self.dataset.ust_or_release, self.dataset.schema)
            logger.info('Views this script looks for: %s', self.get_view_names())
            self.disconnect_db()
            sys.exit()
        self.compare_row_counts()
        self.get_sql()
        self.disconnect_db()
        self.write_sql()

        if self.export_view_ddl:
            # Export data population view DDL for review:
            dataset = Dataset(ust_or_release=self.dataset.ust_or_release,
                               control_id=self.dataset.control_id, 
                               base_file_name='view_ddl.sql')        
            ddl = ViewDdl(dataset=dataset)
            ddl.process()



def main(ust_or_release, control_id=None, organization_id=None, display_bad_data=False, overwrite_existing=False, export_view_ddl=True):
    if not control_id and not organization_id:
        logger.error('Please pass either control_id or organization_id')
        sys.exit()
    elif not control_id:
        control_id = utils.get_control_id(ust_or_release, organization_id)

    dataset = Dataset(ust_or_release=ust_or_release,
                       control_id=control_id, 
                       base_file_name='peer_review.sql',
                      export_file_name=export_file_name,
                      export_file_dir=export_file_dir,
                      export_file_path=export_file_path)

    review = PeerReview(dataset=dataset, display_bad_data=display_bad_data, overwrite_existing=overwrite_existing, export_view_ddl=export_view_ddl)
    review.process()


if __name__ == '__main__':   
    main(ust_or_release=ust_or_release,
         control_id=control_id, 
         organization_id=organization_id,
         display_bad_data=display_bad_data,
         overwrite_existing=overwrite_existing,
         export_view_ddl=export_view_ddl)
