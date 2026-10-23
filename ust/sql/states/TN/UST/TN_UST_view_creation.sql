----------------------------------------------------------------------------------------------------------

-- WARNINGS
-- Generated SQL failed validation for ust_facility: column reference "facility_state" is ambiguous
LINE 11:  facility_state as facility_state,
          ^


create or replace view tn_ust.v_ust_facility as
select distinct
    a."facility_id"::character varying(50) as facility_id,
    a."facility_name"::character varying(100) as facility_name,
    owner_type_id as owner_type_id,
    facility_type_id as facility_type1,
    a."facility_address1"::character varying(100) as facility_address1,
    a."facility_address2"::character varying(100) as facility_address2,
    a."facility_city"::character varying(100) as facility_city,
    a."facility_zip_code"::character varying(10) as facility_zip_code,
    facility_state as facility_state,
    4::integer as facility_epa_region,
    a."facility_latitude"::double precision as facility_latitude,
    a."facility_longitude"::double precision as facility_longitude,
    c."OWNER_NAME"::character varying(100) as facility_owner_company_name,
    -- AUTO-GENERATED SOURCE: d."Facilityid"::character varying(7) as ust_reported_release
    case when "Facilityid" is not null then 'Yes' end as ust_reported_release,
    d."release_id"::character varying(40) as associated_ust_release_id
from tn_ust."v_facilities" a
    left join tn_ust."v_owner_types" b on a."facility_id"::character varying = b."facility_id"::character varying 
    left join tn_ust."tn_facilities_merged" c on a."facility_id"::character varying = c."FACILITY_ID_UST"::character varying 
    left join tn_ust."tn_environmental_sites" d on a."facility_id"::character varying = d."Facilityid"::character varying 
    left join tn_ust.v_facility_type_xwalk e on c."FACILITY_TYPE" = e.organization_value
    left join tn_ust.v_owner_type_xwalk f on b."owner_type" = f.organization_value
    left join tn_ust.v_state_xwalk g on a."facility_state" = g.organization_value
where not exists
    (select 1 from tn_ust.erg_unregulated_facilities unreg
    where a."facility_id"::character varying = unreg.facility_id)
and coalesce(e.exclude_from_query, 'N') <> 'Y'
and coalesce(f.exclude_from_query, 'N') <> 'Y'
and coalesce(g.exclude_from_query, 'N') <> 'Y'

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
----------------------------------------------------------------------------------------------------------

-- WARNINGS
-- Generated SQL failed validation for ust_tank: invalid input syntax for type integer: "compartment_count"
LINE 17:  case when 'compartment_count' > 1 then 'Yes' else 'No' end ...
                    ^


create or replace view tn_ust.v_ust_tank as
select distinct
    a."Facility Id Ust"::character varying(50) as facility_id,
    a."Tank Id"::integer as tank_id,
    a."Tank Number"::character varying(50) as tank_name,
    tank_status_id as tank_status_id,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case
    when a."Regulated Status" = 'Regulated' then 'Yes' end as federally_regulated,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case
    when a."Emergency Generator" = 'a."Emergency Generator"' then 'Yes' when a."Emergency Generator" = 'Not a."Emergency Generator"' then 'No' else null
    end as emergency_generator,
    a."Date Tank Closed"::date as tank_closure_date,
    a."Date Tank Installed"::date as tank_installation_date,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when 'compartment_count' > 1 then 'Yes' else 'No' end as compartmentalized_ust,
    c."number_of_compartments"::integer as number_of_compartments,
    tank_material_description_id as tank_material_description_id,
    -- AUTO-GENERATED SOURCE: a."Tank Construction"::character varying(7) as tank_corrosion_protection_sacrificial_anode
    case when "Tank Construction" = 'Cathodically Protected Steel-StiP3' then 'Yes' end as tank_corrosion_protection_sacrificial_anode,
    tank_secondary_containment_id as tank_secondary_containment_id
from tn_ust."tn_compartments_merged" a
    left join tn_ust."v_tank_status" b on a."Facility Id Ust"::character varying = b."Facility Id Ust"::character varying and a."Tank Id"::integer = b."Tank Id"::integer 
    left join tn_ust."v_tank_compartments" c on a."Facility Id Ust"::character varying = c."Facility Id Ust"::character varying and a."Tank Id"::integer = c."Tank Id"::integer 
    left join tn_ust.v_tank_material_description_xwalk d on a."Tank Construction" = d.organization_value
    left join tn_ust.v_tank_secondary_containment_xwalk e on a."Category Of Construction" = e.organization_value
    left join tn_ust.v_tank_status_xwalk f on b."Status" = f.organization_value
