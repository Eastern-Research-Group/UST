----------------------------------------------------------------------------------------------------------

-- CREATE OR REPLACE preserves views that depend on v_ust_facility.

select * From ma_ust.v_ust_facility where facility_state is null;

create or replace view ma_ust.v_ust_facility as
with financial_responsibility as (
    -- Preserve all methods on one row per facility before joining the parent.
    select nullif(trim(c.facility_id::text), '') as facility_id,
        max(case when c."fr_type_name" is not null then 'Yes'::character varying(7) else null end) as financial_responsibility_obtained,
        max(case when c."fr_type_name" = 'Local Government Bond Rating Test' then 'Yes'::character varying(3) else null end) as financial_responsibility_bond_rating_test,
        max(case when c."fr_type_name" = 'Commercial Insurance' then 'Yes'::character varying(3) else null end) as financial_responsibility_commercial_insurance,
        max(case when c."fr_type_name" = 'Guarantee' then 'Yes'::character varying(3) else null end) as financial_responsibility_guarantee,
        max(case when c."fr_type_name" = 'Irrevocable Standby Letter of Credit' then 'Yes'::character varying(3) else null end) as financial_responsibility_letter_of_credit,
        max(case when c."fr_type_name" = 'Local Government Financial Test of Insurance' then 'Yes'::character varying(3) else null end) as financial_responsibility_local_government_financial_test,
        max(case when c."fr_type_name" = 'Risk Retention Group Coverage' then 'Yes'::character varying(3) else null end) as financial_responsibility_risk_retention_group,
        max(case when c."fr_type_name" = 'Financial Test of Insurance' then 'Yes'::character varying(3) else null end) as financial_responsibility_self_insurance_financial_test,
        max(case when c."fr_type_name" = '' then 'Yes'::character varying(3) else null end) as financial_responsibility_state_fund,
        max(case when c."fr_type_name" = 'Surety Bond' then 'Yes'::character varying(3) else null end) as financial_responsibility_surety_bond,
        max(case when c."fr_type_name" = 'Trust Fund' then 'Yes'::character varying(3) else null end) as financial_responsibility_trust_fund,
        string_agg(distinct (case when c."fr_type_name" in ('Local Government Fund','Local Government Guarantee') then c."fr_type_name"::character varying(500) else null end)::text, '; ' order by (case when c."fr_type_name" in ('Local Government Fund','Local Government Guarantee') then c."fr_type_name"::character varying(500) else null end)::text) as financial_responsibility_other_method
    from ma_ust.erg_facility_info_fr_type c
    group by nullif(trim(c.facility_id::text), '')
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
    case when facility_state is null then 'MA'::varchar(2) else facility_state end as facility_state,
    1::integer as facility_epa_region,
    a."FAC LAT"::double precision as facility_latitude,
    a."FAC LONG"::double precision as facility_longitude,
    c.financial_responsibility_obtained::character varying as financial_responsibility_obtained,
    c.financial_responsibility_bond_rating_test::character varying as financial_responsibility_bond_rating_test,
    c.financial_responsibility_commercial_insurance::character varying as financial_responsibility_commercial_insurance,
    c.financial_responsibility_guarantee::character varying as financial_responsibility_guarantee,
    c.financial_responsibility_letter_of_credit::character varying as financial_responsibility_letter_of_credit,
    c.financial_responsibility_local_government_financial_test::character varying as financial_responsibility_local_government_financial_test,
    c.financial_responsibility_risk_retention_group::character varying as financial_responsibility_risk_retention_group,
    c.financial_responsibility_self_insurance_financial_test::character varying as financial_responsibility_self_insurance_financial_test,
    c.financial_responsibility_state_fund::character varying as financial_responsibility_state_fund,
    c.financial_responsibility_surety_bond::character varying as financial_responsibility_surety_bond,
    c.financial_responsibility_trust_fund::character varying as financial_responsibility_trust_fund,
    c.financial_responsibility_other_method::character varying as financial_responsibility_other_method
from ma_ust."erg_facility_final" a
    left join ma_ust."erg_facility_info_org_type" b on nullif(trim(a."Facility ID#"::text), '') = nullif(trim(b."facility_id"::text), '') 
    left join financial_responsibility c on nullif(trim(a."Facility ID#"::text), '') = nullif(trim(c."facility_id"::text), '') 
    left join ma_ust.v_facility_type_xwalk d on a."FAC TYPE" = d.organization_value
    left join ma_ust.v_owner_type_xwalk e on b."org_type_name" = e.organization_value
    left join ma_ust.v_state_xwalk f on a."FAC STATE" = f.organization_value
where not exists
    (select 1 from ma_ust.erg_unregulated_facilities unreg
    where nullif(trim(a."Facility ID#"::text), '') = unreg.facility_id)
and coalesce(d.exclude_from_query, 'N') <> 'Y'
and coalesce(e.exclude_from_query, 'N') <> 'Y'
and coalesce(f.exclude_from_query, 'N') <> 'Y'

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
----------------------------------------------------------------------------------------------------------

-- WARNINGS
-- Overriding query_logic for ust_tank.compartmentalized_ust with standardized recipe SQL.

drop view ma_ust.v_ust_tank;

create or replace view ma_ust.v_ust_tank as
select distinct
    nullif(trim(a."Facility ID#"::text), '')::character varying(50) as facility_id,
    a."TANK ID#"::integer as tank_id,
    tank_status_id as tank_status_id,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when a."TANK CONSTRUCT" = 'Field Constructed Tank Double Walled (cathodic protection not required)' then 'Yes' end as field_constructed,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when "STATUS" = 'Tank Closure In-Place' then a."STATUS DATE"::date else null end as tank_closure_date,
    a."INSTALL DATE"::date as tank_installation_date,
    case when nullif(trim(a."NUMBER OF COMPARTMENT"::text), '') ~ '^[+-]?\d+(\.0+)?$' and (nullif(trim(a."NUMBER OF COMPARTMENT"::text), ''))::numeric > 1 then 'Yes'::text when nullif(trim(a."NUMBER OF COMPARTMENT"::text), '') ~ '^[+-]?\d+(\.0+)?$' then 'No'::text else null::text end as compartmentalized_ust,
    a."NUMBER OF COMPARTMENT"::integer as number_of_compartments,
    tank_material_description_id as tank_material_description_id,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when a."TANK CORROSION TYPE" in ('Manufactured Sacrificial Anode (Galvanic) System','Field Constructed Sacrificial Anode (Galvanic) System') then 'Yes'::character varying(7) else null end as tank_corrosion_protection_sacrificial_anode,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when a."TANK CORROSION TYPE" = 'Field Constructed Impressed Current System' then 'Yes'::character varying(7) else null end as tank_corrosion_protection_impressed_current,
    tank_secondary_containment_id as tank_secondary_containment_id
from ma_ust."Tank info" a
    left join ma_ust.v_tank_material_description_xwalk b on a."TANK CONSTRUCT" = b.organization_value
    left join ma_ust.v_tank_secondary_containment_xwalk c on a."TANK CONSTRUCT" = c.organization_value
    left join ma_ust.v_tank_status_xwalk d on a."STATUS" = d.organization_value
where not exists
    (select 1 from ma_ust.erg_unregulated_facilities unreg_fac
    where nullif(trim(a."Facility ID#"::text), '') = unreg_fac.facility_id)
and not exists
    (select 1 from ma_ust.erg_unregulated_tanks unreg_tank
    where nullif(trim(a."Facility ID#"::text), '') = unreg_tank.facility_id and case when nullif(trim(a."TANK ID#"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."TANK ID#"::text), '')::integer else null::integer end = unreg_tank.tank_id)
and exists
    (select 1 from ma_ust.v_ust_facility parent
    where parent.facility_id = nullif(trim(a."Facility ID#"::text), ''))
and coalesce(b.exclude_from_query, 'N') <> 'Y'
and coalesce(c.exclude_from_query, 'N') <> 'Y'
and coalesce(d.exclude_from_query, 'N') <> 'Y'

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
----------------------------------------------------------------------------------------------------------

create or replace view ma_ust.v_ust_tank_substance as
select distinct
    nullif(trim(a."Facility ID#"::text), '')::character varying(50) as facility_id,
    case when nullif(trim(a."TANK ID#"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."TANK ID#"::text), '')::integer else null::integer end as tank_id,
    substance_id as substance_id
from ma_ust."Tank info" a
    left join ma_ust.v_substance_xwalk b on a."CONTENT" = b.organization_value
where substance_id is not null and not exists
    (select 1 from ma_ust.erg_unregulated_facilities unreg_fac
    where nullif(trim(a."Facility ID#"::text), '') = unreg_fac.facility_id)
and not exists
    (select 1 from ma_ust.erg_unregulated_tanks unreg_tank
    where nullif(trim(a."Facility ID#"::text), '') = unreg_tank.facility_id and case when nullif(trim(a."TANK ID#"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."TANK ID#"::text), '')::integer else null::integer end = unreg_tank.tank_id)
and exists
    (select 1 from ma_ust.v_ust_facility parent
    where parent.facility_id = nullif(trim(a."Facility ID#"::text), ''))
and coalesce(b.exclude_from_query, 'N') <> 'Y'

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
----------------------------------------------------------------------------------------------------------

-- WARNINGS
-- Overriding query_logic for ust_compartment.spill_bucket_installed with standardized recipe SQL.
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
-- Pair each source row with one generated ID, matching the source ctid order
-- used by MA_UST_id_column_generation.sql. Rank before applying row filters.
with compartment_src as (
    select a.*,
        row_number() over (
            partition by a."Facility ID#"::text, a."TANK ID#"
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
)
select distinct
    nullif(trim(a."Facility ID#"::text), '')::character varying(50) as facility_id,
    case when nullif(trim(a."TANK ID#"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."TANK ID#"::text), '')::integer else null::integer end as tank_id,
    b."compartment_id"::integer as compartment_id,
    compartment_status_id as compartment_status_id,
    a."CAPACITY"::integer as compartment_capacity_gallons,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when a."OVERFILL PROTECT TYPE" = 'Ball Float' then 'Yes'::character varying(7) else null end as overfill_prevention_ball_float_valve,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when a."OVERFILL PROTECT TYPE" = 'Automatic shut-off valve' then 'Yes'::character varying(7) else null end as overfill_prevention_flow_shutoff_device,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when a."OVERFILL PROTECT TYPE" = 'High level alarm' then 'Yes'::character varying(7) else null end as overfill_prevention_high_level_alarm,
    case when lower(nullif(trim(a."SPILL BUCKET SENSOR"::text), '')) in ('true', 't', 'yes', 'y', '1', '1.0') then 'Yes'::text when lower(nullif(trim(a."SPILL BUCKET SENSOR"::text), '')) in ('false', 'f', 'no', 'n', '0', '0.0') then 'No'::text else null::text end as spill_bucket_installed,
    case when lower(nullif(trim(a."TANK LEAK DETECT"::text), '')) in ('secondary containment', 'double walled', 'interstitial monitoring', 'concrete vault') then 'Yes'::text else null::text end as tank_interstitial_monitoring,
    case when lower(nullif(trim(a."TANK LEAK DETECT"::text), '')) in ('in-tank monitor', 'automatic tank gauging') then 'Yes'::text else null::text end as tank_automatic_tank_gauging_release_detection,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when a."TANK LEAK DETECT" = 'Continuous In-Tank Monitoring System' then 'Yes'::character varying(7) else null end as automatic_tank_gauging_continuous_leak_detection,
    case when lower(nullif(trim(a."TANK LEAK DETECT"::text), '')) in ('manual gauging') then 'Yes'::text else null::text end as tank_manual_tank_gauging,
    case when lower(nullif(trim(a."TANK LEAK DETECT"::text), '')) in ('s.i.r.') then 'Yes'::text else null::text end as tank_statistical_inventory_reconciliation,
    case when lower(nullif(trim(a."TANK LEAK DETECT"::text), '')) in ('tightness testing', 'tanktightnesstesting') then 'Yes'::text else null::text end as tank_tightness_testing,
    case when lower(nullif(trim(a."TANK LEAK DETECT"::text), '')) in ('vapor monitoring') then 'Yes'::text else null::text end as tank_vapor_monitoring
from compartment_src a
    left join compartment_ids b on a."Facility ID#"::text = b."facility_id" and a."TANK ID#" = b."tank_id"
        and a.compartment_row_number = b.compartment_row_number
    left join ma_ust.v_compartment_status_xwalk c on a."STATUS" = c.organization_value
where not exists
    (select 1 from ma_ust.erg_unregulated_facilities unreg_fac
    where nullif(trim(a."Facility ID#"::text), '') = unreg_fac.facility_id)
and not exists
    (select 1 from ma_ust.erg_unregulated_tanks unreg_tank
    where nullif(trim(a."Facility ID#"::text), '') = unreg_tank.facility_id and case when nullif(trim(a."TANK ID#"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."TANK ID#"::text), '')::integer else null::integer end = unreg_tank.tank_id)
and exists
    (select 1 from ma_ust.v_ust_facility parent
    where parent.facility_id = nullif(trim(a."Facility ID#"::text), ''))
and coalesce(c.exclude_from_query, 'N') <> 'Y'

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
LINE 18: ...'Field Constructed Impressed Current System then 'Yes'::char...
                                                              ^


create or replace view ma_ust.v_ust_piping as
select distinct
    nullif(trim(a."Facility ID#"::text), '')::character varying(50) as facility_id,
    case when nullif(trim(a."TANK ID#"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."TANK ID#"::text), '')::integer else null::integer end as tank_id,
    case when nullif(trim(c."compartment_id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(c."compartment_id"::text), '')::integer else null::integer end as compartment_id,
    d."piping_id"::character varying(50) as piping_id,
    piping_style_id as piping_style_id,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when a."PIPE TYPE" = 'European suction system' then 'Yes'::character varying(7) else null end as safe_suction,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when a."PIPE TYPE" = 'Non-European suction System' then 'Yes'::character varying(7) else null end as american_suction,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when a."PIPE TYPE" in ('Pressurized piping system with electronic automatic line leak detection','Pressurized piping system with mechanical automatic line leak detection') then 'Yes'::character varying(7) else null end as high_pressure_or_bulk_piping,
    case when lower(nullif(trim(a."PIPE CONSTRUCT"::text), '')) like '%fiberglass%' then 'Yes'::text else null::text end as piping_material_frp,
    case when lower(nullif(trim(a."PIPE CONSTRUCT"::text), '')) in ('black steel', 'cath. protection', 'cath. steel', 'coated steel', 'steel', 'steel/aboveground', 'steel/cont', 'bare steel', 'steel isolated') then 'Yes'::text else null::text end as piping_material_steel,
    case when lower(nullif(trim(a."PIPE CONSTRUCT"::text), '')) in ('cath. protection', 'cath. steel') then 'Yes'::text else null::text end as piping_corrosion_protection_sacrificial_anode,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when a."LEAK CORROSION TYPE" = 'Field Constructed Impressed Current System' then 'Yes'::character varying(7) else null end as piping_corrosion_protection_impressed_current,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when "PIPE CONSTRUCT" in ('Single-walled non-corrodible material (No corrosion protection required)','Double-walled non-corrodible material (No corrosion protection required)') then 'Yes' end as piping_corrosion_protection_cathodic_not_required,
    case when lower(nullif(trim(a."PIPE LEAK DETECT"::text), '')) in ('campo/miller lld', 'electronic lld', 'incon lld', 'mechanical lld', 'ppm 4000') then 'Yes'::text else null::text end as piping_line_leak_detector,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when a."PIPE LEAK DETECT" = 'Continuous Interstitial Space Monitoring' then 'Yes'::character varying(7) else null end as piping_automated_interstitial_monitoring,
    case when lower(nullif(trim(a."PIPE LEAK DETECT"::text), '')) in ('tightness testing') then 'Yes'::text else null::text end as piping_line_test_annual,
    case when lower(nullif(trim(a."PIPE LEAK DETECT"::text), '')) in ('secondary containment', 'sump sensor') then 'Yes'::text else null::text end as piping_interstitial_monitoring,
    case when lower(nullif(trim(a."PIPE LEAK DETECT"::text), '')) in ('s.i.r.') then 'Yes'::text else null::text end as piping_statistical_inventory_reconciliation,
    case when lower(nullif(trim(a."PIPE LEAK DETECT"::text), '')) in ('double walled') then 'Yes'::text else null::text end as piping_release_detection_other,
    b."pipe_tank_top_sump"::character varying(7) as pipe_tank_top_sump,
    piping_wall_type_id as piping_wall_type_id
from ma_ust."Tank info" a
    left join ma_ust."vw_erg_pipe_tank_top_sump" b on nullif(trim(a."Facility ID#"::text), '') = nullif(trim(b."Facility ID#"::text), '') and case when nullif(trim(a."TANK ID#"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."TANK ID#"::text), '')::integer else null::integer end = case when nullif(trim(b."TANK ID#"::text), '') ~ '^[+-]?\d+$' then nullif(trim(b."TANK ID#"::text), '')::integer else null::integer end 
    left join ma_ust."erg_compartment_id" c on nullif(trim(a."Facility ID#"::text), '') = nullif(trim(c."facility_id"::text), '') and case when nullif(trim(a."TANK ID#"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."TANK ID#"::text), '')::integer else null::integer end = case when nullif(trim(c."tank_id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(c."tank_id"::text), '')::integer else null::integer end 
    left join ma_ust."erg_piping_id" d on c."facility_id" = d."facility_id" and c."tank_id" = d."tank_id" and c."compartment_id" = d."compartment_id" 
    left join ma_ust.v_piping_style_xwalk e on a."PIPE TYPE" = e.organization_value
    left join ma_ust.v_piping_wall_type_xwalk f on a."PIPE CONSTRUCT" = f.organization_value
where not exists
    (select 1 from ma_ust.erg_unregulated_facilities unreg_fac
    where nullif(trim(a."Facility ID#"::text), '') = unreg_fac.facility_id)
and not exists
    (select 1 from ma_ust.erg_unregulated_tanks unreg_tank
    where nullif(trim(a."Facility ID#"::text), '') = unreg_tank.facility_id and case when nullif(trim(a."TANK ID#"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."TANK ID#"::text), '')::integer else null::integer end = unreg_tank.tank_id)
and exists
    (select 1 from ma_ust.v_ust_facility parent
    where parent.facility_id = nullif(trim(a."Facility ID#"::text), ''))
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
select distinct
    nullif(trim(a."Facility ID#"::text), '')::character varying(50) as facility_id,
    a."dispenser_number"::character varying(50) as dispenser_id,
    case when lower(nullif(trim(a."dispenser_sump_ind"::text), '')) in ('true', 't', 'yes', 'y', '1', '1.0') then 'Yes'::text when lower(nullif(trim(a."dispenser_sump_ind"::text), '')) in ('false', 'f', 'no', 'n', '0', '0.0') then 'No'::text else null::text end as dispenser_udc
from ma_ust."Dispenser info" a
where not exists
    (select 1 from ma_ust.erg_unregulated_facilities unreg_fac
    where nullif(trim(a."Facility ID#"::text), '') = unreg_fac.facility_id)
and exists
    (select 1 from ma_ust.v_ust_facility parent
    where parent.facility_id = nullif(trim(a."Facility ID#"::text), ''))

)
select facility_id,
    dispenser_id,
    -- Keep an agreed known value; contradictory Yes/No records remain unknown.
    case when count(distinct dispenser_udc) = 1 then max(dispenser_udc)
         else null::text end as dispenser_udc
from dispenser_values
group by facility_id, dispenser_id;
