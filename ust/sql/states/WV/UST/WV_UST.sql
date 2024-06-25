------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Update the control table 

--EITHER:
--use insert_control.py to insert into public.ust_control
--OR:
insert into ust_control (organization_id, date_received, data_source, comments)
values ('WV', '2024-06-21', 'Two xls files downloaded from https://apps.dep.wv.gov/tanks/public/Pages/USTReports.aspx', null)
returning ust_control_id;
11

--the script above returned a new ust_control_id of 11 for this dataset:
select * from public.ust_control where ust_control_id = 11;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Upload the state data 
/* 
EITHER:
script import_data_file_files.py will create the correct schema (if it doesn't yet exist), 
then upload all .xlsx, .xls, .csv, and .txt in the specified directory to this schema. 
To run, set these variables:

organization_id = 'WV' 
# Enter a directory (not a path to a specific file) for ust_path and ust_path
# Set to None if not applicable
# ust_path = None # r'C:\Users\erguser\OneDrive - Eastern Research Group\Projects\UST\State Data\WV\UST'
ust_path = 'C:\Users\renae\Documents\Work\repos\ERG\UST\ust\sql\states\WV\Releases' 
overwrite_table = False 

OR:
manually in the database, create schema wv_ust if it does not exist, then manually upload the state data
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Get an overview of what the state's data looks like. In this case, we have two tables 
select table_name from information_schema.tables 
where table_schema = 'wv_ust' order by 1;
/*
WVDEP.USTLUSTReports_AllFacilitiesDetailsPublic
WVDEP.USTLUSTReports_FOIA-USTTanksPublic
*/

/*these are bad table names, so let's rename them - remember that the only things we want to alter
in the state data are bad table and column names that will make it hard for us to write our SQL */
alter table wv_ust."WVDEP.USTLUSTReports_AllFacilitiesDetailsPublic" rename to facilities;
alter table wv_ust."WVDEP.USTLUSTReports_FOIA-USTTanksPublic" rename to tanks;

--now let's look at the data:
select * from wv_ust.facilities;

select * from wv_ust.tanks;

--The facilities table looks OK, but the tanks table has a bad column name, so let's rename it:
alter table wv_ust.tanks rename column "Facility#" to "Facility ID";

--see what columns exist in the state's data 
select table_name, column_name, is_nullable, data_type, character_maximum_length 
from information_schema.columns 
where table_schema = 'wv_ust' and table_name = 'facilities' 
order by ordinal_position;

select table_name, column_name, is_nullable, data_type, character_maximum_length 
from information_schema.columns 
where table_schema = 'wv_ust' and table_name = 'tanks' 
order by ordinal_position;


--it might be helpful to create some indexes on the state data 
--(you can also do this as you go along in the processing and find the need to do do)
create index facilities_facid_idx on wv_ust.facilities("Facility Id");
create index facilities_status_idx on wv_ust.facilities("Facility Status");
create index facilities_type_idx on wv_ust.facilities("Facility Type");

create index tanks_facid_idx on wv_ust.tanks("Facility ID");
create index tanks_tankid_idx on wv_ust.tanks("Tank Id");
create index tanks_material_idx on wv_ust.tanks("Material");
create index tanks_status_idx on wv_ust.tanks("Tank Status");
create index tanks_substance_idx on wv_ust.tanks("Substance");

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--get the EPA tables that we need to populate
select table_name
from public.ust_element_table_sort_order
order by sort_order;
/*
ust_facility
ust_tank
ust_compartment
ust_piping
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Start with the first table, ust_release 
--get the EPA columns we need to look for in the state data 
select database_column_name 
from ust_elements a join ust_elements_tables b on a.element_id = b.element_id
where table_name = 'ust_facility' 
order by sort_order;
/*
facility_id
facility_name
owner_type_id
facility_type1
facility_type2
facility_address1
facility_address2
facility_city
facility_county
facility_zip_code
facility_state
facility_epa_region
facility_tribal_site
facility_tribe
facility_latitude
facility_longitude
coordinate_source_id
facility_owner_company_name
facility_operator_company_name
financial_responsibility_obtained
financial_responsibility_bond_rating_test
financial_responsibility_commercial_insurance
financial_responsibility_guarantee
financial_responsibility_letter_of_credit
financial_responsibility_local_government_financial_test
financial_responsibility_risk_retention_group
financial_responsibility_self_insurance_financial_test
financial_responsibility_state_fund
financial_responsibility_surety_bond
financial_responsibility_trust_fund
financial_responsibility_other_method
ust_reported_release
associated_ust_release_id
dispenser_id
dispenser_udc
dispenser_udc_wall_type
*/

--review state facility data 
select * from wv_ust.facilities;

--run queries looking for lookup table values 
select distinct "Facility Type" from wv_ust.facilities;

select distinct "Active Tanks Construction" from wv_ust.facilities;
--looking at the "active tanks construction", it looks like there are multiple values for some rows,
--somewhat challengingly not separated by a delimiter - we'll have to figure out how to deal with this later 

select distinct "Active Pipes Construction" from wv_ust.facilities;
--looking at the "active tanks construction", it looks like there are multiple values for some rows,
--somewhat challengingly not separated by a delimiter - we'll have to figure out how to deal with this later 

