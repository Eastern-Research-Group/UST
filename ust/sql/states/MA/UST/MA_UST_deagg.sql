------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* ORGANIZATION VALUES MAY NEED TO BE DEAGGREGATED for ust_tank_substance.substance_id!
 * 
 * Schema = "ma_ust"
 * Organization table name = "Tank info"
 * Organization column name = "CONTENT"
 * Review the organization values below. If there are multiple values in a single row, the values need to be deaggregated before proceeding.
 */

--select distinct "CONTENT" from ma_ust."Tank info" where "CONTENT" is not null order by 1;
/* Organization values:
'Aviation Gasoline'
'Bulk Heating or Fuel Oil (#2,#4,#6)'
'Diesel'
'E85'
'Gasoline'
'Hazardous Material'
'Jet Fuel'
'Kerosene'
'Unregulated Content'
'Virgin Motor Oils'
'Waste Oil'
 */

/* IF after reviewing the organization values, you determine that there are in fact multiple values per row,
 * run deagg.py, setting the variables below.
 * Setting variable deagg_rows to the default value of True will run deagg_rows.py after running
 * deagg.py, which is usually the behavior you will want.
 * Both scripts will automatically update public.ust_element_mapping to to map the new deagg table(s).

ust_or_release = 'ust'             # Valid values are 'ust' or 'release'
control_id = 42                  # Enter an integer that is the ust_control_id or release_control_id
data_table_name = 'Tank info'             # Enter a string containing organization table name
column_name = 'CONTENT'                # Enter a string containing organization column name
delimiters = [',']         List of delimiters; defaults to [', ']. Put the most prevelant first. Put characters padded by spaces in list before those without spaces. Use '\n' for hard returns.
exclude_values = []                # Python list. Values that contain the delimiter but should not be deaggregated
drop_existing = False             # Boolean, defaults to False; if True will drop existing deagg table with the same name
deagg_rows = True                # Boolean, defaults to True. If True will automatically execute the deagg_rows.py scripts after executing this script.


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
