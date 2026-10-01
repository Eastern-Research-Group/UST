----------------------------------------------------------------------------------------------------------

drop view  ma_ust.v_ust_facility cascade;

create or replace view ma_ust.v_ust_facility as
with financial_responsibility as (
    select
        c."facility_id"::character varying(50) as facility_id,
        max(case when c."fr_type_name" is not null then 'Yes'::character varying(7) else null end) as financial_responsibility_obtained,
        max(case when c."fr_type_name" = 'Local Government Bond Rating Test' then 'Yes'::character varying(3) else null end) as financial_responsibility_bond_rating_test,
        max(case when c."fr_type_name" = 'Commercial Insurance' then 'Yes'::character varying(3) else null end) as financial_responsibility_commercial_insurance,
        max(case when c."fr_type_name" = 'Guarantee' then 'Yes'::character varying(3) else null end) as financial_responsibility_guarantee,
        max(case when c."fr_type_name" = 'Irrevocable Standby Letter of Credit' then 'Yes'::character varying(3) else null end) as financial_responsibility_letter_of_credit,
        max(case when c."fr_type_name" = 'Local Government Financial Test of Insurance' then 'Yes'::character varying(3) else null end) as financial_responsibility_local_government_financial_test,
        max(case when c."fr_type_name" = 'Local Government Fund' then 'Yes'::character varying(3) else null end) as financial_responsibility_local_government_fund,
        max(case when c."fr_type_name" = 'Local Government Guarantee' then 'Yes'::character varying(3) else null end) as financial_responsibility_local_government_guarantee,
        max(case when c."fr_type_name" = 'Risk Retention Group Coverage' then 'Yes'::character varying(3) else null end) as financial_responsibility_risk_retention_group,
        max(case when c."fr_type_name" = 'Financial Test of Insurance' then 'Yes'::character varying(3) else null end) as financial_responsibility_self_insurance_financial_test,
        max(case when c."fr_type_name" = '' then 'Yes'::character varying(3) else null end) as financial_responsibility_state_fund,
        max(case when c."fr_type_name" = 'Surety Bond' then 'Yes'::character varying(3) else null end) as financial_responsibility_surety_bond,
        max(case when c."fr_type_name" = 'Trust Fund' then 'Yes'::character varying(3) else null end) as financial_responsibility_trust_fund
    from ma_ust."erg_facility_info_fr_type" c
    group by c."facility_id"
)
select distinct
    a."Facility ID#"::character varying(50) as facility_id,
    a."FAC NAME"::character varying(100) as facility_name,
    owner_type_id as owner_type_id,
    facility_type_id as facility_type1,
    a."FAC ADD 1"::character varying(100) as facility_address1,
    a."FAC ADD 2"::character varying(100) as facility_address2,
    a."FAC CITY"::character varying(100) as facility_city,
    a."FAC ZIP"::character varying(10) as facility_zip_code,
    case when facility_state is not null then facility_state else 'MA'::character varying(2)  end as facility_state,
    1::integer as facility_epa_region,
    a."FAC LAT"::double precision as facility_latitude,
    a."FAC LONG"::double precision as facility_longitude,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    c.financial_responsibility_obtained,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    c.financial_responsibility_bond_rating_test,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    c.financial_responsibility_commercial_insurance,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    c.financial_responsibility_guarantee,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    c.financial_responsibility_letter_of_credit,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    c.financial_responsibility_local_government_financial_test,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    c.financial_responsibility_local_government_fund,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    c.financial_responsibility_local_government_guarantee,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    c.financial_responsibility_risk_retention_group,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    c.financial_responsibility_self_insurance_financial_test,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    c.financial_responsibility_state_fund,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    c.financial_responsibility_surety_bond,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    c.financial_responsibility_trust_fund
from ma_ust."erg_facility_final" a
    left join ma_ust."erg_facility_info_org_type" b on a."Facility ID#"::character varying = b."facility_id"::character varying 
    left join financial_responsibility c on a."Facility ID#"::character varying = c.facility_id
    left join ma_ust.v_facility_type_xwalk d on a."FAC TYPE" = d.organization_value
    left join ma_ust.v_owner_type_xwalk e on b."org_type_name" = e.organization_value
    left join ma_ust.v_state_xwalk f on a."FAC STATE" = f.organization_value
