from import_service import ImportService
import config, utils
import os
import pandas as pd

state = 'TRUSTD' 
ust_folder = 'TRUSTD_tables/'
tables_file = 'TRUSTD_tables.txt'

import_servic
e = ImportService()

def import_files():
    import_service.import_ust(state, ust_folder)
    get_summary()


def get_table_row_count(table_name, cursor):
    sql = f'select count(*) from "TRUSTD_UST"."{table_name}"'
    cursor.execute(sql)
    return cursor.fetchone()[0]


def get_csv_row_count(csv_path):
    if not os.path.isfile(csv_path):
        return 'n/a'
    else:
        df = pd.read_csv(csv_path)
        return len(df)


def get_summary():
    conn = conn = utils.connect_db(config.db_name)
    cur = conn.cursor()

    results = []
    with open(tables_file, 'r') as f:
        for line in f:
            table = line.strip()
            db_cnt = get_table_row_count(table, cur)

            csv_path = 'TRUSTD_tables/' + table + '.csv'
            csv_cnt = get_csv_row_count(csv_path)

            match = True
            if db_cnt != csv_cnt:
                match = False
            results.append((table, db_cnt, csv_cnt, match))

    cur.close()
    conn.close()

    df = pd.DataFrame.from_records(results, columns=['Table','TRUSTD Count','CSV Count','Counts Match'])
    print(df)    
    
if __name__ == '__main__':       
    # import_files()
     get_summary()
