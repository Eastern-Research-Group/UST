------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Update the control table 

--the script above returned a new ust_control_id of 11 for this dataset:
select * from public.ust_control where ust_control_id = 18;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Upload the state data 
/* 
script import_data_file_files.py will create the correct schema (if it doesn't yet exist), 
then upload all .xlsx, .xls, .csv, and .txt in the specified directory to this schema. 
To run, set these variables:

organization_id = 'CA' 
# Enter a directory (not a path to a specific file) for ust_path and ust_path
# Set to None if not applicable
ust_path = 'C:\Users\renae\Documents\Work\repos\ERG\UST\ust\sql\states\CA\Releases' 
overwrite_table = False 

*/

select 'alter table ca_ust.' || table_name || ' rename to ' || 'OLD_' || table_name || ';'
from information_schema.tables where table_schema = 'ca_ust';

alter table ca_ust.ca_ust_geocoded rename to OLD_ca_ust_geocoded;
alter table ca_ust.permitted_ust rename to OLD_permitted_ust;
alter table ca_ust.permitted_ust_tanks rename to OLD_permitted_ust_tanks;
alter table ca_ust.substance_xwalk rename to OLD_substance_xwalk;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Get an overview of what the state's data looks like. In this case, we have two tables 
select table_name from information_schema.tables 
where table_schema = 'ca_ust' and table_name not like 'old%'
order by 1;
/*
facility
tank
*/

--now let's look at the data in each table to get an overview:
select * from ca_ust.facility;

select * from ca_ust.tank;

--see what columns exist in the state's data 
select table_name, column_name, is_nullable, data_type, character_maximum_length 
from information_schema.columns 
where table_schema = 'ca_ust' and table_name = 'facility' 
order by ordinal_position;

select table_name, column_name, is_nullable, data_type, character_maximum_length 
from information_schema.columns 
where table_schema = 'ca_ust' and table_name = 'tank' 
--and column_name like ' %'
order by ordinal_position;

alter table ca_ust.tank rename column " CERS TankID"  to "CERS TankID";

--it might be helpful to create some indexes on the state data 
--(you can also do this as you go along in the processing and find the need to do do)
create index facilities_facid_idx on ca_ust.facility("CERS ID");
create index tanks_facid_idx on ca_ust.tank("CERS ID");
create index tanks_tankid_idx on ca_ust.tank("CERS TankID");


------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--get the EPA tables that we need to populate
select table_name
from public.ust_element_table_sort_order
order by sort_order;
/*
ust_facility
ust_tank
ust_tank_substance
ust_compartment
ust_compartment_substance
ust_piping
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Start with the first table, ust_facility 
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
select * from ca_ust.facility;

--run queries looking for lookup table values 
select distinct "UST Facility Type" from ca_ust.facility;
/*
Processor
Motor Vehicle Fueling
Other
Farm
Fuel Distribution
 */

--!!! update the control table to note that CA doesn't have compartment-level data
update ust_control set organization_compartment_data_flag = 'N' where ust_control_id = 18;



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
where table_schema = 'ca_ust' order by table_name, ordinal_position;
*/

select table_name, column_name from information_schema.columns
where table_schema = 'ca_ust'
and table_name = 'tank'
order by table_name, ordinal_position ;

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_facility','facility_id','facility','CERS ID','Use CERS ID instead of Facility ID per state; latter is not always populated');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_facility','facility_name','facility','Facility Name',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_facility','facility_type1','facility','UST Facility Type',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_facility','facility_address1','facility','Facility Street Address',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_facility','facility_city','facility','Facility City',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_facility','facility_zip_code','facility','Facility_ZIP Code',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_facility','facility_tribal_site','facility','Indian or _Trust Land',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_facility','facility_latitude','facility','Latitude_Measure',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_facility','facility_longitude','facility','Longitude Measure',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_facility','facility_owner_company_name','facility','Organization Name','Please verify if this is the owner name');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_facility','financial_responsibility_obtained','facility','','If at least one of the FR columns is not null, set to Yes');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_facility','financial_responsibility_commercial_insurance','facility','Insurance',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_facility','financial_responsibility_guarantee','facility','Guarantee',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_facility','financial_responsibility_letter_of_credit','facility','Letter of _Credit',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_facility','financial_responsibility_local_government_financial_test','facility','Local_Government_Mechanism',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_facility','financial_responsibility_self_insurance_financial_test','facility','Self-_Insured',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_facility','financial_responsibility_state_fund','facility','State Fund _and _CFO letter',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_facility','financial_responsibility_state_fund','facility','State Fund _and _CD',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_facility','financial_responsibility_surety_bond','facility','Surety_Bond',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_facility','financial_responsibility_other_method','facility','Other',null);

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_tank','tank_id','tank','CERS TankID',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_tank','tank_name','tank','Tank ID # ',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_tank','tank_status_id','tank','Type of Action','Not all state values apply');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_tank','airport_hydrant_system','tank','Tank Use','Only if state value = "Airport Hydrant System"');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_tank','tank_closure_date','tank','Date UST _Permanently _Closed',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_tank','tank_installation_date','tank','Date UST _System _Installed',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_tank','compartmentalized_ust','tank','Tank _Configuration',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_tank','number_of_compartments','tank','Number of _Compartments _in the Unit',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_tank','tank_material_description_id','tank','Tank Primary _Containment _Construction',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_tank','tank_corrosion_protection_sacrificial_anode','tank','Sacrificial_Anode',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_tank','tank_corrosion_protection_impressed_current','tank','Impressed_Current',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_tank','tank_corrosion_protection_other','tank','Isolation',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_tank','tank_secondary_containment_id','tank','Tank Secondary _Containment _Construction ',null);

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_tank_substance','substance_id','tank','Tank Contents ',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_tank_substance','substance_id','tank','Specify _Other _Petroleum',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_tank_substance','substance_id','tank','Specify _Other _Non-Petroleum',null);

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_compartment','compartment_capacity_gallons','tank','Tank _Capacity _In Gallons',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_compartment','overfill_prevention_ball_float_valve','tank','Ball Float',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_compartment','overfill_prevention_flow_shutoff_device','tank','Fill Tube _Shut-Off _Valve',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_compartment','overfill_prevention_high_level_alarm','tank','Audible/_Visual _Alarms',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_compartment','overfill_prevention_not_required','tank','Exempt',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_compartment','spill_bucket_installed','tank','Spill Bucket _Installed',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_compartment','tank_automatic_tank_gauging_release_detection','tank','Automatic _Tank _Gauging',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_compartment','automatic_tank_gauging_continuous_leak_detection','tank','Continuous _Electronic _Tank Monitoring',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_compartment','tank_manual_tank_gauging','tank','Weekly_Manual _Tank Gauge',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_compartment','tank_statistical_inventory_reconciliation','tank','Monthly Statistical _Inventory _Reconciliation',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_compartment','tank_tightness_testing','tank','Tank _Integrity _Testing','please confirm this is the correct mapping');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_compartment','tank_other_release_detection','tank','Other_Monitoring',null);

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_piping','piping_style_id','tank','Piping_System Type',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_piping','piping_material_frp','tank','Primary_Containment_Construction',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_piping','piping_material_steel','tank','Primary_Containment_Construction',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_piping','piping_material_flex','tank','Primary_Containment_Construction',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_piping','piping_material_other','tank','Primary_Containment_Construction',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_piping','piping_material_unknown','tank','Primary_Containment_Construction',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_piping','pipe_tank_top_sump','tank','Containment _Sump',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_piping','pipe_tank_top_sump_wall_type_id','tank','Piping/Turbine _Containment _Sump',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_piping','piping_wall_type_id','tank','Piping_Construction',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_piping','pipe_secondary_containment_other','tank','Secondary _Containment _Construction',null);

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_compartment_dispenser','dispenser_udc','tank','Construction_Type',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (18,'ust_compartment_dispenser','dispenser_udc_wall_type','tank','Construction_Material',null);

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--see what columns in which table we need to map
select epa_table_name, epa_column_name
from v_ust_available_mapping 
where ust_control_id = 18
order by table_sort_order, column_sort_order;
/*
ust_facility		facility_type1
ust_tank			tank_status_id
ust_tank			tank_material_description_id
ust_tank			tank_secondary_containment_id
ust_tank_substance	substance_id
ust_tank_substance	substance_id
ust_tank_substance	substance_id
ust_piping			piping_style_id
ust_piping			pipe_tank_top_sump_wall_type_id
ust_piping			piping_wall_type_id
*/

