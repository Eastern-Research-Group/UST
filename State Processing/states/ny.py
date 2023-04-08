from import_service import ImportService

state = 'NY' 
file_path = r'C:\Users\erguser\OneDrive - Eastern Research Group\Other Projects\UST\State Data\\' + state + '\\'
lust_folder = None 
ust_folder = file_path + 'UST/UTM Conversion'


import_service = ImportService()

def import_files():
    if lust_folder:
        import_service.import_lust(state, lust_folder, overwrite_table=False)
    if ust_folder:
        import_service.import_ust(state, ust_folder, overwrite_table=False)

    
if __name__ == '__main__':       
    import_files()


