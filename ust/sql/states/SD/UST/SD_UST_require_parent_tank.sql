-- Require matching facility/tank keys. Materialize parent keys once per query.
-- Reapply if generate-views overwrites these custom checks.
begin;
set local lock_timeout = '5s';

create or replace view sd_ust.v_ust_tank_substance as
with valid_tanks as materialized (
    select facility_id, tank_id from sd_ust.v_ust_tank
)
SELECT DISTINCT NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text)::character varying(50) AS facility_id,
        CASE
            WHEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text) ~ '^[+-]?\d+$'::text THEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text)::integer
            ELSE NULL::integer
        END AS tank_id,
    b.substance_id
   FROM sd_ust.tanks a
     LEFT JOIN sd_ust.v_substance_xwalk b ON a."TankProduct" = b.organization_value::text
  WHERE b.substance_id IS NOT NULL AND NOT (EXISTS ( SELECT 1
           FROM sd_ust.erg_unregulated_facilities unreg_fac
          WHERE NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text) = unreg_fac.facility_id::text)) AND NOT (EXISTS ( SELECT 1
           FROM sd_ust.erg_unregulated_tanks unreg_tank
          WHERE NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text) = unreg_tank.facility_id::text AND
                CASE
                    WHEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text) ~ '^[+-]?\d+$'::text THEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text)::integer
                    ELSE NULL::integer
                END = unreg_tank.tank_id)) AND (EXISTS ( SELECT 1
           FROM sd_ust.v_ust_facility parent
          WHERE parent.facility_id::text = NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text))) AND COALESCE(b.exclude_from_query, 'N'::character varying)::text <> 'Y'::text AND EXISTS (
    SELECT 1 FROM valid_tanks tank_parent
    WHERE tank_parent.facility_id = nullif(trim(a."FacilityNumber"::text), '')
      AND tank_parent.tank_id = CASE
          WHEN nullif(trim(a."TankNumber"::text), '') ~ '^[+-]?\d+$'
          THEN nullif(trim(a."TankNumber"::text), '')::integer
          ELSE null::integer END
);

create or replace view sd_ust.v_ust_compartment as
with valid_tanks as materialized (
    select facility_id, tank_id from sd_ust.v_ust_tank
)
SELECT DISTINCT NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text)::character varying(50) AS facility_id,
        CASE
            WHEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text) ~ '^[+-]?\d+$'::text THEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text)::integer
            ELSE NULL::integer
        END AS tank_id,
    b.compartment_id,
    a."TankCompartmentNumber"::character varying(50) AS compartment_name,
    c.compartment_status_id,
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
     LEFT JOIN sd_ust.erg_compartment b ON
        CASE
            WHEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text) ~ '^[+-]?\d+$'::text THEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text)::integer
            ELSE NULL::integer
        END =
        CASE
            WHEN NULLIF(TRIM(BOTH FROM b.tank_id::text), ''::text) ~ '^[+-]?\d+$'::text THEN NULLIF(TRIM(BOTH FROM b.tank_id::text), ''::text)::integer
            ELSE NULL::integer
        END AND NULLIF(ltrim(replace(TRIM(BOTH FROM a."FacilityNumber"), '-'::text, ''::text), '0'::text), ''::text) = NULLIF(ltrim(replace(TRIM(BOTH FROM b.facility_id::text), '-'::text, ''::text), '0'::text), ''::text)
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
          WHERE parent.facility_id::text = NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text))) AND COALESCE(c.exclude_from_query, 'N'::character varying)::text <> 'Y'::text AND EXISTS (
    SELECT 1 FROM valid_tanks tank_parent
    WHERE tank_parent.facility_id = nullif(trim(a."FacilityNumber"::text), '')
      AND tank_parent.tank_id = CASE
          WHEN nullif(trim(a."TankNumber"::text), '') ~ '^[+-]?\d+$'
          THEN nullif(trim(a."TankNumber"::text), '')::integer
          ELSE null::integer END
);

commit;