where not exists
    (select 1 from ma_ust.erg_unregulated_facilities unreg
    where a."Facility ID#"::character varying = unreg.facility_id)
and coalesce(d.exclude_from_query, 'N') <> 'Y'
and coalesce(e.exclude_from_query, 'N') <> 'Y'
and coalesce(f.exclude_from_query, 'N') <> 'Y'

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
----------------------------------------------------------------------------------------------------------

-- WARNINGS
-- Overriding query_logic for ust_tank.emergency_generator with standardized recipe SQL.
-- Overriding query_logic for ust_tank.compartmentalized_ust with standardized recipe SQL.

create or replace view ma_ust.v_ust_tank as
select distinct
    a."Facility ID#"::character varying(50) as facility_id,
    a."TANK ID#"::integer as tank_id,
    tank_status_id as tank_status_id,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when a."TANK CONSTRUCT" = 'Field Constructed Tank Double Walled (cathodic protection not required)' then 'Yes' end as field_constructed,
    case when lower(nullif(trim(a."USE TYPE"::text), '')) in ('true', 't', 'yes', 'y', '1', '1.0') then 'Yes'::text when lower(nullif(trim(a."USE TYPE"::text), '')) in ('false', 'f', 'no', 'n', '0', '0.0') then 'No'::text else null::text end as emergency_generator,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when "STATUS" = 'Tank Closure In-Place' then a."STATUS DATE"::date else null end as tank_closure_date,
    a."INSTALL DATE"::date as tank_installation_date,
    case when nullif(trim(a."NUMBER OF COMPARTMENT"::text), '') ~ '^[+-]?\d+(\.0+)?$' and (nullif(trim(a."NUMBER OF COMPARTMENT"::text), ''))::numeric > 1 then 'Yes'::text when nullif(trim(a."NUMBER OF COMPARTMENT"::text), '') ~ '^[+-]?\d+(\.0+)?$' then 'No'::text else null::text end as compartmentalized_ust,
    a."NUMBER OF COMPARTMENT"::integer as number_of_compartments,
    tank_material_description_id as tank_material_description_id,
    b."tank_corrosion_protection_sacrificial_anode"::character varying(7) as tank_corrosion_protection_sacrificial_anode,
    b."tank_corrosion_protection_impressed_current"::character varying(7) as tank_corrosion_protection_impressed_current,
    tank_secondary_containment_id as tank_secondary_containment_id
from ma_ust."Tank info" a
    left join ma_ust."erg_tank_corrosion_protection" b on a."Facility ID#"::character varying = b."Facility ID#"::character varying and a."TANK ID#"::integer = b."TANK ID#"::integer 
    left join ma_ust.v_tank_material_description_xwalk c on a."TANK CONSTRUCT" = c.organization_value
    left join ma_ust.v_tank_secondary_containment_xwalk d on a."TANK CONSTRUCT" = d.organization_value
    left join ma_ust.v_tank_status_xwalk e on a."STATUS" = e.organization_value
where not exists
    (select 1 from ma_ust.erg_unregulated_facilities unreg_fac
    where a."Facility ID#"::character varying = unreg_fac.facility_id)
and not exists
    (select 1 from ma_ust.erg_unregulated_tanks unreg_tank
    where a."Facility ID#"::character varying = unreg_tank.facility_id and a."TANK ID#"::integer = unreg_tank.tank_id)
and exists
    (select 1 from ma_ust.v_ust_facility parent
    where parent.facility_id = a."Facility ID#"::character varying)
and coalesce(c.exclude_from_query, 'N') <> 'Y'
and coalesce(d.exclude_from_query, 'N') <> 'Y'
and coalesce(e.exclude_from_query, 'N') <> 'Y'

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
----------------------------------------------------------------------------------------------------------

create or replace view ma_ust.v_ust_tank_substance as
select distinct
    a."Facility ID#"::character varying(50) as facility_id,
    a."TANK ID#"::integer as tank_id,
    substance_id as substance_id
