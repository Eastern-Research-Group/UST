select * from cui_exclusions 

insert into cui_exclusions (stopword) values (lower('AGRI-SERVICES')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('dentristy')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('BOTTOMS')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('PIPE')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('coating')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('CONTINENT')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('cessna')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('mid')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('COMANCHE')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('cattle')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('EUREKA')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('thrift-way')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('testing')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('SMOKE')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('HALLMARK CARDS')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('J.C. PENNEYS')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('PROJ')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('off')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('jump')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('start')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('jumpstart')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('savings')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('loan')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('ENTERPRIZE')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('fly')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('tyre')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('AUTO-CARE')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('HANDI-SERVE')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('things')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('swings')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('cardtrol')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('turn')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('winery')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('')) on conflict do nothing;
insert into cui_exclusions (stopword) values (lower('')) on conflict do nothing;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* NOTES:
 * All Python scripts below are found in the github repo at https://github.com/Eastern-Research-Group/UST,
 * in the /ust/python/state_processing directory. 
 * You can set run variables at the top of the script; usually this will just be:
 * control_id (integer primary key from public.ust_control)
 * ust_or_release (string with values 'ust' or 'release').
 * 
 * 1) Before beginning processing, first do a git pull on the main branch, then create and checkout a 
 *    branch the describes what you are processing, for example, KS-UST, where you will do your work. 
 * 2) Copy this template and do a global replace of KS for the organization_id. Save the script in the 
 *    repo at /ust/sql/states/KS/Releases/KS_releases.sql (create these folders if necessary)
 * 3) Follow the steps in the template; when prompted to run a Python script, change the variables
 *    at the top of the script before running it. Unless you need to make a bugfix to the Python script,
 *    don't include any Python scripts from the state_processing directory in your pull request later. 
 */
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* OVERVIEW:
 * Step 1: Upload the source data 
 * Step 2: Update the control table 
 * Step 3: Get an overview of the source data and prepare it for processing
 * Step 4: Map the source data elements to the EPA template elements 
 * Step 5: Check for lookup data that needs to be deaggregated 
 * Step 6: Map the source data values to EPA values 
 * Step 7: Send the substance mapping for review by an ERG chemical expert  
 * Step 8: Create the value mapping crosswalk views
 * Step 9: Create unique identifiers if they don't exist
 * Step 10: Write the views that convert the source data to the EPA format
 * Step 11: QA the views
 * Step 12: Insert data into the EPA schema 
 * Step 13: Export populated EPA template 
 * Step 14: Export control table summary
 * Step 15: Upload exported files to EPA Teams
 * Step 16: Request peer review and make any suggested changes
 * Step 17: Export source data (if necessary)
 * Step 18: Request OUST review
 * Step 19: Respond to OUST comments 
 * Step 20: State review 
 * Step 21: GIS processing (coming soon)
 * 
 */
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 1: Upload the source data 
/*
 * EITHER:
 * If the data was submitted in the form of an Excel spreadsheet or a CSV/text file,
 * you can run script import_data_file_files.py. To run, set these variables:

ust_or_release = 'release'      # Valid values are 'ust' or 'release'
organization_id = 'KS'          # Enter the two-character code for the state, or "TRUSTD" for the tribes database 
path = r''                      # Enter the full path to the directory containing the source data file(s) (NOT a path to a specific file)
overwrite_table = False         # Boolean, defaults to False; set to True if you are replacing existing data in the schema

 * Script import_data_file_files.py will create the correct schema (if it doesn't yet exist), 
 * then upload all .xlsx, .xls, .csv, and .txt in the specified directory to this schema. 
 *
 * OR:
 * If you don't want to use the script, or the data was submitted in a different way (API, database dump, etc.),
 * manually upload it to the database, creating schema KS_release if it does not exist.

 * NOTE:
 * If there is old data in the state schema, from a previous submission, you can either simply
 * drop the old tables, or you can rename each of them with a prefix of "OLD_". This makes it obvious
 * which is the current source data to other developers. 

 * Before uploading the new data, you can run this query and use the resulting SQL to do the renames:

select 'alter table ' || table_schema ||  '.' || table_name || ' rename to ' || 'OLD_' || table_name || ';'
from information_schema.tables 
where table_schema = lower('KS_release')
order by table_name;

 * Or to drop the old data:

select 'drop table ' || table_schema ||  '.' || table_name || ';'
from information_schema.tables 
where table_schema = lower('KS_release')
order by table_name;

 */
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 2: Update the control table 
/* 
 * Table public.release_control contains top-level information about the source data. 
 * This table will later be exported as part of the review materials sent to OUST. 
 * Use the comments column to describe any issues that affect the data set as a whole.
   For example, if the source data contains releases from aboveground tanks as well as
   underground tanks, make a comment that you are excluding ASTs. 
 * It's helpful to run a few queries against the source data before populating this table
   so you can provide good information in the comments column, however, you are also
   encouraged to go back and update this field later if you discover additional situations 
   that need to be documented as you process the data. 
 */

/*
 * To insert a new row into the control table: 
 *  
 * EITHER:
 * Run script insert_control.py
 * 
 * Set the following variables at the top of the script:
 
organization_id = 'KS'                  # Enter the two-character code for the state, or "TRUSTD" for the tribes database 
ust_or_release = 'release'              # Valid values are 'ust' or 'release'
data_source = ''                        # Describe in detail where data came from (e.g. URL downloaded from, Excel spreadsheets from state, state API URL, etc.)
date_received = 'YYYY-MM-DD'            # Defaults to datetime.today(). To use a date other than today, set as a string in the format of 'yyyy-mm-dd'.
date_processed = None                   # Defaults to datetime.today(). To use a date other than today, set as a string in the format of 'yyyy-mm-dd'.
comments = ''                           # Top-level comments on the dataset. An example would be "Exclude Aboveground Storage Tanks".
organization_compartment_flag = None    # For UST only set to 'Y' if state data includes compartments, 'N' if state data is tank-level only. You can set this later if you don't know.

 * OR:

insert into release_control (organization_id, date_received, data_processed, data_source, comments)
values ('KS', 'YYYY-MM-DD', current_date, '', '');
returning release_control_id;

 * Both of the above methods will return the new release_control_id, but if you need to
 * retrieve it, use the following query:

select max(release_control_id) from release_control where organization_id = 'KS;

 * Do a global replace in this script from 23 to the new release_control_id.
 */
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 3: Get an overview of the source data and prepare it for processing

/* Run this query to see what tables we have: 
*/
select table_name from information_schema.tables 
where table_schema = lower('KS_release') order by 1;

/*
 * If the table names came from Excel or CSV files and are hard to type and/or contain 
 * unfriendly characters, it's OK to re-name them.
 * You can use the following query to generate SQL to do so. 
  
select 'alter table ' || table_schema || '."' || table_name || '" rename to "NNNNNNNNNNN";'
from information_schema.tables 
where table_schema = lower('KS_release') and table_type = 'BASE TABLE'
order by 1;

alter table ks_release."EPA_KS_UST_Finder_v2_Data_UST_Reported_Releases_2020_to_Present" rename to "releases";
alter table ks_release."EPA_KS_UST_Finder_v2_Data_UST_Reported_Releases_Historical" rename to "historical_releases";


 * Check the column names out too:
 */
select table_name, column_name
from information_schema.columns
where table_schema = lower('KS_release') 
and table_name like '%releases'
order by table_name, ordinal_position;


