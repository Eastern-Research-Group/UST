from ust.python.util.import_service import ImportService

state = 'SC' 
# Legacy script: set this to the directory containing the state's source folders.
file_path = 'C:/path/to/SC/'
# ust_folder = file_path + 'Regulatory & Compliance\\'
# lust_folder = file_path + 'Technical\\'
ust_folder = None
lust_folder = file_path + 'LUST'

import_service = ImportService()

def import_files():
    if ust_folder:
        import_service.import_ust(state, ust_folder)
    if lust_folder:
        import_service.import_lust(state, lust_folder)
    
if __name__ == '__main__':       
    import_files()

