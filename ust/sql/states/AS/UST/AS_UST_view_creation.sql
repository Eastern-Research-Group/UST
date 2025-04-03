----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW as_ust.v_ust_facility
 AS
 SELECT DISTINCT a."FacilityID"::character varying(50) AS facility_id,
    a."FacilityName"::character varying(100) AS facility_name,
    d.owner_type_id,
    c.facility_type_id AS facility_type1,
    a."FacilityAddress1"::character varying(100) AS facility_address1,
    a."FacilityCity"::character varying(100) AS facility_city,
    a."FacilityCounty"::character varying(100) AS facility_county,
    a."FacilityZipCode"::character varying(10) AS facility_zip_code,
    e.facility_state,
    replace(a."FacilityEPARegion", 'REGION '::text, ''::text)::integer AS facility_epa_region,
    (substr(a."FacilityLatitude", 1,8)::double precision)*(-1) AS facility_latitude,
    (substr(a."FacilityLongitude", 1,9)::double precision)*(-1) AS facility_longitude,
    b.coordinate_source_id,
    a."FacilityOwnerCompanyName"::character varying(100) AS facility_owner_company_name,
    a."FacilityOperatorCompanyName"::character varying(100) AS facility_operator_company_name
   FROM as_ust."Facility" a
     LEFT JOIN as_ust.v_coordinate_source_xwalk b ON a."FacilityCoordinateSource" = b.organization_value::text
     LEFT JOIN as_ust.v_facility_type_xwalk c ON a."FacilityType1" = c.organization_value::text
     LEFT JOIN as_ust.v_owner_type_xwalk d ON a."OwnerType" = d.organization_value::text
     LEFT JOIN as_ust.v_state_xwalk e ON a."FacilityState" = e.organization_value::text;

 
----------------------------------------------------------------------------------------------------------
create view as_ust.v_ust_tank as
select distinct f.facility_id,
    "tank_id"::integer as tank_id, 
    "tank_name"::character varying(50) as tank_name, 
    tank_location_id as tank_location_id, 
    tank_status_id as tank_status_id, 
    "federally_regulated"::character varying(7) as federally_regulated, 
    "tank_installation_date"::date as tank_installation_date, 
    tank_material_description_id as tank_material_description_id, 
    tank_secondary_containment_id as tank_secondary_containment_id 
from as_ust."erg_tank" a
    left join as_ust.v_tank_location_xwalk b on a."tank_location" = b.organization_value
    left join as_ust.v_tank_material_description_xwalk c on a."tank_material_description" = c.organization_value
    left join as_ust.v_tank_secondary_containment_xwalk d on a."tank_secondary_containment" = d.organization_value
    left join as_ust.v_tank_status_xwalk e on a."tank_status" = e.organization_value
    left join as_ust.v_ust_facility f ON a.facility_id::text = f.facility_id::text;
   


----------------------------------------------------------------------------------------------------------
create view as_ust.v_ust_compartment as
select distinct c.facility_id,"tank_id"::integer as tank_id, 
    "compartment_id"::integer as compartment_id, 
    compartment_status_id as compartment_status_id, 
    "overfill_prevention_high_level_alarm"::character varying(7) as overfill_prevention_high_level_alarm, 
    "spill_bucket_installed"::character varying(3) as spill_bucket_installed, 
    "concrete_berm_installed"::character varying(3) as concrete_berm_installed, 
    "tank_automatic_tank_gauging_release_detection"::character varying(7) as tank_automatic_tank_gauging_release_detection, 
    "automatic_tank_gauging_continuous_leak_detection"::character varying(7) as automatic_tank_gauging_continuous_leak_detection, 
    "tank_manual_tank_gauging"::character varying(7) as tank_manual_tank_gauging, 
    "tank_tightness_testing"::character varying(7) as tank_tightness_testing, 
    "tank_inventory_control"::character varying(7) as tank_inventory_control 
from as_ust."erg_compartment" a
    left join as_ust.v_compartment_status_xwalk b on a."compartment_status" = b.organization_value
    left join as_ust.v_ust_facility c ON a.facility_id::text = c.facility_id::text;
     

----------------------------------------------------------------------------------------------------------


create view as_ust.v_ust_piping as
select distinct f.facility_id,a.tank_id::integer as tank_id,a.compartment_id,
    "piping_id"::character varying(50) as piping_id, 
    piping_style_id as piping_style_id, 
    "safesuction"::character varying(7) as safe_suction, 
    "piping_material_frp"::character varying(3) as piping_material_frp, 
    "piping_material_steel"::character varying(3) as piping_material_steel, 
    "piping_material_flex"::character varying(3) as piping_material_flex, 
    "piping_flex_connector"::character varying(7) as piping_flex_connector, 
    "piping_line_leak_detector"::character varying(7) as piping_line_leak_detector, 
    "piping_line_test_annual"::character varying(7) as piping_line_test_annual, 
    "piping_line_test3yr"::character varying(7) as piping_line_test3yr, 
    "piping_release_detection_other"::character varying(7) as piping_release_detection_other, 
    "pipe_tank_topsump"::character varying(7) as pipe_tank_top_sump, 
    pipe_tank_top_sump_wall_type_id as pipe_tank_top_sump_wall_type_id, 
    piping_wall_type_id as piping_wall_type_id 
from as_ust."erg_piping" a
    left join as_ust.v_pipe_tank_top_sump_wall_type_xwalk b on a."pipe_tank_topsump_walltype" = b.organization_value
    left join as_ust.v_piping_style_xwalk c on a."piping_style" = c.organization_value
    left join as_ust.v_piping_wall_type_xwalk d on a."piping_wall_type" = d.organization_value
    left join as_ust.v_ust_facility f on a.facility_id=f.facility_id;

----------------------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW as_ust.v_ust_facility_dispenser
 AS
 SELECT DISTINCT  b.facility_id,
    a.dispenser_id::character varying(50) AS dispenser_id,
    a.dispenser_udc
   FROM as_ust.erg_facility_dispenser a
   LEFT Join as_ust.v_ust_facility b on a.facility_id=b.facility_id;
  

  create view as_ust.v_ust_tank_substance as
select distinct  a.facility_id,  a.tank_id::integer AS tank_id, substance_id as substance_id 
from as_ust."erg_tanksubstance" a
    left join as_ust.v_substance_xwalk b on a."tank_substance" = b.organization_value;
