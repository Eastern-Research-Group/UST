------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* NOTES:
 * All Python scripts below are found in the github repo at https://github.com/Eastern-Research-Group/UST,
 * in the /ust/python/state_processing directory. 
 * Prefer using the ust CLI commands shown in each step rather than editing variables
 * at the top of Python scripts.
 * 
 * 1) Before beginning processing, first do a git pull on the main branch, then create and checkout a 
 *    branch the describes what you are processing, for example, MA-UST, where you will do your work. 
 * 2) Run the command below to copy this template and replace MA for organization_id (and 42 for control_id if known):
 *
 *    ust scaffold-template --type ust --organization-id MA [--control-id 42]
 *
 *    Optional flags:
 *    --no-control-lookup
 *    --overwrite
 * 3) Follow the steps in the template. Use the documented ust CLI commands where available.
 *    Unless you need to make a bugfix to the Python script,
 *    don't include any Python scripts from the state_processing directory in your pull request later. 
 */
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* OVERVIEW:
 * Step 1: Upload the source data 
 * Step 2: Update the control table 
 * Step 3: Get an overview of the source data and prepare it for processing
 * Step 4: Create the unregulated exclusion tables and views. 
 * Step 5: Insert top-level non-regulated/non-UST facilities into table erg_unregulated_facilities. 
 * Step 6: Map the source data elements to the EPA template elements 
 * Step 7: Check for lookup data that needs to be deaggregated 
 * Step 8: Map the source data values to EPA values
 * Step 9: Send the substance mapping for review by an ERG chemical expert  
 * Step 10: Create the value mapping crosswalk views
 * Step 11: Create unique identifiers if they don't exist
 * Step 12: Insert unregulated tanks/substances into table erg_unregulated_tanks. 
 * Step 13: Write the views that convert the source data to the EPA format
 * Step 14: QA the views
 * Step 15: Insert data into the EPA schema 
 * Step 16: Export populated EPA template 
 * Step 17: Export control table summary
 * Step 18: Upload exported files to EPA Teams
 * Step 19: Request peer review and make any suggested changes
 * Step 20: Export source data (if necessary)
 * Step 21: Request OUST review
 * Step 22: Respond to OUST comments 
 * Step 23: State review 
 * Step 24: GIS processing (coming soon)
 * 
 */
/* CLI QUICK CHECKLIST (copy/paste and replace MA + 42):
 * Setup   : ust scaffold-template --type ust --organization-id MA [--control-id 42]
 * Step 1  : ust import-files --type ust --organization-id MA --path "<path_to_directory_with_source_files>"
 * Step 2  : ust init-dataset --type ust --organization-id MA --data-source "<describe_data_source>" --date-received YYYY-MM-DD --comments "<dataset_comments>" --organization-compartment-flag Y
 * Step 4  : ust create-unreg --type ust --control-id 42
 * Step 7  : ust generate-deagg --type ust --control-id 42
 * Step 8  : ust generate-value-mapping --type ust --control-id 42 --append
 * Step 9  : ust export-substance-mapping --type ust --control-id 42
 * Step 10 : ust mapping-xwalks --type ust --control-id 42
 * Step 11 : ust create-missing-ids --type ust --control-id 42
 * Step 12 : ust populate-unreg --type ust --control-id 42
 * Step 13 : ust generate-views --type ust --control-id 42
 * Step 14 : ust qa --type ust --control-id 42
 * Step 15 : ust populate --type ust --control-id 42
 * Step 16 : ust export-template --type ust --control-id 42
 * Step 17 : ust export-control-summary --type ust --control-id 42
 * Step 20 : ust export-source-data --type ust --control-id 42
 * Optional: ust exclude-unregulated --type ust --control-id 42
 */
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 1: Upload the source data 
/*
 * EITHER:
 * If the data was submitted in the form of an Excel spreadsheet or a CSV/text file,
 * run the following command:

ust import-files --type ust --organization-id MA --path "<path_to_directory_with_source_files>"

 * Add --overwrite-table if you are replacing existing data in the schema.

 * Script import_data_from_files.py will create the correct schema (if it doesn't yet exist), 
 * then upload all .xlsx, .xls, .csv, and .txt in the specified directory to this schema. 
 *
 * OR:
 * If you don't want to use the script, or the data was submitted in a different way (API, database dump, etc.),
 * manually upload it to the database, creating schema xx_ust if it does not exist.

 * NOTE:
 * If there is old data in the state schema, from a previous submission, you can either simply
 * drop the old tables, or you can rename each of them with a prefix of "OLD_". This makes it obvious
 * which is the current source data to other developers. 

 * Before uploading the new data, you can run this query and use the resulting SQL to do the renames:

select 'alter table ' || table_schema ||  '.' || table_name || ' rename to ' || 'OLD_' || table_name || ';'
from information_schema.tables 
where table_schema = lower('MA_ust')
order by table_name;

 * Or to drop the old data:

select 'drop table ' || table_schema ||  '.' || table_name || ';'
from information_schema.tables 
where table_schema = lower('MA_ust')
order by table_name;

 */
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 2: Update the control table 
/* 
 * Table public.ust_control contains top-level information about the source data. 
 * This table will later be exported as part of the review materials sent to OUST. 
 * Use the comments column to describe any issues that affect the data set as a whole.
   For example, if the source data contains aboveground tanks as well as USTs, make a comment
   such as "Data includes ASTs, which will be excluded.". 
 * It's helpful to run a few queries against the source data before populating this table
   so you can provide good information in the comments column, however, you are also
   encouraged to go back and update this field later if you discover additional situations 
   that need to be documented as you process the data. 
 * Also ascertain at this time if the state reports their data at the tank or compartment
   level so you can populate the organization_compartment_flag column. In addition to looking
   for tables that have something like "compartment" in the name, you can run a query similar to:
 */

select * from information_schema.columns 
where table_schema = lower('MA_ust') 
and lower(column_name) like '%comp%'
order by table_name, ordinal_position;

/*
 * To insert a new row into the control table: 
 *  
 * EITHER:
 * Run the following command:

ust init-dataset --type ust --organization-id MA --data-source "<describe_data_source>" --date-received YYYY-MM-DD --comments "<dataset_comments>" --organization-compartment-flag Y

 * Optional flags:
 * --date-processed YYYY-MM-DD
 * --organization-compartment-flag N

 * OR:

insert into ust_control (organization_id, date_received, data_processed, data_source, comments, organization_compartment_flag)
values ('MA', 'YYYY-MM-DD', current_date, '', '', '');
returning ust_control_id;

 * Both of the above methods will return the new ust_control_id, but if you need to
 * retrieve it, use the following query:

select max(ust_control_id) from ust_control where organization_id = 'MA;

 * Do a global replace in this script from 42 to the new ust_control_id.
 */
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 3: Get an overview of the source data and prepare it for processing

