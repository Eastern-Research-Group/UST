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
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when d."Facilityid" is not null then 'Yes' end as ust_reported_release,
    d."release_id"::character varying(40) as associated_ust_release_id
from tn_ust."v_facilities" a
    left join tn_ust."v_owner_types" b on nullif(trim(a."facility_id"::text), '') = nullif(trim(b."facility_id"::text), '') 
    left join tn_ust."tn_facilities" c on nullif(trim(a."facility_id"::text), '') = nullif(trim(c."FACILITY_ID_UST"::text), '') 
    left join tn_ust."tn_environmental_sites" d on nullif(trim(a."facility_id"::text), '') = nullif(trim(d."Facilityid"::text), '') 
    left join tn_ust.v_facility_type_xwalk e on c."FACILITY_TYPE" = e.organization_value
    left join tn_ust.v_owner_type_xwalk f on b."owner_type" = f.organization_value
    left join tn_ust.v_state_xwalk g on a."facility_state" = g.organization_value
where not exists
    (select 1 from tn_ust.erg_unregulated_facilities unreg
    where nullif(trim(a."facility_id"::text), '') = unreg.facility_id)
and coalesce(e.exclude_from_query, 'N') <> 'Y'
and coalesce(f.exclude_from_query, 'N') <> 'Y'
and coalesce(g.exclude_from_query, 'N') <> 'Y'

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
----------------------------------------------------------------------------------------------------------

-- WARNINGS
-- Overriding query_logic for ust_tank.federally_regulated with standardized recipe SQL.
-- Overriding query_logic for ust_tank.emergency_generator with standardized recipe SQL.
-- Overriding query_logic for ust_tank.compartmentalized_ust with standardized recipe SQL.

create or replace view tn_ust.v_ust_tank as
select distinct
    nullif(trim(a."Facility Id Ust"::text), '')::character varying(50) as facility_id,
    a."Tank Id"::integer as tank_id,
    a."Tank Number"::character varying(50) as tank_name,
    tank_status_id as tank_status_id,
    case when lower(nullif(trim(a."Regulated Status"::text), '')) in ('true', 't', 'yes', 'y', '1', '1.0') then 'Yes'::text when lower(nullif(trim(a."Regulated Status"::text), '')) in ('false', 'f', 'no', 'n', '0', '0.0') then 'No'::text else null::text end as federally_regulated,
    case when lower(nullif(trim(a."Emergency Generator"::text), '')) in ('true', 't', 'yes', 'y', '1', '1.0') then 'Yes'::text when lower(nullif(trim(a."Emergency Generator"::text), '')) in ('false', 'f', 'no', 'n', '0', '0.0') then 'No'::text else null::text end as emergency_generator,
    a."Date Tank Closed"::date as tank_closure_date,
    a."Date Tank Installed"::date as tank_installation_date,
    case when nullif(trim(c."compartmentalized_ust"::text), '') ~ '^[+-]?\d+(\.0+)?$' and (nullif(trim(c."compartmentalized_ust"::text), ''))::numeric > 1 then 'Yes'::text when nullif(trim(c."compartmentalized_ust"::text), '') ~ '^[+-]?\d+(\.0+)?$' then 'No'::text else null::text end as compartmentalized_ust,
    c."number_of_compartments"::integer as number_of_compartments,
    tank_material_description_id as tank_material_description_id,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when a."Tank Construction" = 'Cathodically Protected Steel-StiP3' then 'Yes' end as tank_corrosion_protection_sacrificial_anode,
    tank_secondary_containment_id as tank_secondary_containment_id
