import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

from python.util import utils
from python.util.import_service import ImportService
from python.util.logger_factory import logger


ust_or_release = 'ust'          # Valid values are 'ust' or 'release'
organization_id = ''            # Enter the two-character code for the state, or "TRUSTD" for the tribes database 
path = r""                      # Enter the full path to the directory containing the source data file(s) (NOT a path to a specific file)
overwrite_table = False         # Boolean, defaults to False; set to True if you are replacing existing data in the schema


import_service = ImportService()

def import_files(ust_or_release, organization_id, path, overwrite_table=False):
    ust_or_release = utils.verify_ust_or_release(ust_or_release)
    import_service.import_data(organization_id, ust_or_release, path, overwrite_table=overwrite_table)
   
    
if __name__ == '__main__':       
    import_files(ust_or_release, organization_id, path, overwrite_table=overwrite_table)



