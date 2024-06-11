import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

from python.util.database_importer import DatabaseImporter  


class ImportService:
    
    def import_ust(self, state, file_path, overwrite_table=True):
        importer = DatabaseImporter(state, 'ust', file_path, overwrite_table)
        print(importer)
        importer.print_self()
        importer.save_files_to_db()

    def import_release(self, state, file_path, overwrite_table=True):
        importer = DatabaseImporter(state, 'release', file_path, overwrite_table)
        importer.save_files_to_db()

    def import_all(self, state, file_path, overwrite_table=True):
        self.import_ust(state, file_path, overwrite_table)
        self.import_release(state, file_path, overwrite_table)

class ImportService:    
    def import_data(self, state, file_path, system_type, overwrite_table=True):
        importer = DatabaseImporter(state, file_path, system_type, overwrite_table)
        importer.save_files_to_db()
    
