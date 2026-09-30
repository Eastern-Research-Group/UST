from unittest.mock import MagicMock, patch

import pytest

import main
from ust.python.backups import save_ddl


def cursor_for(relations=(), routines=(), table=False):
    cursor = MagicMock()
    cursor.fetchone.side_effect = [(1,)] + ([(42,), ('CREATE TABLE public.t (id integer)',)] if table else [])
    cursor.fetchall.side_effect = [list(relations)] + ([ [('ALTER TABLE public.t ADD CONSTRAINT t_pkey PRIMARY KEY (id)',)], [('CREATE INDEX t_idx ON public.t (id)',)]] if table else []) + [list(routines)]
    return cursor


def test_routines_preserve_overloads_and_exclude_backups():
    cursor = cursor_for(routines=[
        ('f', 'CREATE OR REPLACE FUNCTION public.f() RETURNS int LANGUAGE sql AS $$ SELECT 1 $$'),
        ('f', 'CREATE OR REPLACE FUNCTION public.f(int) RETURNS int LANGUAGE sql AS $$ SELECT $1 $$'),
        ('f_bak', 'ignored'),
    ])
    files = save_ddl.Ddl()._collect(cursor)
    assert list(files) == [('function', 'f')]
    assert files[('function', 'f')].count('CREATE OR REPLACE FUNCTION') == 2
    assert files[('function', 'f')].endswith(';\n\n')


def test_table_queries_scope_constraints_and_exclude_constraint_indexes():
    cursor = cursor_for([(42, 't', 'r', 'public.t')], table=True)
    files = save_ddl.Ddl()._collect(cursor)
    assert files[('table', 't')].count(';') == 3
    calls = cursor.execute.call_args_list
    assert any('WHERE conrelid = %s' in c.args[0] and c.args[1] == ('public.t', 42) for c in calls)
    assert any('c.conindid = i.indexrelid' in c.args[0] for c in calls)


def test_view_uses_quoted_catalog_name_and_oid():
    cursor = cursor_for([(7, 'Odd View', 'v', '"public"."Odd View"')])
    cursor.fetchone.side_effect = [(1,), ('SELECT 1;',)]
    files = save_ddl.Ddl()._collect(cursor)
    assert files[('view', 'Odd View')] == 'CREATE OR REPLACE VIEW "public"."Odd View" AS\nSELECT 1;\n'
    cursor.execute.assert_any_call('SELECT pg_catalog.pg_get_viewdef(%s, true)', (7,))


def test_missing_helper_is_clear():
    cursor = cursor_for([(42, 't', 'r', 'public.t')])
    cursor.fetchone.side_effect = [(1,), (None,)]
    with pytest.raises(ValueError, match='require public.generate_create_table_statement'):
        save_ddl.Ddl()._collect(cursor)


def test_filters_and_exact_object_names():
    assert save_ddl.Ddl()._included('ust_template_data_tables')
    assert not save_ddl.Ddl()._included('ust_bak2026')
    assert save_ddl.Ddl(include_temp_backup=True)._included('ust_bak2026')
    assert save_ddl.Ddl(object_name='Odd Name')._included('Odd Name')
    assert not save_ddl.Ddl(object_name='Odd Name')._included('odd name')


@pytest.mark.parametrize('name', ['../escape', 'a/b', 'a\\b', 'CON', 'name.'])
def test_safe_filename(name):
    encoded = save_ddl._filename(name)
    assert '/' not in encoded and '\\' not in encoded
    assert encoded != name


def test_export_closes_connection_and_writes_utf8(tmp_path, monkeypatch):
    for name in ('db_ip', 'db_name', 'db_user', 'db_password'):
        monkeypatch.setattr(save_ddl.config, name, 'test')
    conn = MagicMock()
    monkeypatch.setattr(save_ddl.psycopg2, 'connect', lambda **kw: conn)
    monkeypatch.setattr(save_ddl.Ddl, '_collect', lambda self, cursor: {('view', 'v'): '-- café\n'})
    assert save_ddl.main(export_path=tmp_path) == 1
    assert (tmp_path / 'public/view/v.sql').read_text(encoding='utf-8') == '-- café\n'
    conn.set_session.assert_called_once_with(isolation_level='REPEATABLE READ', readonly=True)
    conn.close.assert_called_once()


def test_failed_collection_preserves_existing_files(tmp_path, monkeypatch):
    for name in ('db_ip', 'db_name', 'db_user', 'db_password'):
        monkeypatch.setattr(save_ddl.config, name, 'test')
    conn = MagicMock()
    monkeypatch.setattr(save_ddl.psycopg2, 'connect', lambda **kw: conn)
    target = tmp_path / 'public/view/v.sql'
    target.parent.mkdir(parents=True)
    target.write_text('original')
    with patch.object(save_ddl.Ddl, '_collect', side_effect=ValueError('failure')):
        assert save_ddl.run(export_path=tmp_path) == 1
    assert target.read_text() == 'original'
    conn.close.assert_called_once()


def test_cli_dispatch():
    with patch.object(save_ddl, 'run', return_value=0) as run:
        assert main.main(['save-ddl', '--schema', 'or_ust', '--output', 'ddl',
                          '--object-name', 'v_ust', '--include-temp-backup']) == 0
        run.assert_called_once_with(schema='or_ust', export_path='ddl', object_name='v_ust', include_temp_backup=True)


def test_cli_defaults():
    with patch.object(save_ddl, 'run', return_value=0) as run:
        assert main.main(['save-ddl']) == 0
        run.assert_called_once_with(schema='public', export_path=None, object_name=None, include_temp_backup=False)
