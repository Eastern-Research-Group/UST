
import re

import pandas as pd

from ust.python.state_processing.create_unreg_tables import UnregTables
from ust.python.util import utils
from ust.python.util.dataset import Dataset
from ust.python.util.logger_factory import logger

ust_or_release = ''                     # Valid values are 'ust' or 'release'
control_id = 0                          # Enter an integer that is the ust_control_id or release_control_id
organization_id = ''                    # Optional; if control_id = 0 or None, will find the most recent control_id
find_regulated = False                  # Boolean; defauls to False. Set to True if the unregulated tanks and facilites tables do not already exist in the schema and need to be created. 
execute_sql = True                        # Boolean; defaults to True. Set to True to execute the SQL that replaces the views in the database; False to export the new view SQL to file without executing it in the database. 
export_sql = True                          # Boolean; defaults to True. If True will generate a SQL file containing the 'create or replace view' statements.
print_sql = False                        # Boolean; default to False. Set to True to print generated SQL to the console 
view_name = None                        # String; defaults to None. To limit output to a single view, enter view name (e.g. "v_ust_tank_substance").
override_existing_unreg_check = False    # Boolean; defaults to False. If False, script will exit with a warning if an "erg_unreg" table is already excluded from the view. Set to True to force script to execute anyway. 

# These variables can usually be left unset. This script will general a SQL file in the appropriate state folder in the repo under /ust/sql/states
export_file_path = None
export_file_dir = None
export_file_name = None

