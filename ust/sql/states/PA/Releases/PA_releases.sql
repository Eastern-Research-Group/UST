--Get an overview of what the state's data looks like. In this case, we only have one table
select * from "Tank_Cleanup_Incidents" ;

--see what columns exist in the state's data 
select table_name, column_name, is_nullable, data_type, character_maximum_length 
from information_schema.columns 
where table_schema = 'pa_release' and table_name = 'Tank_Cleanup_Incidents' 
order by ordinal_position;

--rename any columns with funky characters to make it easier to write queries
--(note, other than renaming columns and tables to make queries easier, try not to alter the raw state data)
alter table "Tank_Cleanup_Incidents" rename column "ï»¿REGION" to "REGION";

--it might be helpful to create some indexes on the state data 
--(you can also do this as you go along in the processing and find the need to do do)
create index Tank_Cleanup_Incidents_facid_idx on "Tank_Cleanup_Incidents"("FACILITY_ID");
create index Tank_Cleanup_Incidents_incid_idx on "Tank_Cleanup_Incidents"("INCIDENT_ID");
create index Tank_Cleanup_Incidents_sub_idx on "Tank_Cleanup_Incidents"("SUBSTANCE");
create index Tank_Cleanup_Incidents_hrd_idx on "Tank_Cleanup_Incidents"("RELEASE_DISCOVERED");

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Update the control table 

--EITHER:
--use insert_control.py to insert into public.release_control
--OR:
--insert into release_control (organization_id, date_received, data_source, comments)
--values ('PA', '2024-06-11', 'CSV downloaded from http://cedatareporting.pa.gov/Reportserver/Pages/ReportViewer.aspx?/Public/DEP/Cleanup/SSRS/Tank_Cleanup_Incidents', null);
--returning release_control_id;

--the script above returned a new release_control_id of 2 for this dataset:
select * from public.release_control where release_control_id = 2;

--after viewing the state's data, I observed it includes Aboveground Storage tanks, so I put a 
--comment in the release_control table about it.  
--When I write the views that populate the EPA template, I'll exclude these rows 
--(rather than deleting them from the state's data )
update release_control set comments = 'ignore rows where "INCIDENT_TYPE" = ''AST''' where release_control_id = 2;

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
select * from "Tank_Cleanup_Incidents";

--run queries looking for lookup table values 
select distinct "INCIDENT_TYPE" from "Tank_Cleanup_Incidents" order by 1;
--AST
--AST, USTPT
--USTHZ
--USTPT

--AST probably stands for "Aboveground Storage Tank", so as mentioned above, we'll want to 
--exclude rows where Tank_Cleanup_Incidents.INCIDENT_TYPE = AST. 
--(we'll keep rows that are both AST and USTPT)

select distinct "STATUS_DESCRIPTION" from "Tank_Cleanup_Incidents" order by 1;
--this will map to release_status; we'll do the actual mapping later 

select distinct "IMPACT_DESCRIPTION" from "Tank_Cleanup_Incidents" order by 1;
--this will map to our Y/N/Unknown columns media_impacted_soil, media_impacted_groundwater, 
--and media_impacted_surface_water; we'll do the actual mapping later 

select distinct "SOURCE_OF_NOTIFICATION" from "Tank_Cleanup_Incidents" order by 1;
--this probably doesn't map to any EPA elements; we'll probably end up ignoring it

select distinct "RELEASE_DISCOVERED" from "Tank_Cleanup_Incidents" order by 1;
--this will map to EPA element how_release_detected, but we'll have to deaggrate it; we'll do this later. 


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Generate SQL statements to do the inserts into release_element_mapping. 
--Run the query below, paste the results into your console, then do a global replace of XX for the release_control_id 
--Next, go through each generated SQL statement and do the following:
--If there is no matching column in the state's data, delete the SQL statement 
--If there is a matching column in the state's data, update the ORG_TAB_NAME and ORG_COL_NAME variables to match the state's data 
--If you have questions or comments, replace the "null" with your comment. 
--After you have updated all the SQL statements, run them to update the database. 
select * from public.v_release_element_summary_sql;

insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name)
values (2, 'ust_release', 'facility_id', 'Tank_Cleanup_Incidents', 'FACILITY_ID');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name)
values (2, 'ust_release', 'tank_id_associated_with_release', 'Tank_Cleanup_Incidents', 'TANK');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name)
values (2, 'ust_release', 'release_id', 'Tank_Cleanup_Incidents', 'INCIDENT_ID');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name)
values (2, 'ust_release', 'site_name', 'Tank_Cleanup_Incidents', 'FACILITY_NAME');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name)
values (2, 'ust_release', 'site_address', 'Tank_Cleanup_Incidents', 'ADDRESS1');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name)
values (2, 'ust_release', 'site_address2', 'Tank_Cleanup_Incidents', 'ADDRESS2');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name)
values (2, 'ust_release', 'site_city', 'Tank_Cleanup_Incidents', 'CITY');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name)
values (2, 'ust_release', 'zipcode', 'Tank_Cleanup_Incidents', 'ZIP');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name)
values (2, 'ust_release', 'latitude', 'Tank_Cleanup_Incidents', 'LATITUDE');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name)
values (2, 'ust_release', 'longitude', 'Tank_Cleanup_Incidents', 'LONGITUDE');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name)
values (2, 'ust_release', 'coordinate_source', 'Tank_Cleanup_Incidents', 'HOR_REF_DATUM');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name)
values (2, 'ust_release', 'release_status_id', 'Tank_Cleanup_Incidents', 'STATUS_DESCRIPTION');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name)
values (2, 'ust_release', 'reported_date', 'Tank_Cleanup_Incidents', 'CONFIRMED_DATE');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments)
values (2, 'ust_release', 'nfa_date', 'Tank_Cleanup_Incidents', 'STATUS_DATE', 'where "STATUS_DESCRIPTION" = ''Cleanup Completed''');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments)
values (2, 'ust_release', 'media_impacted_soil', 'Tank_Cleanup_Incidents', 'IMPACT_DESCRIPTION', 'where = ''Soil''');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments)
values (2, 'ust_release', 'media_impacted_groundwater', 'Tank_Cleanup_Incidents', 'IMPACT_DESCRIPTION', 'where = ''Ground Water''');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments)
values (2, 'ust_release', 'media_impacted_surface_water', 'Tank_Cleanup_Incidents', 'IMPACT_DESCRIPTION', 'where = ''Surface Water''');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name)
values (2, 'ust_release', 'how_release_detected_id', 'Tank_Cleanup_Incidents', 'RELEASE_DISCOVERED');

insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name)
values (2, 'ust_release_substance', 'substance_id', 'Tank_Cleanup_Incidents', 'SUBSTANCE');

insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments)
values (2, 'ust_release_cause', 'cause_id', 'Tank_Cleanup_Incidents', 'SOURCE_CAUSE_OF_RELEASE', 'Column is comma-separated and also includes sources');

insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments)
values (2, 'ust_release_source', 'source_id', 'Tank_Cleanup_Incidents', 'SOURCE_CAUSE_OF_RELEASE', 'Column is comma-separated and also includes causes');


------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--see what columns in which table we need to map
select epa_table_name, epa_column_name
from v_release_available_mapping 
where release_control_id = 2;

--see what mapping hasn't yet been done for this dataset 
--we'll be going through each of the results of this query below
--so for each value of epa_column_name from this query result, there will be a 
--section below where we generate SQL to perform the mapping 
select distinct epa_table_name, epa_column_name
from v_release_needed_mapping 
where release_control_id = 2 and mapping_complete = 'N'
order by 1, 2;
--ust_release			coordinate_source_id
--ust_release			how_release_detected_id
--ust_release			release_status
--ust_release_cause		cause_id
--ust_release_source	source_id
--ust_release_substance	substance_id

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--coordinate_source_id

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from "' || organization_table_name || '" order by 1;'
from v_release_needed_mapping 
where release_control_id = 2 and epa_column_name = 'coordinate_source_id';

--run the query from the generated sql above to see what the state's data looks like
--you are checking to make sure their values line up with what we are looking for on the EPA side
--(this should have been done during the element mapping above but you can review it now)
--Next, see if the state values need to be deaggregated 
--(that is, is there only one value per row in the state data? If not, we need to deaggregate them)
select distinct "HOR_REF_DATUM" from "Tank_Cleanup_Incidents" order by 1;
--NAD27
--NAD83
--UNK
--WGS84

--in this case there is only one value per row so we can begin mapping 

--generate generic sql to insert value mapping rows into release_element_value_mapping, 
--then modify the generated sql with the mapped EPA values 
--NOTE: insert a NULL for epa_value if you don't have a good guess 
--NOTE: if the organization_value is one that should exclude the facility/tank from UST Finder
--      (e.g. a non-federally regulated substance), manually modify the generated sql to 
--       include column exclude_from_query and set the value to 'Y'
select insert_sql 
from v_release_needed_mapping_insert_sql 
where release_control_id = 2 and epa_column_name = 'coordinate_source_id';

