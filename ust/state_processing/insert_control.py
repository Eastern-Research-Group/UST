import sys
import os
sys.path = [os.path.join(os.path.dirname(__file__), "..", "..")] + sys.path
from ust.util.logger_factory import logger
from ust.util import utils
from datetime import datetime


organization_id = 'SC'
system_type = 'ust' # Accepted values are 'ust' or 'release'
data_source = None 
date_received = None # Defaults to datetime.today(). To use a date other tha-- public.ust_control definition
date_processed = None # Defaults to datetime.today(). To use a date other than today, set as a string in the format of 'yyyy-mm-dd'.
comments = None 


class ControlTable:
    def __init__(self, 
                 system_type,
                 organization_id, 
                 data_source, 
                 date_received=datetime.today(), 
                 date_processed=datetime.today(), 
                 comments=None):

        if system_type.lower() not in ['ust','release']:
            logger.critical("System type '%s' not recognized, aborting.", system_type)
            exit()

        self.system_type = system_type.lower()
        self.organization_id = organization_id
        self.data_source = data_source
        if date_received:
            self.date_received = date_received
        else:
            self.date_received = datetime.today()
        if date_processed:
            self.date_processed = date_processed
        else:
            self.date_processed = datetime.today()
        self.comments = comments
        self.control_id = None


    def insert_db(self):
        conn = utils.connect_db()
        cur = conn.cursor()
        sql = f"""insert into {self.system_type}_control 
                    (organization_id, date_received, date_processed, data_source, comments)
                  values (%s, %s, %s, %s, %s)
                  returning {self.system_type}_control_id"""
        cur.execute(sql, (self.organization_id, self.date_received, self.date_processed, self.data_source, self.comments))
        control_id = cur.fetchone()[0]
        self.control_id = control_id
        logger.info('Inserted into %s_control; %s_control_id = %s', self.system_type, self.system_type, control_id)
        conn.commit()
        cur.close()
        conn.close()
        return control_id

    
if __name__ == '__main__':       
    c = ControlTable(
        system_type=system_type, 
        organization_id=organization_id, 
        data_source=data_source,
        date_received=date_received,
        date_processed=date_processed,
        comments=comments)
    c.insert_db()
    logger.info('New control_id for %s is %s', c.organization_id, c.control_id)
