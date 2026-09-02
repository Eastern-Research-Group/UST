select * from ust_control where organization_id = 'TN'

where tn_compartments."Regulated Status" = 'Regulated' or tn_compartments."Regulated Status" is null;  
Note - The two hazardous waste files provided are from the EPA region and not the state itself. 






select organization_value, epa_value, 
	ust_element_value_mapping_id, 
	organization_table_name, organization_column_name
from v_ust_element_mapping 
where ust_control_id = 35
and epa_column_name = 'owner_type_id'
order by 1, 2;

Commercial	Commercial	2529	erg_owner_type	owner_type_converted
Duplicate Facility	Other	2530	erg_owner_type	owner_type_converted
Federal Government	Federal Government	2531	erg_owner_type	owner_type_converted
Holder	Other	2532	erg_owner_type	owner_type_converted
Local Government	Local Government	2533	erg_owner_type	owner_type_converted
Military	Military	2534	erg_owner_type	owner_type_converted
Private	Private	2535	erg_owner_type	owner_type_converted
State Government	State Government	2536	erg_owner_type	owner_type_converted

select * from tn_ust.erg_owner_type ;

delete from tn_ust.erg_owner_type 
where "OWNER_TYPE" = 'Duplicate Facility';

delete from ust_element_value_mapping 
where ust_element_value_mapping_id = 2530;

select * from tn_ust.erg_unregulated_facilities 

select distinct "OWNER_TYPE" from tn_ust.tn_facilities 

insert into tn_ust.erg_unregulated_facilities 
select "FACILITY_ID_UST", 'Owner type = ''Duplicate Facility'''
from tn_ust.tn_facilities
where "OWNER_TYPE" = 'Duplicate Facility'
on conflict do nothing;



select organization_value, epa_value, 
	ust_element_value_mapping_id, 
	organization_table_name, organization_column_name
from v_ust_element_mapping 
where ust_control_id = 35
and epa_column_name like 'facility_type%'
order by 1, 2;

delete from ust_element_value_mapping 
where ust_element_value_mapping_id in (2542,2543,2559,2558);


insert into tn_ust.erg_unregulated_facilities 
select "FACILITY_ID_UST", 'Facility type = ''Residential less than 1101 not regulated'''
from tn_ust.tn_facilities
where "FACILITY_TYPE" = 'Residential less than 1101 not regulated'
on conflict do nothing;

insert into tn_ust.erg_unregulated_facilities 
select "FACILITY_ID_UST", 'Facility type = ''Duplicate Facility'''
from tn_ust.tn_facilities
where "FACILITY_TYPE" = 'Duplicate Facility'
on conflict do nothing;

insert into tn_ust.erg_unregulated_facilities 
select "FACILITY_ID_UST", 'Facility type = ''Farm less than 1101 not regulated'''
from tn_ust.tn_facilities
where "FACILITY_TYPE" = 'Farm less than 1101 not regulated'
on conflict do nothing;

insert into tn_ust.erg_unregulated_facilities 
select "FACILITY_ID_UST", 'Facility type = ''Residential above 1100'''
from tn_ust.tn_facilities
where "FACILITY_TYPE" = 'Residential above 1100'
on conflict do nothing;

select * from facility_types 

update ust_element_value_mapping set epa_value = 'Other' where ust_element_value_mapping_id =  2553;
update ust_element_value_mapping set epa_value = '' where ust_element_value_mapping_id =  ;
update ust_element_value_mapping set epa_value = '' where ust_element_value_mapping_id =  ;
update ust_element_value_mapping set epa_value = '' where ust_element_value_mapping_id =  ;



select organization_value, epa_value, 
	ust_element_value_mapping_id, 
	organization_table_name, organization_column_name
from v_ust_element_mapping 
where ust_control_id = 35
and epa_column_name like 'tank_material%'
order by 1, 2;


select * from tank_material_descriptions order by 1;

Tank Construction		EPA Value for Tank Corrosion Protection (Y/N)(metallic tanks only)



Cathodically Protected Steel-StiP3		Yes for TankCorrosionProtection SacrificialAnode

delete from ust_element_value_mapping where ust_element_value_mapping_id = 2592;

update ust_element_value_mapping set epa_value = 'Composite/clad steel w/fiberglass reinforced plastic' where ust_element_value_mapping_id =  2587;
update ust_element_value_mapping set epa_value = 'Asphalt coated or bare steel' where ust_element_value_mapping_id =  2591;
update ust_element_value_mapping set epa_value = '' where ust_element_value_mapping_id =  ;



select ust_element_mapping_id, query_logic, epa_column_name, organization_table_name, organization_column_name 
from v_ust_element_mapping 
where ust_control_id = 35
and epa_column_name like 'tank_corro%'
order by 1, 2;

when tank_material_description_id in (5,6) then 'Yes' else null

update ust_element_mapping set query_logic = 'where "Tank Construction" = ''Cathodically Protected Steel-StiP3''' 
where ust_element_mapping_id = 3040;

select ust_element_mapping_id, query_logic, epa_column_name, organization_table_name, organization_column_name 
from v_ust_element_mapping 
where ust_control_id = 35
and epa_column_name like '%emerg%'
order by 1, 2;

update ust_element_mapping
set query_logic = 'when "Emergency Generator" = ''Emergency Generator'' then ''Yes'' when "Emergency Generator" = ''Not Emergency Generator'' then ''No'' else null'
where ust_element_mapping_id = 2975;


select epa_table_name, epa_column_name, organization_value, epa_value, 
	ust_element_value_mapping_id, ust_element_mapping_id,
	organization_table_name, organization_column_name
from v_ust_element_mapping 
where ust_control_id = 35
and epa_column_name like 'tank_se%'
order by 1, 2;

select * from tank_secondary_containments 

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name)
values (35, 'ust_tank','tank_secondary_containment_id','tn_compartments','Category Of Construction');


select distinct "Category Of Construction" from tn_ust.tn_compartments order by 1;

Double Wall
Single Wall

insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value)
values (4318, 'Double Wall','Double wall');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value)
values (4318, 'Single Wall','Single wall');



select organization_value, epa_value, 
	ust_element_value_mapping_id, ust_element_mapping_id, 
	organization_table_name, organization_column_name, query_logic, programmer_comments
from v_ust_element_mapping 
where ust_control_id = 35
and epa_column_name like 'compartment_status%'
order by 1, 2;

Permanently Out of Use	Permanently Out of Use
Currently in Use	Currently in Use
Temporarily Out of Use	Temporarily Out of Service

select distinct "Status"
from tn_ust.tn_compartments order by 1;
Currently in Use
Permanently Out of Use
Temporarily Out of Use

select * from tn_ust.erg_status;

select distinct "How Tank Closed"
from tn_ust.tn_compartments ;

Removed from Ground
Unkown
Closed in Ground

select * from  tn_ust.tn_compartments 
where "How Tank Closed" = 'Unkown'

select * from compartment_statuses 
Currently in use
Temporarily out of service
Closed (removed from ground)
Closed (in place)
Closed (general)
Abandoned
Other
Unknown

select distinct "Status", 
from tn_ust.tn_compartments 

