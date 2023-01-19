from import_service import ImportService

state = 'TN' 
file_path = r'C:\Users\RMyers\OneDrive - Eastern Research Group\Other Projects\UST\State Data\TN\\'
# ust_folder = file_path + 'UST_Finder'
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
