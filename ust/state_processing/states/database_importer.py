import sys
import os
sys.path = [os.path.join(os.path.dirname(__file__), "..", "..")] + sys.path
from ust.util.logger_factory import logger
from ust.util import config, utils
import pandas as pd
import os
import glob
from psycopg2.errors import DuplicateSchema, UndefinedTable


class DatabaseImporter:
    def __init__(self, state, system_type, file_location, overwrite_table=True):
        self.state = state
        self.system_type = system_type
        self.file_location = file_location
        self.overwrite_table = overwrite_table
        self.schema = self.state.upper() + '_' + self.system_type.upper() 
        self.create_schema()
        self.existing_tables = []
        self.bad_file_list = []
    

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

        sql = "select table_name from information_schema.tables where upper(table_schema) = upper(%s) order by 1"
        cur.execute(sql, (self.schema,))
        rows = cur.fetchall()
        self.existing_tables = [row[0] for row in rows]

        cur.close()
        conn.close()

        logger.info('The following tables already exist in schema %s: %s', self.schema, self.existing_tables)
        
        
    def get_table_name_from_file_name(self, file_path):
        table_name = file_path.rsplit('\\', 1)[1]
        table_name = table_name.replace(' ','_').replace('.xlsx','').replace('.csv','').replace('.txt','')
        return table_name
        
        
    def save_file_to_db(self, file_path, engine=None):
        table_name = self.get_table_name_from_file_name(file_path)
        if table_name in self.existing_tables and not self.overwrite_table:
            logger.warning('Table %s already exists in the database and will not be imported because the overwrite_table flag is set to False', table_name)
            return True

        logger.info('New table name will be %s', table_name)

        if file_path[-4:] == 'xlsx':
            try:
                df = pd.read_excel(file_path)   
            except ValueError as e:
                logger.error('Error opening %s; skipping: %s', file_path, e) 
                self.bad_file_list.append(table_name)
                return False
        elif file_path[-3:] == 'csv':
            df = pd.read_csv(file_path, encoding='ansi', low_memory=False)
        elif file_path[-3:] == 'txt':
            df = pd.read_csv(file_path, sep='\t', encoding='ansi', low_memory=False)
        else:
            logger.info(f'{file_path} is not an .xlsx, .csv, or .txt file so aborting...')
            sys.exit()
        logger.debug(f'{file_path} read into dataframe')    

        if not engine:
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

    def get_files(self):
        file_list = []
        file_list = glob.glob(f'{self.file_location}/*.csv')
        file_list.extend(glob.glob(f'{self.file_location}/*.xlsx'))
        file_list.extend(glob.glob(f'{self.file_location}/*.txt'))
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