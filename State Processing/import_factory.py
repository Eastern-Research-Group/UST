from database_importer import DatabaseImporter  

class ImportFactory:
    
    @staticmethod
    def ust_importer(state, file_location):
        system_type = 'UST'
        database_importer = DatabaseImporter(state, system_type, file_location)
        return database_importer
    
    @staticmethod
    def lust_importer(state, file_location):
        system_type = 'LUST'
        database_importer = DatabaseImporter(state, system_type, file_location)
        return database_importer