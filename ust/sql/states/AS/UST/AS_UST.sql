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
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 2: Update the control table 
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 3: Get an overview of the source data and prepare it for processing

/* Run this query to see what tables we have: 
*/
select table_name from information_schema.tables 
where table_schema = lower('AS_ust') order by 1;

 -- Check the column names out too:
 
select table_name, column_name
from information_schema.columns
where table_schema = lower('AS_ust') 
order by table_name, ordinal_position;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 4: Map the source data elements to the EPA template elements (public.ust_element_mapping)
select * from public.v_ust_element_summary_sql;

----=====create erg_table=============
--create table as_ust."erg_tank" as table as_ust."Tank"
SELECT "FacilityID", substr("TankID",1,10) Tank1, substr("TankID",12,14) Tank2 
FROM as_ust."Tank" where "FacilityID" like '%A& T Service Station%' 

SELECT "FacilityID", substr("TankID",1,11) Tank1, substr("TankID",48,14) Tank2 
FROM as_ust."Tank" where "FacilityID"='Nu''uuli Way Service Station';

SELECT "FacilityID", substr("TankID",1,10) Tank1, substr("TankID",36,10) Tank2 ,  substr("TankID",84,15)  tank3 
FROM as_ust."Tank" where "FacilityID" like '%Pavaiai Country Station%' ;

----- erg_tank---------
CREATE TABLE IF NOT EXISTS as_ust.erg_tank
(
    facility_id character varying(100) COLLATE pg_catalog."default",
    tank_name character varying(100) COLLATE pg_catalog."default",
    tank_id integer,
    tank_location character varying(100) COLLATE pg_catalog."default",
    tank_status character varying(100) COLLATE pg_catalog."default",
    federally_regulated character varying(7) COLLATE pg_catalog."default",
    tank_installation_date date,
    tank_material_description character varying(100) COLLATE pg_catalog."default",
    tank_secondary_containment character varying(100) COLLATE pg_catalog."default"
);

INSERT INTO as_ust.erg_tank(
	facility_id, tank_name, tank_id, tank_location, tank_status, federally_regulated, tank_installation_date, tank_material_description, tank_secondary_containment)
select "FacilityID", substr("TankID",1,10), 1, 'Underground entirely buried',"TankStatus", 'Yes',  '1993-01-01',"TankMaterialDescription", 'DW' 
from as_ust."Tank" where "FacilityID" like 'A&%';
INSERT INTO as_ust.erg_tank(
	facility_id, tank_name, tank_id, tank_location, tank_status, federally_regulated,  tank_installation_date, tank_material_description,  tank_secondary_containment)
select "FacilityID", substr("TankID",12,14), 2, 'Underground entirely buried',"TankStatus", 'Yes',  '1993-01-01',"TankMaterialDescription", 'DW'
from as_ust."Tank" where "FacilityID" like 'A&%';
INSERT INTO as_ust.erg_tank(
	facility_id, tank_name, tank_id, tank_location, tank_status, federally_regulated,  tank_installation_date, tank_material_description, tank_secondary_containment)
select "FacilityID", substr("TankID",1,11), 1, 'Underground entirely buried',"TankStatus", 'Yes',  '1993-10-01',"TankMaterialDescription", null
from as_ust."Tank" where "FacilityID" like 'Nu%';
INSERT INTO as_ust.erg_tank(
	facility_id, tank_name, tank_id, tank_location, tank_status, federally_regulated,   tank_installation_date, tank_material_description, tank_secondary_containment)
select "FacilityID", substr("TankID",48,14), 2, 'Underground entirely buried',"TankStatus", 'Yes', '1993-10-01',"TankMaterialDescription", null 
from as_ust."Tank" where "FacilityID" like 'Nu%';
INSERT INTO as_ust.erg_tank(
	facility_id, tank_name, tank_id, tank_location, tank_status, federally_regulated,  tank_installation_date, tank_material_description, tank_secondary_containment)
select "FacilityID", substr("TankID",1,10), 1, 'Underground entirely buried',"TankStatus", 'Yes',  '1989-01-01',"TankMaterialDescription", 'DW' 
from as_ust."Tank" where "FacilityID" like 'Pa%';
INSERT INTO as_ust.erg_tank(
	facility_id, tank_name, tank_id, tank_location, tank_status, federally_regulated,  tank_installation_date, tank_material_description,  tank_secondary_containment)
