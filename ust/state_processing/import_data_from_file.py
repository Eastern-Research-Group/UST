import sys
import os
sys.path = [os.path.join(os.path.dirname(__file__), "..", "..")] + sys.path
from ust.util.import_service import ImportService

state = 'NC' 
file_path = r'C:\Users\renae\Downloads\UST\UST'
release_folder = None 
ust_folder = file_path + '\\'

import_service = ImportService()

def import_files(state, ust_folder=None, release_folder=None, overwrite_table=False):
    if release_folder:
        import_service.import_data(state, release_folder, 'release', overwrite_table=overwrite_table)
    if ust_folder:
        import_service.import_data(state, ust_folder, 'ust', overwrite_table=overwrite_table)

    
if __name__ == '__main__':       
    import_files(state, ust_folder)