/* Run this query to see what tables we have: 
*/
select table_name from information_schema.tables 
where table_schema = lower('MA_ust') order by 1;

CLOSED_UST_FACILITIES_JUN_3_2024
Dispenser info
Facility info
OPEN_UST_FACILITIES_JUN_3_2024
Tank info

select * from ma_ust."Facility info"

select * from ma_ust."OPEN_UST_FACILITIES_JUN_3_2024"


select * from information_schema.tables 
where table_schema = lower('MA_ust') order by 1;

SELECT
c.oid::regclass AS table_name,
f.creation AS file_created_at,
f.change AS inode_changed_at,
f.modification AS file_modified_at
FROM pg_class c
CROSS JOIN LATERAL pg_stat_file(pg_relation_filepath(c.oid)) f
WHERE c.oid =  'ma_ust."Facility info"'::regclass;

SELECT
n.nspname AS schema_name,
c.relname AS table_name,
pg_xact_commit_timestamp(t.xmin) AS approx_created_at
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
JOIN your_schema.your_table t ON true
WHERE n.nspname = 'ma_ust'
AND c.relname = '"Facility info"'
LIMIT 1;

SELECT pg_xact_commit_timestamp(xmin) AS approx_created_at
FROM ma_ust."Facility info"
LIMIT 1;

SELECT
  n.nspname AS schema_name,
  c.relname AS table_name,
  pg_xact_commit_timestamp(t.xmin) AS approx_created_at
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
JOIN ma_ust."Facility info" t ON true
WHERE n.nspname = 'ma_ust'
  AND c.relname = 'Facility info'
LIMIT 1;


/*
 * If the table names came from Excel or CSV files and are hard to type and/or contain 
 * unfriendly characters, it's OK to re-name them.
 * You can use the following query to generate SQL to do so. 
  
select 'alter table ' || table_schema || '."' || table_name || '" rename to "NNNNNNNNNNN";'
from information_schema.tables 
where table_schema = lower('MA_ust') and table_type = 'BASE TABLE'
order by 1;

 * Check the column names out too:
 */
select table_name, column_name
from information_schema.columns
where table_schema = lower('MA_ust') 
order by table_name, ordinal_position;

/* 
 * If any columns have "bad" characters in them, you can use the following 
 * query to generate SQL to change them.
 * In general, try to keep the column names aligned with the source data as
 * much as possible as it will be easier for the states to understand the mapping. 
  
select 'alter table ' || table_schema || '."' || table_name || '" rename column "' || column_name || '" to "NNNNNNNNNNN";'
from information_schema.columns
where table_schema = lower('MA_ust') and table_type = 'BASE TABLE'
order by 1;
  
 * NOTE: 
 * The ONLY changes we want to make to the source data is altering table and/or
 * column names to make it easier to query them. Any other manipulation that needs to be
 * done to the source data should be done by writing views or creating "erg_" prefixed tables.  
 */
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Step 4: Create the unregulated exclusion tables and views. 

/* Script create_unreg_tables.py creates the following tables and views:
 * 
 *   * MA_ust.erg_unregulated_facilities
 *   * MA_ust.erg_unregulated_tanks
 *   * MA_ust.vw_erg_substance_mapping
 *   * MA_ust.vw_erg_facility_type_mapping
 *   * MA_ust.vw_erg_tank_sizes
 *   * MA_ust.vw_erg_unreg_substances
 * 
 * The views won't contain any rows until after the mapping is completed in subsequent steps
 * but we may inserting some rows into erg_unregulated_facilities in the next step. 
 *
 * Run the following command:

ust create-unreg --type ust --control-id 42

 * Optional flags:
 * --drop-existing
 * --views-only

 * 
 */
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Step 5: Insert top-level non-regulated/non-UST facilities into table erg_unregulated_facilities. 

/* If the source data contains any non-regulated facilities, such as aboveground storage tanks, 
 * insert them into table MA_ust.erg_unregulated_facilities, providing a concise but descriptive unregulated_reason. 
 * Below is an EXAMPLE query you could use to insert AST facilities:

insert into MA_ust.erg_unregulated_facilities (facility_id, unregulated_reason)
select distinct "FacilityID", 'AST' 
from MA_ust.facilities 
where site_type = 'AST'
on conflict do nothing; 

select "FAC STATUS", count(*)
from ma_ust."Facility info"
group by "FAC STATUS";
CLOSED	1766
OPEN	5013



select count(*) from ma_ust."OPEN_UST_FACILITIES_JUN_3_2024" 
where "UST Facility ID" not in 
	(select "Facility ID#" from ma_ust."Facility info");
3417
38

select count(*)
from ma_ust."CLOSED_UST_FACILITIES_JUN_3_2024" 
where "UST Facility ID" not in 
	(select "Facility ID#" from ma_ust."Facility info");
7853
6473


select * from ma_ust."CLOSED_UST_FACILITIES_JUN_3_2024" 

select 'alter table ma_ust."CLOSED_UST_FACILITIES_JUN_3_2024"  drop column "' || column_name || '";'
from information_schema.columns 
where table_schema = 'ma_ust' and table_name = 'CLOSED_UST_FACILITIES_JUN_3_2024'
and column_name like 'Unname%'
order by ordinal_position;

alter table ma_ust."CLOSED_UST_FACILITIES_JUN_3_2024"  drop column "Unnamed: 9";
alter table ma_ust."CLOSED_UST_FACILITIES_JUN_3_2024"  drop column "Unnamed: 10";
alter table ma_ust."CLOSED_UST_FACILITIES_JUN_3_2024"  drop column "Unnamed: 11";
alter table ma_ust."CLOSED_UST_FACILITIES_JUN_3_2024"  drop column "Unnamed: 12";
alter table ma_ust."CLOSED_UST_FACILITIES_JUN_3_2024"  drop column "Unnamed: 13";

select 'a."' || column_name || '"::text,'
from  information_schema.columns 
where table_schema = 'ma_ust' and table_name = 'OPEN_UST_FACILITIES_JUN_3_2024'
order by ordinal_position

create or replace view ma_ust.vw_ust_facilities_combined as 
select a."UST Facility ID"::int,
		a."Facility Name"::text,
		a."Facility Address Line 1"::text,
		a."Facility City"::text,
    case
      when nullif(regexp_replace(a."Facility Zip"::text, '[^0-9]', '', 'g'), '') is null then null
      when length(regexp_replace(a."Facility Zip"::text, '[^0-9]', '', 'g')) >= 9
        then substr(regexp_replace(a."Facility Zip"::text, '[^0-9]', '', 'g'), 1, 5)
           || '-' ||
           substr(regexp_replace(a."Facility Zip"::text, '[^0-9]', '', 'g'), 6, 4)
      else lpad(regexp_replace(a."Facility Zip"::text, '[^0-9]', '', 'g'), 5, '0')
    end as "Facility Zip",
		a."Owner Name"::text,
		a."Owner Contact Name"::text,
		a."Operator Name"::text,
		a."Operator Contact Name"::text,
 'Open' as facility_status 
from ma_ust."OPEN_UST_FACILITIES_JUN_3_2024" a
union all 
select  a."UST Facility ID"::int,
		a."Facility Name"::text,
		a."Facility Address Line 1"::text,
		a."Facility City"::text,
    case
      when nullif(regexp_replace(a."Facility Zip"::text, '[^0-9]', '', 'g'), '') is null then null
      when length(regexp_replace(a."Facility Zip"::text, '[^0-9]', '', 'g')) >= 9
        then substr(regexp_replace(a."Facility Zip"::text, '[^0-9]', '', 'g'), 1, 5)
           || '-' ||
           substr(regexp_replace(a."Facility Zip"::text, '[^0-9]', '', 'g'), 6, 4)
      else lpad(regexp_replace(a."Facility Zip"::text, '[^0-9]', '', 'g'), 5, '0')
    end as "Facility Zip",
		a."Owner Name"::text,
		a."Owner Contact Name"::text,
		a."Operator Name"::text,
		a."Operator Contact Name"::text,
		 'Closed' as facility_status 
from ma_ust."CLOSED_UST_FACILITIES_JUN_3_2024" a;


*
*/

