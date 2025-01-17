------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* NOTES:
 * All Python scripts below are found in the github repo at https://github.com/Eastern-Research-Group/UST,
 * in the /ust/python/state_processing directory. 
 * You can set run variables at the top of the script; usually this will just be:
 * control_id (integer primary key from public.ust_control)
 * ust_or_release (string with values 'ust' or 'release').
 * 
 * 1) Before beginning processing, first do a git pull on the main branch, then create and checkout a 
 *    branch the describes what you are processing, for example, DE-UST, where you will do your work. 
 * 2) Copy this template and do a global replace of XX for the organization_id. Save the script in the 
 *    repo at /ust/sql/states/DE/Releases/DE_releases.sql (create these folders if necessary)
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
 * Step 7: Create the value mapping crosswalk views
 * Step 8: Create unique identifiers if they don't exist
 * Step 9: Write the views that convert the source data to the EPA format
 * Step 10: QA the views
 * Step 11: Insert data into the EPA schema 
 * Step 12: Export populated EPA template 
 * Step 13: Export control table summary
 * Step 14: Upload exported files to EPA Teams
 * Step 15: Request peer review and make any suggested changes
 * Step 16: Export source data (if necessary)
 * Step 17: Request OUST review
 * Step 18: Respond to OUST comments 
 * Step 19: State review 
 * Step 20: GIS processing (coming soon)
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
organization_id = 'DE'          # Enter the two-character code for the state, or "TRUSTD" for the tribes database 
path = r''                      # Enter the full path to the directory containing the source data file(s) (NOT a path to a specific file)
overwrite_table = False         # Boolean, defaults to False; set to True if you are replacing existing data in the schema

 * Script import_data_file_files.py will create the correct schema (if it doesn't yet exist), 
 * then upload all .xlsx, .xls, .csv, and .txt in the specified directory to this schema. 
 *
 * OR:
 * If you don't want to use the script, or the data was submitted in a different way (API, database dump, etc.),
 * manually upload it to the database, creating schema DE_release if it does not exist.

 * NOTE:
 * If there is old data in the state schema, from a previous submission, you can either simply
 * drop the old tables, or you can rename each of them with a prefix of "OLD_". This makes it obvious
 * which is the current source data to other developers. 

 * Before uploading the new data, you can run this query and use the resulting SQL to do the renames:

select 'alter table ' || table_schema ||  '.' || table_name || ' rename to ' || 'OLD_' || table_name || ';'
from information_schema.tables 
where table_schema = lower('DE_release')
order by table_name;

 * Or to drop the old data:

select 'drop table ' || table_schema ||  '.' || table_name || ';'
from information_schema.tables 
where table_schema = lower('DE_release')
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
 
organization_id = 'DE'                  # Enter the two-character code for the state, or "TRUSTD" for the tribes database 
ust_or_release = 'release'              # Valid values are 'ust' or 'release'
data_source = ''                        # Describe in detail where data came from (e.g. URL downloaded from, Excel spreadsheets from state, state API URL, etc.)
date_received = 'YYYY-MM-DD'            # Defaults to datetime.today(). To use a date other than today, set as a string in the format of 'yyyy-mm-dd'.
date_processed = None                   # Defaults to datetime.today(). To use a date other than today, set as a string in the format of 'yyyy-mm-dd'.
comments = ''                           # Top-level comments on the dataset. An example would be "Exclude Aboveground Storage Tanks".
organization_compartment_flag = None    # For UST only set to 'Y' if state data includes compartments, 'N' if state data is tank-level only. You can set this later if you don't know.

 * OR:

insert into release_control (organization_id, date_received, data_processed, data_source, comments)
values ('DE', 'YYYY-MM-DD', current_date, '', '');
returning release_control_id;

 * Both of the above methods will return the new release_control_id, but if you need to
 * retrieve it, use the following query:

select max(release_control_id) from release_control where organization_id = 'DE;

 * Do a global replace in this script from ZZ to the new release_control_id.
 */
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 3: Get an overview of the source data and prepare it for processing

/* Run this query to see what tables we have: 
*/
select table_name from information_schema.tables 
where table_schema = lower('DE_release') order by 1;

/*
 * If the table names came from Excel or CSV files and are hard to type and/or contain 
 * unfriendly characters, it's OK to re-name them.
 * You can use the following query to generate SQL to do so. 
  
select 'alter table ' || table_schema || '."' || table_name || '" rename to "NNNNNNNNNNN";'
from information_schema.tables 
where table_schema = lower('DE_release') and table_type = 'BASE TABLE'
order by 1;

 * Check the column names out too:
 */
select table_name, column_name
from information_schema.columns
where table_schema = lower('DE_release') 
order by table_name, ordinal_position;

/* 
 * If any columns have "bad" characters in them, you can use the following 
 * query to generate SQL to change them.
 * In general, try to keep the column names aligned with the source data as
 * much as possible as it will be easier for the states to understand the mapping. 
  
select 'alter table ' || table_schema || '."' || table_name || '" rename column "' || column_name || '" to "NNNNNNNNNNN";'
from information_schema.columns
where table_schema = lower('DE_release') and table_type = 'BASE TABLE'
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
where lower(table_schema) = 'DE_release' 
and lower(column_name) like '%fac%type%'
order by 1, 2;

 * DO NOT assume that just because a state column name is very similar to or exactly the same as
 * an EPA column that they are the same thing. Before mapping a state element, run some queries to 
 * make sure it actually contains the right data!

--query the EPA lookup table to see what we are looking for, for example:
select * from public.facility_types order by 1;

--then see what the state's data looks like:
select distinct "ORG_COL_NAME"
from DE_release."ORG_TAB_NAME"
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
from DE_release."ORG_TAB_NAME"
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

--ust_release: This table is REQUIRED
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (ZZ,'ust_release','facility_id','ORG_TAB_NAME','ORG_COL_NAME',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic)
values (ZZ,'ust_release','tank_id_associated_with_release','ORG_TAB_NAME','ORG_COL_NAME',null,null);
--NOTE: release_id is a required field. If Release ID does not exist in the source data, STOP and talk to the state. 
--(Note: it is OK to combine multiple fields to create a unique Release ID if necessary. To do so, create a view that concatenates the columns
--and then replace ORG_TAB_NAME below with the view name and ORG_COL_NAME with the concatenated column name.)
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (ZZ,'ust_release','release_id','ORG_TAB_NAME','ORG_COL_NAME',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (ZZ,'ust_release','federally_reportable_release','ORG_TAB_NAME','ORG_COL_NAME',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (ZZ,'ust_release','site_name','ORG_TAB_NAME','ORG_COL_NAME',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (ZZ,'ust_release','site_address','ORG_TAB_NAME','ORG_COL_NAME',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (ZZ,'ust_release','site_address2','ORG_TAB_NAME','ORG_COL_NAME',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (ZZ,'ust_release','site_city','ORG_TAB_NAME','ORG_COL_NAME',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (ZZ,'ust_release','zipcode','ORG_TAB_NAME','ORG_COL_NAME',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (ZZ,'ust_release','county','ORG_TAB_NAME','ORG_COL_NAME',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (ZZ,'ust_release','state','ORG_TAB_NAME','ORG_COL_NAME',null,null);
--NOTE: EPA region is rarely populated in the state data, other than TrUSTD (the tribal database)
--so it won't often be mapped here, but it will be added to view v_ust_release later. 
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (ZZ,'ust_release','epa_region','ORG_TAB_NAME','ORG_COL_NAME',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (ZZ,'ust_release','facility_type_id','ORG_TAB_NAME','ORG_COL_NAME',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (ZZ,'ust_release','tribal_site','ORG_TAB_NAME','ORG_COL_NAME',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (ZZ,'ust_release','tribe','ORG_TAB_NAME','ORG_COL_NAME',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (ZZ,'ust_release','latitude','ORG_TAB_NAME','ORG_COL_NAME',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (ZZ,'ust_release','longitude','ORG_TAB_NAME','ORG_COL_NAME',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (ZZ,'ust_release','coordinate_source_id','ORG_TAB_NAME','ORG_COL_NAME',null,null);
--NOTE: release_status_id is a required field. If no such element exists in the source data, have Victoria ask the state to supply it.
--You can continue mapping while waiting for a response from the state, but you won't be able to do the final insert into the EPA tables
--until we receive the additional information.
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (ZZ,'ust_release','release_status_id','ORG_TAB_NAME','ORG_COL_NAME',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (ZZ,'ust_release','reported_date','ORG_TAB_NAME','ORG_COL_NAME',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (ZZ,'ust_release','nfa_date','ORG_TAB_NAME','ORG_COL_NAME',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (ZZ,'ust_release','media_impacted_soil','ORG_TAB_NAME','ORG_COL_NAME',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (ZZ,'ust_release','media_impacted_groundwater','ORG_TAB_NAME','ORG_COL_NAME',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (ZZ,'ust_release','media_impacted_surface_water','ORG_TAB_NAME','ORG_COL_NAME',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (ZZ,'ust_release','release_discovered_id','ORG_TAB_NAME','ORG_COL_NAME',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (ZZ,'ust_release','closed_with_contamination','ORG_TAB_NAME','ORG_COL_NAME',null,null);
--NOTE: no_further_action_letter_url ONLY applies to tribal/TrUSTD data. DO NOT MAP for any other organizations. 
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (ZZ,'ust_release','no_further_action_letter_url','ORG_TAB_NAME','ORG_COL_NAME',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (ZZ,'ust_release','military_dod_site','ORG_TAB_NAME','ORG_COL_NAME',null,null);

--ust_release_substance: This table is OPTIONAL, do not map if there is no substance data in the source data
--NOTE: release_id is a required field. If Release ID does not exist in the source data, STOP and talk to the state. 
--(Note: it is OK to combine multiple fields to create a unique Release ID if necessary. To do so, create a view that concatenates the columns
--and then replace ORG_TAB_NAME below with the view name and ORG_COL_NAME with the concatenated column name.)
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (ZZ,'ust_release_substance','release_id','ORG_TAB_NAME','ORG_COL_NAME',null,null);
--NOTE: If you are populating this table, substance_id is a required field. 
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (ZZ,'ust_release_substance','substance_id','ORG_TAB_NAME','ORG_COL_NAME',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (ZZ,'ust_release_substance','quantity_released','ORG_TAB_NAME','ORG_COL_NAME',null,null);
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (ZZ,'ust_release_substance','unit','ORG_TAB_NAME','ORG_COL_NAME',null,null);

--ust_release_source: This table is OPTIONAL, do not map if there is no source data in the source data
--NOTE: release_id is a required field. If Release ID does not exist in the source data, STOP and talk to the state. 
--(Note: it is OK to combine multiple fields to create a unique Release ID if necessary. To do so, create a view that concatenates the columns
--and then replace ORG_TAB_NAME below with the view name and ORG_COL_NAME with the concatenated column name.)
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (ZZ,'ust_release_source','release_id','ORG_TAB_NAME','ORG_COL_NAME',null,null);
--NOTE: If you are populating this table, source_id is a required field. 
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (ZZ,'ust_release_source','source_id','ORG_TAB_NAME','ORG_COL_NAME',null,null);

--ust_release_cause: This table is OPTIONAL, do not map if there is no cause data in the source data
--NOTE: release_id is a required field. If Release ID does not exist in the source data, STOP and talk to the state. 
--(Note: it is OK to combine multiple fields to create a unique Release ID if necessary. To do so, create a view that concatenates the columns
--and then replace ORG_TAB_NAME below with the view name and ORG_COL_NAME with the concatenated column name.)
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (ZZ,'ust_release_cause','release_id','ORG_TAB_NAME','ORG_COL_NAME',null,null);
--NOTE: If you are populating this table, cause_id is a required field. 
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (ZZ,'ust_release_cause','cause_id','ORG_TAB_NAME','ORG_COL_NAME',null,null);

--ust_release_corrective_action_strategy: This table is OPTIONAL, do not map if there is no corrective action strategy data in the source data
--NOTE: release_id is a required field. If Release ID does not exist in the source data, STOP and talk to the state. 
--(Note: it is OK to combine multiple fields to create a unique Release ID if necessary. To do so, create a view that concatenates the columns
--and then replace ORG_TAB_NAME below with the view name and ORG_COL_NAME with the concatenated column name.)
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (ZZ,'ust_release_corrective_action_strategy','release_id','ORG_TAB_NAME','ORG_COL_NAME',null,null);
--NOTE: If you are populating this table, corrective_action_strategy_id is a required field. 
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (ZZ,'ust_release_corrective_action_strategy','corrective_action_strategy_id','ORG_TAB_NAME','ORG_COL_NAME',null,null);

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
control_id = ZZ                 # Enter an integer that is the ust_control_id or release_control_id
only_incomplete = True 			# Boolean, set to True to restrict the output to EPA columns that have not yet been value mapped or False to output mapping for all columns

 * If - and only if - this script identifies possible aggregrated data, it will output SQL file in the repo at
 * /ust/sql/DE/Releases/DE_release_deagg.sql). Open the generated file in your database console and step through it.  
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
	where release_control_id = ZZ and mapping_complete = 'N'
	order by table_sort_order, column_sort_order) x;
 
 * To generate the SQL that will assist you in doing the value mapping, run the script 
 * generate_value_mapping_sql.py. Set the following variables before running the script:
 
ust_or_release = 'release' 		# Valid values are 'ust' or 'release'
control_id = ZZ                 # Enter an integer that is the ust_control_id or release_control_id
only_incomplete = True   		# Boolean, defaults to True. Set to False to output mapping for all columns regardless if mapping was previously done. 
overwrite_existing = False      # Boolean, defaults to False. Set to True to overwrite existing generated SQL file. If False, will append an existing file.
 
 * This script will output a SQL file (located by default in the repo at 
 * /ust/sql/DE/Releases/DE_release_value_mapping.sql). Open the generated file in your database console 
 * and step through it.  
 * 
 */
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 7: Create the value mapping crosswalk views

/* 
 * Run script org_mapping_xwalks.py to create crosswalk views for all lookup tables.
 * Set these variables in the script:
 
ust_or_release = 'release' 		# Valid values are 'ust' or 'release'
control_id = ZZ                 # Enter an integer that is the ust_control_id or release_control_id
  
 * To see the crosswalk views after running the script:

select table_name 
from information_schema.tables 
where table_schema = lower('DE_release') and table_type = 'VIEW'
and table_name like '%_xwalk' order by 1;

*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 8: Create unique identifiers if they don't exist

/* 
 * Run script create_missing_id_columns.py to identify if any required columns (e.g. Tank ID, Compartment ID, etc.)
 * are missing and to create an ERG table containing generated IDs if necessary. 
 * Set these variables in the script:

ust_or_release = 'release' 		 # Valid values are 'ust' or 'release' 
control_id = ZZ                  # Enter an integer that is the release_control_id
drop_existing = False 		     # Boolean, defaults to False. Set to True to drop the table if it exists before creating it new.
write_sql = True                 # Boolean, defaults to True. If True, writes a SQL script recording the queries it ran to generate the tables.
overwrite_sql_file = False       # Boolean, defaults to False. Set to True to overwrite an existing SQL file if it exists. This parameter has no effect if write_sql = False. 

 * By default, this script will generate any required ID columns, update the public.release_element_mapping table,
 * and export a SQL file (located by default in the repo at /ust/sql/DE/Releases/DE_release_id_column_generation.sql).
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
where release_control_id = ZZ and organization_table_name like 'erg%'
order by sort_order;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 9: Write the views that convert the source data to the EPA format

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

--Remind yourself if there are any state-level business rules you need to take into consideration
--when writing the views (such as excluding AST, for example).
select comments from public.release_control where release_control_id = ZZ;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 10: QA the views 

/* 
 * Run script qa_check.py to check that the views you have written to populate the main data tables
 * adhere to all business and logic rules.  
 * Set these variables in the script:

ust_or_release = 'release' 		 # Valid values are 'ust' or 'release' 
control_id = ZZ                  # Enter an integer that is the release_control_id

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
 *
 * The script will also provide the counts of rows in v_ust_release, v_ust_release_substance, v_ust_release_source, v_ust_release_cause,
 * and v_ust_release_corrective_action_strategy (if these views exist) - ensure these counts make sense! 
 *   
 * The script will export a QAQC spreadsheet to the repo at 
 * /ust/python/exports/QAQC/DE/Releases/DE_release_QAQC_yyyymmddsssss.xlsx 
 * (in additional to printing to the screen and logs). If there are errors, re-write the views above, 
 * then re-run the qa script, and proceed when all errors have been resolved. 
 * 
*/

--------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 11: Insert data into the EPA schema 

/*
 * Run script populate_epa_data_tables.py to insert data into the main data tables in the public schema 
 * (ust_release, ust_release_substance, ust_release_source, ust_release_cause, and/or ust_release_corrective_action_strategy)
 * using the views you wrote in Step 9 above. 
 * 
 * Set these variables in the script: 
 
ust_or_release = 'release' 		 # Valid values are 'ust' or 'release' 
control_id = ZZ                  # Enter an integer that is the release_control_id
delete_existing = False 		 # can set to True if there is existing UST data you need to delete before inserting new

 * Do a quick sanity check of number of rows inserted:
*/
select table_name, num_rows 
from v_release_table_row_count
where release_control_id = ZZ
order by sort_order;

--------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 12: Export populated EPA template

/*
 * Run script export_template.py to generate a populated EPA template that will be sent first to OUST
 * for review, then to the state for review.
 * 
 * Set these variables in the script: 

ust_or_release = 'release' 		# Valid values are 'ust' or 'release'
control_id = ZZ                 # Enter an integer that is the ust_control_id or release_control_id

 * 
 * This script will output an Excel file (located by default in the repo at 
 * /ust/python/exports/epa_templates/DE/Releases/DE_release_template_yyyymmddsssss.xlsx). 
 * Before uploading this file in Step 14, open it to make sure it was generated correctly.
 * 
*/

--------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 13: Export control table summary

/*
 * Run script control_table_summary.py to generate a high-level overview of the data for OUST's review. 
 * 
 * Set these variables in the script: 

ust_or_release = 'release' 		# Valid values are 'ust' or 'release'
control_id = ZZ                 # Enter an integer that is the ust_control_id or release_control_id

 * 
 * This script will output an Excel file (located by default in the repo at 
 * /ust/python/exports/control_table_summaries/DE/Releases/DE_release_control_table_summary_yyyymmddsssss.xlsx). 
 * Before uploading this file in Step 14, open it to make sure it was generated correctly.
 * 
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--Step 14: Upload exported files to EPA Teams

/* 
 * Upload the following three files to the appropriate state folder on the EPA Teams site at 
 * https://usepa.sharepoint.com/:f:/r/sites/USTFinder2ASTSWMO/Shared%20Documents/General/02%20-%20Draft%20Mapped%20Templates?csf=1&web=1&e=fp1koB
 * (Documents > General > 02 - Draft Mapped Templates)
 * 
 * 1) Populated EPA template: /ust/python/exports/epa_templates/DE/Releases/DE_release_template_yyyymmddsssss.xlsx
 * 2) QAQC file: /ust/python/exports/QAQC/DE/Releases/DE_release_QAQC_yyyymmddsssss.xlsx
 * 3) Control table summary file: /ust/python/exports/control_table_summaries/DE/Releases/DE_release_control_table_summary_yyyymmddsssss.xlsx
 *
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--Step 15: Request peer review and make any suggested changes

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
--Step 16: Export source data (if necessary)

/* 
 * OUST has requested that ERG make all source data available to them to assist in their review. If the 
 * state sent ERG Excel or CSV files, or a populated EPA template, Victoria will upload the source data to 
 * the EPA Teams site and you can skip this step. If, however, you had to download files from a state website, 
 * or if you retrieved the state data from an API, or if the state sent a database we extracted data from, or 
 * if for any other reason the source data was not uploaded to the EPA Teams site in the 
 * Documents > General > 01 - UST Source Data > DE > State-Provided Source Data folder, you must export the 
 * tables from the ERG database to CSV files and upload them to the EPA Teams site at
 * Documents > General > 01 - UST Source Data > DE > ERG Source Data folder. 
 * 
 * To export the source data from the database, run script export_source_data.py
 * 
 * Set these variables in the script: 
 * 
ust_or_release = 'release' 		# Valid values are 'ust' or 'release'
control_id = ZZ                 # Enter an integer that is the ust_control_id or release_control_id
all_tables = True               # Boolean, defaults to True. If True will export all source data tables; if False will only export those referenced in ust_element_mapping or release_element_mapping.
tables_to_exclude = []          # Python list of strings; defaults to empty list. Populate with table names in the organization schema that should be excluded from the export. (NOTE: ERG-created tables will not be exported regardless of the values in this list.)
empty_export_dir = True         # Boolean, defaults to True. If True, will delete all files in the export directory before proceeding. If False, will not delete any files, but will overwrite any that have the same name as the generated file name. 

 * 
 * This script will output a CSV file for each table in the state schema (the default export location is 
 * in the repo at /ust/python/exports/source_data/DE/Releases). 
 * After exporting the files, upload them to the appropriate state folder on the EPA Teams site at
 * https://usepa.sharepoint.com/:f:/r/sites/USTFinder2ASTSWMO/Shared%20Documents/General/01%20-%20UST%20Source%20Data?csf=1&web=1&e=7GtcsH
 * 
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--Step 17: Request OUST review

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
--Step 18: Respond to OUST comments 

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
--Step 19: State review 

/* 
 * We haven't gotten this far yet, but this process will be very similar to the OUST review process. 
 * Repeat Step 15 for any changes requested by the state. 
 * 
 */

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--Step 20: GIS processing (coming soon)

/* 
 * For any facilities the state did not submit coordinates for, or for coordinates less than 3 decimal 
 * places of accuracy, ERG will be geo-locating the data. This will be a separate process not covered by this 
 * processing template. Further instructions will be provided later. 
*/