
import sys

import pandas as pd

from ust.python.util import utils
from ust.python.util.logger_factory import logger

input_file_path = r"C:\Users\RMyers\OneDrive - Eastern Research Group\Projects\UST\Geocoding\needed_geocoding_20251113202942_geocoded.xlsx"


class Geocode:
    def __init__(self, input_file_path, temp_table_name='temp_geocode'):
        self.input_file_path = input_file_path
        self.temp_table_name = temp_table_name


    def get_data(self):
        return pd.read_excel(self.input_file_path)


    def save_temp_table(self, df):
        df.to_sql(self.temp_table_name, con=utils.get_engine(), if_exists='replace', index=False)
        logger.info('Saved input data to temp table public.%s', self.temp_table_name)


    def generate_sql(self, ust_or_release):
        if ust_or_release == 'ust':
            geo_table_name = 'ust_facility_geocode'
            id_col = 'ust_facility_id'
        elif ust_or_release == 'release':
            geo_table_name = 'ust_release_geocode'
            id_col = 'ust_release_id'
        else:
            logger.warning('Unknown value "%s" for ust_or_release; allowed values are "ust" and "release"', ust_or_release)
            sys.exit()
        sql = f"""insert into public.{geo_table_name}
                    ({id_col}, status, score, match_type, rank, street_address, city,    
                     subregion, region_abbreviation, zip_code, zip_extension, country,
                    latitude, longitude)
                select "USER_id", "Status", "Score", "Match_type", "Rank",
                    "StAddr", "City", "Subregion", "RegionAbbr", "Postal", "PostalExt", 
                    "Country", "DisplayY", "DisplayX"
                from public.{self.temp_table_name} 
                where "USER_ust_or_release" = '{ust_or_release}'
                on conflict ({id_col}) do update set
                    status = EXCLUDED.status, 
                    score = EXCLUDED.score, 
                    match_type = EXCLUDED.match_type, 
                    rank = EXCLUDED.rank, 
                    street_address = EXCLUDED.street_address, 
                    city = EXCLUDED.city, 
                    subregion = EXCLUDED.subregion, 
                    region_abbreviation = EXCLUDED.region_abbreviation, 
                    zip_code = EXCLUDED.zip_code, 
                    zip_extension = EXCLUDED.zip_extension, 
                    country = EXCLUDED.country, 
                    latitude = EXCLUDED.latitude, 
                    longitude = EXCLUDED.longitude"""
        return sql 


    def process_sql(self, sql):
        insert_table_name = sql[19:sql.find('\n')]
        conn = utils.connect_db()
        cur = conn.cursor()         
        utils.process_sql(conn, cur, sql)
        logger.info('Processed %s rows in public.%s', cur.rowcount, insert_table_name)
        conn.commit()
        cur.close()
        conn.close()


    def process(self):
        df = self.get_data() 
        self.save_temp_table(df)
        self.process_sql(self.generate_sql('ust'))
        self.process_sql(self.generate_sql('release'))
        


def main(input_file_path):
    g = Geocode(input_file_path=input_file_path)
    g.process()


if __name__ == '__main__':   
    main(input_file_path)