/* 
 * If any columns have "bad" characters in them, you can use the following 
 * query to generate SQL to change them.
 * In general, try to keep the column names aligned with the source data as
 * much as possible as it will be easier for the states to understand the mapping. 
  
select 'alter table ' || table_schema || '."' || table_name || '" rename column "' || column_name || '" to "NNNNNNNNNNN";'
from information_schema.columns
where table_schema = lower('KS_release') and table_type = 'BASE TABLE'
order by 1;
  
 * NOTE: 
 * The ONLY changes we want to make to the source data is altering table and/or
 * column names to make it easier to query them. Any other manipulation that needs to be
 * done to the source data should be done by writing views or creating "erg_" prefixed tables.  
 */
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 4: Map the source data elements to the EPA template elements 

/* Table public.release_element_mapping documents the mapping of the source data elements
 * to the EPA template data elements. 
 * Go through each generated SQL statement and do the following:
 *  1) If there is no matching column in the state's data, delete the SQL statement from
 *     the script.
 *  2) If there is a matching column in the state's data, update the ORG_TAB_NAME
 *     and ORG_COL_NAME variables to match the state's data. 
 *  3) If you have questions or comments about the mapping, replace the first "null" with your 
 *     comment. 
 *  4) There should be only a one-to-one relationship between the EPA column and the
 *     source data column. If you need to use a combination of state columns to map
 *     to a single EPA column, create a crosswalk table (prefix the name of this table
 *     with "erg_" so it is obvious by glancing at the schema that we created it) that
 *     contains the primary key column(s) from the source data table (for example, 
 *     ReleaseID or ReleaseID and SubstanceReleased, etc.) and then a column that performs 
 *     whatever manipulation you need to do to the data to transform it into a single
 *     column. Enter the table name and column name from the table you created into 
 *     ORG_TAB_NAME and ORG_COLUMN_NAME and describe in detail in programmer_comments
 *     what you did. 
 *  5) Use the query_logic field to enter specifics about the mapping logic. Replace the
 *     second "null" with SQL or pseudocode that expresses the logic you will perform 
 *     on the source data column to map it to the EPA format. 
 * 
 *     FOR EXAMPLE, say the source data has a single column for Media Impacted,
 *     in table "releases" and column "media_impacted", with a list of possible values like
 *     ["soil", "gw"]. 
 *     Map EPA fields media_impacted_soil and media_impacted_groundwater
 *     EACH to state column "media_impacted", and set the query_logic field as follows:
 *     media_impacted_soil: "if media_impacted = 'soil' then 'Yes'"	   
 *     media_impacted_groundwater: "if media_impacted = 'gw' then 'Yes'"	   
 * 
 * After you've adjusted all the SQL statements for elements you are able to map and deleted those
 * you can't, run the SQL statements to perform the inserts.  
 * 
 * The SQL statements below were generated by running this query:
 
select * from public.v_release_element_summary_sql;

 * It might help you to have another tab open in your database console where you can run queries like the 
 * following to help you do the mapping. FOR EXAMPLE, say you are trying to map EPA field facility_type_id. 
 * This query may help you find it in the source data:

select table_name, column_name, data_type
from information_schema.columns 
where lower(table_schema) = 'KS_release' 
and lower(column_name) like '%fac%type%'
order by 1, 2;

 * DO NOT assume that just because a state column name is very similar to or exactly the same as
 * an EPA column that they are the same thing. Before mapping a state element, run some queries to 
 * make sure it actually contains the right data!

--query the EPA lookup table to see what we are looking for, for example:
select * from public.facility_types order by 1;

--then see what the state's data looks like:
select distinct "ORG_COL_NAME"
from KS_release."ORG_TAB_NAME"
order by 1;

 * If the states's values look approximately like EPA's values, it's OK to map. 

 * NOTE: 
 * The SQL statements below assume the state's data is in a relative flat format, e.g. there aren't
 * lookup tables. If the source data contains lookup tables, manipulate the SQL statements below to
 * include columns organization_join_table and organization_join_column. 
 * In this case, set the organization_table_name and organization_column_name to the source LOOKUP TABLE,
 * and set organization_join_table and organization_join_column to the source PARENT TABLE. 
 * There may be multiple columns included in the join; include all of them.
 * For examples of how to do this, run this query:
 * 
select release_control_id, epa_table_name, epa_column_name, 
	organization_table_name, organization_column_name,
	organization_join_table, 
	organization_join_column, organization_join_fk,
	organization_join_column2, organization_join_fk2,
	organization_join_column3, organization_join_fk3
from public.release_element_mapping
where organization_join_table is not null 
order by 1, 2, 3, 4, 5;

 * NOTE:
 * The SQL statements below also assume the state's data is stored with a single value per cell. 
 * Sometimes states stored multiple values in a single cell, separated by a comma or other separator (if you're lucky...)
 * When examining the state's data with this query:

select distinct "ORG_COL_NAME"
from KS_release."ORG_TAB_NAME"
order by 1;

 * If some rows appear to contain multiple values, you will have to DEAGGREGATE the data. This is most easily done
 * using a Python script written for that purpose and is discussed in the next step. In this step, set the 
 * organization_table_name and organization_column_name to the source data table and column containing the 
 * multiple values. When you get to the next step where you are mapping the values and you run deagg.py to
 * perform the deaggregation, the script will update the deagg_table_name and deagg_column_name columns of
 * public.release_element_mapping for you. The query below finds examples of how release_element_mapping eventually gets 
 * populated for these fields. 

select release_control_id, epa_table_name, epa_column_name, 
	organization_table_name, organization_column_name,
	deagg_table_name, deagg_column_name
from public.release_element_mapping
where deagg_table_name is not null 
order by 1, 2, 3, 4, 5;

 */

drop view ks_release.v_releases;
create or replace view ks_release.v_releases as 
select 
	"Number" as release_id,  
	"ALT_ID" as facility_id, 
	"Name" as site_name, 
	"Address Street" as site_address, 
	"Address Line 2" as site_address2,
	"Address City" as site_city,
	"Address State" as state, 
	"Address PostalCode"::text as zipcode, 
	"Latitude" as latitude,
	"Longitude" as longitude, 
	"Collection Method" as coordinate_source, 
	"County" as county, 
	"Master Status" as release_status, 
	"Leak and Additional Information - Suspected or Report Leak Date"::text as reported_date, 
	case when "Tank Excavation Area - Remaining soil condition" is not null then "Tank Excavation Area - Remaining soil condition"
		else "Tank Excavation Area - Remaining soil condition.1" end as media_impacted_soil, 
	case when "Groundwater contamination was confirmed on site ab " is not null 
	 then upper("Groundwater contamination was confirmed on site ab ")
	 else upper("Groundwater contamination was confirmed on site ab") end as media_impacted_groundwater,
	null::text as nfa_date
from ks_release.releases
union all 
select 
	"Number" as release_id,  
	"ALT_ID" as facility_id, 
	"Name" as site_name, 
	"Address Street" as site_address, 
	"Address Line 2" as site_address2,
	"Address City" as site_city,
	"Address State" as state, 
	"Address PostalCode"::text as zipcode, 
	"Latitude" as latitude,
	"Longitude" as longitude, 
	"Collection Method" as coordinate_source, 
	"County" as county, 
	"Master Status" as release_status, 
	"Inspection Details - Confirmed Release Date"::text as reported_date, 
	null as media_impacted_soil, 
	"Inspection Details - Describe extent of groundwater contaminati" as media_impacted_groundwater,
	"Storage Tank Details - Cleanup Completed Date"::text as nfa_date
