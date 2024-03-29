import sys
import os
sys.path = [os.path.join(os.path.dirname(__file__), "..", "..")] + sys.path
from ust.util.database_importer import DatabaseImporter  

class ImportFactory:
    
    @staticmethod
<<<<<<< HEAD
    def importer(state, system_type, file_location, overwrite_table=True):
        database_importer = DatabaseImporter(state, system_type, file_location, overwrite_table)
        return database_importer
    
=======
    def importer(state, file_location, system_type, overwrite_table=True):
        database_importer = DatabaseImporter(state, system_type, file_location, overwrite_table)
        return database_importer
>>>>>>> origin/main