/*
see what mapping hasn't yet been done for this dataset 
we'll be going through each of the results of this query below
so for each value of epa_column_name from this query result, there will be a 
section below where we generate SQL to perform the mapping 
*/
select epa_table_name, epa_column_name 
from 
	(select distinct epa_table_name, epa_column_name, table_sort_order, column_sort_order
	from v_ust_needed_mapping 
	where ust_control_id = 18 and mapping_complete = 'N'
	order by table_sort_order, column_sort_order) x;
/*
ust_facility		facility_type1
ust_tank			tank_status_id
ust_tank			tank_material_description_id
ust_tank			tank_secondary_containment_id
ust_tank_substance	substance_id
ust_piping			piping_style_id
ust_piping			pipe_tank_top_sump_wall_type_id
ust_piping			piping_wall_type_id
*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--facility_type1

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from ca_ust."' || organization_table_name || '" order by 1;'
from v_ust_needed_mapping 
where ust_control_id = 18 and epa_column_name = 'facility_type1';

/*
run the query from the generated sql above to see what the state's data looks like
you are checking to make sure their values line up with what we are looking for on the EPA side
(this should have been done during the element mapping above but you can review it now)
Next, see if the state values need to be deaggregated 
(that is, is there only one value per row in the state data? If not, we need to deaggregate them)
*/
select distinct "UST Facility Type" from ca_ust."facility" order by 1;
/*
Farm
Fuel Distribution
Motor Vehicle Fueling
Other
Processor
*/

/* generate generic sql to insert value mapping rows into ust_element_value_mapping, 
then modify the generated sql with the mapped EPA values 
NOTE: insert a NULL for epa_value if you don't have a good guess 
*/
select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 18 and epa_column_name = 'facility_type1';

--paste the insert_sql from the first row below, then run the query:
select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 1099 || ', ''' || "UST Facility Type" || ''', '''', null);'
from ca_ust."facility" order by 1;

/*paste the generated insert statements from the query above below, then manually update each one to fill in the missing epa_value
if necessary, replace the "null" with any questions or comments you have about the specific mapping */

insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1099, 'Farm', 'Agricultural/farm', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1099, 'Fuel Distribution', 'Bulk plant storage/petroleum distributor', 'please confirm');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1099, 'Motor Vehicle Fueling', 'Retail fuel sales (non-marina)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1099, 'Other', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1099, 'Processor', 'Commercial', 'please confirm');

--list valid EPA values to paste into sql above 
select * from public.facility_types  order by 1;


--to assist with the mapping above, check the archived mapping table for old examples of mapping 
--NOTE! As we continue to map more states, we can check the current mapping table instead of the archive table!
select distinct state_value, epa_value
from archive.v_ust_element_mapping 
where lower(element_name) like lower('%facilitys%')
order by 1, 2;

/*!!! WARNING! Some of the lookups have changed for the new template format, so if you used the 
archive.v_ust_element_mapping and/or archive.v_lust_element_mapping views and copied values 
directly from them, you may have to update them:*/
select distinct epa_value
from ust_element_value_mapping a join ust_element_mapping b on a.ust_element_mapping_id = b.ust_element_mapping_id
where ust_control_id = 18 and epa_column_name = 'facility_type1'
and epa_value not in (select facility_type from facility_types)
order by 1;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--tank_status_id

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from ca_ust."' || organization_table_name || '" order by 1;'
from v_ust_needed_mapping 
where ust_control_id = 18 and epa_column_name = 'tank_status_id';

/*
run the query from the generated sql above to see what the state's data looks like
you are checking to make sure their values line up with what we are looking for on the EPA side
(this should have been done during the element mapping above but you can review it now)
Next, see if the state values need to be deaggregated 
(that is, is there only one value per row in the state data? If not, we need to deaggregate them)
*/
select distinct "Type of Action" from ca_ust."tank" order by 1;

/* generate generic sql to insert value mapping rows into ust_element_value_mapping, 
then modify the generated sql with the mapped EPA values 
NOTE: insert a NULL for epa_value if you don't have a good guess 
*/
select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 18 and epa_column_name = 'tank_status_id';

--paste the insert_sql from the first row below, then run the query:
select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 1130 || ', ''' || "Type of Action" || ''', '''', null);'
from ca_ust."tank" order by 1;

/*paste the generated insert statements from the query above below, then manually update each one to fill in the missing epa_value
if necessary, replace the "null" with any questions or comments you have about the specific mapping */
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1130, 'AST Change to UST', 'Currently in use', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1130, 'Confirmed/Updated Information', 'Currently in use', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1130, 'New Permit', 'Currently in use', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1130, 'Renewal Permit', 'Currently in use', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1130, 'Split Facility', 'Currently in use', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1130, 'Temporary UST Closure', 'Temporarily out of service', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1130, 'UST Change to AST', 'Other', 'Should these rows be excluded?');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1130, 'UST Permanent Closure on Site', 'Closed (in place)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1130, 'UST Removal', 'Closed (removed from ground)', null);

--list valid EPA values to paste into sql above 
select * from public.tank_statuses  order by 1;


