from import_service import ImportService
import config

state = 'SD' 
file_path = config.local_ust_path + state + '\\'
ust_folder = file_path + 'UST'
lust_folder = file_path + 'LUST'

import_service = ImportService()

def import_files():
    if ust_folder:
        import_service.import_ust(state, ust_folder)
    if lust_folder:
        import_service.import_lust(state, lust_folder)
    
if __name__ == '__main__':       
    import_files()