select * from ust_control where organization_id = 'MA'

select * from ust_facility 
where ust_control_id = 42
order by facility_id desc;

select * from ma_ust.erg_facility_final 

select * from ma_ust."OPEN_UST_FACILITIES_JUN_3_2024" 
where "UST Facility ID"::text not in 
	(select "Facility ID#"::text from ma_ust.erg_facility_final)
	
select "STATUS", count(*)
from ma_ust."Tank info"
where "Facility ID#"::text not in 
	(select "Facility ID#"::text from ma_ust."Facility info")
group by "STATUS"

Tank Closure In-Place	241
Tank Temporarily Out of Service	1
In Use	4




------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 6: Map the source data elements to the EPA template elements 

/* Table public.ust_element_mapping documents the mapping of the source data elements
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
 *     FacilityID or FacilityID and TankID, etc.) and then a column that performs 
 *     whatever manipulation you need to do to the data to transform it into a single
 *     column. Enter the table name and column name from the table you created into 
 *     ORG_TAB_NAME and ORG_COLUMN_NAME and describe in detail in programmer_comments
 *     what you did. 
 *  5) Use the query_logic field to enter specifics about the mapping logic. Replace the
 *     second "null" with SQL or pseudocode that expresses the logic you will perform 
 *     on the source data column to map it to the EPA format. 
 * 
 *     FOR EXAMPLE, say the source data has a single column for Financial Responsibility,
 *     in table "facilities" and column "fr_type", with a list of possible values like
 *     ["credit", "guarantee", "local gov't", "self insurance", "state fund", "other"]. 
 *     Map EPA fields financial_responsibility_obtained,
 *        financial_responsibility_letter_of_credit, financial_responsibility_guarantee,
 *        financial_responsibility_local_government_financial_test, 
 *        financial_responsibility_self_insurance_financial_test, and financial_responsibility_other_method
 *     EACH to state column "fr_type", and set the query_logic field as follows:
 *     financial_responsibility_obtained: "if fr_type is not null then 'Yes'"          
 *        financial_responsibility_letter_of_credit: "if fr_type = 'credit' then 'Yes'"    
 *     financial_responsibility_guarantee: "if fr_type = 'guarantee' then 'Yes'"    
 *     financial_responsibility_local_government_financial_test: "if fr_type = 'local gov't' then 'Yes'"    
 *     financial_responsibility_self_insurance_financial_test: "if fr_type = 'self insurance' then 'Yes'"    
 *     financial_responsibility_state_fund: "if fr_type = 'state fun' then 'Yes'"
 *        financial_responsibility_other_method: "if fr_type = 'state fund' then 'Yes'"    
 * 
 * After you've adjusted all the SQL statements for elements you are able to map and deleted those
 * you can't, run the SQL statements to perform the inserts.  
 * 
 * The SQL statements below were generated by running this query:
 
select * from public.v_ust_element_summary_sql;

 * It might help you to have another tab open in your database console where you can run queries like the 
 * following to help you do the mapping. FOR EXAMPLE, say you are trying to map EPA field facility_type1. 
 * This query may help you find it in the source data:

select table_name, column_name, data_type
from information_schema.columns 
where lower(table_schema) = 'MA_ust' 
and lower(column_name) like '%fac%type%'
order by 1, 2;

 * DO NOT assume that just because a state column name is very similar to or exactly the same as
 * an EPA column that they are the same thing. Before mapping a state element, run some queries to 
 * make sure it actually contains the right data!

--query the EPA lookup table to see what we are looking for, for example:
select * from public.facility_types order by 1;

--then see what the state's data looks like:
select distinct "ORG_COL_NAME"
from MA_ust."ORG_TAB_NAME"
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
select ust_control_id, epa_table_name, epa_column_name, 
    organization_table_name, organization_column_name,
    organization_join_table, 
    organization_join_column, organization_join_fk,
    organization_join_column2, organization_join_fk2,
    organization_join_column3, organization_join_fk3
from public.ust_element_mapping
where organization_join_table is not null 
order by 1, 2, 3, 4, 5;

 * NOTE:
 * The SQL statements below also assume the state's data is stored with a single value per cell. 
 * Sometimes states stored multiple values in a single cell, separated by a comma or other separator (if you're lucky...)
 * When examining the state's data with this query:

select distinct "ORG_COL_NAME"
from MA_ust."ORG_TAB_NAME"
order by 1;

 * If some rows appear to contain multiple values, you will have to DEAGGREGATE the data. This is most easily done
 * using a Python script written for that purpose and is discussed in the next step. In this step, set the 
 * organization_table_name and organization_column_name to the source data table and column containing the 
 * multiple values. When you get to the next step where you are mapping the values and you run deagg.py to
 * perform the deaggregation, the script will update the deagg_table_name and deagg_column_name columns of
 * public.ust_element_mapping for you. The query below finds examples of how ust_element_mapping eventually gets 
 * populated for these fields. 

select ust_control_id, epa_table_name, epa_column_name, 
    organization_table_name, organization_column_name,
    deagg_table_name, deagg_column_name
from public.ust_element_mapping
where deagg_table_name is not null 
order by 1, 2, 3, 4, 5;

 */

