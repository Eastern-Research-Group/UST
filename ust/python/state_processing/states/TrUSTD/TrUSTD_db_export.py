import oracledb
import os 
import pandas as pd
from sqlalchemy import create_engine


db_user = 'TRUSTD_UST_FINDER_ETL'
db_pass = 'ustETL2023qtr3!'
db_host = 'vmoraeeprd1.rtpnc.epa.gov'
db_service_name = 'epap11.vmoraeeprd1'
db_port = '1521'
db_dsn = db_host + '/' + db_service_name

oraclient_path = r'C:\Users\RMyers\Oracle\instantclient_21_10'
thick_mode = {'lib_dir': oraclient_path}

tables_file = 'TRUSTD_tables.txt'


def get_connection():
    # initialize thick client because db won't allow thin client
    oracledb.init_oracle_client(lib_dir=oraclient_path)
    return oracledb.connect(user=db_user, password=db_pass, dsn=db_dsn)


def get_engine():
    return create_engine(f'oracle+oracledb://{db_user}:{db_pass}@{db_host}:{db_port}/?service_name={db_service_name}',thick_mode=thick_mode)


def test_table(table_name):
    conn = get_connection()
    cur = conn.cursor()   
    sql = f"select * from {table_name}"
    cur.execute(sql)
    for row in cur.fetchall():
        print(row)
    cur.close()
    conn.close()


def get_table_df(table_name, engine):
    return pd.read_sql(f'select * from {table_name}', engine)


def get_table_row_count(table_name, cursor):
    sql = f"select count(*) from trustd.{table_name}"
    cursor.execute(sql)
    return cursor.fetchone()[0]


def get_csv_row_count(csv_path):
    if not os.path.isfile(csv_path):
        return 'n/a'
    else:
        df = pd.read_csv(csv_path)
        return len(df)


def get_summary():
    conn = get_connection()
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
        


def main():
    engine = get_engine()

    with open(tables_file, 'r') as f:
        for line in f:
            table = line.strip()
            csv_path = 'TRUSTD_tables/' + table + '.csv'
            if not os.path.isfile(csv_path):
                df = get_table_df('trustd.' + table, engine)
                df.to_csv(csv_path, index=False)
                print(csv_path + ' saved to file')
            else:
                print(csv_path + ' already exists so skipping')

    get_summary()


if __name__ == '__main__':
    main()
