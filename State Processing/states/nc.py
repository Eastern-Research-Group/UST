from import_service import ImportService

state = 'NC' 
file_path = r'C:\Users\erguser\OneDrive - Eastern Research Group\Other Projects\UST\State Data\\' + state + '\\'
# ust_folder = file_path + 'UST'
# lust_folder = file_path + 'LUST'
# lust_folder = file_path  + 'LUST 20230117'
lust_folder = file_path + 'LUST-may5' 
ust_folder = None


import_service = ImportService()

def import_files():
    if lust_folder:
        import_service.import_lust(state, lust_folder, overwrite_table=False)
    if ust_folder:
        import_service.import_ust(state, ust_folder, overwrite_table=False)

    
if __name__ == '__main__':       
    import_files()


