
def col_list_to_string(col_list, quote_type='"'):
	col_string = ''
	for col in col_list:
		col_string = col_string + quote_type + col + quote_type + ', '
	col_string = col_string[:-2] 	
	return col_string 


col_string = '"FacilityID", "FacilityName", "FacilityAddress"'

col_list = col_string.split(', ')
col_list = ['a.' + c for c in col_list]

print(col_list_to_string(col_list, quote_type="'"))
