------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Update the control table 

--use insert_control.py to insert into public.ust_control
--the script above returned a new ust_control_id of 14 for this dataset:
select * from public.ust_control where ust_control_id = 14;

-- Update the control table 

--use insert_control.py to insert into public.ust_control
--the script above returned a new ust_control_id of 14 for this dataset:
select * from public.ust_control where ust_control_id = 14;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Upload the state data 
/* 
EITHER:
script import_data_file_files.py will create the correct schema (if it doesn't yet exist), 
then upload all .xlsx, .xls, .csv, and .txt in the specified directory to this schema. 
To run, set these variables:

organization_id = 'AZ' 
# Enter a directory (not a path to a specific file) for ust_path and ust_path
# Set to None if not applicable
ust_path = 'C:\Users\renae\Documents\Work\repos\ERG\UST\ust\sql\states\AZ\Releases' 
overwrite_table = False 

OR:
manually in the database, create schema az_ust if it does not exist, then manually upload the state data
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Get an overview of what the state's data looks like. In this case, we have two tables 
select table_name from information_schema.tables 
where table_schema = 'az_ust' order by 1;
/*
2024.06.21.draft_AZ_UST_Compartment_data_v1
2024.06.21.draft_AZ_UST_Facility_data_v1
2024.06.21.draft_AZ_UST_Piping_data_v1
2024.06.21.draft_AZ_UST_Tank_data_v1
*/

/* These table names are hard to type, so let's rename them - remember that the only things we want 
   to alter in the state data are table and column names that will make it hard for us to write our SQL */
alter table az_ust."2024.06.21.draft_AZ_UST_Compartment_data_v1" rename to ust_compartment;
alter table az_ust."2024.06.21.draft_AZ_UST_Facility_data_v1" rename to ust_facility;
alter table az_ust."2024.06.21.draft_AZ_UST_Piping_data_v1" rename to ust_piping;
alter table az_ust."2024.06.21.draft_AZ_UST_Tank_data_v1" rename to ust_tank;
--now let's look at the data in each table to get an overview:
select * from az_ust.facility;
select * from az_ust.tank;
select * from az_ust.compartment;
select * from az_ust.piping;

alter table az_ust.compartment rename to ust_compartment;
alter table az_ust.facility rename to ust_facility;
alter table az_ust.piping rename to ust_piping;
alter table az_ust.tank rename to ust_tank;


--see what columns exist in the state's data 
select table_name, column_name, is_nullable, data_type, character_maximum_length 
from information_schema.columns 
where table_schema = 'az_ust' and table_name = 'facility' 
order by ordinal_position;


--it might be helpful to create some indexes on the state data 
--(you can also do this as you go along in the processing and find the need to do do)
create index facility_facid_idx on az_ust.facility("FacilityID");
create index tank_facid_idx on az_ust.tank("FacilityID");
create index tank_tankname_idx on az_ust.tank("TankName");
create index tank_fk_idx on az_ust.tank("FacilityID","TankName");
create index compartment_tank_idx on az_ust.compartment("TankName");
create index compartment_comp_id_idx on az_ust.compartment("CompartmentName");
create index compartment_fk_idx on az_ust.compartment("FacilityID","TankName","CompartmentName");
create index piping_facid_idx on az_ust.piping("FacilityID");
create index piping_tankid_idx on az_ust.piping("TankName");
create index piping_compid_idx on az_ust.piping("CompartmentName");
create index piping_fk_idx on az_ust.piping("FacilityID","TankName","CompartmentName");




