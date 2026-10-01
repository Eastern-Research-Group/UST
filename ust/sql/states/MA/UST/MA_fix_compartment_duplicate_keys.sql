-- Repair the many-to-many join between Tank info and generated compartment IDs.
-- Preserves the current view columns, value mappings, and exclusion filters.
-- Source row order must match the ctid order used when compartment IDs were
-- generated. Regenerate/reconcile the ID mapping if source rows have changed.
-- Re-running generate-views can overwrite this custom join; reapply this patch.
begin;

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

-- Expected: 9,500 rows and 9,500 distinct keys for the data checked on 2026-09-25.
select count(*) as rows, count(distinct (facility_id, tank_id, compartment_id)) as distinct_keys
from ma_ust.v_ust_compartment;

-- Expected: zero rows.
select facility_id, tank_id, compartment_id, count(*) as row_count
from ma_ust.v_ust_compartment
group by facility_id, tank_id, compartment_id
having count(*) > 1;

-- Review QA, then choose one:
-- commit;
-- rollback;
