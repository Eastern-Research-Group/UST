--working on v_ust_tank

select * from public.ust_control where ust_control_id = 17;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------


alter table "UST_V2_template_03_01_24_DispenserInfo" rename "ï»¿DISPENSER_ID" to dispenser_id;

--cleanup some records that have multiple lat/longs to get a unique facility record
select * from  "UST_V2_template_03_01_24_GISInfoUSTs"
where ("SITE_NUMBER","GIS_LAT","GIS_LON")
in (
select "SITE_NUMBER","GIS_LAT","GIS_LON" from "UST_V2_template_03_01_24_GISInfoUSTs"
group by 1,2,3
having count(*) > 1)
order by 2;


select * from "UST_V2_template_03_01_24_GISInfoUSTs"
where "SITE_NUMBER" in (199506011,
199211008,
199204001,
201305020,
201401007,
200609038)
order by 2,"GIS_MODADD_DATE";

delete from  "UST_V2_template_03_01_24_GISInfoUSTs"
where "ï»¿GIS_RSN" in (
33005,
52595,
52597,
31646,
52448,
51897,
52142)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Generate SQL statements to do the inserts into ust_element_mapping. 
Run the query below, paste the results into your console, then do a global replace of 9 for the ust_control_id 
Next, go through each generated SQL statement and do the following:
If there is no matching column in the state's data, delete the SQL statement 
If there is a matching column in the state's data, update the tanks and ORG_COL_NAME variables to match the state's data 
If you have questions or comments, replace the "null" with your comment. 
After you have updated all the SQL statements, run them to update the database. 
*/
select * from public.v_ust_element_summary_sql;


insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (17,'ust_facility','facility_id','facilities','FACILITY_ID',NULL);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (17,'ust_facility','facility_name','facilities','REGISTERED_NAME',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (17,'ust_facility','owner_type_id','facilities','OWNER_TYPE',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (17,'ust_facility','facility_type1','facilities','FACILITY_TYPE',null); 
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (17,'ust_facility','facility_address1','site','SITE_ADDRESS',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (17,'ust_facility','facility_city','site','SITE_CITY',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (17,'ust_facility','facility_latitude','UST_V2_template_03_01_24_GISInfoUSTs','GIS_LAT',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (17,'ust_facility','facility_longitude','UST_V2_template_03_01_24_GISInfoUSTs','GIS_LON',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (17,'ust_facility','coordinate_source_id','UST_V2_template_03_01_24_GISInfoUSTs','GIS_COLLECTION_METHOD',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (17,'ust_facility','facility_owner_company_name','facilities','OWNER_NAME',null);

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (17,'ust_tank','facility_id','tanks','FACILITY_ID',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (17,'ust_tank','tank_name','tanks','TANK_NUMBER',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (17,'ust_tank','tank_status_id','tanks','STATUS',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (17,'ust_tank','tank_closure_date','tanks','PERMANENT_CLOSED_DATE',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (17,'ust_tank','tank_installation_date','tanks','DATE_INSTALLED',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (17,'ust_tank','compartmentalized_ust','tanks','COMPARTMENT',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (17,'ust_tank','tank_material_description_id','tanks','CONSTRUCTION_MATERIAL',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (17,'ust_tank','tank_corrosion_protection_sacrificial_anode','tanks','CORROSION_PROTECTION_TANK',null,'where CORROSION_PROTECTION_TANK in (REPAIRED SA, SACRAFICIAL ANODE)');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (17,'ust_tank','tank_corrosion_protection_impressed_current','tanks','CORROSION_PROTECTION_TANK',null,'where CORROSION_PROTECTION_TANK in (REPAIRED IC, IMPRESSED CURRENT) ');


select * from ust_element_mapping where ust_control_id = '17' and organization_column_name = 'CORROSION_PROTECTION_TANK';

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (17,'ust_tank_substance','facility_id','tanks','FACILITY_ID',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (17,'ust_tank_substance','tank_name','tanks','TANK_NUMBER',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (17,'ust_tank_substance','substance_id','tanks','SUBSTANCE_STORED',null);


insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (17,'ust_compartment','facility_id','tanks','FACILITY_ID',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (17,'ust_compartment','tank_name','tanks','TANK_NUMBER',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (17,'ust_compartment','compartment_status_id','tanks','STATUS',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (17,'ust_compartment','compartment_capacity_gallons','tanks','CAPACITY',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (17,'ust_compartment','overfill_prevention_ball_float_valve','tanks','OVERFILL_TYPE',null,'where OVERFILL_TYPE like %BALL%FLOAT or OVERFILL_TYPE like %BALL%FLT%');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (17,'ust_compartment','overfill_prevention_flow_shutoff_device','tanks','OVERFILL_TYPE',null,'where OVERFILL_TYPE = FLOW SHUTOFF - FLAPPER VALVE');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (17,'ust_compartment','overfill_prevention_high_level_alarm','tanks','OVERFILL_TYPE',null,'where OVERFILL_TYPE like %ALARM%');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (17,'ust_compartment','overfill_prevention_other','tanks','OVERFILL_TYPE','Please verify','where OVERFILL_TYPE in (61-F-STOP, COAXIAL FLAPPER VALVE,MULTIPLE STAGE FLAPPER VALVE)');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (17,'ust_compartment','overfill_prevention_not_required','tanks','OVERFILL_TYPE',null,'where OVERFILL_TYPE = NONE');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (17,'ust_compartment','spill_bucket_installed','tanks','SPILL_INSTALLED_DATE','Please verify','Where SPILL_INSTALLED_DATE is not null');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (17,'ust_compartment','tank_automatic_tank_gauging_release_detection','tanks','RELEASE_DETECTION_TANK_TYPE','Please verify','where RELEASE_DETECTION_TANK_TYPE = AUTO TANK GAUGE');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (17,'ust_compartment','automatic_tank_gauging_continuous_leak_detection','tanks','RELEASE_DETECTION_TANK_TYPE','Please verify','where RELEASE_DETECTION_TANK_TYPE = AUTO TANK GAUGE');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (17,'ust_compartment','tank_manual_tank_gauging','tanks','RELEASE_DETECTION_TANK_TYPE',null,'where RELEASE_DETECTION_TANK_TYPE = MANUAL TANK GAUGING');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (17,'ust_compartment','tank_tightness_testing','tanks','RELEASE_DETECTION_TANK_TYPE','Please verify','where TANK_TIGHTNESS_TEST_DATE is not null');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (17,'ust_compartment','tank_other_release_detection','tanks','RELEASE_DETECTION_TANK_TYPE','Please verify','where RELEASE_DETECTION_TANK_TYPE in (AMPRODOX,ARIZONA INSTRUMENT,CARDINAL vacuum,CONTROL SYSTEMS,EBW BULK / STIK II,EMCO WHEATON (OPW),ENVIRONMENTAL SYSTEMS,EVO - FRANKLIN FUELS,GILBARCO,IN SITU,IN TANK MONITOR,INCON,LEAK X MINI,MCG 1100,MONITORING WELL,NEPONSET CONTROLS,OMNTEC,OPW FUEL MGT SYS,OTHER,OWENS CORNING,PETROMETER,PETROVEND,PNEUMERCATOR,POLLULERT,PREFERRED UTILITIES,TIDEL SYSTEMS INC,VEEDER ROOT,WARWICK CONTROLS)');




insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (17,'ust_piping','facility_id','tanks','FACILITY_ID',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (17,'ust_piping','tank_id','tanks','TANK_NUMBER',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (17,'ust_piping','piping_style_id','tanks','PIPING_SYSTEM',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (17,'ust_piping','piping_material_frp','tanks','PIPING_MATERIAL',null,'where PIPING_MATERIAL = FIBERGLASS');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (17,'ust_piping','piping_material_gal_steel','tanks','PIPING_MATERIAL',null,'where PIPING_MATERIAL = STEEL - BARE/GALV');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (17,'ust_piping','piping_material_flex','tanks','PIPING_MATERIAL',null,'where PIPING_MATERIAL = FLEXIBLE');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (17,'ust_piping','piping_material_steel','tanks','PIPING_MATERIAL','Please verify','where PIPING_MATERIAL = STEEL ISOLATED');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (17,'ust_piping','piping_material_stainless_steel','tanks','PIPING_MATERIAL','Please verify','where PIPING_MATERIAL = STEEL-CORR. PROT.');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (17,'ust_piping','piping_material_copper','tanks','PIPING_MATERIAL','Please verify','where PIPING_MATERIAL in (COPPER,COPPER -CORR. PROT.,COPPER ISOLATED)');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (17,'ust_piping','piping_material_no_piping','tanks','PIPING_MATERIAL',null,'where PIPING_MATERIAL = NO PIPING');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (17,'ust_piping','piping_material_other','tanks','PIPING_MATERIAL','Please verify','where PIPING_MATERIAL in (PLASTIC PIPING, COMPOSITE, OTHER - MISCELLANEOUS)');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (17,'ust_piping','piping_material_unknown','tanks','PIPING_MATERIAL',null,'where PIPING_MATERIAL = UNKNOWN');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (17,'ust_piping','piping_corrosion_protection_sacrificial_anode','tanks','CORROSION_PROTECTION_PIPING',null,'where CORROSION_PROTECTION_PIPING = SACRAFICIAL ANODE');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (17,'ust_piping','piping_corrosion_protection_impressed_current','tanks','CORROSION_PROTECTION_PIPING',null,'where CORROSION_PROTECTION_PIPING = IMPRESSED CURRENT');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (17,'ust_piping','piping_corrosion_protection_other','tanks','CORROSION_PROTECTION_PIPING','Please verify','where CORROSION_PROTECTION_PIPING= REPAIRED SA');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (17,'ust_piping','pipe_secondary_containment_unknown','tanks','PIPING_MATERIAL_SECONDARY_CONTAINMENT','Please verify','where PIPING_MATERIAL_SECONDARY_CONTAINMENT = YES');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (17,'ust_piping','piping_release_detection_other','tanks','RELEASE_DETECTION_PIPING_TYPE','Please verify','where RELEASE_DETECTION_PIPING_TYPE in (ARIZONA,BRAVO,CONTROL system,EBW BULK/STICK II,EMCO WHEATON,EVO - FRANKLIN FUELS,GILBARCO,HASSTECH,INCON,INSITU,INTERGY INC,MONTIORING WELL,OMNTEC,OPW FUEL MGT SYS,OTHER,OWENS CORNING,PNEUMERCATOR,POLLULERT,PREFERRED UTILITIES,TANK GUARD,TIGHTNESS TEST,VEEDER ROOT,WARWICK CONTROLS)');

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (17,'ust_facility_dispenser','facility_id','UST_V2_template_03_01_24_DispenserInfo','FACILITY_ID',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (17,'ust_facility_dispenser','dispenser_id','UST_V2_template_03_01_24_DispenserInfo','dispenser_id',null,null);



delete from ust_element_mapping where ust_control_id = '17' and epa_table_name ='ust_tank_substance' and epa_column_name ='tank_name'  ;


select * from ust_element_mapping where ust_control_id=17 and organization_column_name='PIPING_MATERIAL_SECONDARY_CONTAINMENT';

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (ZZ,'ust_piping','pipe_secondary_containment_unknown','ORG_TAB_NAME','ORG_COL_NAME',null,null);

/*you can run this SQL so you can copy and paste table and column names into the SQL statements generated by the query above
select table_name, column_name from information_schema.columns 
where table_schema = 'nh_ust' order by table_name, ordinal_position;
*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--see what columns in which table we need to map
select epa_table_name, epa_column_name
from v_ust_available_mapping 
where ust_control_id = 17
order by table_sort_order, column_sort_order;
/*
ust_facility	owner_type_id
ust_facility	facility_type1
ust_facility	coordinate_source_id
ust_tank	tank_status_id
ust_tank	tank_material_description_id
ust_tank_substance	substance_id
ust_compartment	compartment_status_id
ust_piping	piping_style_id
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--owner_type_id

select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 17 and epa_column_name = 'owner_type_id';

select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 1521 || ', ''' || "OWNER_TYPE" || ''', '''', null);'
from nh_ust."facilities" order by 1;

insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1521, 'COMMERCIAL/RESIDENTIAL', 'Commercial', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1521, 'FEDERAL GOVERNMENT', 'Federal Government - Non Military', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1521, 'STATE OR LOCAL GOVERNMENT', 'State Government - Non Military', 'Please verify');



------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--facility_type1

select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 17 and epa_column_name = 'facility_type1';

select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 1522 || ', ''' || "FACILITY_TYPE" || ''', '''', null);'
from nh_ust."facilities" order by 1;

select * from public.facility_types ft ;

insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1522, 'AUTO DEALERSHIP', 'Auto dealership/auto maintenance & repair', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1522, 'AVIATION', 'Aviation/airport (non-rental car)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1522, 'CHURCH', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1522, 'COLLEGE/UNIVERSITY', 'School', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1522, 'COMMERCIAL', 'Commercial', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1522, 'CONTRACTOR', 'Contractor', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1522, 'FEDERAL- NON-MILITARY', 'Federal government, non-military', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1522, 'FEDERAL - MILITARY', 'Military', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1522, 'GAS STATION', 'Retail fuel sales (non-marina)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1522, 'HOSPITAL', 'Hospital (or other medical)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1522, 'INDUSTRIAL', 'Industrial', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1522, 'LOCAL GOVERNMENT', 'State/local government', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1522, 'MARINA', 'Marina', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1522, 'OTHER', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1522, 'PETROLEUM DISTRIBUTOR', 'Bulk plant storage/petroleum distributor', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1522, 'PROPOSED FACILITY', 'Other', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1522, 'RAILROAD', 'Railroad', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1522, 'RESIDENTIAL OR FARM', 'Residential', 'Please verify RESIDENTIAL vs FARM');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1522, 'SCHOOL', 'School', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1522, 'STATE GOVERNMENT', 'State/local government', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1522, 'TRUCKING / TRANSPORT', 'Trucking/transport/fleet operation', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1522, 'UTILITIES', 'Utility', null);



------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--coordinate_source_id
select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 17 and epa_column_name = 'coordinate_source_id';

select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 1527 || ', ''' || "GIS_COLLECTION_METHOD" || ''', '''', null);'
from nh_ust."UST_V2_template_03_01_24_GISInfoUSTs" order by 1;

insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1527, 'ADDRESS GEOCODED', 'Geocoded address', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1527, 'DESKTOP', 'Map interpolation', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1527, 'HANDHELD GPS', 'GPS', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1527, 'NUVI', 'GPS', null);

select * from public.coordinate_sources cs ;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--tank_status_id


select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 17 and epa_column_name = 'tank_status_id';

select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 1531 || ', ''' || "STATUS" || ''', '''', null);'
from nh_ust."tanks" order by 1;

select * from public.tank_statuses ts 

insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1531, 'ACTIVE', 'Currently in use', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1531, 'INACTIVE', 'Closed (general)', null);

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--compartment_status_id

select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 17 and epa_column_name = 'compartment_status_id';

select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 1544 || ', ''' || "STATUS" || ''', '''', null);'
from nh_ust."tanks" order by 1;

insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1544, 'ACTIVE', 'Currently in use', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1544, 'INACTIVE', 'Closed (general)', null);

select * from ust_element_value_mapping where  ust_element_mapping_id = 1486
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--tank_material_description_id
select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 17 and epa_column_name = 'tank_material_description_id';

select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 1535 || ', ''' || "CONSTRUCTION_MATERIAL" || ''', '''', null);'
from nh_ust."tanks" order by 1;

insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1535, 'COMPOSITE', 'Composite/clad (steel w/fiberglass reinforced plastic)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1535, 'CONCRETE', 'Concrete', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1535, 'FIBERGLASS', 'Fiberglass reinforced plastic', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1535, 'FIELD CONSTRUCTED', 'Other', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1535, 'STEEL-CORR. PROT.', 'Coated and cathodically protected steel', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1535, 'STEEL - BARE/GALV', 'Asphalt coated or bare steel',null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1535, 'UNKNOWN', 'Unknown', null);

select * from public.tank_material_descriptions ; 

select distinct organization_value,epa_value from ust_element_value_mapping where lower(epa_value) like '%steel%' order by 2;


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--piping_style_id
select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 17 and epa_column_name = 'piping_style_id';


select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 1559 || ', ''' || "PIPING_SYSTEM" || ''', '''', null);'
from nh_ust."tanks" order by 1;

insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1559, 'GRAVITY', 'Non-operational (e.g., fill line, vent line, gravity)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1559, 'NONE', 'No piping', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1559, 'PRESSURE', 'Pressure', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1559, 'SIPHON', 'Other', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1559, 'SUCTION: NO VALVE AT TANK', 'Suction', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1559, 'SUCTION: OLD CODE', 'Suction', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1559, 'SUCTION: VALVE AT TANK', 'Suction', null);

select * from ust_element_value_mapping where lower(organization_value) like '%siphon%';

select * from public.piping_styles ps ;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--substance_id
select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 17 and epa_column_name = 'substance_id';

select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 1541 || ', ''' || "SUBSTANCE_STORED" || ''', '''', null);'
from nh_ust."tanks" order by 1;




select * from public.substances s where lower(substance) like '%other%';

select * from ust_element_value_mapping where upper(organization_value) like '%USED%';

select * from archive.ust_element_value_mappings uevm 


insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1541, '#2 HEATING OIL', 'Heating oil/fuel oil 2', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1541, '#4 HEATING OIL', 'Heating oil/fuel oil 4', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1541, '#6 HEATING OIL', 'Heating oil/fuel oil 6', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1541, 'AVIATION GAS', 'Aviation gasoline', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1541, 'BIODIESEL', 'Diesel fuel (b-unknown)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1541, 'DIESEL FUEL', 'Diesel fuel (b-unknown)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1541, 'EMERGENCY GENERATOR FUEL', 'Diesel fuel (b-unknown)', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1541, 'EMPTY', 'Unknown', 'Please verify - should we filter this out of the substance table?');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1541, 'GASOLINE', 'Gasoline (unknown type)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1541, 'HAZARDOUS SUBSTANCE', 'Hazardous substance', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1541, 'JET FUEL', 'Unknown aviation gas or jet fuel', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1541, 'KEROSENE', 'Kerosene', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1541, 'MIDGRADE', 'Gasoline (unknown type)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1541, 'MOTOR OIL', 'Lube/motor oil (new)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1541, 'OFF ROAD DIESEL', 'Off-road diesel/dyed diesel', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1541, 'OTHER SUBSTANCE', 'Other or mixture', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1541, 'RACING FUEL', 'Racing fuel', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1541, 'REGULAR', 'Unknown', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1541, 'REGULAR MASTER', 'Unknown', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1541, 'REGULAR SIPHON', 'Unknown', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1541, 'SUPER', 'Unknown', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1541, 'ULTRA GRADE', 'Unknown', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1541, 'UNKNOWN SUBSTANCE', 'Unknown', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1541, 'USED / WASTE OIL', 'Used oil/waste oil', null);

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--check if there is any more mapping to do
select distinct epa_table_name, epa_column_name
from v_ust_needed_mapping 
where ust_control_id = 17 and mapping_complete = 'N'
order by 1, 2;

--check if any of the mapping is bad:
select database_lookup_table, epa_value 
from v_ust_bad_mapping 
where ust_control_id = 17 order by 1, 2;
--!!!if there are results from this query, fix them!!!


------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*Step 1: create crosswalk views for columns that use a lookup table
run script org_mapping_xwalks.py to create crosswalk views for all lookup tables 
see new views:*/
select table_name 
from information_schema.tables 
where table_schema = 'nh_ust' and table_type = 'VIEW'
and table_name like '%_xwalk' order by 1;


--Step 2: see the EPA tables we need to populate, and in what order
select distinct epa_table_name, table_sort_order
from v_ust_table_population 
where ust_control_id = 17
order by table_sort_order;
/*
ust_facility
ust_tank
ust_tank_substance
ust_compartment
ust_piping
ust_facility_dispenser
*/

/*Step 3: check if there where any dataset-level comments you need to incorporate:
in this case we need to ignore the aboveground storage tanks,
so add this to the where clause of the ust_release view */
select comments from ust_control where ust_control_id = 17;

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
where ust_control_id = 17 and epa_table_name = 'ust_facility'
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

drop view nh_ust.v_ust_facility;

create or replace view nh_ust.v_ust_facility as 
select distinct 
"FACILITY_ID"::character varying(50) as facility_id, 
"REGISTERED_NAME"::character varying(100) as facility_name,
owner_type_id as owner_type_id,
facility_type_id as facility_type1,
x."SITE_ADDRESS"::character varying(100) as facility_address1,
x."SITE_CITY"::character varying(100) as facility_city,
y."GIS_LAT"::double precision as facility_latitude,
y."GIS_LON"::double precision as facility_longitude,
coordinate_source_id as coordinate_source_id,
"OWNER_NAME"::character varying(100) as facility_owner_company_name,
1 as facility_epa_region,
'NH' as facility_state
from facilities fac
left join nh_ust.site x on x."SITE_NUMBER" = fac."SITE_NUMBER" 
left join nh_ust.v_owner_type_xwalk ot on fac."OWNER_TYPE" = ot.organization_value 
left join "UST_V2_template_03_01_24_GISInfoUSTs" y on x."SITE_NUMBER" = y."SITE_NUMBER" 
left join nh_ust.v_coordinate_source_xwalk cs on y."GIS_COLLECTION_METHOD" = cs.organization_value 
left join nh_ust.v_facility_type_xwalk ft on fac."FACILITY_TYPE" = ft.organization_value 
;



--review: 
select * from nh_ust.v_ust_facility;
select count(*) from nh_ust.v_ust_facility;
--6662
--------------------------------------------------------------------------------------------------------------------------
--now repeat for each data table:

--ust_tank 
select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, data_type, character_maximum_length,
	programmer_comments, database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 17 and epa_table_name = 'ust_tank'
order by column_sort_order;


drop table nh_ust.erg_tank;
create table nh_ust.erg_tank (facility_id character varying(50), tank_name character varying(50), tank_id int generated always as identity);
insert into nh_ust.erg_tank (facility_id, tank_name)
select  "FACILITY_ID","TANK_NUMBER" from nh_ust.tanks;

select facility_id,tank_name from erg_tank group by facility_id,tank_name having count(*) >1;

select * from nh_ust.tanks where "SITE_NUMBER" ='199312031' and "TANK_NUMBER" = '4' ;


create or replace view nh_ust.v_ust_tank as 
select distinct 
"FACILITY_ID"::character varying(50) as facility_id,
et.tank_id::integer,
"TANK_NUMBER"::character varying(50) as tank_name,
tank_status_id as tank_status_id,
"PERMANENT_CLOSED_DATE"::date as tank_closure_date,
"DATE_INSTALLED"::date as tank_installation_date,
initcap("COMPARTMENT")::character varying(7) as compartmentalized_ust,
tank_material_description_id as tank_material_description_id,
case when trim(upper("CORROSION_PROTECTION_TANK")) = 'SACRAFICIAL ANODE' then 'Yes' end as tank_corrosion_protection_sacrificial_anode,
case when trim(upper("CORROSION_PROTECTION_TANK")) = 'IMPRESSED CURRENT' then 'Yes' end as tank_corrosion_protection_impressed_current,
case when trim(upper("CORROSION_PROTECTION_TANK")) in ('REPAIRED IC','REPAIRED SA') then 'Yes' end as tank_corrosion_protection_other
from nh_ust.tanks x 
join erg_tank et on  et.facility_id::integer = x."FACILITY_ID" and et.tank_name = x."TANK_NUMBER"
left join nh_ust.v_tank_status_xwalk ts on x."STATUS" = ts.organization_value 
left join nh_ust.v_tank_material_description_xwalk md on x."CONSTRUCTION_MATERIAL" = md.organization_value
;


select * from nh_ust.v_ust_tank;

select count(*) from nh_ust.v_ust_tank;
--21482

--------------------------------------------------------------------------------------------------------------------------
--ust_tank_substance

select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, data_type, character_maximum_length,
	programmer_comments, database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 17 and epa_table_name = 'ust_tank_substance'
order by column_sort_order;

/*be sure to do select distinct if necessary!
NOTE: ADD facility_id::character varying(50) and tank_id::int!!!!
*/

drop view nh_ust.v_ust_tank_substance;

create or replace view nh_ust.v_ust_tank_substance as 
select distinct 
"FACILITY_ID"::character varying(50) as facility_id,
et.tank_id::integer,
	sx.substance_id as substance_id
from nh_ust.tanks x 
join erg_tank et on  et.facility_id::integer = x."FACILITY_ID" and et.tank_name = x."TANK_NUMBER"
left join nh_ust.v_substance_xwalk sx on x."SUBSTANCE_STORED" = sx.organization_value
where x."SUBSTANCE_STORED" is not null;


 select * from nh_ust.v_ust_tank_substance uts 

select count(*) from nh_ust.v_ust_tank_substance;
--21482


--------------------------------------------------------------------------------------------------------------------------
--ust_compartment
select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, data_type, character_maximum_length,
	programmer_comments, database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 17 and epa_table_name = 'ust_compartment'
order by column_sort_order;

/* be sure to do select distinct if necessary!
NOTE: ADD facility_id::character varying(50) and tank_id::int!!!!
NOTE: compartment_id (integer) is a required field - if the state data does not contain an integer field
      that uniquely identifies the compartment, you must generate one. 
      In this case, the state does not store compartment data, so we will generate the compartment ID
      Prefix any tables you create in the state schema that did not come from the source data with "erg_"! */

drop table nh_ust.erg_compartment;
create table nh_ust.erg_compartment (facility_id character varying(50), tank_id int, compartment_id int generated always as identity);
insert into nh_ust.erg_compartment (facility_id, tank_id)
select  facility_id,tank_id from nh_ust.erg_tank;

drop view nh_ust.v_ust_compartment;
create or replace view nh_ust.v_ust_compartment as 
select distinct 
et.facility_id as facility_id,
et.tank_id,
c.compartment_id,
compartment_status_id as compartment_status_id,
"CAPACITY"::integer as compartment_capacity_gallons,
case when trim(upper("OVERFILL_TYPE")) like '%BALL%FLOAT%' or "OVERFILL_TYPE" like '%BALL%FLT%' then 'Yes' end as overfill_prevention_ball_float_valve,
case when trim(upper("OVERFILL_TYPE")) like '%FLOW SHUTOFF - FLAPPER VALVE%' then 'Yes' end as overfill_prevention_flow_shutoff_device,
case when trim(upper("OVERFILL_TYPE")) like '%ALARM%' then 'Yes' end as overfill_prevention_high_level_alarm,
case when trim(upper("OVERFILL_TYPE")) in ('61-F-STOP','COAXIAL FLAPPER VALVE','MULTIPLE STAGE FLAPPER VALVE') then 'Yes' end as overfill_prevention_other,
case when trim(upper("OVERFILL_TYPE")) = 'NONE' then 'Yes' end as overfill_prevention_not_required,
case when "SPILL_INSTALLED_DATE" is not null then 'Yes' end as spill_bucket_installed,
case when trim(upper("RELEASE_DETECTION_TANK_TYPE")) = 'AUTO TANK GAUGE' then 'Yes' end  as tank_automatic_tank_gauging_release_detection,

case when trim(upper("RELEASE_DETECTION_TANK_TYPE")) = 'AUTO TANK GAUGE' then 'Yes' end  as automatic_tank_gauging_continuous_leak_detection,
case when trim(upper("RELEASE_DETECTION_TANK_TYPE")) = 'MANUAL TANK GAUGING' then 'Yes' end  as tank_manual_tank_gauging,
case when "TANK_TIGHTNESS_TEST_DATE" is not null then 'Yes' end  as tank_tightness_testing,
case when trim(upper("RELEASE_DETECTION_TANK_TYPE")) in ('AMPRODOX','ARIZONA INSTRUMENT','CARDINAL VACUUM','CONTROL SYSTEMS','EBW BULK / STIK II','EMCO WHEATON (OPW)','ENVIRONMENTAL SYSTEMS','EVO - FRANKLIN FUELS','GILBARCO','IN SITU','IN TANK MONITOR','INCON','LEAK X MINI','MCG 1100','MONITORING WELL','NEPONSET CONTROLS','OMNTEC','OPW FUEL MGT SYS','OTHER','OWENS CORNING','PETROMETER','PETROVEND','PNEUMERCATOR','POLLULERT','PREFERRED UTILITIES','TIDEL SYSTEMS INC','VEEDER ROOT','WARWICK CONTROLS') then 'Yes' end  as tank_other_release_detection
from nh_ust.tanks x  
join erg_tank et on  et.facility_id::integer = x."FACILITY_ID" and et.tank_name = x."TANK_NUMBER"
join nh_ust.erg_compartment c on et.facility_id = c.facility_id and et.tank_id = c.tank_id
left join nh_ust.v_compartment_status_xwalk ts on x."STATUS" = ts.organization_value;


select distinct "RELEASE_DETECTION_TANK_TYPE" from nh_ust.tanks order by 1;

select * from v_ust_compartment; 
select count(*) from v_ust_compartment;
21482

--------------------------------------------------------------------------------------------------------------------------
--ust_piping

drop table nh_ust.erg_piping;

create table nh_ust.erg_piping (facility_id character varying(50), tank_id int, compartment_id int, piping_id int generated always as identity);
insert into nh_ust.erg_piping (facility_id, tank_id,compartment_id)
select facility_id,tank_id,compartment_id from nh_ust.v_ust_compartment;


select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, programmer_comments, 
	database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 17 and epa_table_name = 'ust_piping'
order by column_sort_order;

drop view v_ust_piping;

create or replace view nh_ust.v_ust_piping as
select   distinct
d.piping_id::varchar(50) piping_id,
d.facility_id as facility_id,
d.tank_id,
d.compartment_id,
piping_style_id as piping_style_id,
case when upper(trim("PIPING_MATERIAL")) = 'FIBERGLASS' then 'Yes' end as piping_material_frp,
case when upper(trim("PIPING_MATERIAL")) = 'STEEL - BARE/GALV' then 'Yes' end as piping_material_gal_steel,
case when upper(trim("PIPING_MATERIAL")) = 'FLEXIBLE' then 'Yes' end as piping_material_flex ,
case when upper(trim("PIPING_MATERIAL")) = 'STEEL ISOLATED' then 'Yes' end as piping_material_steel,
case when upper(trim("PIPING_MATERIAL")) = 'STEEL-CORR. PROT.' then 'Yes' end as piping_material_stainless_steel,
case when upper(trim("PIPING_MATERIAL")) in ('COPPER','COPPER -CORR. PROT.','COPPER ISOLATED') then 'Yes' end as piping_material_copper ,
case when upper(trim("PIPING_MATERIAL")) = 'NO PIPING' then 'Yes' end as piping_material_no_piping,
case when upper(trim("PIPING_MATERIAL")) in ('PLASTIC PIPING', 'COMPOSITE', 'OTHER - MISCELLANEOUS') then 'Yes' end as piping_material_other,
case when upper(trim("PIPING_MATERIAL")) = 'UNKNOWN' then 'Yes' end as piping_material_unknown,
case when upper(trim("CORROSION_PROTECTION_PIPING")) = 'SACRAFICIAL ANODE' then 'Yes' end as piping_corrosion_protection_sacrificial_anode,
case when upper(trim("CORROSION_PROTECTION_PIPING")) = 'IMPRESSED CURRENT' then 'Yes' end as piping_corrosion_protection_impressed_current,
case when upper(trim("CORROSION_PROTECTION_PIPING")) = 'REPAIRED SA' then 'Yes' end as piping_corrosion_protection_other,
case when upper(trim("RELEASE_DETECTION_PIPING_TYPE")) in ('ARIZONA','BRAVO','CONTROL system','EBW BULK/STICK II','EMCO WHEATON','EVO - FRANKLIN FUELS','GILBARCO','HASSTECH','INCON','INSITU','INTERGY INC','MONTIORING WELL','OMNTEC','OPW FUEL MGT SYS','OTHER','OWENS CORNING','PNEUMERCATOR','POLLULERT','PREFERRED UTILITIES','TANK GUARD','TIGHTNESS TEST','VEEDER ROOT','WARWICK CONTROLS') then 'Yes' end as piping_release_detection_other,
case when upper(trim("PIPING_MATERIAL_SECONDARY_CONTAINMENT")) = 'YES' then 'Yes' end as pipe_secondary_containment_unknown
from nh_ust.tanks x 
join erg_tank et on  et.facility_id::integer = x."FACILITY_ID" and et.tank_name = x."TANK_NUMBER"
join nh_ust.erg_compartment c on et.facility_id = c.facility_id and et.tank_id = c.tank_id
join nh_ust.erg_piping d on et.facility_id = d.facility_id and et.tank_id = d.tank_id and c.compartment_id=d.compartment_id
left join nh_ust.v_piping_style_xwalk px on x."PIPING_SYSTEM" = px.organization_value;

select * from nh_ust.v_ust_piping;

select count(*) from nh_ust.v_ust_piping;
21482


--------------------------------------------------------------------------------------------------------------------------

--QA/QC

--check that you didn't miss any columns when creating the data population views:
--if any rows are returned by this query, fix the appropriate view by adding the missing columns!
select epa_table_name, epa_column_name, 
	organization_table_name, organization_column_name, 
	organization_join_table, organization_join_column, 
	deagg_table_name, deagg_column_name
from v_ust_missing_view_mapping a
where ust_control_id = 17
order by 1, 2;

--run Python QA/QC script

/*run script qa_check.py
set variables:
ust_or_release = 'ust' 
control_id = 11
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

The script will also provide the counts of rows in nh_ust.v_ust_facility, nh_ust.v_ust_tank, nh_ust.v_ust_compartment, and
   nh_ust.v_ust_piping (if these views exist) - ensure these counts make sense! 
   
The script will export a QAQC spreadsheet (in additional to printing to the screen and logs). If there are errors, re-write the views above, 
then re-run the qa script, and proceed when all errors have been resolved. */



--------------------------------------------------------------------------------------------------------------------------
--insert data into the EPA schema 

/*run script populate_epa_data_tables.py	
set variables:
ust_or_release = 'ust' 
control_id = 11
delete_existing = False # can set to True if there is existing UST data you need to delete before inserting new
*/

--------------------------------------------------------------------------------------------------------------------------
--Quick sanity check of number of rows inserted:
select table_name, num_rows 
from v_ust_table_row_count
where ust_control_id = 17 
order by sort_order;
/*
ust_facility	6662
ust_tank	21482
ust_tank_substance	21482
ust_compartment	21482
ust_piping	21482
*/


--------------------------------------------------------------------------------------------------------------------------
--export template

/*run script export_template.py
set variables:
control_id = 9
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
control_id = 9
ust_or_release = 'ust' 
organization_id = None  	# Can leave as None if you specify the control_id
export_file_path = None 	# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_dir = None		# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_name = None		# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo*/

--------------------------------------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------------------------------------

