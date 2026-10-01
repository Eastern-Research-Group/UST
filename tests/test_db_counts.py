from unittest.mock import MagicMock

import pytest

import main as cli
from ust.python.util import db_counts


@pytest.mark.parametrize('name,expected', [
    ('ust_facility', True), ('release', True), ('unrelated_table', True),
    ('ust_template_data_tables', True), ('attempt', True),
    ('temp', False), ('TEMP_ust', False), ('ust_tmp', False),
    ('ust_backup', False), ('ust_bkup_20260929', False), ('ust_bak', False),
    ('ust_bkp20260929', False), ('backup20260929_ust', False),
    ('ust.bak', False), ('ust_backups', False), ('temporary_ust', False),
])
def test_table_selection(name, expected):
    assert db_counts.important_table(name) is expected


def test_snapshot_then_comparison(tmp_path, monkeypatch, capsys):
    counts = {'comments': 123, 'form_letter_predictions': 0, 'fdms_comments': 45}
    monkeypatch.setattr(db_counts, 'collect_counts', lambda: (counts, '2026-09-29T12:00:00+00:00'))
    baseline = tmp_path / 'baseline.csv'
    assert cli.main(['db-counts', '--save-baseline', '--output', str(baseline)]) == 0
    assert db_counts.read_baseline(baseline) == counts
    assert cli.main(['db-counts', '--compare', str(baseline), '--output', str(tmp_path / 'aws.csv')]) == 0
    assert 'PASS: all 3 table counts match' in capsys.readouterr().out
    counts['comments'] = 120
    del counts['fdms_comments']
    counts['keywords_new'] = 0
    assert db_counts.run(tmp_path / 'different.csv', baseline) == 1
    output = capsys.readouterr().out
    assert '[MISMATCH] public.comments: 120 | baseline: 123 | difference: -3' in output
    assert '[MISSING TABLE] public.fdms_comments' in output
    assert '[NEW TABLE] public.keywords_new' in output


def test_empty_baseline_is_not_saved(tmp_path, monkeypatch):
    monkeypatch.setattr(db_counts, 'collect_counts', lambda: ({}, 'now'))
    target = tmp_path / 'empty.csv'
    assert db_counts.run(target) == 2
    assert not target.exists()


def test_cli_defaults_to_repository_baseline(monkeypatch):
    run = MagicMock(return_value=0)
    monkeypatch.setattr(db_counts, 'run', run)
    assert cli.main(['db-counts']) == 0
    run.assert_called_once_with('aws-db-counts.csv', db_counts.DEFAULT_BASELINE)
    assert db_counts.DEFAULT_BASELINE.is_absolute()


def test_missing_default_baseline_fails_before_connecting(tmp_path, monkeypatch, capsys):
    monkeypatch.setattr(db_counts, 'DEFAULT_BASELINE', tmp_path / 'missing.csv')
    collect = MagicMock()
    monkeypatch.setattr(db_counts, 'collect_counts', collect)
    assert cli.main(['db-counts', '--output', str(tmp_path / 'out.csv')]) == 2
    collect.assert_not_called()
    assert 'Baseline not found' in capsys.readouterr().out


def test_existing_output_is_preserved(tmp_path, monkeypatch):
    target = tmp_path / 'baseline.csv'
    target.write_text('original')
    collect = MagicMock()
    monkeypatch.setattr(db_counts, 'collect_counts', collect)
    assert db_counts.run(target) == 2
    assert target.read_text() == 'original'
    collect.assert_not_called()


def test_query_error_does_not_create_report_or_expose_secrets(tmp_path, monkeypatch, capsys):
    collect = MagicMock(side_effect=db_counts.psycopg2.OperationalError('secret password'))
    monkeypatch.setattr(db_counts, 'collect_counts', collect)
    target = tmp_path / 'counts.csv'
    assert db_counts.run(target) == 2
    assert not target.exists()
    assert 'secret password' not in capsys.readouterr().out


def test_invalid_baseline_stops_before_connecting(tmp_path, monkeypatch):
    baseline = tmp_path / 'bad.csv'
    baseline.write_text('table,row_count\ncomments,0\n')
    collect = MagicMock()
    monkeypatch.setattr(db_counts, 'collect_counts', collect)
    assert db_counts.run(tmp_path / 'out.csv', baseline) == 2
    collect.assert_not_called()


def test_consistent_readonly_transaction_and_cleanup(monkeypatch):
    for name in ('db_ip', 'db_name', 'db_user', 'db_password'):
        monkeypatch.setattr(db_counts.config, name, 'test')
    connection = MagicMock()
    cursor = connection.cursor.return_value.__enter__.return_value
    cursor.fetchall.return_value = [('comments',), ('form_letter_predictions',), ('comments_bkup',)]
    cursor.fetchone.side_effect = [(10,), (0,)]
    monkeypatch.setattr(db_counts.psycopg2, 'connect', MagicMock(return_value=connection))
    counts, timestamp = db_counts.collect_counts()
    assert counts == {'comments': 10, 'form_letter_predictions': 0}
    assert timestamp
    connection.set_session.assert_called_once_with(isolation_level='REPEATABLE READ', readonly=True)
    assert ('SET LOCAL row_security = off',) in [call.args for call in cursor.execute.call_args_list]
    connection.close.assert_called_once()


def test_all_tables_missing_is_failure(tmp_path, monkeypatch):
    baseline = tmp_path / 'baseline.csv'
    monkeypatch.setattr(db_counts, 'collect_counts', lambda: ({'ust': 0}, 'now'))
    assert db_counts.run(baseline) == 0
    monkeypatch.setattr(db_counts, 'collect_counts', lambda: ({}, 'later'))
    assert db_counts.run(tmp_path / 'missing.csv', baseline) == 1
