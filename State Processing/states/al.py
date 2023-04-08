from import_service import ImportService

state = 'AL' 
file_path = r'C:\Users\erguser\OneDrive - Eastern Research Group\Other Projects\UST\State Data/' + state + '/'
ust_folder = 'UST'
lust_folder = None

import_service = ImportService()

def import_files():
    if ust_folder:
        import_service.import_ust(state, ust_folder)
    if lust_folder:
        import_service.import_lust(state, lust_folder)
    
if __name__ == '__main__':
    import_files()
