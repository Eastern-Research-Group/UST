------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* NOTES:
 * All Python scripts below are found in the github repo at https://github.com/Eastern-Research-Group/UST,
 * in the /ust/python/state_processing directory. 
 * You can set run variables at the top of the script; usually this will just be:
 * control_id (integer primary key from example.ust_control)
 * ust_or_release (string with values 'ust' or 'release').
 * 
 * 1) Before beginning processing, first do a git pull on the main branch, then create and checkout a 
 *    branch the describes what you are processing, for example, XX-UST, where you will do your work. 
 * 2) Copy this template and do a global replace of XX for the organization_id. Save the script in the 
 *    repo at /ust/sql/states/XX/UST/example.sql (create these folders if necessary)
 * 3) Follow the steps in the template; when prompted to run a Python script, change the variables
 *    at the top of the script before running it. Unless you need to make a bugfix to the Python script,
 *    don't include it in your pull request later. 
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
 * Step 8: Create unique identifiers if they dont' exist
 * Step 9: Write the views that convert the source data to the EPA format
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
organization_id = 'XX'          # Enter the two-character code for the state, or "TRUSTD" for the tribes database 
path = r''                      # Enter the full path to the directory containing the source data file(s) (NOT a path to a specific file)
overwrite_table = False         # Boolean, defaults to False; set to True if you are replacing existing data in the schema

 * Script import_data_file_files.py will create the correct schema (if it doesn't yet exist), 
 * then upload all .xlsx, .xls, .csv, and .txt in the specified directory to this schema. 
 *
 * OR:
 * If you don't want to use the script, or the data was submitted in a different way (API, database dump, etc.),
 * manually upload it to the database, creating schema example if it does not exist.

 * NOTE:
 * If there is old data in the state schema, from a previous submission, you can either simply
 * drop the old tables, or you can rename each of them with a prefix of "OLD_". This makes it obvious
 * which is the current source data to other developers. 

 * Before uploading the new data, you can run this query and use the resulting SQL to do the renames:

select 'alter table ' || table_schema ||  '.' || table_name || ' rename to ' || 'OLD_' || table_name || ';'
from information_schema.tables 
where table_schema = lower('example')
order by table_name;

 * Or to drop the old data:

select 'drop table ' || table_schema ||  '.' || table_name || ';'
from information_schema.tables 
where table_schema = lower('example')
order by table_name;

 */
CREATE TABLE example."Facilities" (
	"Facility ID" varchar(100) NULL,
	"Facility Name" varchar(100) NULL,
	"Address" varchar(100) NULL,
	"City" varchar(100) NULL,
	"Zip Code" int4 NULL,
	"Latitude" float8 NULL,
	"Longitude" float8 NULL,
	"Owner Name" varchar(100) NULL
);
CREATE TABLE example."Tanks" (
	"Facility Id" varchar(100) NULL,
	"Tank Name" varchar(100) NULL,
	"Tank Status Id" int4 NULL,
	"Closure Date" date NULL,
	"Install Date" date NULL,
	"Tank Substance" varchar(100) NULL,
	"Tank Type" varchar(100) NULL
);
CREATE TABLE example."Tank Piping" (
	"Facility Id" varchar(100) NULL,
	"Tank Name" varchar(100) NULL,
	"Piping Material Id" int4 NULL
);
create table example."Dispensers" (
	"Facility Id" varchar(100) NULL, 
	"Tank name" varchar(100) NULL, 
	"UDC" varchar(1) NULL
);
CREATE TABLE example."Tank Status Lookup" (
	"Tank Status ID" int4 NULL,
	"Tank Status Desc" varchar(100) NULL
);
CREATE TABLE example."Piping Material Lookup" (
	"Piping Material ID" int4 NULL,
	"Piping Material Desc" varchar(100) NULL
);
INSERT INTO example."Tank Status Lookup" ("Tank Status ID","Tank Status Desc") VALUES
	 (1,'Open'),
	 (2,'Temporarily Closed'),
	 (3,'Closed');
INSERT INTO example."Piping Material Lookup" ("Piping Material ID","Piping Material Desc") VALUES
	 (1,'Fiberglass Reinforced Plastic'),
	 (2,'Copper'),
	 (3,'Stainless Steel'),
	 (4,'Steel'),
	 (5,'Flex Piping'),
	 (6,'Other');
INSERT INTO example."Facilities" ("Facility ID","Facility Name","Address","City","Zip Code","Latitude","Longitude","Owner Name") VALUES
	 ('ABCD1234','Gomez Gas','123 Main St.','Berkeley',95294,37.871666,-122.272781,'Gomez Gasoline Incorporated'),
	 ('WXYZ8877','Gas Station #1','7654 40th St','Santa Cruz',98765,36.974117,122.030792,'Luna Petrol');
INSERT INTO example."Tanks" ("Facility Id","Tank Name","Tank Status Id","Closure Date","Install Date","Tank Substance","Tank Type") VALUES
	 ('WXYZ8877','C',1,NULL,'2016-03-17','Diesel','AST'),
	 ('ABCD1234','Tank #2',1,NULL,'2000-05-24','Unleaded Gasoline, Antifreeze, Racing Gasoline','UST'),
	 ('ABCD1234','Tank #3',1,NULL,'2018-09-15','Premium Gasoline, Motor Oil','UST'),
	 ('WXYZ8877','A',1,NULL,'1999-11-23','Premium Gasoline, Used Motor Oil','UST'),
	 ('WXYZ8877','B',2,NULL,'2003-11-24','Diesel','UST'),
	 ('ABCD1234','Tank #1',3,'2024-04-13','1978-06-04','Leaded Gasoline','UST');
INSERT INTO example."Tank Piping" ("Facility Id","Tank Name","Piping Material Id") VALUES
	 ('ABCD1234','Tank #1',4),
	 ('ABCD1234','Tank #2',1),
	 ('ABCD1234','Tank #2',3),
	 ('ABCD1234','Tank #2',6),
	 ('ABCD1234','Tank #3',2),
	 ('WXYZ8877','A',6),
	 ('WXYZ8877','B',5),
	 ('WXYZ8877','B',1);
INSERT INTO example."Dispensers" ("Facility Id","Tank name","UDC") VALUES
	 ('ABCD1234','Tank #1','N'),
	 ('ABCD1234','Tank #2','Y'),
	 ('ABCD1234','Tank #3','Y'),
	 ('WXYZ8877','A','Y'),
	 ('WXYZ8877','B','N'),
	 ('WXYZ8877','C','Y');
	
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 2: Update the control table 
/* 
 * Table example.ust_control contains top-level information about the source data. 
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
where table_schema = lower('example') 
and lower(column_name) like '%comp%'
and table_name <> 'ust_control' --[additional where clause just for example schema]
order by table_name, ordinal_position;

/*
 * To insert a new row into the control table: 
 *  
 * EITHER:
 * Run script insert_control.py
 * 
 * Set the following variables at the top of the script:
 
organization_id = 'XX'                  # Enter the two-character code for the state, or "TRUSTD" for the tribes database 
ust_or_release = 'ust'                  # Valid values are 'ust' or 'release'
data_source = ''                        # Describe in detail where data came from (e.g. URL downloaded from, Excel spreadsheets from state, state API URL, etc.)
date_received = 'YYYY-MM-DD'            # Defaults to datetime.today(). To use a date other than today, set as a string in the format of 'yyyy-mm-dd'.
date_processed = None                   # Defaults to datetime.today(). To use a date other than today, set as a string in the format of 'yyyy-mm-dd'.
comments = ''                           # Top-level comments on the dataset. An example would be "Exclude Aboveground Storage Tanks".
organization_compartment_flag = None    # For UST only set to 'Y' if state data includes compartments, 'N' if state data is tank-level only. You can set this later if you don't know.

 * OR:
*/
insert into example.ust_control (organization_id, date_received, data_processed, data_source, comments, organization_compartment_flag)
values ('XX', '2024-09-18', current_date, 'Pseudo data to be used as an example only', 'Example data for element mapping', 'N');
returning ust_control_id;
1

/*
 * Both of the above methods will return the new ust_control_id, but if you need to
 * retrieve it, use the following query:

select max(ust_control_id) from ust_control where state = 'XX;

 * Do a global replace in this script from 1 to the new ust_control_id.
 */
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 3: Get an overview of the source data and prepare it for processing

/* Run this query to see what tables we have: 
*/
select table_name from information_schema.tables 
where table_schema = lower('example') order by 1;

Facilities
Piping Material Lookup
Tank Piping
Tank Status Lookup
Tanks

/*
 * If the table names came from Excel or CSV files and are hard to type and/or contain 
 * unfriendly characters, it's OK to re-name them.
 * You can use the following query to generate SQL to do so. 
  
select 'alter table ' || table_schema || '."' || table_name || '" rename to "NNNNNNNNNNN";'
from information_schema.tables 
where table_schema = lower('example') and table_type = 'BASE TABLE'
order by 1;

 * Check the column names out too:
 */
select table_name, column_name
from information_schema.columns
where table_schema = lower('example') 
order by table_name, ordinal_position;

/* 
 * If any columns have "bad" characters in them, you can use the following 
 * query to generate SQL to change them.
 * In general, try to keep the column names aligned with the source data as
 * much as possible as it will be easier for the states to understand the mapping. 
  
select 'alter table ' || table_schema || '."' || table_name || '" rename column "' || column_name || '" to "NNNNNNNNNNN";'
from information_schema.columns
where table_schema = lower('example') and table_type = 'BASE TABLE'
order by 1;
  
 * NOTE: 
 * The ONLY changes we want to make to the source data is altering table and/or
 * column names to make it easier to query them. Any other manipulation that needs to be
 * done to the source data should be done by writing views or creating ERG_ prefixed tables.  
 */
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 4: Map the source data elements to the EPA template elements 

/* Table example.ust_element_mapping documents the mapping of the source data elements
 * to the EPA template data elements. 
 * Go through each generated SQL statement and do the following:
 * 	1) If there is no matching column in the state's data, delete the SQL statement.
 *  2) If there is a matching column in the state's data, update the ORG_TAB_NAME
 *     and ORG_COL_NAME variables to match the state's data. 
 *  3) If you have questions or comments about the mapping, replace "null" with your 
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
 *  5) Also use the programmer_comments field to enter specifics about the mapping. 
 *     FOR EXAMPLE, say the source data has a single column for Financial Responsibility,
 *     in table "facilities" and column "fr_type", with a list of possible values like
 *     ["credit", "guarantee", "local gov't", "self insurance", "state fund", "other"]. 
 *     Map EPA fields financial_responsibility_obtained,
 * 	   financial_responsibility_letter_of_credit, financial_responsibility_guarantee,
 * 	   financial_responsibility_local_government_financial_test, 
 * 	   financial_responsibility_self_insurance_financial_test, and financial_responsibility_other_method
 *     ALL to state column "fr_type", and set the programmer_comments field as follows:
 *     financial_responsibility_obtained: "if not null then 'Yes'"	      
 * 	   financial_responsibility_letter_of_credit: "if = 'credit' then 'Yes'"	
 *     financial_responsibility_guarantee: "if = 'guarantee' then 'Yes'"	
 *     financial_responsibility_local_government_financial_test: "if = 'local gov't' then 'Yes'"	
 *     financial_responsibility_self_insurance_financial_test: "if = 'self insurance' then 'Yes'"	
 *     financial_responsibility_state_fund: "if = 'state fun' then 'Yes'"
 * 	   financial_responsibility_other_method: "if = 'state fund' then 'Yes'"	
 * After you've adjusted all the SQL statements for elements you are able to map and deleted those
 * you can't, run the SQL statements to perform the inserts.  
 * 
 * The SQL statements below were generated by running this query:
 
select * from example.v_ust_element_summary_sql;

 * It might help you to have another tab open in your database console where you can run queries like the 
 * following to help you do the mapping. FOR EXAMPLE, say you are trying to map EPA field facility_type1. 
 * This query may help you find it in the source data:

select table_name, column_name, data_type
from information_schema.columns 
where lower(table_schema) = 'example' 
and lower(column_name) like '%fac%type%'
order by 1, 2;

 * DO NOT assume that just because a state column name is very similar to or exactly the same as
 * an EPA column that they are the same thing. Before mapping a state element, run some queries to 
 * make sure it actually contains the right data:

--query the EPA lookup table to see what we are looking for, for example:
select * from example.facility_types order by 1;

--then see what the state's data looks like:
select distinct "ORG_COL_NAME"
from example."ORG_TAB_NAME"
order by 1;

 * If the states's values look approximately like EPA's values, it's OK to map. 

 * NOTE: 
 * The SQL statements below assume the state's data is in a relative flat format, e.g. there aren't
 * lookup tables. If the source data contains lookup tables, manipulate the SQL statements below to
 * include columns organization_join_table and organization_join_column. 
 * In this case, set the organization_table_name and organization_column_name to the source LOOKUP TABLE,
 * and set organization_join_table and organization_join_column to the source PARENT TABLE. 
 * For examples of how to do this, run this query:
 * 
select ust_control_id, epa_table_name, epa_column_name, 
	organization_table_name, organization_column_name,
	organization_join_table, organization_join_column
from example.ust_element_mapping
where organization_join_table is not null 
order by 1, 2, 3, 4, 5;

 * NOTE:
 * The SQL statements below also assume the state's data is stored with a single value per cell. 
 * Sometimes states stored multiple values in a single cell, separated by a comma or other separator (if you're lucky...)
 * When examining the state's data with this query:

select distinct "ORG_COL_NAME"
from example."ORG_TAB_NAME"
order by 1;

 * If some rows appear to contain multiple values, you will have to DEAGGREGATE the data. This is most easily done
 * using a Python script written for that purpose and is discussed in the next step. In this step, set the 
 * organization_table_name and organization_column_name to the source data table and column containing the 
 * multiple values. When you get to the next step where you are mapping the values and you run deagg.py to
 * perform the deaggregation, the script will update the deagg_table_name and deagg_column_name columns of
 * example.ust_element_mapping for you. The query below finds examples of how ust_element_mapping eventually gets 
 * populated for these fields. 

select ust_control_id, epa_table_name, epa_column_name, 
	organization_table_name, organization_column_name,
	deagg_table_name, deagg_column_name
from example.ust_element_mapping
where deagg_table_name is not null 
order by 1, 2, 3, 4, 5;

 */

--ust_facility: This table is REQUIRED
--NOTE: facility_id is a required field. If Facility ID does not exist in the source data, STOP and talk to the state. 
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_facility','facility_id','Facilities','Facility ID',null);
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_facility','facility_name','Facilities','Facility Name',null);
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_facility','facility_address1','Facilities','Address',null);
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_facility','facility_city','Facilities','City',null);
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_facility','facility_zip_code','Facilities','Zip Code',null);
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_facility','facility_latitude','Facilities','Latitude',null);
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_facility','facility_longitude','Facilities','Longitude',null);
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_facility','facility_owner_company_name','Facilities','Owner Name',null);

--ust_tank: This table is REQUIRED.
--At a mimimum we need a Tank ID (or Tank Name) and Tank Status. If these fields don't exist in the source data, stop and talk to EPA and/or the state. 
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_tank','facility_id','Tanks','Facility Id',null);
--NOTE: Tank ID is required, but we can create it in a later step as long as Tank Name exists in the source data.
--Tank ID must be an INTEGER (or able to be converted to an integer). 
--If the source data contains a column called Tank ID but it contains alphanumeric values, map it to EPA column tank_name instead of tank_id.
--insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
--values (1,'ust_tank','tank_id','ORG_TAB_NAME','ORG_COL_NAME',null);
--NOTE: Either tank_id or tank_name (or both) must be mapped. Use tank_id for numeric fields and tank_name for alphanumeric/text fields. 
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_tank','tank_name','Tanks','Tank Name',null);
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments,
	organization_join_table, organization_join_column, organization_join_fk) 
