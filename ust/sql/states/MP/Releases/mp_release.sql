select * from public.release_control where release_control_id = 12;


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Upload the state data 
/* 
I copied the data over from MP_UST.mp_ust table and mp_ust_tanks view but filtered on former_lust=Yes. Make sure to load the UST schema first. See ctas statements below.
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

create table mp_releases as select mu.*,'No further action' release_status from MP_UST.mp_ust mu where former_lust = 'YES'; 

select * from mp_releases;

create table mp_release_tanks as select * from MP_UST.mp_ust_tanks  where deq_id in (select deq_id from mp_releases) ; 



select * from public.release_statuses rs 
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

insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (12,'ust_release','facility_id','mp_releases','deq_id',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (12,'ust_release','release_id','mp_releases','deq_id',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (12,'ust_release','site_name','mp_releases','FACILITY NAME',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (12,'ust_release','site_address','mp_releases','VILLAGE','Please verify');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (12,'ust_release','site_city','mp_releases','ISLAND',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (12,'ust_release','county','mp_releases','ISLAND',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (12,'ust_release','facility_type_id','mp_releases','FACILITY TYPE',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (12,'ust_release','latitude','mp_releases','Latitude gearth',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (12,'ust_release','longitude','mp_releases','Longitude gearth',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (12,'ust_release','release_status_id','mp_releases','release_status',null);

------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/*
see what mapping hasn't yet been done for this dataset 
we'll be going through each of the results of this query below
so for each value of epa_column_name from this query result, there will be a 
section below where we generate SQL to perform the mapping 
*/
select distinct epa_table_name, epa_column_name
from v_release_needed_mapping 
where release_control_id = 12 and mapping_complete = 'N'
order by 1, 2;
/*
ust_release	facility_type_id
ust_release	release_status_id
ust_release_cause	cause_id
ust_release_substance	substance_id
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--facility_type_id

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from "' || organization_table_name || '" order by 1;'
from v_release_needed_mapping 
where release_control_id = 12 and epa_column_name = 'facility_type_id';

/*
run the query from the generated sql above to see what the state's data looks like
you are checking to make sure their values line up with what we are looking for on the EPA side
(this should have been done during the element mapping above but you can review it now)
Next, see if the state values need to be deaggregated 
(that is, is there only one value per row in the state data? If not, we need to deaggregate them)
*/
select distinct "proptype" from "spill_reports_all" order by 1;
/*
Agricultural
Commercial
Industrial
Other(See Case File)
Public
Residential
Unknown(See Case File)

*/

--in this case there is only one value per row so we can begin mapping 

/*
 * generate generic sql to insert value mapping rows into release_element_value_mapping, 
then modify the generated sql with the mapped EPA values 
NOTE: insert a NULL for epa_value if you don't have a good guess 
NOTE: if the organization_value is one that should exclude the facility/tank from UST Finder
      (e.g. a non-federally regulated substance), manually modify the generated sql to 
       include column exclude_from_query and set the value to 'Y'
*/
select insert_sql 
from v_release_needed_mapping_insert_sql 
where release_control_id = 12 and epa_column_name = 'facility_type_id';

--paste the insert_sql from the first row below, then run the query:
select distinct 
	'insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 219 || ', ''' || "proptype" || ''', '''', null);'
from sd_release."spill_reports_all" order by 1;


insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (219, 'Agricultural', 'Agricultural/farm', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (219, 'Commercial', 'Commercial', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (219, 'Industrial', 'Industrial', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (219, 'Other(See Case File)', 'Other', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (219, 'Public', 'Other', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (219, 'Residential', 'Residential', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (219, 'Unknown(See Case File)', 'Unknown', null);




------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--release_status_id

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from "' || organization_table_name || '" order by 1;'
from v_release_needed_mapping 
where release_control_id = 12 and epa_column_name = 'release_status_id';

select distinct "status" from "spill_reports_all" order by 1;




select insert_sql 
from v_release_needed_mapping_insert_sql 
where release_control_id = 12 and epa_column_name = 'release_status_id';

select distinct 
	'insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 222 || ', ''' || "status" || ''', '''', null);'
from sd_release."spill_reports_all" order by 1;

