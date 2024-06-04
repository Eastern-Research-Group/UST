import sys
import os
sys.path = [os.path.join(os.path.dirname(__file__), "..", "..")] + sys.path
# from ust.util.import_factory import ImportFactory
from ust.util.database_importer import DatabaseImporter  


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
    
