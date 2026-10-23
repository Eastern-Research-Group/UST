----------------------------------------------------------------------------------------------------------

drop view ma_ust.v_ust_facility cascade;

create or replace view ma_ust.v_ust_facility as
with financial_responsibility as (
    select
        facility_id::character varying as facility_id,
        case when bool_or(fr_type_name is not null)
            then 'Yes' end as financial_responsibility_obtained,
        case when bool_or(fr_type_name = 'Local Government Bond Rating Test')
            then 'Yes' end as financial_responsibility_bond_rating_test,
        case when bool_or(fr_type_name = 'Commercial Insurance')
            then 'Yes' end as financial_responsibility_commercial_insurance,
        case when bool_or(fr_type_name = 'Guarantee')
            then 'Yes' end as financial_responsibility_guarantee,
        case when bool_or(fr_type_name = 'Irrevocable Standby Letter of Credit')
            then 'Yes' end as financial_responsibility_letter_of_credit,
        case when bool_or(fr_type_name = 'Local Government Financial Test of Insurance')
            then 'Yes' end as financial_responsibility_local_government_financial_test,
        case when bool_or(fr_type_name = 'Local Government Fund')
            then 'Yes' end as financial_responsibility_local_government_fund,
        case when bool_or(fr_type_name = 'Local Government Guarantee')
            then 'Yes' end as financial_responsibility_local_government_guarantee,
        case when bool_or(fr_type_name = 'Risk Retention Group Coverage')
            then 'Yes' end as financial_responsibility_risk_retention_group,
        case when bool_or(fr_type_name = 'Financial Test of Insurance')
            then 'Yes' end as financial_responsibility_self_insurance_financial_test,
        case when bool_or(fr_type_name = 'Surety Bond')
            then 'Yes' end as financial_responsibility_surety_bond,
        case when bool_or(fr_type_name = 'Trust Fund')
            then 'Yes' end as financial_responsibility_trust_fund
    from ma_ust.erg_facility_info_fr_type
    group by facility_id::character varying
)
select distinct
    a."Facility ID#"::character varying(50) as facility_id,
    a."FAC NAME"::character varying(100) as facility_name,
    e.owner_type_id as owner_type_id,
    d.facility_type_id as facility_type1,
    a."FAC ADD 1"::character varying(100) as facility_address1,
    a."FAC ADD 2"::character varying(100) as facility_address2,
    a."FAC CITY"::character varying(100) as facility_city,
    a."FAC ZIP"::character varying(10) as facility_zip_code,
    coalesce(f.facility_state, 'MA'::varchar(2)) as facility_state,
    1::integer as facility_epa_region,
    a."FAC LAT"::double precision as facility_latitude,
    a."FAC LONG"::double precision as facility_longitude,
    c.financial_responsibility_obtained,
    c.financial_responsibility_bond_rating_test,
    c.financial_responsibility_commercial_insurance,
    c.financial_responsibility_guarantee,
    c.financial_responsibility_letter_of_credit,
    c.financial_responsibility_local_government_financial_test,
    c.financial_responsibility_local_government_fund,
    c.financial_responsibility_local_government_guarantee,
    c.financial_responsibility_risk_retention_group,
    c.financial_responsibility_self_insurance_financial_test,
    c.financial_responsibility_surety_bond,
    c.financial_responsibility_trust_fund
from ma_ust.erg_facility_final a
left join ma_ust.erg_facility_info_org_type b
    on a."Facility ID#"::character varying = b.facility_id::character varying
left join financial_responsibility c
    on a."Facility ID#"::character varying = c.facility_id
left join ma_ust.v_facility_type_xwalk d
    on a."FAC TYPE" = d.organization_value
left join ma_ust.v_owner_type_xwalk e
    on b.org_type_name = e.organization_value
left join ma_ust.v_state_xwalk f
    on a."FAC STATE" = f.organization_value
where not exists (
    select 1
    from ma_ust.erg_unregulated_facilities unreg
    where a."Facility ID#"::character varying = unreg.facility_id
)
and coalesce(d.exclude_from_query, 'N') <> 'Y'
and coalesce(e.exclude_from_query, 'N') <> 'Y'
and coalesce(f.exclude_from_query, 'N') <> 'Y';
-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
----------------------------------------------------------------------------------------------------------

drop view ma_ust.v_ust_tank 

create or replace view ma_ust.v_ust_tank as
select distinct
        a."Facility ID#"::character varying(50) as facility_id,
        a."TANK ID#"::integer as tank_id,
        tank_status_id as tank_status_id,
        -- AUTO-COMPILED FROM QUERY_LOGIC
        case when a."TANK CONSTRUCT" = 'Field Constructed Tank Double Walled (cathodic protection not required)' then 'Yes' end as field_constructed,
        -- AUTO-COMPILED FROM QUERY_LOGIC
        case when a."USE TYPE" in ('Emergency engine driven pumps','Emergency Power Generator')  then 'Yes' end as emergency_generator,
        -- AUTO-COMPILED FROM QUERY_LOGIC
        case when "STATUS" = 'Tank Closure In-Place' then a."STATUS DATE"::date else null end as tank_closure_date,
        a."INSTALL DATE"::date as tank_installation_date,
        -- AUTO-COMPILED FROM QUERY_LOGIC
        case when a."NUMBER OF COMPARTMENT" > 1 then 'Yes'::character varying(7) else null end as compartmentalized_ust,
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
LINE 26: ...ma_ust."erg_compartment_id" b on a."Facility ID#" = b."facil..."
                                                              ^