select * from information_schema.columns 
where table_schema = 'ma_ust' and table_name = 'erg_facility_final'
order by ordinal_position;

select 'facility_info_fr_type' as table_name, count(*) as row_count from ma_ust.erg_facility_info_fr_type
union all
select 'facility_info_business_type', count(*) from ma_ust.erg_facility_info_business_type
union all
select 'facility_info_org_type', count(*) from ma_ust.erg_facility_info_org_type;

select distinct "FAC TYPE" from ma_ust.erg_facility_final;

select distinct "business_type_name" from  ma_ust.erg_facility_info_business_type order by 1;
Corporation or non-profit corporation
Limited Liability Company
Partnership
Public agency
Sole proprietor
Trust

select distinct "org_type_name" from  ma_ust.erg_facility_info_org_type order by 1;
Authority
Federal
Institutional (non-profit)
Municipal
Private
State

select * from owner_types;

--ust_facility: This table is REQUIRED
--NOTE: facility_id is a required field. If Facility ID does not exist in the source data, STOP and talk to the state. 
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_facility','facility_id','erg_facility_final','Facility ID#',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic)
values (42,'ust_facility','facility_name','erg_facility_final','FAC NAME',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_facility','owner_type_id','erg_facility_info_org_type','org_type_name',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_facility','facility_type1','erg_facility_final','FAC TYPE',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_facility','facility_address1','erg_facility_final','FAC ADD 1',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_facility','facility_address2','erg_facility_final','FAC ADD 2',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_facility','facility_city','erg_facility_final','FAC CITY',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_facility','facility_zip_code','erg_facility_final','FAC ZIP',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_facility','facility_state','erg_facility_final','FAC STATE',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_facility','facility_latitude','erg_facility_final','FAC LAT',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_facility','facility_longitude','erg_facility_final','FAC LONG',null,null);

select distinct fr_type_name
from ma_ust.erg_facility_info_fr_type;

insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_facility','financial_responsibility_obtained','erg_facility_info_fr_type','fr_type_name',null,'fr_type_name is not null');

insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_facility','financial_responsibility_bond_rating_test','erg_facility_info_fr_type','fr_type_name',null,'fr_type_name = ''Local Government Bond Rating Test''');

insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_facility','financial_responsibility_commercial_insurance','erg_facility_info_fr_type','fr_type_name',null,'fr_type_name = ''Commercial Insurance''');

insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_facility','financial_responsibility_guarantee','erg_facility_info_fr_type','fr_type_name',null,'fr_type_name = ''Guarantee''');

insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_facility','financial_responsibility_letter_of_credit','erg_facility_info_fr_type','fr_type_name',null,'fr_type_name = ''Irrevocable Standby Letter of Credit''');

insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_facility','financial_responsibility_local_government_financial_test','erg_facility_info_fr_type','fr_type_name',null,'fr_type_name = ''Local Government Financial Test of Insurance''');

insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_facility','financial_responsibility_risk_retention_group','erg_facility_info_fr_type','fr_type_name',null,'fr_type_name = ''Risk Retention Group Coverage''');

insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_facility','financial_responsibility_self_insurance_financial_test','erg_facility_info_fr_type','fr_type_name',null,'fr_type_name = ''Financial Test of Insurance''');

insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_facility','financial_responsibility_state_fund','erg_facility_info_fr_type','fr_type_name',null,'fr_type_name = ''''');

insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_facility','financial_responsibility_surety_bond','erg_facility_info_fr_type','fr_type_name',null,'fr_type_name = ''Surety Bond''');

insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_facility','financial_responsibility_trust_fund','erg_facility_info_fr_type','fr_type_name',null,'fr_type_name = ''Trust Fund''');

insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_facility','financial_responsibility_other_method','erg_facility_info_fr_type','fr_type_name',null,'fr_type_name in (''Local Government Fund'',''Local Government Guarantee'')');


select * from information_schema.columns 
where table_schema = 'ma_ust' and table_name = 'Tank info'
order by ordinal_position;

select * from ma_ust."Tank info"

select distinct "STATUS" from ma_ust."Tank info"

--ust_tank: This table is REQUIRED.
--At a mimimum we need a Tank ID (or Tank Name) and Tank Status. If these fields don't exist in the source data, stop and talk to EPA and/or the state. 
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_tank','facility_id','Tank info','Facility ID#',null,null);
--NOTE: Tank ID is required, but we can create it in a later step as long as Tank Name exists in the source data.
--Tank ID must be an INTEGER (or able to be converted to an integer). 
--If the source data contains a column called Tank ID but it contains alphanumeric values, map it to EPA column tank_name instead of tank_id.
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_tank','tank_id','Tank info','TANK ID#',null,null);
--NOTE: Either tank_id or tank_name (or both) must be mapped. Use tank_id for numeric fields and tank_name for alphanumeric/text fields -
--regardless of the state's column names.
--NOTE: tank_status_id is required. 
--If it doesn't exist but Compartment Status exists, map tank_status_id to the organization's compartment status field. 
--If neither status exists, talk to the state before proceeding. 
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_tank','tank_status_id','Tank info','STATUS',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_tank','tank_closure_date','Tank info','STATUS DATE',null,'STATUS = ''Tank Closure In-Place''');

insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_tank','tank_installation_date','Tank info','INSTALL DATE',null,null);




select * from ust_element_mapping where ust_control_id = 42 order by 1 desc;

insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_tank','compartmentalized_ust','Tank info','NUMBER OF COMPARTMENT',null,'NUMBER OF COMPARTMENT > 1');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_tank','number_of_compartments','Tank info','NUMBER OF COMPARTMENT',null,null);

select * from ma_ust."Tank info"

select distinct "TANK CONSTRUCT" from ma_ust."Tank info" order by 1;
Concrete (cathodic protection not required)
Double-walled metal tank (cathodic protection required)
Double-walled non-corrodible (including "composite") material (cathodic protection not required)
Field Constructed Tank Double Walled (cathodic protection not required)
Single-walled metal tank (cathodic protection required)
Single-walled metal tank with internal liner (cathodic protection required)
Single-walled non-corrodible (including "composite") material (cathodic protection not required)

select * from tank_material_descriptions;
Fiberglass reinforced plastic
Asphalt coated or bare steel
Epoxy coated steel
Coated and cathodically protected steel
Jacketed steel
Concrete
Other
Unknown
Composite/clad steel w/fiberglass reinforced plastic
Cathodically protected steel without coating
Steel NEC
Urethane coated/clad steel (steel with/poly urethane)

insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_tank','tank_material_description_id','Tank info','TANK CONSTRUCT','tank material needs to be pulled out of this field',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_tank','tank_corrosion_protection_sacrificial_anode','Tank info','TANK CONSTRUCT','CP needs to be pulled out of this field',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_tank','tank_corrosion_protection_impressed_current','Tank info','TANK CONSTRUCT','CP needs to be pulled out of this field',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_tank','tank_corrosion_protection_cathodic_not_required','Tank info','TANK CONSTRUCT','CP needs to be pulled out of this field',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_tank','tank_corrosion_protection_interior_lining','Tank info','TANK CONSTRUCT','CP needs to be pulled out of this field',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_tank','tank_corrosion_protection_other','Tank info','TANK CONSTRUCT','CP needs to be pulled out of this field',null);





select ust_element_mapping_id, epa_column_name, organization_column_name, programmer_comments
from  public.ust_element_mapping
where ust_control_id = 42 and epa_column_name like 'tank_cor%'

update ust_element_mapping
set organization_column_name = 'TANK CORROSION TYPE', programmer_comments = null, query_logic = '"TANK CORROSION TYPE" = ''Field Constructed Impressed Current System''' 
where ust_element_mapping_id  = 4187;

update ust_element_mapping
set organization_column_name = 'TANK CORROSION TYPE', programmer_comments = null, query_logic = '"TANK CORROSION TYPE" in (''Manufactured Sacrificial Anode (Galvanic) System'',''Field Constructed Sacrificial Anode (Galvanic) System'')'
where ust_element_mapping_id  = 4186;


select * from ma_ust."Tank info"

select * from tank_secondary_containments;
Single wall
Double wall
Triple wall
Jacketed
Excavation liner
Vault
Tank-within-a-tank retrofit (UL standard 1856)
Other
Unknown

insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_tank','tank_secondary_containment_id','Tank info','TANK CONSTRUCT','Secondary containment needs to be pulled out of this column',null);

select * from ma_ust."Tank info"

select * from information_schema.columns 
where table_schema = 'ma_ust' and table_name = 'Tank info'
order by ordinal_position;


--ust_tank_substance: This table is OPTIONAL (but most states will have data)
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_tank_substance','facility_id','Tank info','Facility ID#',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_tank_substance','tank_id','Tank info','TANK ID#',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_tank_substance','substance_id','Tank info','CONTENT',null,null);

--ust_compartment: This table is REQUIRED. 
--If the state does not report compartment data, we will be creating a Compartment ID for it in a later step. 
--Look for these data elements in the tank data for states that don't report compartments. 
--Compartment Status is required; copy the Tank Status mapping for Compartment Status data for states 
--that don't report compartments or do report compartments but don't have a separate compartment status. 
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_compartment','facility_id','Tank info','Facility ID#',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_compartment','tank_id','Tank info','TANK ID#',null,null);
--NOTE: Compartment ID must be an INTEGER (or able to be converted to an integer). 
--If the source data contains a column called Compartment ID but it contains alphanumeric values, map it to EPA column compartment_name instead of compartment_id.
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_compartment','compartment_id','Tank info','TANK ID#',null,null);

--NOTE: Compartment Status is a required field. If the state does not report compartments, use the same element mapping as Tank Status
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_compartment','compartment_status_id','Tank info','STATUS',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_compartment','compartment_capacity_gallons','Tank info','CAPACITY',null,null);


select * from  public.ust_element_mapping order by 1 desc;

select * from ma_ust."Tank info"

select * from information_schema.columns 
where table_schema = 'ma_ust' and table_name = 'Tank info'
order by ordinal_position;

select distinct "SPILL BUCKET SENSOR" from ma_ust."Tank info" order by 1;

Automatic shut-off valve
Ball Float
High level alarm


insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_compartment','overfill_prevention_ball_float_valve','Tank info','OVERFILL PROTECT TYPE',null,'OVERFILL PROTECT TYPE = ''Ball Float''');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_compartment','overfill_prevention_flow_shutoff_device','Tank info','OVERFILL PROTECT TYPE',null,'OVERFILL PROTECT TYPE = ''Automatic shut-off valve''');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_compartment','overfill_prevention_high_level_alarm','Tank info','OVERFILL PROTECT TYPE',null,'OVERFILL PROTECT TYPE = ''High level alarm''');


insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_compartment','spill_bucket_installed','Tank info','SPILL BUCKET SENSOR',null,'SPILL BUCKET SENSOR = ''Y''');

select distinct "TANK LEAK DETECT" from ma_ust."Tank info" order by 1;
Continuous In-Tank Monitoring System
In-Tank Monitoring System
In tank monitor up to 2 gal per hour
In tank monitor w/ detection rate up to 1 gal/hr


insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_compartment','tank_interstitial_monitoring','Tank info','TANK LEAK DETECT',null,'"TANK LEAK DETECT" = ''Continuous Interstitial Monitoring''');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_compartment','tank_manual_tank_gauging','Tank info','TANK LEAK DETECT',null,'"TANK LEAK DETECT" in (''Manual Tank Gauging (1,000G or less capacity tank)'',''Manual Tank Gauging (1,000G or more capacity tank)'')');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_compartment','tank_statistical_inventory_reconciliation','Tank info','TANK LEAK DETECT',null,'"TANK LEAK DETECT" = ''In-Tank Monitoring with Statistical Inventory Reconciliation Vendor''');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_compartment','tank_tightness_testing','Tank info','TANK LEAK DETECT',null,'"TANK LEAK DETECT" in (''Annual Bulk Tightness Test'',''Annual tightness test w/ detection rate 0.5 gal/hr'')');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_compartment','tank_vapor_monitoring','Tank info','TANK LEAK DETECT',null,'"TANK LEAK DETECT" = ''Soil Vapor Monitoring''');


insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_compartment','tank_automatic_tank_gauging_release_detection','Tank info','TANK LEAK DETECT','please verify','"TANK LEAK DETECT" in (''In-Tank Monitoring with Statistical Inventory Reconciliation Vendor'',''In-Tank Monitoring System'',''In tank monitor up to 2 gal per hour'',''In tank monitor w/ detection rate up to 1 gal/hr'')');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_compartment','automatic_tank_gauging_continuous_leak_detection','Tank info','TANK LEAK DETECT','please verify','"TANK LEAK DETECT" = ''Continuous In-Tank Monitoring System''');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_compartment','tank_other_release_detection','Tank info','TANK LEAK DETECT',null,'"TANK LEAK DETECT" = ''''');



select * from  public.ust_element_mapping order by 1 desc;

delete e from ust_element_mapping where ust_element_mapping_id = 4216;

select * from ma_ust."Tank info"

select * from information_schema.columns 
where table_schema = 'ma_ust' and table_name = 'Tank info'
order by ordinal_position;


--ust_piping: This table is OPTIONAL; do not map if there is no piping data in the source data
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_piping','facility_id','Tank info','Facility ID#',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_piping','tank_id','Tank info','TANK ID#',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_piping','compartment_id','Tank info','TANK ID#',null,null);
--NOTE: Unlike TankID and CompartmentID, PipingID is a string in the EPA template, so it is OK to map an alphanumeric
--column in the source data to piping_id here. However, if there is no unique identifier for PipingID in the source 
--data, we will be creating one in a separate step. 
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_piping','piping_id','Tank info','TANK ID#',null,null);

insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_piping','safe_suction','Tank info','PIPE TYPE',null,'"PIPE TYPE" = ''European suction system''');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_piping','american_suction','Tank info','PIPE TYPE',null,'"PIPE TYPE" = ''Non-European suction System''');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_piping','high_pressure_or_bulk_piping','Tank info','PIPE TYPE',null,'"PIPE TYPE" in (''Pressurized piping system with electronic automatic line leak detection'',''Pressurized piping system with mechanical automatic line leak detection'')');

insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_piping','piping_style_id','Tank info','PIPE TYPE',null,null);



select * from  public.ust_element_mapping order by 1 desc;


select * from ma_ust."Tank info"

select * from information_schema.columns 
where table_schema = 'ma_ust' and table_name = 'Tank info'
order by ordinal_position;



select distinct "PIPE CONSTRUCT" from ma_ust."Tank info"

Double walled metal (Corrosion protection required)
Double-walled non-corrodible material (No corrosion protection required)
Single-walled non-corrodible material (No corrosion protection required)
Single-walled metal (Corrosion protection required)



insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_piping','piping_line_test_annual','Tank info','PIPE LEAK DETECT',null,'"PIPE LEAK DETECT" = ''Annual Automatic Line Leak Detection Test''');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_piping','piping_automated_intersticial_monitoring','Tank info','PIPE LEAK DETECT',null,'"PIPE LEAK DETECT" = ''Continuous Interstitial Space Monitoring''');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_piping','piping_line_leak_detector','Tank info','PIPE LEAK DETECT','please verify','"PIPE LEAK DETECT" is not null');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_piping','piping_interstitial_monitoring','Tank info','PIPE LEAK DETECT','please verify','"PIPE LEAK DETECT" = ''Continuous Interstitial Space Monitoring''');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_piping','piping_statistical_inventory_reconciliation','Tank info','PIPE LEAK DETECT',null,'"PIPE LEAK DETECT" = ''In-tank monitoring with SIR (if installed prior to May 28, 1999)''');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_piping','piping_release_detection_other','Tank info','PIPE LEAK DETECT','please verify','"PIPE LEAK DETECT" in (''Annual tightness test of Non-European suction systems (only if installed prior to 1/1/1989) without '',''Annual Tightness Test of Single-Walled Pressurized Piping Systems'',''Quarterly visual inspection and annual product line tightness test (only if installed prior to 5/28/'')');

 select distinct "LEAK CORROSION TYPE" from ma_ust."Tank info" 

insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_piping','piping_corrosion_protection_sacrificial_anode','Tank info','LEAK CORROSION TYPE',null,'"LEAK CORROSION TYPE" in (''Manufactured Sacrificial Anode (Galvanic) System'',''Field Constructed Sacrificial Anode (Galvanic) System'')');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_piping','piping_corrosion_protection_impressed_current','Tank info','LEAK CORROSION TYPE',null,'"LEAK CORROSION TYPE" = ''Field Constructed Impressed Current System');


select * from ust_element_mapping order by 1 desc;

select distinct "SUBMERSIBLE SUMP" from ma_ust."Tank info" 

select distinct "TURBINE SUMP" from ma_ust."Tank info" 

create view ma_ust.vw_erg_pipe_tank_top_sump 
as
select distinct "Facility ID#","TANK ID#", 'Yes' as pipe_tank_top_sump
from ma_ust."Tank info"  where  "SUBMERSIBLE SUMP" = 'Y' or  "TURBINE SUMP" = 'Y'
union all  
select distinct "Facility ID#","TANK ID#", 'No' as pipe_tank_top_sump
from ma_ust."Tank info"  where  "SUBMERSIBLE SUMP" = 'N' and  "TURBINE SUMP" = 'N';
 



insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_piping','pipe_tank_top_sump','vw_erg_pipe_tank_top_sump','pipe_tank_top_sump','ERG created this view to combine values in columns "SUBMERSIBLE SUMP and "TURBINE SUMP"',null);

select distinct "PIPE CONSTRUCT" from ma_ust."Tank info"
Double walled metal (Corrosion protection required)
Double-walled non-corrodible material (No corrosion protection required)
Single-walled non-corrodible material (No corrosion protection required)
Single-walled metal (Corrosion protection required)


insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_piping','piping_wall_type_id','Tank info','PIPE CONSTRUCT','wall type needs to be pulled out of this column',null);


select * from information_schema.columns 
where table_schema = 'ma_ust' and table_name = 'Dispenser info'
order by ordinal_position;

select * from ma_ust."Dispenser info"


--ust_facility_dispenser: Map and populate this table only if the state stores dispenser data at the Facility level.
--Dispenser data is OPTIONAL.
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_facility_dispenser','facility_id','Dispenser info','Facility ID#',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (42,'ust_facility_dispenser','dispenser_id','Dispenser info','dispenser_number',null,null);


select * from ust_elements where element_name like '%UDC%'

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 7: Check for lookup data that needs to be deaggregated 

/* 
 * Some states store data with multiple values in a single row, for example, 
 * a tank with multiple substances in one row. Before proceeding, we need 
 * to deaggregate this data by creating an ERG table that contains a single
 * value per row.
 * 
 * Run the following command:

ust generate-deagg --type ust --control-id 42

 * Optional flags:
 * --all-columns

 * If - and only if - this script identifies possible aggregrated data, it will output SQL file in the repo at
 * /ust/sql/MA/UST/MA_UST_deagg.sql). Open the generated file in your database console and step through it.  
 * If no file is produced, proceed to the next step. 
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 8: Map the source data values to EPA values 

/* 
 * Table public.ust_element_value_mapping documents the mapping of the source data element
 * values to EPA's lookup values. 
 * This table needs to be populated for all data elements mapped above where the EPA column 
 * has a lookup table. 
 * The following query will tell you which columns you need to perform this exercise for. 
 * (If no rows are returned, make sure you actually ran the SQL statements above after 
 * manipulating them!)

select epa_column_name from 
    (select distinct epa_table_name, epa_column_name, table_sort_order, column_sort_order
    from public.v_ust_needed_mapping 
    where ust_control_id = 42 and mapping_complete = 'N'
    order by table_sort_order, column_sort_order) x;
 
 * To generate the SQL that will assist you in doing the value mapping, run:

ust generate-value-mapping --type ust --control-id 42 --append

 * Optional flags:
 * --all-columns
 
 * This script will output a SQL file (located by default in the repo at 
 * /ust/sql/states/MA/UST/MA_UST_value_mapping.sql). Open the generated file in your database console
 * and step through it.  
 * 
 */
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 10: Create the value mapping crosswalk views

/* 
 * Run the following command:

ust mapping-xwalks --type ust --control-id 42
  
 * To see the crosswalk views after running the script:

select table_name 
from information_schema.tables 
where table_schema = lower('MA_ust') and table_type = 'VIEW'
and table_name like '%_xwalk' order by 1;

*/


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 11: Create unique identifiers if they don't exist

select * from ust_element_mapping where ust_control_id = 42 and epa_column_name in ('compartment_id','piping_id');
delete from  ust_element_mapping where ust_control_id = 42 and epa_column_name in ('compartment_id','piping_id');

select * from ma_ust.erg_compartment_id


/* 
 * Run the following command:

ust create-missing-ids --type ust --control-id 42

 * Optional flags:
 * --table-name <epa_table_name>
 * --drop-existing
 * --no-write-sql
 * --overwrite-sql-file

 * By default, this script will generate any required ID columns, update the public.ust_element_mapping table,
 * and export a SQL file (located by default in the repo at /ust/sql/MA/UST/MA_UST_id_column_generation.sql).
 * You do NOT need to run the SQL in the generated file, however, if the script encounters errors or if you
 * are unable to write the views in the next step because the script did not correctly create the ID
 * generation tables, you can review this SQL file and make changes as needed to fix the data. If you do
 * need to make changes to generated ID tables, be sure to accurately update public.ust_element_mapping table,
 * including making robust comments in the programmer_comments columns.

*/
--check to see if the script generated any tables 
select epa_table_name, epa_column_name, organization_table_name 
from public.v_ust_element_mapping a join public.ust_template_data_tables b 
    on a.epa_table_name = b.table_name 
where ust_control_id = 42 and organization_table_name like 'erg%'
order by sort_order;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 12: Insert unregulated tanks/substances into table erg_unregulated_tanks. 

/* 
 * Run the following command:

ust populate-unreg --type ust --control-id 42 --yes

 * Optional flags:
 * --organization-id MA
 * --delete-auto-inserts
 * --delete-all

 * If you inserted any rows into MA_ust.erg_unregulated_facilities in step 5 above, be sure to leave the 
 * delete_all variable = False; otherwise the rows you inserted previously will be deleted. If you need to
 * rerun this script at a later time, after making changes to the data, set delete_auto_inserts = True 
 * to delete only those rows that were inserted by this script and do a fresh insert.  
 * 
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 13: Write the views that convert the source data to the EPA format

/* THIS SECTION UNDER CONSTRUCTION!!! 
 * 
 * 
 * 
 * 
 * 
Run the following command:

ust generate-views --type ust --control-id 42 --yes

Optional flags:
--table-name <epa_table_name>
--append (append to existing file instead of overwrite)
--print-console

 * 
*/



------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 14: QA the views 

select count(*)
 from ma_ust.v_ust_tank a join ma_ust.erg_unregulated_tanks b on a.facility_id = b.facility_id;

select facility_id, count(*) from ma_ust.v_ust_facility group by facility_id having count(*) > 1 order by 1;

select * from ma_ust.v_ust_facility where facility_id = '1000140'

select * from ust_elements where element_name like 'Piping%'


select facility_id, tank_id, compartment_id, piping_id, count(*) num_rows from ma_ust.v_ust_piping 
 group by facility_id, tank_id, compartment_id, piping_id having count(*) > 1;


piping_automated_intersticial_monitoring

select * from ust_element_mapping where ust_control_id = 42 and epa_column_name = 'piping_automated_intersticial_monitoring'

update ust_element_mapping set epa_column_name = 'piping_automated_interstitial_monitoring'
where ust_element_mapping_id = 4223;

select "Facility ID#", "TANK ID#", count(*)
from ma_ust."Tank info"
group by "Facility ID#", "TANK ID#"
having count(*) > 1;

select * from ma_ust."Tank info"
where "Facility ID#" = 517 and "TANK ID#" = 5;

select * from ma_ust."Tank info"
where "Facility ID#" = 11227 and "TANK ID#" = 6;


select * from ma_ust.v_ust_compartment;

/* 
 * Run the following command to check that the views you have written to populate the main data tables
 * adhere to all business and logic rules:

ust qa --type ust --control-id 42 --yes

 * This script will check the views you just created in the state schema for the following:
 * 1) Missing views - will check that if you created a child view (for example, v_ust_compartment), that the parent view(s) (for example, v_ust_tank)
 *    exist. 
 * 2) Counts of child tables that have too few rows (for example, v_ust_compartment should have at least as many rows as v_ust_tank because
 *    every tank should have at least one compartment). 
 * 3) Missing join columns to parent tables. For example, v_ust_compartment must contain facility_id and tank_id in order to be able to join it
 *    to its parent tables. 
 * 4) Missing required columns. 
 * 5) Required columns that exist but contain null values. 
 * 6) Extraneous columns - will check for any columns in the views that don't match a column in the equivalent EPA table. This will help identify
 *    typos or other errors. 
 * 7) Non-unique rows. To resolve any cases where the counts are greater than 0, check that you did a "select distinct" when creating these views.
 *    Then check for bad joins.  
 * 8) Bad data types - will check for columns in the view where either the data type is different than the EPA column, or (for character columns) 
 *    if the length of the state value is too long to fit into the EPA column. If the data is too long to fit in the EPA column, this may indicate 
 *    an error in your code or mapping, OR it may mean you need to truncate the state's value to fit the EPA format. 
 * 9) Failed check constraints. 
 * 10) Columns that exist in the view that were not mapped in ust_element_mapping. 
 * 11) Bad mapping values. To resolve any cases where bad mapping values exist, examine the specific row(s) in public.ust_element_value_mapping 
 *     and ensure the epa_value exists in the associated lookup table. 
 * 12) Substance mapping using an inactive substance, or a substance not flagged for prevention. 
 * 13) Unregulated facility/tank data related to heating oil and small tank capacities in certain facility types. To resolve these issues,
 *     run:
 *
 *     ust exclude-unregulated --type ust --control-id 42
 *
 *     Optional flags:
 *     --organization-id MA
 *     --execute-sql
 *     --print-sql
 *     --view-name <view_name>
 *     --override-existing-unreg-check
 *
 * The script will also provide the counts of rows in v_ust_facility, v_ust_tank, v_ust_compartment, and v_ust_piping (if these views exist) -
 * ensure these counts make sense! 
 * 
 * If no errors are identified during the QA, the generated file will also contain tabs for excluded/non-regulated releases and excluded/non-regulated
 * substances as well as counts of certain values requested by OUST. 
 *   
 * The script will export a QAQC spreadsheet to the repo at 
 * /ust/python/exports/QAQC/MA/UST/MA_UST_QAQC_yyyymmddsssss.xlsx 
 * (in additional to printing to the screen and logs). If there are errors, re-write the views above, 
 * then re-run the qa script, and proceed when all errors have been resolved. 
 * 
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 15: Insert data into the EPA schema 

/*
 * Run the following command to insert data into the main data tables in the public schema 
 * (ust_facility, ust_tank, ust_tank_substance, ust_compartment, ust_compartment_substance, ust_piping,
 * ust_facility_dispenser, ust_tank_dispenser, and/or ust_compartment_dispenser) using the views you 
 * wrote in Step 13 above. 
 * 
ust populate --type ust --control-id 42 --yes

 * Optional flags:
 * --organization-id MA
 * --delete-existing

select count(*) from ma_ust."Facility info"

select count(*) from ma_ust."Tank info"
9896

select count(*) from (select distinct "Facility ID#" from ma_ust."Tank info") a;
3550

select * from ma_ust.erg_facility_final;


select count(*) from ma_ust.erg_facility_final;

select "Facility ID#", count(*) 
from  ma_ust.erg_facility_final
group by "Facility ID#"
having count(*) > 1;


select count(*) from ma_ust.v_ust_facility;

 * Do a quick sanity check of number of rows inserted:
*/
select table_name, num_rows 
from v_ust_table_row_count
where ust_control_id = 42
order by sort_order;


select count(*) from ma_ust.v_ust_compartment;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 16: Export populated EPA template

/*
 * Run the following command to generate a populated EPA template that will be sent first to OUST
 * for review, then to the state for review.
 *
ust export-template --type ust --control-id 42 --yes

 * Optional flags:
 * --data-only
 * --template-only

 * 
 * This script will output an Excel file (located by default in the repo at 
 * /ust/python/exports/epa_templates/MA/UST/MA_UST_template_yyyymmddsssss.xlsx). 
 * Before uploading this file in Step 18, open it to make sure it was generated correctly.
 * 
*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 17: Export control table summary

/*
 * Run the following command:

ust export-control-summary --type ust --control-id 42 --yes

 * Optional flags:
 * --organization-id MA
 * 
 select * from ust_elements;
 * 

 * 
 * This script will output an Excel file (located by default in the repo at 
 * /ust/python/exports/control_table_summaries/MA/UST/MA_UST_control_table_summary_yyyymmddsssss.xlsx). 
 * Before uploading this file in Step 18, open it to make sure it was generated correctly.
 * 
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--Step 18: Upload exported files to EPA Teams

/* 
 * Upload the following three files to the appropriate state folder on the EPA Teams site at 
 * https://usepa.sharepoint.com/:f:/r/sites/USTFinder2ASTSWMO/Shared%20Documents/General/02%20-%20Draft%20Mapped%20Templates?csf=1&web=1&e=fp1koB
 * (Documents > General > 02 - Draft Mapped Templates)
 * 
 * 1) Populated EPA template: /ust/python/exports/epa_templates/MA/UST/MA_UST_template_yyyymmddsssss.xlsx
 * 2) QAQC file: /ust/python/exports/QAQC/MA/UST/MA_UST_QAQC_yyyymmddsssss.xlsx
 * 3) Control table summary file: /ust/python/exports/control_table_summaries/MA/UST/MA_UST_control_table_summary_yyyymmddsssss.xlsx
 *
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--Step 19: Request peer review and make any suggested changes

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
 * 6) If you made any changes to ust_control, rerun Step 13 to export a new control table summary file. 
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
--Step 20: Export source data (if necessary)

/* 
 * OUST has requested that ERG make all source data available to them to assist in their review. If the 
 * state sent ERG Excel or CSV files, or a populated EPA template, Victoria will upload the source data to 
 * the EPA Teams site and you can skip this step. If, however, you had to download files from a state website, 
 * or if you retrieved the state data from an API, or if the state sent a database we extracted data from, or 
 * if for any other reason the source data was not uploaded to the EPA Teams site in the 
 * Documents > General > 01 - UST Source Data > MA > State-Provided Source Data folder, you must export the 
 * tables from the ERG database to CSV files and upload them to the EPA Teams site at
 * Documents > General > 01 - UST Source Data > MA > ERG Source Data folder. 
 * 
 * To export the source data from the database, run:

ust export-source-data --type ust --control-id 42

 * Optional flags:
 * --used-tables-only
 * --exclude-table <table_name>   (repeat as needed)
 * --keep-existing-files

 * 
 * This script will output a CSV file for each table in the state schema (the default export location is 
 * in the repo at /ust/python/exports/source_data/MA/UST). 
 * After exporting the files, upload them to the appropriate state folder on the EPA Teams site at
 * https://usepa.sharepoint.com/:f:/r/sites/USTFinder2ASTSWMO/Shared%20Documents/General/01%20-%20UST%20Source%20Data?csf=1&web=1&e=7GtcsH
 * 
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--Step 21: Request OUST review

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
--Step 22: Respond to OUST comments 

/* 
 * When OUST completes their review, they will email us. An updated version of the populated template will be 
 * posted in the appropriate state folder at Documents > General > 04 - Template Feedback from OUST on the EPA Teams site at 
 * https://usepa.sharepoint.com/:f:/r/sites/USTFinder2ASTSWMO/Shared%20Documents/General/04%20-%20Template%20Feedback%20from%20OUST?csf=1&web=1&e=tVFLfE
 * 
 * Any changes you make per OUST's comments need to be peer reviewed before sending the template back to OUST, 
 * so repeat Step 18: Request peer review and make any suggested changes. 
 * 
 * Once you've resolved all of OUST's comments and the reviewing developer approves it, the process repeats itself
 * until OUST declares their review final, at which time Victoria will send the populated template to the state
 * for their review. 
 * 
*/

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--Step 23: State review 

/* 
 * We haven't gotten this far yet, but this process will be very similar to the OUST review process. 
 * Repeat Step 15 for any changes requested by the state. 
 * 
 */

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--Step 24: GIS processing (coming soon)

/* 
 * For any facilities the state did not submit coordinates for, or for coordinates less than 3 decimal 
 * places of accuracy, ERG will be geo-locating the data. This will be a separate process not covered by this 
 * processing template. Further instructions will be provided later. 
*/
