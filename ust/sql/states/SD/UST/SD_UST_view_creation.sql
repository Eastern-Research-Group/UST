----------------------------------------------------------------------------------------------------------

create or replace view sd_ust.v_ust_facility as
select distinct
    "FacilityNumber"::character varying(50) as facility_id, 
    "FacilityName"::character varying(100) as facility_name, 
    "FacilityAddress1Text"::character varying(100) as facility_address1, 
    "FacilityAddress2Text"::character varying(100) as facility_address2, 
    "FacilityCity"::character varying(100) as facility_city, 
    "FacilityCounty"::character varying(100) as facility_county, 
    "FacilityZipCode"::character varying(10) as facility_zip_code, 
    "FacilityLatitudeValue"::double precision as facility_latitude, 
    "FacilityLongitudeValue"::double precision as facility_longitude, 
    coordinate_source_id as coordinate_source_id, 
    "OwnerName"::character varying(100) as facility_owner_company_name 
from sd_ust."tanks" a
    left join sd_ust.v_coordinate_source_xwalk b on a."FacilityMethodDescription" = b.organization_value
where not exists
    (select 1 from sd_ust.erg_unregulated_facilities unreg
    where a."FacilityNumber":: varchar(50) = unreg.facility_id )

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
----------------------------------------------------------------------------------------------------------

