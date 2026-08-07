import sys
from pathlib import Path

import pandas as pd

from ust.python.util import utils
from ust.python.util.logger_factory import logger

ust_control_ids = []             # List of ust_control_id's to include in export. Can be empty if release_control_ids is not empty. 
release_control_ids = []        # List of release_control_id's to include in export. Can be empty if release_control_ids is not empty. 



class GeocodingExport:
    df = None  

    def __init__(self, ust_control_ids=None, release_control_ids=None, export_file_dir='../../python/exports/geocoding/'):
        self.ust_control_ids = ust_control_ids
        self.release_control_ids = release_control_ids    
        if not self.release_control_ids and not self.release_control_ids:
            logger.warning('ust_control_ids and/or release_control_ids must be passed...')
            sys.exit()
        self.export_file_dir = export_file_dir
        self.export_file_name = 'needed_geocoding_' + utils.get_timestamp_str() + '.xlsx'
        self.export_file_path = self.export_file_dir + self.export_file_name
                

    def get_data(self):
        wheresql = 'where ('
        ustsql = ''
        releasesql = ''
        if self.ust_control_ids:
            ustsql = f"(ust_or_release = 'ust' and control_id in ({utils.list_nums_to_string(self.ust_control_ids)})) "
        if self.release_control_ids:
            releasesql = f"(ust_or_release = 'release' and control_id in ({utils.list_nums_to_string(self.release_control_ids)})) "
        wheresql += ustsql 
        if ustsql and releasesql:
            wheresql += ' or '
        wheresql += releasesql + ') '

        sql = f"""select distinct ust_or_release, id, organization_id, entity_id, entity_name, 
                address, address2, city, zip, county, state,
                latitude, longitude, coordinate_source 
            from public.v_all_needed_geocoding 
            {wheresql}
            order by organization_id, ust_or_release, entity_id"""
        return pd.read_sql(sql, con=utils.get_engine())


    def process(self):
        Path(self.export_file_dir).mkdir(parents=True, exist_ok=True)    
        self.df = self.get_data() 
        logger.info('Created df with %s rows', len(self.df))
        self.df.to_excel(self.export_file_path, index=False)
        logger.info('Exported to %s', self.export_file_path)



def main(ust_control_ids=None, release_control_ids=None, export_file_dir='../../python/exports/geocoding/'):
    g = GeocodingExport(ust_control_ids=ust_control_ids, release_control_ids=release_control_ids, export_file_dir=export_file_dir)
    g.process()    


if __name__ == '__main__':   
    main(ust_control_ids=ust_control_ids,
         release_control_ids=release_control_ids)                    
