-- Resolve source duplicate keys without renumbering IDs.
-- Status follows compartment_statuses.status_hierarchy; other conflicting known values become NULL.
-- Original duplicate source rows remain in review views.
-- Reapply after regeneration if custom rules are overwritten.
begin;
set local lock_timeout = '5s';

create or replace view sd_ust.v_compartment_duplicate_source_rows as
with mapped as materialized (
WITH valid_tanks AS MATERIALIZED (
         SELECT v_ust_tank.facility_id,
            v_ust_tank.tank_id
           FROM sd_ust.v_ust_tank
        )
 SELECT DISTINCT NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text)::character varying(50) AS facility_id,
        CASE
            WHEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text) ~ '^[+-]?\d+$'::text THEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text)::integer
            ELSE NULL::integer
        END AS tank_id,
    b.compartment_id,
    a."TankCompartmentNumber"::character varying(50) AS compartment_name,
    COALESCE(c.compartment_status_id, 8) AS compartment_status_id,
    a."TankCapacityAmount"::integer AS compartment_capacity_gallons,
        CASE
            WHEN NULLIF(TRIM(BOTH FROM a."TankOverfillProtection"), ''::text) = 'Ball Float Valves'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_ball_float_valve,
        CASE
            WHEN NULLIF(TRIM(BOTH FROM a."TankOverfillProtection"), ''::text) = 'Automatic Shutoff Device'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_flow_shutoff_device,
        CASE
            WHEN NULLIF(TRIM(BOTH FROM a."TankOverfillProtection"), ''::text) = 'Overfill Alarm'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_high_level_alarm,
        CASE
            WHEN NULLIF(TRIM(BOTH FROM a."TankOverfillProtection"), ''::text) = 'Other'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_other,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankSpillProtection"), ''::text)) = ANY (ARRAY['true'::text, 't'::text, 'yes'::text, 'y'::text, '1'::text, '1.0'::text]) THEN 'Yes'::text
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankSpillProtection"), ''::text)) = ANY (ARRAY['false'::text, 'f'::text, 'no'::text, 'n'::text, '0'::text, '0.0'::text]) THEN 'No'::text
            ELSE NULL::text
        END AS spill_bucket_installed,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankReleaseDetection"), ''::text)) = ANY (ARRAY['secondary containment'::text, 'double walled'::text, 'interstitial monitoring'::text, 'concrete vault'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_interstitial_monitoring,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankReleaseDetection"), ''::text)) = ANY (ARRAY['in-tank monitor'::text, 'automatic tank gauging'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_automatic_tank_gauging_release_detection,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankReleaseDetection"), ''::text)) = 'manual gauging'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_manual_tank_gauging,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankReleaseDetection"), ''::text)) = 's.i.r.'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_statistical_inventory_reconciliation,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankReleaseDetection"), ''::text)) = ANY (ARRAY['tightness testing'::text, 'tanktightnesstesting'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_tightness_testing,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankReleaseDetection"), ''::text)) = 'inventory control'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_inventory_control,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankReleaseDetection"), ''::text)) = 'groundwater monitoring'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_groundwater_monitoring,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankReleaseDetection"), ''::text)) = 'vapor monitoring'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_vapor_monitoring,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankReleaseDetection"), ''::text)) = 'other'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_other_release_detection
   FROM sd_ust.tanks a
     LEFT JOIN sd_ust.erg_compartment b ON a."FacilityNumber" = b.facility_id::text AND a."TankNumber" = b.tank_id::double precision
     LEFT JOIN sd_ust.v_compartment_status_xwalk c ON a."StatusName" = c.organization_value::text
  WHERE a."TankNumber" IS NOT NULL AND NOT (EXISTS ( SELECT 1
           FROM sd_ust.erg_unregulated_facilities unreg_fac
          WHERE NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text) = unreg_fac.facility_id::text)) AND NOT (EXISTS ( SELECT 1
           FROM sd_ust.erg_unregulated_tanks unreg_tank
          WHERE NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text) = unreg_tank.facility_id::text AND
                CASE
                    WHEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text) ~ '^[+-]?\d+$'::text THEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text)::integer
                    ELSE NULL::integer
                END = unreg_tank.tank_id)) AND (EXISTS ( SELECT 1
           FROM sd_ust.v_ust_facility parent
          WHERE parent.facility_id::text = NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text))) AND COALESCE(c.exclude_from_query, 'N'::character varying)::text <> 'Y'::text AND (EXISTS ( SELECT 1
           FROM valid_tanks tank_parent
          WHERE tank_parent.facility_id::text = NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text) AND tank_parent.tank_id =
                CASE
                    WHEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text) ~ '^[+-]?\d+$'::text THEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text)::integer
                    ELSE NULL::integer
                END))
) select m.* from mapped m join (select facility_id, tank_id, compartment_id from mapped group by facility_id, tank_id, compartment_id having count(*)>1) d using (facility_id, tank_id, compartment_id);

