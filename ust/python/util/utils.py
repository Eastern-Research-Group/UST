import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))
import re

import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT
from sqlalchemy import create_engine

from python.util import config
from python.util.logger_factory import logger


def connect_db(db_name=config.db_name, schema='public'):
    try:
        options = f'-csearch_path="{schema}"'
        conn = psycopg2.connect(
                    host=config.db_ip,
                    user=config.db_user,
                    password=config.db_password,
                    dbname=db_name,
                    options=options)
    except Exception as e:
        logger.error('Unable to connect to database %s: %s', db_name, e)
        raise

    conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
    return conn


def get_engine(db_name=config.db_name, schema=None):
    try:
        engine = create_engine(config.db_connection_string + db_name, connect_args={'options': f'-csearch_path="{schema}"'})
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
    i = sql.find('FROM')
    to_sql = sql[:i].replace('SELECT DISTINCT ','').replace('SELECT ','')
    to_sql = to_sql.replace('SELECT DISTINCT\n','').replace('SELECT\n','')
    i2 = sql.find('ORDER BY ')
    from_sql = sql[i:i2]
    return (to_sql, from_sql)


def extract_col_alias(col_def):
    i = col_def.find('.') + 1
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
    orig_cols = re.split(r',\s*(?![^()]*\))', sql)
    cols = {}
    for col in orig_cols:
        column = col.strip()
        c = process_col_sql(column)
        alias = c[0]
        col_def = c[1]
        cols[alias] = col_def
    return cols


def get_view_info(state, ust_or_lust, view):
    schema = get_schema_name(state, ust_or_lust)
    view_name = '"' + schema + '"."' + view + '"'
    view_sql = get_view_sql(view_name)
    view_sql = process_view_sql(view_sql)
    from_sql = view_sql[1]
    cols = get_select_cols(view_sql[0])
    return cols, from_sql 


def get_schema_name(state, ust_or_lust):
    return state.upper() + '_' + ust_or_lust.upper() 


def get_view_name(state, ust_or_lust, view_name=None):
    schema = get_schema_name(state, ust_or_lust)    
    if view_name:
        view = '"' + schema + '".' + view_name
    else:
        view = '"' + schema + '".v_' + ust_or_lust.lower() + '_base'
    return view


def autowidth(worksheet):
    for col in worksheet.columns:
         max_length = 0
         column = col[0].column_letter # Get the column name
         for cell in col:
             try: # Necessary to avoid error on empty cells
                 if len(str(cell.value)) > max_length:
                     max_length = len(str(cell.value))
             except:
                 pass
         adjusted_width = (max_length + 2) * 1.2
         worksheet.column_dimensions[column].width = adjusted_width


def get_today_string():
    return datetime.today().strftime('%Y-%m-%d')


def get_control_id(ust_or_lust, organization_id):
    conn = connect_db()
    cur = conn.cursor()

    sql = "select count(*) from " + ust_or_lust.lower() + '_control where organization_id = %s'
    cur.execute(sql, (organization_id, ))
    cnt = cur.fetchone()[0]
    if cnt == 0:
        logger.error('No data in %s_control; unable to proceed.', ust_or_lust.lower())
        exit()
    sql = "select max(control_id) from " + ust_or_lust.lower() + '_control where organization_id = %s'
    cur.execute(sql, (organization_id, ))
    control_id = cur.fetchone()[0]

    if cnt > 1:
        logger.info('Found multiple Control IDs in %s_control; using newest one (%s)', ust_or_lust.lower(), str(control_id) )
    else:
        logger.info('Setting Control ID to %s', str(control_id))

    cur.close()
    conn.close()

    return control_id


def get_selenium_driver(url):
    from selenium import webdriver
    from selenium.webdriver.chrome.options import Options
    from selenium.webdriver.chrome.service import Service
    import time

    options = Options()
    service = Service()
    # comment out the line below to show the browser (use only for debugging)
    options.add_argument('--headless')
    # uncomment the line below to keep the browser window open; use only for debugging
    # options.add_experimental_option('detach', True)
    driver = webdriver.Chrome(service=service, options=options)
    driver.get(url)
    while driver.execute_script("return document.readyState") != "complete":
        time.sleep(1)
    time.sleep(5)
    return driver


