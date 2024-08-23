------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* 
 * NOTES:
 * All Python scripts below are found in the github repo at https://github.com/Eastern-Research-Group/UST,
 * in the /ust/python/state_processing directory. 
 * You can set run variables at the top of the script; usually this will just be:
 * control_id (integer primary key from public.ust_control)
 * ust_or_release (string with values 'ust' or 'release').
 * 
 * 1) Before beginning processing, first do a git pull on the main branch, then create and checkout a 
 *    branch the describes what you are processing, for example, XX-UST, where you will do your work. 
 * 2) Copy this template and do a global replace of XX for the organization_id. Save the script in the repo
 *    at /ust/sql/states/XX/UST/XX_UST.sql (create these folders if necessary)
 * 3) Follow the steps in the template; when prompted to run a Python script, change the variables
 *    at the top of the script before running it. Unless you need to make a bugfix to the Python script,
 *    don't include it in your pull request later. 
 * 
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 1: Upload the source data 
/*
 * EITHER:
 * If the data was submitted in the form of an Excel spreadsheet or a CSV/text file,
 * you can run script import_data_file_files.py. To run, set these variables:

organization_id = 'XX' 
# Enter a directory (not a path to a specific file) for ust_path
# Set to None if not applicable
ust_path = 'path\to\folder\containing\source\data\files' 
overwrite_table = False  # Set this to true if you need to re-import the files

 * Script import_data_file_files.py will create the correct schema (if it doesn't yet exist), 
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
where table_schema = lower('XX_ust')
order by table_name;

 * Or to drop the old data:

select 'drop table ' || table_schema ||  '.' || table_name || ';'
from information_schema.tables 
where table_schema = lower('XX_ust')
order by table_name;

**/

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
where table_schema = lower('XX_ust') 
and lower(column_name) like '%comp%'
order by table_name, ordinal_position;

/*
 * To insert a new row into the control table: 
 *  
 * EITHER:
 * Run script insert_control.py
 * 
 * Set the following variables at the top of the script:
 
organization_id = 'XX'
system_type = 'ust'  			 		# Accepted values are 'ust' or 'release'
data_source = '' 						# Describe where data came from (e.g. URL downloaded from, Excel spreadsheets from state, state API URL, etc.)
date_received = 'YYYY-MM-DD' 			# Defaults to datetime.today(). To use a date other than today, set as a string in the format of 'yyyy-mm-dd'.
date_processed = None 					# Defaults to datetime.today(). To use a date other than today, set as a string in the format of 'yyyy-mm-dd'.
comments = None 						# Optional string. Populate as described above	
organization_compartment_flag = None   	# Set to 'Y' if state data includes compartments, 'N' if state data is tank-level only. 

 * OR:

insert into ust_control (organization_id, date_received, data_processed, data_source, comments, organization_compartment_flag)
values ('XX', 'YYYY-MM-DD', current_date, '', '', '');
returning ust_control_id;

 * Both of the above methods will return the new ust_control_id, but if you need to
 * retrieve it, use the following query:

select max(ust_control_id) from ust_control where state = 'XX;

 * Do a global replace in this script from ZZ to the new ust_control_id.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 3: Get an overview of the source data and prepare it for processing

 * Run this query to see what tables we have: 
*/
select table_name from information_schema.tables 
where table_schema = lower('XX_ust') order by 1;

/*
 * If the table names came from Excel or CSV files and are hard to type and/or contain 
 * unfriendly characters, it's OK to re-name them.
 * You can use the following query to generate SQL to do so. 
  
select 'alter table ' || table_schema || '.' || table_name || ' rename to NNNNNNNNNNN;'
from information_schema.tables 
where table_schema = lower('CA_ust') and table_type = 'BASE TABLE'
order by 1;

 * Check the column names out too:
*/
select table_name, column_name
from information_schema.columns
where table_schema = lower('XX_ust') 
order by table_name, ordinal_position;

/* 
 * If any columns have "bad" characters in them, you can use the following 
 * query to generate SQL to change them.
 * In general, try to keep the column names aligned with the source data as
 * much as possible as it will be easier for the states to understand the mapping. 
  
select 'alter table ' || table_schema || '.' || table_name || ' rename column ' || column_name || ' to NNNNNNNNNNN;'
from information_schema.columns
where table_schema = lower('CA_ust') and table_type = 'BASE TABLE'
order by 1;
  
 * NOTE: 
 * The ONLY changes we want to make to the source data is altering table and/or
 * column names to make it easier to query them. Any other manipulation that needs to be
 * done to the source data should be done by writing views or creating ERG_ prefixed tables.  
*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 4: 

select table_name 
from public.ust_element_table_sort_order
order by sort_order;





------------------------------------------------------------------------------------------------------------------------------------------------------------------------
