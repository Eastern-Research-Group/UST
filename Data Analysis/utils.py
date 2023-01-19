import config
from logger_factory import logger
import psycopg2
from sqlalchemy import create_engine
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT


def connect_db(db_name="ust"):
    try:
        conn = psycopg2.connect(
                    host='localhost',
                    user=config.db_user,
                    password=config.db_password,
                    dbname=db_name)
        logger.info('Connected to database %s', db_name)
    except Exception as e:
        logger.error('Unable to connect to database %s: %s', db_name, e)
        raise

    conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
    return conn



def get_engine(db_name='ust'):
    # engine = create_engine('postgresql://username:password@localhost:5432/mydatabase')
    try:
        engine = create_engine(config.db_connection_string + db_name)
        logger.info('Created database engine')
        return engine
    except Exception as e:
        logger.error('Error creating database engine: %s', e)





