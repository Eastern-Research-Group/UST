import os
from pathlib import Path
from types import SimpleNamespace

from dotenv import dotenv_values

_REPO_ROOT = Path(__file__).resolve().parents[3]
_ENV_FILE = Path(os.environ.get('UST_ENV_FILE', str(_REPO_ROOT / '.env'))).expanduser()
if not _ENV_FILE.is_absolute():
    _ENV_FILE = _REPO_ROOT / _ENV_FILE
_LOCAL = dotenv_values(_ENV_FILE, interpolate=False) if _ENV_FILE.is_file() else {}


def _setting(name, default=''):
    key = 'UST_' + name.upper()
    return os.environ.get(key, _LOCAL.get(key) or default)


config = SimpleNamespace(
    db_ip=_setting('db_ip'),
    db_user=_setting('db_user'),
    db_password=_setting('db_password'),
    db_name=_setting('db_name'),
    db_connection_string=_setting('db_connection_string'),
    element_row_counts_email=_setting('element_row_counts_email'),
    element_row_counts_cc=_setting('element_row_counts_cc'),
    hazsub_email=_setting('hazsub_email'),
    hazsub_cc=_setting('hazsub_cc'),
)