from tn_ust."v_tn_compartments" a
    left join tn_ust."v_tank_status" b on nullif(trim(a."Facility Id Ust"::text), '') = nullif(trim(b."Facility Id Ust"::text), '') and case when nullif(trim(a."Tank Id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."Tank Id"::text), '')::integer else null::integer end = case when nullif(trim(b."Tank Id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(b."Tank Id"::text), '')::integer else null::integer end 
    left join tn_ust."v_tank_compartments" c on nullif(trim(a."Facility Id Ust"::text), '') = nullif(trim(c."Facility Id Ust"::text), '') and case when nullif(trim(a."Tank Id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."Tank Id"::text), '')::integer else null::integer end = case when nullif(trim(c."Tank Id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(c."Tank Id"::text), '')::integer else null::integer end 
    left join tn_ust.v_tank_material_description_xwalk d on a."Tank Construction" = d.organization_value
    left join tn_ust.v_tank_secondary_containment_xwalk e on a."Category Of Construction" = e.organization_value
    left join tn_ust.v_tank_status_xwalk f on b."Status" = f.organization_value
where not exists
    (select 1 from tn_ust.erg_unregulated_facilities unreg_fac
    where nullif(trim(a."Facility Id Ust"::text), '') = unreg_fac.facility_id)
and not exists
    (select 1 from tn_ust.erg_unregulated_tanks unreg_tank
    where nullif(trim(a."Facility Id Ust"::text), '') = unreg_tank.facility_id and case when nullif(trim(a."Tank Id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."Tank Id"::text), '')::integer else null::integer end = unreg_tank.tank_id)
and exists
    (select 1 from tn_ust.v_ust_facility parent
    where parent.facility_id = nullif(trim(a."Facility Id Ust"::text), ''))
and coalesce(d.exclude_from_query, 'N') <> 'Y'
and coalesce(e.exclude_from_query, 'N') <> 'Y'
and coalesce(f.exclude_from_query, 'N') <> 'Y'

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
----------------------------------------------------------------------------------------------------------

create or replace view tn_ust.v_ust_tank_substance as
select distinct
    nullif(trim(a."facility_id"::text), '')::character varying(50) as facility_id,
    case when nullif(trim(a."tank_id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."tank_id"::text), '')::integer else null::integer end as tank_id,
    substance_id as substance_id
from tn_ust."v_tank_substance" a
    left join tn_ust.v_substance_xwalk b on a."Product" = b.organization_value
where substance_id is not null and not exists
    (select 1 from tn_ust.erg_unregulated_facilities unreg_fac
    where nullif(trim(a."facility_id"::text), '') = unreg_fac.facility_id)
and not exists
    (select 1 from tn_ust.erg_unregulated_tanks unreg_tank
    where nullif(trim(a."facility_id"::text), '') = unreg_tank.facility_id and case when nullif(trim(a."tank_id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."tank_id"::text), '')::integer else null::integer end = unreg_tank.tank_id)
and exists
    (select 1 from tn_ust.v_ust_facility parent
    where parent.facility_id = nullif(trim(a."facility_id"::text), ''))
and coalesce(b.exclude_from_query, 'N') <> 'Y'

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
----------------------------------------------------------------------------------------------------------

-- WARNINGS
-- Overriding query_logic for ust_compartment.spill_bucket_installed with standardized recipe SQL.
-- Overriding query_logic for ust_compartment.tank_automatic_tank_gauging_release_detection with standardized recipe SQL.
-- Overriding query_logic for ust_compartment.tank_manual_tank_gauging with standardized recipe SQL.
-- Overriding query_logic for ust_compartment.tank_statistical_inventory_reconciliation with standardized recipe SQL.
-- Overriding query_logic for ust_compartment.tank_tightness_testing with standardized recipe SQL.
-- Overriding query_logic for ust_compartment.tank_inventory_control with standardized recipe SQL.
-- Overriding query_logic for ust_compartment.tank_groundwater_monitoring with standardized recipe SQL.

create or replace view tn_ust.v_ust_compartment as
select distinct
    nullif(trim(a."Facility Id Ust"::text), '')::character varying(50) as facility_id,
    case when nullif(trim(a."Tank Id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."Tank Id"::text), '')::integer else null::integer end as tank_id,
    a."Compartment Id"::integer as compartment_id,
    a."Compartment Letter"::character varying(50) as compartment_name,
    compartment_status_id as compartment_status_id,
    a."Compartment Capacity"::integer as compartment_capacity_gallons,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when a."Overfill Prevention" = 'Ball Float Valves' then 'Yes' end as overfill_prevention_ball_float_valve,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when a."Overfill Prevention" = 'Automatic Shut Off Device' then 'Yes' end as overfill_prevention_flow_shutoff_device,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when a."Overfill Prevention" = 'Overfill Alarm' then 'Yes' end as overfill_prevention_high_level_alarm,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when a."Overfill Prevention" = 'Vent Whistle' then 'Yes' end as overfill_prevention_other,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when a."Overfill Prevention" = 'unknown' then 'Yes' end as overfill_prevention_unknown,
    c."overfill_prevention_not_required"::character varying(7) as overfill_prevention_not_required,
    case when lower(nullif(trim(d."spill_bucket_installed"::text), '')) in ('true', 't', 'yes', 'y', '1', '1.0') then 'Yes'::text when lower(nullif(trim(d."spill_bucket_installed"::text), '')) in ('false', 'f', 'no', 'n', '0', '0.0') then 'No'::text else null::text end as spill_bucket_installed,
    e."spill_prevention_not_required"::character varying(3) as spill_prevention_not_required,
    spill_bucket_wall_type_id as spill_bucket_wall_type_id,
    a."Compartment Release Detection"::character varying(7) as tank_interstitial_monitoring,
    case when lower(nullif(trim(a."Compartment Release Detection"::text), '')) in ('in-tank monitor', 'automatic tank gauging') then 'Yes'::text else null::text end as tank_automatic_tank_gauging_release_detection,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when a."Compartment Release Detection" = 'Continuous In Tank Leak Detection System - CITLDS' then 'Yes' end as automatic_tank_gauging_continuous_leak_detection,
    case when lower(nullif(trim(a."Compartment Release Detection"::text), '')) in ('manual gauging') then 'Yes'::text else null::text end as tank_manual_tank_gauging,
    case when lower(nullif(trim(a."Compartment Release Detection"::text), '')) in ('s.i.r.') then 'Yes'::text else null::text end as tank_statistical_inventory_reconciliation,
    case when lower(nullif(trim(a."Compartment Release Detection"::text), '')) in ('tightness testing', 'tanktightnesstesting') then 'Yes'::text else null::text end as tank_tightness_testing,
    case when lower(nullif(trim(a."Compartment Release Detection"::text), '')) in ('inventory control') then 'Yes'::text else null::text end as tank_inventory_control,
    case when lower(nullif(trim(a."Compartment Release Detection"::text), '')) in ('groundwater monitoring') then 'Yes'::text else null::text end as tank_groundwater_monitoring
from tn_ust."v_tn_compartments" a
    left join tn_ust."v_compartment_status" b on nullif(trim(a."Facility Id Ust"::text), '') = nullif(trim(b."Facility Id Ust"::text), '') and case when nullif(trim(a."Tank Id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."Tank Id"::text), '')::integer else null::integer end = case when nullif(trim(b."Tank Id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(b."Tank Id"::text), '')::integer else null::integer end and case when nullif(trim(a."Compartment Id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."Compartment Id"::text), '')::integer else null::integer end = case when nullif(trim(b."Compartment Id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(b."Compartment Id"::text), '')::integer else null::integer end 
    left join tn_ust."v_overfill_prevention_not_required" c on nullif(trim(a."Facility Id Ust"::text), '') = nullif(trim(c."Facility Id Ust"::text), '') and case when nullif(trim(a."Tank Id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."Tank Id"::text), '')::integer else null::integer end = case when nullif(trim(c."Tank Id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(c."Tank Id"::text), '')::integer else null::integer end and case when nullif(trim(a."Compartment Id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."Compartment Id"::text), '')::integer else null::integer end = case when nullif(trim(c."Compartment Id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(c."Compartment Id"::text), '')::integer else null::integer end 
    left join tn_ust."v_spill_bucket_installed" d on nullif(trim(a."Facility Id Ust"::text), '') = nullif(trim(d."Facility Id Ust"::text), '') and case when nullif(trim(a."Tank Id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."Tank Id"::text), '')::integer else null::integer end = case when nullif(trim(d."Tank Id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(d."Tank Id"::text), '')::integer else null::integer end and case when nullif(trim(a."Compartment Id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."Compartment Id"::text), '')::integer else null::integer end = case when nullif(trim(d."Compartment Id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(d."Compartment Id"::text), '')::integer else null::integer end 
    left join tn_ust."v_spill_prevention_not_required" e on nullif(trim(a."Facility Id Ust"::text), '') = nullif(trim(e."Facility Id Ust"::text), '') and case when nullif(trim(a."Tank Id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."Tank Id"::text), '')::integer else null::integer end = case when nullif(trim(e."Tank Id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(e."Tank Id"::text), '')::integer else null::integer end and case when nullif(trim(a."Compartment Id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."Compartment Id"::text), '')::integer else null::integer end = case when nullif(trim(e."Compartment Id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(e."Compartment Id"::text), '')::integer else null::integer end 
    left join tn_ust.v_compartment_status_xwalk f on b."Status" = f.organization_value
    left join tn_ust.v_spill_bucket_wall_type_xwalk g on a."Spill Prevention" = g.organization_value
where not exists
    (select 1 from tn_ust.erg_unregulated_facilities unreg_fac
    where nullif(trim(a."Facility Id Ust"::text), '') = unreg_fac.facility_id)
and not exists
    (select 1 from tn_ust.erg_unregulated_tanks unreg_tank
    where nullif(trim(a."Facility Id Ust"::text), '') = unreg_tank.facility_id and case when nullif(trim(a."Tank Id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."Tank Id"::text), '')::integer else null::integer end = unreg_tank.tank_id)
and exists
    (select 1 from tn_ust.v_ust_facility parent
    where parent.facility_id = nullif(trim(a."Facility Id Ust"::text), ''))
and coalesce(f.exclude_from_query, 'N') <> 'Y'
and coalesce(g.exclude_from_query, 'N') <> 'Y'

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
----------------------------------------------------------------------------------------------------------

-- WARNINGS
-- Overriding query_logic for ust_piping.piping_material_frp with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_material_steel with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_material_copper with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_material_flex with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_material_no_piping with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_line_test_annual with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_groundwater_monitoring with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_vapor_monitoring with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_interstitial_monitoring with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_statistical_inventory_reconciliation with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_release_detection_other with standardized recipe SQL.

create or replace view tn_ust.v_ust_piping as
select distinct
    nullif(trim(a."Facility Id Ust"::text), '')::character varying(50) as facility_id,
    case when nullif(trim(a."Tank Id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."Tank Id"::text), '')::integer else null::integer end as tank_id,
    case when nullif(trim(a."Compartment Id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."Compartment Id"::text), '')::integer else null::integer end as compartment_id,
    c."piping_id"::character varying(50) as piping_id,
    piping_style_id as piping_style_id,
    case when lower(nullif(trim(a."Piping Material"::text), '')) like '%fiberglass%' then 'Yes'::text else null::text end as piping_material_frp,
    case when lower(nullif(trim(a."Piping Material"::text), '')) in ('black steel', 'cath. protection', 'cath. steel', 'coated steel', 'steel', 'steel/aboveground', 'steel/cont', 'bare steel', 'steel isolated') then 'Yes'::text else null::text end as piping_material_steel,
    case when lower(nullif(trim(a."Piping Material"::text), '')) in ('copper', 'copper -corr. prot.', 'copper isolated') then 'Yes'::text else null::text end as piping_material_copper,
    case when lower(nullif(trim(a."Piping Material"::text), '')) in ('dw ameron', 'dw apt', 'dw environ', 'dw flex', 'dw marinaflex', 'dw opw', 'dw poly', 'sw ameron', 'sw apt', 'sw flex', 'total containment', 'flexible', 'flexible plastic', 'flex piping') then 'Yes'::text else null::text end as piping_material_flex,
    case when lower(nullif(trim(a."Piping Material"::text), '')) in ('none', 'not applicable', 'pipingmaterialnopiping', 'no piping') then 'Yes'::text else null::text end as piping_material_no_piping,
    b."piping_line_leak_detector"::character varying(7) as piping_line_leak_detector,
    case when lower(nullif(trim(a."Leak Detection Periodic"::text), '')) in ('tightness testing') then 'Yes'::text else null::text end as piping_line_test_annual,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when a."Leak Detection Periodic" = '3 Year LTT' then 'Yes' end as piping_line_test3yr,
    case when lower(nullif(trim(a."Leak Detection Periodic"::text), '')) in ('groundwater monitoring') then 'Yes'::text else null::text end as piping_groundwater_monitoring,
    case when lower(nullif(trim(a."Leak Detection Periodic"::text), '')) in ('vapor monitoring') then 'Yes'::text else null::text end as piping_vapor_monitoring,
    case when lower(nullif(trim(a."Leak Detection Periodic"::text), '')) in ('secondary containment', 'sump sensor') then 'Yes'::text else null::text end as piping_interstitial_monitoring,
    case when lower(nullif(trim(a."Leak Detection Periodic"::text), '')) in ('s.i.r.') then 'Yes'::text else null::text end as piping_statistical_inventory_reconciliation,
    case when lower(nullif(trim(a."Leak Detection Periodic"::text), '')) in ('double walled') then 'Yes'::text else null::text end as piping_release_detection_other,
    piping_wall_type_id as piping_wall_type_id
from tn_ust."v_tn_compartments" a
    left join tn_ust."v_piping_line_leak_detector" b on nullif(trim(a."Facility Id Ust"::text), '') = nullif(trim(b."Facility Id Ust"::text), '') and case when nullif(trim(a."Tank Id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."Tank Id"::text), '')::integer else null::integer end = case when nullif(trim(b."Tank Id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(b."Tank Id"::text), '')::integer else null::integer end and case when nullif(trim(a."Compartment Id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."Compartment Id"::text), '')::integer else null::integer end = case when nullif(trim(b."Compartment Id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(b."Compartment Id"::text), '')::integer else null::integer end 
    left join tn_ust."erg_piping_id" c on nullif(trim(a."Facility Id Ust"::text), '') = nullif(trim(c."facility_id"::text), '') and case when nullif(trim(a."Tank Id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."Tank Id"::text), '')::integer else null::integer end = case when nullif(trim(c."tank_id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(c."tank_id"::text), '')::integer else null::integer end and case when nullif(trim(a."Compartment Id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."Compartment Id"::text), '')::integer else null::integer end = case when nullif(trim(c."compartment_id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(c."compartment_id"::text), '')::integer else null::integer end 
    left join tn_ust.v_piping_style_xwalk d on a."Piping Type" = d.organization_value
    left join tn_ust.v_piping_wall_type_xwalk e on a."Pipe Construction Type" = e.organization_value
where not exists
    (select 1 from tn_ust.erg_unregulated_facilities unreg_fac
    where nullif(trim(a."Facility Id Ust"::text), '') = unreg_fac.facility_id)
and not exists
    (select 1 from tn_ust.erg_unregulated_tanks unreg_tank
    where nullif(trim(a."Facility Id Ust"::text), '') = unreg_tank.facility_id and case when nullif(trim(a."Tank Id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."Tank Id"::text), '')::integer else null::integer end = unreg_tank.tank_id)
and exists
    (select 1 from tn_ust.v_ust_facility parent
    where parent.facility_id = nullif(trim(a."Facility Id Ust"::text), ''))
and coalesce(d.exclude_from_query, 'N') <> 'Y'
and coalesce(e.exclude_from_query, 'N') <> 'Y'

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
