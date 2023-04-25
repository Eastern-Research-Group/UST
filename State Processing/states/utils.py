import config
from logger_factory import logger
import psycopg2
from sqlalchemy import create_engine
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT
import re


def connect_db(db_name='ust', schema='public'):
    try:
        options = f'-csearch_path="{schema}"'
        conn = psycopg2.connect(
                    host='localhost',
                    user=config.db_user,
                    password=config.db_password,
                    dbname=db_name,
                    options=options)
        # logger.info('Connected to database %s; schema %s', db_name, schema)
    except Exception as e:
        logger.error('Unable to connect to database %s: %s', db_name, e)
        raise

    conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
    return conn


def get_engine(db_name=config.db_name, schema=None):
    # engine = create_engine('postgresql://username:password@localhost:5432/mydatabase')
    try:
        engine = create_engine(config.db_connection_string + db_name, connect_args={'options': f'-csearch_path="{schema}"'})
        logger.info('Created database engine')
        return engine
    except Exception as e:
        logger.error('Error creating database engine: %s', e)


def get_view_sql(view_name):
    conn = connect_db()
    cur = conn.cursor()
    sql = f"select pg_get_viewdef('{view_name}', true)"
    cur.execute(sql)
    view_sql =  cur.fetchone()[0]
    cur.close()
    conn.close()
    return view_sql

 
def process_view_sql(sql):
    i = sql.find('FROM ')
    to_sql = sql[:i].replace('SELECT DISTINCT ','').replace('SELECT ','')
    i2 = sql.find('ORDER BY ')
    from_sql = sql[i:i2]
    return (to_sql, from_sql)


def extract_col_alias(col_def):
    i = col_def.find('.')+1
    alias = col_def[i:].replace('"','')
    return alias


def process_col_sql(sql):
    i = sql.find(' AS ')
    if i == -1:
        i = len(sql)
    select_col = sql[:i]
    if ' AS ' in sql:
        alias = sql[i:].replace(' AS ','').replace('"','')
    else:
        alias = extract_col_alias(select_col)
    return alias, select_col


def get_select_cols(sql):
    # orig_cols = sql.split(',')
    orig_cols = re.split(r',\s*(?![^()]*\))', sql)
    cols = {}
    for col in orig_cols:
        column = col.strip()
        c = process_col_sql(column)
        alias = c[0]
        col_def = c[1]
        cols[alias] = col_def
    return cols


def get_view_info(state, ust_or_lust='ust', view_name=None):
    schema = state.upper() + '_' + ust_or_lust.upper()
    if view_name:
        view = '"' + schema + '".' + view_name 
    else:
        view = '"' + schema + '".v_' + ust_or_lust.lower() + '_base' 

    view_sql = get_view_sql(view)
    view_sql = process_view_sql(view_sql)
    from_sql = view_sql[1]
    cols = get_select_cols(view_sql[0])
    
    return cols, from_sql 


def get_schema_name(state, ust_or_lust):
    return state + '_' + ust_or_lust.upper() 


def get_view_name(state, ust_or_lust, view_name=None):
    schema = get_schema_name(state, ust_or_lust)    
    if view_name:
        view = '"' + schema + '".' + view_name
    else:
        view = '"' + schema + '".v_' + ust_or_lust.lower() + '_base'
    return view


