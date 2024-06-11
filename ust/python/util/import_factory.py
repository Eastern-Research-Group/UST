import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

from python.util.database_importer import DatabaseImporter  

class ImportFactory:
    
    @staticmethod
    def importer(state, system_type, file_location, overwrite_table=True):
        database_importer = DatabaseImporter(state, system_type, file_location, overwrite_table)
        return database_importer