select "FacilityID", substr("TankID",36,10), 2, 'Underground entirely buried',"TankStatus", 'Yes',  '1989-01-01',"TankMaterialDescription", 'DW'
from as_ust."Tank" where "FacilityID" like 'Pa%';
INSERT INTO as_ust.erg_tank(
	facility_id, tank_name, tank_id, tank_location, tank_status, federally_regulated,  tank_installation_date, tank_material_description, tank_secondary_containment)
select "FacilityID", substr("TankID",84,15), 3, 'Underground entirely buried',"TankStatus", 'Yes', '1989-01-01',"TankMaterialDescription", 'DW' 
from as_ust."Tank" where "FacilityID" like 'Pa%';
-- Tank.FacilityID <> Facility.FacilityID for some, due to extra space in Tank.FacilityID. 
update as_ust.erg_tank 
set facility_id=(select distinct "FacilityID" from as_ust."Facility" where "FacilityID" like 'A%')
where facility_id like 'A%';

update as_ust.erg_tank 
set facility_id=(select distinct "FacilityID" from as_ust."Facility" where "FacilityID" like 'Pa%')
where facility_id like 'Pa%';

 ----erg_compartment -------------------------
CREATE TABLE as_ust.erg_compartment 
(
	facility_id varchar(100) NULL,
	tank_name varchar(100) NULL,
	tank_id   integer,
	compartment_id integer,
    overfill_prevention_high_level_alarm varchar(7) NULL,
	spill_bucket_installed varchar(7) NULL,
	concrete_berm_installed varchar(7) NULL,
     tank_automatic_tank_gauging_release_detection varchar(7) NULL,
	automatic_tank_gauging_continuous_leak_detection varchar(7) NULL,
	tank_manual_tank_gauging varchar(7) NULL,
	tank_tightness_testing varchar(7) NULL,
	tank_inventory_control varchar(7) NULL,
     compartment_status varchar(10) NULL);
INSERT INTO as_ust.erg_compartment(
	facility_id, tank_name, tank_id, compartment_id, overfill_prevention_high_level_alarm, spill_bucket_installed, 
	concrete_berm_installed,  tank_automatic_tank_gauging_release_detection, automatic_tank_gauging_continuous_leak_detection, 
	tank_manual_tank_gauging, tank_tightness_testing, tank_inventory_control,compartment_status)
select facility_id, tank_name, tank_id, 1, 'Yes', 'Yes', null, 'Yes','Yes','Yes', 'Yes','Yes', 'Active'
	from  as_ust.erg_tank  where facility_id like 'A&%' and tank_id=1;
INSERT INTO as_ust.erg_compartment(
	facility_id, tank_name, tank_id, compartment_id, overfill_prevention_high_level_alarm, spill_bucket_installed, 
	concrete_berm_installed, tank_automatic_tank_gauging_release_detection, automatic_tank_gauging_continuous_leak_detection, 
	tank_manual_tank_gauging, tank_tightness_testing, tank_inventory_control,compartment_status)
select  facility_id, tank_name, tank_id, 1, 'Yes', 'Yes', null,'Yes','Yes','Yes', 'Yes','Yes','Active'
	from  as_ust.erg_tank     where facility_id like 'A&%' and tank_id=2;
INSERT INTO as_ust.erg_compartment(
	facility_id, tank_name, tank_id, compartment_id, overfill_prevention_high_level_alarm, spill_bucket_installed, 
	concrete_berm_installed, tank_automatic_tank_gauging_release_detection, automatic_tank_gauging_continuous_leak_detection, 
	tank_manual_tank_gauging, tank_tightness_testing, tank_inventory_control,compartment_status)
select  facility_id, tank_name, tank_id, 1, 'Yes', 'Yes', 'Yes','Yes',null,'Yes', 'Yes','Yes','Active'
	from  as_ust.erg_tank     where facility_id like 'Nu%' and tank_id=1;   
INSERT INTO as_ust.erg_compartment(
	facility_id, tank_name, tank_id, compartment_id, overfill_prevention_high_level_alarm, spill_bucket_installed, 
	concrete_berm_installed, tank_automatic_tank_gauging_release_detection, automatic_tank_gauging_continuous_leak_detection, 
	tank_manual_tank_gauging, tank_tightness_testing, tank_inventory_control,compartment_status)