values (1,'ust_tank','tank_status_id','Tank Status Lookup','Tank Status Desc', null, 'Tanks','Tank Status Id','Tank Status ID');
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_tank','tank_closure_date','Tanks','Closure Date',null);
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_tank','tank_installation_date','Tanks','Install Date',null);
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_tank','tank_location_id','Tanks','Tank Type','Exclude if = AST');


--ust_tank_substance: This table is OPTIONAL (but most states will have data)
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_tank_substance','facility_id','Tanks','Facility Id',null);
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_tank_substance','tank_name','Tanks','Tank Name',null);
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_tank_substance','substance_id','Tanks','Tank Substance','Source data contains multiple substances per row, delimited with a comma and space.');
--NOTE: States that report at the compartment level will likely have substance data at the compartment level
--This will be tracked in table ust_compartment_substance, but all of the columns in that table will be mapped elsewhere
--so there is no mapping required for that table. 

--ust_compartment: This table is REQUIRED. 
--If the state does not report compartment data, we will be creating a Compartment ID for it in a later step. 
--Look for these data elements in the tank data for states that don't report compartments. 
--Compartment Status is required; copy the Tank Status mapping for Compartment Status data for states 
--that don't report compartments or do report compartments but don't have a separate compartment status. 
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_compartment','facility_id','Tanks','Facility Id',null);
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_compartment','tank_name','Tanks','Facility Id',null);
--NOTE: Compartment Status is a required field. If the state does not report compartments, use the same element mapping as Tank Status
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments,
	organization_join_table, organization_join_column, organization_join_fk) 
