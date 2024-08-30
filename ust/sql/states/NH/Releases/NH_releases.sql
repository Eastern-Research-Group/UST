------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Update the control table 
/*
EITHER:
use insert_control.py to insert into public.release_control
OR:
insert into release_control (organization_id, date_received, data_source, comments)
values ('PA', '2024-06-11', 'CSV downloaded from http://cedatareporting.pa.gov/Reportserver/Pages/ReportViewer.aspx?/Public/DEP/Cleanup/SSRS/Tank_Cleanup_Incidents', null)
returning release_control_id;
*/

--the script above returned a new release_control_id of 2 for this dataset:
select * from public.release_control where release_control_id = 9;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Upload the state data 
/* 
EITHER:
script import_data_file_files.py will create the correct schema (if it doesn't yet exist), 
then upload all .xlsx, .xls, .csv, and .txt in the specified directory to this schema. 
To run, set these variables:

organization_id = 'NH'
# Enter a directory (not a path to a specific file) for ust_path and release_path
# Set to None if not applicable
# ust_path = None # r'C:\Users\erguser\OneDrive - Eastern Research Group\Projects\UST\State Data\WV\UST'
release_path = 'C:\Users\renae\Documents\Work\repos\ERG\UST\ust\sql\states\PA\Releases' 
overwrite_table = False 

OR:
manually in the database, create schema nh_release if it does not exist, then manually upload the state data
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Get an overview of what the state's data looks like. In this case, we only have one table
select * from nh_release;
select * from nh_release_gis;


select * from nh_release where (site_number,project_rsn) in (
select  site_number,project_rsn from nh_release group by site_number,project_rsn having count(*) > 1);



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


insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_release','facility_id','nh_release','facility_id',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_release','release_id','nh_release','site_number',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_release','site_name','nh_release','site_name',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_release','site_address','nh_release','site_address',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_release','site_city','nh_release','site_city',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_release','facility_type_id','nh_release','facility_type',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_release','latitude','nh_release_gis','GIS_LAT',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_release','longitude','nh_release_gis','GIS_LON',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_release','release_status_id','nh_release','LUSTstatusOrProjMgrName',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (9,'ust_release','reported_date','nh_release','project_start_date',null);


------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--see what columns in which table we need to map
select epa_table_name, epa_column_name 
from 
	(select distinct epa_table_name, epa_column_name, table_sort_order, column_sort_order
	from v_release_needed_mapping 
	where release_control_id = 9 and mapping_complete = 'N'
	order by table_sort_order, column_sort_order) x;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--facility_type_id

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from "' || organization_table_name || '" order by 1;'
from v_release_needed_mapping 
where release_control_id = 9 and epa_column_name = 'facility_type_id';

/*
run the query from the generated sql above to see what the state's data looks like
you are checking to make sure their values line up with what we are looking for on the EPA side
(this should have been done during the element mapping above but you can review it now)
Next, see if the state values need to be deaggregated 
(that is, is there only one value per row in the state data? If not, we need to deaggregate them)
*/
select distinct "facility_type" from "nh_release" order by 1;


--in this case there is only one value per row so we can begin mapping 

/*
 * generate generic sql to insert value mapping rows into release_element_value_mapping, 
then modify the generated sql with the mapped EPA values 
NOTE: insert a NULL for epa_value if you don't have a good guess 
NOTE: if the organization_value is one that should exclude the facility/tank from UST Finder
      (e.g. a non-federally regulated substance), manually modify the generated sql to 
       include column exclude_from_query and set the value to 'Y'
*/
select insert_sql 
from v_release_needed_mapping_insert_sql 
where release_control_id = 9 and epa_column_name = 'facility_type_id';

