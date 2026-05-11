--todo: working through ut_release.get_release_status and release status mapping table

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Update the control table 
/*
insert into release_control (organization_id,date_received,date_processed,data_source,comments)
values ('UT',current_date,current_date,'Search by county here https://apps.sd.gov/NR42InteractiveMap# and download each counties by using the "download results button" and pull the facility data out of the https://arcgis.sd.gov/arcgis/rest/services/DENR/NR42_SpillReports_Public/MapServer/0 layer using ArcGIS Pro.  ','');
*/

--the script above returned a new release_control_id of 11 for this dataset:
select * from public.release_control where release_control_id = 11;


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Upload the state data 
/* 
EITHER:
script import_data_file_files.py will create the correct schema (if it doesn't yet exist), 
then upload all .xlsx, .xls, .csv, and .txt in the specified directory to this schema. 
To run, set these variables:

organization_id = 'UT' 
# Enter a directory (not a path to a specific file) for ust_path and ust_path
# Set to None if not applicable
release_path = 'C:\Users\JChilton\repo\UST\ust\sql\states\SD\release' 
overwrite_table = False 

OR:
manually in the database, create schema ut_ust if it does not exist, then manually upload the state data
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------


alter table "DEQMAP_LUST_-2227783677392327028" rename to ut_lust;

select * from fac where "TANK" = 1
select count( "DERRID") from ut_lust;


select distinct "NFAFORM" from ut_lust order by 1;

select release_comment from public.ust_release;


delete from ut_lust where "FEDREG" = 'No';



--derive release status from multiple fields in the get_release_status funtion
drop table erg_release_status;

create table erg_release_status as
select "LUSTKEY", get_release_status("LUSTKEY") release_status
from ut_lust;



select  * from erg_release_status where release_status is null;
;
select * from release_element_mapping where release_element_mapping_id = 287;

select count(*) from ut_lust_1115;
5631
5643


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


insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (11,'ust_release','facility_id','ut_lust','FACILITYID',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (11,'ust_release','release_id','ut_lust','LUSTKEY',null);

insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (11,'ust_release','site_name','fac','LOCNAME',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (11,'ust_release','site_address','fac','LOCSTR',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (11,'ust_release','site_city','fac','LOCCITY',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (11,'ust_release','zipcode','fac','LOCZIP',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (11,'ust_release','county','fac','LOCCOUNTY',null);


insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (11,'ust_release','facility_type_id','fac','FACILITYDE',null);

insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (11,'ust_release','latitude','fac','DDLat',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (11,'ust_release','longitude','fac','DDLon',null);

insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (11,'ust_release','release_status_id','erg_release_status','release_status','ERG created table erg_release_status to calculate release status from three columns: "CLOSURETYPE","DATECLOSE","NFAFORM". See deriviation logic in get_release_status function.' );


insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (11,'ust_release','reported_date','ut_lust','NOTIFICATI',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (11,'ust_release','nfa_date','ut_lust','DATECLOSE',null);

select * from ut_release.ut_lust;

insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (11,'ust_release','release_comment','DEPTHGW','ut_lust','Mapped 4 groundwater related fields to this: DEPTHGW - This is the general depth to groundwater at the release site.  GWFLOWDIR1 - This is the groundwater flow direction at the release site.  GWFLOWDIR2 - An additional groundwater flow direction if it fluctuates seasonally, we can capture that here. CAPH2OTREA - This is a volume of groundwater treated by corrective action, generally used for pump and treat technologies.');
------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/*
see what mapping hasn't yet been done for this dataset 
we'll be going through each of the results of this query below
so for each value of epa_column_name from this query result, there will be a 
section below where we generate SQL to perform the mapping 
*/
select distinct epa_table_name, epa_column_name
from v_release_needed_mapping 
where release_control_id = 11 and mapping_complete = 'N'
order by 1, 2;


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--facility_type_id

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from "' || organization_table_name || '" order by 1;'
from v_release_needed_mapping 
where release_control_id = 11 and epa_column_name = 'facility_type_id';


select insert_sql 
from v_release_needed_mapping_insert_sql 
where release_control_id = 11 and epa_column_name = 'facility_type_id';

--paste the insert_sql from the first row below, then run the query:
select distinct 
	'insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 322 || ', ''' || "FACILITYDE" || ''', '''', null);'
from ut_release."fac" order by 1;



insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (322, 'Air Taxi (Airline)', 'Aviation/airport (non-rental car)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (322, 'Aircraft Owner', 'Aviation/airport (non-rental car)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (322, 'Auto Dealership', 'Auto dealership/auto maintenance & repair', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (322, 'Commercial', 'Commercial', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (322, 'Contractor', 'Contractor', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (322, 'Farm', 'Agricultural/farm', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (322, 'Federal Military', 'Military', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (322, 'Federal Non-Military', 'Federal government, non-military', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (322, 'Former Gas Station', 'Retail fuel sales (non-marina)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (322, 'FORMER GAS STATION', 'Retail fuel sales (non-marina)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (322, 'Gas Station', 'Retail fuel sales (non-marina)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (322, 'Industrial', 'Industrial', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (322, 'Local Government', 'Other', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (322, 'Not Listed', 'Unknown', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (322, 'Other', 'Other', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (322, 'Petroleum Distributor', 'Bulk plant storage/petroleum distributor', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (322, 'Railroad', 'Railroad', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (322, 'Residential', 'Residential', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (322, 'State Government',  'Other', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (322, 'Truck/Transporter', 'Trucking/transport/fleet operation', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (322, 'Utilities', 'Utility', null);

select * from wv_release.erg_release_status;
;
select  * from public.facility_types;

update release_element_value_mapping 
set epa_value = 'State/local government', programmer_comments=null
where release_element_mapping_id = 322
and organization_value = 'State Government';

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--release_status_id

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from "' || organization_table_name || '" order by 1;'
from v_release_needed_mapping 
where release_control_id = 11 and epa_column_name = 'release_status_id';

select distinct "NFAFORM" from "ut_lust" order by 1;



select insert_sql 
from v_release_needed_mapping_insert_sql 
where release_control_id = 11 and epa_column_name = 'release_status_id';

select distinct 
	'insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 342 || ', ''' || "release_status" || ''', '''', null);'