values (1,'ust_compartment','compartment_status_id','Tank Status Lookup','Tank Status Desc', 
		'State does not report compartments; copied from Tank Status', 'Tanks','Tank Status Id','Tank Status ID');

--ust_piping: This table is OPTIONAL, do not map if there is no piping data in the source data
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_piping','facility_id','Tanks','Facility Id',null);
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_piping','tank_name','Tanks','Tank Name',null);	
--NOTE: Piping ID is a required field but if there is no INTEGER field in the source data that uniquely identifies each
--piping run per Facility/Tank (non-compartment states) or Facility/Tank/Compartment (compartment states),
--we will be constructing a Piping ID in a later step so don't map it now.
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments,
	organization_join_table, organization_join_column, organization_join_fk) 
values (1,'ust_piping','piping_material_frp','Piping Material Lookup','Piping Material Desc',
        'if "Piping Material Desc" = "Fiberglass Reinforced Plastic" then "Yes"',
       'Tank Piping','Piping Material Id','Piping Material ID');
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments,
	organization_join_table, organization_join_column, organization_join_fk) 
values (1,'ust_piping','piping_material_stainless_steel','Piping Material Lookup','Piping Material Desc',
        'if "Piping Material Desc" = "Stainless Steel" then "Yes"',
       'Tank Piping','Piping Material Id','Piping Material ID');
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments,
	organization_join_table, organization_join_column, organization_join_fk) 