where not exists
    (select 1 from tn_ust.erg_unregulated_facilities unreg_fac
    where a."Facility Id Ust"::character varying = unreg_fac.facility_id)
and not exists
    (select 1 from tn_ust.erg_unregulated_tanks unreg_tank
    where a."Facility Id Ust"::character varying = unreg_tank.facility_id and a."Tank Id"::integer = unreg_tank.tank_id)
and exists
    (select 1 from tn_ust.v_ust_facility parent
    where parent.facility_id = a."Facility Id Ust"::character varying)
and coalesce(d.exclude_from_query, 'N') <> 'Y'
and coalesce(e.exclude_from_query, 'N') <> 'Y'
and coalesce(f.exclude_from_query, 'N') <> 'Y'

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
----------------------------------------------------------------------------------------------------------

create or replace view tn_ust.v_ust_tank_substance as
select distinct
    a."facility_id"::character varying(50) as facility_id,
    a."tank_id"::integer as tank_id,
    substance_id as substance_id
from tn_ust."v_tank_substance" a
    left join tn_ust.v_substance_xwalk b on a."Product" = b.organization_value
where substance_id is not null and not exists
    (select 1 from tn_ust.erg_unregulated_facilities unreg_fac
    where a."facility_id"::character varying = unreg_fac.facility_id)
and not exists
    (select 1 from tn_ust.erg_unregulated_tanks unreg_tank
    where a."facility_id"::character varying = unreg_tank.facility_id and a."tank_id"::integer = unreg_tank.tank_id)
and exists
    (select 1 from tn_ust.v_ust_facility parent
    where parent.facility_id = a."facility_id"::character varying)
and coalesce(b.exclude_from_query, 'N') <> 'Y'

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
----------------------------------------------------------------------------------------------------------

create or replace view tn_ust.v_ust_compartment as
select distinct
    a."Facility Id Ust"::character varying(50) as facility_id,
    a."Tank Id"::integer as tank_id,
    a."Compartment Id"::integer as compartment_id,
    a."Compartment Letter"::character varying(50) as compartment_name,
    compartment_status_id as compartment_status_id,
    a."Compartment Capacity"::integer as compartment_capacity_gallons,
    -- AUTO-GENERATED SOURCE: a."Overfill Prevention"::character varying(7) as overfill_prevention_ball_float_valve
    case when "Overfill Prevention" = 'Ball Float Valves' then 'Yes' end as overfill_prevention_ball_float_valve,
    -- AUTO-GENERATED SOURCE: a."Overfill Prevention"::character varying(7) as overfill_prevention_flow_shutoff_device
    case when "Overfill Prevention" = 'Automatic Shut Off Device' then 'Yes' end as overfill_prevention_flow_shutoff_device,
    -- AUTO-GENERATED SOURCE: a."Overfill Prevention"::character varying(7) as overfill_prevention_high_level_alarm
    case when "Overfill Prevention" = 'Overfill Alarm' then 'Yes' end as overfill_prevention_high_level_alarm,
    -- AUTO-GENERATED SOURCE: a."Overfill Prevention"::character varying(7) as overfill_prevention_other
    case when "Overfill Prevention" = 'Vent Whistle' then 'Yes' end as overfill_prevention_other,
    -- AUTO-GENERATED SOURCE: a."Overfill Prevention"::character varying(7) as overfill_prevention_unknown
    case when "Overfill Prevention" = 'unknown' then 'Yes' end as overfill_prevention_unknown,
    c."overfill_prevention_not_required"::character varying(7) as overfill_prevention_not_required,
    -- AUTO-GENERATED SOURCE: d."spill_bucket_installed"::character varying(3) as spill_bucket_installed
    case when "spill_bucket_installed" = 'Yes' then 'Yes' end as spill_bucket_installed,
    e."spill_prevention_not_required"::character varying(3) as spill_prevention_not_required,
    spill_bucket_wall_type_id as spill_bucket_wall_type_id,
    -- AUTO-GENERATED SOURCE: a."Compartment Release Detection"::character varying(7) as tank_interstitial_monitoring
    case when "Compartment Release Detection" = 'Interstitial Monitoring' then 'Yes' end as tank_interstitial_monitoring,
    -- AUTO-GENERATED SOURCE: a."Compartment Release Detection"::character varying(7) as tank_automatic_tank_gauging_release_detection
    case when "Compartment Release Detection" = 'Automatic Tank Gauging' then 'Yes' end as tank_automatic_tank_gauging_release_detection,
    -- AUTO-GENERATED SOURCE: a."Compartment Release Detection"::character varying(7) as automatic_tank_gauging_continuous_leak_detection
    case when "Compartment Release Detection" = 'Continuous In Tank Leak Detection System - CITLDS' then 'Yes' end as automatic_tank_gauging_continuous_leak_detection,
    -- AUTO-GENERATED SOURCE: a."Compartment Release Detection"::character varying(7) as tank_manual_tank_gauging
    case when "Compartment Release Detection" like 'Manual%' then 'Yes' end as tank_manual_tank_gauging,
    -- AUTO-GENERATED SOURCE: a."Compartment Release Detection"::character varying(7) as tank_statistical_inventory_reconciliation
    case when "Compartment Release Detection" = 'Statistical Inventory Reconciliation (SIR)' then 'Yes' end as tank_statistical_inventory_reconciliation,
    -- AUTO-GENERATED SOURCE: a."Compartment Release Detection"::character varying(7) as tank_tightness_testing
    case when "Compartment Release Detection" = 'Manual Tank Gauging and Tank Tightness Testing' then 'Yes' end as tank_tightness_testing,
    -- AUTO-GENERATED SOURCE: a."Compartment Release Detection"::character varying(7) as tank_inventory_control
    case when "Compartment Release Detection" = 'Inventory Control' then 'Yes' end as tank_inventory_control,
    -- AUTO-GENERATED SOURCE: a."Compartment Release Detection"::character varying(7) as tank_groundwater_monitoring
    case when "Compartment Release Detection" = 'Ground Water Monitoring' then 'Yes' end as tank_groundwater_monitoring
