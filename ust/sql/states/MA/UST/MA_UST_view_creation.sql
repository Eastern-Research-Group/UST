-- Manual hotfix views for MA UST child-table filtering.
-- Applies three filters where requested:
-- 1) exclude unregulated tanks (erg_unregulated_tanks)
-- 2) exclude unregulated facilities (erg_unregulated_facilities)
-- 3) require facility to exist in v_ust_facility

create or replace view ma_ust.v_ust_compartment as
with src as (
    select
        a."Facility ID#",
        a."TANK ID#",
        a."INSTALL DATE",
        a."LONG",
        a."LAT",
        a."NUMBER OF COMPARTMENT",
        a."CAPACITY",
        a."USE TYPE",
        a."CONTENT",
        a."STATUS",
        a."STATUS DATE",
        a."TANK CONSTRUCT",
        a."TANK LEAK DETECT",
        a."PIPE INSTALL DATE",
        a."PIPE TYPE",
        a."PIPE CONSTRUCT",
        a."PIPE LEAK DETECT",
        a."PIPE LEAK INSTALL",
        a."SUBMERSIBLE SUMP",
        a."SUBMERSIBLE SUMP INSTALL",
        a."TURBINE SUMP",
        a."TURBINE SUMP SENSOR",
        a."INTERMEDIATE SUMP",
        a."INTERMEDIATE SUMP SENSOR",
        a."SPILL BUCKET INSTALLED",
        a."SPILL BUCKET SENSOR",
        a."OVERFILL PROTECT INSTALLED",
        a."OVERFILL PROTECT TYPE",
        a."AUTOMATIC LINE LEAK DTECT",
        a."TANK CORROSION TYPE",
        a."LEAK CORROSION TYPE",
        a."Facility ID#"::character varying(50) as facility_id,
        a."TANK ID#"::integer as tank_id,
        row_number() over (
            partition by a."Facility ID#"::character varying(50), a."TANK ID#"::integer
            order by a.ctid
        ) as rn
    from ma_ust."Tank info" a
    where not exists (
            select 1
            from ma_ust.erg_unregulated_tanks unreg
            where a."Facility ID#"::character varying(50)::text = unreg.facility_id::text
              and a."TANK ID#"::integer = unreg.tank_id
        )
      and not exists (
            select 1
            from ma_ust.erg_unregulated_facilities unreg_fac
            where a."Facility ID#"::character varying(50)::text = unreg_fac.facility_id::text
        )
      and exists (
            select 1
            from ma_ust.v_ust_facility fac
            where a."Facility ID#"::character varying(50)::text = fac.facility_id::text
        )
),
id_map as (
    select
        erg_compartment_id.facility_id,
        erg_compartment_id.tank_id,
        erg_compartment_id.compartment_id,
        row_number() over (
            partition by erg_compartment_id.facility_id, erg_compartment_id.tank_id
            order by erg_compartment_id.compartment_id
        ) as rn
    from ma_ust.erg_compartment_id
),
status_xwalk as (
    select
        v_compartment_status_xwalk.organization_value,
        min(v_compartment_status_xwalk.compartment_status_id) as compartment_status_id
    from ma_ust.v_compartment_status_xwalk
    group by v_compartment_status_xwalk.organization_value
)
select
    s.facility_id,
    s.tank_id,
    x.compartment_id,
    b.compartment_status_id,
    s."CAPACITY"::integer as compartment_capacity_gallons,
    case when s."OVERFILL PROTECT TYPE" = 'Ball Float'::text then 'Yes'::text else null::text end as overfill_prevention_ball_float_valve,
    case when s."OVERFILL PROTECT TYPE" = 'Automatic shut-off valve'::text then 'Yes'::text else null::text end as overfill_prevention_flow_shutoff_device,
    case when s."OVERFILL PROTECT TYPE" = 'High level alarm'::text then 'Yes'::text else null::text end as overfill_prevention_high_level_alarm,
    case when s."SPILL BUCKET SENSOR" = 'Y'::text then 'Yes'::text else null::text end as spill_bucket_installed,
    case when s."TANK LEAK DETECT" = 'Continuous Interstitial Monitoring'::text then 'Yes'::text else null::text end as tank_interstitial_monitoring,
    case when s."TANK LEAK DETECT" = any (array['In-Tank Monitoring with Statistical Inventory Reconciliation Vendor'::text, 'In-Tank Monitoring System'::text, 'In tank monitor up to 2 gal per hour'::text, 'In tank monitor w/ detection rate up to 1 gal/hr'::text]) then 'Yes'::text else null::text end as tank_automatic_tank_gauging_release_detection,
    case when s."TANK LEAK DETECT" = 'Continuous In-Tank Monitoring System'::text then 'Yes'::text else null::text end as automatic_tank_gauging_continuous_leak_detection,
    case when s."TANK LEAK DETECT" = any (array['Manual Tank Gauging (1,000G or less capacity tank)'::text, 'Manual Tank Gauging (1,000G or more capacity tank)'::text]) then 'Yes'::text else null::text end as tank_manual_tank_gauging,
    case when s."TANK LEAK DETECT" = 'In-Tank Monitoring with Statistical Inventory Reconciliation Vendor'::text then 'Yes'::text else null::text end as tank_statistical_inventory_reconciliation,
    case when s."TANK LEAK DETECT" = any (array['Annual Bulk Tightness Test'::text, 'Annual tightness test w/ detection rate 0.5 gal/hr'::text]) then 'Yes'::text else null::text end as tank_tightness_testing,
    case when s."TANK LEAK DETECT" = 'Soil Vapor Monitoring'::text then 'Yes'::text else null::text end as tank_vapor_monitoring