from ks_release.historical_releases;	 
	
create or replace view ks_release.v_release_substance as
select * from (
select 
	"Number" as release_id,  
	"Leak and Additional Information - Material leaked" as substance, 
	case when "Leak and Additional Information - Quantity lost gallons" is not null 
	 then "Leak and Additional Information - Quantity lost gallons"::text
	 else "Leak and Additional Information - Quantity lost gallons.1"::text end as quantity_released, 
	'gallons' as unit
from ks_release.releases
union all 
select 
	"Number" as release_id,  
	case when "Inspection Details - Material Leaked OtherReason" is not null then "Inspection Details - Material Leaked OtherReason"
		else "Inspection Details - Material Leaked" end as substance, 
	null as quantity_released, 
	null as unit
from ks_release.historical_releases) a where substance is not null;


create or replace view ks_release.v_release_cause as
select 
	"Number" as release_id,  
	"Leak and Additional Information - Cause of leak" as cause	
from ks_release.releases
where "Leak and Additional Information - Cause of leak" is not null;

create or replace view ks_release.v_release_source as 
select * from (
select 
	"Number" as release_id,  
	case when "Leak and Additional Information - Leak type" is null then 'Other' 
		else "Leak and Additional Information - Leak type" end as source
from ks_release.releases 
union all 
select 
	"Number" as release_id,  
	case when "Inspection Details - Leak Type" is null then 'Other' 
		else "Inspection Details - Leak Type" end as source
from ks_release.historical_releases) a where source is not null;


select * from release_element_mapping 
where release_control_id = 23 and deagg_table_name is not null;

select * from ks_release.erg_substance_datarows_deagg;

select '"' || column_name || '"'
from information_schema.columns 
where table_schema = 'ks_release' and table_name = 'releases'
and lower(column_name) like '%disc%'
order by ordinal_position;

select * from sources;

select * from ks_release.releases;	

select "Program", count(*) 
from ks_release.releases
group by "Program";	
  

select * from release_control where organization_id = 'KS'

