select * from release_control where release_control_id=3;

CSV downloads from https://geohub-vadeq.hub.arcgis.com/pages/16b992debdff41cd945f48d348e17c59, Download "Cleanup Activities" file for release data from https://www.deq.virginia.gov/our-programs/land-waste/petroleum-tanks/underground-storage-tanks, and the registered_petroleum_tank_facilities table in the va_ust schema.
insert into release_control (organization_id,date_received,date_processed,data_source,comments)
values ('VA',current_date,current_date,'CSV downloads from https://geohub-vadeq.hub.arcgis.com/pages/16b992debdff41cd945f48d348e17c59 ','');

SELECT * FROM va_release.petroleum_release_sites;


--Get an overview of what the state's data looks like. In this case, we only have one table
select count(distinct pcnum) from petroleum_release_sites ;
select count(distinct pollution_complaint_pc_number) from release_txt;


select count(distinct pcnum) 
from petroleum_release_sites a, release_txt b
where a.pcnum=b.pollution_complaint_pc_number;

--remove a few duplicates from petroleum_release_sites
select  pcnum
from petroleum_release_sites
group by pcnum
having count(*) > 1;

--see what columns exist in the state's data 
select table_name, column_name, is_nullable, data_type, character_maximum_length 
from information_schema.columns 
where table_schema = 'va_release' and table_name in ('release_txt', 'petroleum_release_sites')
order by table_name,column_name;

--the script above returned a new release_control_id of 3 for this dataset:
select * from public.release_control where release_control_id = 3;



