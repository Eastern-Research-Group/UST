import glob
from pathlib import Path
import os
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import pandas as pd
from psycopg2.errors import DuplicateSchema, UndefinedTable

from python.util import config, utils
from python.util.logger_factory import logger


class DatabaseImporter:
    def __init__(self, organization_id, system_type, file_path, overwrite_table=True):
        self.organization_id = organization_id
        self.system_type = system_type
        self.file_path = file_path
        self.overwrite_table = overwrite_table
        self.schema = self.organization_id.lower() + '_' + self.system_type.lower() 
        self.create_schema()
        self.existing_tables = []
        self.bad_file_list = []
        # self.print_self()
    

    def print_self(self):
        print('organization_id = ' + str(self.organization_id))
        print('system_type = ' + str(self.system_type))
        print('file_path = ' + str(self.file_path))
        print('overwrite_table = ' + str(self.overwrite_table))
        print('schema = ' + str(self.schema))
        print('existing_tables = ' + str(self.existing_tables))
        print('bad_file_list = ' + str(self.bad_file_list))


    def create_schema(self):
        conn = utils.connect_db(config.db_name)
        cur = conn.cursor()
        try:
            cur.execute('create schema "' + self.schema + '" AUTHORIZATION ' + config.db_user)
            logger.info('Created schema %s', self.schema)
        except DuplicateSchema:
            logger.info('Schema %s already exists', self.schema)

        sql = f'grant all on schema "{self.schema}" TO {config.db_user}'
        cur.execute(sql)

        cur.close()
        conn.close()


    def set_existing_tables(self):
        conn = utils.connect_db(config.db_name)
        cur = conn.cursor()

        sql = "select table_name from information_schema.tables where lower(table_schema) = lower(%s) order by 1"
        cur.execute(sql, (self.schema,))
        rows = cur.fetchall()
        self.existing_tables = [row[0] for row in rows]

        cur.close()
        conn.close()

        logger.info('The following tables already exist in schema %s: %s', self.schema, self.existing_tables)
        
        
    def get_table_name_from_file_name(self, file_path):
        table_name = file_path.rsplit('\\', 1)[1]
        table_name = table_name.replace(' ','_').replace('.xlsx','').replace('.xls','').replace('.csv','').replace('.txt','')
        return table_name
        
        
    def save_table_to_db(self, df, table_name):
        if table_name in self.existing_tables and not self.overwrite_table:
            logger.warning('Table %s already exists in the database and will not be imported because the overwrite_table flag is set to False', table_name)
            return True
        logger.info('New table name will be %s', table_name)    
        engine = utils.get_engine(schema=self.schema)    
        if self.overwrite_table:    
            df.to_sql(table_name, engine, index=False, if_exists='replace')
            logger.info('Created table %s', table_name)
        else:
            try:
                df.to_sql(table_name, engine, index=False)
                logger.info('Created table %s', table_name)       
            except error as e:
                self.bad_file_list.append(table_name)
                logger.error('Unable to load table %s; adding to bad_file_list: %s: %s', table_name, e)
        return True


    def save_file_to_db(self, file_path, engine=None):
        if utils.is_excel(file_path):
            xls = pd.ExcelFile(file_path)
            sheet_names = xls.sheet_names
            if len(sheet_names) > 1:
                for sheet_name in sheet_names:
                    df = pd.read_excel(file_path, sheet_name=sheet_name)
                    logger.debug('%s, worksheet %s read into dataframe', file_path, sheet_name)
                    self.save_table_to_db(df, table_name=sheet_name)
            else:
                try:
                    df = pd.read_excel(file_path)   
                    logger.debug('%s read into dataframe', file_path)
                except ValueError as e:
                    logger.error('Error opening %s; skipping: %s', file_path, e) 
                    self.bad_file_list.append(table_name)
                    return False
                self.save_table_to_db(df, table_name=self.get_table_name_from_file_name(file_path))
        elif file_path[-3:] == 'csv':
            df = pd.read_csv(file_path, encoding='ansi', low_memory=False)
            logger.debug('%s read into dataframe', file_path)
            self.save_table_to_db(df, table_name=self.get_table_name_from_file_name(file_path))
        elif file_path[-3:] == 'txt':
            df = pd.read_csv(file_path, sep='\t', encoding='ansi', low_memory=False)
            logger.debug('%s read into dataframe', file_path)
            self.save_table_to_db(df, table_name=self.get_table_name_from_file_name(file_path))
        else:
            logger.info('%s is not an .xlsx, .csv, or .txt file so aborting...', file_path)
            sys.exit()

        return True


    def get_files(self):
        file_list = []
        file_list = glob.glob(f'{self.file_path}/*.csv')
        file_list.extend(glob.glob(f'{self.file_path}/*.xls*'))
        file_list.extend(glob.glob(f'{self.file_path}/*.txt'))
        logger.debug('File list is %s', str(file_list))
        return file_list


    def save_files_to_db(self):
        if not self.overwrite_table:
            self.set_existing_tables()

        engine = utils.get_engine(schema=self.schema)
        file_list = self.get_files()
        for file in file_list:
            self.save_file_to_db(file, engine=engine)
            # logger.info('Saved %s to %s', file, self.schema)

        for table in self.bad_file_list:
            logger.warning('%s not saved to database due to error!!!', table)