from src s
join id_map x on s.facility_id::text = x.facility_id::text and s.tank_id = x.tank_id and s.rn = x.rn
left join status_xwalk b on s."STATUS" = b.organization_value::text
;


create or replace view ma_ust.v_ust_piping as
with src as (
    select
        a."Facility ID#",
        a."TANK ID#",
        a."INSTALL DATE",
        a."LONG",
        a."LAT",
        a."NUMBER OF COMPARTMENT",
        a."CAPACITY",
        a."USE TYPE",
        a."CONTENT",
        a."STATUS",
        a."STATUS DATE",
        a."TANK CONSTRUCT",
        a."TANK LEAK DETECT",
        a."PIPE INSTALL DATE",
        a."PIPE TYPE",
        a."PIPE CONSTRUCT",
        a."PIPE LEAK DETECT",
        a."PIPE LEAK INSTALL",
        a."SUBMERSIBLE SUMP",
        a."SUBMERSIBLE SUMP INSTALL",
        a."TURBINE SUMP",
        a."TURBINE SUMP SENSOR",
        a."INTERMEDIATE SUMP",
        a."INTERMEDIATE SUMP SENSOR",
        a."SPILL BUCKET INSTALLED",
        a."SPILL BUCKET SENSOR",
        a."OVERFILL PROTECT INSTALLED",
        a."OVERFILL PROTECT TYPE",
        a."AUTOMATIC LINE LEAK DTECT",
        a."TANK CORROSION TYPE",
        a."LEAK CORROSION TYPE",
        a."Facility ID#"::character varying(50) as facility_id,
        a."TANK ID#"::integer as tank_id,
        row_number() over (
            partition by a."Facility ID#"::character varying(50), a."TANK ID#"::integer
            order by a.ctid
        ) as rn
    from ma_ust."Tank info" a
    where not exists (
            select 1
            from ma_ust.erg_unregulated_tanks unreg
            where a."Facility ID#"::character varying(50)::text = unreg.facility_id::text
              and a."TANK ID#"::integer = unreg.tank_id
        )
      and not exists (
            select 1
            from ma_ust.erg_unregulated_facilities unreg_fac
            where a."Facility ID#"::character varying(50)::text = unreg_fac.facility_id::text
        )
      and exists (
            select 1
            from ma_ust.v_ust_facility fac
            where a."Facility ID#"::character varying(50)::text = fac.facility_id::text
        )
),
id_map as (
    select
        erg_compartment_id.facility_id,
        erg_compartment_id.tank_id,
        erg_compartment_id.compartment_id,
        row_number() over (
            partition by erg_compartment_id.facility_id, erg_compartment_id.tank_id
            order by erg_compartment_id.compartment_id
        ) as rn
    from ma_ust.erg_compartment_id
),
piping_map as (
    select
        erg_piping_id.facility_id,
        erg_piping_id.tank_id,
        erg_piping_id.compartment_id,
        erg_piping_id.piping_id,
        row_number() over (
            partition by erg_piping_id.facility_id, erg_piping_id.tank_id, erg_piping_id.compartment_id
            order by erg_piping_id.piping_id
        ) as rn
    from ma_ust.erg_piping_id
),
tank_top_sump as (
    select
        vw_erg_pipe_tank_top_sump."Facility ID#",
        vw_erg_pipe_tank_top_sump."TANK ID#",
        min(vw_erg_pipe_tank_top_sump.pipe_tank_top_sump)::character varying(7) as pipe_tank_top_sump
    from ma_ust.vw_erg_pipe_tank_top_sump
    group by vw_erg_pipe_tank_top_sump."Facility ID#", vw_erg_pipe_tank_top_sump."TANK ID#"
)
select
    src.facility_id,
    src.tank_id,
    id_map.compartment_id,
    piping_map.piping_id::character varying(50) as piping_id,
    c.piping_style_id,
    case when src."PIPE TYPE" = 'European suction system'::text then 'Yes'::text else null::text end as safe_suction,
    case when src."PIPE TYPE" = 'Non-European suction System'::text then 'Yes'::text else null::text end as american_suction,
    case when src."PIPE TYPE" = any (array['Pressurized piping system with electronic automatic line leak detection'::text, 'Pressurized piping system with mechanical automatic line leak detection'::text]) then 'Yes'::text else null::text end as high_pressure_or_bulk_piping,
    case when src."PIPE CONSTRUCT" = 'Single-walled metal (Corrosion protection required)'::text then 'Yes'::text else null::text end as piping_corrosion_protection_sacrificial_anode,
    case when src."LEAK CORROSION TYPE" = 'Field Constructed Impressed Current System'::text then 'Yes'::text else null::text end as piping_corrosion_protection_impressed_current,
    case when src."PIPE LEAK DETECT" is not null then 'Yes'::text else null::text end as piping_line_leak_detector,
    case when src."PIPE LEAK DETECT" = 'Annual Automatic Line Leak Detection Test'::text then 'Yes'::text else null::text end as piping_line_test_annual,
    case when src."PIPE LEAK DETECT" = 'Continuous Interstitial Space Monitoring'::text then 'Yes'::text else null::text end as piping_interstitial_monitoring,
    case when src."PIPE LEAK DETECT" = 'In-tank monitoring with SIR (if installed prior to May 28, 1999)'::text then 'Yes'::text else null::text end as piping_statistical_inventory_reconciliation,
    case when src."PIPE LEAK DETECT" = any (array['Annual tightness test of Non-European suction systems (only if installed prior to 1/1/1989) without '::text, 'Annual Tightness Test of Single-Walled Pressurized Piping Systems'::text, 'Quarterly visual inspection and annual product line tightness test (only if installed prior to 5/28/'::text]) then 'Yes'::text else null::text end as piping_release_detection_other,
    tank_top_sump.pipe_tank_top_sump,
    d.piping_wall_type_id
