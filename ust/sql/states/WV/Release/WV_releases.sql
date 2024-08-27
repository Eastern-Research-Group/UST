------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*-----======= Step 1: Update the control table =====--------
EITHER:
use insert_control.py to insert into public.release_control
/*
organization_id = 'WV'
system_type = 'release' # Accepted values are 'ust' or 'release'
data_source = 'https://apps.dep.wv.gov/tanks/public/Pages/USTReports.aspx' # Describe where data came from (e.g. URL downloaded from, Excel spreadsheets from state, state API URL, etc.)
comments = None 

Return: New control_id for WV is 7
*/
OR:
insert into release_control (organization_id, date_received, data_source)
values ('WV', '2024-07-30', 'Excel downloaded from https://apps.dep.wv.gov/tanks/public/Pages/USTReports.aspx')
returning release_control_id;
*/

--the script above returned a new release_control_id of 7 for this dataset:
select * from public.release_control where release_control_id = 7;

/*-----======= Step 2: Upload the state data 
 EITHER:
script import_data_file.py will create the correct schema (if it doesn't yet exist), 
then upload all .xlsx, .xls, .csv, and .txt in the specified directory to this schema. 
To run, set these variables:

organization_id = 'WV' 
# Enter a directory (NOT a path to a specific file) for ust_path and release_path
# Set to None if not applicable
# ust_path = r'C:\Users\renae\Downloads\KS\UST'
ust_path = None
release_path = r'C:\AnnaWork2023\USTank-WV_release\StateFile' 
overwrite_table = False 

Notes: The state file in .xls got error while run py
"ImportError: Missing optional dependency 'xlrd'. Install xlrd >= 2.0.1 for xls Excel support Use pip or conda to install xlrd."
I transfer file to .xlsx, also cleaned up the first empty rows, so the column head will matched with data
I also modified the column head, so they are in one row, instead of two rows in original data file.

OR:
manually in the database, create schema pa_release if it does not exist, then manually upload the state data
*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----======= Step 3: View the original state data ========------------
--Get an overview of what the state's data looks like. In this case, we only have one table
  select * from wv_release."WVDEP.USTLUSTReports_FOIA-LUSTPublic" ;

-- Check to see if there is a primary ID
SELECT count(*), "Facility_ID"
	FROM wv_release."WVDEP.USTLUSTReports_FOIA-LUSTPublic"
	group by "Facility_ID" having count(*)>1;
/* 533 have count(*) >1, so have to use "Facility_ID" + "Leak_ID"
  such as */
SELECT "Facility_ID", concat("Facility_ID","Leak_ID") as newkey
	FROM wv_release."WVDEP.USTLUSTReports_FOIA-LUSTPublic"
	where "Facility_ID" ='2402998';

-- check
SELECT count(*), "Suspected Release"
FROM wv_release."WVDEP.USTLUSTReports_FOIA-LUSTPublic"
group by "Suspected Release";
--3930='No', 65='Yes'
 -- there are statuses we need exclude, add comments in release_control
update release_control set
comments='Ignored rows with Suspected Release = Yes in the view. Need check with state'
where release_control_id = 7;


--see what columns exist in the state's data 
select table_name, column_name, is_nullable, data_type, character_maximum_length 
from information_schema.columns 
where table_schema = 'wv_release' and table_name = 'WVDEP.USTLUSTReports_FOIA-LUSTPublic' 
order by ordinal_position;

--create index
create index WV_LUST_RPT_facid_idx on wv_release."WVDEP.USTLUSTReports_FOIA-LUSTPublic"("Facility_ID");


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----======= Step 4: Map data for related EPA tables ======------------
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
select * from wv_release."WVDEP.USTLUSTReports_FOIA-LUSTPublic";

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   ----- release_element_mapping------
--Generate SQL statements to do the inserts into release_element_mapping. 

select * from public.v_release_element_summary_sql;

