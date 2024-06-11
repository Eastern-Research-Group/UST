import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

from python.util.import_service import ImportService
from python.util.import utils

state = 'NE' 
file_path = r'C:\Users\erguser\OneDrive - Eastern Research Group\Other Projects\UST\State Data\\' + state + '\\'
# ust_folder = file_path + 'UST'
ust_folder = None
lust_folder =  file_path + 'LUST' 


import_service = ImportService()

def import_files():
    if lust_folder:
        import_service.import_lust(state, lust_folder, overwrite_table=False)
    if ust_folder:
        import_service.import_ust(state, ust_folder, overwrite_table=False)

    
def deagg_substances():    
    conn = utils.connect_db()
    cur = conn.cursor()

    sql = """create table "NE_LUST".substance_deagg (
                facility_id varchar(50) not null primary key,
                state_substance varchar(400), 
                substance1 varchar(100),
                substance2 varchar(100), 
                substance3 varchar(100), 
                substance4 varchar(100), 
                substance5 varchar(100))"""
    cur.execute(sql)

    sql = """insert into "NE_LUST".substance_deagg (facility_id, state_substance)
             select distinct "FacilityID", "SubstanceReleased1" from "NE_LUST".lust 
             where "FacilityID" is not null"""
    cur.execute(sql)
    conn.commit()

    cur.close()
    conn.close()




if __name__ == '__main__':       
    # import_files()
    deagg_substances()