--ust_release: This table is REQUIRED
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (23,'ust_release','facility_id','v_releases','facility_id',null,null);
--NOTE: release_id is a required field. If Release ID does not exist in the source data, STOP and talk to the state. 
--(Note: it is OK to combine multiple fields to create a unique Release ID if necessary. To do so, create a view that concatenates the columns
--and then replace v_releases below with the view name and ORG_COL_NAME with the concatenated column name.)
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (23,'ust_release','release_id','v_releases','release_id',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (23,'ust_release','site_name','v_releases','site_name',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (23,'ust_release','site_address','v_releases','site_address',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (23,'ust_release','site_address2','v_releases','site_address2',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (23,'ust_release','site_city','v_releases','site_city',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (23,'ust_release','zipcode','v_releases','zipcode',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (23,'ust_release','county','v_releases','county',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (23,'ust_release','state','v_releases','state',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (23,'ust_release','latitude','v_releases','latitude',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (23,'ust_release','longitude','v_releases','longitude',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (23,'ust_release','coordinate_source_id','v_releases','coordinate_source',null,null);
--NOTE: release_status_id is a required field. If no such element exists in the source data, have Victoria ask the state to supply it.
--You can continue mapping while waiting for a response from the state, but you won't be able to do the final insert into the EPA tables
--until we receive the additional information.
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (23,'ust_release','release_status_id','v_releases','release_status',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (23,'ust_release','reported_date','v_releases','reported_date',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (23,'ust_release','nfa_date','v_releases','nfa_date',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (23,'ust_release','media_impacted_soil','v_releases','media_impacted_soil',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (23,'ust_release','media_impacted_groundwater','media_impacted_groundwater','ORG_COL_NAME',null,null);

--ust_release_substance: This table is OPTIONAL, do not map if there is no substance data in the source data
--NOTE: release_id is a required field. If Release ID does not exist in the source data, STOP and talk to the state. 
--(Note: it is OK to combine multiple fields to create a unique Release ID if necessary. To do so, create a view that concatenates the columns
--and then replace ORG_TAB_NAME below with the view name and ORG_COL_NAME with the concatenated column name.)
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (23,'ust_release_substance','release_id','v_release_substance','release_id',null,null);
--NOTE: If you are populating this table, substance_id is a required field. 
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (23,'ust_release_substance','substance_id','v_release_substance','substance',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (23,'ust_release_substance','quantity_released','v_release_substance','quantity_released',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (23,'ust_release_substance','unit','v_release_substance','unit',null,null);

select * from release_element_mapping where release_control_id = 23;

--ust_release_source: This table is OPTIONAL, do not map if there is no source data in the source data
--NOTE: release_id is a required field. If Release ID does not exist in the source data, STOP and talk to the state. 
--(Note: it is OK to combine multiple fields to create a unique Release ID if necessary. To do so, create a view that concatenates the columns
--and then replace ORG_TAB_NAME below with the view name and ORG_COL_NAME with the concatenated column name.)
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (23,'ust_release_source','release_id','v_release_source','release_id',null,null);
--NOTE: If you are populating this table, source_id is a required field. 
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (23,'ust_release_source','source_id','v_release_source','source',null,null);

--ust_release_cause: This table is OPTIONAL, do not map if there is no cause data in the source data
--NOTE: release_id is a required field. If Release ID does not exist in the source data, STOP and talk to the state. 
--(Note: it is OK to combine multiple fields to create a unique Release ID if necessary. To do so, create a view that concatenates the columns
--and then replace ORG_TAB_NAME below with the view name and ORG_COL_NAME with the concatenated column name.)
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (23,'ust_release_cause','release_id','v_release_cause','release_id',null,null);
--NOTE: If you are populating this table, cause_id is a required field. 
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (23,'ust_release_cause','cause_id','v_release_cause','cause',null,null);


--ust_release_corrective_action_strategy: This table is OPTIONAL, do not map if there is no corrective action strategy data in the source data
--NOTE: release_id is a required field. If Release ID does not exist in the source data, STOP and talk to the state. 
--(Note: it is OK to combine multiple fields to create a unique Release ID if necessary. To do so, create a view that concatenates the columns
--and then replace ORG_TAB_NAME below with the view name and ORG_COL_NAME with the concatenated column name.)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 5: Check for lookup data that needs to be deaggregated 

/* 
 * Some states store data with multiple values in a single row, for example, 
 * a release incident with multiple substances in one row. Before proceeding, we need 
 * to deaggregate this data by creating an ERG table that contains a single
 * value per row.
 * 
 * Run script generate_deagg_code.py to look for state data that may be
 * in this format, and then perform the deaggregation if necessary. 
 * Set the following variables before running the script:
 
ust_or_release = 'release' 		# valid values are 'ust' or 'release'
control_id = 23                 # Enter an integer that is the ust_control_id or release_control_id
only_incomplete = True 			# Boolean, set to True to restrict the output to EPA columns that have not yet been value mapped or False to output mapping for all columns

 * If - and only if - this script identifies possible aggregrated data, it will output SQL file in the repo at
 * /ust/sql/KS/Releases/KS_release_deagg.sql). Open the generated file in your database console and step through it.  
 * If no file is produced, proceed to the next step. 
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 6: Map the source data values to EPA values 

/* 
 * Table public.release_element_value_mapping documents the mapping of the source data element
 * values to EPA's lookup values. 
 * This table needs to be populated for all data elements mapped above where the EPA column 
 * has a lookup table. 
 * The following query will tell you which columns you need to perform this exercise for. 
 * (If no rows are returned, make sure you actually ran the SQL statements above after 
 * manipulating them!)

select epa_column_name from 
	(select distinct epa_table_name, epa_column_name, table_sort_order, column_sort_order
	from public.v_release_needed_mapping 
	where release_control_id = 23 and mapping_complete = 'N'
	order by table_sort_order, column_sort_order) x;
 
 * To generate the SQL that will assist you in doing the value mapping, run the script 
 * generate_value_mapping_sql.py. Set the following variables before running the script:
 
ust_or_release = 'release' 		# Valid values are 'ust' or 'release'
control_id = 23                 # Enter an integer that is the ust_control_id or release_control_id
only_incomplete = True   		# Boolean, defaults to True. Set to False to output mapping for all columns regardless if mapping was previously done. 
overwrite_existing = False      # Boolean, defaults to False. Set to True to overwrite existing generated SQL file. If False, will append an existing file.
 
 * This script will output a SQL file (located by default in the repo at 
 * /ust/sql/KS/Releases/KS_release_value_mapping.sql). Open the generated file in your database console 
 * and step through it.  
 * 
 */

="insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'"&TEXTAFTER(CELL("filename",$A$1),"]")&"','"&$D2&"','"&$E2&"');"

select epa_column_name from 
	(select distinct epa_table_name, epa_column_name, table_sort_order, column_sort_order
	from public.v_release_needed_mapping 
	where release_control_id = 23 and mapping_complete = 'N'
	order by table_sort_order, column_sort_order) x;
 


insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Release Status','ACTIVE','Active: general / open release');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Release Status','CLOSED','No further action');




insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'MediaImpacted','Remaining soil is above KDHE standards','Yes');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'MediaImpacted','Remaining soil is within KDHE standards','No');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'MediaImpacted','Yes','Yes');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'MediaImpacted','No','No');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'MediaImpacted','NA','No');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'MediaImpacted','','');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'MediaImpacted','','');

insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','Petroleum (gasoline)','Gasoline (unknown type)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','Premium Fuel','Gasoline (unknown type)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','Premuim','Gasoline (unknown type)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','Premium Gas','Gasoline (unknown type)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','mid-grade gasoline','Gasoline (unknown type)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','Mid-Grade Gas','Gasoline (unknown type)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','Gasoline','Gasoline (unknown type)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','gas0line','Gasoline (unknown type)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','gasolinbe','Gasoline (unknown type)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','gsasoline','Gasoline (unknown type)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','Regular gasoline','Gasoline (unknown type)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','Regular gas ','Gasoline (unknown type)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','nl gasoline','Gasoline (unknown type)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','reg','Gasoline (unknown type)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','gaso','Gasoline (unknown type)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','ga','Gasoline (unknown type)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','gas ','Gasoline (unknown type)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','gasline','Gasoline (unknown type)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','gasoli','Gasoline (unknown type)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','Gasolone','Gasoline (unknown type)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','mogas','Gasoline (unknown type)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','dgasoline','Gasoline (unknown type)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','Other','Other or mixture');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','None','Unknown');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','high sulphur diesel','Diesel fuel (b-unknown)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','Diesel-Low Sulfur','Diesel fuel (b-unknown)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','Diesel','Diesel fuel (b-unknown)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','Diesel #2','Diesel fuel (b-unknown)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','diese','Diesel fuel (b-unknown)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','Premium Diesel','Diesel fuel (b-unknown)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','#2 diesel','Diesel fuel (b-unknown)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','#2 diesel oil','Diesel fuel (b-unknown)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','diesel no 2','Diesel fuel (b-unknown)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','diesel (#2)','Diesel fuel (b-unknown)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','diesel fuel (#2)','Diesel fuel (b-unknown)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','diesel oil','Diesel fuel (b-unknown)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','deisel','Diesel fuel (b-unknown)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','fuel-diesel','Diesel fuel (b-unknown)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','diesel fuel oil','Diesel fuel (b-unknown)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','diesel-fuel oil','Diesel fuel (b-unknown)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','diesel (red dye)','Off-road diesel/dyed diesel');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','Dyed diesel','Off-road diesel/dyed diesel');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','Dyed diesel fuel','Off-road diesel/dyed diesel');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','mid-grade unleaded','Unleaded gasoline');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','prem unleaded','Unleaded gasoline');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','Unleaded','Unleaded gasoline');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','unlead gasoline','Unleaded gasoline');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','gasoline (unleaded)','Unleaded gasoline');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','gasoline-unleaded','Unleaded gasoline');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','super unleaded','Unleaded gasoline');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','gasoline-prem ul','Unleaded gasoline');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','premium unleaded','Unleaded gasoline');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','Premium Unleaded Gas','Unleaded gasoline');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','Unleaded (Premium)','Unleaded gasoline');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','no lead gasoline','Unleaded gasoline');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','leaded gasoline','Leaded gasoline');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','leaded  ','Leaded gasoline');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','gasohol','Ethanol blend gasoline (e-unknown)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','ethyl/gasoline','Ethanol blend gasoline (e-unknown)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','ehtyl?','Ethanol blend gasoline (e-unknown)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','alcohol','Denatured ethanol (98%)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','hydraulic','Hydraulic oil');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','Kerosene','Kerosene');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','kerosine','Kerosene');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','fuel  ','Heating/fuel oil # unknown');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','fuel oil  ','Heating/fuel oil # unknown');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','#5  fuel oil','Heating oil/fuel oil 5');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','#2 fuel oil','Heating oil/fuel oil 2');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','fuel oil #2','Heating oil/fuel oil 2');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','#6 fuel oil','Heating oil/fuel oil 6');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','fuel oil #6','Heating oil/fuel oil 6');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','bunker oil','Heating oil/fuel oil 6');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','bunker c fuel oil','Heating oil/fuel oil 6');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','Bunker C','Heating oil/fuel oil 6');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','Heating fuel oil','Heating/fuel oil # unknown');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','heating oil','Heating/fuel oil # unknown');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','Waste oil','Used oil/waste oil');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','waster oil','Used oil/waste oil');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','waste o ','Used oil/waste oil');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','wo','Used oil/waste oil');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','w.o.','Used oil/waste oil');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','heavy oil','Petroleum product');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','petroleum','Petroleum product');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance',' Petroleum hydrocarbons','Petroleum product');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','petro hydrocarbons','Petroleum product');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','petrol hydrocarbons','Petroleum product');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','petroleum products','Petroleum product');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','petro product','Petroleum product');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','petro products','Petroleum product');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','weathered petroleum','Petroleum product');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','refined petroleum','Petroleum product');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','refined petrol.','Petroleum product');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance',' Undetermined oil','Petroleum product');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','asphalt oil','Petroleum product');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','mixed petroleum','Petroleum product');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','black printing ink','Petroleum product');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','petroleum naphtha','Mineral Oil');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','solv napthe','Mineral Oil');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance',' stoddard solvent','Mineral Oil');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','mineral spirits','Mineral Oil');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','waste motor oil','Used oil/waste oil');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','drip oil','Used oil/waste oil');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','gasoline&oil','Used oil/waste oil');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','used motor oil','Used oil/waste oil');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','used engine oil','Used oil/waste oil');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','used oil','Used oil/waste oil');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','aviation fuel','Aviation gasoline');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','aviation gas','Aviation gasoline');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','navgas','Aviation gasoline');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','ave - gas','Aviation gasoline');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','av-gas','Aviation gasoline');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','ave-gas','Aviation gasoline');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','aviation gasoline','Aviation gasoline');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','aviation fuel ?','Aviation gasoline');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','av fuels','Aviation gasoline');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','low lead ave gas','Aviation gasoline');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance',' av-gas 100 low-lead','Aviation gasoline');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','avgas (100 octane)','Aviation gasoline');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','avgas  ','Aviation gasoline');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','various avia. fuels','Aviation gasoline');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','various avia fuel','Aviation gasoline');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','av. gas','Aviation gasoline');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','av gas','Aviation gasoline');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','AV Gas','Aviation gasoline');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','oil','Lube/motor oil (new)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','motor oil','Lube/motor oil (new)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','motor oi ','Lube/motor oil (new)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','new oil','Lube/motor oil (new)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','lube oil','Lube/motor oil (new)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','lube  ','Lube/motor oil (new)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','trans fluid','Lube/motor oil (new)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','ant. Free','Antifreeze');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','anti free','Antifreeze');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','antifreeze','Antifreeze');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','jet fuel','Unknown aviation gas or jet fuel');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','jp-4','Jet fuel B');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','jet a fuel','Jet fuel A');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','jet/aviation fuel','Unknown aviation gas or jet fuel');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','aviation & jet fuel','Unknown aviation gas or jet fuel');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','Jet A-aviation fuel','Jet fuel A');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance',' jet fue','Unknown aviation gas or jet fuel');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','oil&condensate&water','Petroleum product');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','condensate','Petroleum product');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','natural gas condensa','Petroleum product');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','nat gas condensate','Petroleum product');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','water into tank','Other or mixture');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','water','Other or mixture');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','dissolved gas','Other or mixture');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','gassy smelling water','Other or mixture');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','bad fuel','Other or mixture');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance',' gas (old)','Other or mixture');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','overfill/spilled','Other or mixture');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','solvent','Hazardous substance');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','solvents','Hazardous substance');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','acetone','Hazardous substance');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','hexane','Hazardous substance');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','btex/pce/tce','Hazardous substance');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance',' btex','Hazardous substance');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','methylmethacrylite m','Hazardous substance');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','butonone','Hazardous substance');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','benzene','Hazardous substance');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','n/a','Unknown');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','0','Unknown');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','?','Unknown');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','ukwn','Unknown');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','unkown','Unknown');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','unknown','Unknown');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','ultra low sufur','Diesel fuel (b-unknown)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Substance','E15 - 15% Ethanol','Gasoline E-15 (E-11-E15)');

insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Source','','Unknown');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Source','Piping','Piping');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Source','Tank','Tank');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Source','Spill/Overfill','Other');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Source','Other','Other');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Source','Unknown','Unknown');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Source','Dispenser','Dispenser');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Source','Delivery','Delivery problem');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Source','Sump pump area','Submersible turbine pump');


insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Cause','Rupture','Physical/mechanical damage');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Cause','Unknown','Unknown');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Cause','Corrosion','Corrosion');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Cause','','Unknown');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Cause','Other','Dispenser spill');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Cause','Physical/mechanical damage','Physical/mechanical damage');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Cause','Overfill','Overfill (general)');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Cause','Installation practices','Install problem');
insert into public.oust_release_value_mapping (release_control_id, excel_tab_name, organization_value, epa_value) values (23,'Cause','Spill','General spill');