--to assist with the mapping above, check the archived mapping table for old examples of mapping 
--NOTE! As we continue to map more states, we can check the current mapping table instead of the archive table!
select distinct state_value, epa_value
from archive.v_ust_element_mapping 
where lower(element_name) like lower('%tankst%')
order by 1, 2;

/*!!! WARNING! Some of the lookups have changed for the new template format, so if you used the 
archive.v_ust_element_mapping and/or archive.v_lust_element_mapping views and copied values 
directly from them, you may have to update them:*/
select distinct epa_value
from ust_element_value_mapping a join ust_element_mapping b on a.ust_element_mapping_id = b.ust_element_mapping_id
where ust_control_id = 18 and epa_column_name = 'tank_status_id'
and epa_value not in (select tank_status from tank_statuses)
order by 1;

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
--compartment_status_id

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from ca_ust."' || organization_table_name || '" order by 1;'
from v_ust_needed_mapping 
where ust_control_id = 18 and epa_column_name = 'compartment_status_id';

/*
run the query from the generated sql above to see what the state's data looks like
you are checking to make sure their values line up with what we are looking for on the EPA side
(this should have been done during the element mapping above but you can review it now)
Next, see if the state values need to be deaggregated 
(that is, is there only one value per row in the state data? If not, we need to deaggregate them)
*/
select distinct "Type of Action" from ca_ust."tank" order by 1;

/* generate generic sql to insert value mapping rows into ust_element_value_mapping, 
then modify the generated sql with the mapped EPA values 
NOTE: insert a NULL for epa_value if you don't have a good guess 
*/
select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 18 and epa_column_name = 'tank_status_id';

--paste the insert_sql from the first row below, then run the query:
select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 1173 || ', ''' || "Type of Action" || ''', '''', null);'
from ca_ust."tank" order by 1;

select * from ust_element_mapping order by 1 desc;

/*paste the generated insert statements from the query above below, then manually update each one to fill in the missing epa_value
if necessary, replace the "null" with any questions or comments you have about the specific mapping */
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1173, 'AST Change to UST', 'Currently in use', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1173, 'Confirmed/Updated Information', 'Currently in use', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1173, 'New Permit', 'Currently in use', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1173, 'Renewal Permit', 'Currently in use', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1173, 'Split Facility', 'Currently in use', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1173, 'Temporary UST Closure', 'Temporarily out of service', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1173, 'UST Change to AST', 'Other', 'Should these rows be excluded?');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1173, 'UST Permanent Closure on Site', 'Closed (in place)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1173, 'UST Removal', 'Closed (removed from ground)', null);

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--tank_material_description_id

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from ca_ust."' || organization_table_name || '" order by 1;'
from v_ust_needed_mapping 
where ust_control_id = 18 and epa_column_name = 'tank_material_description_id';

/*
run the query from the generated sql above to see what the state's data looks like
you are checking to make sure their values line up with what we are looking for on the EPA side
(this should have been done during the element mapping above but you can review it now)
Next, see if the state values need to be deaggregated 
(that is, is there only one value per row in the state data? If not, we need to deaggregate them)
*/
select distinct "Tank Primary _Containment _Construction " from ca_ust."tank" order by 1;
Fiberglass
Internal Bladder
Other
Steel
Steel + Internal Lining
Unknown


/* generate generic sql to insert value mapping rows into ust_element_value_mapping, 
then modify the generated sql with the mapped EPA values 
NOTE: insert a NULL for epa_value if you don't have a good guess 
*/
select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 18 and epa_column_name = 'tank_material_description_id';

select * from ust_element_mapping where ust_element_mapping_id = 1136;
Tank Primary _Containment _Construction

update ust_element_mapping set organization_column_name = 'Tank Primary _Containment _Construction '
where ust_element_mapping_id = 1136;

--paste the insert_sql from the first row below, then run the query:
select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 1136 || ', ''' || "Tank Primary _Containment _Construction " || ''', '''', null);'
from ca_ust."tank" order by 1;

/*paste the generated insert statements from the query above below, then manually update each one to fill in the missing epa_value
if necessary, replace the "null" with any questions or comments you have about the specific mapping */
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1136, 'Fiberglass', 'Fiberglass reinforced plastic', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1136, 'Internal Bladder', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1136, 'Other', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1136, 'Steel', 'Steel (NEC)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1136, 'Steel + Internal Lining', 'Jacketed steel', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1136, 'Unknown', 'Unknown', null);


--list valid EPA values to paste into sql above 
select * from public.tank_material_descriptions  order by 1;

--to assist with the mapping above, check the archived mapping table for old examples of mapping 
--NOTE! As we continue to map more states, we can check the current mapping table instead of the archive table!
select distinct state_value, epa_value
from archive.v_ust_element_mapping 
where lower(element_name) like lower('%tankma%')
order by 1, 2;

/*!!! WARNING! Some of the lookups have changed for the new template format, so if you used the 
archive.v_ust_element_mapping and/or archive.v_lust_element_mapping views and copied values 
directly from them, you may have to update them:*/
select distinct epa_value
from ust_element_value_mapping a join ust_element_mapping b on a.ust_element_mapping_id = b.ust_element_mapping_id
where ust_control_id = 18 and epa_column_name = 'tank_material_description_id'
and epa_value not in (select tank_material_description from tank_material_descriptions)
order by 1;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--tank_secondary_containment_id

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from ca_ust."' || organization_table_name || '" order by 1;'
from v_ust_needed_mapping 
where ust_control_id = 18 and epa_column_name = 'tank_secondary_containment_id';

/*
run the query from the generated sql above to see what the state's data looks like
you are checking to make sure their values line up with what we are looking for on the EPA side
(this should have been done during the element mapping above but you can review it now)
Next, see if the state values need to be deaggregated 
(that is, is there only one value per row in the state data? If not, we need to deaggregate them)
*/
select distinct "Tank Secondary _Containment _Construction " from ca_ust."tank" order by 1;


/* generate generic sql to insert value mapping rows into ust_element_value_mapping, 
then modify the generated sql with the mapped EPA values 
NOTE: insert a NULL for epa_value if you don't have a good guess 
*/
select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 18 and epa_column_name = 'tank_secondary_containment_id';

--paste the insert_sql from the first row below, then run the query:
select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 1140 || ', ''' || "Tank Secondary _Containment _Construction " || ''', '''', null);'
from ca_ust."tank" order by 1;

/*paste the generated insert statements from the query above below, then manually update each one to fill in the missing epa_value
if necessary, replace the "null" with any questions or comments you have about the specific mapping */
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1140, 'Exterior Membrane Liner', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1140, 'Fiberglass', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1140, 'Jacketed', 'Jacketed', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1140, 'Other', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1140, 'Steel', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1140, 'Unknown', 'Unknown', null);

--list valid EPA values to paste into sql above 
select * from public.tank_secondary_containments  order by 1;