create view tn_ust.v_compartment_status as 
select distinct case when "How Tank Closed" is not null then "Status" || ' - ' || "How Tank Closed" else "Status" end as "Status"
from tn_ust.tn_compartments 

Currently in Use								Currently in use
Permanently Out of Use							Closed (general)
Permanently Out of Use - Closed in Ground		Closed (in place)
Permanently Out of Use - Removed from Ground	Closed (removed from ground)
Permanently Out of Use - Unkown					Closed (general)
Temporarily Out of Use							Temporarily out of service

select * from tn_ust.v_compartment_status

delete from ust_element_value_mapping where ust_element_mapping_id = 2985;

update ust_element_mapping 
set organization_table_name = 'v_compartment_status', organization_column_name = 'Status', 
programmer_comments = 'ERG created view v_compartment_status to combine the "Status" and "How Tank Closed" columns in the organization table "tn_compartments"'
where ust_element_mapping_id = 2985;

insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (2985, 'Currently in Use', 'Currently in use');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (2985, 'Permanently Out of Use', 'Closed (general)');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (2985, 'Permanently Out of Use - Closed in Ground', 'Closed (in place)');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (2985, 'Permanently Out of Use - Removed from Ground', 'Closed (removed from ground)');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (2985, 'Permanently Out of Use - Unkown', 'Closed (general)');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (2985, 'Temporarily Out of Use', 'Temporarily out of service');


select organization_value, epa_value, 
	ust_element_value_mapping_id, ust_element_mapping_id, 
	organization_table_name, organization_column_name, query_logic, programmer_comments
from v_ust_element_mapping 
where ust_control_id = 35
and epa_table_name = 'ust_tank_substance'
and epa_column_name like 'substance_id'
order by 1, 2;

Biodiesel less than 100	Diesel blend containing 99% to less than 100% biodiesel
Ethanol Blend above E10	Gasoline E-15 (E-11-E15)
Gasoline_ULSDiesel	Multiple Products Listed
Gear Oil	Lube/motor oil (new)
Mineral Spirits	Mineral Spirits
Power Steering Fluid	TBD
Transmission Fluid Regulated	Transmission Fluid
ULS Diesel	Diesel fuel (ASTM D975), can contain 0-5% biodiesel
ULSDiesel_Kerosene 	Multiple Products Listed
Unknown Petroleum	Petroleum Product

select * from substances order by substance_group, substance;

update ust_element_value_mapping set epa_value = 'Diesel blend containing 99% to less than 100% biodiesel' where ust_element_value_mapping_id =  2594; --Biodiesel less than 100
update ust_element_value_mapping set epa_value = 'Gasoline E-15 (E-11-E15)' where ust_element_value_mapping_id =  2595; --Ethanol Blend above E10
update ust_element_value_mapping set epa_value = 'Multiple products listed' where ust_element_value_mapping_id = 2597; --Gasoline_ULSDiesel
update ust_element_value_mapping set epa_value = 'Lube/motor oil (new)' where ust_element_value_mapping_id =  2598; --Gear Oil
update ust_element_value_mapping set epa_value = 'Mineral spirits' where ust_element_value_mapping_id =  2601; --Mineral Spirits
update ust_element_value_mapping set epa_value = '' where ust_element_value_mapping_id =  2606; --Power Steering Fluid
update ust_element_value_mapping set epa_value = 'Transmission fluid' where ust_element_value_mapping_id =  2608; --Transmission Fluid Regulated
update ust_element_value_mapping set epa_value = 'Diesel fuel (ASTM D975), can contain 0-5% biodiesel' where ust_element_value_mapping_id =  2609; --ULS Diesel
update ust_element_value_mapping set epa_value = 'Multiple products listed' where ust_element_value_mapping_id =  2610; --ULSDiesel_Kerosene 
update ust_element_value_mapping set epa_value = 'Petroleum product' where ust_element_value_mapping_id =  2612; --Unknown Petroleum


select organization_value, epa_value, 
	ust_element_value_mapping_id, ust_element_mapping_id, 
	organization_table_name, organization_column_name, query_logic, programmer_comments
from v_ust_element_mapping 
where ust_control_id = 35
and epa_table_name = 'ust_compartment_substance'
and epa_column_name like 'substance_id'
order by 1, 2;

update ust_element_value_mapping set epa_value = 'Diesel blend containing 99% to less than 100% biodiesel' where ust_element_value_mapping_id =  2617; --Biodiesel less than 100
update ust_element_value_mapping set epa_value = 'Gasoline E-15 (E-11-E15)' where ust_element_value_mapping_id =  2618; --Ethanol Blend above E10
update ust_element_value_mapping set epa_value = 'Multiple products listed' where ust_element_value_mapping_id = 2620; --Gasoline_ULSDiesel
update ust_element_value_mapping set epa_value = 'Lube/motor oil (new)' where ust_element_value_mapping_id =  2621; --Gear Oil
update ust_element_value_mapping set epa_value = 'Mineral spirits' where ust_element_value_mapping_id =  2624; --Mineral Spirits
update ust_element_value_mapping set epa_value = 'Transmission fluid' where ust_element_value_mapping_id =  2631; --Transmission Fluid Regulated
update ust_element_value_mapping set epa_value = 'Diesel fuel (ASTM D975), can contain 0-5% biodiesel' where ust_element_value_mapping_id =  2632; --ULS Diesel
update ust_element_value_mapping set epa_value = 'Multiple products listed' where ust_element_value_mapping_id =  2633; --ULSDiesel_Kerosene 
update ust_element_value_mapping set epa_value = 'Petroleum product' where ust_element_value_mapping_id =  2635; --Unknown Petroleum




select * from v_mapped_substances 
where lower(organization_value) like '%power%'


select * from tn_ust.tn_haz_tanks;

select * from tn_ust.tn_haz_compartments 

select * from tn_ust.tn_facilities 

select a."Location ID", a."Facility Name", a."Street Address",
--	c."Facility Name", c."Street Address",
	b."FACILITY_NAME", b."FACILITY_ADDRESS1" 
from tn_ust.tn_haz_tanks a 
--  	left join tn_ust.tn_haz_compartments c on a."Location ID"::text =  c."Location ID"::text
	left join tn_ust.tn_facilities  b on a."Location ID"::text = b."FACILITY_ID_UST"::text
--where a."Facility Name" <> c."Facility Name" or a."Street Address" <> c."Street Address" 
order by 1;

select a."Location ID", a."Facility Name", a."Street Address",
	b."FACILITY_NAME", b."FACILITY_ADDRESS1" 
from 
order by 1;


select '"' || column_name || '", '
from information_schema.columns 
where table_schema = 'tn_ust' and table_name = 'tn_facilities'
order by ordinal_position;

select * from tn_ust.tn_haz_tanks;

select * from tn_ust.tn_facilities ;

select distinct 
	"FACILITY_ID_UST", 
	"FACILITY_NAME", 
	"FACILITY_ADDRESS1", 
	"FACILITY_ADDRESS2", 
	"FACILITY_CITY", 
	"FACILITY_ZIP"
	null as latitude,
	null as longitude,
	'tn_facilities' as source 
