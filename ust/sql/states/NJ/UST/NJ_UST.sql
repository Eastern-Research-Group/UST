------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* NOTES:
 * All Python scripts below are found in the github repo at https://github.com/Eastern-Research-Group/UST,
 * in the /ust/python/state_processing directory. 
 * You can set run variables at the top of the script; usually this will just be:
 * control_id (integer primary key from public.ust_control)
 * ust_or_release (string with values 'ust' or 'release').
 * 
 * 1) Before beginning processing, first do a git pull on the main branch, then create and checkout a 
 *    branch the describes what you are processing, for example, NJ-UST, where you will do your work. 
 * 2) Copy this template and do a global replace of NJ for the organization_id. Save the script in the 
 *    repo at /ust/sql/states/NJ/UST/NJ_UST.sql (create these folders if necessary)
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

ust_or_release = 'ust'          # Valid values are 'ust' or 'release'
organization_id = 'NJ'          # Enter the two-character code for the state, or "TRUSTD" for the tribes database 
path = r''                      # Enter the full path to the directory containing the source data file(s) (NOT a path to a specific file)
overwrite_table = False         # Boolean, defaults to False; set to True if you are replacing existing data in the schema

 * Script import_data_file_files.py will create the correct schema (if it doesn't yet exist), 
 * then upload all .xlsx, .xls, .csv, and .txt in the specified directory to this schema. 
 *
 * OR:
 * If you don't want to use the script, or the data was submitted in a different way (API, database dump, etc.),
 * manually upload it to the database, creating schema NJ_ust if it does not exist.

 * NOTE:
 * If there is old data in the state schema, from a previous submission, you can either simply
 * drop the old tables, or you can rename each of them with a prefix of "OLD_". This makes it obvious
 * which is the current source data to other developers. 

 * Before uploading the new data, you can run this query and use the resulting SQL to do the renames:

select 'alter table ' || table_schema ||  '.' || table_name || ' rename to ' || 'OLD_' || table_name || ';'
from information_schema.tables 
where table_schema = lower('NJ_ust')
order by table_name;

 * Or to drop the old data:

select 'drop table ' || table_schema ||  '.' || table_name || ';'
from information_schema.tables 
where table_schema = lower('NJ_ust')
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
where table_schema = lower('NJ_ust') 
and lower(column_name) like '%comp%'
order by table_name, ordinal_position;

/*
 * To insert a new row into the control table: 
 *  
 * EITHER:
 * Run script insert_control.py
 * 
 * Set the following variables at the top of the script:
 
organization_id = 'NJ'                  # Enter the two-character code for the state, or "TRUSTD" for the tribes database 
ust_or_release = 'ust'                  # Valid values are 'ust' or 'release'
data_source = ''                        # Describe in detail where data came from (e.g. URL downloaded from, Excel spreadsheets from state, state API URL, etc.)
date_received = 'YYYY-MM-DD'            # Defaults to datetime.today(). To use a date other than today, set as a string in the format of 'yyyy-mm-dd'.
date_processed = None                   # Defaults to datetime.today(). To use a date other than today, set as a string in the format of 'yyyy-mm-dd'.
comments = ''                           # Top-level comments on the dataset. An example would be "Exclude Aboveground Storage Tanks".
organization_compartment_flag = None    # For UST only set to 'Y' if state data includes compartments, 'N' if state data is tank-level only. You can set this later if you don't know.

 * OR:

insert into ust_control (organization_id, date_received, data_processed, data_source, comments, organization_compartment_flag)
values ('NJ', 'YYYY-MM-DD', current_date, '', '', '');
returning ust_control_id;

 * Both of the above methods will return the new ust_control_id, but if you need to
 * retrieve it, use the following query:

select max(ust_control_id) from ust_control where organization_id = 'NJ';

 * Do a global replace in this script from 36 to the new ust_control_id.
 */
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 3: Get an overview of the source data and prepare it for processing

/* Run this query to see what tables we have: 
*/
select table_name from information_schema.tables 
where table_schema = lower('NJ_ust') order by 1;

/*
 * If the table names came from Excel or CSV files and are hard to type and/or contain 
 * unfriendly characters, it's OK to re-name them.
 * You can use the following query to generate SQL to do so. 
  
select 'alter table ' || table_schema || '."' || table_name || '" rename to "NNNNNNNNNNN";'
from information_schema.tables 
where table_schema = lower('NJ_ust') and table_type = 'BASE TABLE'
order by 1;

 * Check the column names out too:
 */
select table_name, column_name
from information_schema.columns
where table_schema = lower('NJ_ust') 
order by table_name, ordinal_position;

/* 
 * If any columns have "bad" characters in them, you can use the following 
 * query to generate SQL to change them.
 * In general, try to keep the column names aligned with the source data as
 * much as possible as it will be easier for the states to understand the mapping. 
  
select 'alter table ' || table_schema || '."' || table_name || '" rename column "' || column_name || '" to "NNNNNNNNNNN";'
from information_schema.columns
where table_schema = lower('NJ_ust') and table_type = 'BASE TABLE'
order by 1;
  
 * NOTE: 
 * The ONLY changes we want to make to the source data is altering table and/or
 * column names to make it easier to query them. Any other manipulation that needs to be
 * done to the source data should be done by writing views or creating "erg_" prefixed tables.  
 */
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 4: Map the source data elements to the EPA template elements 

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
 * 	   financial_responsibility_letter_of_credit, financial_responsibility_guarantee,
 * 	   financial_responsibility_local_government_financial_test, 
 * 	   financial_responsibility_self_insurance_financial_test, and financial_responsibility_other_method
 *     EACH to state column "fr_type", and set the query_logic field as follows:
 *     financial_responsibility_obtained: "if fr_type is not null then 'Yes'"	      
 * 	   financial_responsibility_letter_of_credit: "if fr_type = 'credit' then 'Yes'"	
 *     financial_responsibility_guarantee: "if fr_type = 'guarantee' then 'Yes'"	
 *     financial_responsibility_local_government_financial_test: "if fr_type = 'local gov't' then 'Yes'"	
 *     financial_responsibility_self_insurance_financial_test: "if fr_type = 'self insurance' then 'Yes'"	
 *     financial_responsibility_state_fund: "if fr_type = 'state fun' then 'Yes'"
 * 	   financial_responsibility_other_method: "if fr_type = 'state fund' then 'Yes'"	
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
where lower(table_schema) = 'NJ_ust' 
and lower(column_name) like '%fac%type%'
order by 1, 2;

 * DO NOT assume that just because a state column name is very similar to or exactly the same as
 * an EPA column that they are the same thing. Before mapping a state element, run some queries to 
 * make sure it actually contains the right data!

--query the EPA lookup table to see what we are looking for, for example:
select * from public.facility_types order by 1;

--then see what the state's data looks like:
select distinct "ORG_COL_NAME"
from NJ_ust."ORG_TAB_NAME"
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
from NJ_ust."ORG_TAB_NAME"
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

--ust_facility: This table is REQUIRED
--NOTE: facility_id is a required field. If Facility ID does not exist in the source data, STOP and talk to the state. 
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_facility','facility_id','EPA_Transfer_Facility','FacilityID',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic)
values (36,'ust_facility','facility_name','EPA_Transfer_Facility','FacilityName',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_facility','owner_type_id','EPA_Transfer_Facility','OwnerType',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_facility','facility_type1','EPA_Transfer_Facility','FacilityType1',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_facility','facility_address1','EPA_Transfer_Facility','FacilityAddress1',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_facility','facility_address2','EPA_Transfer_Facility','FacilityAddress2',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_facility','facility_city','EPA_Transfer_Facility','FacilityCity',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_facility','facility_county','EPA_Transfer_Facility','FacilityCounty',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_facility','facility_zip_code','EPA_Transfer_Facility','FacilityZipCode',null,null);
--NOTE: facility_state is a required field but is not always populated in the state's data because the
--source database may assume all facilities are in the state. This column will be added to the v_ust_facility view 
--in a later step if it is not mapped here
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_facility','facility_state','EPA_Transfer_Facility','FacilityState',null,null);

--NOTE: EPA region is rarely populated in the state data, other than TrUSTD (the tribal database)
--so it won't often be mapped here, but it will be added to view v_ust_facility later. 
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_facility','facility_epa_region','EPA_Transfer_Facility','FacilityEPARegion',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_facility','facility_latitude','EPA_Transfer_Facility','FacilityLatitude',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_facility','facility_longitude','EPA_Transfer_Facility','FacilityLongitude',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_facility','facility_owner_company_name','EPA_Transfer_Facility','FacilityOwnerCompanyName',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_facility','facility_operator_company_name','EPA_Transfer_Facility','FacilityOperatorCompanyName',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_facility','financial_responsibility_obtained','EPA_Transfer_Facility','FinancialResponsibilityObtained',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_facility','financial_responsibility_bond_rating_test','EPA_Transfer_Facility','FinancialResponsibilityBondRatingTest',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_facility','financial_responsibility_commercial_insurance','EPA_Transfer_Facility','FinancialResponsibilityCommercialInsurance',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_facility','financial_responsibility_guarantee','EPA_Transfer_Facility','FinancialResponsibilityGuarantee',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_facility','financial_responsibility_letter_of_credit','EPA_Transfer_Facility','FinancialResponsibilityLetterOfCredit',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_facility','financial_responsibility_local_government_financial_test','EPA_Transfer_Facility','FinancialResponsibilityLocalGovernmentFinancialTest',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_facility','financial_responsibility_risk_retention_group','EPA_Transfer_Facility','FinancialResponsibilityRiskRetentionGroup',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_facility','financial_responsibility_self_insurance_financial_test','EPA_Transfer_Facility','FinancialResponsibilitySelfInsuranceFinancialTest',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_facility','financial_responsibility_state_fund','EPA_Transfer_Facility','FinancialResponsibilityStateFund',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_facility','financial_responsibility_surety_bond','EPA_Transfer_Facility','FinancialResponsibilitySuretyBond',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_facility','financial_responsibility_trust_fund','EPA_Transfer_Facility','FinancialResponsibilityTrustFund',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_facility','financial_responsibility_other_method','EPA_Transfer_Facility','FinancialResponsibilityOtherMethod',null,null);

--ust_tank: This table is REQUIRED.
--At a mimimum we need a Tank ID (or Tank Name) and Tank Status. If these fields don't exist in the source data, stop and talk to EPA and/or the state. 
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_tank','facility_id','EPA_Transfer_Tank','FacilityID',null,null);
--NOTE: Tank ID is required, but we can create it in a later step as long as Tank Name exists in the source data.
--Tank ID must be an INTEGER (or able to be converted to an integer). 
--If the source data contains a column called Tank ID but it contains alphanumeric values, map it to EPA column tank_name instead of tank_id.
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_tank','tank_id','EPA_Transfer_Tank','TankID',null,null);
--NOTE: Either tank_id or tank_name (or both) must be mapped. Use tank_id for numeric fields and tank_name for alphanumeric/text fields -
--regardless of the state's column names.
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_tank','tank_name','EPA_Transfer_Tank','TankName',null,null);
--NOTE: tank_status_id is required. 
--If it doesn't exist but Compartment Status exists, map tank_status_id to the organization's compartment status field. 
--If neither status exists, talk to the state before proceeding. 
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_tank','tank_status_id','EPA_Transfer_Tank','TankStatus',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_tank','federally_regulated','EPA_Transfer_Tank','FederallyRegulated',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_tank','emergency_generator','EPA_Transfer_Tank','EmergencyGenerator',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_tank','tank_closure_date','EPA_Transfer_Tank','TankClosureDate',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_tank','tank_installation_date','EPA_Transfer_Tank','TankInstallationDate',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_tank','compartmentalized_ust','EPA_Transfer_Tank','CompartmentalizedUST',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_tank','number_of_compartments','EPA_Transfer_Tank','NumberOfCompartments',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_tank','tank_material_description_id','EPA_Transfer_Tank','TankMaterialDescription',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_tank','tank_corrosion_protection_sacrificial_anode','EPA_Transfer_Tank','TankCorrosionProtectionSacrificialAnode',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_tank','tank_corrosion_protection_impressed_current','EPA_Transfer_Tank','TankCorrosionProtectionImpressedCurrent',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_tank','tank_corrosion_protection_cathodic_not_required','EPA_Transfer_Tank','TankCorrosionProtectionCathodicNotRequired',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_tank','tank_corrosion_protection_interior_lining','EPA_Transfer_Tank','TankCorrosionProtectionInteriorLining',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_tank','tank_corrosion_protection_other','EPA_Transfer_Tank','TankCorrosionProtectionOther',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_tank','tank_corrosion_protection_unknown','EPA_Transfer_Tank','TankCorrosionProtectionUnknown',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_tank','tank_secondary_containment_id','EPA_Transfer_Tank','TankSecondaryContainment',null,null);

--ust_tank_substance: This table is OPTIONAL (but most states will have data)
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_tank_substance','facility_id','EPA_Transfer_Compartment','FacilityID',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_tank_substance','tank_id','EPA_Transfer_Compartment','TankID',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_tank_substance','tank_name','EPA_Transfer_Compartment','TankName',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_tank_substance','substance_id','EPA_Transfer_Compartment','CompartmentSubstanceStored',
'No tank substance ID column. Mapped to CompartmentSubstanceStored in EPA_Transfer_Compartment. Waiting to hear back from state what _Check_TANK_CONTENTS column is.',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_tank_substance','substance_casno','EPA_Transfer_Compartment','CompartmentSubstanceCASNO',null,null);

--ust_compartment: This table is REQUIRED. 
--If the state does not report compartment data, we will be creating a Compartment ID for it in a later step. 
--Look for these data elements in the tank data for states that don't report compartments. 
--Compartment Status is required; copy the Tank Status mapping for Compartment Status data for states 
--that don't report compartments or do report compartments but don't have a separate compartment status. 
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_compartment','facility_id','EPA_Transfer_Compartment','FacilityID',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_compartment','tank_id','EPA_Transfer_Compartment','TankID',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_compartment','tank_name','EPA_Transfer_Compartment','TankName',null,null);
--NOTE: Compartment ID must be an INTEGER (or able to be converted to an integer). 
--If the source data contains a column called Compartment ID but it contains alphanumeric values, map it to EPA column compartment_name instead of compartment_id.
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_compartment','compartment_id','EPA_Transfer_Compartment','CompartmentID',null,null);
--NOTE: Compartment Status is a required field. If the state does not report compartments, use the same element mapping as Tank Status
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_compartment','compartment_status_id','EPA_Transfer_Compartment','CompartmentStatus',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_compartment','compartment_capacity_gallons','EPA_Transfer_Compartment','CompartmentCapacityGallons',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_compartment','overfill_prevention_ball_float_valve','EPA_Transfer_Compartment','OverfillPreventionBallFloatValve',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_compartment','overfill_prevention_flow_shutoff_device','EPA_Transfer_Compartment','OverfillPreventionFlowShutoffDevice',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_compartment','overfill_prevention_high_level_alarm','EPA_Transfer_Compartment','OverfillPreventionHighLevelAlarm',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_compartment','overfill_prevention_other','EPA_Transfer_Compartment','OverfillPreventionOther',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_compartment','overfill_prevention_unknown','EPA_Transfer_Compartment','OverfillPreventionUnknown',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_compartment','overfill_prevention_not_required','EPA_Transfer_Compartment','OverfillPreventionNotRequired',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_compartment','spill_bucket_installed','EPA_Transfer_Compartment','SpillBucketInstalled',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_compartment','tank_interstitial_monitoring','EPA_Transfer_Compartment','TankInterstitialMonitoring',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_compartment','tank_automatic_tank_gauging_release_detection','EPA_Transfer_Compartment','TankAutomaticTankGaugingReleaseDetection',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_compartment','automatic_tank_gauging_continuous_leak_detection','EPA_Transfer_Compartment','AutomaticTankGaugingContinuousLeakDetection',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_compartment','tank_manual_tank_gauging','EPA_Transfer_Compartment','TankManualTankGauging',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_compartment','tank_statistical_inventory_reconciliation','EPA_Transfer_Compartment','TankStatisticalInventoryReconciliation',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_compartment','tank_tightness_testing','EPA_Transfer_Compartment','TankTightnessTesting',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_compartment','tank_inventory_control','EPA_Transfer_Compartment','TankInventoryControl',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_compartment','tank_groundwater_monitoring','EPA_Transfer_Compartment','TankGroundwaterMonitoring',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_compartment','tank_vapor_monitoring','EPA_Transfer_Compartment','TankVaporMonitoring',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_compartment','tank_other_release_detection','EPA_Transfer_Compartment','TankOtherReleaseDetection',null,null);

--ust_comparment_substance is OPTIONAL; this table should ONLY be mapped/populated for states that report substance data at the compartment level,
--and where there is an obvious 1:1 relationship between compartment and substance. 
--Note that in the EPA data tables, this table is a child of ust_tank_substance: there is no substance ID in public.ust_compartment_substance!

--3/24/2025 DSH- Initially included mappings but then deleted, as no compartment substance data reported (or any compartment data, instead it is just a copy of tank data).

--ust_piping: This table is OPTIONAL; do not map if there is no piping data in the source data
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_piping','facility_id','EPA_Transfer_Piping','FacilityID',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_piping','tank_id','EPA_Transfer_Piping','TankID',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_piping','tank_name','EPA_Transfer_Piping','TankName',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_piping','compartment_id','EPA_Transfer_Piping','CompartmentID',null,null);
--NOTE: Unlike TankID and CompartmentID, PipingID is a string in the EPA template, so it is OK to map an alphanumeric
--column in the source data to piping_id here. However, if there is no unique identifier for PipingID in the source 
--data, we will be creating one in a separate step. 
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_piping','piping_id','EPA_Transfer_Piping','PipingID',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_piping','piping_style_id','EPA_Transfer_Piping','PipingStyle',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_piping','safe_suction','EPA_Transfer_Piping','SafeSuction',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_piping','american_suction','EPA_Transfer_Piping','AmericanSuction',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_piping','high_pressure_or_bulk_piping','EPA_Transfer_Piping','HighPressureOrBulkPiping',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_piping','piping_material_frp','EPA_Transfer_Piping','PipingMaterialFRP',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_piping','piping_material_gal_steel','EPA_Transfer_Piping','PipingMaterialGalSteel',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_piping','piping_material_stainless_steel','EPA_Transfer_Piping','PipingMaterialStainlessSteel',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_piping','piping_material_steel','EPA_Transfer_Piping','PipingMaterialSteel',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_piping','piping_material_copper','EPA_Transfer_Piping','PipingMaterialCopper',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_piping','piping_material_flex','EPA_Transfer_Piping','PipingMaterialFlex',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_piping','piping_material_no_piping','EPA_Transfer_Piping','PipingMaterialNoPiping',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_piping','piping_material_other','EPA_Transfer_Piping','PipingMaterialOther',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_piping','piping_material_unknown','EPA_Transfer_Piping','PipingMaterialUnknown',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_piping','piping_corrosion_protection_sacrificial_anode','EPA_Transfer_Piping','PipingCorrosionProtectionSacrificialAnode',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_piping','piping_corrosion_protection_impressed_current','EPA_Transfer_Piping','PipingCorrosionProtectionImpressedCurrent',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_piping','piping_corrosion_protection_cathodic_not_required','EPA_Transfer_Piping','PipingCorrosionProtectionCathodicNotRequired',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_piping','piping_corrosion_protection_other','EPA_Transfer_Piping','PipingCorrosionProtectionOther',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_piping','piping_corrosion_protection_unknown','EPA_Transfer_Piping','PipingCorrosionProtectionUnknown',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_piping','piping_line_leak_detector','EPA_Transfer_Piping','PipingLineLeakDetector',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_piping','piping_automated_intersticial_monitoring','EPA_Transfer_Piping','PipingAutomatedIntersticialMonitoring',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_piping','piping_line_test_annual','EPA_Transfer_Piping','PipingLineTestAnnual',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_piping','piping_line_test3yr','EPA_Transfer_Piping','PipingLineTest3yr',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_piping','piping_groundwater_monitoring','EPA_Transfer_Piping','PipingGroundwaterMonitoring',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_piping','piping_vapor_monitoring','EPA_Transfer_Piping','PipingVaporMonitoring',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_piping','piping_interstitial_monitoring','EPA_Transfer_Piping','PipingInterstitialMonitoring',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_piping','piping_statistical_inventory_reconciliation','EPA_Transfer_Piping','PipingStatisticalInventoryReconciliation',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_piping','piping_release_detection_other','EPA_Transfer_Piping','PipingReleaseDetectionOther',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (36,'ust_piping','piping_wall_type_id','EPA_Transfer_Piping','PipingWallType',null,null);

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 5: Check for lookup data that needs to be deaggregated 

/* 
 * Some states store data with multiple values in a single row, for example, 
 * a tank with multiple substances in one row. Before proceeding, we need 
 * to deaggregate this data by creating an ERG table that contains a single
 * value per row.
 * 
 * Run script generate_deagg_code.py to look for state data that may be
 * in this format, and then perform the deaggregation if necessary. 
 * Set the following variables before running the script:
 
ust_or_release = 'ust' 			# valid values are 'ust' or 'release'
control_id = 36                 # Enter an integer that is the ust_control_id or release_control_id
only_incomplete = True 			# Boolean, set to True to restrict the output to EPA columns that have not yet been value mapped or False to output mapping for all columns

 * If - and only if - this script identifies possible aggregrated data, it will output SQL file in the repo at
 * /ust/sql/NJ/UST/NJ_UST_deagg.sql). Open the generated file in your database console and step through it.  
 * If no file is produced, proceed to the next step. 
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 6: Map the source data values to EPA values 

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
	where ust_control_id = 36 and mapping_complete = 'N'
	order by table_sort_order, column_sort_order) x;
 
 * To generate the SQL that will assist you in doing the value mapping, run the script 
 * generate_value_mapping_sql.py. Set the following variables before running the script:
 
ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = 36                 # Enter an integer that is the ust_control_id or release_control_id
only_incomplete = True   		# Boolean, defaults to True. Set to False to output mapping for all columns regardless if mapping was previously done. 
overwrite_existing = False      # Boolean, defaults to False. Set to True to overwrite existing generated SQL file. If False, will append an existing file.
 
 * This script will output a SQL file (located by default in the repo at 
 * /ust/sql/states/NJ/UST/NJ_UST_value_mapping.sql). Open the generated file in your database console
 * and step through it.  
 * 
 */
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
 * manually attach the file (located at /ust/python/exports/mapping/NJ/UST/) and send an email 
 * to John.Wilhelmi@erg.com, CCing Victoria and Renae. 
 * 
 * Set these variables in the script: 
 
ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = 36                 # Enter an integer that is the ust_control_id or release_control_id
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
 
ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = 36                 # Enter an integer that is the ust_control_id or release_control_id
  
 * To see the crosswalk views after running the script:

select table_name 
from information_schema.tables 
where table_schema = lower('NJ_ust') and table_type = 'VIEW'
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

ust_or_release = 'ust' 			 # Valid values are 'ust' or 'release' 
control_id = 36                  # Enter an integer that is the ust_control_id
drop_existing = False 		     # Boolean, defaults to False. Set to True to drop the table if it exists before creating it new.
write_sql = True                 # Boolean, defaults to True. If True, writes a SQL script recording the queries it ran to generate the tables.
overwrite_sql_file = False       # Boolean, defaults to False. Set to True to overwrite an existing SQL file if it exists. This parameter has no effect if write_sql = False. 

 * By default, this script will generate any required ID columns, update the public.ust_element_mapping table,
 * and export a SQL file (located by default in the repo at /ust/sql/NJ/UST/NJ_UST_id_column_generation.sql).
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
where ust_control_id = 36 and organization_table_name like 'erg%'
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

/** NOTE! Tanks containing heating oil should only be included in UST Finder if the Facility Type =
 * 'Bulk plant storage/petroleum distributor', however, you should not exclude heating oil tanks
 * if Facility Type is not populated. Also, tanks <1100 gallons should be excluded if the 
 * Facility Type is populated and is equal to 'Agricultural/farm' or 'Residential. 
 * 
 * You can run script find_unrequlated.py to build tables erg_unregulated_facilities and 
 * erg_unregulated_tanks and then use these tables to exclude the necessary facilities and tanks 
 * while writing your views, however, the QAQC script that you run in the next step will check for  
 * the existence of these unregulated tanks, and if applicable, will suggest that you run script 
 * exclude_unregulated.py, which will both identify the unregulated facilities/tanks and generate 
 * the SQL for you to update your views after writing them. In most cases, it may be easier to 
 * not worry about these unregulated facilities/tanks in this step and just take care of the 
 * issue during the QAQC step below if necessary. 
 * 
 * 
*/

--Remind yourself if there are any state-level business rules you need to take into consideration
--when writing the views (such as excluding AST, for example).
select comments from public.ust_control where ust_control_id = 36;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 11: QA the views 

/* 
 * Run script qa_check.py to check that the views you have written to populate the main data tables
 * adhere to all business and logic rules.  
 * Set these variables in the script:

ust_or_release = 'ust' 			 # Valid values are 'ust' or 'release' 
control_id = 36                  # Enter an integer that is the ust_control_id

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
 * 12) Unregulated facility/tank data related to heating oil and small tank capacities in certain facility types. To resolve these issues, 
 *     run script exclude_unregulated.py, which will identify the unregulated facilities and tanks and will generate SQL to help you rewrite 
 *     your views. 
 *
 * The script will also provide the counts of rows in v_ust_facility, v_ust_tank, v_ust_compartment, and v_ust_piping (if these views exist) -
 * ensure these counts make sense! 
 *   
 * The script will export a QAQC spreadsheet to the repo at 
 * /ust/python/exports/QAQC/NJ/UST/NJ_UST_QAQC_yyyymmddsssss.xlsx 
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
 * (ust_facility, ust_tank, ust_tank_substance, ust_compartment, ust_compartment_substance, ust_piping,
 * ust_facility_dispenser, ust_tank_dispenser, and/or ust_compartment_dispenser) using the views you 
 * wrote in Step 9 above. 
 * 
 * Set these variables in the script: 
 
ust_or_release = 'ust' 			 # Valid values are 'ust' or 'release' 
control_id = 36                  # Enter an integer that is the ust_control_id
delete_existing = False 		 # can set to True if there is existing UST data you need to delete before inserting new

 * Do a quick sanity check of number of rows inserted:
*/
select table_name, num_rows 
from v_ust_table_row_count
where ust_control_id = 36
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

ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = 36                 # Enter an integer that is the ust_control_id or release_control_id

 * 
 * This script will output an Excel file (located by default in the repo at 
 * /ust/python/exports/epa_templates/NJ/UST/NJ_UST_template_yyyymmddsssss.xlsx). 
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

ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = 36                 # Enter an integer that is the ust_control_id or release_control_id

 * 
 * This script will output an Excel file (located by default in the repo at 
 * /ust/python/exports/control_table_summaries/NJ/UST/NJ_UST_control_table_summary_yyyymmddsssss.xlsx). 
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
 * 1) Populated EPA template: /ust/python/exports/epa_templates/NJ/UST/NJ_UST_template_yyyymmddsssss.xlsx
 * 2) QAQC file: /ust/python/exports/QAQC/NJ/UST/NJ_UST_QAQC_yyyymmddsssss.xlsx
 * 3) Control table summary file: /ust/python/exports/control_table_summaries/NJ/UST/NJ_UST_control_table_summary_yyyymmddsssss.xlsx
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
--Step 17: Export source data (if necessary)