from ma_ust."Tank info" a
    left join ma_ust.v_substance_xwalk b on a."CONTENT" = b.organization_value
where substance_id is not null and not exists
    (select 1 from ma_ust.erg_unregulated_facilities unreg_fac
    where a."Facility ID#"::character varying = unreg_fac.facility_id)
and not exists
    (select 1 from ma_ust.erg_unregulated_tanks unreg_tank
    where a."Facility ID#"::character varying = unreg_tank.facility_id and a."TANK ID#"::integer = unreg_tank.tank_id)
and exists
    (select 1 from ma_ust.v_ust_facility parent
    where parent.facility_id = a."Facility ID#"::character varying)
and coalesce(b.exclude_from_query, 'N') <> 'Y'

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
----------------------------------------------------------------------------------------------------------

-- WARNINGS
-- Overriding query_logic for ust_compartment.tank_interstitial_monitoring with standardized recipe SQL.
-- Overriding query_logic for ust_compartment.tank_automatic_tank_gauging_release_detection with standardized recipe SQL.
-- Overriding query_logic for ust_compartment.tank_manual_tank_gauging with standardized recipe SQL.
-- Overriding query_logic for ust_compartment.tank_statistical_inventory_reconciliation with standardized recipe SQL.
-- Overriding query_logic for ust_compartment.tank_tightness_testing with standardized recipe SQL.
-- Overriding query_logic for ust_compartment.tank_vapor_monitoring with standardized recipe SQL.
-- Generated SQL failed validation for ust_compartment: operator does not exist: bigint = character varying
LINE 24: ...ma_ust."erg_compartment_id" b on a."Facility ID#" = b."facil...
                                                              ^
HINT:  No operator matches the given name and argument types. You might need to add explicit type casts.


create or replace view ma_ust.v_ust_compartment as
with compartment_src as (
    select a.*,
        a."Facility ID#"::character varying(50) as facility_id,
        a."TANK ID#"::integer as tank_id,
        row_number() over (
            partition by a."Facility ID#"::character varying(50), a."TANK ID#"::integer
            order by a.ctid
        ) as compartment_row_number
    from ma_ust."Tank info" a
), compartment_ids as (
    select b.*,
        row_number() over (
            partition by b.facility_id, b.tank_id
            order by b.compartment_id
        ) as compartment_row_number
    from ma_ust.erg_compartment_id b
), status_xwalk as (
    select organization_value,
        min(compartment_status_id) as compartment_status_id,
        max(coalesce(exclude_from_query, 'N')) as exclude_from_query
    from ma_ust.v_compartment_status_xwalk
    group by organization_value
)
select distinct
    a.facility_id,
    a.tank_id,
    b."compartment_id"::integer as compartment_id,
    compartment_status_id as compartment_status_id,
    a."CAPACITY"::integer as compartment_capacity_gallons,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when a."OVERFILL PROTECT TYPE" = 'Ball Float' then 'Yes'::character varying(7) else null end as overfill_prevention_ball_float_valve,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when a."OVERFILL PROTECT TYPE" = 'Automatic shut-off valve' then 'Yes'::character varying(7) else null end as overfill_prevention_flow_shutoff_device,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when a."OVERFILL PROTECT TYPE" = 'High level alarm' then 'Yes'::character varying(7) else null end as overfill_prevention_high_level_alarm,
    c."spill_bucket_installed"::character varying(3) as spill_bucket_installed,
    case when lower(nullif(trim(a."TANK LEAK DETECT"::text), '')) in ('secondary containment', 'double walled', 'interstitial monitoring', 'concrete vault') then 'Yes'::text else null::text end as tank_interstitial_monitoring,
    case when lower(nullif(trim(a."TANK LEAK DETECT"::text), '')) in ('in-tank monitor', 'automatic tank gauging') then 'Yes'::text else null::text end as tank_automatic_tank_gauging_release_detection,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when a."TANK LEAK DETECT" = 'Continuous In-Tank Monitoring System' then 'Yes'::character varying(7) else null end as automatic_tank_gauging_continuous_leak_detection,
    case when lower(nullif(trim(a."TANK LEAK DETECT"::text), '')) in ('manual gauging') then 'Yes'::text else null::text end as tank_manual_tank_gauging,
    case when lower(nullif(trim(a."TANK LEAK DETECT"::text), '')) in ('s.i.r.') then 'Yes'::text else null::text end as tank_statistical_inventory_reconciliation,
    case when lower(nullif(trim(a."TANK LEAK DETECT"::text), '')) in ('tightness testing', 'tanktightnesstesting') then 'Yes'::text else null::text end as tank_tightness_testing,
    case when lower(nullif(trim(a."TANK LEAK DETECT"::text), '')) in ('vapor monitoring') then 'Yes'::text else null::text end as tank_vapor_monitoring