from tn_ust.tn_facilities 



select '"' || column_name || '", '
from information_schema.columns 
where table_schema = 'tn_ust' and table_name = 'tn_haz_tanks'
order by ordinal_position;

select 
	"Location ID"::text as facility_id, 
	"Facility Name"::text as facility_name, 
	"Street Address"::text as facility_address1, 
	null::text as facility_address2, 
	"City"::text as facility_city, 
	"State"::text as facility_state, 
	"Zip"::text as facility_zip, 
	"Latitude"::float facility_latitude, 
	"Longitude"::float as facility_longitude,
	'tn_haz_tanks' as data_source
from tn_ust.tn_haz_tanks a 
where "Federally Regulated Tank" = True
union all 
select distinct 
	a."FACILITY_ID_UST"::text, 
	a."FACILITY_NAME"::text, 
	a."FACILITY_ADDRESS1"::text, 
	a."FACILITY_ADDRESS2"::text, 
	a."FACILITY_CITY"::text, 
	'TN'::text as facility_state, 
	a."FACILITY_ZIP"::text,
	null::float as facility_latitude,
	null::float as facility_longitude,
	'tn_facilities' data_source 
from tn_ust.tn_facilities a join tn_ust.tn_compartments b on a."FACILITY_ID_UST"::text = b."Facility Id Ust"::text
where b."Regulated Status" = 'Regulated' or b."Regulated Status" is null; 


select * from tn_ust.tn_compartments
where "" not in 
	(select "FACILITY_ID_UST" from tn_ust.tn_facilities )
	
select * from tn_ust.tn_facilities
where "FACILITY_ID_UST" not in 
	(select "Facility Id Ust" from tn_ust.tn_compartments )	


select * from tn_ust.v_facilities;	
	
	

select count(*) from tn_ust.v_facilities ;
20068

select count(*) from (select distinct "Facility Id Ust" from tn_ust.tn_compartments ) a
19723


select count(*) from (select distinct "FACILITY_ID_UST" from tn_ust.tn_facilities ) a
20063


select distinct epa_column_name, organization_table_name, organization_column_name, ust_element_mapping_id, column_sort_order
from v_ust_element_mapping 
where ust_control_id = 35
and epa_table_name = 'ust_facility'
order by column_sort_order 


select * from tn_ust.erg_owner_type 
where "OWNER_TYPE" <> owner_type_converted

create view tn_ust.v_owner_types as 
select distinct "FACILITY_ID_UST" as facility_id, 
	case when "FACILITY_TYPE" = 'Federal Military' then 'Military' 
		else "OWNER_TYPE" end as owner_type 
from tn_ust.tn_facilities;


update ust_element_mapping
set organization_table_name = 'v_owner_types', organization_column_name = 'owner_type',
	programmer_comments = 'View v_owner_types created to cast owner type as Military when facility type = "Federal Military"; otherwise use source owner type'
where ust_element_mapping_id = 2956;


update ust_element_mapping 
set organization_table_name = 'v_facilities'
where ust_control_id = 35
and epa_table_name = 'ust_facility'
and organization_table_name = 'v_facility'

update ust_element_mapping
set organization_column_name = 'facility_id' where ust_element_mapping_id = 2954;
update ust_element_mapping
set organization_column_name = 'facility_name' where ust_element_mapping_id = 2955;
update ust_element_mapping
set organization_column_name = 'facility_address1' where ust_element_mapping_id = 2958;
update ust_element_mapping
set organization_column_name = 'facility_address2' where ust_element_mapping_id = 2959;
update ust_element_mapping
set organization_column_name = 'facility_city' where ust_element_mapping_id = 2960;
update ust_element_mapping
set organization_column_name = 'facility_zip' where ust_element_mapping_id = 2961;
update ust_element_mapping
set organization_column_name = 'facility_latitude' where ust_element_mapping_id = 2962;
update ust_element_mapping
set organization_column_name = 'facility_longitude' where ust_element_mapping_id = 2963;

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name)
values (35, 'ust_facility','facility_state','v_facility','facility_state');

update ust_element_mapping set organization_table_name = 'v_facilities'
where ust_element_mapping_id  in (2962,2963)

update ust_element_mapping set organization_table_name = 'tn_facilities'
where ust_element_mapping_id  in (2957)



insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name)
values (35, '','','','');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name)
values (35, '','','','');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name)
values (35, '','','','');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name)
values (35, '','','','');

select * from tn_ust.erg_coordinates_combined

select * from information_schema.columns 
where table_schema = 'tn_ust' 
and lower(column_name) like '%lat%'

select * from tn_ust.facilities_gis;


select * from ust_control where ust_control_id = 35;

update ust_control set comments = comments || '

For facilities, source data includes tables tn_facilities (main facility date source), 
closed_facilities_gis and facilities_gis (lat/longs for most facilities), 
and tn_haz_tanks (supplemental hazardous substance table with some facilities not in 
tn_facilities). The following view was created to generate a single, unique source 
of facility information. When facility-level data (facilitiy name, address, etc.) 
conflicted between tn_facilities and tn_haz_tanks, the data in tn_haz_tanks was preferred.

CREATE OR REPLACE VIEW tn_ust.v_facilities
AS WITH gis_candidates AS (
         SELECT g."FACILITY_ID"::character varying(50) AS facility_id,
            g."LATITUDE" AS facility_latitude,
            g."LONGITUDE" AS facility_longitude,
            1 AS gis_priority
           FROM tn_ust.facilities_gis g
          WHERE g."FACILITY_ID" IS NOT NULL
        UNION ALL
         SELECT g."FACILITY_ID"::character varying(50) AS facility_id,
            g."LATITUDE" AS facility_latitude,
            g."LONGITUDE" AS facility_longitude,
            2 AS gis_priority
           FROM tn_ust.closed_facilities_gis g
          WHERE g."FACILITY_ID" IS NOT NULL
        ), gis_locations AS (
         SELECT ranked_gis.facility_id,
            ranked_gis.facility_latitude,
            ranked_gis.facility_longitude
           FROM ( SELECT gis_candidates.facility_id,
                    gis_candidates.facility_latitude,
                    gis_candidates.facility_longitude,
                    gis_candidates.gis_priority,
                    row_number() OVER (PARTITION BY gis_candidates.facility_id ORDER BY gis_candidates.gis_priority) AS rn
                   FROM gis_candidates) ranked_gis
          WHERE ranked_gis.rn = 1
        ), facility_candidates AS (
         SELECT h."Location ID"::character varying(50) AS facility_id,
            h."Facility Name"::character varying(100) AS facility_name,
            h."Street Address"::character varying(100) AS facility_address1,
            NULL::character varying(100) AS facility_address2,
            h."City"::character varying(100) AS facility_city,
            h."Zip"::character varying(10) AS facility_zip_code,
            h."State"::character varying(2) AS facility_state,
            COALESCE(h."Latitude", g.facility_latitude) AS facility_latitude,
            COALESCE(h."Longitude", g.facility_longitude) AS facility_longitude,
            1 AS source_priority
           FROM tn_ust.tn_haz_tanks h
             LEFT JOIN gis_locations g ON g.facility_id::text = h."Location ID"::character varying(50)::text
          WHERE h."Location ID" IS NOT NULL
        UNION ALL
         SELECT f."FACILITY_ID_UST"::character varying(50) AS facility_id,
            f."FACILITY_NAME"::character varying(100) AS facility_name,
            f."FACILITY_ADDRESS1"::character varying(100) AS facility_address1,
            f."FACILITY_ADDRESS2"::character varying(100) AS facility_address2,
            f."FACILITY_CITY"::character varying(100) AS facility_city,
            f."FACILITY_ZIP"::character varying(10) AS facility_zip_code,
            ''TN''::character varying(2) AS facility_state,
            g.facility_latitude,
            g.facility_longitude,
            2 AS source_priority
           FROM tn_ust.tn_facilities f
             LEFT JOIN gis_locations g ON g.facility_id::text = f."FACILITY_ID_UST"::character varying(50)::text
          WHERE f."FACILITY_ID_UST" IS NOT NULL
        ), ranked_facilities AS (
         SELECT facility_candidates.facility_id,
            facility_candidates.facility_name,
            facility_candidates.facility_address1,
            facility_candidates.facility_address2,
            facility_candidates.facility_city,
            facility_candidates.facility_zip_code,
            facility_candidates.facility_state,
            facility_candidates.facility_latitude,
            facility_candidates.facility_longitude,
            facility_candidates.source_priority,
            row_number() OVER (PARTITION BY facility_candidates.facility_id ORDER BY facility_candidates.source_priority) AS rn
           FROM facility_candidates
        )
 SELECT ranked_facilities.facility_id,
    ranked_facilities.facility_name,
    ranked_facilities.facility_address1,
    ranked_facilities.facility_address2,
    ranked_facilities.facility_city,
    ranked_facilities.facility_zip_code,
    ranked_facilities.facility_state,
    ranked_facilities.facility_latitude,
    ranked_facilities.facility_longitude
   FROM ranked_facilities
  WHERE ranked_facilities.rn = 1;