/* Got 42 sql insert statement for release_element_mapping, 
--ust_release, ust_release_cause, ust_release_substance, ust_release_source and ust_release_corrective_action_strategy
For WV datafile, it has fields only matched with ust_release

*/
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (7,'ust_release','facility_id','WVDEP.USTLUSTReports_FOIA-LUSTPublic','Facility_ID',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (7,'ust_release','release_id','WVDEP.USTLUSTReports_FOIA-LUSTPublic','Leak_ID',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (7,'ust_release','site_name','WVDEP.USTLUSTReports_FOIA-LUSTPublic','Current Facility Name',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (7,'ust_release','site_address','WVDEP.USTLUSTReports_FOIA-LUSTPublic','Address',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (7,'ust_release','site_city','WVDEP.USTLUSTReports_FOIA-LUSTPublic','City',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (7,'ust_release','zipcode','WVDEP.USTLUSTReports_FOIA-LUSTPublic','Zip',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (7,'ust_release','county','WVDEP.USTLUSTReports_FOIA-LUSTPublic','County',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (7,'ust_release','release_status_id','WVDEP.USTLUSTReports_FOIA-LUSTPublic','("Confirmed Release","Cleanup Initiated", "Closed Date")','If Closed Date is not null, ReleaseStatus=No further action; If Cleanup Initiated is not null, ReleaseStatus=Active: corrective action; If Confirmed Release is not null, ReleaseStatus=Active: general');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (7,'ust_release','nfa_date','WVDEP.USTLUSTReports_FOIA-LUSTPublic','Closed Date',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (7,'ust_release','reported_date','WVDEP.USTLUSTReports_FOIA-LUSTPublic','Confirmed Release',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (7,'ust_release','media_impacted_soil','WVDEP.USTLUSTReports_FOIA-LUSTPublic','Priority', 'where="3-Soil contamination"');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (7,'ust_release','media_impacted_groundwater','WVDEP.USTLUSTReports_FOIA-LUSTPublic','Priority', 'where="2-Groundwater contamination"');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (7,'ust_release','media_impacted_surface_water','WVDEP.USTLUSTReports_FOIA-LUSTPublic','Priority', 'where="1-product, vapor, or sig GW contamination"');

--one update for release_id
update release_element_mapping
set programmer_comments='calculated status from three columns, need confirm by state',
organization_column_name='closed date, confirmed release, cleanup initiated'
where release_control_id = 7 and "release_element_mapping_id"=267;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----- see what columns in which table we need to map
select epa_table_name, epa_column_name 
from (select distinct epa_table_name, epa_column_name, table_sort_order, column_sort_order
	from v_release_needed_mapping where release_control_id = 7 and mapping_complete = 'N' 
     order by table_sort_order, column_sort_order) x;

--"ust_release"	"release_status_id"
--get insert sql
select insert_sql 
from v_release_needed_mapping_insert_sql 
where release_control_id = 7 and epa_column_name = 'release_status_id';
/*
"select distinct 
	'insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 273 || ', ''' || ""(""Confirmed Release"",""Cleanup Initiated"", ""Closed Date"")"" || ''', '''', null);'
from wv_release.""WVDEP.USTLUSTReports_FOIA-LUSTPublic"" order by 1;"

*/
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 273 || ', ''' || ""(""Confirmed Release"",""Cleanup Initiated"", ""Closed Date"")"" || ''', '''', null);
--Due to the data need confirmed from state, ignore this step


--======Check=================================

select * from v_release_needed_mapping where release_control_id = 7;
select * from release_element_mapping where release_control_id=7;

select * 
from v_release_element_mapping a
JOIN release_element_mapping b ON a.release_control_id = b.release_control_id AND a.epa_table_name::text = b.epa_table_name::text AND a.epa_column_name::text = b.epa_column_name::text
where  a.release_control_id = 7;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--check if there is any more mapping to do
select distinct epa_table_name, epa_column_name
from v_release_needed_mapping 
where release_control_id = 7 and mapping_complete = 'N'
order by 1, 2;

--check if any of the mapping is bad:
select database_lookup_table, epa_value 
from v_release_bad_mapping 
where release_control_id = 7 order by 1, 2;
--!!!if there are results from this query, fix them!!!

--if not, it's time to write the queries that manipulate the state's data into EPA's tables 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/*Step 1: create crosswalk views for columns that use a lookup table
run script org_mapping_xwalks.py to create crosswalk views for all lookup tables 
see new views:*/
select table_name 
from information_schema.tables 
where table_schema = 'wv_release' and table_type = 'VIEW'
and table_name like '%_xwalk' order by 1;


--Step 2: see the EPA tables we need to populate, and in what order
select distinct epa_table_name
from v_release_table_population 
where release_control_id = 7;
/*
ust_release
ust_release_cause
ust_release_corrective_action_strategy
ust_release_source
ust_release_substance
*/

/*Step 3: check if there where any dataset-level comments you need to incorporate:
    ignore rows where "Suspected Release"<>'No'
*/
select * from v_release_table_population;

/*Step 4: work through the tables in order, using the information you collected 
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
where release_control_id = 7 and epa_table_name = 'ust_release'
order by column_sort_order;

/*Step 5: use the information from the queries above to create the view:
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

--=====create view==========================================================
--------------------------------------------------------------
/*
For view there are parts that need take care:
 1. Release_id is a combined field of facility_id and leak_id
 2. Group the release_status based on data in three column (Confirmed Release, Cleanup Initiated, Closed Date)
 3. Media impacted soil, groundwater and surface water data
*/
CREATE OR REPLACE VIEW wv_release.v_ust_release
 AS
 SELECT DISTINCT (((x."Facility_ID" || '-'::text) || x."Leak_ID"))::character varying(100) AS release_id,
x."Facility_ID"::character varying(100) AS facility_id,
x."Current Facility Name"::character varying(200) AS site_name,
x."Address"::character varying(100) AS site_address,
x."City"::character varying(100) AS site_city,
x."Zip"::character varying(10) AS zipcode,
x."County"::character varying(100) AS county,
'WV' as state, 
 3 as epa_region, 
 (case when "Closed Date" is not null  then (select release_status_id from release_statuses where release_status= 'No further action')
when "Cleanup Initiated" is not null  then (select release_status_id from release_statuses where release_status= 'Active: corrective action')
when "Confirmed Release" is not null  then (select release_status_id from release_statuses where release_status= 'Active: general') 
end ) AS release_status_id,
x."Closed Date" ::date AS nfa_date,
'Yes'  AS media_impacted_soil,
null  AS media_impacted_groundwater,
null AS media_impacted_surface_water
   FROM wv_release."WVDEP.USTLUSTReports_FOIA-LUSTPublic" x
  where "Suspected Release"='No'
  and  x."Priority"='3-Soil contamination' 
 union 
  SELECT DISTINCT (((x."Facility_ID" || '-'::text) || x."Leak_ID"))::character varying(100) AS release_id,
x."Facility_ID"::character varying(100) AS facility_id,
x."Current Facility Name"::character varying(200) AS site_name,
x."Address"::character varying(100) AS site_address,
x."City"::character varying(100) AS site_city,
x."Zip"::character varying(10) AS zipcode,
x."County"::character varying(100) AS county,
'WV' as state, 
 3 as epa_region, 
 (case when "Closed Date" is not null  then (select release_status_id from release_statuses where release_status= 'No further action')
when "Cleanup Initiated" is not null  then (select release_status_id from release_statuses where release_status= 'Active: corrective action')
when "Confirmed Release" is not null  then (select release_status_id from release_statuses where release_status= 'Active: general') 
end ) AS release_status_id,
x."Closed Date" ::date AS nfa_date,
null  AS media_impacted_soil,
'Yes'  AS media_impacted_groundwater,
null AS media_impacted_surface_water
   FROM wv_release."WVDEP.USTLUSTReports_FOIA-LUSTPublic" x
  where "Suspected Release"='No'
  and  x."Priority"='2-Groundwater contamination'
union
  SELECT DISTINCT (((x."Facility_ID" || '-'::text) || x."Leak_ID"))::character varying(100) AS release_id,
x."Facility_ID"::character varying(100) AS facility_id,
x."Current Facility Name"::character varying(200) AS site_name,
x."Address"::character varying(100) AS site_address,
x."City"::character varying(100) AS site_city,
x."Zip"::character varying(10) AS zipcode,
x."County"::character varying(100) AS county,
'WV' as state, 
 3 as epa_region, 
(case when "Closed Date" is not null  then (select release_status_id from release_statuses where release_status= 'No further action')
when "Cleanup Initiated" is not null  then (select release_status_id from release_statuses where release_status= 'Active: corrective action')
when "Confirmed Release" is not null  then (select release_status_id from release_statuses where release_status= 'Active: general') 
end ) AS release_status_id,
x."Closed Date" ::date AS nfa_date,
null  AS media_impacted_soil,
null  AS media_impacted_groundwater,
'Yes'  AS media_impacted_surface_water
   FROM wv_release."WVDEP.USTLUSTReports_FOIA-LUSTPublic" x
  where "Suspected Release"='No'
  and  x."Priority"='1-product, vapor, or sig GW contamination'
union
SELECT DISTINCT (((x."Facility_ID" || '-'::text) || x."Leak_ID"))::character varying(100) AS release_id,
x."Facility_ID"::character varying(100) AS facility_id,
x."Current Facility Name"::character varying(200) AS site_name,
x."Address"::character varying(100) AS site_address,
x."City"::character varying(100) AS site_city,
x."Zip"::character varying(10) AS zipcode,
x."County"::character varying(100) AS county,
'WV' as state, 
 3 as epa_region, 
(case when "Closed Date" is not null  then (select release_status_id from release_statuses where release_status= 'No further action')
when "Cleanup Initiated" is not null  then (select release_status_id from release_statuses where release_status= 'Active: corrective action')
when "Confirmed Release" is not null  then (select release_status_id from release_statuses where release_status= 'Active: general') 
end ) AS release_status_id,
x."Closed Date" ::date AS nfa_date,
null  AS media_impacted_soil,
null  AS media_impacted_groundwater,
null  AS media_impacted_surface_water
   FROM wv_release."WVDEP.USTLUSTReports_FOIA-LUSTPublic" x
  where "Suspected Release"='No'
  and  x."Priority" is null;

--review: 
select * from wv_release.v_ust_release;
select count(*) from wv_release.v_ust_release;
--3930

select count(*) from wv_release.ust_release

--------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
--QA/QC

--check that you didn't miss any columns when creating the data population views:
--if any rows are returned by this query, fix the appropriate view by adding the missing columns!
select epa_table_name, epa_column_name, 
	organization_table_name, organization_column_name, 
	organization_join_table, organization_join_column, 
	deagg_table_name, deagg_column_name	
from v_release_missing_view_mapping a
where release_control_id = 7
order by 1, 2;


select b.column_name, b.data_type, b.character_maximum_length, a.data_type, a.character_maximum_length 
from information_schema.columns a join information_schema.columns b on a.column_name = b.column_name 
where a.table_schema = 'az_release' and a.table_name = 'v_ust_release'
and b.table_schema = 'public' and b.table_name = 'ust_release'
and (a.data_type <> b.data_type or b.character_maximum_length > a.character_maximum_length )
order by b.ordinal_position;

--------------------------------------------------------------------------------------------------------
--------Final steps-------------------------------------------
--run Python QA/QC script

/*run script qa_check.py
set variables:
ust_or_release = 'release' 
control_id = 6
export_file_path = None # If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_dir = None	# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_name = None	# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo

This script will check the views you just created in the state schema for the following:
1) Missing views - will check that if you created a child view (for example, v_ust_compartment), that the parent view(s) (for example, v_ust_tank)
   exist. 
2) Counts of child tables that have too few rows (for example, v_ust_compartment should have at least as many rows as v_ust_tank because
   every tank should have at least one compartment). 
3) Missing join columns to parent tables. For example, v_ust_compartment must contain facility_id and tank_id in order to be able to join it
   to its parent tables. 
4) Missing required columns. 
5) Required columns that exist but contain null values. 
6) Extraneous columns - will check for any columns in the views that don't match a column in the equivalent EPA table. This will help identify
   typos or other errors. 
7) Non-unique rows. To resolve any cases where the counts are greater than 0, check that you did a "select distinct" when creating these views.
   Then check for bad joins.  
8) Bad data types - will check for columns in the view where either the data type is different than the EPA column, or (for character columns) 
   if the length of the state value is too long to fit into the EPA column. If the data is too long to fit in the EPA column, this may indicate 
   an error in your code or mapping, OR it may mean you need to truncate the state's value to fit the EPA format. 
9) Failed check constraints. 
10) Bad mapping values. To resolve any cases where bad mapping values exist, examine the specific row(s) in public.ust_element_value_mapping 
   and ensure the epa_value exists in the associated lookup table. 

The script will also provide the counts of rows in wv_ust.v_ust_release, wv_ust.v_ust_release_substance, wv_ust.v_ust_release_source, 
   wv_ust.v_ust_release_cause, and wv_ust.v_ust_release_corrective_action_strategy (if these views exist) - ensure these counts make sense! 
   
The script will export a QAQC spreadsheet (in additional to printing to the screen and logs). If there are errors, re-write the views above, 
then re-run the qa script, and proceed when all errors have been resolved. */

--------------------------------------------------------------------------------------------------------------------------
--insert data into the EPA schema 

/*run script populate_epa_data_tables.py	
set variables:
ust_or_release = 'release' 
control_id = 7
delete_existing = False # can set to True if there is existing release data you need to delete before inserting new
*/

--------------------------------------------------------------------------------------------------------------------------
--Quick sanity check of number of rows inserted:
select table_name, num_rows from v_release_table_row_count
where release_control_id = 7 order by sort_order;
 
--=ust_release	3930

--------------------------------------------------------------------------------------------------------------------------
--export template

/*run script export_template.py
set variables:
control_id = 7
ust_or_release = 'release' 
organization_id = None  	# Can leave as None if you specify the control_id
data_only = False 		# Set to False to export full template including mapping and reference tabs
template_only = False 	# Set to False to export data and mapping tabs as well as reference tab
export_file_path = None # If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_dir = None	# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_name = None	# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo*/


--------------------------------------------------------------------------------------------------------------------------
 