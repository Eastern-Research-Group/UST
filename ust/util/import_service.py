import sys
import os
sys.path = [os.path.join(os.path.dirname(__file__), "..", "..")] + sys.path
from ust.util.import_factory import ImportFactory

class ImportService:
    
    def import_ust(self, state, file_location, overwrite_table=True):
        importer = ImportFactory.importer(state, 'ust', file_location, overwrite_table)
        importer.save_files_to_db()
    
    def import_release(self, state, file_location, overwrite_table=True):
        importer = ImportFactory.importer(state, 'release', file_location, overwrite_table)
        importer.save_files_to_db()

    def import_all(self, state, file_location, overwrite_table=True):
        self.import_ust(state, file_location, overwrite_table)
        self.import_release(state, file_location, overwrite_table)