delete from oust_release_value_mapping
where release_control_id = 23 and excel_tab_name = 'Source'

select * from public.oust_release_value_mapping
where release_control_id = 23;

select distinct excel_tab_name from oust_release_value_mapping
where release_control_id = 23 and epa_table_name is null 
order by 1;

Cause
Release Status
Source
MediaImpacted
Substance

select * from ust_release_cause;

update oust_release_value_mapping
set epa_table_name = 'causes', epa_column_name = 'cause'
where release_control_id = 23 and excel_tab_name = 'Cause';

update oust_release_value_mapping
set epa_table_name = 'release_statuses', epa_column_name = 'release_status'
where release_control_id = 23 and excel_tab_name = 'Release Status';

update oust_release_value_mapping
set epa_table_name = 'sources', epa_column_name = 'source'
where release_control_id = 23 and excel_tab_name = 'Source';

update oust_release_value_mapping
set epa_table_name = 'substances', epa_column_name = 'substance'
where release_control_id = 23 and excel_tab_name = 'Substance';

update public.oust_release_value_mapping
set organization_table_name = 'v_release_source', organization_column_name = 'source'
where release_control_id = 23 and excel_tab_name = 'Source';

select * from ks_release.v_release_source 
where source is null;

select oust_release_value_mapping_id, organization_value, epa_value
from oust_release_value_mapping
where release_control_id = 23 and excel_tab_name = 'MediaImpacted'

delete from oust_release_value_mapping where release_control_id = 23
and organization_value = '';

select * from release_tables;

select * from release_elements_tables 

select * from release_element_mapping where release_control_id = 23;


select b.epa_table_name, b.epa_column_name, organization_value, epa_value 
from public.oust_release_value_mapping a left join release_element_mapping b 
		on a.epa_table_name = b.epa_table_name and a.epa_column_name = b.epa_column_name  
	left join public.v_release_sort_order c
		on b.epa_table_name = c.table_name and b.epa_column_name = c.column_name 
where release_control_id = 23
order by table_sort_order, column_sort_order;




update oust_release_value_mapping set epa_table_name = 'v_ust_release'
where release_control_id = 23 and epa_table_name = 'ust_release'

select * from oust_release_value_mapping where length(organization_column_name) = 0;

select length('')

update public.oust_release_value_mapping
set organization_table_name = 'v_ust_release_cause', organization_column_name = 'cause'
where release_control_id = 23 and excel_tab_name = 'Cause';

update public.oust_release_value_mapping
set organization_table_name = 'v_ust_releases', organization_column_name = 'release_status'
where release_control_id = 23 and excel_tab_name = 'Release Status';

update public.oust_release_value_mapping
set organization_table_name = 'v_ust_release_source', organization_column_name = 'source'
where release_control_id = 23 and excel_tab_name = 'Source';

update public.oust_release_value_mapping
set organization_table_name = 'v_ust_release_substance', organization_column_name = 'substance'
where release_control_id = 23 and excel_tab_name = 'Substance';


select distinct organization_table_name 
from public.oust_release_value_mapping
where release_control_id = 23 and not exists 
	(select distinct organization_table_name from public.release_element_mapping
	 where release_control_id = 23)
order by 1

v_release
v_release_source
v_releases
v_release_cause
v_release_substance

select distinct  organization_table_name from public.release_element_mapping
	 where release_control_id = 23
v_releases
v_release_cause
v_release_source
v_release_substances
v_ust_releases	 
	 
select * from public.release_element_mapping
	 where release_control_id = 23
	 and organization_table_name not in (select table_name from information_schema.columns 
	 where table_schema = 'ks_release' )
	 
update 	 release_element_mapping set organization_table_name = 'v_releases'
where release_control_id = 23 and organization_table_name = 'v_ust_releases';
	 
update 	 release_element_mapping set organization_table_name = 'v_release_substance'
where release_control_id = 23 and organization_table_name = 'v_release_substances';

update oust_release_value_mapping set organization_table_name = replace(organization_table_name,'v_ust_','v_')
where  release_control_id = 23
	 
select * from public.release_element_mapping
where release_control_id = 23 and organization_table_name = 'media_impacted_groundwater'

