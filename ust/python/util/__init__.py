import os
from types import SimpleNamespace

try:
    from . import config as config
except ImportError:
    config = SimpleNamespace(
        db_ip=os.getenv("UST_DB_IP", ""),
        db_user=os.getenv("UST_DB_USER", ""),
        db_password=os.getenv("UST_DB_PASSWORD", ""),
        db_name=os.getenv("UST_DB_NAME", ""),
        db_connection_string=os.getenv("UST_DB_CONNECTION_STRING", ""),
        local_ust_path=os.getenv("UST_LOCAL_UST_PATH", ""),
        element_row_counts_email=os.getenv("UST_ELEMENT_ROW_COUNTS_EMAIL", ""),
        element_row_counts_cc=os.getenv("UST_ELEMENT_ROW_COUNTS_CC", ""),
        hazsub_email=os.getenv("UST_HAZSUB_EMAIL", ""),
        hazsub_cc=os.getenv("UST_HAZSUB_CC", ""),
    )