def get_org_from_control_id(control_id, ust_or_release):
    if ust_or_release.lower() not in ['ust','release']:
        logger.error('Invalid value %s for ust_or_release. Valid values are ust or release. Exiting...', ust_or_release)
        exit()
    conn = connect_db()
    cur = conn.cursor()    
    table_name = ust_or_release.lower() + '_control'
    column_name = table_name + '_id'
    sql = f"select organization_id from {table_name} where {column_name} = %s"
    cur.execute(sql, (control_id,))
    ok = True
    org = None 
    try:
        org = cur.fetchone()[0]
    except TypeError:
        logger.warning('No %s with a value of %s found in %s. Exiting', column_name, control_id, table_name)
        ok = False
    cur.close()
    conn.close()
    if ok:
        return org  
    else:
        exit()


def delete_all_release_data(control_id):
    conn = connect_db()
    cur = conn.cursor() 

    sql = """delete from public.ust_release_corrective_action_strategy 
            where ust_release_id in (select ust_release_id from ust_release where release_control_id = %s)"""
    cur.execute(sql, (control_id,))
    logger.info('Deleted %s rows from public.ust_release_corrective_action_strategy', cur.rowcount)

    sql = """delete from public.ust_release_cause 
            where ust_release_id in (select ust_release_id from ust_release where release_control_id = %s)"""
    cur.execute(sql, (control_id,))
    logger.info('Deleted %s rows from public.ust_release_cause', cur.rowcount)

    sql = """delete from public.ust_release_source 
            where ust_release_id in (select ust_release_id from ust_release where release_control_id = %s)"""
    cur.execute(sql, (control_id,))
    logger.info('Deleted %s rows from public.ust_release_source', cur.rowcount)

    sql = """delete from public.ust_release_substance 
            where ust_release_id in (select ust_release_id from ust_release where release_control_id = %s)"""
    cur.execute(sql, (control_id,))
    logger.info('Deleted %s rows from public.ust_release_substance', cur.rowcount)

    sql = """delete from public.ust_release where release_control_id = %s"""
    cur.execute(sql, (control_id,))
    logger.info('Deleted %s rows from public.ust_release', cur.rowcount)

    conn.commit()
    cur.close()    
    conn.close()


def delete_all_ust_data(control_id):
    pass


def get_schema_from_control_id(control_id, ust_or_release):
    org = get_org_from_control_id(control_id, ust_or_release)
    return org.lower() + '_' + ust_or_release.lower()


def get_lookup_tabs(ust_or_release='ust'):
    ust_or_release = ust_or_release.lower()
    if ust_or_release == 'ust':
        table_name = 'ust_template_lookup_tables'
    elif ust_or_release == 'release':
        table_name = 'ust_release_template_lookup_tables'
    else:
        logger.warning('Unknown value passed got get_lookup_tabs(ust_or_release): %s', ust_or_release)
        return 
    conn = connect_db()
    cur = conn.cursor() 
    sql = """select table_name, desc_column_name  
            from ust_template_lookup_tables
            order by sort_order"""
    cur.execute(sql)
    rows = cur.fetchall()
    cur.close()
    conn.close()
    return rows


def get_data_tabs(ust_or_release='ust'):
    ust_or_release = ust_or_release.lower()
    if ust_or_release == 'ust':
        table_name = 'ust_template_data_tables'
    elif ust_or_release == 'release':
        table_name = 'ust_release_template_data_tables'
    else:
        logger.warning('Unknown value passed got get_data_tabs(ust_or_release): %s', ust_or_release)
        return 
    conn = connect_db()
    cur = conn.cursor() 
    sql = """select view_name, template_tab_name  
            from ust_template_data_tables
            order by sort_order"""
    cur.execute(sql)
    rows = cur.fetchall()
    cur.close()
    conn.close()
    return rows


def get_headers(table_name):
    conn = connect_db()
    cur = conn.cursor() 
    sql = """select column_name from information_schema.columns
             where table_schema = 'public' and table_name = %s
             order by ordinal_position"""
    cur.execute(sql, (table_name, ))
    headers = [x[0] for x in cur.fetchall()]
    cur.close()
    conn.close()
    return headers


def get_timestamp_str():
    from datetime import datetime 
    now = datetime.now()
    return now.strftime('%Y%m%d%H%M%S')


def get_fill_gen(color, color2=None):
    from openpyxl.styles import PatternFill
    if not color2:
        color2 = color
    fill_gen = PatternFill(fill_type='solid',
                       start_color=color,
                       end_color=color2)
    return fill_gen