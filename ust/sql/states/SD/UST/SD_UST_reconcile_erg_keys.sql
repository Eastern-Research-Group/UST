-- Exact source keys: hyphenated and unhyphenated facility IDs both exist.
-- Preserve existing IDs; add missing lookups instead of merging facility keys.
-- Supersedes SD_UST_fix_null_compartment_ids.sql and SD_UST_fix_null_piping_ids.sql.
begin;
set local lock_timeout = '5s';

lock table sd_ust.erg_compartment, sd_ust.erg_piping in share row exclusive mode;

create index if not exists ix_erg_compartment_exact_keys on sd_ust.erg_compartment (facility_id,tank_id);

create index if not exists ix_erg_piping_exact_keys on sd_ust.erg_piping (facility_id,tank_id,compartment_id);

insert into sd_ust.erg_compartment (facility_id,tank_id)
select facility_id,tank_id from sd_ust.v_ust_tank v
where not exists(select 1 from sd_ust.erg_compartment e where e.facility_id=v.facility_id and e.tank_id=v.tank_id)
order by 1,2;

create or replace view sd_ust.v_ust_compartment as
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
     LEFT JOIN sd_ust.erg_compartment b ON a."FacilityNumber"=b.facility_id AND a."TankNumber"=b.tank_id
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
                END));

insert into sd_ust.erg_piping (facility_id,tank_id,compartment_id)
select distinct facility_id,tank_id,compartment_id from sd_ust.v_ust_compartment v
where not exists(select 1 from sd_ust.erg_piping p where p.facility_id=v.facility_id and p.tank_id=v.tank_id and p.compartment_id=v.compartment_id)
order by 1,2,3;

create or replace view sd_ust.v_ust_piping as
with valid_compartments as materialized (select distinct facility_id,tank_id,compartment_id from sd_ust.v_ust_compartment)
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
     JOIN sd_ust.erg_piping c ON a."FacilityNumber"=c.facility_id AND a."TankNumber"=c.tank_id
     JOIN valid_compartments pc ON pc.facility_id=c.facility_id AND pc.tank_id=c.tank_id AND pc.compartment_id=c.compartment_id
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
          WHERE parent.facility_id::text = NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text))) AND COALESCE(d.exclude_from_query, 'N'::character varying)::text <> 'Y'::text AND COALESCE(e.exclude_from_query, 'N'::character varying)::text <> 'Y'::text;
commit;