from tn_ust."tn_compartments_merged" a
    left join tn_ust."v_compartment_status" b on a."Facility Id Ust"::character varying = b."Facility Id Ust"::character varying and a."Tank Id"::integer = b."Tank Id"::integer and a."Compartment Id"::integer = b."Compartment Id"::integer 
    left join tn_ust."v_overfill_prevention_not_required" c on a."Facility Id Ust"::character varying = c."Facility Id Ust"::character varying and a."Tank Id"::integer = c."Tank Id"::integer and a."Compartment Id"::integer = c."Compartment Id"::integer 
    left join tn_ust."v_spill_bucket_installed" d on a."Facility Id Ust"::character varying = d."Facility Id Ust"::character varying and a."Tank Id"::integer = d."Tank Id"::integer and a."Compartment Id"::integer = d."Compartment Id"::integer 
    left join tn_ust."v_spill_prevention_not_required" e on a."Facility Id Ust"::character varying = e."Facility Id Ust"::character varying and a."Tank Id"::integer = e."Tank Id"::integer and a."Compartment Id"::integer = e."Compartment Id"::integer 
    left join tn_ust.v_compartment_status_xwalk f on b."Status" = f.organization_value
    left join tn_ust.v_spill_bucket_wall_type_xwalk g on a."Spill Prevention" = g.organization_value
where not exists
    (select 1 from tn_ust.erg_unregulated_facilities unreg_fac
    where a."Facility Id Ust"::character varying = unreg_fac.facility_id)
and not exists
    (select 1 from tn_ust.erg_unregulated_tanks unreg_tank
    where a."Facility Id Ust"::character varying = unreg_tank.facility_id and a."Tank Id"::integer = unreg_tank.tank_id)
and exists
    (select 1 from tn_ust.v_ust_facility parent
    where parent.facility_id = a."Facility Id Ust"::character varying)
and coalesce(f.exclude_from_query, 'N') <> 'Y'
and coalesce(g.exclude_from_query, 'N') <> 'Y'

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
----------------------------------------------------------------------------------------------------------

