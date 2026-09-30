"""Export reviewable per-object DDL using the configured PostgreSQL database."""

from contextlib import closing
from pathlib import Path
from urllib.parse import quote

import psycopg2

from ust.python.util import config
from ust.python.util.db_counts import important_table

DEFAULT_EXPORT_PATH = Path(__file__).resolve().parents[2] / 'sql' / 'ddl'


def _filename(name):
    # Encode unsafe Windows/path characters while preserving ordinary object names.
    encoded = quote(name, safe='_-')
    if encoded.rstrip('.').upper() in {'CON', 'PRN', 'AUX', 'NUL'} | {
        f'{prefix}{number}' for prefix in ('COM', 'LPT') for number in range(1, 10)
    } or encoded.endswith('.'):
        encoded = ''.join(f'%{byte:02X}' for byte in name.encode('utf-8'))
    return encoded


def _statement(value):
    if not value or not value.strip():
        raise ValueError('The database returned an empty DDL definition.')
    return value.rstrip().rstrip(';') + ';\n'


class Ddl:
    def __init__(self, schema='public', export_path=None, object_name=None,
                 include_temp_backup=False):
        self.schema = schema
        self.object_name = object_name
        self.include_temp_backup = include_temp_backup
        self.export_path = Path(export_path or DEFAULT_EXPORT_PATH).expanduser() / _filename(schema)

    def _included(self, name):
        return (self.object_name is None or name == self.object_name) and (
            self.include_temp_backup or important_table(name)
        )

    def _collect(self, cursor):
        cursor.execute('SELECT oid FROM pg_catalog.pg_namespace WHERE nspname = %s', (self.schema,))
        if cursor.fetchone() is None:
            raise ValueError(f'Schema does not exist: {self.schema}')
        cursor.execute("""
            SELECT c.oid, c.relname, c.relkind,
                   format('%%I.%%I', n.nspname, c.relname)
            FROM pg_catalog.pg_class c
            JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
            WHERE n.nspname = %s AND c.relkind IN ('r', 'p', 'v', 'm')
            ORDER BY c.relname
        """, (self.schema,))
        relations = [row for row in cursor.fetchall() if self._included(row[1])]
        if any(row[2] in ('r', 'p') for row in relations):
            cursor.execute("SELECT to_regprocedure('public.generate_create_table_statement(character varying,character varying)')")
            if cursor.fetchone()[0] is None:
                raise ValueError('Table exports require public.generate_create_table_statement(varchar, varchar).')
        files = {}
        for oid, name, kind, qualified in relations:
            if kind in ('v', 'm'):
                cursor.execute('SELECT pg_catalog.pg_get_viewdef(%s, true)', (oid,))
                definition = _statement(cursor.fetchone()[0])
                prefix = 'CREATE OR REPLACE VIEW' if kind == 'v' else 'CREATE MATERIALIZED VIEW'
                if kind == 'm':
                    definition = definition.rstrip().rstrip(';') + ' WITH NO DATA;\n'
                folder = 'view' if kind == 'v' else 'materialized_view'
                files[(folder, name)] = f'{prefix} {qualified} AS\n{definition}'
                continue
            cursor.execute('SELECT public.generate_create_table_statement(%s, %s)', (self.schema, name))
            parts = [_statement(cursor.fetchone()[0])]
            cursor.execute("""
                SELECT format('ALTER TABLE %%s ADD CONSTRAINT %%I %%s;',
                              %s, conname, pg_catalog.pg_get_constraintdef(oid))
                FROM pg_catalog.pg_constraint
                WHERE conrelid = %s AND contype IN ('p', 'u', 'f', 'c', 'x')
                ORDER BY conname
            """, (qualified, oid))
            parts.extend(_statement(row[0]) for row in cursor.fetchall())
            cursor.execute("""
                SELECT pg_catalog.pg_get_indexdef(i.indexrelid)
                FROM pg_catalog.pg_index i
                WHERE i.indrelid = %s AND NOT EXISTS (
                    SELECT 1 FROM pg_catalog.pg_constraint c
                    WHERE c.conindid = i.indexrelid AND c.contype IN ('p', 'u', 'x')
                ) ORDER BY i.indexrelid::regclass::text
            """, (oid,))
            parts.extend(_statement(row[0]) for row in cursor.fetchall())
            files[('table', name)] = '\n'.join(parts)
        cursor.execute("""
            SELECT p.proname, pg_catalog.pg_get_functiondef(p.oid)
            FROM pg_catalog.pg_proc p
            JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace
            WHERE n.nspname = %s AND p.prokind IN ('f', 'p')
            ORDER BY p.proname, pg_catalog.pg_get_function_identity_arguments(p.oid)
        """, (self.schema,))
        for name, definition in cursor.fetchall():
            if self._included(name):
                key = ('function', name)
                files[key] = files.get(key, '') + _statement(definition) + '\n'
        if not files:
            raise ValueError('No matching objects found (temp/backup names are excluded by default).')
        return files

    def export(self):
        required = ('db_ip', 'db_name', 'db_user', 'db_password')
        missing = ['UST_' + name.upper() for name in required if not getattr(config, name)]
        if missing:
            raise ValueError('Missing settings: ' + ', '.join(missing))
        with closing(psycopg2.connect(
            host=config.db_ip, dbname=config.db_name, user=config.db_user,
            password=config.db_password, port=5432, connect_timeout=10,
        )) as connection:
            connection.set_session(isolation_level='REPEATABLE READ', readonly=True)
            with connection.cursor() as cursor:
                cursor.execute("SET LOCAL statement_timeout = '2min'")
                files = self._collect(cursor)
        # Finish all queries before replacing any existing exports.
        destinations = {}
        for (kind, name), definition in files.items():
            path = self.export_path / kind / (_filename(name) + '.sql')
            key = str(path).casefold()
            if key in destinations:
                raise ValueError('Object names collide on a case-insensitive filesystem; no files written.')
            destinations[key] = (path, definition)
        for path, definition in destinations.values():
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(definition, encoding='utf-8')
        print(f'Saved {len(files)} DDL files to {self.export_path.resolve()}')
        return len(files)


def main(schema='public', export_path=None, object_name=None, include_temp_backup=False):
    return Ddl(schema, export_path, object_name, include_temp_backup).export()


def run(schema='public', export_path=None, object_name=None, include_temp_backup=False):
    try:
        main(schema, export_path, object_name, include_temp_backup)
    except (ValueError, OSError, psycopg2.Error) as exc:
        detail = str(exc) if isinstance(exc, ValueError) else type(exc).__name__
        print(f'DDL export failed: {detail}. Check configuration, database access, and output path.')
        return 1
    return 0


if __name__ == '__main__':
    raise SystemExit(run())
