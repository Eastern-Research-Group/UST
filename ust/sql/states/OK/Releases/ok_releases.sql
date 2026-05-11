--todo: working through ok_release.get_release_status and release status mapping table

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Update the control table 
/*
insert into release_control (organization_id,date_received,date_processed,data_source,comments)
values ('OK',current_date,current_date,'Search by county here https://apps.sd.gov/NR42InteractiveMap# and download each counties by using the "download results button" and pull the facility data out of the https://arcgis.sd.gov/arcgis/rest/services/DENR/NR42_SpillReports_Public/MapServer/0 layer using ArcGIS Pro.  ','');
*/

--the script above returned a new release_control_id of 11 for this dataset:
select * from public.release_control where release_control_id = 13;




------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Upload the state data 
/* 
EITHER:
script import_data_file_files.py will create the correct schema (if it doesn't yet exist), 
then upload all .xlsx, .xls, .csv, and .txt in the specified directory to this schema. 
To run, set these variables:

organization_id = 'OK' 
# Enter a directory (not a path to a specific file) for ust_path and ust_path
# Set to None if not applicable
release_path = 'C:\Users\JChilton\repo\UST\ust\sql\states\SD\release' 
overwrite_table = False 

OR:
manually in the database, create schema ok_ust if it does not exist, then manually upload the state data
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
select * from "OK_UST_Release_Cases";

alter table "OK_UST_Release_Cases" rename to ok_releases;

alter table ok_releases rename column "Case #" to case_number;

alter table ok_releases rename column "Facility #" to facility_number;



select count(distinct "Tank Type") from ok_releases; --6135

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Generate SQL statements to do the inserts into release_element_mapping. 
Run the query below, paste the results into your console, then do a global replace of XX for the release_control_id 
Next, go through each generated SQL statement and do the following:
If there is no matching column in the state's data, delete the SQL statement 
If there is a matching column in the state's data, update the ORG_TAB_NAME and ORG_COL_NAME variables to match the state's data 
If you have questions or comments, replace the "null" with your comment. 
After you have updated all the SQL statements, run them to update the database. 
*/
select * from public.v_release_element_summary_sql;
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (13,'ust_release','facility_id','ok_releases','facility_number',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (13,'ust_release','release_id','ok_releases','case_number',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (13,'ust_release','site_name','ok_releases','Facility Name',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (13,'ust_release','site_address','ok_releases','Address',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (13,'ust_release','site_city','ok_releases','City',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (13,'ust_release','zipcode','ok_releases','Zip Code',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (13,'ust_release','latitude','ok_releases','Latitude',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (13,'ust_release','longitude','ok_releases','Longitude',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (13,'ust_release','release_status_id','ok_releases','Case Status',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (13,'ust_release','reported_date','ok_releases','Release Date','Please confirm.');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (13,'ust_release','nfa_date','ok_releases','Close Date','Please confirm.');

insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (13,'ust_release','release_comment','ok_releases','Case Type',null);


select * from release_element_mapping  where release_control_id= 13;

select * from ok_releases where "Case Status" = 'Deactivate';

update release_element_mapping set programmer_comments='Filtering out where case status = deactivated per EPA and the State.', epa_comments = '"Sue:  There are 98 counts of deactivated in the OK release file.  57 have a closed date.  Tom - should we exclude all because they are listed as deactivated or keep the ones listed as closed? Tom:  I agree that the deactivated sites should probably not be included in the database as they are likely suspected releases that were not confirmed, but this shouldbe confirmed w/ OK.',
organization_comments='Deactivated cases are those that should not have been activated as a suspicion or confirmed release. Sometimes a release can be traced to a different active case or it is determined that a release doesn’t fall under OCC jurisdiction. '

where release_control_id= 13 and epa_column_name = 'release_status_id';
------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/*
see what mapping hasn't yet been done for this dataset 
we'll be going through each of the results of this query below
so for each value of epa_column_name from this query result, there will be a 
section below where we generate SQL to perform the mapping 
*/
select distinct epa_table_name, epa_column_name
from v_release_needed_mapping 
where release_control_id = 13 and mapping_complete = 'N'
order by 1, 2;


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--release_status_id

select insert_sql 
from v_release_needed_mapping_insert_sql 
where release_control_id = 13 and epa_column_name = 'release_status_id';

--paste the insert_sql from the first row below, then run the query:
select distinct 
	'insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 363 || ', ''' || "Case Status" || ''', '''', null);'
from ok_release."ok_releases" order by 1;
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (363, 'Closed', 'No further action', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (363, 'Deactivate', 'No further action', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (363, 'Open', 'Active: general / open release', null);


delete from release_element_value_mapping where organization_value = 'Deactivate';

Deactivated cases are those that should not have been activated as a suspicion or confirmed release. Sometimes a release can be traced to a different active case or it is determined that a release doesn’t fall under OCC jurisdiction. 
select * from public.release_statuses rs 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/*Step 1: create crosswalk views for columns that use a lookup table
run script org_mapping_xwalks.py to create crosswalk views for all lookup tables 
see new views:*/
select table_name 
from information_schema.tables 
where table_schema = 'ok_release' and table_type = 'VIEW'
and table_name like '%_xwalk' order by 1;
/*
v_cause_xwalk
v_facility_type_xwalk
v_release_status_xwalk
v_substance_xwalk
*/


--Step 2: see the EPA tables we need to populate, and in what order
select distinct epa_table_name, table_sort_order
from v_release_table_population 
where release_control_id = 13
order by table_sort_order;
/*
ust_release
ust_release_cause
ust_release_corrective_action_strategy
ust_release_source
ust_release_substance
ust_release_substance
ust_release_cause
*/

/*Step 3: check if there where any dataset-level comments you need to incorporate:
in this case we need to ignore the aboveground storage tanks,
so add this to the where clause of the ust_release view */
select comments from release_control where release_control_id = 13;
--ignore rows where sor_type <> 'UST'

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
where release_control_id = 13 and epa_table_name = 'ust_release'
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



            
    
-- ok_release.v_ust_release source

CREATE OR REPLACE VIEW ok_release.v_ust_release
AS SELECT DISTINCT y.facility_number::character varying(50) AS facility_id,
    y.case_number::character varying(50) AS release_id,
    y."Facility Name"::character varying(200) AS site_name,
    y."Address"::character varying(100) AS site_address,
    y."City"::character varying(100) AS site_city,
    y."Zip Code"::character varying(10) AS zipcode,
    y."Latitude" AS latitude,
    y."Longitude" AS longitude,
    rs.release_status_id,
    y."Release Date"::date AS reported_date,
    y."Close Date"::date AS nfa_date,
    6 AS epa_region,
    'OK'::text AS state
   FROM ok_release.ok_releases y
      JOIN ok_release.v_release_status_xwalk rs ON y."Case Status" = rs.organization_value::text
and trim("Case Status") not in ('Deactivate');

select distinct trim("Case Status")
   FROM ok_release.ok_releases y where trim("Case Status") <>  'Deactivate';
   
select count(*) from  ok_release.v_ust_release;

select distinct "Case Status" from  ok_release.ok_releases;


select count(*) from ok_release.v_ust_release;
--5493

--------------------------------------------------------------------------------------------------------------------------
--QA/QC

--check that you didn't miss any columns when creating the data population views:
--if any rows are returned by this query, fix the appropriate view by adding the missing columns!
select epa_table_name, epa_column_name, 
	organization_table_name, organization_column_name, 
	organization_join_table, organization_join_column, 
	deagg_table_name, deagg_column_name
from v_release_missing_view_mapping a
where release_control_id = 13
order by 1, 2;

/*
select b.column_name, b.data_type, b.character_maximum_length, a.data_type, a.character_maximum_length 
from information_schema.columns a join information_schema.columns b on a.column_name = b.column_name 
where a.table_schema = 'ok_release' and a.table_name = 'v_ust_release'
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
control_id = 2
delete_existing = False # can set to True if there is existing release data you need to delete before inserting new
*/

--------------------------------------------------------------------------------------------------------------------------
--Quick sanity check of number of rows inserted:
select table_name, num_rows from v_release_table_row_count
where release_control_id = 13 order by sort_order;
ust_release	6037

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


--export control table  summary

/*run script control_table_summary.py
set variables:
control_id = 4
ust_or_release = 'release' 
organization_id = None  	# Can leave as None if you specify the control_id
export_file_path = None 	# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_dir = None		# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_name = None		# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo*/