update public.release_element_mapping
set organization_table_name = 'v_ust_releases', organization_column_name  = 'media_impacted_groundwater'
where release_element_mapping_id = 571;


select a.excel_tab_name, a.organization_table_name, a.organization_column_name
from public.oust_release_value_mapping a join 
	(select distinct release_control_id, organization_table_name from public.release_element_mapping) b 
	on a.release_control_id = b.release_control_id and a.organization_table_name = b.organization_table_name 
where a.release_control_id = 23 and not exists 
	(select 1 from public.release_element_mapping b 
	where a.release_control_id = b.release_control_id 
	and a.organization_table_name = b.organization_table_name and a.organization_column_name = b.organization_column_name);
	

select * from release_element_mapping where 	release_control_id = 23
	

select * from release_elements;

update oust_release_value_mapping
set epa_table_name = 'ust_release', epa_column_name = 'media_impacted_soil'
where release_control_id = 23 and oust_release_value_mapping_id in (3,4);

select * from oust_release_value_mapping order by 1;

update oust_release_value_mapping
set epa_table_name = 'ust_release', epa_column_name = 'media_impacted_groundwater'
where release_control_id = 23 and oust_release_value_mapping_id in (5,6,7);

select * from oust_release_value_mapping
where release_control_id = 23  and epa_column_name is null;

select distinct epa_value from oust_release_value_mapping
where release_control_id = 23 and epa_table_name = 'substances'
and epa_value not in (select substance from substances) order by 1;

Unleaded gasoline
Mineral Oil

select * from v_mapped_substances 
where lower(organization_value) like lower('%mineral%')

Gasoline (unknown type)
Solvent

select * from substances where lower(substance ) like lower('%unlead%')

select * from substances where lower(substance ) like lower('%mineral%')

select distinct organization_value from oust_release_value_mapping
where release_control_id = 23 and epa_table_name = 'substances'
and organization_value not in (select substance from ks_release.v_release_substance ) order by 1;


select distinct epa_value from oust_release_value_mapping
where release_control_id = 23 and epa_table_name = 'sources'
and epa_value not in (select source from sources);

select distinct epa_value from oust_release_value_mapping
where release_control_id = 23 and epa_table_name = 'causes'
and epa_value not in (select cause from causes);

select distinct epa_value from oust_release_value_mapping
where release_control_id = 23 and epa_table_name = 'release_statuses'
and epa_value not in (select release_status from release_statuses);


select * from oust_release_value_mapping
where release_control_id = 23 and epa_table_name = 'release_statuses'

insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (566, 'Address Geocode', '', null);

select epa_table_name, epa_column_name, organization_value, epa_value, release_element_mapping_id
from v_release_element_mapping where release_control_id = 23
order by table_sort_order, column_sort_order;

select * from oust_release_value_mapping 
where release_control_id = 23 and organization_column_name = 'substance'
and organization_value not in 
	(select substance from ks_release.erg_substance_datarows_deagg);

update oust_release_value_mapping
set organization_value = trim(organization_value)
where release_control_id = 23 and organization_column_name = 'substance'





select * from v_release_element_mapping;

select distinct "Status" from ks_release.releases


select distinct "Status" from ks_release.historical_releases

