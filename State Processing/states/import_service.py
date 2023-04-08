from import_factory import ImportFactory

class ImportService:
    
    def import_ust(self, state, file_location, overwrite_table=True):
        importer = ImportFactory.ust_importer(state, file_location, overwrite_table)
        importer.save_files_to_db()
    
    def import_lust(self, state, file_location, overwrite_table=True):
        importer = ImportFactory.lust_importer(state, file_location, overwrite_table)
        importer.save_files_to_db()

    def import_all(self, state, file_location, overwrite_table=True):
        self.import_ust(state, file_location, overwrite_table)
        self.import_lust(state, file_location, overwrite_table)