from src
join id_map on src.facility_id::text = id_map.facility_id::text and src.tank_id = id_map.tank_id and src.rn = id_map.rn
join piping_map on id_map.facility_id::text = piping_map.facility_id::text and id_map.tank_id = piping_map.tank_id and id_map.compartment_id = piping_map.compartment_id
left join ma_ust.v_piping_style_xwalk c on src."PIPE TYPE" = c.organization_value::text
left join ma_ust.v_piping_wall_type_xwalk d on src."PIPE CONSTRUCT" = d.organization_value::text
left join tank_top_sump on src."Facility ID#" = tank_top_sump."Facility ID#" and src."TANK ID#" = tank_top_sump."TANK ID#"
;


create or replace view ma_ust.v_ust_facility_dispenser as
select distinct
    a."Facility ID#"::character varying(50) as facility_id,
    a.dispenser_number::character varying(50) as dispenser_id
from ma_ust."Dispenser info" a
where not exists (
        select 1
        from ma_ust.erg_unregulated_tanks unreg
        where a."Facility ID#"::character varying(50)::text = unreg.facility_id::text
    )
  and not exists (
        select 1
        from ma_ust.erg_unregulated_facilities unreg_fac
        where a."Facility ID#"::character varying(50)::text = unreg_fac.facility_id::text
    )
  and exists (
        select 1
        from ma_ust.v_ust_facility fac
        where a."Facility ID#"::character varying(50)::text = fac.facility_id::text
    )
;
