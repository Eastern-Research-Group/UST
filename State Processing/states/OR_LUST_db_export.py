import pyodbc
from sqlalchemy import create_engine
import pandas as pd
import os

conn_str = (
    r'driver={SQL Server};'
    r'server=CHA-RMYERS2\SQLEXPRESS;'
    r'database=LUST;'
    r'trusted_connection=yes;'
)

db_name = 'LUST'
db_server = r'CHA-RMYERS2\SQLEXPRESS'

tables_file = 'OR_LUST_tables.txt'

# print(pyodbc.drivers())

def get_connection():
    return pyodbc.connect(conn_str)


def get_engine():
    return create_engine(f'mssql+pyodbc://@{db_server}/{db_name}?trusted_connection=yes&driver=SQL+Server')


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
    sql = f"select count(*) from dbo.{table_name}"
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

            csv_path = 'OR_LUST_tables/' + table + '.csv'
            csv_cnt = get_csv_row_count(csv_path)

            match = True
            if db_cnt != csv_cnt:
                match = False
            results.append((table, db_cnt, csv_cnt, match))

    cur.close()
    conn.close()

    df = pd.DataFrame.from_records(results, columns=['Table','OR LUST Count','CSV Count','Counts Match'])
    print(df)    
        


def main():
    engine = get_engine()

    with open(tables_file, 'r') as f:
        for line in f:
            table = line.strip()
            csv_path = 'OR_LUST_tables/' + table + '.csv'
            if not os.path.isfile(csv_path):
                df = get_table_df('dbo.' + table, engine)
                df.to_csv(csv_path, index=False, quoting=0, escapechar=r'|')
                print(csv_path + ' saved to file')
            else:
                print(csv_path + ' already exists so skipping')

    get_summary()

if __name__ == '__main__':
    main()
