
from ust.python.util.database_importer import DatabaseImporter


class ImportFactory:
    
    @staticmethod
    def importer(organization_id, system_type, file_location, overwrite_table=True, table_name=None):
        database_importer = DatabaseImporter(organization_id, system_type, file_location, overwrite_table, table_name)
        return database_importer