--to assist with the mapping above, check the archived mapping table for old examples of mapping 
--NOTE! As we continue to map more states, we can check the current mapping table instead of the archive table!
select distinct state_value, epa_value
from archive.v_ust_element_mapping 
where lower(element_name) like lower('%tankma%')
order by 1, 2;

/*!!! WARNING! Some of the lookups have changed for the new template format, so if you used the 
archive.v_ust_element_mapping and/or archive.v_lust_element_mapping views and copied values 
directly from them, you may have to update them:*/
select distinct epa_value
from ust_element_value_mapping a join ust_element_mapping b on a.ust_element_mapping_id = b.ust_element_mapping_id
where ust_control_id = 18 and epa_column_name = 'tank_secondary_containment_id'
and epa_value not in (select tank_material_description from tank_material_descriptions)
order by 1;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--substance_id

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from ca_ust."' || organization_table_name || '" order by 1;'
from v_ust_needed_mapping 
where ust_control_id = 18 and epa_column_name = 'substance_id';

/*
run the query from the generated sql above to see what the state's data looks like
you are checking to make sure their values line up with what we are looking for on the EPA side
(this should have been done during the element mapping above but you can review it now)
Next, see if the state values need to be deaggregated 
(that is, is there only one value per row in the state data? If not, we need to deaggregate them)
*/


/* generate generic sql to insert value mapping rows into ust_element_value_mapping, 
then modify the generated sql with the mapped EPA values 
NOTE: insert a NULL for epa_value if you don't have a good guess 
*/
select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 18 and epa_column_name = 'substance_id';

--paste the insert_sql from the first row below, then run the query:
select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 1141 || ', ''' || "Tank Contents " || ''', '''', null);'
from ca_ust."tank" order by 1;

select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 1142 || ', ''' || "Specify _Other _Petroleum" || ''', '''', null);'
from ca_ust."tank" order by 1;

delete from ust_element_value_mapping where ust_element_mapping_id in (1142,1143);

select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 1143 || ', ''' || "Specify _Other _Non-Petroleum" || ''', '''', null);'
from ca_ust."tank" order by 1;

/*paste the generated insert statements from the query above below, then manually update each one to fill in the missing epa_value
if necessary, replace the "null" with any questions or comments you have about the specific mapping */
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1141, 'Aviation  Gas', 'Aviation gasoline', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1141, 'Biodiesel 100', '100% biodiesel (B100, not federally regulated)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1141, 'Biodiesel B6  B99', '99.9 percent renewable diesel, 0.01% biodiesel', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1141, 'Diesel', 'Diesel fuel (b-unknown)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1141, 'E85', 'E-85/Flex Fuel (E51-E83)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1141, 'Ethanol', 'Denatured ethanol (98%)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1141, 'Jet Fuel', 'Jet fuel A', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1141, 'Kerosene', 'Kerosene', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1141, 'Midgrade Unleaded', 'Gasoline (unknown type)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1141, 'Other Non-petroleum', 'Other or mixture', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1141, 'Other Petroleum', 'Petroleum product', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1141, 'Petroleum Blend Fuel', 'Heating/fuel oil # unknown', 'please confirm');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1141, 'Premium Unleaded', 'Gasoline (unknown type)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1141, 'Regular Unleaded', 'Gasoline (unknown type)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1141, 'Used Oil', 'Used oil/waste oil', null);


--list valid EPA values to paste into sql above 
select * from public.substances  order by 3, 2;

--to assist with the mapping above, check the archived mapping table for old examples of mapping 
--NOTE! As we continue to map more states, we can check the current mapping table instead of the archive table!
select distinct state_value, epa_value
from archive.v_ust_element_mapping 
where lower(element_name) like lower('%subs%')
order by 1, 2;

/*!!! WARNING! Some of the lookups have changed for the new template format, so if you used the 
archive.v_ust_element_mapping and/or archive.v_lust_element_mapping views and copied values 
directly from them, you may have to update them:*/
select distinct epa_value
from ust_element_value_mapping a join ust_element_mapping b on a.ust_element_mapping_id = b.ust_element_mapping_id
where ust_control_id = 18 and epa_column_name = 'substance_id'
and epa_value not in (select tank_material_description from tank_material_descriptions)
order by 1;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--piping_style_id

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from ca_ust."' || organization_table_name || '" order by 1;'
from v_ust_needed_mapping 
where ust_control_id = 18 and epa_column_name = 'piping_style_id';

/*
run the query from the generated sql above to see what the state's data looks like
you are checking to make sure their values line up with what we are looking for on the EPA side
(this should have been done during the element mapping above but you can review it now)
Next, see if the state values need to be deaggregated 
(that is, is there only one value per row in the state data? If not, we need to deaggregate them)
*/
select distinct "Piping_System Type" from ca_ust."tank" order by 1;


/* generate generic sql to insert value mapping rows into ust_element_value_mapping, 
then modify the generated sql with the mapped EPA values 
NOTE: insert a NULL for epa_value if you don't have a good guess 
*/
select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 18 and epa_column_name = 'piping_style_id';

--paste the insert_sql from the first row below, then run the query:
select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 1161 || ', ''' || "Piping_System Type" || ''', '''', null);'
from ca_ust."tank" order by 1;

/*paste the generated insert statements from the query above below, then manually update each one to fill in the missing epa_value
if necessary, replace the "null" with any questions or comments you have about the specific mapping */
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1161, '23 CCR Â§2636(a)(3) Suction', 'Suction', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1161, 'Conventional Suction', 'Suction', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1161, 'Gravity', 'Non-operational (e.g., fill line, vent line, gravity)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1161, 'Pressure', 'Pressure', null);


--list valid EPA values to paste into sql above 
select * from public.piping_styles  order by 1;

--to assist with the mapping above, check the archived mapping table for old examples of mapping 
--NOTE! As we continue to map more states, we can check the current mapping table instead of the archive table!
select distinct state_value, epa_value
from archive.v_ust_element_mapping 
where lower(element_name) like lower('%tankma%')
order by 1, 2;

/*!!! WARNING! Some of the lookups have changed for the new template format, so if you used the 
archive.v_ust_element_mapping and/or archive.v_lust_element_mapping views and copied values 
directly from them, you may have to update them:*/
select distinct epa_value
from ust_element_value_mapping a join ust_element_mapping b on a.ust_element_mapping_id = b.ust_element_mapping_id
where ust_control_id = 18 and epa_column_name = 'piping_style_id'
and epa_value not in (select tank_material_description from tank_material_descriptions)
order by 1;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--pipe_tank_top_sump_wall_type_id

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from ca_ust."' || organization_table_name || '" order by 1;'
from v_ust_needed_mapping 
where ust_control_id = 18 and epa_column_name = 'pipe_tank_top_sump_wall_type_id';

/*
run the query from the generated sql above to see what the state's data looks like
you are checking to make sure their values line up with what we are looking for on the EPA side
(this should have been done during the element mapping above but you can review it now)
Next, see if the state values need to be deaggregated 
(that is, is there only one value per row in the state data? If not, we need to deaggregate them)
*/
select distinct "Piping/Turbine _Containment _Sump" from ca_ust."tank" order by 1;


