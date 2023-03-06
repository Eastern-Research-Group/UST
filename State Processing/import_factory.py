from database_importer import DatabaseImporter  

class ImportFactory:
    
    @staticmethod
    def ust_importer(state, file_location, overwrite_table=True):
        system_type = 'UST'
        database_importer = DatabaseImporter(state, system_type, file_location, overwrite_table)
        return database_importer
    
    @staticmethod
    def lust_importer(state, file_location, overwrite_table=True):
        system_type = 'LUST'
        database_importer = DatabaseImporter(state, system_type, file_location, overwrite_table)
        return database_importer