insert into public.release_element_value_mapping
(release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (567, 'ACTIVE', '', null);

select a.release_element_mapping_id, 
	a.epa_table_name, a.epa_column_name, 
	b.organization_value, b.epa_value, 'OUST key vocabulary mapping'
	
insert into public.release_element_value_mapping
	(release_element_mapping_id, organization_value, epa_value, programmer_comments)	
select a.release_element_mapping_id, 
	b.organization_value, b.epa_value, 'OUST key vocabulary mapping'	
from public.release_element_mapping a join public.oust_release_value_mapping b 
	on a.release_control_id = b.release_control_id
	and a.organization_table_name = b.organization_table_name 
	and a.organization_column_name = b.organization_column_name 
where a.release_control_id = 23



select distinct a.organization_table_name, a.organization_column_name, epa_table_name, epa_column_name, 
	database_lookup_table, c.database_lookup_column, case when d.column_name is not null then 'Y' else 'N' end as allowed_values,
	table_sort_order, column_sort_order 
from public.oust_release_value_mapping a left join public.v_release_element_mapping b
	on a.release_control_id = b.release_control_id
	and a.organization_table_name = b.organization_table_name and a.organization_column_name = b.organization_column_name
	left join public.release_elements c on b.epa_column_name = c.database_column_name 
	left join (select column_name from public.release_element_allowed_values) d on b.epa_column_name = d.column_name
where a.release_control_id = 23
order by table_sort_order, column_sort_order;

select * from release_element_allowed_values;

select * from release_elements where database_column_name = 'release_status_id'

select * from v_mapped_substances 
where lower(organization_value) like '%unleaded%'

update public.oust_release_value_mapping
set epa_value = 'Solvent'
where release_control_id = 23
and organization_table_name = 'v_release_substance' and organization_column_name = 'substance'
and epa_value = 'Mineral Oil';

update public.oust_release_value_mapping
set epa_value = 'Gasoline (unknown type)'
where release_control_id = 23
and organization_table_name = 'v_release_substance' and organization_column_name = 'substance'
and epa_value = 'Unleaded gasoline';

select * from oust_release_value_mapping 
where release_control_id = 23 and length(epa_value) = 0;

select organization_value
from public.oust_release_value_mapping a
where release_control_id = 23 
and organization_table_name = 'v_releases' and organization_column_name = 'release_status'
and organization_value not in  
	(select release_status from ks_release.v_releases)
order by 1;


select *
from public.oust_release_value_mapping a join public.v_release_element_mapping b 
	on a.release_control_id = b.release_control_id and a.organization_table_name = b.organization_table_name
		and a.organization_column_name = b.organization_column_name;


select * from  ks_release.historical_releases

update public.oust_release_value_mapping
set organization_value = null where release_control_id = 23 and organization_value = '';

delete from public.oust_release_value_mapping where release_control_id = 23 and organization_value = '';

delete from public.oust_release_value_mapping
where release_control_id = 23
and organization_table_name = 'v_release_source' and organization_column_name = 'source'
and organization_value = '';

select * from oust_release_value_mapping;


select distinct substance from ks_release.v_release_substance 
where substance not in 
	(select organization_value from oust_release_value_mapping
	where release_control_id = 23 and organization_column_name = 'substance');


select distinct substance from ks_release.erg_substance_datarows_deagg  
where substance not in 
	(select organization_value from oust_release_value_mapping
	where release_control_id = 23 and organization_column_name = 'substance');

select * from oust_release_value_mapping
where release_control_id = 23 and organization_column_name = 'substance'


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 7: Send the substance mapping (if it exists) for review by an ERG chemical expert 

/*
 * Run script export_substance_mapping.py to export the substance mapping and email it to John Wilhelmi,
 * who will send it along to a chemical expert at ERG to review it for possible hazardous substances.  
 * The script will automatically send the email through Outlook if you are on an ERG computer and
 * have the python module pypiwin32 installed in your environment. 
 * (Note: If the script is unable to send the email automatically (check your Sent folder), please
 * manually attach the file (located at /ust/python/exports/mapping/KS/Releases/) and send an email 
 * to John.Wilhelmi@erg.com, CCing Victoria and Renae. 
 * 
 * Set these variables in the script: 
 
ust_or_release = 'release' 		# Valid values are 'ust' or 'release'
control_id = 23                 # Enter an integer that is the ust_control_id or release_control_id
send_email = True				# Boolean; defaults to True. If True, will use Outlook to automatically email the generated file for ERG review. 

# These variables can usually be left unset. This script will generate an Excel file in the appropriate state folder in the repo under /ust/python/exports/mapping.
# This file directory and its contents are excluded from pushes to the repo by .gitignore.
export_file_path = None
export_file_dir = None
export_file_name = None

*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 8: Create the value mapping crosswalk views

/* 
 * Run script org_mapping_xwalks.py to create crosswalk views for all lookup tables.
 * Set these variables in the script:
 
ust_or_release = 'release' 		# Valid values are 'ust' or 'release'
control_id = 23                 # Enter an integer that is the ust_control_id or release_control_id
  
 * To see the crosswalk views after running the script:

select table_name 
from information_schema.tables 
where table_schema = lower('KS_release') and table_type = 'VIEW'
and table_name like '%_xwalk' order by 1;

*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 9: Create unique identifiers if they don't exist

/* 
 * Run script create_missing_id_columns.py to identify if any required columns (e.g. Tank ID, Compartment ID, etc.)
 * are missing and to create an ERG table containing generated IDs if necessary. 
 * Set these variables in the script:

ust_or_release = 'release' 		 # Valid values are 'ust' or 'release' 
control_id = 23                  # Enter an integer that is the release_control_id
drop_existing = False 		     # Boolean, defaults to False. Set to True to drop the table if it exists before creating it new.
write_sql = True                 # Boolean, defaults to True. If True, writes a SQL script recording the queries it ran to generate the tables.
overwrite_sql_file = False       # Boolean, defaults to False. Set to True to overwrite an existing SQL file if it exists. This parameter has no effect if write_sql = False. 

 * By default, this script will generate any required ID columns, update the public.release_element_mapping table,
 * and export a SQL file (located by default in the repo at /ust/sql/KS/Releases/KS_release_id_column_generation.sql).
 * You do NOT need to run the SQL in the generated file, however, if the script encounters errors or if you
 * are unable to write the views in the next step because the script did not correctly create the ID
 * generation tables, you can review this SQL file and make changes as needed to fix the data. If you do
 * need to make changes to generated ID tables, be sure to accurately update public.release_element_mapping table,
 * including making robust comments in the programmer_comments columns.

*/
--check to see if the script generated any tables 
select epa_table_name, epa_column_name, organization_table_name 
from public.v_release_element_mapping a join public.ust_template_data_tables b 
	on a.epa_table_name = b.table_name 
where release_control_id = 23 and organization_table_name like 'erg%'
order by sort_order;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 10: Write the views that convert the source data to the EPA format

/** THIS SECTION UNDER CONSTRUCTION!!! 
 * 
 * Please write the views manually (refer to the views in other state schemas for the basic structure)
 * for now.  
 * 
 * 
 * **/

/* UNDER CONSTRUCTION!!!!
 * Run script create_view_sql.py to create the BASIC STRUCTURE of the views that will be used to
 * populate the templates. 
 * WARNING! The queries generated by the script are a STARTING PLACE for the developers but will 
 * in most cases need to be manually manipulated to correctly select the data. 
 * 
*/

/** NOTE! Releases involving heating oil should only be included in UST Finder if the Facility Type =
 * 'Bulk plant storage/petroleum distributor', however, you should not exclude heating oil releases
 * if Facility Type is not populated. 
 * 
 * You can run script find_unrequlated.py to build tables erg_unregulated_facilities and 
 * erg_unregulated_releases and then use these tables to exclude the necessary facilities and releases 
 * while writing your views, however, the QAQC script that you run in the next step will check for  
 * the existence of these unregulated facilities, and if applicable, will suggest that you run script 
 * exclude_unregulated.py, which will both identify the unregulated facilities/releases and generate 
 * the SQL for you to update your views after writing them. In most cases, it may be easier to 
 * not worry about these unregulated facilities/releases in this step and just take care of the 
 * issue during the QAQC step below if necessary. 
 * 
 * 
*/

--Remind yourself if there are any state-level business rules you need to take into consideration
--when writing the views (such as excluding AST, for example).
select comments from public.release_control where release_control_id = 23;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 11: QA the views 

/* 
 * Run script qa_check.py to check that the views you have written to populate the main data tables
 * adhere to all business and logic rules.  
 * Set these variables in the script:

ust_or_release = 'release' 		 # Valid values are 'ust' or 'release' 
control_id = 23                  # Enter an integer that is the release_control_id

 * This script will check the views you just created in the state schema for the following:
 * 1) Missing views - will check that if you created a child view (for example, v_ust_release_substance), that the parent view(s) 
 *    (for example, v_ust_release) exist. 
 * 2) Missing join columns to parent tables. For example, v_ust_release_substance must contain release_id in order to be able to join it
 *    to its parent table. 
 * 3) Missing required columns. 
 * 4) Required columns that exist but contain null values. 
 * 5) Extraneous columns - will check for any columns in the views that don't match a column in the equivalent EPA table. This will help identify
 *    typos or other errors. 
 * 6) Non-unique rows. To resolve any cases where the counts are greater than 0, check that you did a "select distinct" when creating these views.
 *    Then check for bad joins.  
 * 7) Bad data types - will check for columns in the view where either the data type is different than the EPA column, or (for character columns) 
 *    if the length of the state value is too long to fit into the EPA column. If the data is too long to fit in the EPA column, this may indicate 
 *    an error in your code or mapping, OR it may mean you need to truncate the state's value to fit the EPA format. 
 * 8) Failed check constraints. 
 * 9) Columns that exist in the view that were not mapped in release_element_mapping. 
 * 10) Bad mapping values. To resolve any cases where bad mapping values exist, examine the specific row(s) in public.release_element_value_mapping 
 *     and ensure the epa_value exists in the associated lookup table. 
 * 11) Unregulated facility/release data related to heating oil in certain facility types. To resolve these issues, run script
 *     exclude_unregulated.py, which will identify the unregulated facilities and tanks and will generate SQL to help you rewrite your views.
 *
 * The script will also provide the counts of rows in v_ust_release, v_ust_release_substance, v_ust_release_source, v_ust_release_cause,
 * and v_ust_release_corrective_action_strategy (if these views exist) - ensure these counts make sense! 
 *   
 * The script will export a QAQC spreadsheet to the repo at 
 * /ust/python/exports/QAQC/KS/Releases/KS_release_QAQC_yyyymmddsssss.xlsx 
 * (in additional to printing to the screen and logs). If there are errors, re-write the views above, 
 * then re-run the qa script, and proceed when all errors have been resolved. 
 * 
*/

--------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 12: Insert data into the EPA schema 

/*
 * Run script populate_epa_data_tables.py to insert data into the main data tables in the public schema 
 * (ust_release, ust_release_substance, ust_release_source, ust_release_cause, and/or ust_release_corrective_action_strategy)
 * using the views you wrote in Step 9 above. 
 * 
 * Set these variables in the script: 
 
ust_or_release = 'release' 		 # Valid values are 'ust' or 'release' 
control_id = 23                  # Enter an integer that is the release_control_id
delete_existing = False 		 # can set to True if there is existing UST data you need to delete before inserting new

 * Do a quick sanity check of number of rows inserted:
*/
select table_name, num_rows 
from v_release_table_row_count
where release_control_id = 23
order by sort_order;

--------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 13: Export populated EPA template

/*
 * Run script export_template.py to generate a populated EPA template that will be sent first to OUST
 * for review, then to the state for review.
 * 
 * Set these variables in the script: 

ust_or_release = 'release' 		# Valid values are 'ust' or 'release'
control_id = 23                 # Enter an integer that is the ust_control_id or release_control_id

 * 
 * This script will output an Excel file (located by default in the repo at 
 * /ust/python/exports/epa_templates/KS/Releases/KS_release_template_yyyymmddsssss.xlsx). 
 * Before uploading this file in Step 14, open it to make sure it was generated correctly.
 * 
*/

--------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 14: Export control table summary

/*
 * Run script control_table_summary.py to generate a high-level overview of the data for OUST's review. 
 * 
 * Set these variables in the script: 

ust_or_release = 'release' 		# Valid values are 'ust' or 'release'
control_id = 23                 # Enter an integer that is the ust_control_id or release_control_id

 * 
 * This script will output an Excel file (located by default in the repo at 
 * /ust/python/exports/control_table_summaries/KS/Releases/KS_release_control_table_summary_yyyymmddsssss.xlsx). 
 * Before uploading this file in Step 14, open it to make sure it was generated correctly.
 * 
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--Step 15: Upload exported files to EPA Teams

/* 
 * Upload the following three files to the appropriate state folder on the EPA Teams site at 
 * https://usepa.sharepoint.com/:f:/r/sites/USTFinder2ASTSWMO/Shared%20Documents/General/02%20-%20Draft%20Mapped%20Templates?csf=1&web=1&e=fp1koB
 * (Documents > General > 02 - Draft Mapped Templates)
 * 
 * 1) Populated EPA template: /ust/python/exports/epa_templates/KS/Releases/KS_release_template_yyyymmddsssss.xlsx
 * 2) QAQC file: /ust/python/exports/QAQC/KS/Releases/KS_release_QAQC_yyyymmddsssss.xlsx
 * 3) Control table summary file: /ust/python/exports/control_table_summaries/KS/Releases/KS_release_control_table_summary_yyyymmddsssss.xlsx
 *
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--Step 16: Request peer review and make any suggested changes

/* 
 * All templates must be peer reviewed before sending to OUST. Currently Renae and Jim are available for peer reviews.
 * Send a Teams message to both Renae and Jim asking who is available to do a review. Set the status to 
 * "ERG Peer Review" in the Jira ticket and assign it to whichever developer agreed to perform the review. 
 * 
 * If the reviewing developer suggested any changes to your mapping or logic, follow these steps:
 * 
 * 1) Make suggested changes in the database. 
 * 2) If necessary, update the views you created in Step 9. 
 * 3) If you made any changes to the views you created in Step 9, re-run Step 10 to QA the views. 
 * 4) Rerun Step 11 to re-insert the data into the EPA schema. Remember to set the delete_existing variable 
 *    in the script to True (it defaults to False) to delete the data before re-inserting it. 
 * 5) Rerun Step 12 to export a new populated template. 
 * 6) If you made any changes to release_control, rerun Step 13 to export a new control table summary file. 
 * 7) Rerun Step 14 to re-upload all new exports to the EPA Teams site. 
 * 8) Add a comment to the Jira ticket noting you've made the changes and are ready for another review.
 *    Assign the ticket back to the original reviewer and make sure the status is ERG Peer Review if not already.
 *    Be sure to @ the reviewer in the ticket comment so they are aware they need to take action. 
 * 9) Repeat these steps until the reviewer approves the template for sending to OUST. 
 * 
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--Step 17: Export source data (if necessary)

/* 
 * OUST has requested that ERG make all source data available to them to assist in their review. If the 
 * state sent ERG Excel or CSV files, or a populated EPA template, Victoria will upload the source data to 
 * the EPA Teams site and you can skip this step. If, however, you had to download files from a state website, 
 * or if you retrieved the state data from an API, or if the state sent a database we extracted data from, or 
 * if for any other reason the source data was not uploaded to the EPA Teams site in the 
 * Documents > General > 01 - UST Source Data > KS > State-Provided Source Data folder, you must export the 
 * tables from the ERG database to CSV files and upload them to the EPA Teams site at
 * Documents > General > 01 - UST Source Data > KS > ERG Source Data folder. 
 * 
 * To export the source data from the database, run script export_source_data.py
 * 
 * Set these variables in the script: 
 * 
ust_or_release = 'release' 		# Valid values are 'ust' or 'release'
control_id = 23                 # Enter an integer that is the ust_control_id or release_control_id
all_tables = True               # Boolean, defaults to True. If True will export all source data tables; if False will only export those referenced in ust_element_mapping or release_element_mapping.
tables_to_exclude = []          # Python list of strings; defaults to empty list. Populate with table names in the organization schema that should be excluded from the export. (NOTE: ERG-created tables will not be exported regardless of the values in this list.)
empty_export_dir = True         # Boolean, defaults to True. If True, will delete all files in the export directory before proceeding. If False, will not delete any files, but will overwrite any that have the same name as the generated file name. 

 * 
 * This script will output a CSV file for each table in the state schema (the default export location is 
 * in the repo at /ust/python/exports/source_data/KS/Releases). 
 * After exporting the files, upload them to the appropriate state folder on the EPA Teams site at
 * https://usepa.sharepoint.com/:f:/r/sites/USTFinder2ASTSWMO/Shared%20Documents/General/01%20-%20UST%20Source%20Data?csf=1&web=1&e=7GtcsH
 * 
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--Step 18: Request OUST review

/* 
 * Sit back and relax, your work here is done for the time being! Or rather, sit back and start another ticket! 
 * Victoria will copy the final files to the appropriate folder on the EPA Teams site and alert
 * OUST that the data is ready for their review. 
 * 
 * OUST will report the findings of their reviews during our bi-weekly Tuesday meetings at 11 a.m. Eastern. 
 * They typically send an agenda out in the hour before the meeting. It's good to attend all of these meetings,
 * but please try especially to attend when they will be discussing a state you have processed - it's much
 * easier to understand their request (and learn a ton about USTs in general) if you are able to hear them 
 * talk about it instead of just reading their comments in the template.   
*/

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--Step 19: Respond to OUST comments 

/* 
 * When OUST completes their review, they will email us. An updated version of the populated template will be 
 * posted in the appropriate state folder at Documents > General > 04 - Template Feedback from OUST on the EPA Teams site at 
 * https://usepa.sharepoint.com/:f:/r/sites/USTFinder2ASTSWMO/Shared%20Documents/General/04%20-%20Template%20Feedback%20from%20OUST?csf=1&web=1&e=tVFLfE
 * 
 * Any changes you make per OUST's comments need to be peer reviewed before sending the template back to OUST, 
 * so repeat Step 15: Request peer review and make any suggested changes. 
 * 
 * Once you've resolved all of OUST's comments and the reviewing developer approves it, the process repeats itself
 * until OUST declares their review final, at which time Victoria will send the populated template to the state
 * for their review. 
 * 
*/

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--Step 20: State review 

/* 
 * We haven't gotten this far yet, but this process will be very similar to the OUST review process. 
 * Repeat Step 15 for any changes requested by the state. 
 * 
 */

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--Step 21: GIS processing (coming soon)

/* 
 * For any facilities the state did not submit coordinates for, or for coordinates less than 3 decimal 
 * places of accuracy, ERG will be geo-locating the data. This will be a separate process not covered by this 
 * processing template. Further instructions will be provided later. 
*/