from import_factory import ImportFactory

class ImportService:
    
    def import_ust(self, state, file_location):
        importer = ImportFactory.ust_importer(state, file_location)
        importer.save_files_to_db()
    
    def import_lust(self, state, file_location):
        importer = ImportFactory.lust_importer(state, file_location)
        importer.save_files_to_db()

    def import_all(self, state, file_location):
        self.import_ust(state, file_location)
        self.import_lust(state, file_location)