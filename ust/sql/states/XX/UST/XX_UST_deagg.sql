------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* ORGANIZATION VALUES MAY NEED TO BE DEAGGREGATED for ust_tank_substance.substance_id!
 * 
 * Schema = "example"
 * Organization table name = "Tanks"
 * Organization column name = "Tank Substance"
 * Review the organization values below. If there are multiple values in a single row, the values need to be deaggregated before proceeding.
 */

--select distinct "Tank Substance" from example."Tanks" where "Tank Substance" is not null order by 1;
/* Organization values:
'Diesel'
'Leaded Gasoline'
'Premium Gasoline, Motor Oil'
'Premium Gasoline, Used Motor Oil'
'Unleaded Gasoline, Antifreeze, Racing Gasoline'
 */

/* IF after reviewing the organization values, you determine that there are in fact multiple values per row,
 * run deagg_example.py, setting the variables below.
 * Setting variable deagg_rows to the default value of True will run deagg_rows_example.py after running
 *  deagg_example.py, which is usually the behavior you will want.
 * Both scripts will automatically update example.ust_element_mapping to
 * to map the new deagg table(s).

ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = 1                  # Enter an integer that is the ust_control_id or release_control_id
data_table_name = 'Tanks' 			# Enter a string containing organization table name
column_name = 'Tank Substance'				# Enter a string containing organization column name
delimiter = ', ' 				# Defaults to ','; delimiter from the column beging deaggregated in the state table. Use '\n' for hard returns.
drop_existing = False 			# Boolean, defaults to False; if True will drop existing deagg table with the same name
deagg_rows = True				# Boolean, defaults to True. If True will automatically execute the deagg_rows_example.py scripts after executing this script.


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