/*below I have mapped the ones I can take a reasonable guess at, but I've inserted nulls for the ones I have no idea about 
the state codes are pretty obtuse so I'm not very confident of my mapping on any of them; therefore I've added a "please verify" comment 
for the ones I took a stab at mapping, as well as "MAPPING NEEDED" for those I didn't. This way, when the mapping is exported to
the review template, EPA and the state have a visual indicator that we need their input for all of them. */
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (222, 'C', 'No further action', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (222, 'I', 'Other', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (222, 'I2', 'Other', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (222, 'M', 'Other', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (222, 'NFA', 'No further action', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (222, 'O', 'Other', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (222, 'T', 'Other', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (222, 'W', 'Other', 'Please verify');


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--substance_id

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from "' || organization_table_name || '" order by 1;'
from v_release_needed_mapping 
where release_control_id = 12 and epa_column_name = 'substance_id';

select distinct "material" from "spill_reports_all" order by 1;

select insert_sql 
from v_release_needed_mapping_insert_sql 
where release_control_id = 12 and epa_column_name = 'substance_id';

--paste the insert_sql from the first row below, then run the query:
select distinct 
	'insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 226 || ', ''' || "material" || ''', '''', null);'
from sd_release."spill_reports_all" 
where sor_type = 'UST'
order by 1;

select * from spill_reports_all;

--list valid EPA values to paste into sql above 
select * from public.substances order by 1;

--search for EPA values:
select substance from public.substances 
where lower(substance) like lower('%Other%')
order by 1;

--to assist with the mapping above, check the archived mapping table for old examples of mapping 
--NOTE! As we continue to map more states, we can check the current mapping table instead of the archive table!
--in the case of Substances, you can check both v_lust_element_mapping and v_ust_element_mapping!
select distinct state_value, epa_value from 
	(select state_value, epa_value
	from archive.v_lust_element_mapping 
	where lower(element_name) like '%substance%' 
	union all 
	select state_value, epa_value
	from archive.v_ust_element_mapping 
	where lower(element_name) like '%substance%') x
where lower(state_value) like lower('%white%')
order by 1, 2;

Other or mixture

update release_element_value_mapping
set epa_value = 'Other or mixture' where
release_element_mapping_id = 226 and epa_value = 'Other';
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Antifreeze', 'Antifreeze', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Asphalt Hot Mix', 'Other', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'aviation fuel', 'Aviation gasoline', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Aviation fuel', 'Aviation gasoline', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Aviation Fuel', 'Aviation gasoline', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Aviation Fuel - 87 or 100 octane', 'Aviation gasoline', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'aviation gasoline', 'Aviation gasoline', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Aviation Gasoline', 'Aviation gasoline', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Chromium', 'Hazardous substance', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Cyclohexanone', 'Solvent', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'diesel', 'Diesel fuel (b-unknown)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Diesel', 'Diesel fuel (b-unknown)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Diesel #1', 'Diesel fuel (b-unknown)', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Diesel #2', 'Diesel fuel (b-unknown)', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Diesel #6', 'Diesel fuel (b-unknown)', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'diesel fuel', 'Diesel fuel (b-unknown)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Diesel fuel', 'Diesel fuel (b-unknown)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Diesel Fuel', 'Diesel fuel (b-unknown)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Diesel, Fuel Oil', 'Diesel fuel (b-unknown)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Diesel, Gas, Oil', 'Diesel fuel (b-unknown)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Diesel, Gasoline', 'Diesel fuel (b-unknown)', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Diesel, JP-4 Fuel', 'Jet fuel A', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Diesel, Oil', 'Diesel fuel (b-unknown)', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Diesel, Water', 'Diesel fuel (b-unknown)', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Dyed Diesel', 'Off-road diesel/dyed diesel', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'E-10 Gasoline', 'Gasoline E-10 (E1-E10)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'E-85', 'E-85/Flex Fuel (E51-E83)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Ethanol', 'Ethanol blend gasoline (e-unknown)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Ethanol gas', 'Ethanol blend gasoline (e-unknown)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Fertilizer, Petroleum', 'Other', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'fuel', 'Heating/fuel oil # unknown', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Fuel', 'Heating/fuel oil # unknown', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'fuel oil', 'Heating/fuel oil # unknown', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Fuel oil', 'Heating/fuel oil # unknown', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Fuel Oil', 'Heating/fuel oil # unknown', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Fuel Oil - Kerosene', 'Kerosene', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Fuel Oil #1', 'Heating/fuel oil # unknown', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'fuel oil #2', 'Heating/fuel oil # unknown', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Fuel Oil #2', 'Heating/fuel oil # unknown', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Fuel Oil #6', 'Heating/fuel oil # unknown', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'fuel oil & perc', 'Heating/fuel oil # unknown', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Fuel Oil & Waste Oil', 'Heating/fuel oil # unknown', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Fuel Oil Gas Solvent', 'Heating/fuel oil # unknown', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Fuel Oil Heating', 'Heating/fuel oil # unknown', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Fuel Oil, Gasoline', 'Heating/fuel oil # unknown', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Gasohol', 'Gasoline (unknown type)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'gasoline', 'Gasoline (unknown type)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Gasoline', 'Gasoline (unknown type)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Gasoline & Kerosene', 'Gasoline (unknown type)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Gasoline Leaded', 'Gasoline (unknown type)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Gasoline Odors', 'Gasoline (unknown type)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Gasoline Unleaded', 'Gasoline (unknown type)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Gasoline vapors', 'Gasoline (unknown type)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Gasoline, Fuel Oil', 'Gasoline (unknown type)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Gasoline, Kerosene', 'Gasoline (unknown type)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Gasoline, Oil', 'Gasoline (unknown type)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Gasoline, unleaded', 'Gasoline (unknown type)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Gasoline, Waste Oil', 'Gasoline (unknown type)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Grease, Oil', 'Lube/motor oil (new)', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'heating fuel', 'Heating/fuel oil # unknown', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Heating fuel', 'Heating/fuel oil # unknown', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Heating Fuel', 'Heating/fuel oil # unknown', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'heating oil', 'Heating/fuel oil # unknown', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Heating oil', 'Heating/fuel oil # unknown', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Heating Oil', 'Heating/fuel oil # unknown', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Heavy fuel oil', 'Heating/fuel oil # unknown', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Heavy Fuel Oil', 'Heating/fuel oil # unknown', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Jet A Aviation Fuel', 'Jet fuel A', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'jet fuel', 'Unknown aviation gas or jet fuel', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Jet Fuel', 'Unknown aviation gas or jet fuel', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'JP-4', 'Jet Fuel A', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'JP-4, JP-8, and Gasoline', 'Jet Fuel A', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'JP-4, Solvent, Oil', 'Jet Fuel A', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'JP-5 Fuel', 'Unknown aviation gas or jet fuel', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'JP-8', 'Jet Fuel A', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'JP 4, water mixture', 'Jet Fuel A', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Kerosene', 'Kerosene', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Latex adhesive', 'Unknown', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Mineral Spirits', 'Petroleum product', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'motor oil', 'Lube/motor oil (new)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Motor Oil', 'Lube/motor oil (new)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'MTBE', 'Petroleum product', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'No known contamination', 'Unknown', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Oil', 'Lube/motor oil (new)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'oil/water', 'Lube/motor oil (new)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Oil/Water', 'Lube/motor oil (new)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'oil/water separator', 'Lube/motor oil (new)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'pesticides, explosives', 'Hazardous substance', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'petro/paint / varnish', 'Solvent', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'petroleum', 'Petroleum product', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Petroleum', 'Petroleum product', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Petroleum - BTEX & VOCs', 'Petroleum product', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Petroleum & Agri Chem', 'Petroleum product', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Petroleum (Benzene)', 'Petroleum product', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Petroleum Hydrocarbons', 'Petroleum product', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Petroleum Products', 'Petroleum product', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Petroleum Vapors', 'Petroleum product', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Petroleum, Solvents', 'Petroleum product', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Petroleum, VOC''s', 'Petroleum product', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Petroleum, Waste Oil', 'Petroleum product', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'premium gas', 'Gasoline (unknown type)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Premium Gasoline', 'Gasoline (unknown type)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Propane Tank Sludge', 'Other', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'solvents', 'Solvent', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'solvents / petroleum', 'Solvent', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Solvents, Petroleum', 'Solvent', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Suspected Fuel Oil', 'Heating/fuel oil # unknown', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Suspected gasoline', 'Gasoline (unknown type)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'TCE', 'Hazardous Substance', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'TCE PAHs', 'Hazardous Substance', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'TCE, Rad waste', 'Hazardous Substance', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Transmission Fluid', 'Lube/motor oil (new)', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'trichloroethene', 'Unknown', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'unleaded gasoline', 'Gasoline (unknown type)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Unleaded Gasoline', 'Gasoline (unknown type)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'used oil', 'Used oil/waste oil', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Used Oil', 'Used oil/waste oil', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Waste & Fuel Oil', 'Used oil/waste oil', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'waste oil', 'Used oil/waste oil', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Waste oil', 'Used oil/waste oil', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Waste Oil', 'Used oil/waste oil', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'waste oil / diesel', 'Used oil/waste oil', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Waste Oil and TCE', 'Used oil/waste oil', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'Waste/Motor Oil', 'Used oil/waste oil', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 'white gasoline', 'Petroleum product', null);


release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (226, 

select * from release_element_value_mapping where release_element_mapping_id = 226 and organization_value = 'Gasoline Leaded';

update release_element_value_mapping 
set epa_value = 'Leaded gasoline'
where release_element_mapping_id = 226 and organization_value = 'Gasoline Leaded';




/*!!! WARNING! Some of the lookups have changed for the new template format, so if you used the 
archive.v_ust_element_mapping and/or archive.v_lust_element_mapping views and copied values 
directly from them, you may have to update them:*/
select distinct epa_value
from release_element_value_mapping a join release_element_mapping b on a.release_element_mapping_id = b.release_element_mapping_id
where release_control_id = 12 and epa_column_name = 'ust_release_cause'
and epa_value not in (select substance from substances)
order by 1;
--Other

--Get the updated value from the current lookup:
select * from substances where lower(substance) like lower('%MTBE%');
/*
Other unlisted blend containing any other mixture of diesel, renewable diesel, or 20% biodiesel or less
Other unlisted blend containing any other mixture of diesel, renewable diesel, or more than 20% biodiesel
Other or mixture
*/

--update release_element_value_mapping with the new value
update release_element_value_mapping a set epa_value = 'Other or mixture'
where epa_value = 'Other' and release_element_mapping_id in 
	(select release_element_mapping_id from release_element_mapping 
	where release_control_id = 12 and epa_column_name = 'substance_id');


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--cause_id

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from "' || organization_table_name || '" order by 1;'
from v_release_needed_mapping 
where release_control_id = 12 and epa_column_name = 'cause_id';

--in this case, the state combined their source and cause values into a single column, 
--so we have already deagged this table when we did the sources above
select distinct "cause_type" from "spill_reports_all" order by 1;


/*generate generic sql to insert value mapping rows into release_element_value_mapping, 
then modify the generated sql with the mapped EPA values 
NOTE: insert a NULL for epa_value if you don't have a good guess 
NOTE: if the organization_value is one that should exclude the facility/tank from UST Finder
      (e.g. a non-federally regulated substance), manually modify the generated sql to 
       include column exclude_from_query and set the value to 'Y'*/
select insert_sql 
from v_release_needed_mapping_insert_sql 
where release_control_id = 12 
and epa_column_name = 'cause_id';

select distinct 
	'insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 230 || ', ''' || "cause_type" || ''', '''', null);'
from sd_release."spill_reports_all" 
where sor_type = 'UST'
order by 1;


select * from public.causes order by 2;


select * from public.causes where lower(cause) like lower('%Vent%') order by 2;
 insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'Accident', 'Other', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'Broken Pipe ', 'Piping failure', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'corrosion', 'Corrosion', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'Corrosion', 'Corrosion', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'Damage', 'Other', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'Damaged Pipe', 'Piping failure', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'Disconnected Hose', 'Damage to dispenser hose', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'Dispenser Leak', 'Damage to dispenser', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'Displaced Load', 'Other', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'Equipment Activation',  'Other', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'Equipment Failure',  'Other', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'Fire Event', 'Weather/natural disaster (i.e., hurricane, flooding, fire, earthquake)', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'Floated', 'Other', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'Handling', 'Other', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'Historical', 'Other', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'Hole in tank', 'Tank damage', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'Immersed', 'Other', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'Leaching', 'Other', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'Leakage', 'Other', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'Leaks and Spills', 'Other', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'Line Leak', 'Other', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'No Lab Results', 'Other', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'no Release', 'Other', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'No Release', 'Other', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'No Tank Found', 'Other', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'No Tank Removed', 'Other', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'Open Valve', 'Shear valve failure', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'Operational Error', 'Human error',  'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'Operator Error', 'Human error', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'Overfill', 'Overfill (general)',  'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'Overfills/Spillage',  'Overfill (general)',  'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'Overflow',  'Other', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'Overturned',  'Other', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'Pump Leak',  'Other', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'spillage', 'Dispenser spill',  'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'Spillage', 'Dispenser spill',  'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'Tank Failure', 'Tank damage', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'Tank Leak', 'Tank damage', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'Unattended Nozzle', 'Other', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'Uncontrolled Nozzle', 'Other', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'Unknown', 'Unknown', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'Unsecured Valve', '', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'Valve Leak', 'Shear valve failure', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'Venting', 'Unknown', null);

insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (230, 'Unsecured Valve', 'Other', 'Please verify');

select * from release_element_value_mapping;



------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--check if there is any more mapping to do
select distinct epa_table_name, epa_column_name
from v_release_needed_mapping 
where release_control_id = 12 and mapping_complete = 'N'
order by 1, 2;

--check if any of the mapping is bad:
select database_lookup_table, epa_value 
from v_release_bad_mapping 
where release_control_id = 12 order by 1, 2;
--!!!if there are results from this query, fix them!!!

--if not, it's time to write the queries that manipulate the state's data into EPA's tables 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/*Step 1: create crosswalk views for columns that use a lookup table
run script org_mapping_xwalks.py to create crosswalk views for all lookup tables 
see new views:*/
select table_name 
from information_schema.tables 
where table_schema = 'sd_release' and table_type = 'VIEW'
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
where release_control_id = 12
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
select comments from release_control where release_control_id = 12;
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
where release_control_id = 12 and epa_table_name = 'ust_release'
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

create or replace view sd_release.v_ust_release as 
select distinct 
"siteid"::character varying(50) as facility_id,
"id"::character varying(50) as release_id,
case "regulated"::character varying(7) when 'true' then 'Yes' else 'No' end as federally_reportable_release,
"site_name"::character varying(200) as site_name,
"street"::character varying(100) as site_address,
"city"::character varying(100) as site_city,
"zip_code"::character varying(10) as zipcode,
"county"::character varying(100) as county,
ft.facility_type_id as facility_type_id,
"latitude"::double precision as latitude,
"longitude"::double precision as longitude,
rs.release_status_id as release_status_id,
"date_rep"::date as reported_date,
"date_close"::date as nfa_date,
8 as epa_region, 
'SD' as state
from "spill_reports_all" x 
left join sd_release.v_release_status_xwalk	rs on x."status" = rs.organization_value 
left join sd_release.v_facility_type_xwalk	ft on x."proptype" = ft.organization_value 
where  sor_type = 'UST';

select count(*) from v_ust_release ;

select count(*) from spill_reports_all where sor_type = 'UST';


select * from spill_reports_all where id='89.225';
--review: 
select  * from sd_release.v_ust_release where release_status_id is null;
select count(*) from sd_release.v_ust_release;
--7177
--------------------------------------------------------------------------------------------------------------------------
--now repeat for each data table:

--ust_release_substance 
select organization_table_name_qtd, selected_column, programmer_comments, 
	database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_release_table_population_sql
where release_control_id = 12 and epa_table_name = 'ust_release_substance'
order by column_sort_order;

--be sure to do select distinct if necessary!
create or replace view sd_release.v_ust_release_substance as 
select distinct s.substance_id as substance_id,
"id"::character varying(50) as release_id,
"amount"::double precision as quantity_released,
"units"::character varying(20) as unit
from "spill_reports_all" x
join sd_release.v_substance_xwalk s on x."material" = s.organization_value 
where s.substance_id is not null 
and  sor_type = 'UST';


select * from v_substance_xwalk where epa_value like '%Jet%';
select * from sd_release.v_ust_release_substance where ;
select count(*) from sd_release.v_ust_release_substance;
--4688 



--------------------------------------------------------------------------------------------------------------------------
--ust_release_cause 

select organization_table_name_qtd, selected_column, programmer_comments, 
	database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_release_table_population_sql
where release_control_id = 12 and epa_table_name = 'ust_release_cause'
order by column_sort_order;

create or replace view sd_release.v_ust_release_cause as 
select distinct b.cause_id ,
"id"::character varying(50) as release_id
from "spill_reports_all" a 
join sd_release.v_cause_xwalk b on a.cause_type = b.organization_value 
where  sor_type = 'UST';
	
select * from spill_reports_all where id = '2017.019';
Unsecured Valve

select * from v_cause_xwalk where organization_value = 'Unsecured Valve';

select * from sd_release.v_ust_release_cause where cause_id is null;
select count(*) from sd_release.v_ust_release_cause;
--7117

--------------------------------------------------------------------------------------------------------------------------
--QA/QC

--check that you didn't miss any columns when creating the data population views:
--if any rows are returned by this query, fix the appropriate view by adding the missing columns!
select epa_table_name, epa_column_name, 
	organization_table_name, organization_column_name, 
	organization_join_table, organization_join_column, 
	deagg_table_name, deagg_column_name
from v_release_missing_view_mapping a
where release_control_id = 12
order by 1, 2;

/*
select b.column_name, b.data_type, b.character_maximum_length, a.data_type, a.character_maximum_length 
from information_schema.columns a join information_schema.columns b on a.column_name = b.column_name 
where a.table_schema = 'sd_release' and a.table_name = 'v_ust_release'
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
where release_control_id = 12 order by sort_order;
ust_release	7177
ust_release_substance	4711
ust_release_cause	7117


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