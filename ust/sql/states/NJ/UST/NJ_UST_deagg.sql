------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* ORGANIZATION VALUES MAY NEED TO BE DEAGGREGATED for ust_tank_substance.substance_id!
 * 
 * Schema = "nj_ust"
 * Organization table name = "EPA_Transfer_Compartment"
 * Organization column name = "CompartmentSubstanceStored"
 * Review the organization values below. If there are multiple values in a single row, the values need to be deaggregated before proceeding.
 */

--select distinct "CompartmentSubstanceStored" from nj_ust."EPA_Transfer_Compartment" where "CompartmentSubstanceStored" is not null order by 1;
/* Organization values:
'Antifreeze'
'Denatured ethanol (98%)'
'Diesel blend containing greater than 20% and less than 99% biodiesel'
'Diesel fuel (b-unknown)'
'Gasoline (unknown type)'
'Hazardous substance'
'Heating oil/fuel oil 2'
'Heating oil/fuel oil 4'
'Heating oil/fuel oil 5'
'Heating oil/fuel oil 6'
'Heating/fuel oil # unknown'
'Kerosene'
'Lube/motor oil (new)'
'Marine fuel'
'Off-road diesel/dyed diesel'
'Other or mixture'
'Other unlisted blend containing any other mixture of diesel, renewable diesel, or more than 20% biodiesel'
'Petroleum product'
'Solvent'
'Unknown'
'Unknown aviation gas or jet fuel'
'Used oil/waste oil'
 */

/* IF after reviewing the organization values, you determine that there are in fact multiple values per row,
 * run deagg.py, setting the variables below.
 * Setting variable deagg_rows to the default value of True will run deagg_rows.py after running
 * deagg.py, which is usually the behavior you will want.
 * Both scripts will automatically update public.ust_element_mapping to to map the new deagg table(s).

ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = 36                  # Enter an integer that is the ust_control_id or release_control_id
data_table_name = 'EPA_Transfer_Compartment' 			# Enter a string containing organization table name
column_name = 'CompartmentSubstanceStored'				# Enter a string containing organization column name
delimiter = ', ' 				# Defaults to ','; delimiter from the column beging deaggregated in the state table. Use '\n' for hard returns.
drop_existing = False 			# Boolean, defaults to False; if True will drop existing deagg table with the same name
deagg_rows = True				# Boolean, defaults to True. If True will automatically execute the deagg_rows.py scripts after executing this script.


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