HINT:  No operator matches the given name and argument types. You might need to add explicit type casts.

drop view ma_ust.v_ust_compartment;

create or replace view ma_ust.v_ust_compartment as
select
    a."Facility ID#"::character varying(50) as facility_id,
    a."TANK ID#"::integer as tank_id,
    b.compartment_id::integer as compartment_id,
    max(d.compartment_status_id) as compartment_status_id,
    max(a."CAPACITY"::integer) as compartment_capacity_gallons,

    (case when a."OVERFILL PROTECT TYPE" = 'Ball Float'
        then 'Yes' end)::character varying(7)
        as overfill_prevention_ball_float_valve,

    (case when bool_or(a."OVERFILL PROTECT TYPE" = 'Automatic shut-off valve')
        then 'Yes' end)::character varying(7)
        as overfill_prevention_flow_shutoff_device,

    (case when bool_or(a."OVERFILL PROTECT TYPE" = 'High level alarm')
        then 'Yes' end)::character varying(7)
        as overfill_prevention_high_level_alarm,

    max(c.spill_bucket_installed) as spill_bucket_installed,

    case when "TANK LEAK DETECT" = 'Continuous Interstitial Monitoring' then 'Yes' end as tank_interstitial_monitoring,

    case when a."TANK LEAK DETECT" in ('In tank monitor up to 2 gal per hour','In tank monitor w/ detection rate up to 1 gal/hr','In-Tank Monitoring System')
    then 'Yes'::text end
        as tank_automatic_tank_gauging_release_detection,

    case when a."TANK LEAK DETECT" = 'Continuous In-Tank Monitoring System'
     then 'Yes' end as automatic_tank_gauging_continuous_leak_detection,

    case when a."TANK LEAK DETECT" in ('Manual Tank Gauging (1,000G or more capacity tank)', 'Manual Tank Gauging (1,000G or less capacity tank)')
    then 'Yes'::text end as tank_manual_tank_gauging,

    case when a."TANK LEAK DETECT" = 'In-Tank Monitoring with Statistical Inventory Reconciliation Vendor'
    then 'Yes'::text end as tank_statistical_inventory_reconciliation,

    case when "TANK LEAK DETECT" in ('Annual Bulk Tightness Test','Annual tightness test w/ detection rate 0.5 gal/hr')then 'Yes'::text end as tank_tightness_testing,

    case when "TANK LEAK DETECT" = 'Soil Vapor Monitoring' then 'Yes' end
 as tank_vapor_monitoring,

    case when "TANK LEAK DETECT" = 'Annual Bulk Tightness Test' then 'Yes' end
 as tank_subpart_k_tightness_testing

from ma_ust."Tank info" a
left join ma_ust.erg_compartment_id b
    on a."Facility ID#"::varchar = b.facility_id
    and a."TANK ID#" = b.tank_id
left join ma_ust.erg_spill_bucket_installed c
    on a."Facility ID#"::character varying =
       c."Facility ID#"::character varying
    and a."TANK ID#"::integer = c."TANK ID#"::integer
left join ma_ust.v_compartment_status_xwalk d
    on a."STATUS" = d.organization_value
where not exists (
    select 1
    from ma_ust.erg_unregulated_facilities unreg_fac
    where a."Facility ID#"::character varying = unreg_fac.facility_id
)
and not exists (
    select 1
    from ma_ust.erg_unregulated_tanks unreg_tank
    where a."Facility ID#"::character varying = unreg_tank.facility_id
      and a."TANK ID#"::integer = unreg_tank.tank_id
)
and exists (
    select 1
    from ma_ust.v_ust_facility parent
    where parent.facility_id = a."Facility ID#"::character varying
)
and coalesce(d.exclude_from_query, 'N') <> 'Y'
group by
    a."Facility ID#"::character varying(50),
    a."TANK ID#"::integer,
    b.compartment_id::integer,
"TANK LEAK DETECT", a."OVERFILL PROTECT TYPE";

select * from ma_ust.erg_compartment_id

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
----------------------------------------------------------------------------------------------------------

-- WARNINGS

LINE 16: ...'Field Constructed Impressed Current System then 'Yes'::char...'
                                   
drop view ma_ust.v_ust_piping