class Exclude:
    conn = None 
    cur = None 
    df = None 
    view_def = None 
    value_mapping_sql = '------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
    
    def __init__(self, 
                 dataset,
                 find_regulated=False,
                 execute_sql=True,
                 export_sql=True,
                 print_sql=False,
                 view_name=None,
                 override_existing_unreg_check=False):
        self.dataset = dataset
        self.unreg = UnregTables(self.dataset)
        self.find_regulated = find_regulated
        self.execute_sql = execute_sql
        self.export_sql = export_sql
        self.print_sql = print_sql
        self.view_name = view_name
        self.override_existing_unreg_check = override_existing_unreg_check


    def _quote_identifier(self, identifier):
        if identifier is None or str(identifier).strip() == '':
            raise ValueError(f'Unsafe SQL identifier: {identifier}')
        return '"' + str(identifier).replace('"', '""') + '"'


    def _qualify_table(self, table_name):
        if '.' in table_name:
            schema, table = table_name.split('.', 1)
            return f'{self._quote_identifier(schema)}.{self._quote_identifier(table)}'
        return self._quote_identifier(table_name)


    def _alias_column(self, alias, column_name, cast_text=False):
        expression = f'{alias}.{self._quote_identifier(column_name)}'
        if cast_text:
            expression += '::varchar(50)'
        return expression


    def unreg_tables_exist(self):
        self.unreg.connect_db()
        try:
            return all(
                self.unreg._table_exists(table)
                for table in (self.unreg.unreg_parent_table, self.unreg.unreg_substance_table)
            )
        finally:
            self.unreg.disconnect_db()


    def execute(self):
        if self.find_regulated and not self.unreg_tables_exist():
            self.unreg.execute()

        self.connect_db()

        self.df = self.get_columns()
        views = ['v_' + v for v in self.df['epa_table_name'].unique()]
        for view in views:
            logger.info('Working on view %s', view)
            self.view_def = self.get_new_view_def(view)
            if self.view_def and self.execute_sql:
                utils.process_sql(self.conn, self.cur, self.view_def)
                logger.info('Replaced view %s.%s', self.dataset.schema, view)
            if self.view_def and self.print_sql:
                print(self.view_def)

            if self.view_def:
                self.value_mapping_sql = self.value_mapping_sql + '\n\n' + self.view_def

        self.disconnect_db()

        if self.export_sql:
            self.write_sql()


    def get_columns(self):
        sql = f"""select a.epa_table_name, a.epa_column_name, b.table_name, b.column_name, table_sort_order, column_sort_order
                 from public.{self.dataset.ust_or_release}_element_mapping a join information_schema.columns b 
                    on lower(a.organization_table_name) = lower(b.table_name) and lower(a.organization_column_name) = lower(b.column_name)
                    left join public.v_{self.dataset.ust_or_release}_element_metadata c on a.epa_table_name = c.table_name and a.epa_column_name = c.column_name
                 where a.{self.dataset.ust_or_release}_control_id = %s
                 and b.table_schema = %s and a.epa_column_name in ('facility_id','tank_id','release_id','substance_id') """
        params = [self.dataset.control_id, self.dataset.schema]
        if self.view_name:
            sql = sql + " and epa_table_name = %s "
            params.append(self.view_name.replace("v_", ""))
        sql = sql + " order by c.table_sort_order, c.column_sort_order"
        df = pd.read_sql(sql, con=utils.get_engine(), params=tuple(params))
        return df 


    def get_view_def(self, view_name):
        sql = "select public.get_view_def(%s, %s)"
        utils.process_sql(self.conn, self.cur, sql, params=(view_name, self.dataset.schema))
        view_def = f'\n\ncreate or replace view {self._quote_identifier(self.dataset.schema)}.{self._quote_identifier(view_name)} as\n' 
        view_def = view_def + self.cur.fetchone()[0].replace(';','')
        return view_def


    def get_new_view_def(self, view_name):
        table = view_name.replace('v_','')

        unreg_parent_table = self.unreg.unreg_parent_table
        unreg_parent_col = self.unreg.unreg_parent_col
        unreg_child_table = self.unreg.unreg_substance_table
        
        src_col_name = None 
        sur_sub_col_name = None 

        unreg_child_col = 'tank_id'
        if self.dataset.ust_or_release == 'release':
            unreg_child_col = 'substance_id'

        view_def = self.get_view_def(view_name)

        if 'erg_unreg' in view_def and not self.override_existing_unreg_check:
            logger.warning('It appears that the unregulated table(s) have already been excluded from %s. This view will not be rewritten. To override this check, set override_existing_unreg_check = True.', view_name)
            return 

        if 'WHERE' in view_def:
            view_def = view_def + '\n and '
        else:
            view_def = view_def + '\n where '

        # print(f'table = "{table}"')
        # print(f'erg_table_name = "{erg_table_name}"')
        # print(f'epa_col_name = "{epa_col_name}"')
        # print(f'pk_col_name = "{pk_col_name}"')

        filtered_table_df = self.df.copy().query(f"epa_table_name == '{table}'")
        # utils.pretty_print_df(filtered_table_df)
        source_table = filtered_table_df['table_name'].iloc[0]
        from_table = self.dataset.schema + '.' + source_table
        # print(f'from_table = {from_table}')        

        src_pk_name = filtered_table_df.copy().query(f"epa_column_name == '{unreg_parent_col}'")['column_name'].iloc[0]
        # print(f'src_pk_name = "{src_pk_name}"')
        try:
            src_col_name = filtered_table_df.copy().query(f"epa_column_name == '{unreg_child_col}'")['column_name'].iloc[0]
            # print(f'src_col_name = "{src_col_name}"')
        except IndexError:
            pass 
        try:
            sur_sub_col_name = filtered_table_df.copy().query("epa_column_name == 'substance_id'")['column_name'].iloc[0]
            # print(f'sur_sub_col_name = "{sur_sub_col_name}"')
        except IndexError:
            pass
        
        table_alias = get_table_alias(self.get_view_def(view_name), from_table) or self._qualify_table(from_table)
        # print(f'table_alias = "{table_alias}"')

        # All views should exclude the parents 
        parent_key_expression = self._alias_column(table_alias, src_pk_name, cast_text=True)
        view_def += (
            f'not exists (select 1 from {unreg_parent_table} unregparent '
            f'where {parent_key_expression} = unregparent.{unreg_parent_col})'
        )

        if view_name not in ('v_ust_facility', 'v_ust_facility_dispenser') and self.dataset.ust_or_release == 'ust':
            # One additional exclusion: the child unreg table, joined only on child pk (that is, if not an UST substance view that requires an additional join on substance)
            view_def += f'\nand not exists (select 1 from {unreg_child_table} unreg'
            view_def += f'\n\twhere {parent_key_expression} = unreg.{unreg_parent_col} and {self._alias_column(table_alias, src_col_name)} = unreg.{unreg_child_col})'
        if 'substance' in view_name:
            view_def += f'\nand not exists (select 1 from {unreg_child_table} unregsub'
            view_def += f'\n\twhere {parent_key_expression} = unregsub.{unreg_parent_col} '
            if self.dataset.ust_or_release == 'ust':
                view_def += f' and {self._alias_column(table_alias, src_col_name)} = unregsub.{unreg_child_col}' 
            view_def += f' and {self._alias_column(table_alias, sur_sub_col_name)} = unregsub.organization_substance)'        

        if view_def[:-1] != ';':
            view_def = view_def + ';'

        return view_def   


    def write_sql(self):
        with open(self.dataset.export_file_path, 'w', encoding='utf-8') as f:
            f.write(self.value_mapping_sql)
        logger.info('Wrote SQL file to %s', self.dataset.export_file_path)


    def connect_db(self):
        if not self.conn:
            self.conn = utils.connect_db()
            self.cur = self.conn.cursor()
            logger.info('Connected to database')
        

    def disconnect_db(self):
        if self.conn:
            self.cur.close()
            self.conn.close()
            self.conn = None 
            logger.info('Disconnected from database')



