import os

import pandas as pd

# Unauthenticated client only works with public data sets. Note 'None'
# in place of application token, and no username or password:
# client = Socrata("data.ny.gov", None)

def get_client():
    try:
        from sodapy import Socrata
    except ModuleNotFoundError as exc:
        raise ModuleNotFoundError('NY_API requires the sodapy package to be installed.') from exc

    app_token = os.getenv('NY_SOCRATA_APP_TOKEN')
    username = os.getenv('NY_SOCRATA_USERNAME')
    password = os.getenv('NY_SOCRATA_PASSWORD')

    if app_token and username and password:
        return Socrata('data.ny.gov', app_token, username=username, password=password)
    return Socrata('data.ny.gov', None)

def main():
    client = get_client()
    results = client.get('pteg-c78n', limit=2000)
    results_df = pd.DataFrame.from_records(results)
    print(results_df)


if __name__ == '__main__':
    main()
