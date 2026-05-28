import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import psycopg2

from python.state_processing.create_unreg_tables import UnregTables
from python.state_processing.insert_control import ControlTable
from python.util import utils
from python.util.dataset import Dataset 
from python.util.logger_factory import logger

organization_id = ''                  	# Enter the two-character code for the state, or "TRUSTD" for the tribes database 
ust_or_release = ''                  	# Valid values are 'ust' or 'release'
control_id = 0
data_source = ''                        # Describe in detail where data came from (e.g. URL downloaded from, Excel spreadsheets from state, state API URL, etc.)
date_received = 'YYYY-MM-DD'            # Defaults to datetime.today(). To use a date other than today, set as a string in the format of 'yyyy-mm-dd'.
date_processed = None                   # Defaults to datetime.today(). To use a date other than today, set as a string in the format of 'yyyy-mm-dd'.
comments = ''                           # Top-level comments on the dataset. An example would be "Exclude Aboveground Storage Tanks".
organization_compartment_flag = None    # For UST only set to 'Y' if state data includes compartments, 'N' if state data is tank-level only. You can set this later if you don't know.


class Initialize:
	control_id: int = None 

    def __init__(self, 
                 ust_or_release,
                 organization_id, 
                 data_source, 
                 date_received=datetime.today(), 
                 date_processed=datetime.today(), 
                 comments=None,
                 organization_compartment_flag=None):

        self.ust_or_release = utils.verify_ust_or_release(ust_or_release)
        self.organization_id = organization_id.upper()
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
        self.organization_compartment_flag = organization_compartment_flag


    def execute(self):
    	self.control_id = self.control_table()
    	self.create_unregulated_tables()


    def control_table(self):
    	c = ControlTable(
	        ust_or_release=self.ust_or_release, 
	        organization_id=self.organization_id, 
	        data_source=self.data_source,
	        date_received=self.date_received,
	        date_processed=self.date_processed,
	        comments=self.comments,
	        organization_compartment_flag=self.organization_compartment_flag)
	    c.insert_db()
	    logger.info('New control_id for %s is %s', c.organization_id, c.control_id)
	    return c.control_id


	def create_unregulated_tables(self):
		dataset = Dataset(ust_or_release=self.ust_or_release,
					  	  control_id=self.control_id,
					      requires_export=False)

		UnregTables(dataset, drop_existing=False).execute()



def main(ust_or_release, 
	     organization_id, 
	     data_source, 
	     date_received=datetime.today(), 
	     date_processed=datetime.today(),
         comments=None,
         organization_compartment_flag=organization_compartment_flag):

	i = Initialize(ust_or_release=ust_or_release, 
				   organization_id=organization_id, 
         		   data_source=data_source,
         		   date_received=date_received,
        	 	   date_processed=date_processed,
         		   comments=comments,
         		   organization_compartment_flag=organization_compartment_flag)
	i.execute()


if __name__ == '__main__':   
	main(ust_or_release=ust_or_release, 
         organization_id=organization_id, 
         data_source=data_source,
         date_received=date_received,
         date_processed=date_processed,
         comments=comments,
         organization_compartment_flag=organization_compartment_flag)
