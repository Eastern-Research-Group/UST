import constants
import utils
import pandas as pd
import numpy as np
import datetime
import re
import os

ust_file = None
lust_file = None


def main(old_file_path):
    
    file_name = re.findall(r'[^\\]+(?=\.)', old_file_path)[0]
    if 'TrUSTD' in file_name:
        state = 'TrUSTD'
    else:
        state = file_name[0:2]
    print(f'State: {state}')
    
    if 'LUST' in file_name:
        ust_or_lust = 'LUST'
    else:
        ust_or_lust = 'UST'
    print(f'UST or LUST: {ust_or_lust}')    
    
    today_str = str(datetime.date.today())
    new_file_name = state + '_' + ust_or_lust + '_template_geocoded_' + today_str + '.xlsx'
    file_path = os.path.dirname(os.path.abspath(old_file_path))
    new_file_path = file_path + '\\' + new_file_name
    print(f'New file path: {new_file_path}')

    if ust_or_lust == 'UST':
        col_names = constants.UST_COL_NAMES
    else:
        col_names = constants.LUST_COL_NAMES
    
    df = pd.read_excel(old_file_path, usecols=lambda x: x in col_names)

    for col in col_names:
        # print(col)
        if col not in df.columns:
            df[col] = np.nan
    df = df[col_names]
    if ust_or_lust == 'UST':
        df['FacilityLatitude'] = np.where(~df['gc_latitude'].isnull(), df['gc_latitude'], df['FacilityLatitude'])
        df['FacilityLongitude'] = np.where(~df['gc_longitude'].isnull(), df['gc_longitude'], df['FacilityLongitude'])
    else:
        df['Latitude'] = np.where(~df['gc_latitude'].isnull(), df['gc_latitude'], df['Latitude'])
        df['Longitude'] = np.where(~df['gc_longitude'].isnull(), df['gc_longitude'], df['Longitude'])
    df.drop(['gc_latitude','gc_longitude'], axis=1, inplace=True)

    df.to_excel(new_file_path, index=False)
    print('Done!')

    
if __name__ == '__main__':    
    # file_path = r'C:\Users\RMyers\OneDrive - Eastern Research Group\Other Projects\UST\State Data\XX\geocoded\XX_YYY_template_20220527.xlsx'
    # file_path = r'C:\Users\RMyers\OneDrive - Eastern Research Group\Other Projects\UST\State Data\XX\geocoded\XX_YYY_template_20220708.xlsx'
    # states = ['OR','SC','TN','TrUSTD']
    # states = ['CA', 'OR', 'SC', 'TN']
    # states = ['TrUSTD']
    # file_paths = []
    # for state in states:
    #     # file_paths.append(file_path.replace('XX',state).replace('YYY','UST'))
    #     file_paths.append(file_path.replace('XX',state).replace('YYY','LUST'))
    # for file_path in file_paths:
    #     print(file_path)
    #     main(file_path)

    file_path = r'C:\Users\erguser\OneDrive - Eastern Research Group\Other Projects\UST\State Data\AL\AL_UST_template_data_only_20230110\AL_UST_template_data_only_20230110.xlsx'
    main(file_path)