from compartment_src a
    left join compartment_ids b on a.facility_id = b.facility_id
        and a.tank_id = b.tank_id
        and a.compartment_row_number = b.compartment_row_number
    left join ma_ust.erg_spill_bucket_installed c on a."Facility ID#"::character varying = c."Facility ID#"::character varying and a."TANK ID#"::integer = c."TANK ID#"::integer 
    left join status_xwalk d on a."STATUS" = d.organization_value
where not exists
    (select 1 from ma_ust.erg_unregulated_facilities unreg_fac
    where a."Facility ID#"::character varying = unreg_fac.facility_id)
and not exists
    (select 1 from ma_ust.erg_unregulated_tanks unreg_tank
    where a."Facility ID#"::character varying = unreg_tank.facility_id and a."TANK ID#"::integer = unreg_tank.tank_id)
and exists
    (select 1 from ma_ust.v_ust_facility parent
    where parent.facility_id = a."Facility ID#"::character varying)
and coalesce(d.exclude_from_query, 'N') <> 'Y'

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
----------------------------------------------------------------------------------------------------------

-- WARNINGS
-- Overriding query_logic for ust_piping.piping_material_frp with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_material_steel with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_corrosion_protection_sacrificial_anode with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_line_leak_detector with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_line_test_annual with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_interstitial_monitoring with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_statistical_inventory_reconciliation with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_release_detection_other with standardized recipe SQL.
-- Generated SQL failed validation for ust_piping: syntax error at or near "Yes"
LINE 16: ...'Field Constructed Impressed Current System then 'Yes'::char...
                                                              ^


create or replace view ma_ust.v_ust_piping as
select distinct
    a."Facility ID#"::character varying(50) as facility_id,
    a."TANK ID#"::integer as tank_id,
    c."compartment_id"::integer as compartment_id,
    d."piping_id"::character varying(50) as piping_id,
    piping_style_id as piping_style_id,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when a."PIPE TYPE" = 'European suction system' then 'Yes'::character varying(7) else null end as safe_suction,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when a."PIPE TYPE" = 'Non-European suction System' then 'Yes'::character varying(7) else null end as american_suction,
    case when lower(nullif(trim(a."PIPE CONSTRUCT"::text), '')) like '%fiberglass%' then 'Yes'::text else null::text end as piping_material_frp,
    case when lower(nullif(trim(a."PIPE CONSTRUCT"::text), '')) in ('black steel', 'cath. protection', 'cath. steel', 'coated steel', 'steel', 'steel/aboveground', 'steel/cont', 'bare steel', 'steel isolated') then 'Yes'::text else null::text end as piping_material_steel,
    case when lower(nullif(trim(a."PIPE CONSTRUCT"::text), '')) in ('cath. protection', 'cath. steel') then 'Yes'::text else null::text end as piping_corrosion_protection_sacrificial_anode,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when a."LEAK CORROSION TYPE" = 'Field Constructed Impressed Current System' then 'Yes'::character varying(7) else null end as piping_corrosion_protection_impressed_current,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when "PIPE CONSTRUCT" in ('Single-walled non-corrodible material (No corrosion protection required)','Double-walled non-corrodible material (No corrosion protection required)') then 'Yes' end as piping_corrosion_protection_cathodic_not_required,
    case when lower(nullif(trim(a."PIPE TYPE"::text), '')) in ('campo/miller lld', 'electronic lld', 'incon lld', 'mechanical lld', 'ppm 4000') then 'Yes'::text else null::text end as piping_line_leak_detector,
    case when lower(nullif(trim(a."PIPE LEAK DETECT"::text), '')) in ('tightness testing') then 'Yes'::text else null::text end as piping_line_test_annual,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when a."PIPE LEAK DETECT" = 'Annual tightness test of Non-European suction systems (only if installed prior to 1/1/1989) without ' then 'Yes' end as piping_line_test3yr,
    case when lower(nullif(trim(a."PIPE LEAK DETECT"::text), '')) in ('secondary containment', 'sump sensor') then 'Yes'::text else null::text end as piping_interstitial_monitoring,
    case when lower(nullif(trim(a."PIPE LEAK DETECT"::text), '')) in ('s.i.r.') then 'Yes'::text else null::text end as piping_statistical_inventory_reconciliation,
    case when lower(nullif(trim(a."PIPE LEAK DETECT"::text), '')) in ('double walled') then 'Yes'::text else null::text end as piping_release_detection_other,
    b.pipe_tank_top_sump::character varying(7) as pipe_tank_top_sump,
    piping_wall_type_id as piping_wall_type_id
