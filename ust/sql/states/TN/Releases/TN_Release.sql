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


/*
see what mapping hasn't yet been done for this dataset 
we'll be going through each of the results of this query below
so for each value of epa_column_name from this query result, there will be a 
section below where we generate SQL to perform the mapping 
*/
select distinct epa_table_name, epa_column_name
from v_release_needed_mapping 
where release_control_id = 2 and mapping_complete = 'N'
order by 1, 2;
/*
ust_release				coordinate_source_id
ust_release				how_release_detected_id
ust_release				release_status
ust_release_cause		cause_id
ust_release_source		source_id
ust_release_substance	substance_id
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

/* Query result
 select distinct "Howdiscovered" from "ust_all-tn-environmental-sites" order by 1;

*/
----these are the valid EPA values to map to the state values above 
select * from public.how_release_detected order by 2;

/*
Match the content for state data and EPA values

select insert_sql 
from v_release_needed_mapping_insert_sql 
where release_control_id = 5 and epa_column_name = 'how_release_detected_id';

/* Query results
select distinct 
	'insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 74 || ', ''' || "Howdiscovered" || ''', '''', null);'
from tn_release."ust_all-tn-environmental-sites" order by 1;

Query results
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (74, '1 At Closure', '', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (74, '2 Release Detection', '', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (74, '3 On-site Impact', '', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (74, '3 On-Site Impact', '', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (74, '4 Off-site Impact', '', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (74, '4 Off-Site Impact', '', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (74, '5 Site Check', '', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (74, '6 Tightness Test', '', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (74, '6 Tightness Testing', '', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (74, '7 Environmental Audit', '', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (74, '8 Other', '', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) 
values (74, '9 Unknown', '', null);

Edit the SQL to 
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

--check
SELECT * FROM release_element_value_mapping where release_element_mapping_id=74;
























-----======= Step 3: create crosswalk views for columns that use a lookup table==============
/*
run script org_mapping_xwalks.py to create crosswalk views for all lookup tables 
update the control_id first
see new views:
*/
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

-----======= Step 2: see the EPA tables we need to populate and in what order===============
select distinct epa_table_name, table_sort_order
from v_release_table_population 
where release_control_id = 5
order by table_sort_order;
/*
ust_release
ust_release_substance
ust_release_cause
*/

-----======= Step 3: check if there where any dataset-level comments you need to incorporate
/*:
in this case we need to ignore the aboveground storage tanks,
so add this to the where clause of the ust_release view */
select comments from release_control where release_control_id = 5;
--For currentstatus, already deleted from this table

-----======= Step 4: work through the tables in order ==============================
select * from v_release_table_population;
where release_control_id=5;
/*
ust_release
ust_release_cause
ust_release_substance

using the information you collected to write views that can be used to populate the data tables 
NOTE! The view queried below (v_release_table_population_sql) contains columns that help
      construct the select sql for the insertion views, but will require manual 
      oversight and manipulation by you! 
      In particular, check out the organization_join_table and organization_join_column 
      are used!!
*/

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

-----======= Step 5: use the information from the queries above to create the view============
/*
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
create or replace view tn_release.v_ust_release as 
select distinct 
"Facilityid"::character varying(50) as facility_id,
"Facilityname"::character varying(200) as site_name,
"Facilityaddress1"::character varying(100) as site_address,
"Facilityaddress2"::character varying(100) as site_address2,
"Facilitycity"::character varying(100) as site_city,
"Facilityzip"::character varying(10) as zipcode,
"Facilitycounty"::character varying(100) as county,
"release_status_id" as release_status_id,
"Discoverydate"::date as reported_date,
"how_release_detected_id" as how_release_detected_id
 from tn_release."ust_all-tn-environmental-sites" x
  left join tn_release.v_release_status_xwalk rs on x."Currentstatus" = rs.organization_value 
  left join tn_release.v_how_release_detected_xwalk rd on x."Howdiscovered" = rd.organization_value;

--review: 
select * from tn_release.v_ust_release;
select count(*) from tn_release.v_ust_release;
--14609

--------------------------------------------------------------------------------------------------------------------------
--ust_release_cause 
select organization_table_name_qtd, selected_column, programmer_comments, 
	database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_release_table_population_sql
where release_control_id = 5 and epa_table_name = 'ust_release_cause'
order by column_sort_order;

create or replace view tn_release.v_ust_release_cause as 
select distinct "cause_id" as cause_id
 from tn_release."ust_all-tn-environmental-sites" x
  left join tn_release."v_cause_xwalk" rc on x."Cause" = rc.organization_value 
where epa_value is not null;

select * from  tn_release.v_ust_release_cause; 

select count(*) from tn_release.v_ust_release_cause;
--6

--------------------------------------------------------------------------------------------------------------------------
----------------
--ust_release_substance 
select organization_table_name_qtd, selected_column, programmer_comments, 
	database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_release_table_population_sql
where release_control_id = 5 and epa_table_name = 'ust_release_substance'
order by column_sort_order;

"""ust_all-tn-environmental-sites"""	
"substance_id as substance_id,"		
"substances"	
"substance"	
"erg_productreleased_deagg"	
"""Productreleased"""

--!! this one has a deagg table so we have to alter the join 
create or replace view tn_release.v_ust_release_substance as 
select distinct  ("Facilityid"||'-'||"Sitenumber")::character varying(100) as release_id,b.substance_id
from tn_release."ust_all-tn-environmental-sites" a 
join tn_release.v_substance_xwalk b on a."Productreleased" like '%' || b.organization_value || '%'
where epa_value is not null;


select * from tn_release.v_ust_release_substance;
select count(*) from tn_release.v_ust_release_substance;
--873

=====================================================================================
--------------------------------------------------------------------------------------------------------------------------
--QA/QC

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
set variables:
ust_or_release = 'release' 
control_id = 2
export_file_path = None # If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_dir = None	# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_name = None	# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo

This script will check for the following:
1) Non-unique rows in pa_release.v_ust_release, pa_release.v_ust_release_substance, pa_release.v_ust_release_source,
   pa_release.v_ust_release_source, and pa_release.v_ust_release_corrective_action_strategy (if these views exist). 
   To resolve any cases where the counts are greater than 0, check that you did a "select distinct" when creating these rows. 
2) Failed check constraints. 
3) Bad mapping values. To resolve any cases where bad mapping values exist, examine the specific row(s) in public.release_element_value_mapping 
   and ensure the epa_value exists in the associated lookup table. 
The script will also provide the counts of rows in pa_release.v_ust_release, pa_release.v_ust_release_substance, pa_release.v_ust_release_source,
   pa_release.v_ust_release_source, and pa_release.v_ust_release_corrective_action_strategy (if these views exist) - ensure these counts 
 make sense! */

--------------------------------------------------------------------------------------------------------------------------
--insert data into the EPA schema 

/*run script populate_epa_data_tables.py	
set variables:
ust_or_release = 'release' 
control_id = 2
delete_existing = False # can set to True if there is existing release data you need to delete before inserting new*/

--------------------------------------------------------------------------------------------------------------------------
--export template

/*run script export_template.py
set variables:
control_id = 2
ust_or_release = 'release' 
organization_id = None  	# Can leave as None if you specify the control_id
data_only = False 		# Set to False to export full template including mapping and reference tabs
template_only = False 	# Set to False to export data and mapping tabs as well as reference tab
export_file_path = None # If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_dir = None	# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_name = None	# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo*/


--------------------------------------------------------------------------------------------------------------------------