create or replace view ma_ust.v_ust_piping as
select distinct
        a."Facility ID#"::character varying(50) as facility_id,
        a."TANK ID#"::integer as tank_id,
        c."compartment_id"::integer as compartment_id,
        d."piping_id"::character varying(50) as piping_id,
        piping_style_id as piping_style_id,
        -- AUTO-GENERATED SOURCE: a."PIPE TYPE"::character varying(7) as safe_suction
        case when "PIPE TYPE" = 'European suction system' then 'Yes' else null end as safe_suction,
        -- AUTO-GENERATED SOURCE: a."PIPE TYPE"::character varying(7) as american_suction
        case when "PIPE TYPE" = 'Non-European suction System' then 'Yes' else null end as american_suction,
        -- AUTO-COMPILED FROM QUERY_LOGIC
        case when "PIPE CONSTRUCT" in ('Single-walled non-corrodible material (No corrosion protection required)','Double-walled non-corrodible material (No corrosion protection required)') then 'Yes' end as piping_material_frp,
        -- AUTO-COMPILED FROM QUERY_LOGIC
        case when "PIPE CONSTRUCT" in ('Double walled metal (Corrosion protection required)','Single-walled metal (Corrosion protection required)') then 'Yes' end as piping_material_steel,
        -- AUTO-COMPILED FROM QUERY_LOGIC
        case
        when a."PIPE CONSTRUCT" = 'Single-walled metal (Corrosion protection required)' then 'Yes' else null
        end as piping_corrosion_protection_sacrificial_anode,
        -- AUTO-COMPILED FROM QUERY_LOGIC
        case when a."LEAK CORROSION TYPE" = 'Field Constructed Impressed Current System' then 'Yes'::character varying(7) else null end as piping_corrosion_protection_impressed_current,
        -- AUTO-COMPILED FROM QUERY_LOGIC
        case when "PIPE CONSTRUCT" in ('Single-walled non-corrodible material (No corrosion protection required)','Double-walled non-corrodible material (No corrosion protection required)') then 'Yes' end as piping_corrosion_protection_cathodic_not_required,
        -- AUTO-GENERATED SOURCE: a."PIPE TYPE"::character varying(7) as piping_line_leak_detector
        case when "PIPE TYPE" in ('Pressurized piping system with electronic automatic line leak detection', 'Pressurized piping system with mechanical automatic line leak detection') then'Yes' end as piping_line_leak_detector,
        -- AUTO-GENERATED SOURCE: a."PIPE LEAK DETECT"::character varying(7) as piping_line_test_annual
        case when "PIPE LEAK DETECT" in ('Annual Automatic Line Leak Detection Test', 'Quarterly visual inspection and annual product line tightness test (only if installed prior to5/28/', 'Annual Tightness Test of Single-Walled Pressurized Piping Systems') then 'Yes' end as piping_line_test_annual,
        -- AUTO-GENERATED SOURCE: a."PIPE LEAK DETECT"::character varying(7) as piping_line_test3yr
        case when "PIPE LEAK DETECT" = 'Annual tightness test of Non-European suction systems (only if installed prior to 1/1/1989) without ' then 'Yes' end as piping_line_test3yr,
        -- AUTO-GENERATED SOURCE: a."PIPE LEAK DETECT"::character varying(7) as piping_interstitial_monitoring
        case when "PIPE LEAK DETECT" = 'Continuous Interstitial Space Monitoring' then 'Yes' else null end as piping_interstitial_monitoring,
        -- AUTO-GENERATED SOURCE: a."PIPE LEAK DETECT"::character varying(7) as piping_statistical_inventory_reconciliation
        case when "PIPE LEAK DETECT" = 'In-tank monitoring with SIR (if installed prior to May 28, 1999)' then 'Yes' else null end as piping_statistical_inventory_reconciliation,
        -- AUTO-GENERATED SOURCE: a."PIPE LEAK DETECT"::character varying(7) as piping_release_detection_other
        case when "PIPE LEAK DETECT" in ('Annual tightness test of Non-European suction systems (only if installed prior to 1/1/1989) without ','Annual Tightness Test of Single-Walled Pressurized Piping Systems','Quarterly visual inspection and annual product line tightness test (only if installed prior to 5/28/') then 'Yes' else null end as piping_release_detection_other,
        b."pipe_tank_top_sump"::character varying(7) as pipe_tank_top_sump,
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
select
    a."Facility ID#"::character varying(50) as facility_id,
    a.dispenser_number::character varying(50) as dispenser_id,
    case
        when bool_or(
            lower(trim(a.dispenser_sump_ind::text))
                in ('true', 't', 'yes', 'y', '1', '1.0')
        ) then 'Yes'::text
        when bool_or(
            lower(trim(a.dispenser_sump_ind::text))
                in ('false', 'f', 'no', 'n', '0', '0.0')
        ) then 'No'::text
        else null::text
    end as dispenser_udc
from ma_ust."Dispenser info" a
where not exists (
    select 1
    from ma_ust.erg_unregulated_facilities unreg_fac
    where a."Facility ID#"::character varying = unreg_fac.facility_id
)
and exists (
    select 1
    from ma_ust.v_ust_facility parent
    where parent.facility_id = a."Facility ID#"::character varying
)
group by
    a."Facility ID#"::character varying(50),
    a.dispenser_number::character varying(50);

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