from ma_ust."Tank info" a
    left join ma_ust."vw_erg_pipe_tank_top_sump" b on a."Facility ID#"::character varying = b."Facility ID#"::character varying and a."TANK ID#"::integer = b."TANK ID#"::integer 
    left join ma_ust."erg_compartment_id" c on a."Facility ID#"::character varying = c."facility_id"::character varying and a."TANK ID#"::integer = c."tank_id"::integer 
    left join ma_ust."erg_piping_id" d on c."facility_id" = d."facility_id" and c."tank_id" = d."tank_id" and c."compartment_id" = d."compartment_id" 
    left join ma_ust.v_piping_style_xwalk e on a."PIPE TYPE" = e.organization_value
    left join ma_ust.v_piping_wall_type_xwalk f on a."PIPE CONSTRUCT" = f.organization_value
where not exists
    (select 1 from ma_ust.erg_unregulated_facilities unreg_fac
    where a."Facility ID#"::character varying = unreg_fac.facility_id)
and not exists
    (select 1 from ma_ust.erg_unregulated_tanks unreg_tank
    where a."Facility ID#"::character varying = unreg_tank.facility_id and a."TANK ID#"::integer = unreg_tank.tank_id)
and exists
    (select 1 from ma_ust.v_ust_facility parent
    where parent.facility_id = a."Facility ID#"::character varying)
and coalesce(e.exclude_from_query, 'N') <> 'Y'
and coalesce(f.exclude_from_query, 'N') <> 'Y'

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
----------------------------------------------------------------------------------------------------------

-- WARNINGS
-- No child join mapping found for ust_facility_dispenser; unregulated exclusion uses parent key only.
-- Overriding query_logic for ust_facility_dispenser.dispenser_udc with standardized recipe SQL.

create or replace view ma_ust.v_ust_facility_dispenser as
with dispenser_values as (
    select
        a."Facility ID#"::character varying(50) as facility_id,
        a."dispenser_number"::character varying(50) as dispenser_id,
        case when lower(nullif(trim(a."dispenser_sump_ind"::text), '')) in ('true', 't', 'yes', 'y', '1', '1.0') then 'Yes'::text when lower(nullif(trim(a."dispenser_sump_ind"::text), '')) in ('false', 'f', 'no', 'n', '0', '0.0') then 'No'::text else null::text end as dispenser_udc
    from ma_ust."Dispenser info" a
    where not exists
        (select 1 from ma_ust.erg_unregulated_facilities unreg_fac
        where a."Facility ID#"::character varying = unreg_fac.facility_id)
    and exists
        (select 1 from ma_ust.v_ust_facility parent
        where parent.facility_id = a."Facility ID#"::character varying)
)
select
    facility_id,
    dispenser_id,
    case when bool_or(dispenser_udc = 'Yes') then 'Yes'::text
         when bool_or(dispenser_udc = 'No') then 'No'::text
         else null::text
    end as dispenser_udc
from dispenser_values
group by facility_id, dispenser_id

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