select 'insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values ({self.control_id}, ''' ||
	c.table_name || ''',''' || b.database_column_name || ''',''' || a.table_name || ''',''' || a.column_name || ''',''Direct mapping to EPA template per state'');'
from information_schema.columns a join ust_elements b on a.column_name = b.element_name 
	join ust_elements_tables c on b.element_id = c.element_id 
where table_schema = 'az_ust' and not exists
	(select 1 from ust_element_mapping c 
	where c.ust_control_id = 14 and a.table_name = c.organization_table_name and a.column_name = c.organization_column_name)
order by a.table_name, a.ordinal_position

select 'insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values ({self.control_id}, ''' ||
	epa_table_name || ''',''' || epa_column_name || ''',''' || org_table_name || ''',''' || org_column_name || ''',''Direct mapping to EPA template per state'');'
from 
	(select distinct c.table_name as epa_table_name, b.database_column_name as epa_column_name, 
		a.table_name as org_table_name, a.column_name as org_column_name, a.ordinal_position
	from information_schema.columns a join ust_elements b on a.column_name = b.element_name 
		join ust_elements_tables c on b.element_id = c.element_id 
	where table_schema = 'az_ust') x 
where not exists
	(select 1 from ust_element_mapping d 
	where d.ust_control_id = 14 and x.org_table_name = d.organization_table_name and x.org_column_name = d.organization_column_name)
order by org_table_name, ordinal_position;

select * from ust_element_mapping where ust_control_id = 14
and organization_column_name like '%Substance%'

delete from ust_element_mapping where ust_control_id = 14
and organization_column_name like '%Substance%'

select * from substances;


select * from ust_elements where element_name like '%Substance%'

select c.*, b.*
from ust_elements b join ust_elements_tables c on b.element_id = c.element_id 
where element_name like '%Substance%'


select state_value, epa_value 
from archive.v_ust_element_mapping 
where element_name like '%Substance%'
and lower(state_value) like lower('%100%')
order by 1, 2;


select table_name, column_name 
from information_schema.columns a
where table_schema = 'az_ust' and not exists 	
	(select 1 from ust_element_mapping b 
	where ust_control_id = 14 
	and a.table_name = b.organization_table_name
	and a.column_name = b.organization_column_name)
	
	select * from ust_elements where element_name like 'Associa%'
	
	select * from ust_element_value_mapping 
	
alter table ust_element_value_mapping add constraint ust_element_value_mapping_unique unique (ust_element_mapping_id, organization_value, epa_value);
alter table release_element_value_mapping add constraint release_element_value_mapping_unique unique (release_element_mapping_id, organization_value, epa_value);

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Because AZ submitted templates in EPA format, run Python script process_populated_template.py 
--to insert rows into ust_element_mapping. 


/*
see what mapping hasn't yet been done for this dataset 
we'll be going through each of the results of this query below
so for each value of epa_column_name from this query result, there will be a 
section below where we generate SQL to perform the mapping 
*/

select organization_table_name, organization_column_name
from 
	(select distinct organization_table_name, organization_column_name, epa_table_name, epa_column_name, table_sort_order, column_sort_order
	from v_ust_needed_mapping 
	where ust_control_id = 14 and mapping_complete = 'N'
	order by table_sort_order, column_sort_order) x;

select distinct "FacilityCoordinateSource" from az_ust.ust_facility ;
select distinct "SpillBucketWallType" from az_ust.ust_compartment ;
select distinct "PipeTankTopSumpWallType" from az_ust.ust_piping ;
select distinct coordinate_source_id from az_ust.ust_facility ;
select distinct coordinate_source_id from az_ust.ust_facility ;
/*
ust_facility		owner_type_id
ust_facility		facility_type1
ust_tank			tank_status_id
ust_tank			tank_material_description_id
ust_tank_substance	substance_id
ust_compartment		compartment_status_id
*/


select 
from ust_element_mapping 
where ust_control_id = 14;



------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--owner_type_id

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from az_ust."' || organization_table_name || '" order by 1;'
from v_ust_needed_mapping 
where ust_control_id = 14 and epa_column_name = 'owner_type_id';

select organization_table_name, organization_column_name
from v_ust_needed_mapping 
where ust_control_id = 14 and epa_column_name = 'owner_type_id';

select epa_table_name, epa_column_name, ust_element_mapping_id, organization_table_name, organization_column_name, database_lookup_table, database_lookup_column 
from v_ust_needed_mapping 
where ust_control_id = 14 order by table_sort_order, column_sort_order;

/*
run the query from the generated sql above to see what the state's data looks like
you are checking to make sure their values line up with what we are looking for on the EPA side
(this should have been done during the element mapping above but you can review it now)
Next, see if the state values need to be deaggregated 
(that is, is there only one value per row in the state data? If not, we need to deaggregate them)
*/
select distinct "OwnerType" from az_ust."ust_facility" 
where "OwnerType" in (select owner_type from public.owner_types)
order by 1;
/*
City Government
Commercial
County Government
Federal Government
Private
School District
State Government
*/

select distinct a."FacilityType1", b.facility_type 
from az_ust."ust_facility" a left join public.facility_types b on a."FacilityType1"::text = b.facility_type 
where a."FacilityType1" is not null 
order by 1


select distinct "FacilityType1" from az_ust."ust_facility"
where "FacilityType1" is not null 
order by 1;

select distinct "FacilityType1"

select distinct "CompartmentSubstanceStored" from az_ust.ust_compartment order by 1;




------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*Step 1: create crosswalk views for columns that use a lookup table
run script org_mapping_xwalks.py to create crosswalk views for all lookup tables 
see new views:*/
select table_name 
from information_schema.tables 
where table_schema = 'az_ust' and table_type = 'VIEW'
and table_name like '%_xwalk' order by 1;
/*
v_compartment_status_xwalk
v_facility_type_xwalk
v_owner_type_xwalk
v_substance_xwalk
v_tank_material_description_xwalk
v_tank_status_xwalk
*/

--Step 2: see the EPA tables we need to populate, and in what order
select distinct epa_table_name, table_sort_order
from v_ust_table_population 
where ust_control_id = 14
order by table_sort_order;
/*
ust_facility	
ust_tank	
ust_tank_substance	
ust_compartment	
*/

/*Step 3: check if there where any dataset-level comments you need to incorporate:
in this case we need to ignore the aboveground storage tanks,
so add this to the where clause of the ust_release view */
select comments from ust_control where ust_control_id = 14;

/*Step 4: work through the tables in order, using the information you collected 
to write views that can be used to populate the data tables 
NOTE! The view queried below (v_ust_table_population_sql) contains columns that help
      construct the select sql for the insertion views, but will require manual 
      oversight and manipulation by you! 
      In particular, check out the organization_join_table and organization_join_column 
      are used!!*/
select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, data_type, character_maximum_length,
	programmer_comments, database_lookup_table, database_lookup_column,
	organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 14 and epa_table_name = 'ust_facility'
order by column_sort_order;

/*Step 5: use the information from the queries above to create the view:
!!! NOTE look at the programmer_comments column to adjust the view if necessary
!!! NOTE also sometimes you need to explicitly cast data types so they match the EPA data tables
!!! NOTE also you may get errors related to data conversion when trying to compile the view
    you are creating here. This is good because it alerts you the data you are trying to
    insert is not compatible with the EPA format. Fix these errors before proceeding! 
!!! NOTE: Remember to do "select distinct" if necessary
!!! NOTE: Some states do not include State or EPA Region in their database, but it is generally
    safe for you to insert these yourself, so add them! (facility_state is a required field! */
create or replace view az_ust.v_ust_facility as 
select distinct 
		"Facility Id"::character varying(50) as facility_id,
		"Facility Name"::character varying(100) as facility_name,
		owner_type_id as owner_type_id,
		facility_type_id as facility_type1,
		"Address"::character varying(100) as facility_address1,
		"City"::character varying(100) as facility_city,
		"County"::character varying(100) as facility_county,
		"Zip"::character varying(10) as facility_zip_code,
		'AZ' as facility_state,
		3 as facility_epa_region,
		"Owner Name"::character varying(100) as facility_owner_company_name
from az_ust.facility x 
	left join az_ust.v_owner_type_xwalk ot on x."Owner Type" = ot.organization_value 
	left join az_ust.v_facility_type_xwalk ft on x."Facility Type" = ft.organization_value;


--review: 
select * from az_ust.v_ust_facility;
select count(*) from az_ust.v_ust_facility;
--8834
--------------------------------------------------------------------------------------------------------------------------
--now repeat for each data table:

--ust_tank 
select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, data_type, character_maximum_length,
	programmer_comments, database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 14 and epa_table_name = 'ust_tank'
order by column_sort_order;

/*be sure to do select distinct if necessary!
NOTE: ADD facility_id::character varying(50)!!!!
NOTE: tank_id (integer) is a required field - if the state data does not contain an integer field
      that uniquely identifies the tank, you must generate one (see Compartments below for how to do this).
*/
create or replace view az_ust.v_ust_tank as 
select distinct 
	"Facility ID"::character varying(50) as facility_id, 
	"Tank Id"::int as tank_id,
	tank_status_id as tank_status_id,
	"Regulated"::character varying(7) as federally_regulated,
	"Closed"::date as tank_closure_date,
	"Installed"::date as tank_installation_date,
	case when "Compartments" = 1 then 'No' when "Compartments" > 1 then 'Yes' end as compartmentalized_ust,
	"Compartments"::integer as number_of_compartments,
	tank_material_description_id as tank_material_description_id
from az_ust.tanks x 
	left join az_ust.v_tank_status_xwalk ts on x."Tank Status" = ts.organization_value
	left join az_ust.v_tank_material_description_xwalk md on x."Material" = md.organization_value;

select * from az_ust.v_ust_tank;
select count(*) from az_ust.v_ust_tank;
--26302

--------------------------------------------------------------------------------------------------------------------------
--ust_tank_substance

select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, data_type, character_maximum_length,
	programmer_comments, database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 14 and epa_table_name = 'ust_tank_substance'
order by column_sort_order;
/*
"tanks"	
"Substance"	
substance_id as substance_id,	
integer			
substances	
substance	
erg_substance_deagg	
Substance
*/

/*be sure to do select distinct if necessary!
NOTE: ADD facility_id::character varying(50) and tank_id::int!!!!
*/
create or replace view az_ust.v_ust_tank_substance as 
select distinct 
	"Facility ID"::character varying(50) as facility_id, 
	"Tank Id"::int as tank_id,
	sx.substance_id as substance_id
from az_ust.erg_substance_datarows_deagg x 
	left join az_ust.v_substance_xwalk sx on x."Substance" = sx.organization_value
where x."Substance" is not null; 

select * from az_ust.v_ust_tank_substance;
select count(*) from az_ust.v_ust_tank_substance;
--26776

--------------------------------------------------------------------------------------------------------------------------
--ust_compartment
select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, data_type, character_maximum_length,
	programmer_comments, database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 14 and epa_table_name = 'ust_compartment'
order by column_sort_order;

/* be sure to do select distinct if necessary!
NOTE: ADD facility_id::character varying(50) and tank_id::int!!!!
NOTE: compartment_id (integer) is a required field - if the state data does not contain an integer field
      that uniquely identifies the compartment, you must generate one. 
      In this case, the state does not store compartment data, so we will generate the compartment ID
      Prefix any tables you create in the state schema that did not come from the source data with "erg_"! */
create table az_ust.erg_compartment (facility_id int, tank_id int, compartment_id int generated always as identity);
insert into az_ust.erg_compartment (facility_id, tank_id)
select distinct "Facility ID", "Tank Id" from az_ust.tanks;

create or replace view az_ust.v_ust_compartment as 
select distinct 
	"Facility ID"::character varying(50) as facility_id, 
	"Tank Id"::int as tank_id,
	c.compartment_id,
	cx."Tank Satus" as compartment_status_id, 
	"Capacity"::integer as compartment_capacity_gallons
from az_ust.tanks x 
	 join az_ust.erg_compartment c on x."Facility ID" = c.facility_id and x."Tank Id" = c.tank_id
	 left join az_ust.v_compartment_status_xwalk cx on x."Tank Status" = cx.organization_value;
	
select * from az_ust.v_ust_compartment order by 1, 2, 3;
select count(*) from az_ust.v_ust_compartment;
--26302

--------------------------------------------------------------------------------------------------------------------------
--ust_compartment_substance 

/*
If the state reports substances at the compartment level OR you can 
establish a one-to-one relationship between substance and compartment 
(for example, if the state considers all compartments to be unique 
tanks and only has one substance per tank), you must populate table 
ust_compartment_substance. 
In the case of AZ, they don't report at the compartment level and have
a one-to-many relationship between tanks and substances. 
*/
select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, programmer_comments, 
	database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 14 and epa_table_name = 'ust_compartment_substance'
order by column_sort_order;


--------------------------------------------------------------------------------------------------------------------------
--ust_piping
select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, programmer_comments, 
	database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 14 and epa_table_name = 'ust_piping'
order by column_sort_order;

--there is no pipping data for this state, so we will skip this view 
--if we had data, we would have to add facility_id, tank_id, AND compartment_id 

--------------------------------------------------------------------------------------------------------------------------

--QA/QC

--check that you didn't miss any columns when creating the data population views:
--if any rows are returned by this query, fix the appropriate view by adding the missing columns!
select epa_table_name, epa_column_name, 
	organization_table_name, organization_column_name, 
	organization_join_table, organization_join_column, 
	deagg_table_name, deagg_column_name
from v_ust_missing_view_mapping a
where ust_control_id = 14
order by 1, 2;

--run Python QA/QC script

/*run script qa_check.py
set variables:
ust_or_release = 'ust' 
control_id = 14
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

The script will also provide the counts of rows in az_ust.v_ust_facility, az_ust.v_ust_tank, az_ust.v_ust_compartment, and
   az_ust.v_ust_piping (if these views exist) - ensure these counts make sense! 
   
The script will export a QAQC spreadsheet (in additional to printing to the screen and logs). If there are errors, re-write the views above, 
then re-run the qa script, and proceed when all errors have been resolved. */

--------------------------------------------------------------------------------------------------------------------------
--insert data into the EPA schema 

/*run script populate_epa_data_tables.py	
set variables:
ust_or_release = 'ust' 
control_id = 14
delete_existing = False # can set to True if there is existing UST data you need to delete before inserting new
*/

--------------------------------------------------------------------------------------------------------------------------
--Quick sanity check of number of rows inserted:
select table_name, num_rows 
from v_ust_table_row_count
where ust_control_id = 14 
order by sort_order;
/*
ust_facility			8834
ust_tank				26226
ust_tank_substance		26771
ust_compartment			26226
*/


--------------------------------------------------------------------------------------------------------------------------
--export template

/*run script export_template.py
set variables:
control_id = 14
ust_or_release = 'ust' 
organization_id = None  	# Can leave as None if you specify the control_id
data_only = False 			# Set to False to export full template including mapping and reference tabs
template_only = False 		# Set to False to export data and mapping tabs as well as reference tab
export_file_path = None 	# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_dir = None		# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_name = None		# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo*/


--------------------------------------------------------------------------------------------------------------------------
--export control table  summary

/*run script control_table_summary.py
set variables:
control_id = 14
ust_or_release = 'ust' 
organization_id = None  	# Can leave as None if you specify the control_id
export_file_path = None 	# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_dir = None		# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_name = None		# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo*/

--------------------------------------------------------------------------------------------------------------------------