create or replace view sd_ust.v_ust_compartment as
with mapped as materialized (
WITH valid_tanks AS MATERIALIZED (
         SELECT v_ust_tank.facility_id,
            v_ust_tank.tank_id
           FROM sd_ust.v_ust_tank
        )
 SELECT DISTINCT NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text)::character varying(50) AS facility_id,
        CASE
            WHEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text) ~ '^[+-]?\d+$'::text THEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text)::integer
            ELSE NULL::integer
        END AS tank_id,
    b.compartment_id,
    a."TankCompartmentNumber"::character varying(50) AS compartment_name,
    COALESCE(c.compartment_status_id, 8) AS compartment_status_id,
    a."TankCapacityAmount"::integer AS compartment_capacity_gallons,
        CASE
            WHEN NULLIF(TRIM(BOTH FROM a."TankOverfillProtection"), ''::text) = 'Ball Float Valves'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_ball_float_valve,
        CASE
            WHEN NULLIF(TRIM(BOTH FROM a."TankOverfillProtection"), ''::text) = 'Automatic Shutoff Device'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_flow_shutoff_device,
        CASE
            WHEN NULLIF(TRIM(BOTH FROM a."TankOverfillProtection"), ''::text) = 'Overfill Alarm'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_high_level_alarm,
        CASE
            WHEN NULLIF(TRIM(BOTH FROM a."TankOverfillProtection"), ''::text) = 'Other'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_other,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankSpillProtection"), ''::text)) = ANY (ARRAY['true'::text, 't'::text, 'yes'::text, 'y'::text, '1'::text, '1.0'::text]) THEN 'Yes'::text
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankSpillProtection"), ''::text)) = ANY (ARRAY['false'::text, 'f'::text, 'no'::text, 'n'::text, '0'::text, '0.0'::text]) THEN 'No'::text
            ELSE NULL::text
        END AS spill_bucket_installed,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankReleaseDetection"), ''::text)) = ANY (ARRAY['secondary containment'::text, 'double walled'::text, 'interstitial monitoring'::text, 'concrete vault'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_interstitial_monitoring,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankReleaseDetection"), ''::text)) = ANY (ARRAY['in-tank monitor'::text, 'automatic tank gauging'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_automatic_tank_gauging_release_detection,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankReleaseDetection"), ''::text)) = 'manual gauging'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_manual_tank_gauging,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankReleaseDetection"), ''::text)) = 's.i.r.'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_statistical_inventory_reconciliation,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankReleaseDetection"), ''::text)) = ANY (ARRAY['tightness testing'::text, 'tanktightnesstesting'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_tightness_testing,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankReleaseDetection"), ''::text)) = 'inventory control'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_inventory_control,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankReleaseDetection"), ''::text)) = 'groundwater monitoring'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_groundwater_monitoring,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankReleaseDetection"), ''::text)) = 'vapor monitoring'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_vapor_monitoring,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankReleaseDetection"), ''::text)) = 'other'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_other_release_detection
   FROM sd_ust.tanks a
     LEFT JOIN sd_ust.erg_compartment b ON a."FacilityNumber" = b.facility_id::text AND a."TankNumber" = b.tank_id::double precision
     LEFT JOIN sd_ust.v_compartment_status_xwalk c ON a."StatusName" = c.organization_value::text
  WHERE a."TankNumber" IS NOT NULL AND NOT (EXISTS ( SELECT 1
           FROM sd_ust.erg_unregulated_facilities unreg_fac
          WHERE NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text) = unreg_fac.facility_id::text)) AND NOT (EXISTS ( SELECT 1
           FROM sd_ust.erg_unregulated_tanks unreg_tank
          WHERE NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text) = unreg_tank.facility_id::text AND
                CASE
                    WHEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text) ~ '^[+-]?\d+$'::text THEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text)::integer
                    ELSE NULL::integer
                END = unreg_tank.tank_id)) AND (EXISTS ( SELECT 1
           FROM sd_ust.v_ust_facility parent
          WHERE parent.facility_id::text = NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text))) AND COALESCE(c.exclude_from_query, 'N'::character varying)::text <> 'Y'::text AND (EXISTS ( SELECT 1
           FROM valid_tanks tank_parent
          WHERE tank_parent.facility_id::text = NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text) AND tank_parent.tank_id =
                CASE
                    WHEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text) ~ '^[+-]?\d+$'::text THEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text)::integer
                    ELSE NULL::integer
                END))
)
select facility_id,
tank_id,
compartment_id,
(case when count(distinct compartment_name) <= 1 then max(compartment_name) else null end)::character varying(50) as compartment_name,
(array_agg(compartment_status_id order by
 (select status_hierarchy from public.compartment_statuses s where s.compartment_status_id=m.compartment_status_id) nulls last,
 compartment_status_id))[1]::integer as compartment_status_id,