/* generate generic sql to insert value mapping rows into ust_element_value_mapping, 
then modify the generated sql with the mapped EPA values 
NOTE: insert a NULL for epa_value if you don't have a good guess 
*/
select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 18 and epa_column_name = 'pipe_tank_top_sump_wall_type_id';

--paste the insert_sql from the first row below, then run the query:
select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 1168 || ', ''' || "Piping/Turbine _Containment _Sump" || ''', '''', null);'
from ca_ust."tank" order by 1;

/*paste the generated insert statements from the query above below, then manually update each one to fill in the missing epa_value
if necessary, replace the "null" with any questions or comments you have about the specific mapping */
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1168, 'Double-walled', 'Double', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1168, 'Single-walled', 'Single', null);

--list valid EPA values to paste into sql above 
select * from public.pipe_tank_top_sump_wall_types  order by 1;

--to assist with the mapping above, check the archived mapping table for old examples of mapping 
--NOTE! As we continue to map more states, we can check the current mapping table instead of the archive table!
select distinct state_value, epa_value
from archive.v_ust_element_mapping 
where lower(element_name) like lower('%tankma%')
order by 1, 2;

/*!!! WARNING! Some of the lookups have changed for the new template format, so if you used the 
archive.v_ust_element_mapping and/or archive.v_lust_element_mapping views and copied values 
directly from them, you may have to update them:*/
select distinct epa_value
from ust_element_value_mapping a join ust_element_mapping b on a.ust_element_mapping_id = b.ust_element_mapping_id
where ust_control_id = 18 and epa_column_name = 'pipe_tank_top_sump_wall_type_id'
and epa_value not in (select tank_material_description from tank_material_descriptions)
order by 1;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--piping_wall_type_id

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from ca_ust."' || organization_table_name || '" order by 1;'
from v_ust_needed_mapping 
where ust_control_id = 18 and epa_column_name = 'piping_wall_type_id';

/*
run the query from the generated sql above to see what the state's data looks like
you are checking to make sure their values line up with what we are looking for on the EPA side
(this should have been done during the element mapping above but you can review it now)
Next, see if the state values need to be deaggregated 
(that is, is there only one value per row in the state data? If not, we need to deaggregate them)
*/
select distinct "Piping_Construction" from ca_ust."tank" order by 1;


/* generate generic sql to insert value mapping rows into ust_element_value_mapping, 
then modify the generated sql with the mapped EPA values 
NOTE: insert a NULL for epa_value if you don't have a good guess 
*/
select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 18 and epa_column_name = 'piping_wall_type_id';

--paste the insert_sql from the first row below, then run the query:
select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 1169 || ', ''' || "Piping_Construction" || ''', '''', null);'
from ca_ust."tank" order by 1;

/*paste the generated insert statements from the query above below, then manually update each one to fill in the missing epa_value
if necessary, replace the "null" with any questions or comments you have about the specific mapping */
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1169, 'Double-walled', 'Double walled', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1169, 'Other', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1169, 'Single-walled', 'Single walled', null);

--list valid EPA values to paste into sql above 
select * from public.piping_wall_types  order by 1;

--to assist with the mapping above, check the archived mapping table for old examples of mapping 
--NOTE! As we continue to map more states, we can check the current mapping table instead of the archive table!
select distinct state_value, epa_value
from archive.v_ust_element_mapping 
where lower(element_name) like lower('%tankma%')
order by 1, 2;

/*!!! WARNING! Some of the lookups have changed for the new template format, so if you used the 
archive.v_ust_element_mapping and/or archive.v_lust_element_mapping views and copied values 
directly from them, you may have to update them:*/
select distinct epa_value
from ust_element_value_mapping a join ust_element_mapping b on a.ust_element_mapping_id = b.ust_element_mapping_id
where ust_control_id = 18 and epa_column_name = 'piping_wall_type_id'
and epa_value not in (select tank_material_description from tank_material_descriptions)
order by 1;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--check if there is any more mapping to do
select distinct epa_table_name, epa_column_name
from v_ust_needed_mapping 
where ust_control_id = 18 and mapping_complete = 'N'
order by 1, 2;


select * from v_ust_element_mapping where ust_control_id = 18;

delete from ust_element_mapping where ust_element_mapping_id in (1142,1143)

--check if any of the mapping is bad:
select database_lookup_table, epa_value 
from v_ust_bad_mapping 
where ust_control_id = 18 order by 1, 2;
--!!!if there are results from this query, fix them!!!

--if not, it's time to write the queries that manipulate the state's data into EPA's tables 



------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*Step 1: create crosswalk views for columns that use a lookup table
run script org_mapping_xwalks.py to create crosswalk views for all lookup tables 
see new views:*/
select table_name 
from information_schema.tables 
where table_schema = 'ca_ust' and table_type = 'VIEW'
and table_name like '%_xwalk' order by 1;
/*
Created view ca_ust.v_facility_type_xwalk
Created view ca_ust.v_tank_status_xwalk
Created view ca_ust.v_tank_material_description_xwalk
Created view ca_ust.v_tank_secondary_containment_xwalk
Created view ca_ust.v_substance_xwalk
Created view ca_ust.v_piping_style_xwalk
Created view ca_ust.v_pipe_tank_top_sump_wall_type_xwalk
Created view ca_ust.v_piping_wall_type_xwalk
*/

CREATE OR REPLACE VIEW ca_ust.v_compartment_status_xwalk
AS SELECT a.organization_value,
    a.epa_value,
    b.compartment_status_id
   FROM v_ust_element_mapping a
     LEFT JOIN compartment_statuses  b ON a.epa_value::text = b.compartment_status::text
  WHERE a.ust_control_id = 18 AND a.epa_column_name::text = 'compartment_status_id'::text;


--Step 2: see the EPA tables we need to populate, and in what order
select distinct epa_table_name, table_sort_order
from v_ust_table_population 
where ust_control_id = 18
order by table_sort_order;
/*
ust_facility
ust_tank
ust_tank_substance
ust_compartment
ust_piping
ust_compartment_dispenser
*/

