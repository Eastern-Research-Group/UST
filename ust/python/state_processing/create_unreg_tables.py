import difflib
import string

import psycopg2

from ust.python.util import utils
from ust.python.util.dataset import Dataset
from ust.python.util.logger_factory import logger

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
        self.source_columns_cache = {}
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
        facility_row = self.cur.fetchone()
        self.org_facility_table = facility_row[0] if facility_row else None

        sql = f"""select organization_table_name 
                  from public.{self.dataset.ust_or_release}_element_mapping 
                  where {self.dataset.ust_or_release}_control_id = %s
                  and epa_column_name = 'substance_id' and epa_table_name = %s"""
        utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id, self.epa_substance_table))
        substance_row = self.cur.fetchone()
        self.org_substance_table = substance_row[0] if substance_row else None

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


    def _table_name_only(self, table):
        return table.replace(self.dataset.schema + '.', '')


    def _table_exists(self, table):
        sql = """select count(*) from information_schema.tables 
                  where table_schema = %s and table_name = %s"""
        utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.schema, self._table_name_only(table)))
        return self.cur.fetchone()[0] > 0


    def _quote_qualified_table(self, table):
        return f'{self.dataset.schema}."{self._table_name_only(table)}"'


    def _capture_dependent_view_definitions(self, tables):
        table_names = [self._table_name_only(table) for table in tables]
        sql = """select distinct dependent_view.relname as view_name,
                        pg_get_viewdef(dependent_view.oid, true) as view_definition
                 from pg_depend d
                 join pg_rewrite r on r.oid = d.objid
                 join pg_class dependent_view on dependent_view.oid = r.ev_class
                 join pg_namespace dependent_ns on dependent_ns.oid = dependent_view.relnamespace
                 join pg_class source_table on source_table.oid = d.refobjid
                 join pg_namespace source_ns on source_ns.oid = source_table.relnamespace
                 where source_ns.nspname = %s
                   and source_table.relname = any(%s)
                   and dependent_view.relkind in ('v', 'm')
                 order by dependent_view.relname"""
        utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.schema, table_names))
        return {row[0]: row[1] for row in self.cur.fetchall()}


    def _restore_schema_views(self, view_definitions):
        remaining = dict(view_definitions)
        while remaining:
            restored = []
            last_error = None
            for view_name, view_definition in remaining.items():
                try:
                    sql = f'create or replace view {self.dataset.schema}."{view_name}" as\n{view_definition}'
                    self.cur.execute(sql)
                    restored.append(view_name)
                    logger.info('Restored view %s.%s', self.dataset.schema, view_name)
                except psycopg2.Error as exc:
                    self.conn.rollback()
                    last_error = exc

            for view_name in restored:
                remaining.pop(view_name)

            if not restored:
                remaining_views = ', '.join(sorted(remaining))
                raise RuntimeError(f'Unable to restore dependent views after rebuilding unregulated tables: {remaining_views}') from last_error


    def _create_unreg_substance_table(self):
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


    def _create_unreg_parent_table(self):
        sql = f"""create table {self.unreg_parent_table} 
                    ({self.unreg_parent_col} varchar(50) not null primary key, 
                    unregulated_reason varchar(1000))"""
        utils.process_sql(self.conn, self.cur, sql)
        logger.info('Created table %s', self.unreg_parent_table)


    def rebuild_tables_preserving_views(self):
        tables = [self.unreg_substance_table, self.unreg_parent_table]
        view_definitions = self._capture_dependent_view_definitions(tables)
        for table in tables:
            if self._table_exists(table):
                self.backup_table(table)
        for table in tables:
            if self._table_exists(table):
                sql = f'drop table {self._quote_qualified_table(table)} cascade'
                utils.process_sql(self.conn, self.cur, sql)
                logger.info('Dropped table %s with dependent views; views will be restored.', table)
        self._create_unreg_substance_table()
        self._create_unreg_parent_table()
        self._restore_schema_views(view_definitions)


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
                raise RuntimeError(f'Table {table} already exists and drop_existing is False.')
            return True


    def create_tables(self):
        if self.views_only:
            return

        self.connect_db()

        if self.drop_existing:
            self.rebuild_tables_preserving_views()
            self.disconnect_db()
            return

        if self.drop_table(self.unreg_substance_table):
            self._create_unreg_substance_table()

        if self.drop_table(self.unreg_parent_table):
            self._create_unreg_parent_table()

        self.disconnect_db()


    def create_placeholder_substance_view(self):
        view_name = f'{self.dataset.schema}.{self.erg_substance_mapping_view}'
        if self.dataset.ust_or_release == 'ust':
            view_sql = f"""create or replace view {view_name} as
select null::varchar(50) as facility_id,
       null::int as tank_id,
       null::varchar(1000) as org_substance,
       null::varchar(200) as epa_substance,
       null::int as substance_id
where false"""
        else:
            view_sql = f"""create or replace view {view_name} as
select null::varchar(50) as release_id,
       null::varchar(1000) as org_substance,
       null::varchar(200) as epa_substance,
       null::int as substance_id
where false"""
        utils.process_sql(self.conn, self.cur, view_sql)
        logger.info('Created placeholder view %s', view_name)


    def create_placeholder_facility_type_view(self):
        view_name = f'{self.dataset.schema}.{self.erg_facility_type_mapping_view}'
        parent_col = 'facility_id' if self.dataset.ust_or_release == 'ust' else 'release_id'
        view_sql = f"""create or replace view {view_name} as
select null::varchar(50) as {parent_col},
       null::varchar(1000) as org_facility_type,
       null::varchar(200) as epa_facility_type,
       null::int as facility_type_id
where false"""
        utils.process_sql(self.conn, self.cur, view_sql)
        logger.info('Created placeholder view %s', view_name)


    def create_placeholder_tank_size_view(self):
        if self.dataset.ust_or_release == 'release':
            return
        view_name = f'{self.dataset.schema}.{self.erg_tank_size_view}'
        view_sql = f"""create or replace view {view_name} as
select null::varchar(50) as facility_id,
       null::int as tank_id,
       null::numeric as tank_capacity_gallons
where false"""
        utils.process_sql(self.conn, self.cur, view_sql)
        logger.info('Created placeholder view %s', view_name)


    def create_placeholder_unreg_subs_view(self):
        view_name = f'{self.dataset.schema}.{self.erg_unreg_subs_view}'
        if self.dataset.ust_or_release == 'ust':
            view_sql = f"""create or replace view {view_name} as
select null::varchar(50) as facility_id,
       null::int as tank_id,
       null::varchar(1000) as org_substance,
       null::varchar(200) as epa_substance,
       null::int as substance_id,
       null::varchar(1000) as unregulated_reason
where false"""
        else:
            view_sql = f"""create or replace view {view_name} as
select null::varchar(50) as release_id,
       null::varchar(1000) as org_substance,
       null::varchar(200) as epa_substance,
       null::int as substance_id,
       null::varchar(1000) as unregulated_reason
where false"""
        utils.process_sql(self.conn, self.cur, view_sql)
        logger.info('Created placeholder view %s', view_name)


    def _cast_unreg_view_col(self, col_alias, expression):
        cast_map = {
            'facility_id': 'varchar(50)',
            'release_id': 'varchar(50)',
            'tank_id': 'int',
            'org_substance': 'varchar(1000)',
            'epa_substance': 'varchar(200)',
            'substance_id': 'int',
            'org_facility_type': 'varchar(1000)',
            'epa_facility_type': 'varchar(200)',
            'facility_type_id': 'int',
            'tank_capacity_gallons': 'numeric',
        }
        datatype = cast_map.get(col_alias)
        if not datatype:
            return expression
        return f'{expression}::{datatype}'


    def _get_source_columns(self, table_name):
        if table_name in self.source_columns_cache:
            return self.source_columns_cache[table_name]
        sql = """select column_name
                 from information_schema.columns
                 where table_schema = %s and table_name = %s"""
        utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.schema, table_name))
        columns = [row[0] for row in self.cur.fetchall()]
        self.source_columns_cache[table_name] = columns
        return columns


    def _resolve_join_columns(self, join_table, from_table, join_column, join_fk):
        if join_fk:
            return self._resolve_source_column(join_table, join_column), self._resolve_source_column(from_table, join_fk)

        join_columns = self._get_source_columns(join_table)
        from_columns = self._get_source_columns(from_table)

        if join_column in join_columns:
            return join_column, join_column

        if join_column in from_columns:
            join_columns_by_lower = {column.lower(): column for column in join_columns}
            matching_join_column = join_columns_by_lower.get(join_column.lower())
            if matching_join_column:
                return matching_join_column, join_column

        return join_column, join_column


    def _resolve_source_column(self, table_name, column_name):
        columns = self._get_source_columns(table_name)
        if column_name in columns:
            return column_name
        columns_by_lower = {column.lower(): column for column in columns}
        matched_column = columns_by_lower.get(str(column_name).lower())
        if matched_column:
            return matched_column
        close_matches = difflib.get_close_matches(str(column_name).lower(), list(columns_by_lower), n=2, cutoff=0.95)
        if len(close_matches) == 1:
            logger.warning(
                'Using close source column match %s.%s for mapped column %s.',
                table_name,
                columns_by_lower[close_matches[0]],
                column_name,
            )
            return columns_by_lower[close_matches[0]]
        return column_name


    def _build_join_predicate(self, join_table, from_table, join_column, join_fk, join_alias, from_alias):
        join_column, from_column = self._resolve_join_columns(join_table, from_table, join_column, join_fk)
        return f'{join_alias}."{join_column}" = {from_alias}."{from_column}"'


    def _build_inferred_source_join_predicates(self, join_table, from_table, join_alias, from_alias):
        join_columns = self._get_source_columns(join_table)
        from_columns = self._get_source_columns(from_table)
        join_columns_by_lower = {column.lower(): column for column in join_columns}
        from_columns_by_lower = {column.lower(): column for column in from_columns}
        common_keys = [
            key for key in join_columns_by_lower
            if key in from_columns_by_lower and ('id' in key or key.endswith('number') or key.endswith('name'))
        ]
        return [
            f'{join_alias}."{join_columns_by_lower[key]}" = {from_alias}."{from_columns_by_lower[key]}"'
            for key in sorted(common_keys)
        ]


    def _append_missing_source_join(self, from_sql, joined_tables, base_table, from_table, aliases):
        if from_table in joined_tables or from_table == base_table:
            return from_sql
        join_predicates = self._build_inferred_source_join_predicates(
            base_table,
            from_table,
            aliases[base_table],
            aliases[from_table],
        )
        if not join_predicates:
            return from_sql
        joined_tables.add(from_table)
        return (
            from_sql
            + f' join {self.dataset.schema}."{from_table}" {aliases[from_table]} '
            + ' on ' + ' and '.join(join_predicates) + ' '
        )


    def create_substance_view(self):
        self.connect_db()

        view_name = f'{self.dataset.schema}.{self.erg_substance_mapping_view}'
        
        sql = f"""select count(*) from public.{self.dataset.ust_or_release}_element_mapping 
                  where {self.dataset.ust_or_release}_control_id = %s and epa_column_name = 'substance_id'"""
        utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id,))
        cnt = self.cur.fetchone()[0]
        if cnt == 0:
            logger.warning('No substances mapped; creating placeholder %s', view_name)
            self.create_placeholder_substance_view()
            self.disconnect_db()
            return 

        sql = f"""select epa_column_name,
                    case when deagg_column_name is not null then deagg_column_name else organization_column_name end as organization_column_name, 
                    case when deagg_table_name is not null then deagg_table_name else organization_table_name end as organization_table_name, 
                    organization_join_table, organization_join_column, organization_join_fk
                from public.{self.dataset.ust_or_release}_element_mapping a join public.v_{self.dataset.ust_or_release}_sort_order b 
                    on a.epa_table_name = b.table_name and a.epa_column_name = b.column_name 
                where {self.dataset.ust_or_release}_control_id = %s
                and epa_table_name = %s
                and epa_column_name in ('facility_id', 'tank_id', 'release_id', 'substance_id')
                order by b.column_sort_order"""
        utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id, self.epa_substance_table), print_sql=False)
        rows = self.cur.fetchall()
        if not rows:
            logger.warning('No mapping rows found to build %s; creating placeholder view.', view_name)
            self.create_placeholder_substance_view()
            self.disconnect_db()
            return

        epa_cols, org_cols, org_tables, org_join_tables, org_join_cols, org_join_fks = map(list, zip(*rows))
        unique_org_tables = list(dict.fromkeys(org_tables))
        aliases = dict(zip(unique_org_tables, string.ascii_lowercase))
        # print(aliases)

        select_sql = "select "
        base_table = unique_org_tables[0]
        joined_tables = {base_table}
        from_sql = f'\nfrom {self.dataset.schema}."{base_table}" {aliases[base_table]}'
        org_val_col = ''

        for i in range(len(epa_cols)):
            org_cols[i] = self._resolve_source_column(org_tables[i], org_cols[i])
            if not org_join_tables[i]:
                from_sql = self._append_missing_source_join(from_sql, joined_tables, base_table, org_tables[i], aliases)
            if epa_cols[i] == 'substance_id':
                org_val_col = f'{aliases[org_tables[i]]}."{org_cols[i]}"'
                col_alias = 'org_substance'
            else:
                col_alias = epa_cols[i]
            source_expression = f'{aliases[org_tables[i]]}."{org_cols[i]}"'
            casted_expression = self._cast_unreg_view_col(col_alias, source_expression)
            select_sql += f'{casted_expression} as {col_alias}, '
            if org_join_tables[i]:
                from_sql += f' join {self.dataset.schema}."{org_tables[i]}" {aliases[org_tables[i]]} '
                joined_tables.add(org_tables[i])
                from_sql += ' on ' + self._build_join_predicate(
                    org_join_tables[i],
                    org_tables[i],
                    org_join_cols[i],
                    org_join_fks[i],
                    aliases[org_join_tables[i]],
                    aliases[org_tables[i]],
                ) + ' '

        select_sql += (
            f"{self._cast_unreg_view_col('epa_substance', 's.substance')} as epa_substance, "
            f"{self._cast_unreg_view_col('substance_id', 's.substance_id')} as substance_id"
        )
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
            logger.warning('No facility types mapped; creating placeholder %s', view_name)
            self.create_placeholder_facility_type_view()
            self.disconnect_db()
            return 

        sql = f"""select distinct replace(replace(epa_column_name,'1','_id'),'2','_id') as epa_column_name, 
                    organization_column_name, organization_table_name, organization_join_table, organization_join_column, organization_join_fk,
                    (epa_column_name ilike '%%type%%') as sort_order
                from public.{self.dataset.ust_or_release}_element_mapping 
                where {self.dataset.ust_or_release}_control_id = %s
                and epa_table_name = %s
                and epa_column_name in ('facility_id','facility_type1','facility_type2','release_id','facility_type_id')
                order by (epa_column_name ilike '%%type%%')"""
        utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id, self.epa_facility_table), print_sql=False)
        rows = self.cur.fetchall()
        if not rows:
            logger.warning('No mapping rows found to build %s; creating placeholder view.', view_name)
            self.create_placeholder_facility_type_view()
            self.disconnect_db()
            return

        epa_cols, org_cols, org_tables, org_join_tables, org_join_cols, org_join_fks, _nulls = map(list, zip(*rows))
        unique_org_tables = list(dict.fromkeys(org_tables))
        aliases = dict(zip(unique_org_tables, string.ascii_lowercase))

        select_sql = "select "
        base_table = unique_org_tables[0]
        joined_tables = {base_table}
        from_sql = f'\nfrom {self.dataset.schema}."{base_table}" {aliases[base_table]}'
        org_val_col = ''

        for i in range(len(epa_cols)):
            org_cols[i] = self._resolve_source_column(org_tables[i], org_cols[i])
            if not org_join_tables[i]:
                from_sql = self._append_missing_source_join(from_sql, joined_tables, base_table, org_tables[i], aliases)
            if epa_cols[i] == 'facility_type_id':
                org_val_col = f'{aliases[org_tables[i]]}."{org_cols[i]}"'
                col_alias = 'org_facility_type'
            else:
                col_alias = epa_cols[i]
            source_expression = f'{aliases[org_tables[i]]}."{org_cols[i]}"'
            casted_expression = self._cast_unreg_view_col(col_alias, source_expression)
            select_sql += f'{casted_expression} as {col_alias}, '
            if org_join_tables[i]:
                from_sql += f' join {self.dataset.schema}."{org_tables[i]}" {aliases[org_tables[i]]} '
                joined_tables.add(org_tables[i])
                from_sql += ' on ' + self._build_join_predicate(
                    org_join_tables[i],
                    org_tables[i],
                    org_join_cols[i],
                    org_join_fks[i],
                    aliases[org_join_tables[i]],
                    aliases[org_tables[i]],
                ) + ' '

        select_sql += (
            f"{self._cast_unreg_view_col('epa_facility_type', 'ft.facility_type')} as epa_facility_type, "
            f"{self._cast_unreg_view_col('facility_type_id', 'ft.facility_type_id')} as facility_type_id"
        )
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
            logger.warning('No compartment sizes available; creating placeholder %s', view_name)
            self.create_placeholder_tank_size_view()
            self.disconnect_db()
            return 

        sql = """select epa_column_name, organization_column_name, organization_table_name, organization_join_table, organization_join_column, organization_join_fk
                from public.ust_element_mapping a join public.v_ust_sort_order b 
                    on a.epa_table_name = b.table_name and a.epa_column_name = b.column_name 
                where ust_control_id = %s
                and epa_table_name = 'ust_compartment'
                and epa_column_name in ('facility_id', 'tank_id', 'compartment_capacity_gallons')
                order by b.column_sort_order"""
        utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.control_id,), print_sql=False)
        rows = self.cur.fetchall()
        if not rows:
            logger.warning('No mapping rows found to build %s; creating placeholder view.', view_name)
            self.create_placeholder_tank_size_view()
            self.disconnect_db()
            return

        epa_cols, org_cols, org_tables, org_join_tables, org_join_cols, org_join_fks = map(list, zip(*rows))
        unique_org_tables = list(dict.fromkeys(org_tables))
        aliases = dict(zip(unique_org_tables, string.ascii_lowercase))
        groupby_cols = [f'"{c}"' for c in epa_cols if c != 'compartment_capacity_gallons']

        select_sql = "select "
        base_table = unique_org_tables[0]
        joined_tables = {base_table}
        from_sql = f'\nfrom {self.dataset.schema}."{base_table}" {aliases[base_table]}'
        groupby_sql = f'\ngroup by {', '.join(groupby_cols)}'

        for i in range(len(epa_cols)):
            org_cols[i] = self._resolve_source_column(org_tables[i], org_cols[i])
            if not org_join_tables[i]:
                from_sql = self._append_missing_source_join(from_sql, joined_tables, base_table, org_tables[i], aliases)
            select_col = f'{aliases[org_tables[i]]}."{org_cols[i]}"'
            if epa_cols[i] == 'compartment_capacity_gallons':
                select_sql += f"{self._cast_unreg_view_col('tank_capacity_gallons', f'sum({select_col})')} as tank_capacity_gallons"
            else:
                casted_expression = self._cast_unreg_view_col(epa_cols[i], select_col)
                select_sql += f'{casted_expression} as {epa_cols[i]}, '
            if org_join_tables[i]:
                from_sql += f' join {self.dataset.schema}."{org_tables[i]}" {aliases[org_tables[i]]} '
                joined_tables.add(org_tables[i])
                from_sql += ' on ' + self._build_join_predicate(
                    org_join_tables[i],
                    org_tables[i],
                    org_join_cols[i],
                    org_join_fks[i],
                    aliases[org_join_tables[i]],
                    aliases[org_tables[i]],
                ) + ' '
        
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
            self.create_placeholder_unreg_subs_view()
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