' 
where  ust_control_id = 35



select distinct epa_column_name, organization_table_name, organization_column_name, ust_element_mapping_id, column_sort_order
from v_ust_element_mapping 
where ust_control_id = 35
and epa_table_name = 'ust_tank'
order by column_sort_order ;

tank_status_id	erg_status	status_combined	2969


update ust_element_mapping 
set organization_table_name = 'v_tank_compartments', 
programmer_comments = 'View v_tank_compartments created to identify compartmentalized tanks and number of compartments' 
where ust_element_mapping_id in (2973,2972);


update ust_element_mapping 
set organization_table_name = 'v_tank_status', organization_column_name = 'Status', 
programmer_comments = 'View v_tank_status created to roll compartment statuses up to a unique tank status based on the compartment status hierarchy in lookup table compartment_statuses' 
where ust_element_mapping_id = 2969;

select * from  tn_ust.v_tank_status;

compartmentalized_ust	erg_compartment_counts	compartment_count
number_of_compartments	erg_compartment_counts	compartment_count

select * from tn_ust.erg_status

select * from tn_ust.erg_compartment_counts order by 1 desc;

create view tn_ust.v_tank_compartments as 
select "Facility Id Ust", "Tank Id", "Tank Number", number_of_compartments, 
	case when number_of_compartments > 1 then 'Yes' else 'No' end as compartmentalized_ust
from 
	(select "Facility Id Ust", "Tank Id", "Tank Number", count(*) as number_of_compartments
	from 
		(select distinct "Facility Id Ust", "Tank Id", "Tank Number", "Compartment Id"
		from tn_ust.tn_compartments) a
	group by "Facility Id Ust", "Tank Id", "Tank Number") b;




drop view tn_ust.v_compartment_status

CREATE OR REPLACE VIEW tn_ust.v_compartment_status
AS SELECT DISTINCT
	 "Facility Id Ust", "Tank Id", "Tank Number", "Compartment Id", "Compartment Letter",
        CASE
            WHEN a."How Tank Closed" IS NOT NULL THEN (a."Status" || ' - '::text) || a."How Tank Closed"
            ELSE a."Status"
        END AS "Status",
        epa_value 
   FROM tn_ust.tn_compartments a
   	left join (select organization_value, epa_value 
   	           from v_ust_element_mapping 
   	           where ust_control_id = 35 
   	           and epa_column_name = 'compartment_status_id') b on  CASE
            WHEN a."How Tank Closed" IS NOT NULL THEN (a."Status" || ' - '::text) || a."How Tank Closed"
            ELSE a."Status"
        END = b.organization_value 
  

select distinct epa_column_name, organization_table_name, organization_column_name, ust_element_mapping_id, column_sort_order
from v_ust_element_mapping 
where ust_control_id = 35
and epa_table_name = 'ust_compartment'
order by column_sort_order ;

update ust_element_mapping set programmer_comments = 'View v_compartment_status created to combine source columns "Status" and "How Tank Closed" to get detailed compartment status'
where ust_element_mapping_id = 2985;

select "Facility Id Ust", "Tank Id", "Tank Number", count(*)
from 
	(select "Facility Id Ust", "Tank Id", "Tank Number", "Status"
	from tn_ust.v_compartment_status) a
group by "Facility Id Ust", "Tank Id", "Tank Number"
having count(*) > 1;


select * from  tn_ust.v_compartment_status
order by "Facility Id Ust", "Tank Id", "Tank Number", "Status"


select * from tn_ust.v_compartment_status;

select * from compartment_statuses;

select *
from tn_ust.v_compartment_status_errors
order by "Facility Id Ust", "Tank Id", "Compartment Id";


select distinct epa_column_name, organization_table_name, organization_column_name, ust_element_mapping_id, column_sort_order
from v_ust_element_mapping 
where ust_control_id = 35
and epa_table_name = 'ust_tank_substance'
order by column_sort_order ;

select * from ust_elements where element_name like 'Tank%'

create view tn_ust.v_tank_substances as 
select distinct "Facility Id Ust" as facilty_id, "Tank Id" as tank_id, "Tank Number" as tank_name, "Product" 
from tn_ust.tn_compartments



select * from tn_ust.tn_haz_tanks 

select *
into tn_ust.erg_tank_substance_conflicts 
from tn_ust.v_tank_substance_conflicts
order by facility_id, tank_id, tank_name;


2470923	15710

select * from tn_ust.v_tank_substance 
where facility_id = '2470923' and tank_id = 15710;

select * from tn_ust.tn_facilities 


select * from tn_ust.tn_compartments;


select distinct epa_column_name, organization_table_name, organization_column_name, ust_element_mapping_id, column_sort_order
from v_ust_element_mapping 
where ust_control_id = 35
and epa_table_name = 'ust_compartment'
order by column_sort_order ;

update ust_element_mapping 
set programmer_comments = 'Created view v_tn_compartments to exclude non-regulated tanks' 
where  ust_control_id = 35
and epa_table_name = 'ust_compartment'
and organization_table_name = 'v_tn_compartments'


select distinct epa_column_name, organization_table_name, organization_column_name, ust_element_mapping_id, column_sort_order
from v_ust_element_mapping 
where ust_control_id = 35
and epa_table_name = 'ust_tank_substance'
order by column_sort_order ;