select  facility_id, tank_name, tank_id, 1, 'Yes', 'Yes', 'Yes','Yes',null,'Yes', 'Yes','Yes','Active'
	from  as_ust.erg_tank     where facility_id like 'Nu%' and tank_id=2;
INSERT INTO as_ust.erg_compartment(
	facility_id, tank_name, tank_id, compartment_id, overfill_prevention_high_level_alarm, spill_bucket_installed, 
	concrete_berm_installed, tank_automatic_tank_gauging_release_detection, automatic_tank_gauging_continuous_leak_detection, 
	tank_manual_tank_gauging, tank_tightness_testing, tank_inventory_control,compartment_status)
select  facility_id, tank_name, tank_id, 1, 'Yes', 'Yes', null,'Yes','Yes','Yes', 'Yes','Yes','Active'
	from  as_ust.erg_tank     where facility_id like 'Pa%' and tank_id=1;
INSERT INTO as_ust.erg_compartment(
	facility_id, tank_name, tank_id, compartment_id, overfill_prevention_high_level_alarm, spill_bucket_installed, 
	concrete_berm_installed, tank_automatic_tank_gauging_release_detection, automatic_tank_gauging_continuous_leak_detection, 
	tank_manual_tank_gauging, tank_tightness_testing, tank_inventory_control,compartment_status)
select facility_id, tank_name, tank_id, 1, 'Yes', 'Yes', null,'Yes','Yes','Yes', 'Yes','Yes','Active'
	from  as_ust.erg_tank     where facility_id like 'Pa%' and tank_id=2;
INSERT INTO as_ust.erg_compartment(
	facility_id, tank_name, tank_id, compartment_id, overfill_prevention_high_level_alarm, spill_bucket_installed, 
	concrete_berm_installed, tank_automatic_tank_gauging_release_detection, automatic_tank_gauging_continuous_leak_detection, 
	tank_manual_tank_gauging, tank_tightness_testing, tank_inventory_control,compartment_status)
select  facility_id, tank_name, tank_id, 1, 'Yes', 'Yes', null,'Yes','Yes','Yes', 'Yes','Yes','Active'
	from  as_ust.erg_tank     where facility_id like 'Pa%' and tank_id=3;

update as_ust.erg_compartment 
set facility_id=(select distinct "FacilityID" from as_ust."Facility" where "FacilityID" like 'A%')
where facility_id like 'A%';

update as_ust.erg_compartment 
set facility_id=(select distinct "FacilityID" from as_ust."Facility" where "FacilityID" like 'Pa%')
where facility_id like 'Pa%';

----erg_tanksubstance-------
insert into as_ust.erg_tanksubstance(facility_id, tank_id, tank_name, tank_substance)
SELECT facility_id, tank_id, tank_name, 'Diesel' 
FROM as_ust.erg_tank where tank_name like '%Diesel';


----erg_piping----------
SELECT * FROM public.piping_styles
ORDER BY piping_style_id ASC;

CREATE TABLE IF NOT EXISTS as_ust.erg_piping
(
    facility_id text COLLATE pg_catalog."default",
    tank_name text COLLATE pg_catalog."default",
    tank_id text COLLATE pg_catalog."default",
    compartment_id integer,
    piping_id integer,
    piping_style text COLLATE pg_catalog."default",
    safesuction text COLLATE pg_catalog."default",
    piping_material_frp text COLLATE pg_catalog."default",
    piping_material_steel text COLLATE pg_catalog."default",
    piping_material_flex text COLLATE pg_catalog."default",
    piping_flex_connector text COLLATE pg_catalog."default",
    piping_line_leak_detector text COLLATE pg_catalog."default",
	piping_line_test_annual text COLLATE pg_catalog."default",
    piping_line_test3yr text COLLATE pg_catalog."default",
    piping_release_detection_other text COLLATE pg_catalog."default",
    pipe_tank_topsump text COLLATE pg_catalog."default",
    pipe_tank_topsump_walltype text COLLATE pg_catalog."default",
    piping_wall_type text COLLATE pg_catalog."default"
);
insert into as_ust.erg_piping
   (facility_id, tank_name, tank_id, compartment_id, piping_id, 
     piping_style, safesuction, piping_material_frp, piping_material_steel,piping_material_flex,
     piping_flex_connector, piping_line_leak_detector,piping_line_test_annual,      
     piping_line_test3yr,piping_release_detection_other,
     pipe_tank_topsump, pipe_tank_topsump_walltype, piping_wall_type)
