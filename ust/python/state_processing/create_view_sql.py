# TODO: when creating v_ust_tank_substance and v_ust_compartment_substance, include substance_comment and populate with organization value

from pathlib import Path
import pandas as pd

from ust.python.util.dataset import Dataset
from ust.python.util import utils
from ust.python.util.logger_factory import logger


ust_or_release = ''             # Valid values are 'ust' or 'release'
control_id = 0                  # Enter an integer that is the ust_control_id or release_control_id
table_name = ''               # Enter EPA table name we are writing the view to populate. Set to None to generate all required views. 
overwrite_sql_file = True          # Boolean, defaults to True. If True, will overwrite an existing SQL file if it exists. If False, will append to the existing file. 
print_console = False            # Boolean; defaults to False. Set to True to print the create view SQL to the console. 

# These variables can usually be left unset. This script will general a SQL file in the appropriate state folder in the repo under /ust/sql/states
export_file_path = None         
export_file_dir = None
export_file_name = None

class ViewSql:
    def __init__(self, 
                 dataset,
                 table_name,
                 overwrite_sql_file=True,
                 print_console=True,
                 strict=False):
        self.dataset = dataset
        self.table_name = table_name 
        self.strict = strict
        self.conn = None
        self.cur = None
        self.required_cols = {}
        self.existing_cols = {}
        self.required_col_ids = []
        self.existing_col_ids = []
        self.all_col_ids = []
        self.epa_column_name = None
        self.join_info = {}
        self.select_sql = ''
        self.from_sql = ''
        self.where_sql = ''
        self.view_sql = '----------------------------------------------------------------------------------------------------------\n\n'
        self.table_aliases = {}
        self.join_tables = []
        self.mapped_epa_columns = set()
        self.warnings = []
        logger.info('Working on table %s', self.table_name)
        if overwrite_sql_file:
            self.overwrite_file()
        self.print_console = print_console
        self.view_name = 'v_' + self.table_name
        self.connect_db()
        try:
            self.generate_sql()
        finally:
            self.disconnect_db()
        self.write_self()


    def connect_db(self):
        if not self.conn:
            self.conn = utils.connect_db()
            self.cur = self.conn.cursor()


    def disconnect_db(self):
        if self.conn:
            self.conn.commit()
            self.cur.close()
            self.conn.close()
            self.conn = None 


    def overwrite_file(self):
        file_path = Path(self.dataset.export_file_path)
        if file_path.is_file():
            with open(file_path, 'w'):
                pass  


    def show_existing_cols(self):
        for k, v in self.existing_cols.items():
            print('column ID = ' + str(k))
            print('column_name = ' + v['column_name'])


    def write_self(self):
        with open(self.dataset.export_file_path, 'a', encoding='utf-8') as f:
            f.write(self.view_sql.replace('\t','    '))
        logger.info('Wrote SQL to %s', self.dataset.export_file_path)


    def get_required_cols(self):
        sql = f"""select column_sort_order, a.column_name, a.data_type, a.character_maximum_length
                from information_schema.columns a join public.{self.dataset.ust_or_release}_required_view_columns b 
                    on a.table_name = b.information_schema_table_name and a.column_name = b.column_name
                where table_schema = 'public' and b.table_name = %s 
                and b.column_name not in 
                    (select epa_column_name from public.v_{self.dataset.ust_or_release}_element_mapping_joins
                    where {self.dataset.ust_or_release}_control_id = %s and epa_table_name = %s)
                order by column_sort_order"""
        self.cur.execute(sql, (self.table_name, self.dataset.control_id, self.table_name))
        # utils.pretty_print_query(self.cur)
        req_col_info = self.cur.fetchall()
        self.required_col_ids = [c[0] for c in req_col_info]
        req_cols = {}
        for req_col in req_col_info:
            column_id = req_col[0]
            column_name = req_col[1]
            data_type = req_col[2]
            character_maximum_length = req_col[3]
            req_cols[column_id] = {'column_name': column_name, 'data_type': data_type, 'character_maximum_length':character_maximum_length}
        # print(req_cols)
        return req_cols


    def _warn(self, message):
        self.warnings.append(message)
        logger.warning(message)


    def _has_value(self, value):
        if value is None:
            return False
        if isinstance(value, float) and pd.isna(value):
            return False
        text = str(value).strip()
        return text != '' and text.lower() != 'nan'


    def _preflight(self):
        try:
            self.join_tables = utils.get_join_tables(self.dataset, self.table_name)
        except Exception as exc:
            msg = f'Unable to retrieve join metadata for {self.table_name}: {exc}'
            if self.strict:
                raise RuntimeError(msg) from exc
            self._warn(msg)
            self.join_tables = []

        if not self.join_tables:
            msg = f'No join metadata found for {self.table_name}; SQL will include placeholders and may need manual edits.'
            if self.strict:
                raise RuntimeError(msg)
            self._warn(msg)


    def _get_fallback_source_table(self):
        sql = f"""select coalesce(deagg_table_name, organization_table_name)
                  from public.v_{self.dataset.ust_or_release}_element_mapping_joins
                  where {self.dataset.ust_or_release}_control_id = %s
                  and epa_table_name = %s
                  and coalesce(deagg_table_name, organization_table_name) is not null
                  order by column_sort_order
                  limit 1"""
        self.cur.execute(sql, (self.dataset.control_id, self.table_name))
        row = self.cur.fetchone()
        if not row:
            return None
        return row[0]
            

    def get_column_select_sql(self, epa_column_name, org_column_name):
        if not self._has_value(org_column_name):
            return f'???? as {epa_column_name}'
        epa_table_name = self.table_name
        if epa_column_name == 'facility_id' and self.table_name != 'ust_facility':
            epa_table_name = 'ust_facility'
        elif (epa_column_name == 'tank_id' or epa_column_name == 'tank_name') and self.table_name != 'ust_tank':
            epa_table_name = 'ust_tank'
        elif (epa_column_name == 'compartment_id' or epa_column_name == 'compartment_name') and self.table_name != 'ust_compartment':
            epa_table_name = 'ust_compartment'

        sql = """select data_type, character_maximum_length from information_schema.columns 
                 where table_schema = 'public' and table_name = %s and column_name = %s"""
        self.cur.execute(sql, (epa_table_name, epa_column_name))
        # utils.pretty_print_query(self.cur)
        row = self.cur.fetchone()
        if not row:
            self._warn(f'No datatype metadata found for {epa_table_name}.{epa_column_name}; using placeholder SQL.')
            return f'???? as {epa_column_name}'
        data_type = row[0]
        max_len = row[1]
        selected_column = '"' + org_column_name + '"::' + data_type
        if max_len:
            selected_column = selected_column + '(' + str(max_len) + ')'
        selected_column = selected_column + ' as ' + epa_column_name

        return selected_column 


    def get_existing_cols(self):
        sql = f"""select column_sort_order as column_id, 
                    epa_column_name, 
                    organization_column_name, 
                    selected_column, query_logic,
                    organization_table_name
            from public.v_{self.dataset.ust_or_release}_table_population_sql
            where {self.dataset.ust_or_release}_control_id = %s and epa_table_name = %s
            and column_sort_order is not null
            order by column_sort_order """
        self.cur.execute(sql, (self.dataset.control_id, self.table_name))
        # utils.pretty_print_query(self.cur)
        existing_col_info = self.cur.fetchall()
        if not existing_col_info:
            self._warn(f'No mapped elements found for EPA table {self.table_name}; generating required placeholders only.')
            self.existing_col_ids = []
            self.mapped_epa_columns = set()
            return {}
        self.existing_col_ids = [c[0] for c in existing_col_info]
        existing_cols = {}
        for existing_col in existing_col_info:
            column_id = existing_col[0]
            epa_column_name = existing_col[1]
            organization_column_name = existing_col[2]
            selected_column = existing_col[3]
            query_logic = existing_col[4]
            organization_table_name = existing_col[5]
            if not selected_column:
                selected_column = self.get_column_select_sql(epa_column_name, organization_column_name)
                try:
                    selected_column = self.table_aliases[organization_table_name] + '.' + selected_column
                except KeyError:
                    pass
            selected_column = selected_column.strip()
            if selected_column.endswith(','):
                selected_column = selected_column[:-1]
            if query_logic:
                query_logic = utils.comment_every_line(query_logic)
            else:
                query_logic = ''
            existing_cols[column_id] = {'column_name': epa_column_name, 
                                        'selected_column': selected_column, 
                                        'query_logic': query_logic,
                                        'organization_table_name': organization_table_name}
            self.mapped_epa_columns.add(epa_column_name)
        return existing_cols


    def build_where_sql(self):
        if self.dataset.ust_or_release == 'ust':
            parent_table = 'ust_facility'
            parent_col = 'facility_id'
            parent_unreg_table = 'erg_unregulated_facilities'
            child_unreg_table = 'erg_unregulated_tanks'
            cols = ['facility_id', 'tank_id', 'substance_id']
        else:
            parent_table = 'ust_release'
            parent_col = 'release_id'
            parent_unreg_table = 'erg_unregulated_releases'
            child_unreg_table = 'erg_unregulated_substances'
            cols = ['release_id', 'substance_id']
        if self.table_name == parent_table:
            unreg_table = parent_unreg_table
        else:
            unreg_table = child_unreg_table

        fk_col = ''
        if 'substance' in self.table_name:
            fk_col = 'substance'
        elif 'cause' in self.table_name:
            fk_col = 'cause'
        elif 'source' in self.table_name:
            fk_col = 'source'
        elif 'corrective' in self.table_name:
            fk_col = 'corrective_action_strategy'

        if fk_col:
            self.where_sql = f'\nwhere {fk_col}_id is not null and'
        else:
            self.where_sql = "\nwhere"
        self.where_sql += f" not exists\n\t(select 1 from {self.dataset.schema}.{unreg_table} unreg\n\twhere "

        sql = f"""select organization_column_name, epa_column_name 
                  from public.{self.dataset.ust_or_release}_element_mapping 
                  where {self.dataset.ust_or_release}_control_id = %s 
                  and epa_table_name = %s and epa_column_name = any(array{cols})
                  order by 2"""
        utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id, self.table_name))
        rows = self.cur.fetchall()

        org_parent_col = ''
        org_child_col = ''
        for row in rows:
            if row[1] == parent_col:
                org_parent_col = row[0]
            else:
                org_child_col = row[0]

        if not self._has_value(org_parent_col):
            msg = f'Missing mapping for required key {parent_col} in {self.table_name}; using where 1=1 fallback.'
            if self.strict:
                raise RuntimeError(msg)
            self._warn(msg)
            self.where_sql = '\nwhere 1=1\n\n-- ADD ADDITIONAL SQL HERE IF NECESSARY\n;\n'
            return

        self.where_sql += f"""a."{org_parent_col}":: varchar(50) = unreg.{parent_col} """
        if self._has_value(org_child_col):
            if self.dataset.ust_or_release == 'ust':
                self.where_sql += f"""and a."{org_child_col}"::int = unreg.tank_id"""
            else:
                self.where_sql += f"""and a."{org_child_col}"::varchar = unreg.substance_id"""
        elif self.table_name != parent_table:
            self._warn(f'No child join mapping found for {self.table_name}; unregulated exclusion uses parent key only.')

        self.where_sql += ")\n"
        self.where_sql = self.where_sql + '\n-- ADD ADDITIONAL SQL HERE IF NECESSARY\n;\n'


    def build_from_sql(self, from_table, alias, join_alias):
        if self.join_info['table_type'] == 'lookup':
            self.from_sql = self.from_sql + '\n\tleft join ' + self.dataset.schema + '.' + from_table + ' ' + alias + ' on ' + join_alias + '."' + self.join_info['organization_join_column'] + '" = ' + alias + '.organization_value'
        else:
            if self._has_value(self.join_info['organization_join_column']) and self._has_value(self.join_info['organization_join_fk']):
                self.from_sql = self.from_sql + '\n\tleft join ' + self.dataset.schema + '."' + from_table + '" ' + alias + ' on ' + join_alias + '."' + self.join_info['organization_join_column'] + '" = ' + alias + '."' + self.join_info['organization_join_fk'] + '" '
            if self._has_value(self.join_info['organization_join_column2']) and self._has_value(self.join_info['organization_join_fk2']):
                self.from_sql = self.from_sql + 'and ' + join_alias + '."' + self.join_info['organization_join_column2'] + '" = ' + alias + '."' + self.join_info['organization_join_fk2'] + '" '
            if self._has_value(self.join_info['organization_join_column3']) and self._has_value(self.join_info['organization_join_fk3']):
                self.from_sql = self.from_sql + 'and ' + join_alias + '."' + self.join_info['organization_join_column3'] + '" = ' + alias + '."' + self.join_info['organization_join_fk3'] + '" '


    def build_from_query(self):
        self.from_sql = 'from '

        if not self.join_tables:
            fallback_table = self._get_fallback_source_table()
            if fallback_table:
                self.from_sql = self.from_sql + self.dataset.schema + '."' + fallback_table + '" a'
                self.table_aliases[fallback_table] = 'a'
                self._warn(f'Using fallback source table {fallback_table} for {self.table_name}.')
            else:
                self.from_sql = self.from_sql + '(select 1) a'
            return

        df = pd.DataFrame(self.join_tables)
        df.set_index('organization_table_name', inplace=True)
        # print(df.to_string())
        # print('----------------------------------------------------------------------------------------------------------------------\n')
        # exit()

        for from_table, row in df.iterrows():
            # logger.info('Working on table %s', from_table)
            self.join_info = row
            alias = row['alias']

            if alias == 'a':
                self.from_sql = self.from_sql + self.dataset.schema + '.' + '"' + from_table + '" ' + alias
                self.table_aliases[from_table] = alias

            else:
                try:
                    join_alias = df.loc[self.join_info['organization_join_table']]['alias']
                except KeyError:
                    join_alias = 'a'
                # print('alias = ' + alias)
                # print('join_alias = ' + join_alias)
                self.build_from_sql(from_table, alias, join_alias)
                self.table_aliases[from_table] = alias

            # print('__________________________________________________________________________________________________________________\n')


    def build_select_query(self):
        select_items = []
        region_next = False 
        for i in range(len(self.all_col_ids)):
            # deal with EPARegion column if in ust_facility and the last column was FacilityState
            if region_next:
                selected_column = str(utils.get_epa_region(self.dataset.organization_id)) + '::integer as facility_epa_region,'
                select_items.append('\t' + selected_column[:-1])
                region_next = False

            # build the select columns component of the query
            column_id = self.all_col_ids[i]
            query_logic = ''
            if self.all_col_ids[i] in self.existing_col_ids: # the column we are working on was mapped in the element_mapping table
                self.epa_column_name = self.existing_cols[column_id]['column_name']
                # logger.info('Working on column %s', self.epa_column_name)
                selected_column = self.existing_cols[column_id]['selected_column'].replace('""','????')
                query_logic = self.existing_cols[column_id]['query_logic']
                if 'facility_type' in self.epa_column_name and '_id' not in self.epa_column_name:
                    selected_column = selected_column.replace('facility_type1 as','facility_type_id as').replace('facility_type2 as','facility_type_id as')
            else: # the column we are working on wasn't mapped in the element mapping table but is a required field so add it anyway
                self.epa_column_name = self.required_cols[column_id]['column_name']
                # logger.info('Working on column %s', self.epa_column_name)
                data_type = self.required_cols[column_id]['data_type']
                character_maximum_length = self.required_cols[column_id]['character_maximum_length']
                org_col = '????' # print a symbol making it obvious to the developer they need to update the generated SQL
                selected_column = org_col + '::' + utils.get_datatype_sql(data_type, character_maximum_length) + ' as ' + self.epa_column_name + ','
            if self.epa_column_name == 'facility_state':
                # if facility_state wasn't mapped, set it as the organization ID
                if 'facility_state' not in self.mapped_epa_columns:
                    org_col = f"'{self.dataset.organization_id}'"
                    selected_column = org_col + '::' + utils.get_datatype_sql(data_type, character_maximum_length) + ' as ' + self.epa_column_name + ','
                # if we are working on ust_facility and we are on facility state, set the region_next variable
                if self.dataset.ust_or_release == 'ust' and self.table_name == 'ust_facility' and 'facility_epa_region' not in self.mapped_epa_columns:
                    region_next = True
            if query_logic:
                selected_column = '  !!! ' + selected_column
            select_items.append('\t' + selected_column.rstrip(',') + ' ' + query_logic)

        self.select_sql = 'select distinct\n' + ',\n'.join(s.rstrip() for s in select_items) + '\n'


    def generate_sql(self):
        self._preflight()
        self.build_where_sql()
        self.build_from_query()
        self.required_cols = self.get_required_cols()
        self.existing_cols = self.get_existing_cols()
        self.required_col_ids = [n for n in self.required_col_ids if n not in self.existing_col_ids]
        self.all_col_ids = sorted(self.required_col_ids + self.existing_col_ids, key=lambda x: x or 0)        
        self.build_select_query()
        if self.warnings:
            self.view_sql += '-- WARNINGS\n'
            for warning in self.warnings:
                self.view_sql += '-- ' + warning + '\n'
            self.view_sql += '\n'
        self.view_sql = self.view_sql + f'create or replace view {self.dataset.schema}.{self.view_name} as\n'
        self.view_sql = self.view_sql + self.select_sql + self.from_sql + self.where_sql
        # print(self.view_sql)
        if self.print_console:
            print(self.view_sql)
            print('-----------------------------------------------------------------------------------------------------------')
        return self.view_sql 