select * from tn_ust.v_tank_substance;

update ust_element_mapping 
set organization_table_name = 'v_tank_substance', organization_column_name = 'facility_id', 
	programmer_comments = 'View v_tank_substance written to combine tn_compartments and tn_haz_tanks; where there was a conflict between tank substances, preferred the substance/product from tn_haz_tanks' 
where ust_element_mapping_id = 2976;
update ust_element_mapping 
set organization_table_name = 'v_tank_substance', organization_column_name = 'tank_id', 
	programmer_comments = 'View v_tank_substance written to combine tn_compartments and tn_haz_tanks; where there was a conflict between tank substances, preferred the substance/product from tn_haz_tanks' 
where ust_element_mapping_id = 2977;
update ust_element_mapping 
set organization_table_name = 'v_tank_substance', organization_column_name = 'tank_name', 
	programmer_comments = 'View v_tank_substance written to combine tn_compartments and tn_haz_tanks; where there was a conflict between tank substances, preferred the substance/product from tn_haz_tanks' 
where ust_element_mapping_id = 2978;
update ust_element_mapping 
set organization_table_name = 'v_tank_substance', organization_column_name = 'Product', 
	programmer_comments = 'View v_tank_substance written to combine tn_compartments and tn_haz_tanks; where there was a conflict between tank substances, preferred the substance/product from tn_haz_tanks' 
where ust_element_mapping_id = 2979;


select distinct epa_column_name, organization_table_name, organization_column_name, ust_element_mapping_id, column_sort_order
from v_ust_element_mapping 
where ust_control_id = 35
and epa_table_name = 'ust_compartment_substance'
order by column_sort_order ;

select * from tn_ust.tn_compartments where "Product" = 'Power Steering Fluid'

select * from tn_ust.tn_haz_tanks where "Location ID" = '3331311'


select * from tn_ust.tn_haz_compartments where "Location ID" = '3331311'

select distinct "How Tank Closed" from tn_ust.tn_compartments ;

select * from tank_statuses;


select "Facility Id Ust", "Facility Name", "Status", "How Tank Closed", "Date Tank Closed"
from tn_ust.tn_compartments
where "How Tank Closed" is not null
and "Status" <> 'Permanently Out of Use'


select * from tn_ust.v_compartment_status 

select distinct "Status" from tn_ust.v_compartment_status 
order by 1;

Closed (removed from ground)
Currently in Use
Currently in Use - Unkown
Permanently Out of Use
Permanently Out of Use - Closed in Ground
Permanently Out of Use - Unkown
Temporarily Out of Use
Temporarily Out of Use - Unkown

select distinct "Status" from tn_ust.v_tank_status 
order by 1;

Closed (general)
Closed (in place)
Closed (removed from ground)
Currently in use
Temporarily out of service

select distinct epa_column_name, organization_table_name, organization_column_name, ust_element_mapping_id, column_sort_order
from v_ust_element_mapping 
where ust_control_id = 35
and epa_table_name = 'ust_compartment'
and epa_column_name = 'compartment_status_id'
order by column_sort_order ;


select organization_value, epa_value, 
	ust_element_value_mapping_id, ust_element_mapping_id,
	organization_table_name, organization_column_name
from v_ust_element_mapping 
where ust_control_id = 35
and epa_column_name = 'compartment_status_id'
order by 1, 2;

select organization_value, epa_value, 
	ust_element_value_mapping_id, ust_element_mapping_id
from  v_ust_element_mapping
where ust_control_id = 35 and epa_column_name = 'compartment_status_id'
and organization_value not in (select "Status" from tn_ust.v_compartment_status)
order by 1, 2;

delete from ust_element_value_mapping where ust_element_value_mapping_id = 4027;

insert into ust_element_value_mapping(ust_element_mapping_id,organization_value,epa_value)
values (2985,'Closed (removed from ground)','Closed (removed from ground)');
insert into ust_element_value_mapping(ust_element_mapping_id,organization_value,epa_value)
values (2985,'Temporarily Out of Use - Unkown','Temporarily out of service');

select distinct "Status" from tn_ust.v_compartment_status
where "Status" not in 
	(select organization_value from v_ust_element_mapping
	where ust_control_id = 35 and epa_column_name = 'compartment_status_id')
order by 1;

select * from compartment_statuses 

insert into ust_element_value_mapping(ust_element_mapping_id,organization_value,epa_value)
values (2985,'Currently in Use - Unkown','Currently in use');


select organization_value, epa_value, 
	ust_element_value_mapping_id, ust_element_mapping_id,
	organization_table_name, organization_column_name
from v_ust_element_mapping 
where ust_control_id = 35
and epa_column_name = 'tank_status_id'
order by 1, 2;

Currently in Use								Currently in use
Permanently Out of Use							Closed (general)
Permanently Out of Use - Closed in Ground		Closed (in place)
Permanently Out of Use - Removed from Ground	Closed (removed from ground)
Permanently Out of Use - Unkown					Closed (general)
Temporarily Out of Use							Temporarily out of service


select organization_value, epa_value, 
	ust_element_value_mapping_id, ust_element_mapping_id
from  v_ust_element_mapping
where ust_control_id = 35 and epa_column_name = 'tank_status_id'
and organization_value not in (select "Status" from tn_ust.v_tank_status)
order by 1, 2;

delete from ust_element_value_mapping where ust_element_value_mapping_id in (2581,2646,2582,2583,2584,2585);

select distinct "Status" from tn_ust.v_tank_status
where "Status" not in 
	(select organization_value from v_ust_element_mapping
	where ust_control_id = 35 and epa_column_name = 'tank_status_id')
order by 1;

Closed (general)
Closed (in place)
Closed (removed from ground)
Currently in use
Temporarily out of service

Small Delivery	EPA Value for OverfillPrevention Not Required and SpillPrevention Not Required (Y/N)
More than 25	Yes
Less than 25	No





select distinct epa_column_name, organization_table_name, organization_column_name, query_logic,
	programmer_comments, ust_element_mapping_id, column_sort_order
from v_ust_element_mapping 
where ust_control_id = 35
and epa_table_name = 'ust_compartment'
and epa_column_name like '%not_requ%'
order by column_sort_order ;

update ust_element_mapping 
set organization_table_name = 'v_overfill_prevention_not_required',
    organization_column_name = 'overfill_prevention_not_required',
    query_logic = null, 
    programmer_comments = 'View v_overfill_prevention_not_required created to combine values in columns "Overfill Prevention" and "Small Delivery" to determine if overfill prevention is required.' 
where ust_element_mapping_id = 2992;

update ust_element_mapping 
set organization_table_name = 'v_spill_prevention_not_required',
    organization_column_name = 'spill_prevention_not_required',
    query_logic = null, 
    programmer_comments = 'View v_spill_prevention_not_required created to combine values in columns "Spill Prevention" and "Small Delivery" to determine if spill prevention is required.' 
where ust_element_mapping_id = 2994;



select distinct "Overfill Prevention" from tn_ust.v_tn_compartments order by 1;
Automatic Shut Off Device
Ball Float Valves
Not Required
Overfill Alarm
unknown
Vent Whistle

