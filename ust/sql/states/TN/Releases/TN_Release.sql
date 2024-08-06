------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*-----======= Step 1: Update the control table =====--------

EITHER:
use insert_control.py to insert into public.release_control
OR:
insert into release_control (organization_id, date_received, data_source)
values ('TN', '2024-06-25', 'Excel downloaded from https://www.tn.gov/environment/ust/data-reports.html')
returning release_control_id;
*/

--the script above returned a new release_control_id of 5 for this dataset:
select * from public.release_control where release_control_id = 5;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*-----======= Step 2: Upload the state data 
 -- As my first time, rename previous tables for reference
 alter table tn_lust rename to tn_lust_old 
 alter table "SubstanceReleased_deagg" rename to "SubstanceReleased_deagg_old"; 
 alter table "TN_LUST_template" rename to "TN_LUST_template_old"; 
 alter table "tn_lust_geocoded" rename to "tn_lust_geocoded_old"; 
 alter table "ust_all-tn-environmental-sites" rename to "ust_all-tn-environmental-sites_old";
*/
/*
EITHER:
script import_data_file_files.py will create the correct schema (if it doesn't yet exist), 
then upload all .xlsx, .xls, .csv, and .txt in the specified directory to this schema. 
To run, set these variables:

state = 'TN' 
# Enter a directory (not path to a specific file) for ust_path and release_path
# Set to None if not applicable
ust_path = None
release_path = r'C:\Github\UST-49\ust\sql\states\TN\Releases' 
overwrite_table = False 

OR:
manually in the database, create schema pa_release if it does not exist, then manually upload the state data
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*-----======= Step 3: View the original state data ========------------
--Get an overview of what the state's data looks like. In this case, we only have one table
  select * from tn_release."ust_all-tn-environmental-sites" ;

/* As noted before, there are statuses we need exclude, 
  -- Add comments in release_control
update release_control set
comments='for records with currentstatus in (0a Suspected Release - Closed,0 Suspected Release - RD records,3 Release Investigation) were excluded per the state's direction during the pilot.'
where release_control_id = 5;

--see what columns exist in the state's data 
select table_name, column_name, is_nullable, data_type, character_maximum_length 
from information_schema.columns 
where table_schema = 'tn_release' and table_name = 'ust_all-tn-environmental-sites' 
order by ordinal_position;

*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*-----======= Step 4: Map data for related EPA tables ======------------
--get the EPA tables that we need to populate
select table_name
from public.release_element_table_sort_order
order by sort_order;
/*   
ust_release
ust_release_substance
ust_release_cause
ust_release_source
ust_release_corrective_action_strategy

For TN data, no matched fields for ust_release_source and ust_release_corrective_action_strategy 
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Start with the first table, ust_release 
--get the EPA columns we need to look for in the state data 
select database_column_name 
from release_elements a join release_elements_tables b on a.element_id = b.element_id
where table_name = 'ust_release' 
order by sort_order;
/*
facility_id
tank_id_associated_with_release
release_id
federally_reportable_release
site_name
site_address
site_address2
site_city
zipcode
county
state
epa_region
facility_type_id
tribal_site
tribe
latitude
longitude
coordinate_source_id
release_status_id
reported_date
nfa_date
media_impacted_soil
media_impacted_groundwater
media_impacted_surface_water
how_release_detected_id
closed_with_contamination
no_further_action_letter_url
military_dod_site
*/

--review state data again 
select * from tn_release."ust_all-tn-environmental-sites";

--run queries looking for lookup table values 
select distinct "Currentstatus" from tn_release."ust_all-tn-environmental-sites" order by 1;
--this will map to release_status, but have to deaggrate it; we'll do the actual mapping later 

select distinct "Howdiscovered" from tn_release."ust_all-tn-environmental-sites"  order by 1;
--this will map to EPA element how_release_detected,  we'll do this later. 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*   ----- release_element_mapping------
Generate SQL statements to do the inserts into release_element_mapping. 
Run the query below, paste the results into your console, then do a global replace of XX for the release_control_id 
Next, go through each generated SQL statement and do the following:
If there is no matching column in the state's data, delete the SQL statement 
If there is a matching column in the state's data, update the ORG_TAB_NAME and ORG_COL_NAME variables to match the state's data 
If you have questions or comments, replace the "null" with your comment. 
After you have updated all the SQL statements, run them to update the database. 
*/
select * from public.v_release_element_summary_sql;

