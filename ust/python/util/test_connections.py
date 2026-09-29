"""Read-only database connectivity diagnostics."""

from contextlib import closing

import psycopg2

from ust.python.util import config


def _postgres(timeout):
    with closing(psycopg2.connect(
        host=config.db_ip,
        dbname=config.db_name,
        user=config.db_user,
        password=config.db_password,
        port=5432,
        connect_timeout=timeout,
        options=f'-c statement_timeout={timeout * 1000}',
    )) as connection, connection.cursor() as cursor:
        cursor.execute('SELECT 1')
        if cursor.fetchone()[0] != 1:
            raise RuntimeError('Unexpected query result')
    return 'Authenticated; SELECT 1 succeeded'


def run_checks(timeout=10):
    """Test the configured PostgreSQL database and return a process exit code."""
    required = ('db_ip', 'db_name', 'db_user', 'db_password')
    missing = [name for name in required if not getattr(config, name)]

    print('Testing effective configuration (.env settings with environment-variable overrides).', flush=True)
    print('\nUST database', flush=True)
    print('  Checking...', flush=True)

    if missing:
        detail = 'Missing: ' + ', '.join('UST_' + name.upper() for name in missing)
        print(f'  [FAIL] {detail}', flush=True)
        print('\nSummary: 0 passed, 1 failed.')
        return 1

    try:
        detail = _postgres(timeout)
    except Exception as exc:  # Do not expose connection strings or credentials from driver errors.
        detail = (
            f'{type(exc).__name__}: check configuration, credentials, network/VPN, '
            'permissions, and required drivers'
        )
        print(f'  [FAIL] {detail}', flush=True)
        print('\nSummary: 0 passed, 1 failed.')
        return 1

    print(f'  [PASS] {detail}', flush=True)
    print('\nSummary: 1 passed, 0 failed.')
    return 0