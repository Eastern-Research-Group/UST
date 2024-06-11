import sys
import os
sys.path = [os.path.join(os.path.dirname(__file__), "..", "..")] + sys.path
from ust.python.util.logger_factory import logger
from ust.python.util import utils
import pandas as pd

path_to_csv = r'C:\Users\renae\Downloads/USTs_5.csv'


def main():
	df = pd.read_csv(path_to_csv, low_memory=False)
	df_len = len(df)
	print('There are ' + str(df_len) + ' rows in the CSV file')
	# print(df.columns)
	df.sort_values(by=['State'], inplace=True)
	states = df['State'].unique().tolist()
	# print(states)
	i = int(len(states)/3)
	# print(i)
	group1 = states[:i]
	group2 = states[i:i*2]
	group3 = states[i*2:]
	# print(group1)
	# print(group2)
	# print(group3)
	df1 = df[df['State'].isin(group1)]
	df2 = df[df['State'].isin(group2)]
	df3 = df[df['State'].isin(group3)]
	df1_len = len(df1)
	df2_len = len(df2)
	df3_len = len(df3)
	print('There are ' + str(df1_len) + ' rows in df1')
	print('There are ' + str(df2_len) + ' rows in df2')
	print('There are ' + str(df3_len) + ' rows in df3')

	sum_df_len = df1_len + df2_len + df3_len
	if df_len - sum_df_len == 0:
		print('df groups contain all rows')
	else:
		print('Problem with chunked dfs; there are ' + str(df_len) + ' total rows in the chunked dfs!!!')
		exit()
	df1.to_csv(r'C:\Users\renae\Downloads/USTs_group1.csv', index=False)
	df2.to_csv(r'C:\Users\renae\Downloads/USTs_group2.csv', index=False)
	df3.to_csv(r'C:\Users\renae\Downloads/USTs_group3.csv', index=False)
	print('dfs have been exported')


if __name__ == '__main__':
	main()