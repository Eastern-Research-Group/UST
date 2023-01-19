from logger_factory import logger
import utils
import pandas as pd
import os
import glob
from psycopg2.errors import DuplicateDatabase


class DatabaseImporter:
    def __init__(self, state, system_type, file_location):
        self.state = state
        self.system_type = system_type
        self.file_location = file_location
        self.db_name = self.state.upper() + '_' + self.system_type.upper() 
        self.create_db()
        

    def create_db(self):
        conn = utils.connect_db()
        cur = conn.cursor()
        try:
            cur.execute('create database "' + self.db_name + '"')
            logger.info('Created database %s', self.db_name)
        except DuplicateDatabase:
            logger.info('Database %s already exists', self.db_name)

        
    def get_table_name_from_file_name(self, file_path):
        table_name = file_path.rsplit('\\', 1)[1]
        table_name = table_name.replace(' ','_').replace('.xlsx','').replace('.csv','').replace('.txt','')
        return table_name
        
        
    def save_file_to_db(self, file_path, engine=None):
        table_name = self.get_table_name_from_file_name(file_path)
        logger.info('New table name will be %s', table_name)

        if file_path[-4:] == 'xlsx':
            df = pd.read_excel(file_path)    
        elif file_path[-3:] == 'csv':
            df = pd.read_csv(file_path, encoding='ansi', low_memory=False)
        elif file_path[-3:] == 'txt':
            df = pd.read_csv(file_path, sep='\t', encoding='ansi', low_memory=False)
        else:
            logger.info(f'{file_path} is not an .xlsx, .csv, or .txt file so aborting...')
            sys.exit()
        logger.debug(f'{file_path} read into dataframe')    

        if not engine:
            engine = utils.get_engine(self.db_name)        
        df.to_sql(table_name, engine, index=False, if_exists='replace')
        logger.info('Created table %s', table_name)


    def get_files(self):
        print(f'{self.file_location}/*.txt')
        file_list = []
        file_list = glob.glob(f'{self.file_location}/*.csv')
        file_list.extend(glob.glob(f'{self.file_location}/*.xlsx'))
        file_list.extend(glob.glob(f'{self.file_location}/*.txt'))
        logger.debug('File list is %s', str(file_list))
        return file_list


    def save_files_to_db(self):
        engine = utils.get_engine(self.db_name)
        file_list = self.get_files()
        for file in file_list:
            self.save_file_to_db(file, engine=engine)
            logger.info('Saved %s to %s', file, self.db_name)