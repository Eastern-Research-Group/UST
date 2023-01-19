import pandas as pd
import os
import glob
import utils

reg_path = r'C:\Users\RMyers\OneDrive - Eastern Research Group\Other Projects\UST\State Data\SC\Regulatory & Compliance\\'
tech_path = r'C:\Users\RMyers\OneDrive - Eastern Research Group\Other Projects\UST\State Data\SC\Technical\\'

db_name = 'SC_UST'


def get_table_name_from_file_name(file_path):
    table_name = file_path.rsplit('\\', 1)[1]
    table_name = table_name.replace(' ','_').replace('.xlsx','').replace('.csv','')
    return table_name
    

def save_file_to_db(file_path):
    table_name = get_table_name_from_file_name(file_path)
    engine = utils.get_engine(db_name)
    
    if file_path[-4:] == 'xlsx':
        df = pd.read_excel(file_path)    
    elif file_path[-3:] == 'csv':
        df = pd.read_csv(file_path, encoding='ansi', low_memory=False)
    else:
        utils.msg_and_log(f'{file_path} is neither an xlsx or csv so aborting...')
        sys.exit()
    
    df.to_sql(table_name, engine, index=False, if_exists='replace')
    utils.msg_and_log(f'Created table {table_name}')


def get_files(path, extension='xlsx'):
    file_list = glob.glob(f'{path}/*.{extension}')
    return file_list


def save_files_to_db(file_list):
    for file in file_list:
        save_file_to_db(file)

def main():
    conn = utils.connect_to_db()
    cur = conn.cursor()
    
    
    cur.close()
    conn.close()
    

if __name__ == '__main__':
    # save_file_to_db(get_files(reg_path, 'xlsx'))
    save_files_to_db(get_files(tech_path, 'csv')) 


################################################################################
# Notes 
#
# Sites with FR.xlsx and FOI FR Report.xlsx are the same