/* Got 35 sql insert statement for release_element_mapping, such as 
"insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (XX,'ust_release','no_further_action_letter_url','ORG_TAB_NAME','ORG_COL_NAME',null);"

after check state data, I have 12
*/
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (5,'ust_release','facility_id','ust_all-tn-environmental-sites','Facilityid',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (5,'ust_release','site_name','ust_all-tn-environmental-sites','Facilityname',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (5,'ust_release','site_address','ust_all-tn-environmental-sites','Facilityaddress1',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (5,'ust_release','site_address2','ust_all-tn-environmental-sites','Facilityaddress2',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (5,'ust_release','site_city','ust_all-tn-environmental-sites','Facilitycity',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (5,'ust_release','zipcode','ust_all-tn-environmental-sites','Facilityzip',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (5,'ust_release','county','ust_all-tn-environmental-sites','Facilitycounty',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (5,'ust_release','release_status_id','ust_all-tn-environmental-sites','Currentstatus',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (5,'ust_release','reported_date','ust_all-tn-environmental-sites','Discoverydate',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (5,'ust_release','how_release_detected_id','ust_all-tn-environmental-sites','Howdiscovered',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (5,'ust_release_substance','substance_id','ust_all-tn-environmental-sites','Productreleased','Column is comma-separated');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (5,'ust_release_cause','cause_id','ust_all-tn-environmental-sites','Cause','data have number with text);


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----- see what columns in which table we need to map
select epa_table_name, epa_column_name 
from (select distinct epa_table_name, epa_column_name, table_sort_order, column_sort_order
	from v_release_needed_mapping where release_control_id = 5 and mapping_complete = 'N' 
     order by table_sort_order, column_sort_order) x;

/*
ust_release			how_release_detected_id
ust_release			release_status
ust_release_cause		cause_id
ust_release_substance		substance_id
*/
*/


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ust_release.how_release_detected_id
/*run the query from the generated sql above to see what the state's data looks like
you are checking to make sure their values line up with what we are looking for on the EPA side
Next, see if the state values need to be deaggregated 
(that is, is there only one value per row in the state data? If not, we need to deaggregate them)
*/
--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from "' || organization_table_name || '" order by 1;'
from v_release_needed_mapping 
where release_control_id = 5 and epa_column_name = 'how_release_detected_id';

-- got SQL as 
 select distinct "Howdiscovered" from "ust_all-tn-environmental-sites" order by 1;

-- Data showed no need to deagg.
-- for valid EPA values to map to the state values above 
select * from public.how_release_detected order by 2;

/* generate generic sql to insert value mapping rows into release_element_value_mapping, 
then modify the generated sql with the mapped EPA values 
NOTE: insert a NULL for epa_value if you don't have a good guess 
*/
select insert_sql 
from v_release_needed_mapping_insert_sql 
where release_control_id = 5 and epa_column_name = 'how_release_detected_id';


select distinct 
	'insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 74 || ', ''' || "Howdiscovered" || ''', '''', null);'
from tn_release."ust_all-tn-environmental-sites" order by 1;
/*
Query results like
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (74, '1 At Closure', '', null);
...

Edit the SQL 
*/
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (74, '1 At Closure', 'Other', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (74, '2 Release Detection', 'Other', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (74, '3 On-site Impact', 'Other', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (74, '3 On-Site Impact', 'Other', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (74, '4 Off-site Impact', 'Other', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (74, '4 Off-Site Impact', 'Other', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (74, '5 Site Check', 'Inspection', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (74, '6 Tightness Test', 'Tank tightness testing', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (74, '6 Tightness Testing', 'Tank tightness testing', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (74, '7 Environmental Audit', 'Inspection', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (74, '8 Other', 'Other', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (74, '9 Unknown', 'Unknown', null);

--check---
SELECT * FROM release_element_value_mapping where release_element_mapping_id=74;

--8/5/2024 some update after review
select * from release_element_value_mapping 
where release_element_mapping_id=74 ;
----update --------
update release_element_value_mapping
set epa_value='Inspection',
programmer_comments='This mapping was used during the pilot.' 
where release_element_value_mapping_id=121;
--or where release_element_mapping_id=74 and organization_value='1 At Closure'


update release_element_value_mapping
set epa_value='Third party (well water, vapor intrusion, etc.)',
programmer_comments='This mapping was used during the pilot.' 
where release_element_value_mapping_id in (125,126);
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ust_release.release_status_id

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from "' || organization_table_name || '" order by 1;'
from v_release_needed_mapping 
where release_control_id = 5 and epa_column_name = 'release_status_id';

/* query result
"select distinct ""Currentstatus"" from ""ust_all-tn-environmental-sites"" order by 1;"

 run the query from the generated sql above to see what the state's data looks like
you are checking to make sure their values line up with what we are looking for on the EPA side
Next, see if the state values need to be deaggregated 
(that is, is there only one value per row in the state data? If not, we need to deaggregate them)
 No need deagg!
*/
--see what the EPA values we need to map to are
select * from release_statuses order by 2;
/*
Active: Corrective Action
Active: general
Active: post Corrective Action monitoring
Active: site investigation
Active: stalled
No further action
Other
Unknown
*/

/*generate generic sql to insert value mapping rows into release_element_value_mapping, 
then modify the generated sql with the mapped EPA values 
NOTE: insert a NULL for epa_value if you don't have a good guess 
NOTE: if the organization_value is one that should exclude the facility/tank from UST Finder
      (e.g. a non-federally regulated substance), manually modify the generated sql to 
       include column exclude_from_query and set the value to 'Y'*/

select insert_sql 
from v_release_needed_mapping_insert_sql 
where release_control_id = 5 and epa_column_name = 'release_status_id';

select distinct 
	'insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 71 || ', ''' || "Currentstatus" || ''', '''', null);'
from tn_release."ust_all-tn-environmental-sites" order by 1;

/* Query results and edit
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (71, '1 Tank Closure', 'No further action', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (71, '13 Abandoned Facility Project', 'No further action', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (71, '1a Completed Tank Closure', 'No further action', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (71, '1b Closure Application Expired', 'Unknown', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (71, '1c Line Closure', 'No further action', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (71, '1d Completed Line Closure', 'No further action', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (71, '2 Site Check', 'Active: site investigation', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (71, '6 Corrective Action', 'Active: Corrective Action', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (71, '7 Closure Monitoring', 'No further action', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (71, '8 Case Closed', 'No further action', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (71, '9 Other', 'Other', null);


-- update after review, 8/5/2024
select * from release_element_value_mapping 
where release_element_mapping_id=71 ;
----update --------
update release_element_value_mapping  	
set epa_value='No further action',
programmer_comments='This mapping was used during the pilot.' 
where release_element_mapping_id=71 and organization_value='1b Closure Application Expired';

update release_element_value_mapping  	
set epa_value='No further action',
programmer_comments='originally mapped to "Other", but in pilot it is "No further action". It must be requested by state.' 
where release_element_mapping_id=71 and organization_value='9 Other';
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----- ust_release_substance.substance_id

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from "' || organization_table_name || '" order by 1;'
from v_release_needed_mapping 
where release_control_id = 5 and epa_column_name = 'substance_id';

/*run the query from the generated sql above to see what the state's data looks like
you are checking to make sure their values line up with what we are looking for on the EPA side
Next, see if the state values need to be deaggregated 
(that is, is there only one value per row in the state data? If not, we need to deaggregate them)
*/

select distinct "Productreleased" from "ust_all-tn-environmental-sites" order by 1;
  /* Need deagg
    Diesel, Jet Fuel, Kerosene
    Diesel, Jet Fuel, Kerosene, Waste Oil, Used Oil
    Gasoline
    Gasoline, Diesel, Jet Fuel, Kerosene
    Gasoline, Diesel, Jet Fuel, Kerosene, Waste Oil, Used Oil
.....
*/
----=====deaggregate===========----------------
/*
in this case we have comma-separated values in single rows, which means we need to deaggregate them in order to map them. 
Run deagg.py after update related parameters:
----
ust_or_release = 'release' # valid values are 'ust' or 'release'
control_id = 5
table_name = 'ust_all-tn-environmental-sites'
column_name = 'Productreleased'
delimiter = ', '     /* Pay attention to the space part */
----
the script will create a deagg table and return the name of the new table; in this case: erg_productreleased_deagg
check the contents of the deagg table:
*/
select * from erg_productreleased_deagg order by 2;

--!! update release_element_mapping with the new deagg_table_name and deagg_column_name, generated by deagg.py
update release_element_mapping set deagg_table_name = 'erg_productreleased_deagg', 
 deagg_column_name = '"Productreleased"' 
where release_control_id = 5 and epa_column_name = 'substance_id';

/*generate generic sql to insert value mapping rows into release_element_value_mapping, 
then modify the generated sql with the mapped EPA values 
NOTE: insert a NULL for epa_value if you don't have a good guess 
NOTE: if the organization_value is one that should exclude the facility/tank from UST Finder
      (e.g. a non-federally regulated substance), manually modify the generated sql to 
       include column exclude_from_query and set the value to 'Y'*/

select insert_sql 
from v_release_needed_mapping_insert_sql 
where release_control_id = 5 and epa_column_name = 'substance_id';
----Query result---------------------
select distinct 
	'insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 75 || ', ''' || "Productreleased"|| ''', '''', null);'
from tn_release."erg_productreleased_deagg" order by 1;

----Query for insert statement---------------------
"insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (75, ' Diesel', '', null);"

------list valid EPA values to match 
select * from public.substances order by 1;

-------Insert statement---------------------
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (75, ' Diesel', 'Diesel fuel (b-unknown)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (75, ' Jet Fuel', 'Unknown aviation gas or jet fuel', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (75, ' Kerosene', 'Kerosene', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (75, ' Used Oil', 'Used oil/waste oil', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (75, ' Waste Oil', 'Used oil/waste oil', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (75, 'Gasoline', 'Gasoline (unknown type)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (75, 'Unknown', 'Unknown', null);

-- update after reviw, 8/5/2024
select * from release_element_value_mapping 
where release_element_mapping_id=71 ;
----update --------
update release_element_value_mapping  	
set epa_value='No further action',
programmer_comments='This mapping was used during the pilot.' 
where release_element_mapping_id=71 and organization_value='1b Closure Application Expired';

update release_element_value_mapping  	
set epa_value='No further action',
programmer_comments='originally mapped to "Other", but in pilot it is "No further action". It must be requested by state.' 
where release_element_mapping_id=71 and organization_value='9 Other';

  -----check ------------------------------
select * from release_element_value_mapping
where release_element_mapping_id=75;

select distinct epa_value
from release_element_value_mapping a join release_element_mapping b on a.release_element_mapping_id = b.release_element_mapping_id
where release_control_id = 5 and epa_column_name = 'substance_id'
and epa_value not in (select substance from substances)
order by 1;


--------------------------------------------------------------------------------------------
---------------------------------
---- ust_release_cause.cause_id

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from "' || organization_table_name || '" order by 1;'
from v_release_needed_mapping 
where release_control_id = 5 and epa_column_name = 'cause_id';
------Query Result---------
select distinct "Cause" from "ust_all-tn-environmental-sites" order by 1;

/*run the query from the generated sql above to see what the state's data looks like
you are checking to make sure their values line up with what we are looking for on the EPA side
Next, see if the state values need to be deaggregated 
(that is, is there only one value per row in the state data? If not, we need to deaggregate them)
*/

------list valid EPA values to match 
select * from public.causes order by 1;
/*
"Corrosion"
"Damage to dispenser"
"Damage to dispenser hose"
"Delivery overfill"
"Delivery problem"
"Dispenser spill"
"Dope/sealant"
"Flex connector failure"
"Human error"
"Motor vehicle accident"
"Overfill (general)"
"Piping failure"
"Shear valve failure"
"Spill bucket failure"
"Tank corrosion"
"Tank damage"
"Tank removal"
"Weather/natural disaster (i.e., hurricane, flooding, fire, earthquake)"
"Other"
"Unknown"
*/

select insert_sql 
from v_release_needed_mapping_insert_sql 
where release_control_id = 5 and epa_column_name = 'cause_id';
----Query result---------------------
select distinct 
	'insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
     values (' || 76 || ', ''' || "Cause" || ''', '''', null);'
from tn_release."ust_all-tn-environmental-sites" order by 1;

---------------Insert Statement---------------
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (76, '1 Spill', 'Overfill (general)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (76, '2 Overfill', 'Overfill (general)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (76, '3 Human Error', 'Human error', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (76, '4 Corrosion', 'Corrosion', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (76, '5 Pipe Failure', 'Piping failure', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (76, '6 Mechanical Failure', 'Other', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (76, '7 Unknown', 'Unknown', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (76, '8 Other', 'Other', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (76, 'Corrosion', 'Corrosion', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (76, 'Human Error', 'Human error', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (76, 'Mechanical Failure', 'Other', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (76, 'Other', 'Other', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (76, 'Pipe Failure', 'Piping failure', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (76, 'Unknown', 'Unknown', null);

----Check---------------
select * from release_element_value_mapping 
where release_element_mapping_id=76;

==========================================
--check if there is any more mapping to do
select distinct epa_table_name, epa_column_name
from v_release_needed_mapping 
where release_control_id = 5 and mapping_complete = 'N'
order by 1, 2;

--check if any of the mapping is bad:
select database_lookup_table, epa_value 
from v_release_bad_mapping 
where release_control_id = 5 order by 1, 2;
--!!!if there are results from this query, fix them!!!

--if not, it's time to write the queries that manipulate the state's data into EPA's tables 
SET search_path TO "tn_release";

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----=====EPA Data Tables =============---------------
 -----------Step 1--------------
/* create crosswalk views for columns that use a lookup table
run script org_mapping_xwalks.py to create crosswalk views for all lookup tables 
see new views:*/
select table_name 
from information_schema.tables 
where table_schema = 'tn_release' and table_type = 'VIEW'
and table_name like '%_xwalk' order by 1;
/*
v_cause_xwalk
v_how_release_detected_xwalk
v_release_status_xwalk
v_substance_xwalk
*/

  -----------Step 2--------------
-- see the EPA tables we need to populate, and in what order
select distinct epa_table_name, table_sort_order
from v_release_table_population 
where release_control_id = 5
order by table_sort_order;
/*
ust_release
ust_release_substance
ust_release_cause
*/

  -----------Step 3--------------
/* check if there where any dataset-level comments you need to incorporate:
in this case we need to ignore the aboveground storage tanks,
so add this to the where clause of the ust_release view */
select comments from release_control where release_control_id = 5;
--"for records with currentstatus in (0a Suspected Release - Closed,0 Suspected Release - RD records,3 Release Investigation) were excluded per the state's direction during the pilot."
--ignore those rows where "Currentstatus" in ('0a Suspected Release - Closed','0 Suspected Release - RD records','3 Release Investigation')
*/
select * from v_release_table_population
where release_control_id=5;

  -----------Step 4--------------
/* work through the tables in order, using the information you collected 
to write views that can be used to populate the data tables 
NOTE! The view queried below (v_release_table_population_sql) contains columns that help
      construct the select sql for the insertion views, but will require manual 
      oversight and manipulation by you! 
      In particular, check out the organization_join_table and organization_join_column 
      are used!!*/
select organization_table_name_qtd, selected_column, programmer_comments, 
	database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_release_table_population_sql
where release_control_id = 5 and epa_table_name = 'ust_release'
order by column_sort_order;

/*
-- 10 rows
"""Facilityid""::character varying(50) as facility_id,"
"""Facilityname""::character varying(200) as site_name,"
"""Facilityaddress1""::character varying(100) as site_address,"
"""Facilityaddress2""::character varying(100) as site_address2,"
"""Facilitycity""::character varying(100) as site_city,"
"""Facilityzip""::character varying(10) as zipcode,"
"""Facilitycounty""::character varying(100) as county,"
"release_status_id as release_status_id,"
"""Discoverydate""::date as reported_date,"
"how_release_detected_id as how_release_detected_id,"
*/

  -----------Step 5-------------------
/* use the information from the queries above to create the view:
!!! NOTE how I'm using the programmer_comments column to adjust the view (e.g. nfa_date)
!!! NOTE also sometimes you need to explicitly cast data types. In this example, the two
    dates "CONFIRMED_DATE" and "STATUS_DATE" are text fields in the state's data and need 
    to be cast as dates to fit into the EPA table  
!!! NOTE also you may get errors related to data conversion when trying to compile the view
    you are creating here. This is good because it alerts you the data you are trying to
    insert is not compatible with the EPA format. Fix these errors before proceeding! 
!!! NOTE: Remember to do "select distinct" if necessary
!!! NOTE: Some states do not include State or EPA Region in their database, but it is generally
    safe for you to insert these yourself, so add them! */
CREATE OR REPLACE VIEW tn_release.v_ust_release
 AS
 SELECT DISTINCT (((x."Facilityid" || '-'::text) || x."Sitenumber"))::character varying(50) AS release_id,
    x."Facilityid"::character varying(50) AS facility_id,
    x."Facilityname"::character varying(200) AS site_name,
    x."Facilityaddress1"::character varying(100) AS site_address,
    x."Facilityaddress2"::character varying(100) AS site_address2,
    x."Facilitycity"::character varying(100) AS site_city,
    x."Facilityzip"::character varying(10) AS zipcode,
    x."Facilitycounty"::character varying(100) AS county,
    'TN' as state, 
    4 as epa_region, 
    rs.release_status_id,
    x."Discoverydate"::date AS reported_date,
    rd.how_release_detected_id
   FROM tn_release."ust_all-tn-environmental-sites" x
     LEFT JOIN tn_release.v_release_status_xwalk rs ON x."Currentstatus" = rs.organization_value::text
     LEFT JOIN tn_release.v_how_release_detected_xwalk rd ON x."Howdiscovered" = rd.organization_value::text
  WHERE rs.organization_value IS NOT NULL and 
  "Currentstatus" not in ('0a Suspected Release - Closed','0 Suspected Release - RD records','3 Release Investigation');
--Note: With  "WHERE rs.organization_value IS NOT NULL" is actually good enough to exclude those status.

--review: 
select * from tn_release.v_ust_release;
select count(*) from tn_release.v_ust_release;
--14691
--------

--------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------
----  now repeat for each data table:
------ ust_release_substance --------------
select organization_table_name_qtd, selected_column, programmer_comments, 
	database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_release_table_population_sql
where release_control_id = 5 and epa_table_name = 'ust_release_substance'
order by column_sort_order;
/*
"ust_all-tn-environmental-sites"	
"substance_id as substance_id,"
"Column is comma-separated",		
"substances"	
"substance"	
"erg_productreleased_deagg"	
"Productreleased"
*/
--!! this one has a deagg table so we have to alter the join 
--be sure to do select distinct if necessary!

create or replace view tn_release.v_ust_release_substance as 
select distinct  ("Facilityid"||'-'||"Sitenumber")::character varying(50) as release_id,b.substance_id
from tn_release."ust_all-tn-environmental-sites" a 
join tn_release.v_substance_xwalk b on a."Productreleased" like '%' || b.organization_value || '%'
where epa_value is not null and 
  "Currentstatus" not in ('0a Suspected Release - Closed','0 Suspected Release - RD records','3 Release Investigation');
--This time the status condition in where is needed!

select * from tn_release.v_ust_release_substance;
select count(*) from tn_release.v_ust_release_substance;
--873

--------------------------------------------------------------------------------------------------------------------------
------ ust_release_cause ----------------------
select organization_table_name_qtd, selected_column, programmer_comments, 
	database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_release_table_population_sql
where release_control_id = 5 and epa_table_name = 'ust_release_cause'
order by column_sort_order;

create or replace view tn_release.v_ust_release_cause as 
create or replace view tn_release.v_ust_release_cause as 
select distinct  ("Facilityid"||'-'||"Sitenumber")::character varying(50) as release_id, "cause_id" as cause_id
 from tn_release."ust_all-tn-environmental-sites" x
   left join tn_release."v_cause_xwalk" rc on x."Cause" = rc.organization_value 
where epa_value is not null and
"Currentstatus" not in ('0a Suspected Release - Closed','0 Suspected Release - RD records','3 Release Investigation');

select * from  tn_release.v_ust_release_cause; 
select count(*) from tn_release.v_ust_release_cause;
--5883

--------------------------------------------------------------------------------------------------------------------------
----------------


=====================================================================================
--------------------------------------------------------------------------------------------------------------------------
---- ===== QAQC ==========-------

--check that you didn't miss any columns when creating the data population views:
--if any rows are returned by this query, fix the appropriate view by adding the missing columns!

select epa_table_name, epa_column_name, 
	organization_table_name, organization_column_name, 
	organization_join_table, organization_join_column, 
	deagg_table_name, deagg_column_name
from v_release_missing_view_mapping a
where release_control_id =5
order by 1, 2;

/*
select b.column_name, b.data_type, b.character_maximum_length, a.data_type, a.character_maximum_length 
from information_schema.columns a join information_schema.columns b on a.column_name = b.column_name 
where a.table_schema = 'tn_release' and a.table_name = 'v_ust_release'
and b.table_schema = 'public' and b.table_name = 'ust_release'
and (a.data_type <> b.data_type or b.character_maximum_length > a.character_maximum_length )
order by b.ordinal_position;
*/

--run Python QA/QC script

/*run script qa_check.py

set variables 
ust_or_release = 'release' 
control_id = 5
export_file_path = None # If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_dir = None	# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_name = None	# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
#    self.export_file_dir = '../exports/QAQC/' + self.organization_id.upper() + '/'
     self.export_file_dir = 'C:/Github/UST-49/ust/python/exports/QAQC/' + self.organization_id.upper() + '/'

(due to error for mine at local setting
add physical path due to access:
FileNotFoundError: [WinError 3] The system cannot find the path specified: '..\\exports\\QAQC\\TN')


This script will check the views you just created in the state schema for the following:
1) Missing views - will check that if you created a child view (for example, v_ust_compartment), that the parent view(s) (for example, v_ust_tank)  exist. 
2) Counts of child tables that have too few rows (for example, v_ust_compartment should have at least as many rows as v_ust_tank because
   every tank should have at least one compartment). 
3) Missing join columns to parent tables. For example, v_ust_compartment must contain facility_id and tank_id in order to be able to join it  to its parent tables. 
4) Missing required columns. 
5) Required columns that exist but contain null values. 
6) Extraneous columns - will check for any columns in the views that don't match a column in the equivalent EPA table. This will help identify typos or other errors. 
7) Non-unique rows. To resolve any cases where the counts are greater than 0, check that you did a "select distinct" when creating these views. Then check for bad joins.  
8) Bad data types - will check for columns in the view where either the data type is different than the EPA column, or (for character columns) 
   if the length of the state value is too long to fit into the EPA column. If the data is too long to fit in the EPA column, this may indicate an error in your code or mapping, OR it may mean you need to truncate the state's value to fit the EPA format. 
9) Failed check constraints. 
10) Bad mapping values. To resolve any cases where bad mapping values exist, examine the specific row(s) in public.ust_element_value_mapping and ensure the epa_value exists in the associated lookup table. 

The script will also provide the counts of rows in wv_ust.v_ust_release, wv_ust.v_ust_release_substance, wv_ust.v_ust_release_source, 
   wv_ust.v_ust_release_cause, and wv_ust.v_ust_release_corrective_action_strategy (if these views exist) - ensure these counts make sense! 
   
The script will export a QAQC spreadsheet (in additional to printing to the screen and logs). If there are errors, re-write the views above, 
then re-run the qa script, and proceed when all errors have been resolved. */
--------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
--insert data into the EPA schema 

/*run script populate_epa_data_tables.py	
set variables:
ust_or_release = 'release' 
control_id = 5
delete_existing = False # can set to True if there is existing release data you need to delete before inserting new
*/--insert data into the EPA schema 

/*run script populate_epa_data_tables.py	
set variables:
ust_or_release = 'release' 
control_id = 5
delete_existing = True # False or set to True if there is existing release data you need to delete before inserting new*/

--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--Quick sanity check of number of rows inserted:
select table_name, num_rows from v_ust_table_row_count
where ust_control_id = 5 order by sort_order;
--NONE (release data not in any of the tables, such as Facility, tanks...)
--------------------------------------------------------------------------------------------------------------------------
--export template

/*run script export_template.py
set variables:
control_id = 5
ust_or_release = 'release' 
organization_id = None  	# Can leave as None if you specify the control_id
data_only = False 		# Set to False to export full template including mapping and reference tabs
template_only = False 	# Set to False to export data and mapping tabs as well as reference tab
export_file_path = None # If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_dir = None	# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_name = None	# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo

----Similar error for folder exports, had to set physical path
    self.export_file_dir = 'C:/Github/UST-49/ust/python/exports/epa_templates/' + self.organization_id.upper() + '/'
  # self.export_file_dir = '../exports/epa_templates/' + self.organization_id.upper() + '/'
*/


--------------------------------------------------------------------------------------------------------------------------
-- Control table summary----------
--------------------------------------------------------------------------------------------------------------------------
/*run script control_table_summary.py
set variables:
ust_or_release = 'release' # valid values are 'ust' or 'release'
control_id = 5
organization_id = None

self.export_file_dir = 'C:/Github/UST-49/ust/python/exports/control_table_summaries/' + self.organization_id.upper() + '/'

----Finished!--------------------------*/			