/*Step 3: check if there where any dataset-level comments you need to incorporate:
in this case we need to ignore the aboveground storage tanks,
so add this to the where clause of the ust_release view */
select comments from ust_control where ust_control_id = 18;

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
where ust_control_id = 18 and epa_table_name = 'ust_facility'
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
drop view  ca_ust.v_ust_facility ;
create or replace view ca_ust.v_ust_facility as 
select distinct 
	"CERS ID"::character varying(50) as facility_id,
	"Facility Name"::character varying(100) as facility_name,
	ft.facility_type_id as facility_type1,
	"Facility Street Address"::character varying(100) as facility_address1,
	"Facility City"::character varying(100) as facility_city,
	"Facility_ZIP Code"::character varying(10) as facility_zip_code,
	'CA' as facility_state,
	9 as facility_epa_region,
	"Indian or _Trust Land"::character varying(3) as facility_tribal_site,
	"Latitude_Measure"::double precision as facility_latitude,
	"Longitude Measure"::double precision as facility_longitude,
	"Organization Name"::character varying(100) as facility_owner_company_name,
	case when "Insurance" = 'Yes' or "Guarantee" = 'Yes' or "Letter of _Credit" = 'Yes' 
		or "Local_Government_Mechanism" = 'Yes' or "Self-_Insured" = 'Yes' or "State Fund _and _CFO letter" = 'Yes'
		or "State Fund _and _CD" = 'Yes' or "Surety_Bond"= 'Yes' or "Other" = 'Yes' then 'Yes'
		end as financial_responsibility_obtained,
	"Insurance"::character varying(3) as financial_responsibility_commercial_insurance,
	"Guarantee"::character varying(3) as financial_responsibility_guarantee,
	"Letter of _Credit"::character varying(3) as financial_responsibility_letter_of_credit,
	"Local_Government_Mechanism"::character varying(3) as financial_responsibility_local_government_financial_test,
	"Self-_Insured"::character varying(3) as financial_responsibility_self_insurance_financial_test,
	case when "State Fund _and _CFO letter" = 'Yes' or "State Fund _and _CD" = 'Yes' then 'Yes'
		 when "State Fund _and _CFO letter" = 'No' or "State Fund _and _CD" = 'No' then 'No' end as financial_responsibility_state_fund,
	"Surety_Bond"::character varying(3) as financial_responsibility_surety_bond,
	"Other"::character varying(500) as financial_responsibility_other_method
from ca_ust.facility x 
	left join ca_ust.v_facility_type_xwalk ft on x."UST Facility Type" = ft.organization_value;


--review: 
select * from ca_ust.v_ust_facility;
select count(*) from ca_ust.v_ust_facility;
--14949
--------------------------------------------------------------------------------------------------------------------------
--now repeat for each data table:

--ust_tank 
select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, data_type, character_maximum_length,
	programmer_comments, database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 18 and epa_table_name = 'ust_tank'
order by column_sort_order;

/*be sure to do select distinct if necessary!
NOTE: ADD facility_id::character varying(50)!!!!
NOTE: tank_id (integer) is a required field - if the state data does not contain an integer field
      that uniquely identifies the tank, you must generate one (see Compartments below for how to do this).
*/

select * from ust_element_mapping where ust_control_id = 18 and epa_column_name = 'tank_id'
update ust_element_mapping set epa_column_name = 'tank_name' where ust_element_mapping_id = 1128;

create table ca_ust.erg_tank_id (
facility_id varchar(50) not null,
tank_name varchar(50) not null, 
tank_id int generated always as identity);

insert into ca_ust.erg_tank_id 
select distinct "CERS ID"::character varying(50) as facility_id,
	"CERS TankID"::character varying(50)
	from ca_ust.tank;
	
drop view ca_ust.v_ust_tank;
create or replace view ca_ust.v_ust_tank as 
select distinct 
	"CERS ID"::character varying(50) as facility_id,
	t.tank_id as tank_id,
	"CERS TankID"::character varying(50) as tank_name,
	tank_status_id as tank_status_id,
	case when "Tank Use" = 'Airport Hydrant System' then 'Yes' end as airport_hydrant_system,
	"Date UST _Permanently _Closed"::date as tank_closure_date,
	"Date UST _System _Installed"::date as tank_installation_date,
	case when "Tank _Configuration" = 'One in a Compartmented Unit' then 'Yes' 
	     when  "Tank _Configuration" = 'A Stand-alone Tank' then 'No' end as compartmentalized_ust,
	"Number of _Compartments _in the Unit"::integer as number_of_compartments,
	tank_material_description_id as tank_material_description_id,
	"Sacrificial_Anode"::character varying(7) as tank_corrosion_protection_sacrificial_anode,
	"Impressed_Current"::character varying(7) as tank_corrosion_protection_impressed_current,
	"Isolation"::character varying(7) as tank_corrosion_protection_other,
	tank_secondary_containment_id as tank_secondary_containment_id
from ca_ust.tank x 
	join ca_ust.erg_tank_id t on x."CERS ID"::varchar(50) = t.facility_id and x."CERS TankID"::varchar(50) = t.tank_name
	left join ca_ust.v_tank_status_xwalk ts on x."Type of Action" = ts.organization_value
	left join ca_ust.v_tank_material_description_xwalk md on x."Tank Primary _Containment _Construction " = md.organization_value
	left join ca_ust.v_tank_secondary_containment_xwalk sc on x."Tank Secondary _Containment _Construction " = sc.organization_value;


select organization_table_name, organization_column_name, 
	   organization_join_table, 
       organization_join_column, organization_join_fk, 
       organization_join_column2, organization_join_fk2, 
       organization_join_column3, organization_join_fk3,
       ust_element_mapping_id
from v_ust_element_mapping_joins 
where ust_control_id = 18 and epa_column_name = 'tank_id'
1175

update ust_element_mapping 
set organization_join_table = 'tank',
	organization_join_column2 = 'CERS TankID',
	organization_join_fk2 = 'tank_name',
	organization_join_column = 'facility_id',
	organization_join_fk = 'CERS TankID'
where ust_element_mapping_id = 1175;


select * from ca_ust.v_tank_status_xwalk;

select * from ust_element_mapping where ust_control_id = 18 and organization_column_name = 'Type of Action';

update ust_element_value_mapping set epa_value = 'Other' where  ust_element_mapping_id in (1130,1173);

delete from ust_element_value_mapping  where  ust_element_mapping_id in (1130,1173);

select * from tank_statuses 

select * from ust_element_mapping where ust_control_id = 18 and organization_column_name = 'Tank _Configuration';

update ust_element_mapping set programmer_comments = 'if "Tank Use" = ''Airport Hydrant System'' then ''Yes''' where ust_element_mapping_id = 1131;
update ust_element_mapping set programmer_comments = 'if "Tank _Configuration" = ''One in a Compartmented Unit'' then ''Yes'', if "Tank _Configuration" = ''A Stand-alone Tank'' then ''No''' where ust_element_mapping_id = 1134;



select distinct "Tank _Configuration" from ca_ust.tank;

select * from ca_ust.v_ust_tank;
select count(*) from ca_ust.v_ust_tank;
--43145

--------------------------------------------------------------------------------------------------------------------------
--ust_tank_substance

select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, data_type, character_maximum_length,
	programmer_comments, database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 18 and epa_table_name = 'ust_tank_substance'
order by column_sort_order;

