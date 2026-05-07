import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

from python.util.database_importer import DatabaseImporter  


class ImportService:
    
    def import_ust(self, organization_id, file_path, overwrite_table=True):
        importer = DatabaseImporter(organization_id, 'ust', file_path, overwrite_table)
        importer.print_self()
        importer.save_files_to_db()

    def import_release(self, organization_id, file_path, overwrite_table=True):
        importer = DatabaseImporter(organization_id, 'release', file_path, overwrite_table)
        importer.save_files_to_db()

    def import_all(self, organization_id, file_path, overwrite_table=True):
        self.import_ust(organization_id, file_path, overwrite_table)
        self.import_release(organization_id, file_path, overwrite_table)

class ImportService:    
    def import_data(self, organization_id, file_path, system_type, overwrite_table=True):
        importer = DatabaseImporter(organization_id, file_path, system_type, overwrite_table)
        importer.save_files_to_db()
    
