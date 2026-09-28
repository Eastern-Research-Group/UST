-- SUPERSEDED: use SD_UST_reconcile_erg_keys.sql; do not reapply the old normalized joins.
-- Preserve existing compartment IDs; reconcile formatting in the lookup only.
-- Run before regenerating/applying the compartment view; regeneration can replace
-- the custom facility-ID normalization below.
begin;
set local lock_timeout = '5s';
lock table sd_ust.erg_compartment in share row exclusive mode;
insert into sd_ust.erg_compartment (facility_id, tank_id)
select min(v.facility_id), v.tank_id
from sd_ust.v_ust_compartment v
where v.tank_id is not null
  and not exists (
    select 1 from sd_ust.erg_compartment e
    where nullif(ltrim(replace(trim(e.facility_id), '-', ''), '0'), '')
        = nullif(ltrim(replace(trim(v.facility_id), '-', ''), '0'), '')
      and e.tank_id = v.tank_id
  )
group by nullif(ltrim(replace(trim(v.facility_id), '-', ''), '0'), ''), v.tank_id
order by min(v.facility_id), v.tank_id;

create or replace view sd_ust.v_ust_compartment as
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
        END AND nullif(ltrim(replace(trim(a."FacilityNumber"), '-', ''), '0'), '') = nullif(ltrim(replace(trim(b.facility_id::text), '-', ''), '0'), '')
     LEFT JOIN sd_ust.v_compartment_status_xwalk c ON a."StatusName" = c.organization_value::text
  WHERE a."TankNumber" is not null AND NOT (EXISTS ( SELECT 1
           FROM sd_ust.erg_unregulated_facilities unreg_fac
          WHERE NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text) = unreg_fac.facility_id::text)) AND NOT (EXISTS ( SELECT 1
           FROM sd_ust.erg_unregulated_tanks unreg_tank
          WHERE NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text) = unreg_tank.facility_id::text AND
                CASE
                    WHEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text) ~ '^[+-]?\d+$'::text THEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text)::integer
                    ELSE NULL::integer
                END = unreg_tank.tank_id)) AND (EXISTS ( SELECT 1
           FROM sd_ust.v_ust_facility parent
          WHERE parent.facility_id::text = NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text))) AND COALESCE(c.exclude_from_query, 'N'::character varying)::text <> 'Y'::text;
select count(*) as rows,
       count(*) filter(where compartment_id is null) as null_compartment_ids,
       count(*) filter(where tank_id is null) as null_tank_ids
from sd_ust.v_ust_compartment;
commit;