--paste the insert_sql from the first row below, then run the query:
select distinct 
	'insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 310 || ', ''' || "facility_type" || ''', '''', null);'
from nh_release."nh_release" order by 1;


--list valid EPA values to paste into sql above 
select * from public.facility_types order by 2;
/*
Map interpolation
GPS
PLSS
Geocoded address
Other
Unknown
*/

insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (310, 'AIR', 'Aviation/airport (non-rental car)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (310, 'CAR', null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (310, 'CHU', null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (310, 'COL', null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (310, 'COM', 'Commercial', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (310, 'CON', 'Contractor', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (310, 'FED', null, 'MAPPING NEEDED');;
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (310, 'GAS', null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (310, 'HOS', 'Hospital (or other medical)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (310, 'IND', 'Industrial', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (310, 'LOC', null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (310, 'MAR', 'Marina', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (310, 'MIL', null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (310, 'OTH', 'Other', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (310, 'PET', null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (310, 'PRO', null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (310, 'RES', 'Residential', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (310, 'SCH', 'School', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (310, 'STA', null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (310, 'TRK', 'Trucking/transport/fleet operation', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (310, 'UTL', 'Utility', null);


--to assist with the mapping above, check the archived mapping table for old examples of mapping 
--NOTE! As we continue to map more states, we can check the current mapping table instead of the archive table!
select distinct state_value, epa_value
from archive.v_lust_element_mapping 
where lower(element_name) like lower('%facility_type%')
order by 1, 2;
/*
Estimated								Map interpolation
Geocode									Geocoded address
GPS_EPA									GPS
GPS_State								GPS
GPS_Tribe								GPS
Legacy Verified							Other
OnlineMapGoogle							Map interpolation
OnlineMapMS								Map interpolation
Site Assessment Report by MCE Environmental dated 2/12/2003	Other
Trimble, collected 5/3/2010				Other
Trimble, collected 5/4/2010				Other
Trimble, collected 5/5/2010				Other
*/



------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--release_status_id

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from "' || organization_table_name || '" order by 1;'
from v_release_needed_mapping 
where release_control_id = 9 and epa_column_name = 'release_status_id';

select insert_sql 
from v_release_needed_mapping_insert_sql 
where release_control_id = 9 and epa_column_name = 'release_status_id';

--paste the insert_sql from the first row below, then run the query:
select distinct 
	'insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 313 || ', ''' || "LUSTstatusOrProjMgrName" || ''', '''', null);'
from nh_release."nh_release" order by 1;

select * from public.release_statuses;


insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (313, 'BASTIEN', null, 'This site is open still and listed the manager name for the site.  Should we map it to Active: general?');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (313, 'BONIS', null, 'This site is open still and listed the manager name for the site.  Should we map it to Active: general?');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (313, 'BRODERICK',  null, 'This site is open still and listed the manager name for the site.  Should we map it to Active: general?');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (313, 'BROWN-CHERYL', null,  'This site is open still and listed the manager name for the site.  Should we map it to Active: general?');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (313, 'CLOSED', 'No further action', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (313, 'CLOSED-AUR', 'No further action', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (313, 'DREW', null, 'This site is open still and listed the manager name for the site.  Should we map it to Active: general?');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (313, 'FULTON', null, 'This site is open still and listed the manager name for the site.  Should we map it to Active: general?');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (313, 'JOHNSON', null, 'This site is open still and listed the manager name for the site.  Should we map it to Active: general?');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (313, 'MARTS-JENNIFER', null, 'This site is open still and listed the manager name for the site.  Should we map it to Active: general?');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (313, 'OAKES', null, 'This site is open still and listed the manager name for the site.  Should we map it to Active: general?');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (313, 'PADDLEFORD', null, 'This site is open still and listed the manager name for the site.  Should we map it to Active: general?');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (313, 'RIZZA', null, 'This site is open still and listed the manager name for the site.  Should we map it to Active: general?');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (313, 'SANDIN', null, 'This site is open still and listed the manager name for the site.  Should we map it to Active: general?');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (313, 'SLAYTON', null, 'This site is open still and listed the manager name for the site.  Should we map it to Active: general?');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (313, 'STARK', null, 'This site is open still and listed the manager name for the site.  Should we map it to Active: general?');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (313, 'STEWART', null, 'This site is open still and listed the manager name for the site.  Should we map it to Active: general?');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (313, 'STRONDAK', null, 'This site is open still and listed the manager name for the site.  Should we map it to Active: general?');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (313, 'UNASSIGNED', null, 'This site is open still and listed the manager name for the site.  Should we map it to Active: general?');


------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--check if there is any more mapping to do
select distinct epa_table_name, epa_column_name
from v_release_needed_mapping 
where release_control_id = 9 and mapping_complete = 'N'
order by 1, 2;

--check if any of the mapping is bad:
select database_lookup_table, epa_value 
from v_release_bad_mapping 
where release_control_id = 9 order by 1, 2;
--!!!if there are results from this query, fix them!!!

--if not, it's time to write the queries that manipulate the state's data into EPA's tables 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/*Step 1: create crosswalk views for columns that use a lookup table
run script org_mapping_xwalks.py to create crosswalk views for all lookup tables 
see new views:*/
select table_name 
from information_schema.tables 
where table_schema = 'nh_release' and table_type = 'VIEW'
and table_name like '%_xwalk' order by 1;
/*
v_cause_xwalk
v_coordinate_source_xwalk
v_how_release_detected_xwalk
v_release_status_xwalk
v_source_xwalk
v_substance_xwalk
*/


--Step 2: see the EPA tables we need to populate, and in what order
select distinct epa_table_name, table_sort_order
from v_release_table_population 
where release_control_id = 9
order by table_sort_order;
/*
ust_release
ust_release_substance
ust_release_source
ust_release_cause
*/

/*Step 3: check if there where any dataset-level comments you need to incorporate:
in this case we need to ignore the aboveground storage tanks,
so add this to the where clause of the ust_release view */
select comments from release_control where release_control_id = 9;
--ignore rows where "INCIDENT_TYPE" = 'AST'

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
where release_control_id = 9 and epa_table_name = 'ust_release'
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


--remove 2 duplicates
select * from  nh_release.nh_release_gis
where ( "SITE_NUMBER", "PROJECT_HEADER_RSN") in (
select  "SITE_NUMBER", "PROJECT_HEADER_RSN" from nh_release.nh_release_gis
group by "SITE_NUMBER", "PROJECT_HEADER_RSN"  having count(*) > 1);

delete from nh_release.nh_release_gis where gis_rsn in ('54344','48428');



create or replace view nh_release.v_ust_release as 
select distinct 
"facility_id"::character varying(50) as facility_id,
"site_number"::character varying(50) as release_id,
"site_name"::character varying(200) as site_name,
"site_address"::character varying(100) as site_address,
"site_city"::character varying(100) as site_city,
facility_type_id as facility_type_id,
"GIS_LAT"::double precision as latitude,
"GIS_LON"::double precision as longitude,
case release_status_id when 6 then release_status_id else 1 end  as release_status_id,
"project_start_date"::date as reported_date,
'NH'as state, 
1 as epa_region
from "nh_release" x 
	left join nh_release."nh_release_gis" cs on x.site_number = cs."SITE_NUMBER"  and x.project_rsn = cs."PROJECT_HEADER_RSN" 
	left join nh_release.v_release_status_xwalk	rs on x."LUSTstatusOrProjMgrName" = rs.organization_value 
	left join nh_release.v_facility_type_xwalk rd on x."facility_type" = rd.organization_value ;


select  count(*) from nh_release.v_ust_release;
--2554

--------------------------------------------------------------------------------------------------------------------------
--QA/QC

--check that you didn't miss any columns when creating the data population views:
--if any rows are returned by this query, fix the appropriate view by adding the missing columns!
select epa_table_name, epa_column_name, 
	organization_table_name, organization_column_name, 
	organization_join_table, organization_join_column, 
	deagg_table_name, deagg_column_name
from v_release_missing_view_mapping a
where release_control_id = 9
order by 1, 2;

/*
select b.column_name, b.data_type, b.character_maximum_length, a.data_type, a.character_maximum_length 
from information_schema.columns a join information_schema.columns b on a.column_name = b.column_name 
where a.table_schema = 'nh_release' and a.table_name = 'v_ust_release'
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
where release_control_id = 9 order by sort_order;

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