(case when count(distinct compartment_capacity_gallons) <= 1 then max(compartment_capacity_gallons) else null end)::integer as compartment_capacity_gallons,
(case when count(distinct overfill_prevention_ball_float_valve) <= 1 then max(overfill_prevention_ball_float_valve) else null end)::text as overfill_prevention_ball_float_valve,
(case when count(distinct overfill_prevention_flow_shutoff_device) <= 1 then max(overfill_prevention_flow_shutoff_device) else null end)::text as overfill_prevention_flow_shutoff_device,
(case when count(distinct overfill_prevention_high_level_alarm) <= 1 then max(overfill_prevention_high_level_alarm) else null end)::text as overfill_prevention_high_level_alarm,
(case when count(distinct overfill_prevention_other) <= 1 then max(overfill_prevention_other) else null end)::text as overfill_prevention_other,
(case when count(distinct spill_bucket_installed) <= 1 then max(spill_bucket_installed) else null end)::text as spill_bucket_installed,
(case when count(distinct tank_interstitial_monitoring) <= 1 then max(tank_interstitial_monitoring) else null end)::text as tank_interstitial_monitoring,
(case when count(distinct tank_automatic_tank_gauging_release_detection) <= 1 then max(tank_automatic_tank_gauging_release_detection) else null end)::text as tank_automatic_tank_gauging_release_detection,
(case when count(distinct tank_manual_tank_gauging) <= 1 then max(tank_manual_tank_gauging) else null end)::text as tank_manual_tank_gauging,
(case when count(distinct tank_statistical_inventory_reconciliation) <= 1 then max(tank_statistical_inventory_reconciliation) else null end)::text as tank_statistical_inventory_reconciliation,
(case when count(distinct tank_tightness_testing) <= 1 then max(tank_tightness_testing) else null end)::text as tank_tightness_testing,
(case when count(distinct tank_inventory_control) <= 1 then max(tank_inventory_control) else null end)::text as tank_inventory_control,
(case when count(distinct tank_groundwater_monitoring) <= 1 then max(tank_groundwater_monitoring) else null end)::text as tank_groundwater_monitoring,
(case when count(distinct tank_vapor_monitoring) <= 1 then max(tank_vapor_monitoring) else null end)::text as tank_vapor_monitoring,
(case when count(distinct tank_other_release_detection) <= 1 then max(tank_other_release_detection) else null end)::text as tank_other_release_detection
from mapped m
group by facility_id, tank_id, compartment_id;