create or replace view tn_ust.v_ust_piping as
select distinct
    a."Facility Id Ust"::character varying(50) as facility_id,
    a."Tank Id"::integer as tank_id,
    a."Compartment Id"::integer as compartment_id,
    c."piping_id"::character varying(50) as piping_id,
    piping_style_id as piping_style_id,
    -- AUTO-GENERATED SOURCE: a."Piping Material"::character varying(3) as piping_material_frp
    case when "Piping Material" in ('Rigid Plastic - (NUPI - Western Fiberglass -UPP - Brugg)', 'Fiberglass FRP - (Ameron Dualoy - Smith Fibercast))') then 'Yes' end as piping_material_frp,
    -- AUTO-GENERATED SOURCE: a."Piping Material"::character varying(3) as piping_material_steel
    case when "Piping Material" = 'Steel' then 'Yes' end as piping_material_steel,
    -- AUTO-GENERATED SOURCE: a."Piping Material"::character varying(3) as piping_material_copper
    case when "Piping Material" = 'Copper' then 'Yes' end as piping_material_copper,
    -- AUTO-GENERATED SOURCE: a."Piping Material"::character varying(3) as piping_material_flex
    case when "Piping Material" = 'Flexible Plastic (APT - OPW Pieces - Environ - etc)' then 'Yes' end as piping_material_flex,
    -- AUTO-GENERATED SOURCE: a."Piping Material"::character varying(3) as piping_material_no_piping
    case when "Piping Material" = 'No Piping' then 'Yes' end as piping_material_no_piping,
    b."piping_line_leak_detector"::character varying(7) as piping_line_leak_detector,
    -- AUTO-GENERATED SOURCE: a."Leak Detection Periodic"::character varying(7) as piping_line_test_annual
    case when "Leak Detection Periodic" in ('ELLD .1 Annual','ELLD .2 Monthly','Annual LTT') then 'Yes' end as piping_line_test_annual,
    -- AUTO-GENERATED SOURCE: a."Leak Detection Periodic"::character varying(7) as piping_line_test3yr
    case when "Leak Detection Periodic" = '3 Year LTT' then 'Yes' end as piping_line_test3yr,
    -- AUTO-GENERATED SOURCE: a."Leak Detection Periodic"::character varying(7) as piping_groundwater_monitoring
    case when "Leak Detection Periodic" = 'Groundwater Monitoring' then 'Yes' end as piping_groundwater_monitoring,
    -- AUTO-GENERATED SOURCE: a."Leak Detection Periodic"::character varying(7) as piping_vapor_monitoring
    case when "Leak Detection Periodic" = 'Vapor Monitoring' then 'Yes' end as piping_vapor_monitoring,
    -- AUTO-GENERATED SOURCE: a."Leak Detection Periodic"::character varying(7) as piping_interstitial_monitoring
    case when "Leak Detection Periodic" = 'Interstitial Monitoring for Piping' then 'Yes' end as piping_interstitial_monitoring,
    -- AUTO-GENERATED SOURCE: a."Leak Detection Periodic"::character varying(7) as piping_statistical_inventory_reconciliation
    case when "Leak Detection Periodic" = 'Statistical Inventory Reconciliation' then 'Yes' end as piping_statistical_inventory_reconciliation,
    -- AUTO-GENERATED SOURCE: a."Leak Detection Periodic"::character varying(7) as piping_release_detection_other
    case when "Leak Detection Periodic" = 'Other or No Method of Release Detection' then 'Yes' end as piping_release_detection_other,
    piping_wall_type_id as piping_wall_type_id
from tn_ust."tn_compartments_merged" a
    left join tn_ust."v_piping_line_leak_detector" b on a."Facility Id Ust"::character varying = b."Facility Id Ust"::character varying and a."Tank Id"::integer = b."Tank Id"::integer and a."Compartment Id"::integer = b."Compartment Id"::integer 
    left join tn_ust."erg_piping_id" c on a."Facility Id Ust"::character varying = c."facility_id"::character varying and a."Tank Id"::integer = c."tank_id"::integer and a."Compartment Id"::integer = c."compartment_id"::integer 
    left join tn_ust.v_piping_style_xwalk d on a."Piping Type" = d.organization_value
    left join tn_ust.v_piping_wall_type_xwalk e on a."Pipe Construction Type" = e.organization_value
where not exists
    (select 1 from tn_ust.erg_unregulated_facilities unreg_fac
    where a."Facility Id Ust"::character varying = unreg_fac.facility_id)
and not exists
    (select 1 from tn_ust.erg_unregulated_tanks unreg_tank
    where a."Facility Id Ust"::character varying = unreg_tank.facility_id and a."Tank Id"::integer = unreg_tank.tank_id)
and exists
    (select 1 from tn_ust.v_ust_facility parent
    where parent.facility_id = a."Facility Id Ust"::character varying)
and coalesce(d.exclude_from_query, 'N') <> 'Y'
and coalesce(e.exclude_from_query, 'N') <> 'Y'

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