select facility_id, tank_name, tank_id, 1, 1, 
     'Pressure',null,'Yes', null, 'Yes',
     'Yes','Yes', 'Yes', null, 'Yes',
     'Yes', 'Plastic Sump Wall', 'DW' 
from as_ust.erg_tank where facility_id like 'A&%' and tank_id=1;

insert into as_ust.erg_piping
   (facility_id,tank_name, tank_id,compartment_id, piping_id, 
    piping_style, safesuction, piping_material_frp, piping_material_steel, piping_material_flex,
    piping_flex_connector, piping_line_leak_detector, piping_line_test_annual, piping_line_test3yr, 
    piping_release_detection_other,
    pipe_tank_topsump, pipe_tank_topsump_walltype, piping_wall_type)
select facility_id, tank_name, tank_id, 1, 1, 
     'Pressure',null,'Yes', null, 'Yes',
     'Yes','Yes', 'Yes', null, 'Yes',
     'Yes', 'Plastic Sump Wall', 'DW' 
from as_ust.erg_tank where facility_id like 'A&%' and tank_id=2;

insert into as_ust.erg_piping
  (facility_id,tank_name, tank_id,compartment_id, piping_id, 
    piping_style, safesuction, piping_material_frp, piping_material_steel,piping_material_flex,
    piping_flex_connector, piping_line_leak_detector,piping_line_test3yr,piping_release_detection_other,
    pipe_tank_topsump, pipe_tank_topsump_walltype, piping_wall_type)
select facility_id, tank_name, tank_id, 1, 1, 
     'Pressure', null, null, 'Yes', null,
     'Yes', 'Yes', null, null,
     'Yes', 'Plastic Sump Wall', null 
from as_ust.erg_tank where facility_id like 'Nu%' and tank_id=1;

insert into as_ust.erg_piping
(facility_id,tank_name, tank_id,compartment_id, piping_id, piping_style, safesuction,   
    piping_material_frp, piping_material_steel,piping_material_flex, piping_flex_connector,
    piping_line_leak_detector,piping_line_test3yr,piping_release_detection_other,
    pipe_tank_topsump, pipe_tank_topsump_walltype, piping_wall_type)
select facility_id, tank_name, tank_id, 1, 1, 
     'Suction','Yes', null, 'Yes', null,
     'Yes', null, 'Yes', null,
     'Yes', 'Plastic Sump Wall', null
from as_ust.erg_tank where facility_id like 'Nu%' and tank_id=2;

insert into as_ust.erg_piping
   (facility_id,tank_name, tank_id,compartment_id, piping_id, 
    piping_style, safesuction, piping_material_frp, piping_material_steel,piping_material_flex,
    piping_flex_connector,piping_line_leak_detector,piping_line_test3yr,piping_release_detection_other,
    pipe_tank_topsump, pipe_tank_topsump_walltype, piping_wall_type)
select facility_id, tank_name, tank_id, 1, 1, 
     'Pressure', null,'Yes', null, 'Yes',
     'Yes', 'Yes', null, 'Yes',
     'Yes', 'Plastic Sump Wall', 'DW'
from as_ust.erg_tank where facility_id like 'Pa%' and tank_id=1;

insert into as_ust.erg_piping
(facility_id,tank_name, tank_id,compartment_id, piping_id, 
    piping_style, safesuction,   
    piping_material_frp, piping_material_steel,piping_material_flex,piping_flex_connector,
    piping_line_leak_detector,piping_line_test3yr,piping_release_detection_other,
    pipe_tank_topsump, pipe_tank_topsump_walltype, piping_wall_type)
select facility_id, tank_name, tank_id, 1, 1, 
     'Pressure',null,'Yes', null, 'Yes',
     'Yes', 'Yes', null, 'Yes',
     'Yes', 'Plastic Sump Wall', 'DW'
from as_ust.erg_tank where facility_id like 'Pa%' and tank_id=2;

insert into as_ust.erg_piping
(facility_id,tank_name, tank_id,compartment_id, piping_id, 
    piping_style, safesuction,   
    piping_material_frp, piping_material_steel,piping_material_flex,piping_flex_connector,
    piping_line_leak_detector,piping_line_test3yr,piping_release_detection_other,
    pipe_tank_topsump, pipe_tank_topsump_walltype, piping_wall_type)
