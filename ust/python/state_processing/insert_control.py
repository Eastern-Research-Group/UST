from datetime import datetime
import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

from python.util import utils
from python.util.logger_factory import logger


organization_id = 'CA'
ust_or_release = 'ust'   # Accepted values are 'ust' or 'release'
data_source = 'State granted web access to CERS database (https://cersregulator.calepa.ca.gov/)' # Describe where data came from (e.g. URL downloaded from, Excel spreadsheets from state, state API URL, etc.)
date_received = '2024-08-14' # Defaults to datetime.today(). To use a date other than today, set as a string in the format of 'yyyy-mm-dd'.
date_processed = None # Defaults to datetime.today(). To use a date other than today, set as a string in the format of 'yyyy-mm-dd'.
comments = 'Wrote a Python script to download individual Excel spreadsheets for each of 104 Regulators (as we were advised to download each separately), then combined them.' 
organization_compartment_flag = None   # For UST only set to 'Y' if state data includes compartments, 'N' if state data is tank-level only. 


class ControlTable:
    def __init__(self, 
                 ust_or_release,
                 organization_id, 
                 data_source, 
                 date_received=datetime.today(), 
                 date_processed=datetime.today(), 
                 comments=None,
                 organization_compartment_flag=None):

        self.ust_or_release = utils.verify_ust_or_release(ust_or_release)
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
        if self.ust_or_release == 'ust' and self.organization_compartment_flag:
            sql = f"""insert into {self.ust_or_release}_control 
                        (organization_id, date_received, date_processed, data_source, comments, organization_compartment_flag)
                      values (%s, %s, %s, %s, %s, %s)
                      returning {self.ust_or_release}_control_id"""
            cur.execute(sql, (self.organization_id, self.date_received, self.date_processed, self.data_source, self.comments, self.organization_compartment_flag))
        else:
            sql = f"""insert into {self.ust_or_release}_control 
                        (organization_id, date_received, date_processed, data_source, comments)
                      values (%s, %s, %s, %s, %s)
                      returning {self.ust_or_release}_control_id"""
            cur.execute(sql, (self.organization_id, self.date_received, self.date_processed, self.data_source, self.comments))
        control_id = cur.fetchone()[0]
        self.control_id = control_id
        logger.info('Inserted into %s_control; %s_control_id = %s', self.ust_or_release, self.ust_or_release, control_id)
        conn.commit()
        cur.close()
        conn.close()
        return control_id

    
if __name__ == '__main__':       
    c = ControlTable(
        ust_or_release=ust_or_release, 
        organization_id=organization_id, 
        data_source=data_source,
        date_received=date_received,
        date_processed=date_processed,
        comments=comments,
        organization_compartment_flag=organization_compartment_flag)
    c.insert_db()
    logger.info('New control_id for %s is %s', c.organization_id, c.control_id)
