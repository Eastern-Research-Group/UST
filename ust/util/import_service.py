import sys
import os
sys.path = [os.path.join(os.path.dirname(__file__), "..", "..")] + sys.path
from ust.util.import_factory import ImportFactory

class ImportService:    
    def import_data(self, state, file_location, system_type, overwrite_table=True):
        importer = ImportFactory.importer(state, file_location, system_type, overwrite_table)
        importer.save_files_to_db()
    