select facility_id, tank_name, tank_id, 1, 1, 
     'Suction','Yes', 'Yes', null, 'Yes',
     'Yes', null, 'Yes', 'Yes',
     'Yes', 'Plastic Sump Wall', 'DW'
from as_ust.erg_tank where facility_id like 'Pa%' and tank_id=3;

------erg_dispenser-----------
CREATE TABLE IF NOT EXISTS as_ust.erg_facility_dispenser
(
    facility_id character varying(100) COLLATE pg_catalog."default",
    dispenser_id integer,
    dispenser_udc character varying(7) COLLATE pg_catalog."default",
    dispenser_udc_wall_type character varying(100) COLLATE pg_catalog."default"
);

insert into as_ust.erg_facility_dispenser(facility_id, dispenser_id, dispenser_udc)
SELECT distinct "FacilityID", 1,'Yes'  FROM as_ust."Facility";
--Not sure for _wall_type 'SUMP'
----===============================================
--ust_facility: This table is REQUIRED
--NOTE: facility_id is a required field. If Facility ID does not exist in the source data, STOP and talk to the state. 
insert into ust_element_mapping(ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_facility','facility_id','Facility','FacilityID',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_facility','facility_name','Facility','FacilityName',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_facility','owner_type_id','Facility','OwnerType',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_facility','facility_type1','Facility','FacilityType1',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_facility','facility_address1','Facility','FacilityAddress1',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_facility','facility_city','Facility','FacilityCity',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_facility','facility_county','Facility','FacilityCounty',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_facility','facility_zip_code','Facility','FacilityZipCode',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_facility','facility_state','Facility','FacilityState',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_facility','facility_epa_region','Facility','FacilityEPARegion','extract the region number from "FacilityEPARegion"','replace(FacilityEPARegion,''REGION '','')::int');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_facility','facility_latitude','Facility','FacilityLatitude',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_facility','facility_longitude','Facility','FacilityLongitude',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_facility','coordinate_source_id','Facility','FacilityCoordinateSource',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_facility','facility_owner_company_name','Facility','FacilityOwnerCompanyName',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_facility','facility_operator_company_name','Facility','FacilityOperatorCompanyName',null,null);

----------Tank--------------------
--ust_tank: This table is REQUIRED.
--At a mimimum we need a Tank ID (or Tank Name) and Tank Status. 
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_tank','facility_id','erg_tank','facility_id',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_tank','tank_id','erg_tank','tank_id',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_tank','tank_name','erg_tank','tank_name',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_tank','tank_location_id','erg_tank','tank_location','stated by state email reply for question of tank location',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_tank','tank_status_id','erg_tank','tank_status',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_tank','federally_regulated','erg_tank','federally_regulated',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_tank','tank_installation_date','erg_tank','tank_installation_date','The source data contained a mixture of year and month/year values. ERG set the date as January 1 when only a year was present, and the first of the month when a month was provided.'
,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_tank','tank_material_description_id','erg_tank','tank_material_description',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_tank','tank_secondary_containment_id','erg_tank','tank_secondary_containment','pulled the "DW" out of the TankName field in the source data, which AS used as a notes field',null)

--ust_tank_substance: This table is OPTIONAL (but most states will have data)
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_tank_substance','facility_id','erg_tanksubstance','facility_id',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_tank_substance','tank_id','erg_tanksubstance','tank_id',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_tank_substance','tank_name','erg_tanksubstance','tank_name',null,null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_tank_substance','substance_id','erg_tanksubstance','tank_substance',null,null);


