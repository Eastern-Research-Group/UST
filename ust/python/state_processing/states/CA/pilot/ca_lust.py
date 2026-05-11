import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

from psycopg2.errors import UndefinedTable

from python.util.logger_factory import logger
from python.util.import_service import ImportService
from python.util import utils


state = 'CA' 
file_path = r'C:/Users/erguser/OneDrive - Eastern Research Group/Other Projects/UST/State Data/' 
file_path = file_path + state + '/'
lust_folder = file_path + 'GeoTrackerDownload' 
schema = 'CA_LUST'

import_service = ImportService()

def import_files():
    if lust_folder:
        import_service.import_lust(state, lust_folder)


def delete_extra_nonlust():
    conn = utils.connect_db(schema=schema)
    cur = conn.cursor()

    tables = ['contacts','regulatory_activities','status_history']
    for table in tables:
        sql = f'delete from {table} where "GLOBAL_ID" not in (select "GLOBAL_ID" from sites)'
        cur.execute(sql)
        rowcount = cur.rowcount
        logger.info('Deleted %s rows from %s.table %s', rowcount, schema, table)

    conn.commit()
    cur.close()
    conn.close()     


def delete_nonlust_rows():
    conn = utils.connect_db(schema=schema)
    cur = conn.cursor()

    # sql = "show search_path"
    # cur.execute(sql)
    # print(cur.fetchone()[0])

    sql = f'delete from sites where "CASE_TYPE" not in (%s,%s)'
    cur.execute(sql, ('LUST Cleanup Site','Military UST Site'))
    rowcount = cur.rowcount
    logger.info('Deleted %s rows from table %s.sites where CASE_TYPE not "LUST Cleanup Site" or "Military UST Site"', rowcount, schema)

    sql = f"select count(*) from sites"
    cur.execute(sql)
    cnt = cur.fetchone()[0]
    logger.info('There are %s remaining rows in table %s.sites', cnt, schema)

    delete_extra_nonlust()

    conn.commit()
    cur.close()
    conn.close()     
    


# def create_deagg_table(deagg_table_name, deagg_column_name):
#     conn = utils.connect_db('CA_LUST')
#     cur = conn.cursor()

#     sql = f'drop table "{deagg_table_name}"'
#     try:
#         cur.execute(sql)
#         logger.info('Table %s dropped', deagg_table_name)
#     except UndefinedTable:
#         pass 

#     sql = f"""create table "{deagg_table_name}" (
#                 id int generated always as identity not null primary key,
#                 "GLOBAL_ID" text,
#                 "{deagg_column_name}" text)"""
#     cur.execute(sql)
#     logger.info('Table %s created', deagg_table_name)

#     sql = f'select "GLOBAL_ID", "{deagg_column_name}" from sites order by 1'
#     cur.execute(sql)
#     rows = cur.fetchall()
#     for row in rows:
#         global_id = row[0]
#         values = row[1]
#         if values:
#             value_list = values.split(',')
#             value_list = [v.replace('*','').strip() for v in value_list]
#             for value in value_list:
#                 sql2 = f'insert into {deagg_table_name} ("GLOBAL_ID", "{deagg_column_name}") values (%s, %s)'
#                 cur.execute(sql2, (global_id, value))
#                 print(f'{global_id}: {value}')
#             conn.commit()

#     sql = f'select count(*) from "{deagg_table_name}"'
#     cur.execute(sql)
#     cnt = cur.fetchone()[0]
#     logger.info('There are %s rows in table %s', cnt, deagg_table_name)

#     cur.close()
#     conn.close()       

    
if __name__ == '__main__':      
    # import_files()    
    delete_nonlust_rows()
    # create_deagg_table('substances_deagg', 'POTENTIAL_CONTAMINANTS_OF_CONCERN')
    # create_deagg_table('sources_deagg', 'DISCHARGE_SOURCE')
    # create_deagg_table('causes_deagg', 'DISCHARGE_CAUSE')
    # create_deagg_table('remediations_deagg', 'STOP_METHOD')
