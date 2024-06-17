select * from release_control ;

insert into release_control (organization_id,date_received,date_processed,data_source,comments)
values ('VA',current_date,current_date,'CSV downloads from https://geohub-vadeq.hub.arcgis.com/pages/16b992debdff41cd945f48d348e17c59 ','');




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
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (3,'ust_release','facility_id','release_txt','rst_fac_id','This is the Release ID.  There is a different fac ID for UST called ceds_fac_id.');
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

select * from release_element_mapping where release_control_id= 3;
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


-- pa_release.v_release_bad_mapping source

 
--check if any of the mapping is bad:
select database_lookup_table, epa_value 
from v_release_bad_mapping 
where release_control_id = 3 order by 1, 2;
--!!!if there are results from this query, fix them!!!

--if not, it's time to write the queries that manipulate the state's data into EPA's tables 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--Step 1: create crosswalk views for columns that use a lookup table
--run script org_mapping_xwalks.py to create crosswalk views for all lookup tables 
--see new views:
select table_name 
from information_schema.tables 
where table_schema = 'va_release' and table_type = 'VIEW'
and table_name like '%_xwalk' order by 1;
--v_facility_type_xwalk
--v_release_status_xwalk
--v_state_xwalk


--Step 2: see the EPA tables we need to populate, and in what order
select distinct epa_table_name, table_sort_order
from v_release_table_population 
where release_control_id = 3
order by table_sort_order;
--ust_release	1

--Step 3: check if there where any dataset-level comments you need to incorporate:
--in this case we need to ignore the aboveground storage tanks,
--so add this to the where clause of the ust_release view 
select comments from release_control where release_control_id = 3;
--ignore rows in release_txt where federally_regulated_ust <> Yes

--Step 4: work through the tables in order, using the information you collected 
--to write views that can be used to populate the data tables 
select epa_column_name, '"' || organization_table_name || '"' organization_table_name, 
	case when database_lookup_table is null then '"' || organization_column_name || '" as ' || epa_column_name || ',' 
		else '"' || organization_column_name || '"' end organization_column_name, 
	programmer_comments, 
	database_lookup_table, database_lookup_column, 
	--'"' || organization_join_table || '"' organization_join_table, 
	--'"' || organization_join_column || '"' organization_join_column,  
	deagg_table_name, deagg_column_name 
from v_release_table_population 
where release_control_id = 3 and epa_table_name = 'ust_release'
order by column_sort_order;


--Step 5: use the information from the queries above to create the view:
--!!! NOTE how I'm using the programmer_comments column to adjust the view (e.g. nfa_date)
--!!! NOTE also sometimes you need to explicitly cast data types. In this example, the two
--    dates "CONFIRMED_DATE" and "STATUS_DATE" are text fields in the state's data and need 
--    to be cast as dates to fit into the EPA table  

create or replace view va_release.v_ust_release as 
select 	"rst_fac_id" as facility_id,
		"pollution_complaint_pc_number" as release_id,
		"federally_regulated_ust" as federally_reportable_release,
		"site_name_" as site_name,
		"address_1_" as site_address,
		"city_" as site_city,
		"zip_5" as zipcode,
		"county" as county,
		"fac_l_state",
		c."FAC_TYPE"  ,
		a.lat as latitude,
		a.lon as longitude,
		"case_status" ,
		"release_reported_date" as reported_date,
		"case_closed_date" as nfa_date
from  petroleum_release_sites a, release_txt b
	left  join va_ust.registered_petroleum_tank_facilities c on b.ceds_fac_id  = c."CEDS_FAC_ID"
where a.pcnum=b.pollution_complaint_pc_number
and federally_regulated_ust='Yes';


--select *
--from petroleum_release_sites a, release_txt b
--left  join va_ust.registered_petroleum_tank_facilities c on b.ceds_fac_id  = c."CEDS_FAC_ID"
--where a.pcnum=b.pollution_complaint_pc_number
--and  (federally_regulated_ust='Yes')
--review: 
select * from va_release.v_ust_release;
select count(*) from va_release.v_ust_release;
--69865
--------------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------------------

--check that you didn't miss any columns when creating the data population views:
--if any rows are returned by this query, fix the appropriate view by adding the missing columns!
select epa_table_name, epa_column_name, 
	organization_table_name, organization_column_name, 
	organization_join_table, organization_join_column, 
	deagg_table_name, deagg_column_name
from v_release_missing_view_mapping a
where release_control_id = 3
order by 1, 2;

--------------------------------------------------------------------------------------------------------------------------
--insert data into the EPA schema 

select table_name, view_name
from release_template_data_tables
order by sort_order;

--ust_release	v_ust_release

select column_name from information_schema.columns 
where table_schema = 'va_release' and table_name = 'v_ust_release'


insert into ust_release(facility_id,
release_id,
federally_reportable_release,
site_name,
site_address,
site_city,
zipcode,
county,
state,
facility_type_id,
latitude,
longitude,
release_status_id,
reported_date,
nfa_date,
release_control_id)
select 
facility_id,
release_id,
federally_reportable_release,
site_name,
site_address,
site_city,
zipcode,
county,
fac_l_state state,
"FAC_TYPE",va_ust.get_lookup_id(9,"FAC_TYPE",'fac_type')::int facility_type_id, -- reuse the mapping function from the UST schema
latitude::float8 latitude,
longitude::float8 longitude,
case when case_status = 'Closed' then 6 
when case_status in ('Open','Reopened') then 1
end  release_status_id,
TO_DATE(reported_date,'MM/DD/YYYY')  reported_date,
TO_DATE(nfa_date,'MM/DD/YYYY')  nfa_date, 
3
 from v_ust_release;
 

--final output to the excel template tab
	select
	facility_id,
	null tank_id,
	release_id,
	federally_reportable_release,
	site_name,
	site_address,
	null site_address2,
	site_city,
	zipcode,
	county,
	state,
	'03' region,
	ft.facility_type ,
	null tribe_site,
	null tribe,
	latitude,
	longitude,
	null coordinate_source,
	rs.release_status,
	reported_date,
	nfa_date
from
	ust_release a
left join facility_types ft on
	a.facility_type_id = ft.facility_type_id
left join release_statuses rs on
	a.release_status_id = rs.release_status_id
where
	release_control_id = 3;



select * from release_element_value_mapping where release_element_mapping_id = 45;