----------Compartment---------
--ust_compartment: This table is REQUIRED. 
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_compartment','facility_id','erg_compartment','facility_id',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_compartment','tank_id','erg_compartment','tank_id',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_compartment','tank_name','erg_compartment','tank_name',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_compartment','compartment_id','erg_compartment','compartment_id',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_compartment','overfill_prevention_high_level_alarm','erg_compartment','overfill_prevention_high_level_alarm',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_compartment','spill_bucket_installed','erg_compartment','spill_bucket_installed',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_compartment','concrete_berm_installed','erg_compartment','concrete_berm_installed',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_compartment','tank_automatic_tank_gauging_release_detection','erg_compartment','tank_automatic_tank_gauging_release_detection',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_compartment','automatic_tank_gauging_continuous_leak_detection','erg_compartment','automatic_tank_gauging_continuous_leak_detection',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic)
values (34,'ust_compartment','tank_manual_tank_gauging','erg_compartment','tank_manual_tank_gauging',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_compartment','tank_tightness_testing','erg_compartment','tank_tightness_testing',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_compartment','tank_inventory_control','erg_compartment','tank_inventory_control',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_compartment','compartment_status_id','erg_compartment','compartment_status',null,null);

--ust_piping: This table is OPTIONAL; do not map if there is no piping data in the source data
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_piping','facility_id','erg_piping','facility_id',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_piping','tank_id','erg_piping','tank_id',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_piping','tank_name','erg_piping','tank_name',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_piping','compartment_id','erg_piping','compartment_id',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_piping','piping_id','erg_piping','piping_id',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_piping','piping_style_id','erg_piping','piping_style','related information from other column--Safesuction',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_piping','safe_suction','erg_piping','safesuction',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_piping','piping_material_frp','erg_piping','piping_material_frp',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_piping','piping_material_steel','erg_piping','piping_material_steel',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_piping','piping_material_flex','erg_piping','piping_material_flex',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_piping','piping_flex_connector','erg_piping','piping_flex_connector',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_piping','piping_line_leak_detector','erg_piping','piping_line_leak_detector',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_piping','piping_line_test_annual','erg_piping','piping_line_test_annual',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_piping','piping_line_test3yr','erg_piping','piping_line_test3yr',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_piping','piping_release_detection_other','erg_piping','piping_release_detection_other',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_piping','pipe_tank_top_sump','erg_piping','pipe_tank_topsump',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_piping','pipe_tank_top_sump_wall_type_id','erg_piping','pipe_tank_topsump_walltype',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_piping','piping_wall_type_id','erg_piping','piping_wall_type',null,null);

--ust_facility_dispenser: Map and populate this table only if the state stores dispenser data at the Facility level.
--Dispenser data is OPTIONAL.
----facility_dispenser---------------
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_facility_dispenser','facility_id','erg_facility_dispenser','facility_id',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_facility_dispenser','dispenser_id','erg_facility_dispenser','dispenser_id',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (34,'ust_facility_dispenser','dispenser_udc','erg_facility_dispenser','dispenser_udc',null,null);

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
control_id = ZZ                 # Enter an integer that is the ust_control_id or release_control_id
only_incomplete = True 			# Boolean, set to True to restrict the output to EPA columns that have not yet been value mapped or False to output mapping for all columns

 * If - and only if - this script identifies possible aggregrated data, it will output SQL file in the repo at
 * /ust/sql/AS/UST/AS_UST_deagg.sql). Open the generated file in your database console and step through it.  
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
	where ust_control_id = ZZ and mapping_complete = 'N'
	order by table_sort_order, column_sort_order) x;
 
 * To generate the SQL that will assist you in doing the value mapping, run the script 
 * generate_value_mapping_sql.py. Set the following variables before running the script:
 
ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = ZZ                 # Enter an integer that is the ust_control_id or release_control_id
only_incomplete = True   		# Boolean, defaults to True. Set to False to output mapping for all columns regardless if mapping was previously done. 
overwrite_existing = False      # Boolean, defaults to False. Set to True to overwrite existing generated SQL file. If False, will append an existing file.
 
 * This script will output a SQL file (located by default in the repo at 
 * /ust/sql/states/AS/UST/AS_UST_value_mapping.sql). Open the generated file in your database console
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
 * manually attach the file (located at /ust/python/exports/mapping/AS/UST/) and send an email 
 * to John.Wilhelmi@erg.com, CCing Victoria and Renae. 
 * 
 * Set these variables in the script: 
 
ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = ZZ                 # Enter an integer that is the ust_control_id or release_control_id
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
control_id = ZZ                 # Enter an integer that is the ust_control_id or release_control_id
  
 * To see the crosswalk views after running the script:

select table_name 
from information_schema.tables 
where table_schema = lower('AS_ust') and table_type = 'VIEW'
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
control_id = ZZ                  # Enter an integer that is the ust_control_id
drop_existing = False 		     # Boolean, defaults to False. Set to True to drop the table if it exists before creating it new.
write_sql = True                 # Boolean, defaults to True. If True, writes a SQL script recording the queries it ran to generate the tables.
overwrite_sql_file = False       # Boolean, defaults to False. Set to True to overwrite an existing SQL file if it exists. This parameter has no effect if write_sql = False. 

 * By default, this script will generate any required ID columns, update the public.ust_element_mapping table,
 * and export a SQL file (located by default in the repo at /ust/sql/AS/UST/AS_UST_id_column_generation.sql).
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
where ust_control_id = ZZ and organization_table_name like 'erg%'
order by sort_order;

alter table as_ust."Facility" add primary key ("FacilityID");
alter table as_ust.erg_tank add primary key (tank_name);
ALTER TABLE as_ust.erg_tank ADD CONSTRAINT tankfk 
    FOREIGN KEY (facility_id) REFERENCES as_ust."Facility" ("FacilityID");
alter table as_ust.erg_piping add primary key (facility_id, tank_id);
alter table as_ust.erg_compartment add primary key (facility_id, tank_id);
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

--Remind yourself if there are any state-level business rules you need to take into consideration
--when writing the views (such as excluding AST, for example).
select comments from public.ust_control where ust_control_id = ZZ;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 11: QA the views 

/* 
 * Run script qa_check.py to check that the views you have written to populate the main data tables
 * adhere to all business and logic rules.  
 * Set these variables in the script:

ust_or_release = 'ust' 			 # Valid values are 'ust' or 'release' 
control_id = ZZ                  # Enter an integer that is the ust_control_id

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
 *
 * The script will also provide the counts of rows in v_ust_facility, v_ust_tank, v_ust_compartment, and v_ust_piping (if these views exist) -
 * ensure these counts make sense! 
 *   
 * The script will export a QAQC spreadsheet to the repo at 
 * /ust/python/exports/QAQC/AS/UST/AS_UST_QAQC_yyyymmddsssss.xlsx 
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
control_id = ZZ                  # Enter an integer that is the ust_control_id
delete_existing = False 		 # can set to True if there is existing UST data you need to delete before inserting new

 * Do a quick sanity check of number of rows inserted:
*/
select table_name, num_rows 
from v_ust_table_row_count
where ust_control_id = ZZ
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
control_id = ZZ                 # Enter an integer that is the ust_control_id or release_control_id

 * 
 * This script will output an Excel file (located by default in the repo at 
 * /ust/python/exports/epa_templates/AS/UST/AS_UST_template_yyyymmddsssss.xlsx). 
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
control_id = ZZ                 # Enter an integer that is the ust_control_id or release_control_id

 * 
 * This script will output an Excel file (located by default in the repo at 
 * /ust/python/exports/control_table_summaries/AS/UST/AS_UST_control_table_summary_yyyymmddsssss.xlsx). 
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
 * 1) Populated EPA template: /ust/python/exports/epa_templates/AS/UST/AS_UST_template_yyyymmddsssss.xlsx
 * 2) QAQC file: /ust/python/exports/QAQC/AS/UST/AS_UST_QAQC_yyyymmddsssss.xlsx
 * 3) Control table summary file: /ust/python/exports/control_table_summaries/AS/UST/AS_UST_control_table_summary_yyyymmddsssss.xlsx
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
 * Documents > General > 01 - UST Source Data > AS > State-Provided Source Data folder, you must export the 
 * tables from the ERG database to CSV files and upload them to the EPA Teams site at
 * Documents > General > 01 - UST Source Data > AS > ERG Source Data folder. 
 * 
 * To export the source data from the database, run script export_source_data.py
 * 
 * Set these variables in the script: 
 * 
ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = ZZ                 # Enter an integer that is the ust_control_id or release_control_id
all_tables = True               # Boolean, defaults to True. If True will export all source data tables; if False will only export those referenced in ust_element_mapping or release_element_mapping.
tables_to_exclude = []          # Python list of strings; defaults to empty list. Populate with table names in the organization schema that should be excluded from the export. (NOTE: ERG-created tables will not be exported regardless of the values in this list.)
empty_export_dir = True         # Boolean, defaults to True. If True, will delete all files in the export directory before proceeding. If False, will not delete any files, but will overwrite any that have the same name as the generated file name. 

 * 
 * This script will output a CSV file for each table in the state schema (the default export location is 
 * in the repo at /ust/python/exports/source_data/AS/UST). 
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