def get_tables_needed(dataset):
    conn = utils.connect_db()
    cur = conn.cursor()
    sql = f"""select distinct epa_table_name, table_sort_order
            from public.v_{dataset.ust_or_release}_table_population 
            where {dataset.ust_or_release}_control_id = %s
            order by table_sort_order"""
    cur.execute(sql, (dataset.control_id,))
    rows = cur.fetchall()
    cur.close()
    conn.close()
    return [r[0] for r in rows]


def _collect_table_preflight(dataset, table_name, strict=False):
    conn = utils.connect_db()
    cur = conn.cursor()
    warnings = []
    errors = []

    try:
        try:
            joins = utils.get_join_tables(dataset, table_name)
        except Exception as exc:
            joins = []
            message = f'Unable to retrieve join metadata: {exc}'
            if strict:
                errors.append(message)
            else:
                warnings.append(message)

        if not joins:
            message = 'No join metadata found.'
            if strict:
                errors.append(message)
            else:
                warnings.append(message)

        required_sql = f"""select b.column_name
                            from information_schema.columns a
                            join public.{dataset.ust_or_release}_required_view_columns b
                              on a.table_name = b.information_schema_table_name
                             and a.column_name = b.column_name
                            where a.table_schema = 'public' and b.table_name = %s"""
        cur.execute(required_sql, (table_name,))
        required_columns = {row[0] for row in cur.fetchall()}

        mapped_sql = f"""select distinct epa_column_name
                          from public.v_{dataset.ust_or_release}_table_population_sql
                          where {dataset.ust_or_release}_control_id = %s
                            and epa_table_name = %s
                            and epa_column_name is not null
                            and column_sort_order is not null"""
        cur.execute(mapped_sql, (dataset.control_id, table_name))
        mapped_columns = {row[0] for row in cur.fetchall()}

        missing_required = sorted(required_columns - mapped_columns)
        if missing_required:
            warnings.append(f'Missing required mappings: {", ".join(missing_required)}')

        if not mapped_columns:
            message = 'No mapped columns found in table population SQL.'
            if strict:
                errors.append(message)
            else:
                warnings.append(message)

        if dataset.ust_or_release == 'ust':
            parent_table = 'ust_facility'
            parent_col = 'facility_id'
            child_col = 'tank_id'
        else:
            parent_table = 'ust_release'
            parent_col = 'release_id'
            child_col = 'substance_id'

        key_sql = f"""select epa_column_name
                       from public.{dataset.ust_or_release}_element_mapping
                       where {dataset.ust_or_release}_control_id = %s
                         and epa_table_name = %s
                         and epa_column_name = any(%s)"""
        cur.execute(key_sql, (dataset.control_id, table_name, [parent_col, child_col]))
        key_cols = {row[0] for row in cur.fetchall()}

        if parent_col not in key_cols:
            message = f'Missing key mapping for {parent_col}.'
            if strict:
                errors.append(message)
            else:
                warnings.append(message)

        if table_name != parent_table and child_col not in key_cols:
            warnings.append(f'Missing key mapping for {child_col}.')

        return {
            'table_name': table_name,
            'join_count': len(joins) if 'joins' in locals() else 0,
            'required_count': len(required_columns),
            'mapped_count': len(mapped_columns),
            'missing_required_count': len(missing_required),
            'warnings': warnings,
            'errors': errors,
        }
    finally:
        cur.close()
        conn.close()


