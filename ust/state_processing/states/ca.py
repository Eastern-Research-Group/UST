from import_service import ImportService
import utils

state = 'CA' 
file_path = r'C:\Users\RMyers\OneDrive - Eastern Research Group\Other Projects\UST\State Data\\' 
file_path = file_path + state + '\\'
ust_folder = None
# ust_folder = file_path + 'UST'
lust_folder = file_path + 'GeoTrackerDownload'
# lust_folder = None

import_service = ImportService()

def import_files():
    if ust_folder:
        import_service.import_ust(state, ust_folder)
    if lust_folder:
        import_service.import_lust(state, lust_folder)

    

def insert_lust_substances_table():
    conn = utils.connect_to_db('CA_LUST')
    cur = conn.cursor()
    
    sql = 'select "GLOBAL_ID", "POTENTIAL_CONTAMINANTS_OF_CONCERN" from sites order by 1'
    cur.execute(sql)
    rows = cur.fetchall()
    for row in rows:
        global_id = row[0]
        substances = row[1]
        if substances:
            substance_list = substances.split(',')
            substance_list = [s.replace('*','').strip() for s in substance_list]
            for substance in substance_list:
                sql2 = "insert into substances values (%s, %s)"
                cur.execute(sql2, (global_id, substance))
                print(f'{global_id}: {substance}')
            conn.commit()
            
    cur.close()
    conn.close()     
    
def insert_lust_sources_table():
    conn = utils.connect_to_db('CA_LUST')
    cur = conn.cursor()
    sql = 'select "GLOBAL_ID", "DISCHARGE_SOURCE" from sites order by 1'
    cur.execute(sql)
    rows = cur.fetchall()
    for row in rows:
        global_id = row[0]
        sources = row[1]
        if sources:
            source_list = sources.split(',')
            source_list = [s.replace('*','').strip() for s in source_list]
            for source in source_list:
                sql2 = "insert into sources values (%s, %s)"
                cur.execute(sql2, (global_id, source))
                print(f'{global_id}: {source}')
            conn.commit()
    cur.close()
    conn.close()         
    
def insert_lust_causes_table():
    conn = utils.connect_to_db('CA_LUST')
    cur = conn.cursor()
    sql = 'select "GLOBAL_ID", "DISCHARGE_CAUSE" from sites order by 1'
    cur.execute(sql)
    rows = cur.fetchall()
    for row in rows:
        global_id = row[0]
        causes = row[1]
        if causes:
            cause_list = causes.split(',')
            cause_list = [s.replace('*','').strip() for s in cause_list]
            for cause in cause_list:
                sql2 = "insert into causes values (%s, %s)"
                cur.execute(sql2, (global_id, cause))
                print(f'{global_id}: {cause}')
            conn.commit()
    cur.close()
    conn.close()       

def insert_lust_remediations_table():
    conn = utils.connectdb('CA_LUST')
    cur = conn.cursor()
    sql = 'select "GLOBAL_ID", "STOP_METHOD" from sites order by 1'
    cur.execute(sql)
    rows = cur.fetchall()
    for row in rows:
        global_id = row[0]
        causes = row[1]
        if causes:
            cause_list = causes.split(',')
            cause_list = [s.replace('*','').strip() for s in cause_list]
            for cause in cause_list:
                sql2 = "insert into remediations values (%s, %s)"
                cur.execute(sql2, (global_id, cause))
                print(f'{global_id}: {cause}')
            conn.commit()
    cur.close()
    conn.close()           
    
    
if __name__ == '__main__':      
    import_files()    
    insert_lust_substances_table()
    insert_lust_sources_table()
    insert_lust_causes_table()
    insert_lust_remediations_table()
