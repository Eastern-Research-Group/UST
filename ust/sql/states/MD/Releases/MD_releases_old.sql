------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Update the control table 
/*
EITHER:
use insert_control.py to insert into public.release_control
*/

--the script above returned a new release_control_id of 8 for this dataset:
select * from public.release_control where release_control_id = 8;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Upload the state data 
/* 
EITHER:
script import_data_file_files.py will create the correct schema (if it doesn't yet exist), 
then upload all .xlsx, .xls, .csv, and .txt in the specified directory to this schema. 
To run, set these variables:

organization_id = 'PA' 
# Enter a directory (not a path to a specific file) for ust_path and release_path
# Set to None if not applicable
# ust_path = None # r'C:\Users\JChilton\OneDrive - Eastern Research Group\Desktop\UST\MD\Release\CASES 04-03-24\CASES 04-03-24'
release_path = 'C:\Users\JChilton\OneDrive - Eastern Research Group\Desktop\UST\MD\Release\CASES 04-03-24\CASES 04-03-24' 
overwrite_table = False 

OR:
manually in the database, create schema md_release if it does not exist, then manually upload the state data
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--cleanup tables for creating combined table
ALTER TABLE "All_Cases_Request__1" ALTER COLUMN "ZIP" TYPE text ;
ALTER TABLE "All_Cases_Request__5" ALTER COLUMN "ZIP" TYPE text ;
ALTER TABLE "All_Cases_Request_13" DROP COLUMN "MIA";

create table md_release_combined as
select * from "All_Cases_Request_10"
union
select * from "All_Cases_Request_11"
union
select * from "All_Cases_Request_12"
union
select * from "All_Cases_Request_13"
union
select * from "All_Cases_Request_14"
union
select * from "All_Cases_Request__1"
union
select * from "All_Cases_Request__2"
union
select * from "All_Cases_Request__3"
union
select * from "All_Cases_Request__4"
union
select * from "All_Cases_Request__5"
union
select * from "All_Cases_Request__6"
union
select * from "All_Cases_Request__7"
union
select * from "All_Cases_Request__8"
union
select * from "All_Cases_Request__9";

select * from  md_release_combined where "RELEASE" = 'YES' and "CODE" like 'B%' and "REG_NUMBER" is  null and "STATUS" is null; 16941

create index mrc_idx on md_release_combined("CASE_NO");
create index mrc_idx2 on md_release_combined("REG_NUMBER");

analyze md_release_combined;

/*
After viewing the state's data, I observed it includes Aboveground Storage tanks, so I put a 
comment in the release_control table about it.  
When I write the views that populate the EPA template, I'll exclude these rows 
(rather than deleting them from the state's data )
*/
update release_control set comments = 'only return where "RELEASE" = YES and "CODE" like B%' where release_control_id = 8;

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
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (8,'ust_release','facility_id','md_release_combined','REG_NUMBER',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (8,'ust_release','release_id','md_release_combined','CASE_NO',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (8,'ust_release','site_name','md_release_combined','SPILL_LOC',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (8,'ust_release','site_address','md_release_combined','ADDRESS',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (8,'ust_release','site_city','md_release_combined','CITY',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (8,'ust_release','zipcode','md_release_combined','ZIP',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (8,'ust_release','release_status_id','md_release_combined','STATUS',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (8,'ust_release','reported_date','md_release_combined','DATE_OPEN',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (8,'ust_release','nfa_date','md_release_combined','DT_CLOSED',null);




------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--see what columns in which table we need to map
select epa_table_name, epa_column_name 
from 
	(select distinct epa_table_name, epa_column_name, table_sort_order, column_sort_order
	from v_release_needed_mapping 
	where release_control_id = 8 and mapping_complete = 'N'
	order by table_sort_order, column_sort_order) x;
/*
ust_release	release_status_id
*/


/*
see what mapping hasn't yet been done for this dataset 
we'll be going through each of the results of this query below
so for each value of epa_column_name from this query result, there will be a 
section below where we generate SQL to perform the mapping 
*/
select distinct epa_table_name, epa_column_name
from v_release_needed_mapping 
where release_control_id = 8 and mapping_complete = 'N'
order by 1, 2;
/*
ust_release	release_status_id
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--release_status_id

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from "' || organization_table_name || '" order by 1;'
from v_release_needed_mapping 
where release_control_id = 8 and epa_column_name = 'release_status_id';

/*
run the query from the generated sql above to see what the state's data looks like
you are checking to make sure their values line up with what we are looking for on the EPA side
(this should have been done during the element mapping above but you can review it now)
Next, see if the state values need to be deaggregated 
(that is, is there only one value per row in the state data? If not, we need to deaggregate them)
*/
select distinct "STATUS" from md_release_combined order by 1;
/*
NAD27
NAD83
UNK
WGS84
*/

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
where release_control_id = 8 and epa_column_name = 'release_status_id';

--paste the insert_sql from the first row below, then run the query:
select distinct 
	'insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 241 || ', ''' || "STATUS" || ''', '''', null);'
from md_release."md_release_combined" order by 1;
/*
paste the generated insert statements from the query above below, then manually update each one to fill in the missing epa_value
if necessary, replace the "null" with any questions or comments you have about the specific mapping 

insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (22, 'NAD27', '', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (22, 'NAD83', '', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (22, 'UNK', '', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (22, 'WGS84', '', null);
*/

insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (22, 'NAD27', 'Map interpolation', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (22, 'NAD83', 'Map interpolation', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (22, 'UNK', 'Unknown', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (22, 'WGS84', 'Map interpolation', null);

--list valid EPA values to paste into sql above 
select * from public.coordinate_sources order by 1;
/*
Map interpolation
GPS
PLSS
Geocoded address
Other
Unknown
*/

--to assist with the mapping above, check the archived mapping table for old examples of mapping 
--NOTE! As we continue to map more states, we can check the current mapping table instead of the archive table!
select distinct state_value, epa_value
from archive.v_lust_element_mapping 
where lower(element_name) like lower('%coord%')
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



/*!!! WARNING! Some of the lookups have changed for the new template format, so if you used the 
archive.v_ust_element_mapping and/or archive.v_lust_element_mapping views and copied values 
directly from them, you may have to update them:*/
select distinct epa_value
from release_element_value_mapping a join release_element_mapping b on a.release_element_mapping_id = b.release_element_mapping_id
where release_control_id = 8 and epa_column_name = 'coordinate_source_id'
and epa_value not in (select coordinate_source from coordinate_sources)
order by 1;
--no results are returned by this query, so we don't need to update anything
--(see substances section below for steps to take if there are rows returned by this query)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--how_release_detected_id

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from "' || organization_table_name || '" order by 1;'
from v_release_needed_mapping 
where release_control_id = 8 and epa_column_name = 'how_release_detected_id';

/*run the query from the generated sql above to see what the state's data looks like
you are checking to make sure their values line up with what we are looking for on the EPA side
(this should have been done during the element mapping above but you can review it now)
Next, see if the state values need to be deaggregated 
(that is, is there only one value per row in the state data? If not, we need to deaggregate them)*/
select distinct "RELEASE_DISCOVERED" from "Tank_Cleanup_Incidents" order by 1;
/*
3PTY
3PTY, CLOS
3PTY, CLOS, SAMPL
3PTY, CLOS, VISOD
3PTY, UPGRD
3PTY, VISOD
CLOS
CLOS, CONST
CLOS, CONST, SAMPL
....
*/

/*in this case we have comma-separated values in single rows, which means we need to deaggregate them in order to map them. 
Run deagg.py, setting the state table name and state column name 
the script will create a deagg table and return the name of the new table; in this case: erg_release_discovered_deagg
check the contents of the deagg table:*/
select * from erg_release_discovered_deagg order by 2;

--!! update release_element_mapping with the new deagg_table_name and deagg_column_name, generated by deagg.py
update release_element_mapping set deagg_table_name = 'erg_release_discovered_deagg', deagg_column_name = '"RELEASE_DISCOVERED"' 
where release_control_id = 8 and epa_column_name = 'how_release_detected_id';

/*generate generic sql to insert value mapping rows into release_element_value_mapping, 
then modify the generated sql with the mapped EPA values 
NOTE: insert a NULL for epa_value if you don't have a good guess 
NOTE: if the organization_value is one that should exclude the facility/tank from UST Finder
      (e.g. a non-federally regulated substance), manually modify the generated sql to 
       include column exclude_from_query and set the value to 'Y'*/
select insert_sql 
from v_release_needed_mapping_insert_sql 
where release_control_id = 8 and epa_column_name = 'how_release_detected_id';

select distinct 
	'insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 29 || ', ''' || "RELEASE_DISCOVERED" || ''', '''', null);'
from "erg_release_discovered_deagg" order by 1;

/*below I have mapped the ones I can take a reasonable guess at, but I've inserted nulls for the ones I have no idea about 
the state codes are pretty obtuse so I'm not very confident of my mapping on any of them; therefore I've added a "please verify" comment 
for the ones I took a stab at mapping, as well as "MAPPING NEEDED" for those I didn't. This way, when the mapping is exported to
the review template, EPA and the state have a visual indicator that we need their input for all of them. */
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (29, '3PTY', 'Third party (well water, vapor intrusion, etc.)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (29, 'CLOS', 'At tank removal', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (29, 'CONST', 'Other', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (29, 'DEPI', null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (29, 'GW', 'GW monitoring well', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (29, 'LD', null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (29, 'MWELL', null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (29, 'SAMPL', null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (29, 'SWELL', null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (29, 'TLI', null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (29, 'TTEST', 'Tank tightness testing', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (29, 'UNDTD', 'Unknown', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (29, 'UPGRD', null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (29, 'VISOD', 'Visual (overfill)', 'Please verify');

--these are the valid EPA values to map to the state values above 
select * from public.how_release_detected order by 2;
/*
At tank removal
GW monitoring well
Inspection
Interstial monitor
Other
Overfill alarm
Statistical Inventory Reconciliation (SIR)
Tank tightness testing
Third party (well water, vapor intrusion, etc.)
Unknown
Vapor monitoring
Visual (overfill)
*/


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--release_status_id

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from "' || organization_table_name || '" order by 1;'
from v_release_needed_mapping 
where release_control_id = 8 and epa_column_name = 'release_status_id';

/*run the query from the generated sql above to see what the state's data looks like
you are checking to make sure their values line up with what we are looking for on the EPA side
(this should have been done during the element mapping above but you can review it now)
Next, see if the state values need to be deaggregated 
(that is, is there only one value per row in the state data? If not, we need to deaggregate them)*/
select distinct "STATUS_DESCRIPTION" from "Tank_Cleanup_Incidents" order by 1;
/*
Administrative Close Out (ACO)
Attainment Monitoring in Progress
Cleanup Completed
Inactive
Interim or Remedial Actions Initiated
Interim Remedial Actions Not Initiated
Suspected Release - Invest. Complete, No Release Confirmed
Suspected Release - Investigation Pending or Initiated
Unverified Incident*/



/*generate generic sql to insert value mapping rows into release_element_value_mapping, 
then modify the generated sql with the mapped EPA values 
NOTE: insert a NULL for epa_value if you don't have a good guess 
NOTE: if the organization_value is one that should exclude the facility/tank from UST Finder
      (e.g. a non-federally regulated substance), manually modify the generated sql to 
       include column exclude_from_query and set the value to 'Y'*/
select insert_sql 
from v_release_needed_mapping_insert_sql 
where release_control_id = 8 and epa_column_name = 'release_status_id';
select distinct 
	'insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 241 || ', ''' || "STATUS" || ''', '''', null);'
from md_release."md_release_combined" order by 1;

--see what the EPA values we need to map to are
select * from release_statuses order by 2;

--search for EPA values:
select state_value, epa_value
	from archive.v_lust_element_mapping 
	where lower(element_name) like '%status%' 
and lower(state_value) like lower('%cancel%');

insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (241, 'cancelled', 'No further action', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (241, 'CANCELLED', 'No further action','Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (241, 'CLOSED', 'No further action', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (241, 'OPEN', 'Active: general', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (241, 'SEE NOTE', 'Unknown', 'Please verify');


--check if there is any more mapping to do
select distinct epa_table_name, epa_column_name
from v_release_needed_mapping 
where release_control_id = 8 and mapping_complete = 'N'
order by 1, 2;

--check if any of the mapping is bad:
select database_lookup_table, epa_value 
from v_release_bad_mapping 
where release_control_id = 8 order by 1, 2;
--!!!if there are results from this query, fix them!!!

--if not, it's time to write the queries that manipulate the state's data into EPA's tables 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/*Step 1: create crosswalk views for columns that use a lookup table
run script org_mapping_xwalks.py to create crosswalk views for all lookup tables 
see new views:*/
select table_name 
from information_schema.tables 
where table_schema = 'md_release' and table_type = 'VIEW'
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
where release_control_id = 8
order by table_sort_order;
/*
v_release_status_xwalk
*/

/*Step 3: check if there where any dataset-level comments you need to incorporate:
in this case we need to ignore the aboveground storage tanks,
so add this to the where clause of the ust_release view */
select comments from release_control where release_control_id = 8;
--only return where "RELEASE" = YES and "CODE" like B%


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
where release_control_id = 8 and epa_table_name = 'ust_release'
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
create or replace view md_release.v_ust_release as 
select distinct 
"REG_NUMBER"::character varying(50) as facility_id,
"CASE_NO"::character varying(50) as release_id,
"SPILL_LOC"::character varying(200) as site_name,
"ADDRESS"::character varying(100) as site_address,
"CITY"::character varying(100) as site_city,
"ZIP"::character varying(10) as zipcode,
release_status_id as release_status_id,
"DATE_OPEN"::date as reported_date,
"DT_CLOSED"::date as nfa_date,
3 as epa_region, 
'MD' as state
from md_release.md_release_combined x 
left join md_release.v_release_status_xwalk	rs on x."STATUS" = rs.organization_value 
where "RELEASE" = 'YES' and "CODE" like 'B%';

--review: 
select * from md_release.v_ust_release;
select count(*) from md_release.v_ust_release;
--16941


--------------------------------------------------------------------------------------------------------------------------
--QA/QC

--check that you didn't miss any columns when creating the data population views:
--if any rows are returned by this query, fix the appropriate view by adding the missing columns!
select epa_table_name, epa_column_name, 
	organization_table_name, organization_column_name, 
	organization_join_table, organization_join_column, 
	deagg_table_name, deagg_column_name
from v_release_missing_view_mapping a
where release_control_id = 8
order by 1, 2;

/*
select b.column_name, b.data_type, b.character_maximum_length, a.data_type, a.character_maximum_length 
from information_schema.columns a join information_schema.columns b on a.column_name = b.column_name 
where a.table_schema = 'md_release' and a.table_name = 'v_ust_release'
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
where release_control_id = 8 order by sort_order;

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