select distinct "Spill Prevention"  from tn_ust.v_tn_compartments order by 1;
Double walled
Not Required
Single walled


select distinct "Small Delivery" from tn_ust.v_tn_compartments order by 1;
Less than 25
More than 25

create view tn_ust.v_overfill_prevention_not_required as
SELECT DISTINCT 
	"Facility Id Ust",
    "Tank Id",
    "Tank Number",
    "Compartment Id",
    "Compartment Letter",
    case when "Overfill Prevention" = 'Not Required' then 'Yes' 
         when "Small Delivery" = 'Less than 25' then 'Yes' 
    	 when "Overfill Prevention" is not null then 'No' end as overfill_prevention_not_required
from  tn_ust.v_tn_compartments 

select overfill_prevention_not_required, count(*) 
from tn_ust.v_overfill_prevention_not_required 
group by overfill_prevention_not_required
	42434
No	15459
Yes	251

create view tn_ust.v_spill_prevention_not_required as
SELECT DISTINCT 
	"Facility Id Ust",
    "Tank Id",
    "Tank Number",
    "Compartment Id",
    "Compartment Letter",
    case when "Spill Prevention" = 'Not Required' then 'Yes' 
         when "Small Delivery" = 'Less than 25' then 'Yes' end as spill_prevention_not_required
from  tn_ust.v_tn_compartments 


select spill_prevention_not_required, count(*) 
from tn_ust.v_spill_prevention_not_required
group by spill_prevention_not_required



Overfill Prevention	EPA Value for Overfill Prevention (Y/N)
Automatic Shut Off Device	Yes for OverfillPreventionFlow ShutoffDevice
Ball Float Valves	Yes for OverfillPreventionBall FloatValve
Overfill Alarm	Yes for OverfillPrevention HighLevelAlarm
Not Required	Yes for OverfillPrevention NotRequired
unknown	Yes for OverfillPrevention Unknown
Vent Whistle	Yes for OverfillPreventionOther



select distinct epa_column_name, organization_table_name, organization_column_name, query_logic,
	programmer_comments, ust_element_mapping_id, column_sort_order
from v_ust_element_mapping 
where ust_control_id = 35
and epa_table_name = 'ust_compartment'
and epa_column_name like '%overfill_pre%'
order by column_sort_order ;


update ust_element_mapping set query_logic = 'case when "Overfill Prevention" = ''Ball Float Valves'' then ''Yes'' end' where ust_element_mapping_id = 2987;
update ust_element_mapping set query_logic = 'case when "Overfill Prevention" = ''Automatic Shut Off Device'' then ''Yes'' end' where ust_element_mapping_id = 2988;
update ust_element_mapping set query_logic = 'case when "Overfill Prevention" = ''Overfill Alarm'' then ''Yes'' end' where ust_element_mapping_id = 2989;
update ust_element_mapping set query_logic = 'case when "Overfill Prevention" = ''Vent Whistle'' then ''Yes'' end' where ust_element_mapping_id = 2990;
update ust_element_mapping set query_logic = 'case when "Overfill Prevention" = ''unknown'' then ''Yes'' end' where ust_element_mapping_id = 2991;

Spill Prevention	EPA Value for Spill Bucket Installed (Y/N)	EPA Value for Spill Bucket Wall Type
Single walled	Yes 	Single Wall
Double walled	Yes 	Double Wall
	

select distinct epa_column_name, organization_table_name, organization_column_name, query_logic,
	programmer_comments, ust_element_mapping_id, column_sort_order
from v_ust_element_mapping 
where ust_control_id = 35
and epa_table_name = 'ust_compartment'
and epa_column_name like '%spill_bu%'
order by column_sort_order ;


--create view tn_ust.v_spill_bucket_installed as
--SELECT DISTINCT 
--	a."Facility Id Ust",
--    a."Tank Id",
--    a."Tank Number",
--    a."Compartment Id",
--    a."Compartment Letter",
--    case when "Spill Bucket Installation Date" is not null then 'Yes' end as spill_bucket_installed
--from tn_ust.v_tn_compartments a;

select * from  tn_ust.v_spill_bucket_installed


select * from tn_ust.tn_haz_compartments 




select organization_value, epa_value, 
	ust_element_value_mapping_id, ust_element_mapping_id, epa_column_name,
	organization_table_name, organization_column_name
from v_ust_element_mapping 
where ust_control_id = 35
and epa_column_name like '%spill_bu%'
order by 1, 2;

--update ust_element_mapping 
--set 
--	organization_table_name = 'v_spill_bucket_installed',
-- 	organization_column_name = 'v_spill_bucket_installed',
-- 	query_logic = '',
-- 	programmer_comments = '' 
--where ust_element_mapping_id  = 2993


select * from information_schema.columns 
where table_schema = 'tn_ust' and column_name like '%Spill%'

select "Spill Installed", count(*) 
from tn_ust.tn_haz_compartments
group by "Spill Installed"

	8
2.0	17



select distinct "Compartment Release Detection" from tn_ust.v_tn_compartments order by 1;

Compartment Release Detection						EPA Value for Tank Release Detection (Y/N) - multiple values allowed

Automatic Tank Gauging								Yes for TankAutomaticTankGaugingReleaseDetection
Continuous In Tank Leak Detection System - CITLDS	Yes for AutomaticTankGaugingContinuousLeakDetection
Deferred											blank
Ground Water Monitoring								Yes for TankGroundwaterMonitoring
Interstitial Monitoring								Yes for TankInterstitialMonitoring
Inventory Control									Yes for TankInventoryControl
Manual Tank Gauging									Yes for TankManualTankGauging
Manual Tank Gauging and Tank Tightness Testing		Yes for TankManualTankGauging and Yes for TankTightnessTesting
Other or No Method									blank
Statistical Inventory Reconciliation (SIR)			Yes for TankStatisticalInventoryReconciliation
Tank LD Not Listed									blank

select epa_column_name, query_logic, programmer_comments,
	ust_element_mapping_id
from v_ust_condensed_mapping 
where ust_control_id = 35
and organization_column_name = 'Compartment Release Detection'
order by column_sort_order;