def preflight_report(ust_or_release, control_id, table_name=None, strict=False):
    dataset = Dataset(
        ust_or_release=ust_or_release,
        control_id=control_id,
        base_file_name='view_creation.sql',
        export_file_name=export_file_name,
        export_file_dir=export_file_dir,
        export_file_path=export_file_path,
    )

    tables = [table_name] if table_name else get_tables_needed(dataset)
    print('View SQL preflight report')
    print(f'  type: {ust_or_release}')
    print(f'  control-id: {control_id}')
    print(f'  strict: {strict}')

    fatal_tables = []
    for table in tables:
        result = _collect_table_preflight(dataset, table, strict=strict)
        print(f'\n[{table}]')
        print(f'  joins: {result["join_count"]}')
        print(f'  required columns: {result["required_count"]}')
        print(f'  mapped columns: {result["mapped_count"]}')
        print(f'  missing required: {result["missing_required_count"]}')
        for message in result['warnings']:
            print(f'  WARN: {message}')
        for message in result['errors']:
            print(f'  ERROR: {message}')
        if result['errors']:
            fatal_tables.append(table)

    if strict and fatal_tables:
        raise RuntimeError('Preflight failed in strict mode for: ' + ', '.join(fatal_tables))

    logger.info('Preflight complete for %s table(s).', len(tables))



