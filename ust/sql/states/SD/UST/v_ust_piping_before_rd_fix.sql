create or replace view sd_ust.v_ust_piping as
 WITH mapped AS MATERIALIZED (
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
 SELECT m.facility_id,
    m.tank_id,
    m.compartment_id,
    m.piping_id,
        CASE
            WHEN count(DISTINCT m.piping_style_id) <= 1 THEN max(m.piping_style_id)
            ELSE NULL::integer
        END AS piping_style_id,
        CASE
            WHEN count(DISTINCT m.safe_suction) <= 1 THEN max(m.safe_suction)
            ELSE NULL::text
        END AS safe_suction,
        CASE
            WHEN count(DISTINCT m.high_pressure_or_bulk_piping) <= 1 THEN max(m.high_pressure_or_bulk_piping)
            ELSE NULL::text
        END AS high_pressure_or_bulk_piping,
        CASE
            WHEN count(DISTINCT m.piping_material_frp) <= 1 THEN max(m.piping_material_frp)
            ELSE NULL::text
        END AS piping_material_frp,
        CASE
            WHEN count(DISTINCT m.piping_material_gal_steel) <= 1 THEN max(m.piping_material_gal_steel)
            ELSE NULL::text
        END AS piping_material_gal_steel,
        CASE
            WHEN count(DISTINCT m.piping_material_stainless_steel) <= 1 THEN max(m.piping_material_stainless_steel)
            ELSE NULL::text
        END AS piping_material_stainless_steel,
        CASE
            WHEN count(DISTINCT m.piping_material_steel) <= 1 THEN max(m.piping_material_steel)
            ELSE NULL::text
        END AS piping_material_steel,
        CASE
            WHEN count(DISTINCT m.piping_material_copper) <= 1 THEN max(m.piping_material_copper)
            ELSE NULL::text
        END AS piping_material_copper,
        CASE
            WHEN count(DISTINCT m.piping_material_flex) <= 1 THEN max(m.piping_material_flex)
            ELSE NULL::text
        END AS piping_material_flex,
        CASE
            WHEN count(DISTINCT m.piping_material_no_piping) <= 1 THEN max(m.piping_material_no_piping)
            ELSE NULL::text
        END AS piping_material_no_piping,
        CASE
            WHEN count(DISTINCT m.piping_material_unknown) <= 1 THEN max(m.piping_material_unknown)
            ELSE NULL::text
        END AS piping_material_unknown,
        CASE
            WHEN count(DISTINCT m.piping_corrosion_protection_sacrificial_anode) <= 1 THEN max(m.piping_corrosion_protection_sacrificial_anode)
            ELSE NULL::text
        END AS piping_corrosion_protection_sacrificial_anode,
        CASE
            WHEN count(DISTINCT m.piping_line_leak_detector) <= 1 THEN max(m.piping_line_leak_detector)
            ELSE NULL::text
        END AS piping_line_leak_detector,
        CASE
            WHEN count(DISTINCT m.piping_line_test_annual) <= 1 THEN max(m.piping_line_test_annual)
            ELSE NULL::text
        END AS piping_line_test_annual,
        CASE
            WHEN count(DISTINCT m.piping_line_test3yr) <= 1 THEN max(m.piping_line_test3yr)
            ELSE NULL::text
        END AS piping_line_test3yr,
        CASE
            WHEN count(DISTINCT m.piping_groundwater_monitoring) <= 1 THEN max(m.piping_groundwater_monitoring)
            ELSE NULL::text
        END AS piping_groundwater_monitoring,
        CASE
            WHEN count(DISTINCT m.piping_vapor_monitoring) <= 1 THEN max(m.piping_vapor_monitoring)
            ELSE NULL::text
        END AS piping_vapor_monitoring,
        CASE
            WHEN count(DISTINCT m.piping_interstitial_monitoring) <= 1 THEN max(m.piping_interstitial_monitoring)
            ELSE NULL::text
        END AS piping_interstitial_monitoring,
        CASE
            WHEN count(DISTINCT m.piping_statistical_inventory_reconciliation) <= 1 THEN max(m.piping_statistical_inventory_reconciliation)
            ELSE NULL::text
        END AS piping_statistical_inventory_reconciliation,
        CASE
            WHEN count(DISTINCT m.piping_wall_type_id) <= 1 THEN max(m.piping_wall_type_id)
            ELSE NULL::integer
        END AS piping_wall_type_id,
        CASE
            WHEN count(DISTINCT m.pipe_secondary_containment_other) <= 1 THEN max(m.pipe_secondary_containment_other)
            ELSE NULL::text
        END AS pipe_secondary_containment_other
   FROM mapped m
  GROUP BY m.facility_id, m.tank_id, m.compartment_id, m.piping_id;