values (1,'ust_piping','piping_material_steel','Piping Material Lookup','Piping Material Desc',
        'if "Piping Material Desc" = "Steel" then "Yes"',
       'Tank Piping','Piping Material Id','Piping Material ID');
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments,
	organization_join_table, organization_join_column, organization_join_fk) 
values (1,'ust_piping','piping_material_copper','Piping Material Lookup','Piping Material Desc',
        'if "Piping Material Desc" = "Copper" then "Yes"',
       'Tank Piping','Piping Material Id','Piping Material ID');
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments,
	organization_join_table, organization_join_column, organization_join_fk) 
values (1,'ust_piping','piping_material_flex','Piping Material Lookup','Piping Material Desc',
        'if "Piping Material Desc" = "Flex Piping" then "Yes"',
       'Tank Piping','Piping Material Id','Piping Material ID');
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments,
	organization_join_table, organization_join_column, organization_join_fk) 
values (1,'ust_piping','piping_material_other','Piping Material Lookup','Piping Material Desc',
        'if "Piping Material Desc" = "Other" then "Yes"',
       'Tank Piping','Piping Material Id','Piping Material ID');

--ust_tank_dispenser: Map and populate this table only if the state stores dispenser data at the Tank level.
--Dispenser data is OPTIONAL.
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_tank_dispenser','facility_id','Dispensers','Facility Id',null);
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_tank_dispenser','tank_name','Dispensers','Tank name',null);
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_tank_dispenser','dispenser_udc','Dispensers','UDC','If "Y" then "Yes"; if "N" then "No"');

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
control_id = 1                  # Enter an integer that is the ust_control_id or release_control_id
only_incomplete = True 			# Boolean, set to True to restrict the output to EPA columns that have not yet been value mapped or False to output mapping for all columns

 * If - and only if - this script identifies possible aggregrated data, it will output SQL file in the repo at
 * /ust/sql/XX/UST/example_deagg.sql). Open the generated file in your database console and step through it.  
 * If no file is produced, proceed to the next step. 
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 6: Map the source data values to EPA values 

