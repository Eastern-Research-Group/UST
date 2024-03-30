import sys
import os
sys.path = [os.path.join(os.path.dirname(__file__), "..", "..")] + sys.path
from ust.util.import_service import ImportService

state = 'SD' 
ust_path = r'C:\Users\erguser\OneDrive - Eastern Research Group\Projects\UST\State Data\SD\UST'
release_path = None 
overwrite_table = False 

import_service = ImportService()

def import_files(state, ust_path=None, release_path=None, overwrite_table=False):
    if ust_path:
        import_service.import_data(state, 'ust', ust_path,  overwrite_table=overwrite_table)
    if release_path:
        import_service.import_data(state, 'release', release_path, overwrite_table=overwrite_table)

    
if __name__ == '__main__':       
    import_files(state, ust_path, release_path, overwrite_table=False)



