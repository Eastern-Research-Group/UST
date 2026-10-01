from ust.python.util.import_service import ImportService

state = 'TrUSTD' 
# Legacy script: set this to the directory containing the source export folders.
file_path = 'C:/path/to/TrUSTD/'
ust_folder = file_path + 'db_export/db_export'
# lust_folder = file_path + 'db_export_lust'
lust_folder = None

import_service = ImportService()

def import_files():
    if ust_folder:
        import_service.import_ust(state, ust_folder)
    if lust_folder:
        import_service.import_lust(state, lust_folder)
    
if __name__ == '__main__':       
    import_files()
