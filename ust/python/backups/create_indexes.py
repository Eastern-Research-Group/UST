
"""Recreate indexes expected by the UST database conventions.

PostgreSQL does not retain definitions for indexes that were dropped, so this
script derives the recoverable index set from current tables, foreign keys,
and the project's existing lookup/data-table conventions.
"""

import argparse
import hashlib
import re

from ust.python.util import utils
from ust.python.util.logger_factory import logger


INDEXED_COLUMNS_SQL = """
select
    n.nspname as schema_name,
    table_class.relname as table_name,
    index_metadata.indexrelid as index_id,
    attribute.attname as column_name,
    index_column.ordinality
from pg_index index_metadata
join pg_class table_class on table_class.oid = index_metadata.indrelid
join pg_namespace n on n.oid = table_class.relnamespace
cross join lateral unnest(index_metadata.indkey) with ordinality as index_column(attnum, ordinality)
join pg_attribute attribute
    on attribute.attrelid = table_class.oid
    and attribute.attnum = index_column.attnum
where index_metadata.indpred is null
  and index_metadata.indexprs is null
order by n.nspname, table_class.relname, index_metadata.indexrelid, index_column.ordinality
"""


TABLES_SQL = """
select table_schema, table_name
from information_schema.tables
where table_type = 'BASE TABLE'
  and table_schema not in ('pg_catalog', 'information_schema')
order by table_schema, table_name
"""


COLUMNS_SQL = """
select table_schema, table_name, column_name, ordinal_position
from information_schema.columns
where table_schema not in ('pg_catalog', 'information_schema')
order by table_schema, table_name, ordinal_position
"""


FOREIGN_KEYS_SQL = """
select
        key_columns.table_schema as schema_name,
        key_columns.table_name,
    key_columns.constraint_name,
    key_columns.column_name,
    key_columns.ordinal_position
from information_schema.key_column_usage key_columns
join information_schema.table_constraints constraints
        on constraints.constraint_schema = key_columns.constraint_schema
        and constraints.constraint_name = key_columns.constraint_name
        and constraints.table_name = key_columns.table_name
where constraints.constraint_type = 'FOREIGN KEY'
    and key_columns.constraint_schema not in ('pg_catalog', 'information_schema')
order by key_columns.table_schema, key_columns.table_name, key_columns.constraint_name, key_columns.ordinal_position
"""


def quote_identifier(identifier):
    return '"' + identifier.replace('"', '""') + '"'


def index_name(schema_name, table_name, columns):
    raw_name = 'ix_' + table_name + '_' + '_'.join(columns)
    if len(raw_name) <= 63:
        return raw_name
    digest = hashlib.sha1(f'{schema_name}.{raw_name}'.encode()).hexdigest()[:8]
    return raw_name[:54] + '_' + digest


def load_indexed_columns(cur):
    cur.execute(INDEXED_COLUMNS_SQL)
    grouped = {}
    for schema_name, table_name, index_id, column_name, _ in cur.fetchall():
        grouped.setdefault((schema_name, table_name, index_id), []).append(column_name)
    return {
        (schema_name, table_name, tuple(columns))
        for (schema_name, table_name, _), columns in grouped.items()
    }


def load_tables(cur):
    cur.execute(TABLES_SQL)
    return {(row[0], row[1]) for row in cur.fetchall()}


def load_columns(cur):
    cur.execute(COLUMNS_SQL)
    columns = {}
    for schema_name, table_name, column_name, ordinal_position in cur.fetchall():
        columns.setdefault((schema_name, table_name), []).append((column_name, ordinal_position))
    return columns


def load_foreign_keys(cur):
    cur.execute(FOREIGN_KEYS_SQL)
    grouped = {}
    for schema_name, table_name, constraint_name, column_name, _ in cur.fetchall():
        grouped.setdefault((schema_name, table_name, constraint_name), []).append(column_name)
    return {
        (schema_name, table_name, tuple(columns))
        for (schema_name, table_name, _), columns in grouped.items()
    }


def expected_index_columns(tables, columns, foreign_keys):
    expected = set(foreign_keys)

    for schema_name, table_name in tables:
        table_columns = columns.get((schema_name, table_name), [])
        if schema_name != 'public' or table_name == 'states':
            continue
        if not table_name.startswith(('release', 'ust')):
            second_column = [name for name, position in table_columns if position == 2]
            if second_column:
                expected.add((schema_name, table_name, (second_column[0],)))
        else:
            for column_name, _ in table_columns:
                if re.search(r'_id$', column_name):
                    expected.add((schema_name, table_name, (column_name,)))

    return expected


def build_index_statements(cur):
    tables = load_tables(cur)
    columns = load_columns(cur)
    foreign_keys = load_foreign_keys(cur)
    existing = load_indexed_columns(cur)
    expected = expected_index_columns(tables, columns, foreign_keys)

    statements = []
    for schema_name, table_name, indexed_columns in sorted(expected):
        if (schema_name, table_name, indexed_columns) in existing:
            continue
        name = index_name(schema_name, table_name, indexed_columns)
        qualified_columns = ', '.join(quote_identifier(column) for column in indexed_columns)
        statements.append(
            f'create index if not exists {quote_identifier(name)} '
            f'on {quote_identifier(schema_name)}.{quote_identifier(table_name)} ({qualified_columns});'
        )
    return statements


def recreate_indexes(apply=False):
    conn = utils.connect_db()
    try:
        with conn.cursor() as cur:
            statements = build_index_statements(cur)
            if not statements:
                logger.info('No missing indexes found.')
                return []
            for statement in statements:
                if apply:
                    cur.execute(statement)
                    logger.info('Created index from: %s', statement)
                else:
                    print(statement)
            if not apply:
                logger.info('%s index statements generated; rerun with --apply to execute them.', len(statements))
            return statements
    finally:
        conn.close()


def main():
    parser = argparse.ArgumentParser(description='Recreate missing indexes from the current PostgreSQL database catalog')
    parser.add_argument('--apply', action='store_true', help='Execute the generated CREATE INDEX statements')
    args = parser.parse_args()
    recreate_indexes(apply=args.apply)


if __name__ == '__main__':
    main()
