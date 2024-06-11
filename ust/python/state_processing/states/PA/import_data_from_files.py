import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

from python.util.import_service import ImportService


state = 'PA' 
# Enter a directory (not path to a specific file) for ust_path and release_path
# Set to None if not applicable
# ust_path = r'C:\Users\renae\OneDrive\Documents\Work\UST\States\PA'
ust_path = None
release_path = r'C:\Users\renae\Documents\Work\repos\ERG\UST\ust\sql\states\PA\Releases' 
overwrite_table = False 

import_service = ImportService()

def import_files(state, ust_path=None, release_path=None, overwrite_table=False):
    if ust_path:
        import_service.import_data(state, 'ust', ust_path,  overwrite_table=overwrite_table)
    if release_path:
        import_service.import_data(state, 'release', release_path, overwrite_table=overwrite_table)

    
if __name__ == '__main__':       
    import_files(state, ust_path, release_path, overwrite_table=False)