/* 
 * OUST has requested that ERG make all source data available to them to assist in their review. If the 
 * state sent ERG Excel or CSV files, or a populated EPA template, Victoria will upload the source data to 
 * the EPA Teams site and you can skip this step. If, however, you had to download files from a state website, 
 * or if you retrieved the state data from an API, or if the state sent a database we extracted data from, or 
 * if for any other reason the source data was not uploaded to the EPA Teams site in the 
 * Documents > General > 01 - UST Source Data > NJ > State-Provided Source Data folder, you must export the 
 * tables from the ERG database to CSV files and upload them to the EPA Teams site at
 * Documents > General > 01 - UST Source Data > NJ > ERG Source Data folder. 
 * 
 * To export the source data from the database, run script export_source_data.py
 * 
 * Set these variables in the script: 
 * 
ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = 36                 # Enter an integer that is the ust_control_id or release_control_id
all_tables = True               # Boolean, defaults to True. If True will export all source data tables; if False will only export those referenced in ust_element_mapping or release_element_mapping.
tables_to_exclude = []          # Python list of strings; defaults to empty list. Populate with table names in the organization schema that should be excluded from the export. (NOTE: ERG-created tables will not be exported regardless of the values in this list.)
empty_export_dir = True         # Boolean, defaults to True. If True, will delete all files in the export directory before proceeding. If False, will not delete any files, but will overwrite any that have the same name as the generated file name. 

 * 
 * This script will output a CSV file for each table in the state schema (the default export location is 
 * in the repo at /ust/python/exports/source_data/NJ/UST). 
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