/*be sure to do select distinct if necessary!
NOTE: ADD facility_id::character varying(50) and tank_id::int!!!!
*/
drop view ca_ust.v_ust_tank_substance;
create or replace view ca_ust.v_ust_tank_substance as 
select distinct 
	"CERS ID"::character varying(50) as facility_id,
	t.tank_id as tank_id,
	sx.substance_id as substance_id
from ca_ust.tank x 
	join ca_ust.erg_tank_id t on x."CERS ID"::varchar(50) = t.facility_id and x."CERS TankID"::varchar(50) = t.tank_name
	left join ca_ust.v_substance_xwalk sx on x."Tank Contents " = sx.organization_value
where x."Tank Contents " is not null; 

select * from ca_ust.v_ust_tank_substance;
select count(*) from ca_ust.v_ust_tank_substance;
--43145

--------------------------------------------------------------------------------------------------------------------------
--ust_compartment
select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, data_type, character_maximum_length,
	programmer_comments, database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 18 and epa_table_name = 'ust_compartment'
order by column_sort_order;

/* be sure to do select distinct if necessary!
NOTE: ADD facility_id::character varying(50) and tank_id::int!!!!
NOTE: compartment_id (integer) is a required field - if the state data does not contain an integer field
      that uniquely identifies the compartment, you must generate one. 
      In this case, the state does not store compartment data, so we will generate the compartment ID
      Prefix any tables you create in the state schema that did not come from the source data with "erg_"! */

create table ca_ust.erg_compartment_id (
facility_id varchar(50) not null,
tank_name varchar(50) not null, 
tank_id int not null, 
compartment_id int generated always as identity);

insert into ca_ust.erg_compartment_id 
select distinct facility_id, tank_name, tank_id
from ca_ust.erg_tank_id;

select * from ust_element_mapping  where ust_control_id = 18 
and epa_column_name like '%tank_status%'

insert into ust_element_mapping (ust_control_id, mapping_date, epa_table_name, epa_column_name, organization_table_name, organization_column_name)
values (18,'2024-08-20','ust_tank','compartment_status_id','tank','Type of Action' );

drop view ca_ust.v_ust_compartment ;
create or replace view ca_ust.v_ust_compartment as 
select distinct 
	"CERS ID"::character varying(50) as facility_id,
	t.tank_id as tank_id,
	t.compartment_id,
	compartment_status_id as compartment_status_id, 
	"Tank _Capacity _In Gallons"::integer as compartment_capacity_gallons,
	"Ball Float"::character varying(7) as overfill_prevention_ball_float_valve,
	"Fill Tube _Shut-Off _Valve"::character varying(7) as overfill_prevention_flow_shutoff_device,
	"Audible/_Visual _Alarms"::character varying(7) as overfill_prevention_high_level_alarm,
	"Exempt"::character varying(7) as overfill_prevention_not_required,
	"Spill Bucket _Installed"::character varying(3) as spill_bucket_installed,
	"Automatic _Tank _Gauging"::character varying(7) as tank_automatic_tank_gauging_release_detection,
	"Continuous _Electronic _Tank Monitoring"::character varying(7) as automatic_tank_gauging_continuous_leak_detection,
	"Weekly_Manual _Tank Gauge"::character varying(7) as tank_manual_tank_gauging,
	"Monthly Statistical _Inventory _Reconciliation"::character varying(7) as tank_statistical_inventory_reconciliation,
	"Tank _Integrity _Testing"::character varying(7) as tank_tightness_testing,
	"Other_Monitoring"::character varying(7) as tank_other_release_detection
from ca_ust.tank x 
	join ca_ust.erg_compartment_id t on x."CERS ID"::varchar(50) = t.facility_id and x."CERS TankID"::varchar(50) = t.tank_name
	left join ca_ust.v_compartment_status_xwalk cx on x."Type of Action"  = cx.organization_value;
	
select * from ca_ust.v_ust_compartment order by 1, 2, 3;
select count(*) from ca_ust.v_ust_compartment;
--43145

--------------------------------------------------------------------------------------------------------------------------

--ust_piping
select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, programmer_comments, 
	database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 18 and epa_table_name = 'ust_piping'
order by column_sort_order;


create table ca_ust.erg_piping_id (
facility_id varchar(50) not null,
tank_name varchar(50) not null, 
tank_id int not null, 
compartment_id int not null, 
piping_id int generated always as identity);

insert into ca_ust.erg_piping_id 
select distinct facility_id, tank_name, tank_id, compartment_id
from ca_ust.erg_compartment_id;

drop view ca_ust.v_ust_piping;
create or replace view ca_ust.v_ust_piping as 
select distinct 
	"CERS ID"::character varying(50) as facility_id,
	t.tank_id as tank_id,
	t.compartment_id,
	t.piping_id::character varying(50) as piping_id,
	piping_style_id as piping_style_id,
	case when "Primary_Containment_Construction" = 'Fiberglass' then 'Yes' end as piping_material_frp,
	case when "Primary_Containment_Construction" = 'Steel' then 'Yes' end as piping_material_steel,
	case when "Primary_Containment_Construction" = 'Flexible' then 'Yes' end as piping_material_flex,
	case when "Primary_Containment_Construction" = 'Other' then 'Yes' end as piping_material_other,
	case when "Primary_Containment_Construction" = 'Unknown' then 'Yes' end as piping_material_unknown,
	"Containment _Sump"::character varying(7) as pipe_tank_top_sump,
	pipe_tank_top_sump_wall_type_id as pipe_tank_top_sump_wall_type_id,
	piping_wall_type_id as piping_wall_type_id,
	case when "Secondary _Containment _Construction" is not null then 'Yes' end as pipe_secondary_containment_other
from ca_ust.tank x 
	join ca_ust.erg_piping_id t on x."CERS ID"::varchar(50) = t.facility_id and x."CERS TankID"::varchar(50) = t.tank_name
	left join ca_ust.v_piping_style_xwalk ps on x."Piping_System Type" = ps.organization_value
	left join ca_ust.v_pipe_tank_top_sump_wall_type_xwalk tt on x."Piping/Turbine _Containment _Sump" = tt.organization_value
	left join ca_ust.v_piping_wall_type_xwalk wt on x."Piping_Construction"= wt.organization_value
	;

select * from ust_element_mapping where ust_control_id = 18 and organization_column_name = 'Primary_Containment_Construction'

update ust_element_mapping set programmer_comments = 'if "Primary_Containment_Construction" = ''Fiberglass'' then ''Yes''' where ust_element_mapping_id = 1162;
update ust_element_mapping set programmer_comments = 'if "Primary_Containment_Construction" = ''Steel'' then ''Yes''' where ust_element_mapping_id = 1163;
update ust_element_mapping set programmer_comments = 'if "Primary_Containment_Construction" = ''Flexible'' then ''Yes''' where ust_element_mapping_id = 1164;
update ust_element_mapping set programmer_comments = 'if "Primary_Containment_Construction" = ''Other'' then ''Yes''' where ust_element_mapping_id = 1165;
update ust_element_mapping set programmer_comments = 'if "Primary_Containment_Construction" = ''Unknown'' then ''Yes''' where ust_element_mapping_id = 1166;

