import pandas as pd
from sodapy import Socrata

# Unauthenticated client only works with public data sets. Note 'None'
# in place of application token, and no username or password:
# client = Socrata("data.ny.gov", None)

# Example authenticated client (needed for non-public datasets):
client = Socrata('data.ny.gov',
                 'VU8AUug91OeDZmzjHhXB4KCaz',
                 username="renae.myers@erg.com",
                 password="TiggerSims1019!")

# First 2000 results, returned as JSON from API / converted to Python list of
# dictionaries by sodapy.
results = client.get("pteg-c78n", limit=2000)

# Convert to pandas DataFrame
results_df = pd.DataFrame.from_records(results)
print(results_df)