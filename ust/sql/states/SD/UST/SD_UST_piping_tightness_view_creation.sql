-- Apply after SD_UST_piping_tightness_testing.sql. Preserves existing view fields.
begin;
set local lock_timeout = '5s';
create or replace view sd_ust.v_ust_piping as
 SELECT DISTINCT NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text)::character varying(50) AS facility_id,
        CASE
            WHEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text) ~ '^[+-]?\d+$'::text THEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text)::integer
            ELSE NULL::integer
        END AS tank_id,
        CASE
            WHEN NULLIF(TRIM(BOTH FROM b.compartment_id::text), ''::text) ~ '^[+-]?\d+$'::text THEN NULLIF(TRIM(BOTH FROM b.compartment_id::text), ''::text)::integer
            ELSE NULL::integer
        END AS compartment_id,
    b.piping_id::character varying(50) AS piping_id,
    c.piping_style_id,
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
        CASE WHEN tt.annual_tightness_testing = 'Tightness Testing' THEN 'Yes'::text ELSE NULL::text END AS piping_line_test_annual,
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
    d.piping_wall_type_id,
        CASE
            WHEN lower(NULLIF(TRIM(BOTH FROM a."TankPipingReleaseDetection"), ''::text)) = ANY (ARRAY['secondary containment'::text, 'concrete containment'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS pipe_secondary_containment_other,
    CASE WHEN tt.three_year_tightness_testing = 'Tightness Testing' THEN 'Yes'::text ELSE NULL::text END AS piping_line_test3yr
   FROM sd_ust.tanks a
     LEFT JOIN sd_ust.erg_piping b ON
        CASE
            WHEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text) ~ '^[+-]?\d+$'::text THEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text)::integer
            ELSE NULL::integer
        END = b.tank_id AND NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text) = b.facility_id::text
     LEFT JOIN sd_ust.v_piping_style_xwalk c ON a."TankPipingType" = c.organization_value::text
     LEFT JOIN sd_ust.v_piping_wall_type_xwalk d ON a."TankPipingMaterial" = d.organization_value::text
     LEFT JOIN sd_ust.v_piping_tightness_testing tt
       ON a."TankPipingType" = tt."TankPipingType"
      AND a."TankPipingReleaseDetection" = tt."TankPipingReleaseDetection"
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
          WHERE parent.facility_id::text = NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text)));
commit;