def main(
    ust_or_release,
    control_id,
    table_name=None,
    overwrite_sql_file=True,
    print_console=False,
    strict=False,
    preflight_only=False,
):
    if preflight_only:
        preflight_report(
            ust_or_release=ust_or_release,
            control_id=control_id,
            table_name=table_name,
            strict=strict,
        )
        return

    dataset = Dataset(ust_or_release=ust_or_release,
                       control_id=control_id,
                      base_file_name='view_creation.sql',
                      export_file_name=export_file_name,
                      export_file_dir=export_file_dir,
                      export_file_path=export_file_path)

    if table_name:
        sql = ViewSql(dataset=dataset, 
                      table_name=table_name,
                      overwrite_sql_file=overwrite_sql_file,
                      print_console=print_console,
                      strict=strict)
        if print_console:
            print(sql.view_sql)
        else:
            logger.info('Generated view SQL for %s.%s', dataset.schema, sql.view_name)
    else:
        tables_needed = get_tables_needed(dataset)
        for table in tables_needed: 
            sql = ViewSql(dataset=dataset, 
                          table_name=table,
                          overwrite_sql_file=overwrite_sql_file,
                          print_console=print_console,
                          strict=strict)
            overwrite_sql_file = False
            # print(sql.view_sql)

    logger.info('Script complete.')


if __name__ == '__main__':   

    # dataset = Dataset(ust_or_release='release', control_id=4) 
    # epa_table_name = 'ust_release_substance'

    # join_tables = utils.get_join_tables(dataset,epa_table_name)
    # for j in join_tables:
    #     for k, v in j.items():
    #         print(k + ' = ' + str(v))
    # exit()
    main(ust_or_release=ust_or_release,
         control_id=control_id,
         table_name=table_name,
         overwrite_sql_file=overwrite_sql_file,
         print_console=print_console)