select distinct "Facility Status" from wv_ust.facilities;

--review state tank data
--WV does not store data at the compartment level, so some of this data will go into EPA's compartment table 
select * from wv_ust.tanks;

--run queries looking for lookup table values 
select distinct "Material" from wv_ust.tanks;

select distinct "Installed" from wv_ust.tanks;

select distinct "Tank Status" from wv_ust.tanks;
--looking at the tank statuses, I see some rows appear to have multiple values separated by a hard return 
--we'll need to remember to deaggregate these values later

select distinct "Substance" from wv_ust.tanks;
--looking at the substances, I see some rows appear to have multiple values separated by a hard return 
--we'll need to remember to deaggregate these values later

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Generate SQL statements to do the inserts into ust_element_mapping. 
Run the query below, paste the results into your console, then do a global replace of 11 for the ust_control_id 
Next, go through each generated SQL statement and do the following:
If there is no matching column in the state's data, delete the SQL statement 
If there is a matching column in the state's data, update the tanks and ORG_COL_NAME variables to match the state's data 
If you have questions or comments, replace the "null" with your comment. 
After you have updated all the SQL statements, run them to update the database. 
*/
select * from public.v_ust_element_summary_sql;

/*you can run this SQL so you can copy and paste table and column names into the SQL statements generated by the query above
select table_name, column_name from information_schema.columns 
where table_schema = 'wv_ust' order by table_name, ordinal_position;
*/

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (11,'ust_facility','facility_id','facilities','Facility Id',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (11,'ust_facility','facility_name','facilities','Facility Name',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments)
values (11,'ust_facility','owner_type_id','facilities','Owner Type',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (11,'ust_facility','facility_type1','facilities','Facility Type',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (11,'ust_facility','facility_address1','facilities','Address',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (11,'ust_facility','facility_city','facilities','City',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (11,'ust_facility','facility_county','facilities','County',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (11,'ust_facility','facility_zip_code','facilities','Zip',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (11,'ust_facility','facility_owner_company_name','facilities','Owner Name',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (11,'ust_tank','facility_id','tanks','Facility ID',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (11,'ust_tank','tank_id','tanks','Tank Id',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (11,'ust_tank','tank_status_id','tanks','Tank Status',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (11,'ust_tank','federally_regulated','tanks','Regulated',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (11,'ust_tank','tank_closure_date','tanks','Closed',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (11,'ust_tank','tank_installation_date','tanks','Installed',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (11,'ust_tank','compartmentalized_ust','tanks','Compartments','This is an integer; set to Yes if > 1');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (11,'ust_tank','number_of_compartments','tanks','Compartments',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (11,'ust_tank','tank_material_description_id','tanks','Material',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (11,'ust_compartment','facility_id','tanks','Facility ID',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (11,'ust_compartment','tank_id','tanks','Tank Id',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (11,'ust_compartment','compartment_status_id','tanks','Tank Status',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (11,'ust_compartment','substance_id','tanks','Substance',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (11,'ust_compartment','compartment_capacity_gallons','tanks','Capacity',null);


------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--see what columns in which table we need to map
select epa_table_name, epa_column_name
from v_ust_available_mapping 
where ust_control_id = 11;

/*
see what mapping hasn't yet been done for this dataset 
we'll be going through each of the results of this query below
so for each value of epa_column_name from this query result, there will be a 
section below where we generate SQL to perform the mapping 
*/
select distinct epa_table_name, epa_column_name
from v_ust_needed_mapping 
where ust_control_id = 11 and mapping_complete = 'N'
order by 1, 2;
/*
ust_compartment	substance_id
ust_facility	facility_type1
ust_facility	owner_type_id
ust_tank		tank_material_description_id
ust_tank		tank_status_id
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--facility_type1

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from wv_ust."' || organization_table_name || '" order by 1;'
from v_ust_needed_mapping 
where ust_control_id = 11 and epa_column_name = 'facility_type1';

/*
run the query from the generated sql above to see what the state's data looks like
you are checking to make sure their values line up with what we are looking for on the EPA side
(this should have been done during the element mapping above but you can review it now)
Next, see if the state values need to be deaggregated 
(that is, is there only one value per row in the state data? If not, we need to deaggregate them)
*/
select distinct "Facility Type" from wv_ust.facilities order by 1;
/*
AIR TAXI (AIRLINE)
AIRCRAFT OWNER
AUTO DEALERSHIP
COAL MINE
COMMERCIAL
CONSTRUCTION COMPANY
CONTRACTOR
FARM
FEDERAL GOVERNMENT
FEDERAL MILITARY
FEDERAL NON-MILITARY
GAS STATION
GOLF COURSE
HOSPITAL
INDUSTRIAL
LOCAL GOVERNMENT
NOT LISTED
OTHER
PETROLEUM DISTRIBUTOR
PUBLIC SCHOOL
RAILROAD
RESIDENTIAL
STATE GOVERNMENT
TRUCK/TRANSPORTER
UTILITIES
*/

--in this case there is only one value per row so we can begin mapping 

/*
 * generate generic sql to insert value mapping rows into ust_element_value_mapping, 
then modify the generated sql with the mapped EPA values 
NOTE: insert a NULL for epa_value if you don't have a good guess 
NOTE: if the organization_value is one that should exclude the facility/tank from UST Finder
      (e.g. a non-federally regulated substance), manually modify the generated sql to 
       include column exclude_from_query and set the value to 'Y'
*/
select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 11 and epa_column_name = 'facility_type1';

--paste the insert_sql from the first row below, then run the query:
select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 82 || ', ''' || "Facility Type" || ''', '''', null);'
from wv_ust."facilities" order by 1;
 
/*paste the generated insert statements from the query above below, then manually update each one to fill in the missing epa_value
if necessary, replace the "null" with any questions or comments you have about the specific mapping */

insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (82, 'AIR TAXI (AIRLINE)', 'Aviation/airport (non-rental car)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (82, 'AIRCRAFT OWNER', 'Aviation/airport (non-rental car)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (82, 'AUTO DEALERSHIP', 'Auto dealership/auto maintenance & repair', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (82, 'COAL MINE', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (82, 'COMMERCIAL', 'Commercial', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (82, 'CONSTRUCTION COMPANY', 'Contractor', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (82, 'CONTRACTOR', 'Contractor', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (82, 'FARM', 'Agricultural/farm', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (82, 'FEDERAL GOVERNMENT', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (82, 'FEDERAL MILITARY', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (82, 'FEDERAL NON-MILITARY', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (82, 'GAS STATION', 'Retail fuel sales (non-marina)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (82, 'GOLF COURSE', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (82, 'HOSPITAL', 'Hospital (or other medical)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (82, 'INDUSTRIAL', 'Industrial', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (82, 'LOCAL GOVERNMENT', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (82, 'NOT LISTED', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (82, 'OTHER', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (82, 'PETROLEUM DISTRIBUTOR', 'Bulk plant storage/petroleum distributor', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (82, 'PUBLIC SCHOOL', 'School', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (82, 'RAILROAD', 'Railroad', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (82, 'RESIDENTIAL', 'Residential', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (82, 'STATE GOVERNMENT', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (82, 'TRUCK/TRANSPORTER', 'Trucking/transport/fleet operation', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (82, 'UTILITIES', 'Utility', null);


--list valid EPA values to paste into sql above 
select * from public.facility_types  order by 1;
/*
Agricultural/farm
Auto dealership/auto maintenance & repair
Aviation/airport (non-rental car)
Bulk plant storage/petroleum distributor
Commercial 
Contractor
Hospital (or other medical)
Industrial
Marina
Railroad
Rental Car
Residential
Retail fuel sales (non-marina)
School
Telecommunication facility
Trucking/transport/fleet operation
Utility
Wholesale
Other
Unknown
*/


--to assist with the mapping above, check the archived mapping table for old examples of mapping 
--NOTE! As we continue to map more states, we can check the current mapping table instead of the archive table!
select distinct state_value, epa_value
from archive.v_ust_element_mapping 
where lower(element_name) like lower('%facilitytype%')
order by 1, 2;


/*!!! WARNING! Some of the lookups have changed for the new template format, so if you used the 
archive.v_ust_element_mapping and/or archive.v_lust_element_mapping views and copied values 
directly from them, you may have to update them:*/
select distinct epa_value
from ust_element_value_mapping a join ust_element_mapping b on a.ust_element_mapping_id = b.ust_element_mapping_id
where ust_control_id = 11 and epa_column_name = 'facility_type1'
and epa_value not in (select facility_type from facility_types)
order by 1;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--owner_type_id

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from wv_ust."' || organization_table_name || '" order by 1;'
from v_ust_needed_mapping 
where ust_control_id = 11 and epa_column_name = 'owner_type_id';

/*
run the query from the generated sql above to see what the state's data looks like
you are checking to make sure their values line up with what we are looking for on the EPA side
(this should have been done during the element mapping above but you can review it now)
Next, see if the state values need to be deaggregated 
(that is, is there only one value per row in the state data? If not, we need to deaggregate them)
*/
select distinct "Owner Type" from wv_ust."facilities" order by 1;
/*
Company
County
Federal
Individual
Municipality
State
*/

--in this case there is only one value per row so we can begin mapping 

/*
 * generate generic sql to insert value mapping rows into ust_element_value_mapping, 
then modify the generated sql with the mapped EPA values 
NOTE: insert a NULL for epa_value if you don't have a good guess 
NOTE: if the organization_value is one that should exclude the facility/tank from UST Finder
      (e.g. a non-federally regulated substance), manually modify the generated sql to 
       include column exclude_from_query and set the value to 'Y'
*/
select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 11 and epa_column_name = 'owner_type_id';

--paste the insert_sql from the first row below, then run the query:
select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 81 || ', ''' || "Owner Type" || ''', '''', null);'
from wv_ust."facilities" order by 1;
 
/*paste the generated insert statements from the query above below, then manually update each one to fill in the missing epa_value
if necessary, replace the "null" with any questions or comments you have about the specific mapping */

insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (81, 'Company', 'Commercial', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (81, 'County', 'Local Government', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (81, 'Federal', 'Federal Government - Non Military', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (81, 'Individual', 'Private', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (81, 'Municipality', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (81, 'State', 'State Government - Non Military', null);

--list valid EPA values to paste into sql above 
select * from public.owner_types  order by 1;
/*
Federal Government - Non Military
State Government - Non Military
Tribal Governernment
Local Government
Commercial
Private
Military
Other
*/

--to assist with the mapping above, check the archived mapping table for old examples of mapping 
--NOTE! As we continue to map more states, we can check the current mapping table instead of the archive table!
select distinct state_value, epa_value
from archive.v_ust_element_mapping 
where lower(element_name) like lower('%owner%')
order by 1, 2;


/*!!! WARNING! Some of the lookups have changed for the new template format, so if you used the 
archive.v_ust_element_mapping and/or archive.v_lust_element_mapping views and copied values 
directly from them, you may have to update them:*/
select distinct epa_value
from ust_element_value_mapping a join ust_element_mapping b on a.ust_element_mapping_id = b.ust_element_mapping_id
where ust_control_id = 11 and epa_column_name = 'owner_type_id'
and epa_value not in (select owner_type from owner_types)
order by 1;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--tank_status_id

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from wv_ust."' || organization_table_name || '" order by 1;'
from v_ust_needed_mapping 
where ust_control_id = 11 and epa_column_name = 'tank_status_id';

/*
run the query from the generated sql above to see what the state's data looks like
you are checking to make sure their values line up with what we are looking for on the EPA side
(this should have been done during the element mapping above but you can review it now)
Next, see if the state values need to be deaggregated 
(that is, is there only one value per row in the state data? If not, we need to deaggregate them)
*/
select distinct "Tank Status" from wv_ust."tanks" order by 1;
/*
Abandoned
Currently In Use
Currently In Use
Temporarily Out of Service
Permanently Out of Service
Temporarily Out of Service
*/
--in this case there appears to be some rows where there are multiple statuses separated by a hard return 
--let's examine the rows where that is the case 
select * from wv_ust."tanks" where "Tank Status" like 'Currently In Use%Temporarily Out of Service'
--this query returns 9 rows. For now I am going to assume these tanks are Currently In Use, but I will make a note 
--to ask the state about this. 

/*
 * generate generic sql to insert value mapping rows into ust_element_value_mapping, 
then modify the generated sql with the mapped EPA values 
NOTE: insert a NULL for epa_value if you don't have a good guess 
NOTE: if the organization_value is one that should exclude the facility/tank from UST Finder
      (e.g. a non-federally regulated substance), manually modify the generated sql to 
       include column exclude_from_query and set the value to 'Y'
*/
select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 11 and epa_column_name = 'tank_status_id';

--paste the insert_sql from the first row below, then run the query:
select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 90 || ', ''' || "Tank Status" || ''', '''', null);'
from wv_ust."tanks" order by 1;

/*paste the generated insert statements from the query above below, then manually update each one to fill in the missing epa_value
if necessary, replace the "null" with any questions or comments you have about the specific mapping */

insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (90, 'Abandoned', 'Abandoned', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (90, 'Currently In Use', 'Currently in use', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (90, 'Currently In Use
Temporarily Out of Service', 'Currently in use', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (90, 'Permanently Out of Service', 'Closed (general)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (90, 'Temporarily Out of Service', 'Temporarily out of service', null);

--list valid EPA values to paste into sql above 
select * from public.tank_statuses  order by 1;
/*
Currently in use
Temporarily out of service
Closed (removed from ground)
Closed (in place)
Closed (general)
Abandoned
Other
Unknown
*/

--to assist with the mapping above, check the archived mapping table for old examples of mapping 
--NOTE! As we continue to map more states, we can check the current mapping table instead of the archive table!
select distinct state_value, epa_value
from archive.v_ust_element_mapping 
where lower(element_name) like lower('%tankstat%')
order by 1, 2;

/*!!! WARNING! Some of the lookups have changed for the new template format, so if you used the 
archive.v_ust_element_mapping and/or archive.v_lust_element_mapping views and copied values 
directly from them, you may have to update them:*/
select distinct epa_value
from ust_element_value_mapping a join ust_element_mapping b on a.ust_element_mapping_id = b.ust_element_mapping_id
where ust_control_id = 11 and epa_column_name = 'tank_status_id'
and epa_value not in (select tank_status from tank_statuses)
order by 1;


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--tank_material_description_id

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from wv_ust."' || organization_table_name || '" order by 1;'
from v_ust_needed_mapping 
where ust_control_id = 11 and epa_column_name = 'tank_material_description_id';

/*
run the query from the generated sql above to see what the state's data looks like
you are checking to make sure their values line up with what we are looking for on the EPA side
(this should have been done during the element mapping above but you can review it now)
Next, see if the state values need to be deaggregated 
(that is, is there only one value per row in the state data? If not, we need to deaggregate them)
*/
select distinct "Material" from wv_ust."tanks" order by 1;
/*
Carbon Steel Fiberglass Jacket
Composite
Composite (Fiberglass/polyurethane-coated)
Composite (Steel w/FRP or Epoxy Coating)
Epoxy Coated Steel
Fiberglass Reinforced Plastic
Not Listed
Other
Polyethylene Tank Jacket
Steel
UnKnown
*/

/*
generate generic sql to insert value mapping rows into ust_element_value_mapping, 
then modify the generated sql with the mapped EPA values 
NOTE: insert a NULL for epa_value if you don't have a good guess 
NOTE: if the organization_value is one that should exclude the facility/tank from UST Finder
      (e.g. a non-federally regulated substance), manually modify the generated sql to 
       include column exclude_from_query and set the value to 'Y'
*/
select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 11 and epa_column_name = 'tank_material_description_id';

--paste the insert_sql from the first row below, then run the query:
select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 96 || ', ''' || "Material" || ''', '''', null);'
from wv_ust."tanks" order by 1;

/*paste the generated insert statements from the query above below, then manually update each one to fill in the missing epa_value
if necessary, replace the "null" with any questions or comments you have about the specific mapping */
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (96, 'Carbon Steel Fiberglass Jacket', 'Composite/clad (steel w/fiberglass reinforced plastic)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (96, 'Composite', 'Composite/clad (steel w/fiberglass reinforced plastic)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (96, 'Composite (Fiberglass/polyurethane-coated)', 'Composite/clad (steel w/fiberglass reinforced plastic)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (96, 'Composite (Steel w/FRP or Epoxy Coating)', 'Composite/clad (steel w/fiberglass reinforced plastic)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (96, 'Epoxy Coated Steel', 'Epoxy coated steel', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (96, 'Fiberglass Reinforced Plastic', 'Fiberglass reinforced plastic', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (96, 'Not Listed', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (96, 'Other', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (96, 'Polyethylene Tank Jacket', 'Jacketed steel', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (96, 'Steel', 'Steel (NEC)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (96, 'UnKnown', 'Unknown', null);

--list valid EPA values to paste into sql above 
select * from public.tank_material_descriptions  order by 1;
/*
Fiberglass reinforced plastic
Asphalt coated or bare steel
Composite/clad (steel w/fiberglass reinforced plastic)
Epoxy coated steel
Coated and cathodically protected steel
Cathodically protected steel (without coating)
Jacketed steel
Steel (NEC)
Concrete
Other
Unknown
*/

--to assist with the mapping above, check the archived mapping table for old examples of mapping 
--NOTE! As we continue to map more states, we can check the current mapping table instead of the archive table!
select distinct state_value, epa_value
from archive.v_ust_element_mapping 
where lower(element_name) like lower('%material%')
order by 1, 2;

/*!!! WARNING! Some of the lookups have changed for the new template format, so if you used the 
archive.v_ust_element_mapping and/or archive.v_lust_element_mapping views and copied values 
directly from them, you may have to update them:*/
select distinct epa_value
from ust_element_value_mapping a join ust_element_mapping b on a.ust_element_mapping_id = b.ust_element_mapping_id
where ust_control_id = 11 and epa_column_name = 'tank_material_description_id'
and epa_value not in (select tank_material_description from tank_material_descriptions)
order by 1;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--compartment_status_id

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from wv_ust."' || organization_table_name || '" order by 1;'
from v_ust_needed_mapping 
where ust_control_id = 11 and epa_column_name = 'compartment_status_id';

/*
run the query from the generated sql above to see what the state's data looks like
you are checking to make sure their values line up with what we are looking for on the EPA side
(this should have been done during the element mapping above but you can review it now)
Next, see if the state values need to be deaggregated 
(that is, is there only one value per row in the state data? If not, we need to deaggregate them)
*/
select distinct "Tank Status" from wv_ust."tanks" order by 1;
/*
Abandoned
Currently In Use
Currently In Use
Temporarily Out of Service
Permanently Out of Service
Temporarily Out of Service
*/
--in this case there appears to be some rows where there are multiple statuses separated by a hard return 
--let's examine the rows where that is the case 
select * from wv_ust."tanks" where "Tank Status" like 'Currently In Use%Temporarily Out of Service'
--this query returns 9 rows. For now I am going to assume these tanks are Currently In Use, but I will make a note 
--to ask the state about this. 

/*
 * generate generic sql to insert value mapping rows into ust_element_value_mapping, 
then modify the generated sql with the mapped EPA values 
NOTE: insert a NULL for epa_value if you don't have a good guess 
NOTE: if the organization_value is one that should exclude the facility/tank from UST Finder
      (e.g. a non-federally regulated substance), manually modify the generated sql to 
       include column exclude_from_query and set the value to 'Y'
*/
select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 11 and epa_column_name = 'compartment_status_id';

--paste the insert_sql from the first row below, then run the query:
select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 113 || ', ''' || "Tank Status" || ''', '''', null);'
from wv_ust."tanks" order by 1;

/*paste the generated insert statements from the query above below, then manually update each one to fill in the missing epa_value
if necessary, replace the "null" with any questions or comments you have about the specific mapping */

insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (113, 'Abandoned', 'Abandoned', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (113, 'Currently In Use', 'Currently in use', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (113, 'Currently In Use
Temporarily Out of Service', 'Currently in use', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (113, 'Permanently Out of Service', 'Closed (general)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (113, 'Temporarily Out of Service', 'Temporarily out of service', null);

--list valid EPA values to paste into sql above 
select * from public.compartment_statuses order by 1;
/*
Currently in use
Temporarily out of service
Closed (removed from ground)
Closed (in place)
Closed (general)
Abandoned
Other
Unknown
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--substance_id

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from wv_ust."' || organization_table_name || '" order by 1;'
from v_ust_needed_mapping 
where ust_control_id = 11 and epa_column_name = 'substance_id';

/*
run the query from the generated sql above to see what the state's data looks like
you are checking to make sure their values line up with what we are looking for on the EPA side
(this should have been done during the element mapping above but you can review it now)
Next, see if the state values need to be deaggregated 
(that is, is there only one value per row in the state data? If not, we need to deaggregate them)
*/
select distinct "Substance" from wv_ust."tanks" order by 1;
/*
This returns rows that have more than one value, separated by a hard return. We are going to have to deaggregate.
Run deagg.py, setting the state table name, state column name, and delimiter 
The script will create a deagg table and return the name of the new table; in this case: erg_substance_deagg
check the contents of the deagg table:*/
select * from wv_ust.erg_substance_deagg order by 2;

--!! update ust_element_mapping with the new deagg_table_name and deagg_column_name, generated by deagg.py
update ust_element_mapping set deagg_table_name = 'erg_substance_deagg', deagg_column_name = 'Substance' 
where ust_control_id = 11 and epa_column_name = 'substance_id';


/*
generate generic sql to insert value mapping rows into ust_element_value_mapping, 
then modify the generated sql with the mapped EPA values 
NOTE: insert a NULL for epa_value if you don't have a good guess 
NOTE: if the organization_value is one that should exclude the facility/tank from UST Finder
      (e.g. a non-federally regulated substance), manually modify the generated sql to 
       include column exclude_from_query and set the value to 'Y'
*/
select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 11 and epa_column_name = 'substance_id';

--paste the insert_sql from the first row below, then run the query:
select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 99 || ', ''' || "Substance" || ''', '''', null);'
from wv_ust."erg_substance_deagg" order by 1;

/*paste the generated insert statements from the query above below, then manually update each one to fill in the missing epa_value
if necessary, replace the "null" with any questions or comments you have about the specific mapping 
NOTE! Some substances, such as DEF, are not federally regulated. 
      In those cases, set the exclude_from_query flag to 'Y' and remember to exclude these rows 
      when construction the view v_ust_substances later. */
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (99, 'AV Gas', 'Aviation gasoline', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (99, 'Biodiesel', 'Diesel fuel (b-unknown)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (99, 'Crude Oil', 'Petroleum product', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments, exclude_from_query) values (99, 'DEF', null, 'Not federally requlated, excluding from template','Y');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (99, 'Diesel', 'Diesel fuel (b-unknown)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (99, 'Diesel-offroad', 'Off-road diesel/dyed diesel', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (99, 'Diesel-onroad', 'Diesel fuel (b-unknown)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (99, 'Diesel-ultra low sulfur', 'Diesel fuel (b-unknown)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (99, 'E85', 'E-85/Flex Fuel (E51-E83)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (99, 'Empty', 'Unknown', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (99, 'Ethanol', 'Ethanol blend gasoline (e-unknown)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (99, 'Ethanol Free', 'Gasoline (non-ethanol)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (99, 'ETHYLENE GLYCOL', 'Antifreeze', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (99, 'Gasohol', 'Ethanol blend gasoline (e-unknown)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (99, 'Gasoline', 'Gasoline (unknown type)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (99, 'Hazardous Substance', 'Hazardous substance', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (99, 'Heating Oil', 'Heating/fuel oil # unknown', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (99, 'Hydraulic Oil', 'Lube/motor oil (new)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (99, 'Jet Fuel', 'Jet fuel A', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (99, 'Kerosene', 'Kerosene', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (99, 'Midgrade Unleaded', 'Gasoline (unknown type)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (99, 'Mixture', 'Other or mixture', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (99, 'Motor Oil', 'Lube/motor oil (new)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (99, 'New Oil', 'Lube/motor oil (new)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (99, 'Not Listed', 'Other or mixture', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (99, 'Other', 'Other or mixture', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (99, 'Premium Unleaded', 'Gasoline (unknown type)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (99, 'Regular Unleaded', 'Gasoline (unknown type)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (99, 'Unknown', 'Unknown', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (99, 'Used Oil', 'Used oil/waste oil', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (99, 'Waste Oil', 'Used oil/waste oil', null);

--list valid EPA values to paste into sql above 
select * from public.substances order by 2;
/*
Aviation biofuel
Aviation gasoline
Biojet (diesel)
Jet fuel A
Jet fuel B
Sustainable aviation fuel/aviation fuel blend
Unknown aviation gas or jet fuel
80% renewable diesel, 20% biodiesel
95% renewable diesel, 5% biodiesel
99.9 percent renewable diesel, 0.01% biodiesel
ASTM D975 diesel (known 100% renewable diesel)
Diesel blend containing 99% to less than 100% biodiesel
Diesel blend containing greater than 20% and less than 99% biodiesel
Diesel blends containing greater than 5% and up to 20% or less biodiesel
Diesel fuel (ASTM D975), can contain 0-5% biodiesel
Diesel fuel (b-unknown)
Diesel fuel (known to contain 0% biodiesel)
Off-road diesel/dyed diesel
Other unlisted blend containing any other mixture of diesel, renewable diesel, or 20% biodiesel or less
Other unlisted blend containing any other mixture of diesel, renewable diesel, or more than 20% biodiesel
E-85/Flex Fuel (E51-E83)
Ethanol blend gasoline (e-unknown)
Gasoline (non-ethanol)
Gasoline (unknown type)
Gasoline E-10 (E1-E10)
Gasoline E-15 (E-11-E15)
Gasoline/ethanol blends E16-E50
Gasoline/ethanol blend containing more than 83% and less than 98% ethanol
Racing fuel
Biofuel/bioheat
Heating oil/fuel oil 1
Heating oil/fuel oil 2
Heating oil/fuel oil 4
Heating oil/fuel oil 5
Heating oil/fuel oil 6
Heating/fuel oil # unknown
Lube/motor oil (new)
Used oil/waste oil
Antifreeze
Denatured ethanol (98%)
Hazardous substance
Kerosene
Marine fuel
Petroleum product
Solvent
Other or mixture
Unknown 
 */

--to assist with the mapping above, check the archived mapping table for old examples of mapping 
--NOTE! As we continue to map more states, we can check the current mapping table instead of the archive table!
select distinct state_value, epa_value
from archive.v_ust_element_mapping 
where lower(element_name) like lower('%substance%')
and lower(state_value) like lower('%biod%')
order by 1, 2;

/*!!! WARNING! Some of the lookups have changed for the new template format, so if you used the 
archive.v_ust_element_mapping and/or archive.v_lust_element_mapping views and copied values 
directly from them, you may have to update them:*/
select distinct epa_value
from ust_element_value_mapping a join ust_element_mapping b on a.ust_element_mapping_id = b.ust_element_mapping_id
where ust_control_id = 11 and epa_column_name = 'substance_id'
and epa_value not in (select substance from substances)
order by 1;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--check if there is any more mapping to do
select distinct epa_table_name, epa_column_name
from v_ust_needed_mapping 
where ust_control_id = 11 and mapping_complete = 'N'
order by 1, 2;

--check if any of the mapping is bad:
select database_lookup_table, epa_value 
from v_ust_bad_mapping 
where ust_control_id = 11 order by 1, 2;
--!!!if there are results from this query, fix them!!!

--if not, it's time to write the queries that manipulate the state's data into EPA's tables 



------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*Step 1: create crosswalk views for columns that use a lookup table
run script org_mapping_xwalks.py to create crosswalk views for all lookup tables 
see new views:*/
select table_name 
from information_schema.tables 
where table_schema = 'wv_ust' and table_type = 'VIEW'
and table_name like '%_xwalk' order by 1;
/*
v_facility_type_xwalk
v_owner_type_xwalk
v_substance_xwalk
v_tank_material_description_xwalk
v_tank_status_xwalk
*/

--Step 2: see the EPA tables we need to populate, and in what order
select distinct epa_table_name, table_sort_order
from v_ust_table_population 
where ust_control_id = 11
order by table_sort_order;
/*
ust_facility
ust_tank
ust_compartment
ust_piping
*/

/*Step 3: check if there where any dataset-level comments you need to incorporate:
in this case we need to ignore the aboveground storage tanks,
so add this to the where clause of the ust_release view */
select comments from ust_control where ust_control_id = 11;

select * from v_ust_table_population;

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
where ust_control_id = 11 and epa_table_name = 'ust_facility'
order by column_sort_order;

/*Step 5: use the information from the queries above to create the view:
!!! NOTE look at the programmer_comments column to adjust the view if necessary
!!! NOTE also sometimes you need to explicitly cast data types so they match the EPA data tables
!!! NOTE also you may get errors related to data conversion when trying to compile the view
    you are creating here. This is good because it alerts you the data you are trying to
    insert is not compatible with the EPA format. Fix these errors before proceeding! 
!!! NOTE: Remember to do "select distinct" if necessary
!!! NOTE: Some states do not include State or EPA Region in their database, but it is generally
    safe for you to insert these yourself, so add them! */
create or replace view wv_ust.v_ust_facility as 
select distinct 
		"Facility Id"::character varying(50) as facility_id,
		"Facility Name"::character varying(100) as facility_name,
		owner_type_id as owner_type_id,
		facility_type_id as facility_type1,
		"Address"::character varying(100) as facility_address1,
		"City"::character varying(100) as facility_city,
		"County"::character varying(100) as facility_county,
		"Zip"::character varying(10) as facility_zip_code,
		'WV' as facility_state,
		3 as facility_epa_region,
		"Owner Name"::character varying(100) as facility_owner_company_name
from wv_ust.facilities x 
	left join wv_ust.v_owner_type_xwalk ot on x."Owner Type" = ot.organization_value 
	left join wv_ust.v_facility_type_xwalk ft on x."Facility Type" = ft.organization_value;


--review: 
select * from wv_ust.v_ust_facility;
select count(*) from wv_ust.v_ust_facility;
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
where ust_control_id = 11 and epa_table_name = 'ust_tank'
order by column_sort_order;

--be sure to do select distinct if necessary!
--NOTE: ADD facility_id::character varying(50)!!!!
create or replace view wv_ust.v_ust_tank as 
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
from wv_ust.tanks x 
	left join wv_ust.v_tank_status_xwalk ts on x."Tank Status" = ts.organization_value 
	left join wv_ust.v_tank_material_description_xwalk md on x."Material" = md.organization_value;

select * from wv_ust.v_ust_tank;
select count(*) from wv_ust.v_ust_tank;
--26302

--------------------------------------------------------------------------------------------------------------------------
--ust_compartment
select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, data_type, character_maximum_length,
	programmer_comments, database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 11 and epa_table_name = 'ust_compartment'
order by column_sort_order;

--be sure to do select distinct if necessary!
--NOTE: ADD facility_id::character varying(50) and tank_id::int OR tank_name::varchar(100)!!!!
create or replace view wv_ust.v_ust_compartment as 
select distinct 
	"Facility ID"::character varying(50) as facility_id, 
	"Tank Id"::int as tank_id,
	compartment_status_id as compartment_status_id,
	substance_id as substance_id,
	"Capacity"::integer as compartment_capacity_gallons
from wv_ust.tanks x 
	 left join wv_ust.v_compartment_status_xwalk cs on x."Tank Status" = cs.organization_value
	 left join wv_ust.v_substance_xwalk s on x."Substance" = s.organization_value;

select * from wv_ust.v_ust_compartment;
select count(*) from wv_ust.v_ust_compartment;
--26302


--------------------------------------------------------------------------------------------------------------------------
--ust_piping
select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, programmer_comments, 
	database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 11 and epa_table_name = 'ust_piping'
order by column_sort_order;

--there is no pipping data for this state, so we will skip this view 
--if we had data, we would have to add facility_id, tank_id AND/OR tank_name, and compartment_id AND/OR compartment_name

--------------------------------------------------------------------------------------------------------------------------

--QA/QC

--check that you didn't miss any columns when creating the data population views:
--if any rows are returned by this query, fix the appropriate view by adding the missing columns!
select epa_table_name, epa_column_name, 
	organization_table_name, organization_column_name, 
	organization_join_table, organization_join_column, 
	deagg_table_name, deagg_column_name
from v_ust_missing_view_mapping a
where ust_control_id = 11
order by 1, 2;

--run Python QA/QC script

/*run script qa_check.py
set variables:
ust_or_release = 'release' 
control_id = 11
export_file_path = None # If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_dir = None	# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_name = None	# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo

This script will check the views you just created in the state schema for the following:
1) Missing views - will check that if you created a child view (for example, v_ust_compartment), that the parent view(s) (for example, v_ust_tank)
   exit. 
2) Counts of child tables that have too few rows (for example, v_ust_compartment should have at least as many rows as v_ust_tank because
   every tank should have at least one compartment). 
3) Missing join columns to parent tables. For example, v_ust_compartment must contain facility_id and tank_id in order to be able to join it
   to its parent tables. 
4) Missing required columns. 
5) Extraneous columns - will check for any columns in the views that don't match a column in the equivalent EPA table. This will help identify
   typos or other errors. 
6) Non-unique rows. To resolve any cases where the counts are greater than 0, check that you did a "select distinct" when creating these views. 
7) Bad data types - will check for columns in the view where either the data type is different than the EPA column, or (for character columns) 
   if the length of the state value is too long to fit into the EPA column. If the data is too long to fit in the EPA column, this may indicate 
   an error in your code or mapping, OR it may mean you need to truncate the state's value to fit the EPA format. 
8) Failed check constraints. 
9) Bad mapping values. To resolve any cases where bad mapping values exist, examine the specific row(s) in public.ust_element_value_mapping 
   and ensure the epa_value exists in the associated lookup table. 

The script will also provide the counts of rows in wv_ust.v_ust_facility, wv_ust.v_ust_tank, wv_ust.v_ust_compartment, and
   wv_ust.v_ust_piping (if these views exist) - ensure these counts make sense! 
   
The script will export a QAQC spreadsheet (in additional to printing to the screen and logs). If there are errors, re-write the views above, 
then re-run the qa script, and proceed when all errors have been resolved. */

--------------------------------------------------------------------------------------------------------------------------
--insert data into the EPA schema 

/*run script populate_epa_data_tables.py	
set variables:
ust_or_release = 'ust' 
control_id = 11
delete_existing = False # can set to True if there is existing UST data you need to delete before inserting new*/

--------------------------------------------------------------------------------------------------------------------------
--export template

/*run script export_template.py
set variables:
control_id = 11
ust_or_release = 'ust' 
organization_id = None  	# Can leave as None if you specify the control_id
data_only = False 			# Set to False to export full template including mapping and reference tabs
template_only = False 		# Set to False to export data and mapping tabs as well as reference tab
export_file_path = None 	# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_dir = None		# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_name = None		# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo*/


--------------------------------------------------------------------------------------------------------------------------