select 'update ust_element_mapping set query_logic = ''' || query_logic || ''' where ust_element_mapping_id = ' || ust_element_mapping_id || '; --' || epa_column_name 
from  v_ust_condensed_mapping 
where ust_control_id = 35
and organization_column_name = 'Compartment Release Detection'
order by column_sort_order;


update ust_element_mapping set query_logic = 'case when "Compartment Release Detection" = ''Automatic Tank Gauging'' then ''Yes'' end' where ust_element_mapping_id = 2997; --tank_automatic_tank_gauging_release_detection
update ust_element_mapping set query_logic = 'case when "Compartment Release Detection" = ''Continuous In Tank Leak Detection System - CITLDS'' then ''Yes'' end' where ust_element_mapping_id = 2998; --automatic_tank_gauging_continuous_leak_detection
update ust_element_mapping set query_logic = 'case when "Compartment Release Detection" like ''Manual%'' then ''Yes'' end' where ust_element_mapping_id = 2999; --tank_manual_tank_gauging
update ust_element_mapping set query_logic = 'case when "Compartment Release Detection" = ''Statistical Inventory Reconciliation (SIR)'' then ''Yes'' end' where ust_element_mapping_id = 3000; --tank_statistical_inventory_reconciliation
update ust_element_mapping set query_logic = 'case when "Compartment Release Detection" = ''Manual Tank Gauging and Tank Tightness Testing'' then ''Yes'' end' where ust_element_mapping_id = 3001; --tank_tightness_testing
update ust_element_mapping set query_logic = 'case when "Compartment Release Detection" = ''Inventory Control'' then ''Yes'' end' where ust_element_mapping_id = 3002; --tank_inventory_control
update ust_element_mapping set query_logic = 'case when "Compartment Release Detection" = ''Ground Water Monitoring'' then ''Yes'' end' where ust_element_mapping_id = 3003; --tank_groundwater_monitoring
delete from ust_element_mapping where ust_element_mapping_id = 3004;


select epa_column_name, query_logic, programmer_comments,
	ust_element_mapping_id
from v_ust_condensed_mapping 
where ust_control_id = 35
and organization_column_name = 'Piping Material'
order by column_sort_order;


Piping Material	EPA Value for Piping Material (Y/N)

Steel	Yes for PipingMaterialSteel
Copper	Yes for PipingMaterialCopper
Rigid Plastic - (NUPI - Western Fiberglass -UPP - Brugg)	Yes for PipingMaterialFRP
Flexible Plastic (APT - OPW Pieces - Environ - etc)	Yes for PipingMaterialFlex
Other	Yes for PipingMaterialOther
Fiberglass FRP - (Ameron Dualoy - Smith Fibercast)	Yes for PipingMaterialFRP
Hazardous Substance	Not a material
Gasoline_ULSDiesel	Not a material
ULSDiesel_Kerosene 	Not a material
Kerosene	Not a material
Gasoline	Not a material
No Piping	PipingMaterialNoRegulatedPiping


select 'update ust_element_mapping set query_logic = ''' || query_logic || ''' where ust_element_mapping_id = ' || ust_element_mapping_id || '; --' || epa_column_name 
from  v_ust_condensed_mapping 
where ust_control_id = 35
and organization_column_name = 'Piping Material'
order by column_sort_order;


update ust_element_mapping set query_logic = 'case when "Piping Material" in (''Rigid Plastic - (NUPI - Western Fiberglass -UPP - Brugg)'', ''Fiberglass FRP - (Ameron Dualoy - Smith Fibercast))'') then ''Yes'' end' where ust_element_mapping_id = 3021; --piping_material_frp
update ust_element_mapping set query_logic = 'case when "Piping Material" = ''Steel'' then ''Yes'' end' where ust_element_mapping_id = 3022; --piping_material_steel
update ust_element_mapping set query_logic = 'case when "Piping Material" = ''Copper'' then ''Yes'' end' where ust_element_mapping_id = 3023; --piping_material_copper
update ust_element_mapping set query_logic = 'case when "Piping Material" = ''Flexible Plastic (APT - OPW Pieces - Environ - etc)'' then ''Yes'' end' where ust_element_mapping_id = 3024; --piping_material_flex
update ust_element_mapping set query_logic = 'case when "Piping Material" = ''No Piping'' then ''Yes'' end' where ust_element_mapping_id = 3025; --piping_material_no_piping
delete from ust_element_mapping where ust_element_mapping_id = 3026;



Piping Type	EPA Value for Piping Style 

Gravity Feed	Non-operational e.g., fill line, vent line, gravity
No Piping	No Piping
No Piping - Manifolded	No Piping
Not Listed	Other 
Pressurized	Pressure
Pressurized-Suction	Other 
Suction	Suction


select * from v_ust_value_mapping 
where ust_control_id = 35 
and epa_column_name = 'piping_style_id'

update ust_element_value_mapping set epa_value = 'Other' where ust_element_value_mapping_id = 2642;

Pipe Construction Type	EPA Value for Piping Wall Type
Double Wall	Double Wall
Single Wall	Single Wall


select * from v_ust_value_mapping 
where ust_control_id = 35 
and epa_column_name = 'piping_wall_type_id'




Leak Detection Periodic	EPA Value for Piping Release Detection (Y/N) - multiple values allowed

--3 Year LTT								Yes for PipingLineTest3yr
--Annual LTT								Yes for PipingLineTestAnnual
--ELLD .1 Annual							Yes for PipingLineLeakDetector and Yes for PipingLineTestAnnual
--ELLD .2 Monthly							Yes for PipingLineLeakDetector and Yes for PipingLineTestAnnual
--Groundwater Monitoring					Yes for PipingGroundwaterMonitoring
--Interstitial Monitoring for Piping		Yes for PipingInterstitialMonitoring
None Required							blank
--Other or No Method of Release Detection	Yes for PipingReleaseDetectionOther
Pipe Leak Detection Not Listed			blank
--Statistical Inventory Reconciliation	Yes for PipingStatisticalInventoryReconciliation
--Vapor Monitoring						Yes for PipingVaporMonitoring

select 'update ust_element_mapping set query_logic = ''' || query_logic || ''' where ust_element_mapping_id = ' || ust_element_mapping_id || '; --' || epa_column_name 
from  v_ust_condensed_mapping 
where ust_control_id = 35
and organization_column_name = 'Leak Detection Periodic'
order by column_sort_order;

update ust_element_mapping set query_logic = 'case when "Leak Detection Periodic" in (''ELLD .1 Annual'',''ELLD .2 Monthly'') then ''Yes'' end' where ust_element_mapping_id = 3027; --piping_line_leak_detector
update ust_element_mapping set query_logic = 'case when "Leak Detection Periodic" in (''ELLD .1 Annual'',''ELLD .2 Monthly'',''Annual LTT'') then ''Yes'' end' where ust_element_mapping_id = 3029; --piping_line_test_annual
update ust_element_mapping set query_logic = 'case when "Leak Detection Periodic" = ''3 Year LTT'' then ''Yes'' end' where ust_element_mapping_id = 3030; --piping_line_test3yr
update ust_element_mapping set query_logic = 'case when "Leak Detection Periodic" = ''Groundwater Monitoring'' then ''Yes'' end' where ust_element_mapping_id = 3031; --piping_groundwater_monitoring
update ust_element_mapping set query_logic = 'case when "Leak Detection Periodic" = ''Vapor Monitoring'' then ''Yes'' end' where ust_element_mapping_id = 3032; --piping_vapor_monitoring
update ust_element_mapping set query_logic = 'case when "Leak Detection Periodic" = ''Interstitial Monitoring for Piping'' then ''Yes'' end' where ust_element_mapping_id = 3033; --piping_interstitial_monitoring
update ust_element_mapping set query_logic = 'case when "Leak Detection Periodic" = ''Statistical Inventory Reconciliation'' then ''Yes'' end' where ust_element_mapping_id = 3034; --piping_statistical_inventory_reconciliation
update ust_element_mapping set query_logic = 'case when "Leak Detection Periodic" = ''Other or No Method of Release Detection'' then ''Yes'' end' where ust_element_mapping_id = 3035; --piping_release_detection_other


select * from v_ust_condensed_mapping 
where ust_control_id = 35
and epa_column_name like '%line%'





CREATE OR REPLACE VIEW tn_ust.v_piping_line_leak_detector
AS SELECT DISTINCT c."Facility Id Ust",
    c."Tank Id",
    c."Tank Number",
    c."Compartment Id",
    c."Compartment Letter",
        CASE
            WHEN (c."Leak Detection Periodic" = ANY (ARRAY['ELLD .1 Annual'::text, 'ELLD .2 Monthly'::text])) OR (c."Leak Detection Cat" = ANY (ARRAY['Annual Line Leak Detector Test'::text, 'Electronic'::text, 'Mechanical (Automatic)'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_line_leak_detector
   FROM tn_ust.v_tn_compartments c;

Leak Detection Cat	EPA Value for Piping Release Detection (Y/N) - multiple values allowed

Annual Line Leak Detector Test	Yes for PipingLineLeakDetector
Electronic						Yes for PipingLineLeakDetector
Mechanical (Automatic)			Yes for PipingLineLeakDetector
None Required					blank
Other							Yes for PipingReleaseDetectionOther


select * from v_ust_condensed_mapping where ust_element_mapping_id = 3027

update ust_element_mapping set query_logic = null, 
programmer_comments = 'Created view v_piping_line_leak_detector to combine values from source columns "Leak Detection Periodic" and "Leak Detection Cat"'
where  ust_element_mapping_id = 3027

select epa_column_name, query_logic, programmer_comments,
	ust_element_mapping_id
from v_ust_condensed_mapping 
where ust_control_id = 35
and organization_column_name = 'Leak Detection Cat'
order by column_sort_order;



select * from tn_ust.erg_unregulated_facilities ;

select * from tn_ust.erg_unregulated_tanks 


select relname as table_name,
       seq_scan,
       seq_tup_read,
       idx_scan,
       n_live_tup
from pg_stat_user_tables
where schemaname = lower('tn_ust')
  and seq_scan > 0
  and coalesce(idx_scan, 0) = 0
order by seq_tup_read desc, seq_scan desc;


select * from tn_ust.v_tn_compartments where "Facility Id Ust" = '2470923' and "Tank Id" = 15710
Transmission Fluid Regulated


select * from tn_ust.tn_haz_compartments where "Location ID" = '2470923'

select * from tn_ust.v_tank_substance where facility_id = '2470923' 

select * from v_ust_value_mapping
where ust_control_id = 35 
and epa_column_name = 'substance_id'
and epa_table_name = 'ust_tank_substance'
order by organization_value;


select distinct "Product" 
from tn_ust.v_tank_substance 
where "Product" not in 
	(select organization_value from v_ust_value_mapping
	where ust_control_id = 35 
	and epa_column_name = 'substance_id'
	and epa_table_name = 'ust_tank_substance' )
order by 1;

    select * from tn_ust."v_facilities"
    
    
select distinct epa_column_name, 
	organization_table_name, organization_column_name, 
	query_logic, ust_element_mapping_id, column_sort_order
from v_ust_element_mapping 
where ust_control_id = 35 and epa_table_name = 'ust_facility'
order by column_sort_order 

select * from information_schema.columns 
where table_schema = 'tn_ust' and column_name = 'OWNER_NAME'


update ust_element_mapping set organization_table_name = 'tn_facilities' where ust_element_mapping_id = 2964;


select distinct epa_column_name, 
	organization_table_name, organization_column_name, 
	query_logic, ust_element_mapping_id, column_sort_order
from v_ust_element_mapping 
where ust_element_mapping_id = 2980

select distinct epa_column_name, 
	organization_table_name, organization_column_name, 
	query_logic, programmer_comments 
from v_ust_element_mapping 
where ust_element_mapping_id = 2980

Facility Id Ust

select column_name
from information_schema.columns 
where table_schema = 'tn_ust' 
and table_name = 'v_tn_compartments' 
order by ordinal_position;

update ust_element_mapping set organization_column_name = 'Facility Id Ust' where ust_element_mapping_id = 2980;

update ust_element_mapping set organization_column_name = 'facility_zip_code' where ust_element_mapping_id = 2961;
update ust_element_mapping set orgnization_table_name = 'tn_facilities' where ust_element_mapping_id = 2964;


select * 
from v_ust_element_mapping 
where ust_element_mapping_id in (2972,2973)

update ust_element_mapping set organization_column_name = 'compartmentalized_ust' where ust_element_mapping_id = 2972;
update ust_element_mapping set organization_column_name = 'number_of_compartments' where ust_element_mapping_id = 2973;


-- ust_compartment.facility_id: unknown organization source column tn_ust.v_tn_compartments."Facility Id US"
-- Perhaps you meant: "Facility Id Ust"
update public.ust_element_mapping
set organization_column_name = '<REPLACE_WITH_CORRECT_IDENTIFIER>'
where ust_element_mapping_id = 2980;


2956: ust_facility.owner_type_id has 1 unmapped value(s) in tn_ust.v_owner_types.owner_type

select * 
from v_ust_element_mapping 
where ust_element_mapping_id = 2956

select distinct owner_type 
from tn_ust.v_owner_types 
where owner_type not in 
	(select organization_value from v_ust_element_mapping 
	where ust_element_mapping_id = 2956)
order by 1;

insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2956, 'Duplicate Facility', '', null);

select  * from tn_ust.erg_unregulated_facilities 


select * from ust_element_value_mapping;


alter table ust_element_value_mapping add mapping_action varchar(30) not null default 'MAP';
alter table ust_element_value_mapping alter column epa_value drop not null;
update public.ust_element_value_mapping
set mapping_action = 'INTENTIONALLY_NULL'
where mapping_action = 'MAP'
  and epa_value is null;
update public.ust_element_value_mapping
set mapping_action = 'EXCLUDE',
    exclude_from_query = 'Y'
where ust_element_value_mapping_id = 3350;
alter table ust_element_value_mapping add constraint ust_element_value_mapping_chk_map check (
    (mapping_action = 'MAP' and nullif(trim(epa_value), '') is not null)
    or
    (mapping_action in ('EXCLUDE', 'INTENTIONALLY_NULL') and epa_value is null)
);



alter table release_element_value_mapping add mapping_action varchar(30) not null default 'MAP';
alter table release_element_value_mapping alter column epa_value drop not null;
update public.release_element_value_mapping
set mapping_action = 'INTENTIONALLY_NULL'
where mapping_action = 'MAP'
  and epa_value is null;

select release_element_value_mapping_id,
       release_element_mapping_id,
       organization_value,
       epa_value,
       mapping_action,
       programmer_comments
from public.release_element_value_mapping
where mapping_action = 'INTENTIONALLY_NULL'
order by release_element_value_mapping_id;

alter table release_element_value_mapping add constraint release_element_value_mapping_chk_map check (
    (mapping_action = 'MAP' and nullif(trim(epa_value), '') is not null)
    or
    (mapping_action in ('EXCLUDE', 'INTENTIONALLY_NULL') and epa_value is null)
);