select distinct "Secondary _Containment _Construction" from ca_ust.tank ;

select * from ca_ust.v_piping_style_xwalk;
	
select * from ca_ust.v_ust_compartment order by 1, 2, 3;
select count(*) from ca_ust.v_ust_compartment;
--43145
--------------------------------------------------------------------------------------------------------------------------

create table ca_ust.erg_dispenser_id (
facility_id varchar(50) not null,
tank_name varchar(50) not null, 
tank_id int not null, 
compartment_id int not null, 
dispenser_id int generated always as identity);

insert into ca_ust.erg_dispenser_id 
select distinct facility_id, tank_name, tank_id, compartment_id
from ca_ust.erg_compartment_id;


--ust_compartment_dispenser
select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, programmer_comments, 
	database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 18 and epa_table_name = 'ust_compartment_dispenser'
order by column_sort_order;

select * from information_schema.columns 
where table_schema = 'public' and column_name = 'piping_id'

drop view ca_ust.v_ust_compartment_dispenser;
create or replace view ca_ust.v_ust_compartment_dispenser as 
select distinct 
	"CERS ID"::character varying(50) as facility_id,
	t.tank_id as tank_id,
	t.compartment_id,
	t.dispenser_id::character varying(50) as dispenser_id,
	case when "Construction_Type" in ('Single-walled', 'Double-walled') then 'Yes' 
	    when  "Construction_Type" = 'No Dispensers' then 'No' end as dispenser_udc,
	dispenser_udc_wall_type_id as dispenser_udc_wall_type_id
from ca_ust.tank x 
	join ca_ust.erg_dispenser_id t on x."CERS ID"::varchar(50) = t.facility_id and x."CERS TankID"::varchar(50) = t.tank_name
	left join ca_ust.v_dispenser_udc_wall_type_xwalk wt on x."Construction_Type" = wt.organization_value
	where "Construction_Type"  is not null 
	;

select * From ca_ust.v_ust_compartment_dispenser

-- ca_ust.v_pipe_tank_top_sump_wall_type_xwalk source

CREATE OR REPLACE VIEW ca_ust.v_dispenser_udc_wall_type_xwalk
AS SELECT a.organization_value,
    a.epa_value,
    b.dispenser_udc_wall_type_id
   FROM v_ust_element_mapping a
     LEFT JOIN dispenser_udc_wall_types b ON a.epa_value::text = b.dispenser_udc_wall_type::text
  WHERE a.ust_control_id = 18 AND a.epa_column_name::text = 'dispenser_udc_wall_type'::text;
 
 update ust_element_mapping set programmer_comments = 'if "Construction_Type" in (''Single-walled'', ''Double-walled'') then ''Yes'', if "Construction_Type" = ''No Dispensers'' then ''No'''
 where ust_element_mapping_id = 1172;
 
select * From ust_element_mapping where ust_control_id = 18 and epa_column_name like 'dispenser_udc%'

select * from ust_element_value_mapping where ust_element_mapping_id = 1172;

insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value)
values (1172, 'Single-walled', 'Single');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value)
values (1172, 'Double-walled', 'Double');

update ust_element_mapping set epa_column_name = 'dispenser_udc_wall_type_id' where ust_element_mapping_id = 1172

select distinct "Construction_Type" from ca_ust.tank ;

select * from dispenser_udc_wall_types 

select * from ca_ust.v_piping_style_xwalk;
	
update ust_element_mapping set organization_column_name = 'Construction_Type' where ust_element_mapping_id = 1172;

select * from ca_ust.v_ust_compartment_dispenser order by 1, 2, 3;
select count(*) from ca_ust.v_ust_compartment_dispenser;
--43141

--------------------------------------------------------------------------------------------------------------------------

--QA/QC

--check that you didn't miss any columns when creating the data population views:
--if any rows are returned by this query, fix the appropriate view by adding the missing columns!

select epa_table_name, epa_column_name, 
	organization_table_name, organization_column_name, 
	organization_join_table, organization_join_column, 
	deagg_table_name, deagg_column_name
from v_ust_missing_view_mapping a
where ust_control_id = 18
order by 1, 2;
ust_compartment_dispenser	dispenser_udc_wall_type	tank	Construction_Type

select * from ust_element_mapping order by 1 desc;

update ust_element_mapping set programmer_comments = 'if "Construction_Type" in (''Single-walled'', ''Double-walled'') then ''Yes'', if "Construction_Type" = ''No Dispensers'' then ''No'''
where ust_element_mapping_id = 1171;

update ust_element_mapping set programmer_comments =null
where ust_element_mapping_id = 1172;


select distinct epa_column_name, epa_value, database_lookup_table, database_column_name 
from public.v_ust_element_mapping a join public.ust_elements b on a.epa_column_name = b.database_column_name 
where ust_control_id = 18 and epa_table_name =  and epa_value is not null
order by 1, 2, 3

update ust_element_mapping set epa_table_name = 'ust_compartment'
where ust_element_mapping_id = 1173;



delete from ust_element_mapping where ust_element_mapping_id = 1172;
delete from ust_element_mapping where ust_element_mapping_id = 1129;

--run Python QA/QC script

/*run script qa_check.py
set variables:
ust_or_release = 'ust' 
control_id = 18
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

The script will also provide the counts of rows in ca_ust.v_ust_facility, ca_ust.v_ust_tank, ca_ust.v_ust_compartment, and
   ca_ust.v_ust_piping (if these views exist) - ensure these counts make sense! 
   
The script will export a QAQC spreadsheet (in additional to printing to the screen and logs). If there are errors, re-write the views above, 
then re-run the qa script, and proceed when all errors have been resolved. */

--------------------------------------------------------------------------------------------------------------------------
--insert data into the EPA schema 

/*run script populate_epa_data_tables.py	
set variables:
ust_or_release = 'ust' 
control_id = 18
delete_existing = False # can set to True if there is existing UST data you need to delete before inserting new
*/

--------------------------------------------------------------------------------------------------------------------------
--Quick sanity check of number of rows inserted:
select table_name, num_rows 
from v_ust_table_row_count
where ust_control_id = 18 
order by sort_order;
/*
ust_facility	14949
ust_tank	43145
ust_tank_substance	43145
ust_compartment	43145
ust_piping	43145
ust_compartment_dispenser	43141
*/
	
--------------------------------------------------------------------------------------------------------------------------
--export template

/*run script export_template.py
set variables:
control_id = 18
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
control_id = 18
ust_or_release = 'ust' 
organization_id = None  	# Can leave as None if you specify the control_id
export_file_path = None 	# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_dir = None		# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_name = None		# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo*/

--------------------------------------------------------------------------------------------------------------------------