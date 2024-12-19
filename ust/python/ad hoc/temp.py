import os
from pathlib import Path
import sys
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

from python.util import utils


# query_logic = """Line 1\n\nLine2\n\nLine3"""
query_logic = "Line 1"


def parse_query_logic(ql_string):
	query_logic = ''
	ql_list = ql_string.split('\n')
	for ql in ql_list:
		if ql == '':
			continue
		query_logic = query_logic + '-- ' + ql + '\n'
	return query_logic[:-1]



print(parse_query_logic(query_logic))