create or replace view sd_ust.v_piping_duplicate_source_rows as
with mapped as materialized (
WITH valid_compartments AS MATERIALIZED (
         SELECT DISTINCT v_ust_compartment.facility_id,
            v_ust_compartment.tank_id,
            v_ust_compartment.compartment_id
           FROM sd_ust.v_ust_compartment
        )
 SELECT DISTINCT NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text)::character varying(50) AS facility_id,
        CASE
            WHEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text) ~ '^[+-]?\d+$'::text THEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text)::integer
            ELSE NULL::integer
        END AS tank_id,
        CASE
            WHEN NULLIF(TRIM(BOTH FROM c.compartment_id::text), ''::text) ~ '^[+-]?\d+$'::text THEN NULLIF(TRIM(BOTH FROM c.compartment_id::text), ''::text)::integer
            ELSE NULL::integer
        END AS compartment_id,
    c.piping_id::character varying(50) AS piping_id,
    d.piping_style_id,
        CASE
            WHEN NULLIF(TRIM(BOTH FROM a."TankPipingType"), ''::text) = 'Safe Suction'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS safe_suction,
        CASE
            WHEN NULLIF(TRIM(BOTH FROM a."TankPipingType"), ''::text) = 'Pressure'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS high_pressure_or_bulk_piping,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankPipingMaterial"), ''::text)) ~~ '%fiberglass%'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_frp,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankPipingMaterial"), ''::text)) = ANY (ARRAY['galvanized steel'::text, 'steel - bare/galv'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_gal_steel,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankPipingMaterial"), ''::text)) = ANY (ARRAY['stainless steel'::text, 'pipingmaterialstainlesssteel'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_stainless_steel,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankPipingMaterial"), ''::text)) = ANY (ARRAY['black steel'::text, 'cath. protection'::text, 'cath. steel'::text, 'coated steel'::text, 'steel'::text, 'steel/aboveground'::text, 'steel/cont'::text, 'bare steel'::text, 'steel isolated'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_steel,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankPipingMaterial"), ''::text)) = ANY (ARRAY['copper'::text, 'copper -corr. prot.'::text, 'copper isolated'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_copper,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankPipingMaterial"), ''::text)) = ANY (ARRAY['dw ameron'::text, 'dw apt'::text, 'dw environ'::text, 'dw flex'::text, 'dw marinaflex'::text, 'dw opw'::text, 'dw poly'::text, 'sw ameron'::text, 'sw apt'::text, 'sw flex'::text, 'total containment'::text, 'flexible'::text, 'flexible plastic'::text, 'flex piping'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_flex,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankPipingMaterial"), ''::text)) = ANY (ARRAY['none'::text, 'not applicable'::text, 'pipingmaterialnopiping'::text, 'no piping'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_no_piping,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankPipingMaterial"), ''::text)) = 'unknown'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_unknown,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankPipingMaterial"), ''::text)) = ANY (ARRAY['cath. protection'::text, 'cath. steel'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_corrosion_protection_sacrificial_anode,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankPipingReleaseDetection"), ''::text)) = ANY (ARRAY['campo/miller lld'::text, 'electronic lld'::text, 'incon lld'::text, 'mechanical lld'::text, 'ppm 4000'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_line_leak_detector,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM b.annual_tightness_testing), ''::text)) = 'tightness testing'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_line_test_annual,
        CASE
            WHEN NULLIF(TRIM(BOTH FROM b.three_year_tightness_testing), ''::text) = 'Tightness Testing'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_line_test3yr,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankPipingReleaseDetection"), ''::text)) = 'groundwater monitoring'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_groundwater_monitoring,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankPipingReleaseDetection"), ''::text)) = 'vapor monitoring'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_vapor_monitoring,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankPipingReleaseDetection"), ''::text)) = ANY (ARRAY['secondary containment'::text, 'sump sensor'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_interstitial_monitoring,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankPipingReleaseDetection"), ''::text)) = 's.i.r.'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_statistical_inventory_reconciliation,
    e.piping_wall_type_id,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankPipingReleaseDetection"), ''::text)) = ANY (ARRAY['secondary containment'::text, 'concrete containment'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS pipe_secondary_containment_other
   FROM sd_ust.tanks a
     LEFT JOIN sd_ust.v_piping_tightness_testing b ON a."TankPipingType" = b."TankPipingType" AND a."TankPipingReleaseDetection" = b."TankPipingReleaseDetection"
     JOIN sd_ust.erg_piping c ON a."FacilityNumber" = c.facility_id::text AND a."TankNumber" = c.tank_id::double precision
     JOIN valid_compartments pc ON pc.facility_id::text = c.facility_id::text AND pc.tank_id = c.tank_id AND pc.compartment_id = c.compartment_id
     LEFT JOIN sd_ust.v_piping_style_xwalk d ON a."TankPipingType" = d.organization_value::text
     LEFT JOIN sd_ust.v_piping_wall_type_xwalk e ON a."TankPipingMaterial" = e.organization_value::text
  WHERE NOT (EXISTS ( SELECT 1
           FROM sd_ust.erg_unregulated_facilities unreg_fac
          WHERE NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text) = unreg_fac.facility_id::text)) AND NOT (EXISTS ( SELECT 1
           FROM sd_ust.erg_unregulated_tanks unreg_tank
          WHERE NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text) = unreg_tank.facility_id::text AND
                CASE
                    WHEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text) ~ '^[+-]?\d+$'::text THEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text)::integer
                    ELSE NULL::integer
                END = unreg_tank.tank_id)) AND (EXISTS ( SELECT 1
           FROM sd_ust.v_ust_facility parent
          WHERE parent.facility_id::text = NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text))) AND COALESCE(d.exclude_from_query, 'N'::character varying)::text <> 'Y'::text AND COALESCE(e.exclude_from_query, 'N'::character varying)::text <> 'Y'::text
) select m.* from mapped m join (select facility_id, tank_id, compartment_id, piping_id from mapped group by facility_id, tank_id, compartment_id, piping_id having count(*)>1) d using (facility_id, tank_id, compartment_id, piping_id);