--paste the insert_sql from the first row below, then run the query:
select distinct 
	'insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 22 || ', ''' || "HOR_REF_DATUM" || ''', '''', null);'
from "Tank_Cleanup_Incidents"
order by 1;
 
--paste the generated insert statements from the query above below, then manually update each one to fill in the missing epa_value
--if necessary, replace the "null" with any questions or comments you have about the specific mapping 
--insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (22, 'NAD27', '', null);
--insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (22, 'NAD83', '', null);
--insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (22, 'UNK', '', null);
--insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (22, 'WGS84', '', null);

insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (22, 'NAD27', 'Map interpolation', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (22, 'NAD83', 'Map interpolation', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (22, 'UNK', 'Unknown', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (22, 'WGS84', 'Map interpolation', null);

--to assist with the mapping above, check the archived mapping table for old examples of mapping 
select distinct state_value, epa_value
from archive.v_lust_element_mapping 
where lower(element_name) like lower('%coord%')
order by 1, 2;
--Estimated									Map interpolation
--Geocode									Geocoded address
--GPS_EPA									GPS
--GPS_State									GPS
--GPS_Tribe									GPS
--Legacy Verified							Other
--OnlineMapGoogle							Map interpolation
--OnlineMapMS								Map interpolation
--Site Assessment Report by MCE Environmental dated 2/12/2003	Other
--Trimble, collected 5/3/2010				Other
--Trimble, collected 5/4/2010				Other
--Trimble, collected 5/5/2010				Other

--list valid EPA values to paste into sql above 
select * from public.coordinate_sources order by 1;
--Map interpolation
--GPS
--PLSS
--Geocoded address
--Other
--Unknown

--!!! WARNING! Some of the lookups have changed for the new template format, so if you used the 
--archive.v_ust_element_mapping and/or archive.v_lust_element_mapping views and copied values 
--directly from them, you may have to update them:
select distinct epa_value
from release_element_value_mapping a join release_element_mapping b on a.release_element_mapping_id = b.release_element_mapping_id
where release_control_id = 2 and epa_column_name = 'coordinate_source_id'
and epa_value not in (select coordinate_source from coordinate_sources)
order by 1;
--no results are returned by this query, so we don't need to update anything
--(see substances section below for steps to take if there are rows returned by this query)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--how_release_detected_id

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from "' || organization_table_name || '" order by 1;'
from v_release_needed_mapping 
where release_control_id = 2 and epa_column_name = 'how_release_detected_id';

--run the query from the generated sql above to see what the state's data looks like
--you are checking to make sure their values line up with what we are looking for on the EPA side
--(this should have been done during the element mapping above but you can review it now)
--Next, see if the state values need to be deaggregated 
--(that is, is there only one value per row in the state data? If not, we need to deaggregate them)
select distinct "RELEASE_DISCOVERED" from "Tank_Cleanup_Incidents" order by 1;
--3PTY
--3PTY, CLOS
--3PTY, CLOS, SAMPL
--3PTY, CLOS, VISOD
--3PTY, UPGRD
--3PTY, VISOD
--CLOS
--CLOS, CONST
--CLOS, CONST, SAMPL
--....

--in this case we have comma-separated values in single rows, which means we need to deaggregate them in order to map them. 
--Run deagg.py, setting the state table name and state column name 
--the script will create a deagg table and return the name of the new table; in this case: erg_source_cause_of_release_deagg
--check the contents of the deagg table:
select * from erg_release_discovered_deagg order by 2;

--!! update release_element_mapping with the new deagg_table_name and deagg_column_name, generated by deagg.py
update release_element_mapping set deagg_table_name = 'erg_release_discovered_deagg', deagg_column_name = '"RELEASE_DISCOVERED"' 
where release_control_id = 2 and epa_column_name = 'how_release_detected_id';

--generate generic sql to insert value mapping rows into release_element_value_mapping, 
--then modify the generated sql with the mapped EPA values 
--NOTE: insert a NULL for epa_value if you don't have a good guess 
--NOTE: if the organization_value is one that should exclude the facility/tank from UST Finder
--      (e.g. a non-federally regulated substance), manually modify the generated sql to 
--       include column exclude_from_query and set the value to 'Y'
select insert_sql 
from v_release_needed_mapping_insert_sql 
where release_control_id = 2 and epa_column_name = 'how_release_detected_id';

select distinct 
	'insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 29 || ', ''' || "RELEASE_DISCOVERED" || ''', '''', null);'
from "erg_release_discovered_deagg" order by 1;

