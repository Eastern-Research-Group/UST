import sys
import os
sys.path = [os.path.join(os.path.dirname(__file__), "..", "..")] + sys.path
from ust.util.logger_factory import logger

import requests
import json
import pandas as pd


state = 'TN'
system_type = 'UST'
output_file = f'../data/{state}_{system_type}.csv'
url = 'https://tdeconline.tn.gov/arcgis/rest/services/UST_EPA_Info_By_Compartment/FeatureServer/0/query'
result_offset = 0 
record_count = 1000


def get_json(url):
    # print(url)
    try:
        response = requests.get(url)
        if response.ok:
            # print(response.text)
            return json.loads(response.text)
        else:
            logger.error(f'{url} returned response status code {response.status_code}')
    except Exception as e:
        msg = f'Error encountered when attempting to download {url}: {e}'
        logger.error(msg)
        raise Error(msg)


def print_distinct_values(column_name):
    where = f'?where=1%3D1&f=pjson&&returnGeometry=false&returnDistinctValues=true&outFields={column_name}&&orderByFields={column_name}'
    json_dict = get_json(url + where)
    values = []
    
    if json_dict and 'error' in json_dict.keys():
        logger.error(f"Error code {json_dict['error']['code']} returned by service", 'ERROR')
    elif not json_dict:
        logger.error('No data returned from service', 'ERROR')
    else:
        if 'features' in json_dict.keys():
            for attribute in json_dict['features']:
                for v in attribute.values():
                    if v[column_name]:
                        values.append(v[column_name])
    for value in values:
        print(value)


def get_num_records():
    where = '?where=1%3D1&f=pjson&returnGeometry=false&returnCountOnly=true'
    json_dict = get_json(url + where)
    return json_dict['count']
    

# def get_num_current_tanks():    
#     where = f"?where=COMPARTMENT_STATUS='Currently in Use'&f=pjson&returnGeometry=false&returnDistinctValues=true&outFields=FACILITY_ID,TANK_ID"
#     where = where + '&returnCountOnly=true'
#     print(url + where)
#     json_dict = get_json(url + where)
#     # return json_dict['count']    
#     print(json_dict)
    

def get_num_current_tanks():
    where = f"?where=COMPARTMENT_STATUS='Currently in Use'&f=pjson&returnGeometry=false&returnDistinctValues=true&outFields=FACILITY_ID,TANK_ID&orderByFields=FACILITY_ID,TANK_ID"
    where = where + f'&resultRecordCount={record_count}&resultOffset=' 

    exceededTransferLimit = True
    i = 0
    offset = 0
    json_dict = {}    

    while exceededTransferLimit:
        json_dict = get_json(url + where + str(offset))
        if json_dict and 'error' in json_dict.keys():
            logger.error(f"Error code {json_dict['error']['code']} returned by service")
        elif not json_dict:
            logger.error('No data returned from service')
        elif 'features' in json_dict.keys():
                for attribute in json_dict['features']:
                    for v in attribute.values():
                        print(v)
                        i += 1
                        # print(i)
                if 'exceededTransferLimit' not in json_dict.keys():
                    exceededTransferLimit = False
        else:
            logger.warning("Could not find 'features' element")

        offset = offset + record_count
        
    print(i)


def get_all_tanks():
    # where = '?where=FACILITY_ID%3D7400040&f=pjson&returnGeometry=false&outFields=*&orderByFields=FACILITY_ID,TANK_ID'
    where = f'?where=1%3D1&f=pjson&returnGeometry=false&outFields=*&orderByFields=FACILITY_ID,TANK_ID'
    where = where + f'&resultRecordCount={record_count}&resultOffset=' 

    exceededTransferLimit = True
    offset = 0
    json_dict = {}    
    df = pd.DataFrame()
    i = 1

    while exceededTransferLimit:
        logger.info(f'Working on page {i}')
        rurl = url + where + str(offset)
        logger.debug(rurl)
        json_dict = get_json(rurl)
        if json_dict and 'error' in json_dict.keys():
            logger.error(f"Error code {json_dict['error']['code']} returned by service")
        elif not json_dict:
            logger.error('No data returned from service')
        elif 'features' in json_dict.keys():
                for feature in json_dict['features']:
                    # df = df.append(feature['attributes'], ignore_index=True)
                    row = pd.json_normalize(feature['attributes'])
                    df = pd.concat([df, row], ignore_index=True)
                if 'exceededTransferLimit' not in json_dict.keys():
                    exceededTransferLimit = False
        else:
            logger.warning("Could not find 'features' element")

        offset = offset + record_count
        i += 1
    
    df.drop(columns=['OBJECTID'], inplace=True, errors='ignore')
    df.to_csv(output_file, index=False)
    logger.info(f'Data exported to {output_file}')
    

def main():
    logger.info(f'There are {get_num_records()} total records.')
    get_all_tanks()

if __name__ == '__main__':
    # print_distinct_values('COMPARTMENT_RD'.upper())
    # get_num_current_tanks()
    # get_num_records()
    main()
