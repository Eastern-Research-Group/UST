import sys
from pathlib import Path

import pandas as pd
from psycopg2.errors import DuplicateSchema
from sqlalchemy.exc import SQLAlchemyError

from ust.python.util import config, utils
from ust.python.util.logger_factory import logger


SUPPORTED_SUFFIXES = {'.csv', '.xls', '.xlsx', '.txt'}
EXCEL_SUFFIXES = {'.xls', '.xlsx'}


class DatabaseImporter:
    def __init__(self, organization_id, ust_or_release, file_path, overwrite_table=True, table_name=None):
        self.organization_id = organization_id
        self.ust_or_release = utils.verify_ust_or_release(ust_or_release)
        self.file_path = file_path
        self.overwrite_table = overwrite_table
        self.table_names = self.normalize_table_names(table_name)
        self.schema = self.organization_id.lower() + '_' + self.ust_or_release.lower() 
        self.create_schema()
        self.existing_tables = []
        self.bad_file_list = []
        # self.print_self()
    

    def print_self(self):
        print('organization_id = ' + str(self.organization_id))
        print('ust_or_release = ' + str(self.ust_or_release))
        print('file_path = ' + str(self.file_path))
        print('overwrite_table = ' + str(self.overwrite_table))
        print('table_names = ' + str(self.table_names))
        print('schema = ' + str(self.schema))
        print('existing_tables = ' + str(self.existing_tables))
        print('bad_file_list = ' + str(self.bad_file_list))


    @staticmethod
    def normalize_table_names(table_name):
        if table_name is None:
            return None
        names = [table_name] if isinstance(table_name, str) else list(table_name)
        cleaned = []
        for name in names:
            candidate = str(name).strip().replace(' ', '_')
            if not candidate:
                raise ValueError('Table name override cannot be blank.')
            cleaned.append(candidate)
        if not cleaned:
            return None
        if len(set(name.lower() for name in cleaned)) != len(cleaned):
            raise ValueError('Table name overrides must be unique: ' + ', '.join(cleaned))
        return cleaned


    def create_schema(self):
        conn = utils.connect_db(config.db_name)
        cur = conn.cursor()
        try:
            sql = 'create schema "' + self.schema + '" AUTHORIZATION ' + config.db_user
            cur.execute(sql)
            logger.info('Created schema %s', self.schema)
        except DuplicateSchema:
            logger.info('Schema %s already exists', self.schema)

        sql = f'grant all on schema "{self.schema}" TO {config.db_user}'
        utils.process_sql(conn, cur, sql)
        cur.close()
        conn.close()


    def set_existing_tables(self):
        conn = utils.connect_db(config.db_name)
        cur = conn.cursor()
        sql = "select table_name from information_schema.tables where lower(table_schema) = lower(%s) order by 1"
        utils.process_sql(conn, cur, sql, params=(self.schema,))
        rows = cur.fetchall()
        self.existing_tables = [row[0] for row in rows]
        cur.close()
        conn.close()
        logger.info('The following tables already exist in schema %s: %s', self.schema, self.existing_tables)
        
        
    def get_table_name_from_file_name(self, file_path):
        table_path = Path(file_path)
        table_name = table_path.stem.replace(' ', '_')
        return table_name


    def suggest_table_name(self, table_name):
        taken = {name.lower() for name in self.existing_tables}
        suffix = 2
        while f'{table_name.lower()}_{suffix}' in taken:
            suffix += 1
        return f'{table_name}_{suffix}'


    def validate_table_names(self, file_list):
        """A table name override is only allowed when exactly one table will be created per name."""
        if not self.table_names:
            return
        if len(file_list) != 1:
            raise ValueError(
                'A table name override requires a path to a single supported file, or a directory '
                f'containing exactly one supported file; found {len(file_list)} file(s) at {self.file_path}'
            )
        expected = 1
        sheet_names = []
        if Path(file_list[0]).suffix.lower() in EXCEL_SUFFIXES:
            sheet_names = pd.ExcelFile(file_list[0]).sheet_names
            expected = len(sheet_names)
        if len(self.table_names) != expected:
            if expected == 1:
                raise ValueError(
                    f'Exactly one table name override is allowed for {file_list[0]}; '
                    f'received {len(self.table_names)}'
                )
            raise ValueError(
                f'{file_list[0]} contains {expected} worksheets ({", ".join(sheet_names)}), so '
                f'{expected} table names are required in worksheet order; received {len(self.table_names)}'
            )

        if self.overwrite_table:
            return
        self.set_existing_tables()
        taken = {name.lower() for name in self.existing_tables}
        for name in self.table_names:
            if name.lower() in taken:
                raise ValueError(
                    f'Table "{name}" already exists in schema {self.schema}. Choose another name '
                    f'(for example "{self.suggest_table_name(name)}") or rerun with overwrite enabled.'
                )


    def get_override_table_name(self, index=0):
        if not self.table_names:
            return None
        return self.table_names[index]
        
        
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
            except (SQLAlchemyError, ValueError, OSError, TypeError) as e:
                self.bad_file_list.append(table_name)
                logger.error('Unable to load table %s; adding to bad_file_list: %s: %s', table_name, e)
        return True


    def save_file_to_db(self, file_path, engine=None):
        file_suffix = Path(file_path).suffix.lower()
        if file_suffix in {'.xls', '.xlsx'}:
            xls = pd.ExcelFile(file_path)
            sheet_names = xls.sheet_names
            if len(sheet_names) > 1:
                for index, sheet_name in enumerate(sheet_names):
                    df = pd.read_excel(file_path, sheet_name=sheet_name)
                    logger.debug('%s, worksheet %s read into dataframe', file_path, sheet_name)
                    self.save_table_to_db(df, table_name=self.get_override_table_name(index) or sheet_name)
            else:
                try:
                    df = pd.read_excel(file_path)   
                    logger.debug('%s read into dataframe', file_path)
                except ValueError as e:
                    logger.error('Error opening %s; skipping: %s', file_path, e) 
                    self.bad_file_list.append(self.get_table_name_from_file_name(file_path))
                    return False
                self.save_table_to_db(df, table_name=self.get_override_table_name() or self.get_table_name_from_file_name(file_path))
        elif file_suffix == '.csv':
            df = pd.read_csv(file_path, encoding='ansi', low_memory=False)
            logger.debug('%s read into dataframe', file_path)
            self.save_table_to_db(df, table_name=self.get_override_table_name() or self.get_table_name_from_file_name(file_path))
        elif file_suffix == '.txt':
            df = pd.read_csv(file_path, sep='\t', encoding='ansi', low_memory=False)
            logger.debug('%s read into dataframe', file_path)
            self.save_table_to_db(df, table_name=self.get_override_table_name() or self.get_table_name_from_file_name(file_path))
        else:
            logger.info('%s is not an .xlsx, .csv, or .txt file so aborting...', file_path)
            sys.exit()

        return True


    def get_files(self):
        source_path = Path(self.file_path)
        supported_suffixes = SUPPORTED_SUFFIXES

        if source_path.is_file():
            file_list = [str(source_path)] if source_path.suffix.lower() in supported_suffixes else []
        elif source_path.is_dir():
            file_list = sorted(
                str(path)
                for path in source_path.iterdir()
                if path.is_file() and path.suffix.lower() in supported_suffixes
            )
        else:
            logger.warning('Import path does not exist or is not accessible: %s', self.file_path)
            file_list = []

        logger.debug('File list is %s', str(file_list))
        return file_list


    def save_files_to_db(self):
        file_list = self.get_files()
        self.validate_table_names(file_list)
        if not self.overwrite_table and not self.existing_tables:
            self.set_existing_tables()

        engine = utils.get_engine(schema=self.schema)
        for file in file_list:
            self.save_file_to_db(file, engine=engine)
            # logger.info('Saved %s to %s', file, self.schema)

        for table in self.bad_file_list:
            logger.warning('%s not saved to database due to error!!!', table)
