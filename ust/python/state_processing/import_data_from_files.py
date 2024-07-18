import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

from python.util.import_service import ImportService

organization_id = 'KS' 
# Enter a directory (NOT a path to a specific file) for ust_path and release_path
# Set to None if not applicable
ust_path = r'C:\Users\renae\Downloads\KS\UST'
# ust_path = None
release_path = r'C:\Users\renae\Downloads\KS\Releases' 
overwrite_table = False 

import_service = ImportService()

def import_files(organization_id, ust_path=None, release_path=None, overwrite_table=False):
    if ust_path:
        import_service.import_data(organization_id, 'ust', ust_path,  overwrite_table=overwrite_table)
    if release_path:
        import_service.import_data(organization_id, 'release', release_path, overwrite_table=overwrite_table)

    
if __name__ == '__main__':       
    import_files(organization_id, ust_path, release_path, overwrite_table=False)