from ut_release."erg_release_status" order by 1;

/*below I have mapped the ones I can take a reasonable guess at, but I've inserted nulls for the ones I have no idea about 
the state codes are pretty obtuse so I'm not very confident of my mapping on any of them; therefore I've added a "please verify" comment 
for the ones I took a stab at mapping, as well as "MAPPING NEEDED" for those I didn't. This way, when the mapping is exported to
the review template, EPA and the state have a visual indicator that we need their input for all of them. */

select *  from release_element_value_mapping where release_element_mapping_id= 342;

insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (342, 'Active: corrective action', 'Active: corrective action', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (342, 'No further action', 'No further action', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (342, 'Other', 'Other', null);


------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--check if there is any more mapping to do
select distinct epa_table_name, epa_column_name
from v_release_needed_mapping 
where release_control_id = 11 and mapping_complete = 'N'
order by 1, 2;

--check if any of the mapping is bad:
select database_lookup_table, epa_value 
from v_release_bad_mapping 
where release_control_id = 11 order by 1, 2;
--!!!if there are results from this query, fix them!!!

select * from public.release_control
--if not, it's time to write the queries that manipulate the state's data into EPA's tables 
Download csvs from https://opendata.gis.utah.gov/datasets/utah::utah-petroleum-storage-tanks/about, https://opendata.gis.utah.gov/datasets/utah::utah-deqmap-lust/about, and exported csv from https://services1.arcgis.com/99lidPhWCzftIe9K/ArcGIS/rest/services/FacilityPST/FeatureServer/0/.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/*Step 1: create crosswalk views for columns that use a lookup table
run script org_mapping_xwalks.py to create crosswalk views for all lookup tables 
see new views:*/
select table_name 
from information_schema.tables 
where table_schema = 'ut_release' and table_type = 'VIEW'
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
where release_control_id = 11
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
select comments from release_control where release_control_id = 11;
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
where release_control_id = 11 and epa_table_name = 'ust_release'
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


select * from public.ust_release where release_comment is not null;
select column_name from information_schema.columns
             where table_schema = 'public' and table_name = 'ust_release'
             order by ordinal_position
             
 select * from release_template_data_tables
 
 select column_name from information_schema.columns
             where table_schema = 'public' and table_name = 'v_ust_release'
             order by ordinal_position
 release_comment
             select * from ust_release;
create or replace view ut_release.v_ust_release as 
select distinct 
"FACILITYID"::character varying(50) as facility_id,
"LUSTKEY"::character varying(50) as release_id,
"LOCNAME"::character varying(200) as site_name,
"LOCSTR"::character varying(100) as site_address,
"LOCCITY"::character varying(100) as site_city,
"LOCZIP"::character varying(10) as zipcode,
"LOCCOUNTY"::character varying(100) as county,
facility_type_id as facility_type_id,
"DDLat"::double precision as latitude,
"DDLon"::double precision as longitude,
release_status_id as release_status_id,
"NOTIFICATI"::date as reported_date,
"DATECLOSE"::date as nfa_date,
8 as epa_region, 
'UT' as state,
"DEPTHGW" || ' - is the general depth to groundwater at the release site. '||"GWFLOWDIR1"|| ' - is the groundwater flow direction at the release site.   '||"GWFLOWDIR2" ||' - An additional groundwater flow direction if it fluctuates seasonally.  '||"CAPH2OTREA"|| ' - is a volume of groundwater treated by corrective action, generally used for pump and treat technologies.' as release_comment
from ut_lust y 
join fac x on x."FacilityID"  = y."FACILITYID"
left join ut_release.v_release_status_xwalk	rs on y."NFAFORM" = rs.organization_value 
left join ut_release.v_facility_type_xwalk	ft on x."FACILITYDE" = ft.organization_value 
where  x."RELEASE" > 0;

select distinct "NFAFORM"  from ut_lust;

select * from ut_lust;
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (11,'ust_release','release_comment','DEPTHGW','ut_lust','Mapped 4 groundwater related fields to this: DEPTHGW - This is the general depth to groundwater at the release site.  GWFLOWDIR1 - This is the groundwater flow direction at the release site.  GWFLOWDIR2 - An additional groundwater flow direction if it fluctuates seasonally, we can capture that here. CAPH2OTREA - This is a volume of groundwater treated by corrective action, generally used for pump and treat technologies.');


select * from  ut_release.v_ust_release;;


select count(*) from ut_release.v_ust_release;
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
where release_control_id = 11
order by 1, 2;

/*
select b.column_name, b.data_type, b.character_maximum_length, a.data_type, a.character_maximum_length 
from information_schema.columns a join information_schema.columns b on a.column_name = b.column_name 
where a.table_schema = 'ut_release' and a.table_name = 'v_ust_release'
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
where release_control_id = 11 order by sort_order;
ust_release	5493

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