def get_table_alias(view_def, from_table):
    schema, table = from_table.split('.', 1)
    identifier = rf'(?:(?:"{re.escape(schema)}"|{re.escape(schema)})\.)?(?:"{re.escape(table)}"|{re.escape(table)})'
    alias_match = re.search(
        identifier + r'\s+(?:as\s+)?(?P<alias>"[^"]+"|[A-Za-z_][A-Za-z0-9_]*)',
        view_def,
        flags=re.IGNORECASE,
    )
    if alias_match:
        return alias_match.group('alias')
    if re.search(identifier, view_def, flags=re.IGNORECASE):
        return from_table
    return None



def main(ust_or_release, 
         control_id, 
         organization_id=None,
         find_regulated=True, 
         execute_sql=False,
         export_sql=True,
         print_sql=False,
         export_file_path=None, 
         export_file_dir=None,
         export_file_name=None,
         view_name=None,
         override_existing_unreg_check=False):
    if not control_id or control_id == 0:
        control_id = utils.get_control_id(ust_or_release, organization_id.upper())
    dataset = Dataset(ust_or_release=ust_or_release,
                      control_id=control_id,
                      requires_export=True,
                      base_file_name='view_definitions.sql',
                      export_file_path=export_file_path,
                      export_file_dir=export_file_dir,
                      export_file_name=export_file_name)

    e = Exclude(dataset, 
                find_regulated=find_regulated, 
                execute_sql=execute_sql, 
                export_sql=export_sql, 
                print_sql=print_sql,
                view_name=view_name,
                override_existing_unreg_check=override_existing_unreg_check)
    e.execute()


if __name__ == '__main__':   
    main(ust_or_release=ust_or_release,
         control_id=control_id,
         organization_id=organization_id,
         find_regulated=find_regulated,
         execute_sql=execute_sql,
         export_sql=export_sql,
         print_sql=print_sql,
         export_file_path=export_file_path,
         export_file_dir=export_file_dir,
         export_file_name=export_file_name,
         view_name=view_name,
         override_existing_unreg_check=override_existing_unreg_check)