--below I have mapped the ones I can take a reasonable guess at, but I've inserted nulls for the ones I have no idea about 
--the state codes are pretty obtuse so I'm not very confident of my mapping on any of them; therefore I've added a "please verify" comment 
--for the ones I took a stab at mapping, as well as "MAPPING NEEDED" for those I didn't. This way, when the mapping is exported to
--the review template, EPA and the state have a visual indicator that we need their input for all of them. 
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (29, '3PTY', 'Third party (well water, vapor intrusion, etc.)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (29, 'CLOS', 'At tank removal', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (29, 'CONST', 'Other', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (29, 'DEPI', null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (29, 'GW', 'GW monitoring well', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (29, 'LD', null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (29, 'MWELL', null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (29, 'SAMPL', null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (29, 'SWELL', null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (29, 'TLI', null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (29, 'TTEST', 'Tank tightness testing', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (29, 'UNDTD', 'Unknown', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (29, 'UPGRD', null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (29, 'VISOD', 'Visual (overfill)', 'Please verify');

--these are the valid EPA values to map to the state values above 
select * from public.how_release_detected order by 2;
--At tank removal
--GW monitoring well
--Inspection
--Interstial monitor
--Other
--Overfill alarm
--Statistical Inventory Reconciliation (SIR)
--Tank tightness testing
--Third party (well water, vapor intrusion, etc.)
--Unknown
--Vapor monitoring
--Visual (overfill)


--TODO: add additional mapping!!
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--release_status_id

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from "' || organization_table_name || '" order by 1;'
from v_release_needed_mapping 
where release_control_id = 2 and epa_column_name = 'release_status_id';

--run the query from the generated sql above to see what the state's data looks like
--you are checking to make sure their values line up with what we are looking for on the EPA side
--(this should have been done during the element mapping above but you can review it now)
--Next, see if the state values need to be deaggregated 
--(that is, is there only one value per row in the state data? If not, we need to deaggregate them)
select distinct "STATUS_DESCRIPTION" from "Tank_Cleanup_Incidents" order by 1;
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
select * from release_statuses order by 2;
--Active: Corrective Action
--Active: general
--Active: post Corrective Action monitoring
--Active: site investigation
--Active: stalled
--No further action
--Other
--Unknown

--generate generic sql to insert value mapping rows into release_element_value_mapping, 
--then modify the generated sql with the mapped EPA values 
--NOTE: insert a NULL for epa_value if you don't have a good guess 
--NOTE: if the organization_value is one that should exclude the facility/tank from UST Finder
--      (e.g. a non-federally regulated substance), manually modify the generated sql to 
--       include column exclude_from_query and set the value to 'Y'
select insert_sql 
from v_release_needed_mapping_insert_sql 
where release_control_id = 2 and epa_column_name = 'release_status_id';

select distinct 
	'insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 23 || ', ''' || "STATUS_DESCRIPTION" || ''', '''', null);'
from "Tank_Cleanup_Incidents" order by 1;

--These are a little easier to map because they are more descriptive, but I've still put a comment to "please verify"
--on a couple I wasn't 100% sure about; this will help draw attention to them when EPA/the state review the exported template. 
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (23, 'Administrative Close Out (ACO)', 'No further action', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (23, 'Attainment Monitoring in Progress', 'Active: post Corrective Action monitoring', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (23, 'Cleanup Completed', 'No further action', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (23, 'Inactive', 'Other', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (23, 'Interim or Remedial Actions Initiated', 'Active: Corrective Action', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (23, 'Interim Remedial Actions Not Initiated', 'Active: general', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (23, 'Suspected Release - Invest. Complete, No Release Confirmed', 'Other', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (23, 'Suspected Release - Investigation Pending or Initiated', 'Other', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (23, 'Unverified Incident', 'Other', null);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--substance_id

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from "' || organization_table_name || '" order by 1;'
from v_release_needed_mapping 
where release_control_id = 2 and epa_column_name = 'substance_id';

--run the query from the generated sql above to see what the state's data looks like
--you are checking to make sure their values line up with what we are looking for on the EPA side
--(this should have been done during the element mapping above but you can review it now)
--Next, see if the state values need to be deaggregated 
--(that is, is there only one value per row in the state data? If not, we need to deaggregate them)
select distinct "SUBSTANCE" from "Tank_Cleanup_Incidents" order by 1;
--Aviation Gasoline
--Chlorinated Solvents
--Diesel Fuel
--Fuel Oil No 1
--Fuel Oil No 2
--Fuel Oil No 4
--Fuel Oil No 5
--Fuel Oil No 6
--Gasohol (>15% alcohol)
--Gasoline
--Inorganics
--Jet Fuel
--Kerosene
--Lead
--Leaded Gasoline
--MTBE
--New Motor Oil
--Other Organics
--PAH
--PCB
--Pesticides
--Unleaded Gasoline
--Used Motor Oil

--in this case there is only one value per row so we can begin mapping 

--generate generic sql to insert value mapping rows into release_element_value_mapping, 
--then modify the generated sql with the mapped EPA values 
--NOTE: insert a NULL for epa_value if you don't have a good guess 
--NOTE: if the organization_value is one that should exclude the facility/tank from UST Finder
--      (e.g. a non-federally regulated substance), manually modify the generated sql to 
--       include column exclude_from_query and set the value to 'Y'
select insert_sql 
from v_release_needed_mapping_insert_sql 
where release_control_id = 2 and epa_column_name = 'substance_id';

--paste the insert_sql from the first row below, then run the query:
select distinct 
	'insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 30 || ', ''' || "SUBSTANCE" || ''', '''', null);'
from "Tank_Cleanup_Incidents" order by 1;

insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (30, 'Aviation Gasoline', 'Aviation gasoline', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (30, 'Chlorinated Solvents', 'Solvent', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (30, 'Diesel Fuel', 'Diesel fuel (b-unknown)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (30, 'Fuel Oil No 1', 'Heating oil/fuel oil 1', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (30, 'Fuel Oil No 2', 'Heating oil/fuel oil 2', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (30, 'Fuel Oil No 4', 'Heating oil/fuel oil 4', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (30, 'Fuel Oil No 5', 'Heating oil/fuel oil 5', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (30, 'Fuel Oil No 6', 'Heating oil/fuel oil 6', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (30, 'Gasohol (>15% alcohol)', 'Ethanol blend gasoline (e-unknown)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (30, 'Gasoline', 'Gasoline (unknown type)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (30, 'Inorganics', 'Other', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (30, 'Jet Fuel', 'Jet fuel A', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (30, 'Kerosene', 'Kerosene', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (30, 'Lead', 'Hazardous substance', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (30, 'Leaded Gasoline', 'Gasoline (unknown type)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (30, 'MTBE', 'Petroleum product', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (30, 'New Motor Oil', 'Lube/motor oil (new)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (30, 'Other Organics', 'Other', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (30, 'PAH', 'Hazardous substance', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (30, 'PCB', 'Hazardous substance', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (30, 'Pesticides', 'Hazardous substance', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (30, 'Unleaded Gasoline', 'Gasoline (unknown type)', null);
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (30, 'Used Motor Oil', 'Used oil/waste oil', null);

--list valid EPA values to paste into sql above 
select * from public.substances order by 1;

--search for EPA values:
select substance from public.substances 
where lower(substance) like lower('%used%')
order by 1;

--to assist with the mapping above, check the archived mapping table for old examples of mapping 
--in the case of Substances, you can check both v_lust_element_mapping and v_ust_element_mapping!
select distinct state_value, epa_value from 
	(select state_value, epa_value
	from archive.v_lust_element_mapping 
	where lower(element_name) like '%substance%' 
	union all 
	select state_value, epa_value
	from archive.v_ust_element_mapping 
	where lower(element_name) like '%substance%') x
where lower(state_value) like lower('%gashol%')
order by 1, 2;

--!!! WARNING! Some of the lookups have changed for the new template format, so if you used the 
--archive.v_ust_element_mapping and/or archive.v_lust_element_mapping views and copied values 
--directly from them, you may have to update them:
select distinct epa_value
from release_element_value_mapping a join release_element_mapping b on a.release_element_mapping_id = b.release_element_mapping_id
where release_control_id = 2 and epa_column_name = 'substance_id'
and epa_value not in (select substance from substances)
order by 1;
--Other

--Get the updated value from the current lookup:
select * from substances where lower(substance) like lower('%other%');
--Other unlisted blend containing any other mixture of diesel, renewable diesel, or 20% biodiesel or less
--Other unlisted blend containing any other mixture of diesel, renewable diesel, or more than 20% biodiesel
--Other or mixture

--update release_element_value_mapping with the new value
update release_element_value_mapping a set epa_value = 'Other or mixture'
where epa_value = 'Other' and release_element_mapping_id in 
	(select release_element_mapping_id from release_element_mapping 
	where release_control_id = 2 and epa_column_name = 'substance_id');


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--source_id

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from "' || organization_table_name || '" order by 1;'
from v_release_needed_mapping 
where release_control_id = 2 and epa_column_name = 'source_id';

--run the query from the generated sql above to see what the state's data looks like
--you are checking to make sure their values line up with what we are looking for on the EPA side
--(this should have been done during the element mapping above but you can review it now)
--Next, see if the state values need to be deaggregated 
--(that is, is there only one value per row in the state data? If not, we need to deaggregate them)
select distinct "SOURCE_CAUSE_OF_RELEASE" from "Tank_Cleanup_Incidents" order by 1;
--ACCND
--ACCND, CONT, DISP, PHMEF, SPCB
--ACCND, DISP
--ACCND, PAST
--ACCND, PUST
--ACCND, SUBTP
--....

--in this case we have comma-separated values in single rows, which means we need to deaggregate them in order to map them. 
--Run deagg.py, setting the state table name and state column name 
--the script will create a deagg table and return the name of the new table; in this case: erg_source_cause_of_release_deagg
--check the contents of the deagg table:
select * from erg_source_cause_of_release_deagg order by 2;

--!! update release_element_mapping with the new deagg_table_name and deagg_column_name, generated by deagg.py
update release_element_mapping set deagg_table_name = 'erg_source_cause_of_release_deagg', deagg_column_name = '"SOURCE_CAUSE_OF_RELEASE"' 
where release_control_id = 2 and epa_column_name = 'source_id';

--generate generic sql to insert value mapping rows into release_element_value_mapping, 
--then modify the generated sql with the mapped EPA values 
--NOTE: insert a NULL for epa_value if you don't have a good guess 
--NOTE: if the organization_value is one that should exclude the facility/tank from UST Finder
--      (e.g. a non-federally regulated substance), manually modify the generated sql to 
--       include column exclude_from_query and set the value to 'Y'
select insert_sql 
from v_release_needed_mapping_insert_sql 
where release_control_id = 2 and epa_column_name = 'source_id';

select distinct 
	'insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 32 || ', ''' || "SOURCE_CAUSE_OF_RELEASE" || ''', '''', null);'
from "erg_source_cause_of_release_deagg" order by 1;

--Mapping I was able to guess at: 
--DISP	Dispenser
--OTHR	Other
--SUBTP	Submersible turbine pump
--TANK	Tank
 
--below I have mapped the ones I can take a reasonable guess at, but I've inserted nulls for the ones I have no idea about 
--the state codes are pretty obtuse so I'm not very confident of my mapping on any of them; therefore I've added a "please verify" comment 
--for the ones I took a stab at mapping, as well as "MAPPING NEEDED" for those I didn't. This way, when the mapping is exported to
--the review template, EPA and the state have a visual indicator that we need their input for all of them. 
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (32, 'ACCND', null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (32, 'CONT', null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (32, 'CORR', null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (32, 'DISP', 'Dispenser', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (32, 'FLTYI', null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (32, 'HOSE', null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (32, 'INFNP', null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (32, 'OTHR', 'Other', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (32, 'OVER', null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (32, 'PAST', null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (32, 'PHMEF', null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (32, 'PSNR', null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (32, 'PUST', null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (32, 'SPCB', null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (32, 'SPILL', null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (32, 'SUBTP', 'Submersible turbine pump', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (32, 'TANK', 'Tank', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (32, 'UNDTD', 'Unknown', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (32, 'VEHIC', null, 'MAPPING NEEDED');

--put a comment here to remember to come back to this 
--TODO: add additional mapping!!


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--cause_id

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from "' || organization_table_name || '" order by 1;'
from v_release_needed_mapping 
where release_control_id = 2 and epa_column_name = 'cause_id';

--in this case, the state combined their source and cause values into a single column, 
--so we have already deagged this table when we did the sources above
select distinct "SOURCE_CAUSE_OF_RELEASE" from "Tank_Cleanup_Incidents" order by 1;
--ACCND
--ACCND, CONT, DISP, PHMEF, SPCB
--ACCND, DISP
--ACCND, PAST
--ACCND, PUST
--ACCND, SUBTP

--!! update release_element_mapping with the new deagg_table_name and deagg_column_name, generated by deagg.py
update release_element_mapping set deagg_table_name = 'erg_source_cause_of_release_deagg', deagg_column_name = '"SOURCE_CAUSE_OF_RELEASE"' 
where release_control_id = 2 and epa_column_name = 'cause_id';

--generate generic sql to insert value mapping rows into release_element_value_mapping, 
--then modify the generated sql with the mapped EPA values 
--NOTE: insert a NULL for epa_value if you don't have a good guess 
--NOTE: if the organization_value is one that should exclude the facility/tank from UST Finder
--      (e.g. a non-federally regulated substance), manually modify the generated sql to 
--       include column exclude_from_query and set the value to 'Y'
select insert_sql 
from v_release_needed_mapping_insert_sql 
where release_control_id = 2 
and epa_column_name = 'cause_id';

select distinct 
	'insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 31 || ', ''' || "SOURCE_CAUSE_OF_RELEASE" || ''', '''', null);'
from "erg_source_cause_of_release_deagg" order by 1;

--Mapping I was able to guess at: 
--CORR	Corrosion
--HOSE	Damage to dispenser hose
--OTHR	Other
--OVER	Delivery overfill
--SPILL	Dispenser spill
--VEHIC	Motor vehicle accident
 
--below I have mapped the ones I can take a reasonable guess at, but I've inserted nulls for the ones I have no idea about 
--the state codes are pretty obtuse so I'm not very confident of my mapping on any of them; therefore I've added a "please verify" comment 
--for the ones I took a stab at mapping, as well as "MAPPING NEEDED" for those I didn't. This way, when the mapping is exported to
--the review template, EPA and the state have a visual indicator that we need their input for all of them. 
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (31, 'ACCND',  null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (31, 'CONT',  null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (31, 'CORR', 'Corrosion', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (31, 'DISP',  null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (31, 'FLTYI',  null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (31, 'HOSE', 'Damage to dispenser hose');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (31, 'INFNP', null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (31, 'OTHR', 'Other', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (31, 'OVER', 'Overfill (general)');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (31, 'PAST',  null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (31, 'PHMEF',  null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (31, 'PSNR',  null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (31, 'PUST',  null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (31, 'SPCB',  null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (31, 'SPILL', 'Dispenser spill', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (31, 'SUBTP',  null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (31, 'TANK',  null, 'MAPPING NEEDED');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (31, 'UNDTD', 'Unknown', 'Please verify');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values (31, 'VEHIC', 'Motor vehicle accident', 'Please verify');

--TODO: add additional mapping!!
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--check if there is any more mapping to do
select distinct epa_table_name, epa_column_name
from v_release_needed_mapping 
where release_control_id = 2 and mapping_complete = 'N'
order by 1, 2;

--check if any of the mapping is bad:
select database_lookup_table, epa_value 
from v_release_bad_mapping 
where release_control_id = 2 order by 1, 2;
--!!!if there are results from this query, fix them!!!

--if not, it's time to write the queries that manipulate the state's data into EPA's tables 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--Step 1: create crosswalk views for columns that use a lookup table
--run script org_mapping_xwalks.py to create crosswalk views for all lookup tables 
--see new views:
select table_name 
from information_schema.tables 
where table_schema = 'pa_release' and table_type = 'VIEW'
and table_name like '%_xwalk' order by 1;
--v_cause_xwalk
--v_coordinate_source_xwalk
--v_how_release_detected_xwalk
--v_release_status_xwalk
--v_source_xwalk
--v_substance_xwalk


--Step 2: see the EPA tables we need to populate, and in what order
select distinct epa_table_name, table_sort_order
from v_release_table_population 
where release_control_id = 2
order by table_sort_order;
--ust_release
--ust_release_substance
--ust_release_source
--ust_release_cause

--Step 3: check if there where any dataset-level comments you need to incorporate:
--in this case we need to ignore the aboveground storage tanks,
--so add this to the where clause of the ust_release view 
select comments from release_control where release_control_id = 2;
--ignore rows where "INCIDENT_TYPE" = 'AST'

select * from v_release_table_population;

--Step 4: work through the tables in order, using the information you collected 
--to write views that can be used to populate the data tables 
--NOTE! The view queried below (v_release_table_population_sql) contains columns that help
--      construct the select sql for the insertion views, but will require manual 
--      oversight and manipulation by you! 
--      In particular, check out the organization_join_table and organization_join_column 
--      are used!!
select organization_table_name_qtd, selected_column, programmer_comments, 
	database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_release_table_population_sql
where release_control_id = 2 and epa_table_name = 'ust_release'
order by column_sort_order;

--Step 5: use the information from the queries above to create the view:
--!!! NOTE how I'm using the programmer_comments column to adjust the view (e.g. nfa_date)
--!!! NOTE also sometimes you need to explicitly cast data types. In this example, the two
--    dates "CONFIRMED_DATE" and "STATUS_DATE" are text fields in the state's data and need 
--    to be cast as dates to fit into the EPA table  
--!!! NOTE also you may get errors related to data conversion when trying to compile the view
--    you are creating here. This is good because it alerts you the data you are trying to
--    insert is not compatible with the EPA format. Fix these errors before proceeding! 
--!!! NOTE: Remember to do "select distinct" if necessary
--!!! NOTE: Some states do not include State or EPA Region in their database, but it is generally
--    safe for you to insert these yourself, so add them! 
create or replace view pa_release.v_ust_release as 
select distinct 
		"FACILITY_ID"::character varying(50) as facility_id,
		"TANK"::character varying(50) as tank_id_associated_with_release,
		"INCIDENT_ID"::character varying(50) as release_id,
		"FACILITY_NAME"::character varying(200) as site_name,
		"ADDRESS1"::character varying(100) as site_address,
		"ADDRESS2"::character varying(100) as site_address2,
		"CITY"::character varying(100) as site_city,
		"ZIP"::character varying(10) as zipcode,
		'PA' as state, 
		3 as epa_region, 
		"LATITUDE"::double precision as latitude,
		"LONGITUDE"::double precision as longitude,
		coordinate_source_id as coordinate_source_id,
		release_status_id as release_status_id,
		"CONFIRMED_DATE"::date as reported_date,
		case when "STATUS_DESCRIPTION" = 'Cleanup Completed' then "STATUS_DATE"::date end as nfa_date, 
		case when "IMPACT_DESCRIPTION" = 'Soil' then 'Yes' end as media_impacted_soil,
		case when "IMPACT_DESCRIPTION" = 'Ground Water' then 'Yes' end as media_impacted_groundwater,
		case when "IMPACT_DESCRIPTION" = 'Surface Water' then 'Yes' end as media_impacted_surface_water,
		how_release_detected_id
from "Tank_Cleanup_Incidents" x 
	left join pa_release.v_coordinate_source_xwalk cs on x."HOR_REF_DATUM" = cs.organization_value 
	left join pa_release.v_release_status_xwalk	rs on x."STATUS_DESCRIPTION" = rs.organization_value 
	left join pa_release.v_how_release_detected_xwalk rd on x."RELEASE_DISCOVERED" = rd.organization_value 
where "INCIDENT_TYPE" <> 'AST';

--review: 
select * from pa_release.v_ust_release;
select count(*) from pa_release.v_ust_release;
--69865
--------------------------------------------------------------------------------------------------------------------------
--now repeat for each data table:

--ust_release_substance 
select organization_table_name_qtd, selected_column, programmer_comments, 
	database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_release_table_population_sql
where release_control_id = 2 and epa_table_name = 'ust_release_substance'
order by column_sort_order;

--be sure to do select distinct if necessary!
create or replace view pa_release.v_ust_release_substance as 
select distinct "INCIDENT_ID"::character varying(50) as release_id,
		s.substance_id
from "Tank_Cleanup_Incidents" x 
	join pa_release.v_substance_xwalk s on x."SUBSTANCE" = s.organization_value 
where s.substance_id is not null 
and "INCIDENT_TYPE" <> 'AST'; 

select * from pa_release.v_ust_release_substance;
select count(*) from pa_release.v_ust_release_substance;
--62868
--------------------------------------------------------------------------------------------------------------------------
--ust_release_source 
select organization_table_name_qtd, selected_column, programmer_comments, 
	database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_release_table_population_sql
where release_control_id = 2 and epa_table_name = 'ust_release_source'
order by column_sort_order;

--!! this one has a deagg table so we have to alter the join 
create or replace view pa_release.v_ust_release_source as 
select distinct "INCIDENT_ID"::character varying(50) as release_id,
		b.source_id
from "Tank_Cleanup_Incidents" a join pa_release.v_source_xwalk b on a."SOURCE_CAUSE_OF_RELEASE" like '%' || b.organization_value || '%'
where epa_value is not null
and "INCIDENT_TYPE" <> 'AST';
	
select * from pa_release.v_ust_release_source;
select count(*) from pa_release.v_ust_release_source;
--5138

--------------------------------------------------------------------------------------------------------------------------
--ust_release_cause 

select organization_table_name_qtd, selected_column, programmer_comments, 
	database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_release_table_population_sql
where release_control_id = 2 and epa_table_name = 'ust_release_cause'
order by column_sort_order;

--!! this one has a deagg table so we have to alter the join 
create or replace view pa_release.v_ust_release_cause as 
select distinct "INCIDENT_ID"::character varying(50) as release_id,
		b.cause_id
from "Tank_Cleanup_Incidents" a join pa_release.v_cause_xwalk b on a."SOURCE_CAUSE_OF_RELEASE" like '%' || b.organization_value || '%'
where epa_value is not null
and "INCIDENT_TYPE" <> 'AST';
	
select * from pa_release.v_ust_release_cause;
select count(*) from pa_release.v_ust_release_cause;
--3120

--------------------------------------------------------------------------------------------------------------------------
--QA/QC

--check that you didn't miss any columns when creating the data population views:
--if any rows are returned by this query, fix the appropriate view by adding the missing columns!
select epa_table_name, epa_column_name, 
	organization_table_name, organization_column_name, 
	organization_join_table, organization_join_column, 
	deagg_table_name, deagg_column_name
from v_release_missing_view_mapping a
where release_control_id = 2
order by 1, 2;

--select b.column_name, b.data_type, b.character_maximum_length, a.data_type, a.character_maximum_length 
--from information_schema.columns a join information_schema.columns b on a.column_name = b.column_name 
--where a.table_schema = 'pa_release' and a.table_name = 'v_ust_release'
--and b.table_schema = 'public' and b.table_name = 'ust_release'
--and (a.data_type <> b.data_type or b.character_maximum_length > a.character_maximum_length )
--order by b.ordinal_position;

--run Python QA/QC script

--run script qa_check.py
--set variables:
--ust_or_release = 'release' 
--control_id = 2
--export_file_path = None # If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
--export_file_dir = None	# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
--export_file_name = None	# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo

--This script will check for the following:
--1) Non-unique rows in pa_release.v_ust_release, pa_release.v_ust_release_substance, pa_release.v_ust_release_source,
--   pa_release.v_ust_release_source, and pa_release.v_ust_release_corrective_action_strategy (if these views exist). 
--   To resolve any cases where the counts are greater than 0, check that you did a "select distinct" when creating these rows. 
--2) Failed check constraints. 
--3) Bad mapping values. To resolve any cases where bad mapping values exist, examine the specific row(s) in public.release_element_value_mapping 
--   and ensure the epa_value exists in the associated lookup table. 
--The script will also provide the counts of rows in pa_release.v_ust_release, pa_release.v_ust_release_substance, pa_release.v_ust_release_source,
--   pa_release.v_ust_release_source, and pa_release.v_ust_release_corrective_action_strategy (if these views exist) - ensure these counts 
-- make sense! 

--------------------------------------------------------------------------------------------------------------------------
--insert data into the EPA schema 

--run script populate_epa_data_tables.py	
--set variables:
--ust_or_release = 'release' 
--control_id = 2
--delete_existing = False # can set to True if there is existing release data you need to delete before inserting new

--------------------------------------------------------------------------------------------------------------------------
--export template

--run script export_template.py
--set variables:
--control_id = 2
--ust_or_release = 'release' 
--organization_id = None  	# Can leave as None if you specify the control_id
--data_only = False 		# Set to False to export full template including mapping and reference tabs
--template_only = False 	# Set to False to export data and mapping tabs as well as reference tab
--export_file_path = None # If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
--export_file_dir = None	# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
--export_file_name = None	# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo


--------------------------------------------------------------------------------------------------------------------------