create or replace view sd_ust.v_ust_piping as
with mapped as materialized (
WITH valid_compartments AS MATERIALIZED (
         SELECT DISTINCT v_ust_compartment.facility_id,
            v_ust_compartment.tank_id,
            v_ust_compartment.compartment_id
           FROM sd_ust.v_ust_compartment
        )
 SELECT DISTINCT NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text)::character varying(50) AS facility_id,
        CASE
            WHEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text) ~ '^[+-]?\d+$'::text THEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text)::integer
            ELSE NULL::integer
        END AS tank_id,
        CASE
            WHEN NULLIF(TRIM(BOTH FROM c.compartment_id::text), ''::text) ~ '^[+-]?\d+$'::text THEN NULLIF(TRIM(BOTH FROM c.compartment_id::text), ''::text)::integer
            ELSE NULL::integer
        END AS compartment_id,
    c.piping_id::character varying(50) AS piping_id,
    d.piping_style_id,
        CASE
            WHEN NULLIF(TRIM(BOTH FROM a."TankPipingType"), ''::text) = 'Safe Suction'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS safe_suction,
        CASE
            WHEN NULLIF(TRIM(BOTH FROM a."TankPipingType"), ''::text) = 'Pressure'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS high_pressure_or_bulk_piping,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankPipingMaterial"), ''::text)) ~~ '%fiberglass%'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_frp,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankPipingMaterial"), ''::text)) = ANY (ARRAY['galvanized steel'::text, 'steel - bare/galv'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_gal_steel,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankPipingMaterial"), ''::text)) = ANY (ARRAY['stainless steel'::text, 'pipingmaterialstainlesssteel'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_stainless_steel,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankPipingMaterial"), ''::text)) = ANY (ARRAY['black steel'::text, 'cath. protection'::text, 'cath. steel'::text, 'coated steel'::text, 'steel'::text, 'steel/aboveground'::text, 'steel/cont'::text, 'bare steel'::text, 'steel isolated'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_steel,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankPipingMaterial"), ''::text)) = ANY (ARRAY['copper'::text, 'copper -corr. prot.'::text, 'copper isolated'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_copper,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankPipingMaterial"), ''::text)) = ANY (ARRAY['dw ameron'::text, 'dw apt'::text, 'dw environ'::text, 'dw flex'::text, 'dw marinaflex'::text, 'dw opw'::text, 'dw poly'::text, 'sw ameron'::text, 'sw apt'::text, 'sw flex'::text, 'total containment'::text, 'flexible'::text, 'flexible plastic'::text, 'flex piping'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_flex,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankPipingMaterial"), ''::text)) = ANY (ARRAY['none'::text, 'not applicable'::text, 'pipingmaterialnopiping'::text, 'no piping'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_no_piping,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankPipingMaterial"), ''::text)) = 'unknown'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_unknown,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankPipingMaterial"), ''::text)) = ANY (ARRAY['cath. protection'::text, 'cath. steel'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_corrosion_protection_sacrificial_anode,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankPipingReleaseDetection"), ''::text)) = ANY (ARRAY['campo/miller lld'::text, 'electronic lld'::text, 'incon lld'::text, 'mechanical lld'::text, 'ppm 4000'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_line_leak_detector,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM b.annual_tightness_testing), ''::text)) = 'tightness testing'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_line_test_annual,
        CASE
            WHEN NULLIF(TRIM(BOTH FROM b.three_year_tightness_testing), ''::text) = 'Tightness Testing'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_line_test3yr,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankPipingReleaseDetection"), ''::text)) = 'groundwater monitoring'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_groundwater_monitoring,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankPipingReleaseDetection"), ''::text)) = 'vapor monitoring'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_vapor_monitoring,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankPipingReleaseDetection"), ''::text)) = ANY (ARRAY['secondary containment'::text, 'sump sensor'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_interstitial_monitoring,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankPipingReleaseDetection"), ''::text)) = 's.i.r.'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_statistical_inventory_reconciliation,
    e.piping_wall_type_id,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankPipingReleaseDetection"), ''::text)) = ANY (ARRAY['secondary containment'::text, 'concrete containment'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS pipe_secondary_containment_other
   FROM sd_ust.tanks a
     LEFT JOIN sd_ust.v_piping_tightness_testing b ON a."TankPipingType" = b."TankPipingType" AND a."TankPipingReleaseDetection" = b."TankPipingReleaseDetection"
     JOIN sd_ust.erg_piping c ON a."FacilityNumber" = c.facility_id::text AND a."TankNumber" = c.tank_id::double precision
     JOIN valid_compartments pc ON pc.facility_id::text = c.facility_id::text AND pc.tank_id = c.tank_id AND pc.compartment_id = c.compartment_id
     LEFT JOIN sd_ust.v_piping_style_xwalk d ON a."TankPipingType" = d.organization_value::text
     LEFT JOIN sd_ust.v_piping_wall_type_xwalk e ON a."TankPipingMaterial" = e.organization_value::text
  WHERE NOT (EXISTS ( SELECT 1
           FROM sd_ust.erg_unregulated_facilities unreg_fac
          WHERE NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text) = unreg_fac.facility_id::text)) AND NOT (EXISTS ( SELECT 1
           FROM sd_ust.erg_unregulated_tanks unreg_tank
          WHERE NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text) = unreg_tank.facility_id::text AND
                CASE
                    WHEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text) ~ '^[+-]?\d+$'::text THEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text)::integer
                    ELSE NULL::integer
                END = unreg_tank.tank_id)) AND (EXISTS ( SELECT 1
           FROM sd_ust.v_ust_facility parent
          WHERE parent.facility_id::text = NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text))) AND COALESCE(d.exclude_from_query, 'N'::character varying)::text <> 'Y'::text AND COALESCE(e.exclude_from_query, 'N'::character varying)::text <> 'Y'::text
)
select facility_id,
tank_id,
compartment_id,
piping_id,
(case when count(distinct piping_style_id) <= 1 then max(piping_style_id) else null end)::integer as piping_style_id,
(case when count(distinct safe_suction) <= 1 then max(safe_suction) else null end)::text as safe_suction,
(case when count(distinct high_pressure_or_bulk_piping) <= 1 then max(high_pressure_or_bulk_piping) else null end)::text as high_pressure_or_bulk_piping,
(case when count(distinct piping_material_frp) <= 1 then max(piping_material_frp) else null end)::text as piping_material_frp,
(case when count(distinct piping_material_gal_steel) <= 1 then max(piping_material_gal_steel) else null end)::text as piping_material_gal_steel,
(case when count(distinct piping_material_stainless_steel) <= 1 then max(piping_material_stainless_steel) else null end)::text as piping_material_stainless_steel,
(case when count(distinct piping_material_steel) <= 1 then max(piping_material_steel) else null end)::text as piping_material_steel,
(case when count(distinct piping_material_copper) <= 1 then max(piping_material_copper) else null end)::text as piping_material_copper,
(case when count(distinct piping_material_flex) <= 1 then max(piping_material_flex) else null end)::text as piping_material_flex,
(case when count(distinct piping_material_no_piping) <= 1 then max(piping_material_no_piping) else null end)::text as piping_material_no_piping,
(case when count(distinct piping_material_unknown) <= 1 then max(piping_material_unknown) else null end)::text as piping_material_unknown,
(case when count(distinct piping_corrosion_protection_sacrificial_anode) <= 1 then max(piping_corrosion_protection_sacrificial_anode) else null end)::text as piping_corrosion_protection_sacrificial_anode,
(case when count(distinct piping_line_leak_detector) <= 1 then max(piping_line_leak_detector) else null end)::text as piping_line_leak_detector,
(case when count(distinct piping_line_test_annual) <= 1 then max(piping_line_test_annual) else null end)::text as piping_line_test_annual,
(case when count(distinct piping_line_test3yr) <= 1 then max(piping_line_test3yr) else null end)::text as piping_line_test3yr,
(case when count(distinct piping_groundwater_monitoring) <= 1 then max(piping_groundwater_monitoring) else null end)::text as piping_groundwater_monitoring,
(case when count(distinct piping_vapor_monitoring) <= 1 then max(piping_vapor_monitoring) else null end)::text as piping_vapor_monitoring,
(case when count(distinct piping_interstitial_monitoring) <= 1 then max(piping_interstitial_monitoring) else null end)::text as piping_interstitial_monitoring,
(case when count(distinct piping_statistical_inventory_reconciliation) <= 1 then max(piping_statistical_inventory_reconciliation) else null end)::text as piping_statistical_inventory_reconciliation,
(case when count(distinct piping_wall_type_id) <= 1 then max(piping_wall_type_id) else null end)::integer as piping_wall_type_id,
(case when count(distinct pipe_secondary_containment_other) <= 1 then max(pipe_secondary_containment_other) else null end)::text as pipe_secondary_containment_other
from mapped m
group by facility_id, tank_id, compartment_id, piping_id;
commit;
