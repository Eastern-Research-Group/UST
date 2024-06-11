import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

from python.util.import_service import ImportService

state = 'AL' 
file_path = r'C:\Users\erguser\OneDrive - Eastern Research Group\Other Projects\UST\State Data/' + state + '/'
ust_folder = None
lust_folder = 'LUST'

import_service = ImportService()

def import_files():
    if ust_folder:
        import_service.import_ust(state, file_path + ust_folder)
    if lust_folder:
        import_service.import_lust(state, file_path + lust_folder)
    




if __name__ == '__main__':
    import_files()
