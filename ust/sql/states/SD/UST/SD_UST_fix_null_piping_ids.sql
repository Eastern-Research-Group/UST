-- SUPERSEDED: use SD_UST_reconcile_erg_keys.sql; do not reapply the old normalized joins.
-- Preserve IDs, add missing compartment piping mappings, and require valid parent compartments.
-- Reapply after generation if custom joins are overwritten.
begin;
set local lock_timeout = '5s';
lock table sd_ust.erg_piping in share row exclusive mode;
insert into sd_ust.erg_piping (facility_id,tank_id,compartment_id)
select distinct v.facility_id,v.tank_id,v.compartment_id
from sd_ust.v_ust_compartment v
where not exists (
 select 1 from sd_ust.erg_piping p
 where nullif(ltrim(replace(trim(p.facility_id), '-', ''), '0'), '')
     = nullif(ltrim(replace(trim(v.facility_id), '-', ''), '0'), '')
   and p.tank_id=v.tank_id and p.compartment_id=v.compartment_id
)
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
     LEFT JOIN sd_ust.erg_piping c ON
        CASE
            WHEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text) ~ '^[+-]?\d+$'::text THEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text)::integer
            ELSE NULL::integer
        END =
        CASE
            WHEN NULLIF(TRIM(BOTH FROM c.tank_id::text), ''::text) ~ '^[+-]?\d+$'::text THEN NULLIF(TRIM(BOTH FROM c.tank_id::text), ''::text)::integer
            ELSE NULL::integer
        END AND nullif(ltrim(replace(trim(a."FacilityNumber"), '-', ''), '0'), '') = nullif(ltrim(replace(trim(c.facility_id::text), '-', ''), '0'), '')
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
          WHERE parent.facility_id::text = NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text))) AND COALESCE(d.exclude_from_query, 'N'::character varying)::text <> 'Y'::text AND COALESCE(e.exclude_from_query, 'N'::character varying)::text <> 'Y'::text AND EXISTS (
 select 1 from valid_compartments parent_compartment
 where parent_compartment.facility_id = nullif(trim(a."FacilityNumber"), '')
   and parent_compartment.tank_id = c.tank_id
   and parent_compartment.compartment_id = c.compartment_id
);

commit;
