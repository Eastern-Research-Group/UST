
from ust.python.util.database_importer import DatabaseImporter


class ImportFactory:
    
    @staticmethod
    def importer(organization_id, system_type, file_location, overwrite_table=True):
        database_importer = DatabaseImporter(organization_id, system_type, file_location, overwrite_table)
        return database_importer