/* 
 * Table example.ust_element_value_mapping documents the mapping of the source data element
 * values to EPA's lookup values. 
 * This table needs to be populated for all elements mapped above where the EPA column 
 * has a lookup table. 
 * The following query will tell you which columns you need to perform this exercise for. 
 * (If no rows are returned, make sure you actually ran the SQL statements above after 
 * manipulating them!)

select epa_column_name from 
	(select distinct epa_table_name, epa_column_name, table_sort_order, column_sort_order
	from example.v_ust_needed_mapping 
	where ust_control_id = 1 and mapping_complete = 'N'
	order by table_sort_order, column_sort_order) x;
 
 * To generate the SQL that will assist you in doing the value mapping, run the script 
 * generate_value_mapping.sql. Set the following variables before running the script:
 
ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = 1                 # Enter an integer that is the ust_control_id or release_control_id
only_incomplete = False 		# Boolean, defaults to True. Set to False to output mapping for all columns regardless if mapping was previously done. 

 * 
 * This script will output a SQL file (located by default in the repo at 
 * /ust/sql/XX/UST/example_value_mapping.sql). Open the generated file in your database console 
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
 
ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = 1                 # Enter an integer that is the ust_control_id or release_control_id
  
 * To see the crosswalk views after running the script:

select table_name 
from information_schema.tables 
where table_schema = lower('example') and table_type = 'VIEW'
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

ust_or_release = 'ust' 			 # Valid values are 'ust' or 'release' 
control_id = 1                   # Enter an integer that is the ust_control_id
drop_existing = False 		     # Boolean, defaults to False. Set to True to drop the table if it exists before creating it new.
write_sql = True                 # Boolean, defaults to True. If True, writes a SQL script recording the queries it ran to generate the tables.
overwrite_sql_file = False       # Boolean, defaults to False. Set to True to overwrite an existing SQL file if it exists. This parameter has no effect if write_sql = False. 

 * By default, this script will generate any required ID columns, update the example.ust_element_mapping table,
 * and export a SQL file (located by default in the repo at  /ust/sql/XX/UST/example_id_column_generation.sql).
 * You do NOT need to run the SQL in the generated file, however, if the script encounters errors or if you
 * are unable to write the views in the next step because the script did not correctly create the ID
 * generation tables, you can review this SQL file and make changes as needed to fix the data. If you do
 * need to make changes to generated ID tables, be sure to accurately update example.ust_element_mapping table,
 * including making robust comments in the programmer_comments columns.

*/
--check to see if the script generated any tables 
select epa_table_name, epa_column_name, organization_table_name 
from example.v_ust_element_mapping a join public.ust_template_data_tables b 
	on a.epa_table_name = b.table_name 
where ust_control_id = 1 and organization_table_name like 'erg%'
order by sort_order;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 9: Write the views that convert the source data to the EPA format

/* 
 * Run script create_view_sql.py to create the BASIC STRUCTURE of the views that will be used to
 * populate the templates. 
 * WARNING! The queries generated by the script are a STARTING PLACE for the developers but will 
 * in most cases need to be manually manipulated to correctly select the data. 
 * 
*/

--Remind yourself if there are any state-level business rules you need to take into consideration
--when writing the views (such as excluding AST, for example).
select comments from example.ust_control where ust_control_id = 1;

*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