create or replace view sd_ust.v_ust_tank as
select distinct
    "TankNumber"::integer as tank_id, 
    "TankNumber"::character varying(50) as tank_name, 
      !!! tank_status_id as tank_status_id,   -- COALESCE(ts.tank_status_id, 8
      !!! "TankRemovedYear"::date as tank_closure_date,   -- WHEN x."TankRemovedYear" = ANY (ARRAY[04/10/1991::text, 11/15/1989::text]) THEN to_date(x."TankRemovedYear", mm/dd/yyyy::text)  --             ELSE to_date(x."TankRemovedYear"::character varying::text, yyyy::text
      !!! "TankInstalledYear"::date as tank_installation_date,   -- WHEN x."TankInstalledYear" = 1899::double precision THEN NULL::date  --             ELSE to_date(x."TankInstalledYear"::character varying::text, yyyy::text
      !!! "TankCompartmentNumber"::character varying(7) as compartmentalized_ust,   -- WHEN x."TankCompartmentNumber" > 1::double precision THEN Yes::text  --             ELSE No::tex
      !!! "TankCompartmentNumber"::integer as number_of_compartments,   -- sd_ust.getmaxcompartment(x."FacilityNumber"::character varying, x."TankNumber"
    tank_material_description_id as tank_material_description_id, 
      !!! "TankConstructionName"::character varying(7) as tank_corrosion_protection_sacrificial_anode,   -- WHEN x."TankConstructionName" = ANY (ARRAY[DW/STIP3::text, DW/STIP3/Compart::text, STIP3::text, STIP3/Compart::text]) THEN Yes::text  --             ELSE NULL::tex
      !!! "TankConstructionName"::character varying(7) as tank_corrosion_protection_impressed_current,   -- WHEN x."TankConstructionName" = ANY (ARRAY[Lined w/ Impressed::text, Steel/Impressed::text]) THEN Yes::text  --             ELSE NULL::tex
      !!! "TankConstructionName"::character varying(7) as tank_corrosion_protection_interior_lining,   -- WHEN x."TankConstructionName" = ANY (ARRAY[Lined Interior::text, Lined w/ Impressed::text, Painted Steel w/ Lining::text]) THEN Yes::text  --             ELSE NULL::tex
    tank_secondary_containment_id as tank_secondary_containment_id 
from sd_ust."tanks" a
    left join sd_ust.v_tank_material_description_xwalk b on a."TankConstructionName" = b.organization_value
    left join sd_ust.v_tank_secondary_containment_xwalk c on a."TankConstructionName" = c.organization_value
    left join sd_ust.v_tank_status_xwalk d on a."StatusName" = d.organization_value
where not exists
    (select 1 from sd_ust.erg_unregulated_tanks unreg
    where a."FacilityNumber":: varchar(50) = unreg.facility_id and a."TankNumber"::int = unreg.tank_id)

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
----------------------------------------------------------------------------------------------------------

create or replace view sd_ust.v_ust_tank_substance as
select distinct
    substance_id as substance_id 
from sd_ust."tanks" a
    left join sd_ust.v_substance_xwalk b on a."TankProduct" = b.organization_value
where substance_id is not null and not exists
    (select 1 from sd_ust.erg_unregulated_tanks unreg
    where a."FacilityNumber":: varchar(50) = unreg.facility_id and a."TankNumber"::int = unreg.tank_id)

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
----------------------------------------------------------------------------------------------------------

create or replace view sd_ust.v_ust_compartment as
select distinct
    "compartment_id"::integer as compartment_id, 
    "TankCompartmentNumber"::character varying(50) as compartment_name, 
    compartment_status_id as compartment_status_id, 
    "TankCapacityAmount"::integer as compartment_capacity_gallons, 
      !!! "TankOverfillProtection"::character varying(7) as overfill_prevention_ball_float_valve,   -- WHEN Ball Float Valves::text THEN Yes::text  --             ELSE NULL::tex
      !!! "TankOverfillProtection"::character varying(7) as overfill_prevention_flow_shutoff_device,   -- where = Automatic Shutoff Device
      !!! "TankOverfillProtection"::character varying(7) as overfill_prevention_high_level_alarm,   -- WHEN Overfill Alarm::text THEN Yes::text  --             ELSE NULL::tex
      !!! "TankOverfillProtection"::character varying(7) as overfill_prevention_other,   -- WHEN Other::text THEN Yes::text  --             ELSE NULL::tex
      !!! "TankSpillProtection"::character varying(3) as spill_bucket_installed,   -- WHEN Spill Bucket::text THEN Yes::text  --             ELSE NULL::tex
      !!! "TankReleaseDetection"::character varying(7) as tank_interstitial_monitoring,   -- WHEN x."TankReleaseDetection" = ANY (ARRAY[Secondary Containment::text, Double Walled::text, Interstitial Monitoring::text, Concrete Vault::text]) THEN Yes::text  --             ELSE NULL::tex
      !!! "TankReleaseDetection"::character varying(7) as tank_automatic_tank_gauging_release_detection,   -- WHEN x."TankReleaseDetection" = ANY (ARRAY[In-Tank Monitor::text, Automatic Tank Gauging::text]) THEN Yes::text  --             ELSE NULL::tex
      !!! "TankReleaseDetection"::character varying(7) as tank_manual_tank_gauging,   -- WHEN Manual Gauging::text THEN Yes::text  --             ELSE NULL::tex
      !!! "TankReleaseDetection"::character varying(7) as tank_statistical_inventory_reconciliation,   -- WHEN S.I.R.::text THEN Yes::text  --             ELSE NULL::tex
      !!! "TankReleaseDetection"::character varying(7) as tank_tightness_testing,   -- WHEN Tightness Testing::text THEN Yes::text  --             ELSE NULL::tex
      !!! "TankReleaseDetection"::character varying(7) as tank_inventory_control,   -- WHEN Inventory Control::text THEN Yes::text  --             ELSE NULL::tex
      !!! "TankReleaseDetection"::character varying(7) as tank_groundwater_monitoring,   -- WHEN Groundwater Monitoring::text THEN Yes::text  --             ELSE NULL::tex
      !!! "TankReleaseDetection"::character varying(7) as tank_vapor_monitoring,   -- WHEN Vapor Monitoring::text THEN Yes::text  --             ELSE NULL::tex
      !!! "TankReleaseDetection"::character varying(7) as tank_other_release_detection   -- WHEN Other::text THEN Yes::text  --             ELSE NULL::tex
from sd_ust."tanks" a
    left join sd_ust.v_compartment_status_xwalk c on a."StatusName" = c.organization_value
where not exists
    (select 1 from sd_ust.erg_unregulated_tanks unreg
    where a."FacilityNumber":: varchar(50) = unreg.facility_id and a."TankNumber"::int = unreg.tank_id)

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
----------------------------------------------------------------------------------------------------------

create or replace view sd_ust.v_ust_piping as
select distinct
    "piping_id"::character varying(50) as piping_id, 
    piping_style_id as piping_style_id, 
      !!! "TankPipingType"::character varying(7) as safe_suction,   -- WHEN Safe Suction::text THEN Yes::text  --             ELSE NULL::tex
      !!! "TankPipingType"::character varying(7) as american_suction,   -- WHEN Suction::text THEN Yes::text  --             ELSE NULL::tex
      !!! "TankPipingType"::character varying(7) as high_pressure_or_bulk_piping,   -- WHEN Pressure::text THEN Yes::text  --             ELSE NULL::tex
      !!! "TankPipingMaterial"::character varying(3) as piping_material_frp,   -- WHEN x."TankPipingMaterial" ~~ %Fiberglass%::text THEN Yes::text  --             ELSE NULL::tex
      !!! "TankPipingMaterial"::character varying(3) as piping_material_gal_steel,   -- WHEN Galvanized Steel::text THEN Yes::text  --             ELSE NULL::tex
      !!! "TankPipingMaterial"::character varying(3) as piping_material_stainless_steel,   -- WHEN Stainless Steel::text THEN Yes::text  --             ELSE NULL::tex
      !!! "TankPipingMaterial"::character varying(3) as piping_material_steel,   -- WHEN x."TankPipingMaterial" = ANY (ARRAY[Black Steel::text, Cath. Protection::text, Cath. Steel::text, Coated Steel::text, Steel::text, Steel/Aboveground::text, Steel/Cont::text]) THEN Yes::text  --             ELSE NULL::tex
      !!! "TankPipingMaterial"::character varying(3) as piping_material_copper,   -- WHEN Copper::text THEN Yes::text  --             ELSE NULL::tex
      !!! "TankPipingMaterial"::character varying(3) as piping_material_flex,   -- WHEN x."TankPipingMaterial" = ANY (ARRAY[DW Ameron::text, DW APT::text, DW Environ::text, DW Flex::text, DW MarinaFlex::text, DW OPW::text, DW Poly::text, SW Ameron::text, SW APT::text, SW Flex::text, Total Containment::text]) THEN Yes::text  --             ELSE NULL::tex
      !!! "TankPipingMaterial"::character varying(3) as piping_material_no_piping,   -- WHEN x."TankPipingMaterial" = ANY (ARRAY[None::text, Not Applicable::text]) THEN Yes::text  --             ELSE NULL::tex
      !!! "TankPipingMaterial"::character varying(3) as piping_material_unknown,   -- WHEN Unknown::text THEN Yes::text  --             ELSE NULL::tex
      !!! "TankPipingMaterial"::character varying(7) as piping_corrosion_protection_sacrificial_anode,   -- WHEN x."TankPipingMaterial" = ANY (ARRAY[Cath. Protection::text, Cath. Steel::text]) THEN Yes::text  --             ELSE NULL::tex
      !!! "TankPipingReleaseDetection"::character varying(7) as piping_line_leak_detector,   -- when 'Campo/Miller LLD', 'Electronic LLD','Incon LLD','Mechanical LLD','PPM 4000' then 'Yes'  else null
      !!! "TankPipingReleaseDetection"::character varying(7) as piping_line_test_annual,   -- when 'Tightness Testing' then 'Yes' else null en
      !!! "TankPipingReleaseDetection"::character varying(7) as piping_groundwater_monitoring,   -- WHEN Groundwater Monitoring::text THEN Yes::text  --             ELSE NULL::tex
      !!! "TankPipingReleaseDetection"::character varying(7) as piping_vapor_monitoring,   -- WHEN Vapor Monitoring::text THEN Yes::text  --             ELSE NULL::tex
      !!! "TankPipingReleaseDetection"::character varying(7) as piping_interstitial_monitoring,   -- when in 'Secondary Containment', 'Sump Sensor' then  'Yes' else null en
      !!! "TankPipingReleaseDetection"::character varying(7) as piping_statistical_inventory_reconciliation,   -- WHEN S.I.R.::text THEN Yes::text  --             ELSE NULL::tex
      !!! "TankPipingReleaseDetection"::character varying(7) as piping_release_detection_other,   -- when 'Double Walled' then 'Yes' else null en
    piping_wall_type_id as piping_wall_type_id, 
      !!! "TankPipingReleaseDetection"::character varying(7) as pipe_secondary_containment_other,   -- WHEN Secondary Containment::text THEN Yes::text  --             ELSE NULL::tex
      !!! "TankPipingReleaseDetection"::character varying(7) as pipe_secondary_containment_unknown,   -- where = Unknow
      !!! "TankPipingReleaseDetection"::character varying(4000) as piping_comment   -- WHEN x."TankPipingReleaseDetection" = ANY (ARRAY[None::text, Not Applicable::text, Unknown::text]) THEN EPA has no acceptable mapping to the State Release Detection values for this piping data.::text  --             ELSE NULL::tex
from sd_ust."tanks" a
    left join sd_ust.v_piping_style_xwalk c on a."TankPipingType" = c.organization_value
    left join sd_ust.v_piping_wall_type_xwalk d on a."TankPipingMaterial" = d.organization_value
where not exists
    (select 1 from sd_ust.erg_unregulated_tanks unreg
    where a."FacilityNumber":: varchar(50) = unreg.facility_id and a."TankNumber"::int = unreg.tank_id)

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