--after viewing the state's data, I observed it includes Aboveground Storage tanks, so I put a 
--comment in the release_control table about it.  
--When I write the views that populate the EPA template, I'll exclude these rows 
--(rather than deleting them from the state's data )
select  count(*) cnt, regulated_ast,unregulated_ast,small_heating_oil_ast,federally_regulated_ust,excluded_ust,deferred_ust,partially_deferred_ust,exempt_1_Ust,exempt_2_heating_oil_ust
from release_txt
group by  regulated_ast,unregulated_ast,small_heating_oil_ast,federally_regulated_ust,excluded_ust,deferred_ust,partially_deferred_ust,exempt_1_Ust,exempt_2_heating_oil_ust
order by cnt;



update release_control set comments = 'ignore rows in release_txt where federally_regulated_ust <> Yes' where release_control_id = 3;


update release_control set data_source = 'CSV downloads from https://geohub-vadeq.hub.arcgis.com/pages/16b992debdff41cd945f48d348e17c59, Download "Cleanup Activities" file for release data from https://www.deq.virginia.gov/our-programs/land-waste/petroleum-tanks/underground-storage-tanks, and the registered_petroleum_tank_facilities table in the va_ust schema.' where release_control_id = 3;



select * from  va_ust.registered_petroleum_tank_facilities where "CEDS_FAC_ID"  = '200000087294';
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--get the EPA tables that we need to populate
select table_name
from public.release_element_table_sort_order
order by sort_order;
--ust_release
--ust_release_substance
--ust_release_cause
--ust_release_source
--ust_release_corrective_action_strategy


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Start with the first table, ust_release 
--get the EPA columns we need to look for in the state data 
select database_column_name 
from release_elements a join release_elements_tables b on a.element_id = b.element_id
where table_name = 'ust_release' 
order by sort_order;
--facility_id
--tank_id_associated_with_release
--release_id
--federally_reportable_release
--site_name
--site_address
--site_address2
--site_city
--zipcode
--county
--state
--epa_region
--facility_type_id
--tribal_site
--tribe
--latitude
--longitude
--coordinate_source_id
--release_status_id
--reported_date
--nfa_date
--media_impacted_soil
--media_impacted_groundwater
--media_impacted_surface_water
--how_release_detected_id
--closed_with_contamination
--no_further_action_letter_url
--military_dod_site

--review state data again 
select  a.*
from petroleum_release_sites a, release_txt b
left  join va_ust.registered_petroleum_tank_facilities c on b.ceds_fac_id  = c."CEDS_FAC_ID"
where a.pcnum=b.pollution_complaint_pc_number
and  (federally_regulated_ust='Yes')
and rst_status_ind <> case_status
;






--this will map to release_status; we'll do the actual mapping later 
select distinct case_status from release_txt order by 1;

--this will map to fac_type; we'll do the actual mapping later 
select distinct "FAC_TYPE" from va_ust.registered_petroleum_tank_facilities  order by 1;




------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Generate SQL statements to do the inserts into release_element_mapping. 
--Run the query below, paste the results into your console, then do a global replace of XX for the release_control_id 
--Next, go through each generated SQL statement and do the following:
--If there is no matching column in the state's data, delete the SQL statement 
--If there is a matching column in the state's data, update the ORG_TAB_NAME and ORG_COL_NAME variables to match the state's data 
--If you have questions or comments, replace the "null" with your comment. 
--After you have updated all the SQL statements, run them to update the database. 
select * from public.v_release_element_summary_sql;

select rst_id  from release_txt ; 
51948
43899

delete from release_element_mapping where release_control_id = '3' and  epa_column_name = 'facility_id'
select * from va_release.petroleum_release_sites;


select * from release_element_mapping where release_control_id = 3;


drop table erg_release_facility_id;
create table erg_release_facility_id as 
select distinct coalesce(c."FAC_ID",a.rst_fac_id) release_facility_id, b.pollution_complaint_pc_number 
from va_release.petroleum_release_sites a
left join va_release.release_txt b on a.pcnum = b.pollution_complaint_pc_number and b.federally_regulated_ust='Yes'
left join va_ust.registered_petroleum_tank_facilities c on b.ceds_fac_id = c."CEDS_FAC_ID" and (c."FAC_ACTIVE_UST"::int > 0 or c."FAC_INACTIVE_UST"::int > 0) and c."FAC_FED_REG_YN"='Y';

select * from erg_release_facility_id
where pollution_complaint_pc_number in 
(select pollution_complaint_pc_number 
from erg_release_facility_id group by pollution_complaint_pc_number having count(*) > 1) order by 2;


select * from  va_release.petroleum_release_sites where pcnum='19850564';
select * from release_txt where pollution_complaint_pc_number in ('19850564');
select * from release_txt where ceds_fac_id  in ('200000194059') and federally_regulated_ust='Yes';
select * from  va_ust.registered_petroleum_tank_facilities where "CEDS_FAC_ID" = '200000194059';

select count(*) from va_release.release_txt a
49373
select * from va_ust.registered_petroleum_tank_facilities ;

select ceds_fac_id , pollution_complaint_pc_number
from release_txt;
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (3,'ust_release','facility_id','petroleum_release_sites','rst_id','This is the Release ID.  There is a different fac ID for UST called ceds_fac_id.');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (3,'ust_release','release_id','release_txt','pollution_complaint_pc_number',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (3,'ust_release','federally_reportable_release','release_txt','federally_regulated_ust',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (3,'ust_release','site_name','release_txt','site_name_',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (3,'ust_release','site_address','release_txt','address_1_',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (3,'ust_release','site_city','release_txt','city_',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (3,'ust_release','zipcode','release_txt','zip_5',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (3,'ust_release','county','release_txt','county',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (3,'ust_release','state','petroleum_release_sites','fac_l_state',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (3,'ust_release','facility_type_id','registered_petroleum_tank_facilities','fac_type',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (3,'ust_release','latitude','release_txt','lat',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (3,'ust_release','longitude','petroleum_release_sites','lon',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (3,'ust_release','release_status_id','release_txt','case_status',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (3,'ust_release','reported_date','release_txt','release_reported_date',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (3,'ust_release','nfa_date','release_txt','case_closed_date',null);
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (3,'ust_release','military_dod_site','registered_petroleum_tank_facilities','fac_type','When FEDERAL MILITARY then Y else N.');



select * from release_element_mapping where release_control_id= 3 and epa_column_name = 'facility_id';

select rst_fac_id  from petroleum_release_sites


select "FAC_ID"  from va_ust.registered_petroleum_tank_facilities rptf 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--see what columns in which table we need to map
select epa_table_name, epa_column_name
from v_release_available_mapping 
where release_control_id = 3;

--see what mapping hasn't yet been done for this dataset 
--we'll be going through each of the results of this query below
--so for each value of epa_column_name from this query result, there will be a 
--section below where we generate SQL to perform the mapping 
select distinct epa_table_name, epa_column_name
from v_release_needed_mapping 
where release_control_id = 3 and mapping_complete = 'N'
order by 1, 2;
ust_release	facility_type_id
ust_release	release_status_id
ust_release	state

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--FAC_TYPE

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from "' || organization_table_name || '" order by 1;'
from v_release_needed_mapping 
where release_control_id = 3 and epa_column_name = 'facility_type_id';

--run the query from the generated sql above to see what the state's data looks like
--you are checking to make sure their values line up with what we are looking for on the EPA side
--(this should have been done during the element mapping above but you can review it now)
--Next, see if the state values need to be deaggregated 
--(that is, is there only one value per row in the state data? If not, we need to deaggregate them)
select distinct "FAC_TYPE" from va_ust.registered_petroleum_tank_facilities order by 1;
--
--AIRCRAFT
--AIRLINE
--AUTO DEALER
--COMMERCIAL
--CONTRACTOR
--FARM
--FEDERAL MILITARY
--FEDERAL NON-MILITARY
--GAS STATION
--INDUSTRIAL
--LOCAL
--OTHER
--PETROLEUM DISTRIBUTOR
--RAILROAD
--RESIDENTIAL
--STATE
--TRUCKING TRANSPORT
--UNKNOWN
--UTILITY
--in this case there is only one value per row so we can begin mapping 

--generate generic sql to insert value mapping rows into release_element_value_mapping, 
--then modify the generated sql with the mapped EPA values 
--NOTE: insert a NULL for epa_value if you don't have a good guess 
--NOTE: if the organization_value is one that should exclude the facility/tank from UST Finder
--      (e.g. a non-federally regulated substance), manually modify the generated sql to 
--       include column exclude_from_query and set the value to 'Y'
select insert_sql 
from v_release_needed_mapping_insert_sql 
where release_control_id = 3 and epa_column_name = 'facility_type_id';

--paste the insert_sql from the first row below, then run the query:
select distinct 
	'insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 42 || ', ''' || "FAC_TYPE" || ''', '''', null);'
from va_ust.registered_petroleum_tank_facilities order by 1;
 
--paste the generated insert statements from the query above below, then manually update each one to fill in the missing epa_value
--if necessary, replace the "null" with any questions or comments you have about the specific mapping 
-
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (42, 'AIRCRAFT', 'Aviation/airport (non-rental car)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (42, 'AIRLINE', 'Aviation/airport (non-rental car)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (42, 'AUTO DEALER', 'Auto dealership/auto maintenance & repair', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (42, 'COMMERCIAL', 'Commercial', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (42, 'CONTRACTOR', 'Contractor', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (42, 'FARM', 'Agricultural/farm', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (42, 'FEDERAL MILITARY', 'Other', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (42, 'FEDERAL NON-MILITARY', 'Other', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (42, 'GAS STATION', 'Retail fuel sales (non-marina)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (42, 'INDUSTRIAL', 'Industrial', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (42, 'LOCAL', 'Other', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (42, 'OTHER', 'Other', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (42, 'PETROLEUM DISTRIBUTOR', 'Bulk plant storage/petroleum distributor', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (42, 'RAILROAD', 'Railroad', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (42, 'RESIDENTIAL', 'Residential', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (42, 'STATE', 'Other', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (42, 'TRUCKING TRANSPORT', 'Trucking/transport/fleet operation', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (42, 'UNKNOWN', 'Unknown', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (42, 'UTILITY', 'Utility', null);



select * from public.facility_types;


select * from release_element_value_mapping
where release_element_mapping_id= 42 and  organization_value in ('LOCAL','STATE')

update release_element_value_mapping
set epa_value = 'State/local government'
where release_element_mapping_id= 42 and  organization_value in ('LOCAL','STATE');

update release_element_value_mapping
set  organization_comments = 'Federal Non-Military should be Federally Owned (Cell A8)'
where release_element_mapping_id= 42 and  organization_value= 'FEDERAL NON-MILITARY';



update release_element_value_mapping
set  epa_value  = 'Military', organization_comments = null
where release_element_mapping_id= 42 and  organization_value= 'FEDERAL MILITARY';


select * from public.facility_types ;
--to assist with the mapping above, check the archived mapping table for old examples of mapping 
select * from ust_element_value_mapping where ust_element_mapping_id=9 order by organization_value;
--AIRCRAFT	Aviation/airport (non-rental car)
--AIRLINE	Aviation/airport (non-rental car)
--AUTO DEALER	Auto dealership/auto maintenance & repair
--COMMERCIAL	Commercial
--CONTRACTOR	Contractor
--FARM	Agricultural/farm
--FEDERAL MILITARY	Other
--FEDERAL NON-MILITARY	Other
--GAS STATION	Retail fuel sales (non-marina)
--INDUSTRIAL	Industrial
--LOCAL	Other
--OTHER	Other
--PETROLEUM DISTRIBUTOR	Bulk plant storage/petroleum distributor
--RAILROAD	Railroad
--RESIDENTIAL	Residential
--STATE	Other
--TRUCKING TRANSPORT	Trucking/transport/fleet operation
--UNKNOWN	Unknown
--UTILITY	Utility


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--release_status_id

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from "' || organization_table_name || '" order by 1;'
from v_release_needed_mapping 
where release_control_id = 3 and epa_column_name = 'release_status_id';

--run the query from the generated sql above to see what the state's data looks like
--you are checking to make sure their values line up with what we are looking for on the EPA side
--(this should have been done during the element mapping above but you can review it now)
--Next, see if the state values need to be deaggregated 
--(that is, is there only one value per row in the state data? If not, we need to deaggregate them)
select distinct "case_status" from "release_txt" order by 1;
--Closed
--Open
--Reopened


--generate generic sql to insert value mapping rows into release_element_value_mapping, 
--then modify the generated sql with the mapped EPA values 
--NOTE: insert a NULL for epa_value if you don't have a good guess 
--NOTE: if the organization_value is one that should exclude the facility/tank from UST Finder
--      (e.g. a non-federally regulated substance), manually modify the generated sql to 
--       include column exclude_from_query and set the value to 'Y'
select insert_sql 
from v_release_needed_mapping_insert_sql 
where release_control_id =3 and epa_column_name = 'release_status_id';

select distinct 
	'insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 45 || ', ''' || "case_status" || ''', '''', null);'
from "release_txt" order by 1;
--below I have mapped the ones I can take a reasonable guess at, but I've inserted nulls for the ones I have no idea about 
--the state codes are pretty obtuse so I'm not very confident of my mapping on any of them; therefore I've added a "please verify" comment 
--for the ones I took a stab at mapping, as well as "MAPPING NEEDED" for those I didn't. This way, when the mapping is exported to
--the review template, EPA and the state have a visual indicator that we need their input for all of them. 
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (45, 'Closed', 'No further action', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (45, 'Open', 'Active: general', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (45, 'Reopened', 'Active: general', 'Please verify');


select * from release_element_value_mapping
where release_element_mapping_id= 45 and  organization_value= 'Reopened';


select * from 
update release_element_value_mapping
set organization_comments = 'Correct - reopened sites can be any release status/phase of investigation'
where release_element_mapping_id= 45 and  organization_value= 'Reopened';


--epa options
--"Active: general
--Active: post CorrectiveAction monitoring
--Active: CorrectiveAction
--Active: site investigation
--Active: stalled
--No further action
--Unknown
--Other
--"

select * from archive.lust_element_db_mapping where lower(element_name) like '%status%';
select * from archive.lust_element_value_mappings  where lower(state_value) like '%r%open%';

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--state

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from "' || organization_table_name || '" order by 1;'
from v_release_needed_mapping 
where release_control_id = 3 and epa_column_name = 'state';

--run the query from the generated sql above to see what the state's data looks like
--you are checking to make sure their values line up with what we are looking for on the EPA side
--(this should have been done during the element mapping above but you can review it now)
--Next, see if the state values need to be deaggregated 
--(that is, is there only one value per row in the state data? If not, we need to deaggregate them)
select distinct "fac_l_state" from "petroleum_release_sites" order by 1;

--Administrative Close Out (ACO)
--Attainment Monitoring in Progress
--Cleanup Completed
--Inactive
--Interim or Remedial Actions Initiated
--Interim Remedial Actions Not Initiated
--Suspected Release - Invest. Complete, No Release Confirmed
--Suspected Release - Investigation Pending or Initiated
--Unverified Incident

--see what the EPA values we need to map to are
select * from petroleum_release_sites order by 2;

--generate generic sql to insert value mapping rows into release_element_value_mapping, 
--then modify the generated sql with the mapped EPA values 
--NOTE: insert a NULL for epa_value if you don't have a good guess 
--NOTE: if the organization_value is one that should exclude the facility/tank from UST Finder
--      (e.g. a non-federally regulated substance), manually modify the generated sql to 
--       include column exclude_from_query and set the value to 'Y'
select insert_sql 
from v_release_needed_mapping_insert_sql 
where release_control_id = 3 and epa_column_name = 'state';

select distinct 
	'insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 41 || ', ''' || "fac_l_state" || ''', '''', null);'
from "petroleum_release_sites" order by 1;

--These are a little easier to map because they are more descriptive, but I've still put a comment to "please verify"
--on a couple I wasn't 100% sure about; this will help draw attention to them when EPA/the state review the exported template. 
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (41, 'DC', 'DC', 'Should DC data be removed from the VA dataset?');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (41, 'VA', 'VA', null);

--check if there is any more mapping to do
select distinct epa_table_name, epa_column_name
from v_release_needed_mapping 
where release_control_id = 3 and mapping_complete = 'N'
order by 1, 2;

--check if any of the mapping is bad:
select database_lookup_table, epa_value 
from v_release_bad_mapping 
where release_control_id = 3 order by 1, 2;
--!!!if there are results from this query, fix them!!!

--if not, it's time to write the queries that manipulate the state's data into EPA's tables 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/*Step 1: create crosswalk views for columns that use a lookup table
run script org_mapping_xwalks.py to create crosswalk views for all lookup tables 
see new views:*/
select table_name 
from information_schema.tables 
where table_schema = 'va_release' and table_type = 'VIEW'
and table_name like '%_xwalk' order by 1;
/*
v_facility_type_xwalk
v_release_status_xwalk
v_state_xwalk
*/


--Step 2: see the EPA tables we need to populate, and in what order
select distinct epa_table_name, table_sort_order
from v_release_table_population 
where release_control_id = 3
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
select comments from release_control where release_control_id = 3;
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
where release_control_id = 3 and epa_table_name = 'ust_release'
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
drop view va_release.v_ust_release;

-- va_release.v_ust_release source


select ceds_fac_id from     va_release.registered_petroleum_tank_facilities;
registered_petroleum_tank_facilities


CREATE OR REPLACE VIEW va_release.v_ust_release
AS SELECT DISTINCT c."FAC_ID"::character varying(50) AS facility_id,
    b.pollution_complaint_pc_number::character varying(50) AS release_id,
    b.federally_regulated_ust::character varying(7) AS federally_reportable_release,
    b.site_name_::character varying(200) AS site_name,
    b.address_1_::character varying(100) AS site_address,
    b.city_::character varying(100) AS site_city,
    b.zip_5::character varying(10) AS zipcode,
    b.county::character varying(100) AS county,
    ft.facility_type_id,
    d.lat::double precision AS latitude,
    d.lon::double precision AS longitude,
    rs.release_status_id,
    b.release_reported_date::date AS reported_date,
    b.case_closed_date::date AS nfa_date,
        CASE
            WHEN c."FAC_TYPE"::text = 'FEDERAL MILITARY'::text THEN 'Yes'::text
            ELSE 'No'::text
        END AS military_dod_site,
    3 AS epa_region,
    'VA'::text AS state
   FROM va_release.release_txt b
     LEFT JOIN va_release.petroleum_release_sites d ON b.pollution_complaint_pc_number::text = d.pcnum::text
     LEFT JOIN va_ust.registered_petroleum_tank_facilities c ON b.ceds_fac_id::text = c."CEDS_FAC_ID"::text
     LEFT JOIN va_release.v_facility_type_xwalk ft ON c."FAC_TYPE"::text = ft.organization_value::text
     LEFT JOIN va_release.v_release_status_xwalk rs ON b.case_status::text = rs.organization_value::text
  WHERE b.federally_regulated_ust::text = 'Yes'::text;
 
 13838 --ceds
 
 select count(*)
FROM va_release.release_txt b
     join va_ust.registered_petroleum_tank_facilities rptf on b.ceds_fac_id =rptf."CEDS_FAC_ID" 
  WHERE b.federally_regulated_ust::text = 'Yes'::text;
 
 --13231
 
 200000222902
200000090123

  select *
FROM va_release.release_txt  b
where ceds_fac_id  not in (select "CEDS_FAC_ID" from va_ust.registered_petroleum_tank_facilities )
and    b.federally_regulated_ust::text = 'Yes'::text;
 
   

200000222902


 SELECT  distinct c."FAC_ID"::character varying(50) AS facility_id,
    b.pollution_complaint_pc_number::character varying(50) AS release_id,
    b.federally_regulated_ust::character varying(7) AS federally_reportable_release,
    b.site_name_::character varying(200) AS site_name,
    b.address_1_::character varying(100) AS site_address,
    b.city_::character varying(100) AS site_city,
    b.zip_5::character varying(10) AS zipcode,
    b.county::character varying(100) AS county,
    ft.facility_type_id,
    d.lat::double precision AS latitude,
    d.lon::double precision AS longitude,
    rs.release_status_id,
    b.release_reported_date::date AS reported_date,
    b.case_closed_date::date AS nfa_date,
        CASE
            WHEN c."FAC_TYPE"::text = 'FEDERAL MILITARY'::text THEN 'Yes'::text
            ELSE 'No'::text
        END AS military_dod_site,
    3 AS epa_region,
    'VA'::text AS state
   FROM va_release.release_txt b
     LEFT JOIN va_release.petroleum_release_sites d ON b.pollution_complaint_pc_number::text = d.pcnum::text
     LEFT JOIN va_ust.registered_petroleum_tank_facilities c ON b.ceds_fac_id::text = c."CEDS_FAC_ID"::text
     LEFT JOIN va_release.v_facility_type_xwalk ft ON c."FAC_TYPE"::text = ft.organization_value::text
     LEFT JOIN va_release.v_release_status_xwalk rs ON b.case_status::text = rs.organization_value::text
  WHERE b.federally_regulated_ust::text = 'Yes'::text 
 order by 1;

--review: 
select  * from va_release.v_ust_release;
select count(*) from va_release.v_ust_release;
--13256


20131012 - 200000094660
19922331
20101025

select * 
from release_txt
where pollution_complaint_pc_number  = '20131012';


select * from va_ust.registered_petroleum_tank_facilities
where "CEDS_FAC_ID" = '200000169263';

select * from release_txt a
where ceds_fac_id not in (select "CEDS_FAC_ID" from va_ust.registered_petroleum_tank_facilities);



--------------------------------------------------------------------------------------------------------------------------
--QA/QC

--check that you didn't miss any columns when creating the data population views:
--if any rows are returned by this query, fix the appropriate view by adding the missing columns!
select epa_table_name, epa_column_name, 
	organization_table_name, organization_column_name, 
	organization_join_table, organization_join_column, 
	deagg_table_name, deagg_column_name
from v_release_missing_view_mapping a
where release_control_id = 3
order by 1, 2;


select distinct state from v_ust_release;
/*
select b.column_name, b.data_type, b.character_maximum_length, a.data_type, a.character_maximum_length 
from information_schema.columns a join information_schema.columns b on a.column_name = b.column_name 
where a.table_schema = 'va_release' and a.table_name = 'v_ust_release'
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
control_id = 3
delete_existing = False # can set to True if there is existing release data you need to delete before inserting new
*/

--------------------------------------------------------------------------------------------------------------------------
--Quick sanity check of number of rows inserted:
select table_name, num_rows from v_release_table_row_count
where release_control_id = 3 order by sort_order;
ust_release	13245

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


