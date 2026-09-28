-- Saved custom SD UST view definitions. Reapply after generate-views if needed.
create or replace view sd_ust.v_piping_tightness_testing as
 SELECT DISTINCT tanks."TankPipingType",
    tanks."TankPipingReleaseDetection",
        CASE
            WHEN TRIM(BOTH FROM tanks."TankPipingReleaseDetection") = 'Tightness Testing'::text AND TRIM(BOTH FROM tanks."TankPipingType") = 'Pressure'::text THEN 'Tightness Testing'::text
            ELSE NULL::text
        END AS annual_tightness_testing,
        CASE
            WHEN TRIM(BOTH FROM tanks."TankPipingReleaseDetection") = 'Tightness Testing'::text AND (TRIM(BOTH FROM tanks."TankPipingType") = ANY (ARRAY['Suction'::text, 'Suction - Valve'::text])) THEN 'Tightness Testing'::text
            ELSE NULL::text
        END AS three_year_tightness_testing
   FROM sd_ust.tanks;

create or replace view sd_ust.v_ust_compartment as
 WITH mapped AS MATERIALIZED (
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
            CASE
                WHEN NULLIF(TRIM(a."TankCompartmentNumber"::text), '') IS NULL THEN 1
                ELSE NULLIF(TRIM(a."TankCompartmentNumber"::text), '')::integer
            END AS compartment_id,
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
 SELECT m.facility_id,
    m.tank_id,
    m.compartment_id,
        CASE
            WHEN count(DISTINCT m.compartment_name) <= 1 THEN max(m.compartment_name::text)
            ELSE NULL::text
        END::character varying(50) AS compartment_name,
    (array_agg(m.compartment_status_id ORDER BY (( SELECT s.status_hierarchy
           FROM compartment_statuses s
          WHERE s.compartment_status_id = m.compartment_status_id)), m.compartment_status_id))[1] AS compartment_status_id,
        CASE
            WHEN count(DISTINCT m.compartment_capacity_gallons) <= 1 THEN max(m.compartment_capacity_gallons)
            ELSE NULL::integer
        END AS compartment_capacity_gallons,
        CASE
            WHEN count(DISTINCT m.overfill_prevention_ball_float_valve) <= 1 THEN max(m.overfill_prevention_ball_float_valve)
            ELSE NULL::text
        END AS overfill_prevention_ball_float_valve,
        CASE
            WHEN count(DISTINCT m.overfill_prevention_flow_shutoff_device) <= 1 THEN max(m.overfill_prevention_flow_shutoff_device)
            ELSE NULL::text
        END AS overfill_prevention_flow_shutoff_device,
        CASE
            WHEN count(DISTINCT m.overfill_prevention_high_level_alarm) <= 1 THEN max(m.overfill_prevention_high_level_alarm)
            ELSE NULL::text
        END AS overfill_prevention_high_level_alarm,
        CASE
            WHEN count(DISTINCT m.overfill_prevention_other) <= 1 THEN max(m.overfill_prevention_other)
            ELSE NULL::text
        END AS overfill_prevention_other,
        CASE
            WHEN count(DISTINCT m.spill_bucket_installed) <= 1 THEN max(m.spill_bucket_installed)
            ELSE NULL::text
        END AS spill_bucket_installed,
        CASE
            WHEN count(DISTINCT m.tank_interstitial_monitoring) <= 1 THEN max(m.tank_interstitial_monitoring)
            ELSE NULL::text
        END AS tank_interstitial_monitoring,
        CASE
            WHEN count(DISTINCT m.tank_automatic_tank_gauging_release_detection) <= 1 THEN max(m.tank_automatic_tank_gauging_release_detection)
            ELSE NULL::text
        END AS tank_automatic_tank_gauging_release_detection,
        CASE
            WHEN count(DISTINCT m.tank_manual_tank_gauging) <= 1 THEN max(m.tank_manual_tank_gauging)
            ELSE NULL::text
        END AS tank_manual_tank_gauging,
        CASE
            WHEN count(DISTINCT m.tank_statistical_inventory_reconciliation) <= 1 THEN max(m.tank_statistical_inventory_reconciliation)
            ELSE NULL::text
        END AS tank_statistical_inventory_reconciliation,
        CASE
            WHEN count(DISTINCT m.tank_tightness_testing) <= 1 THEN max(m.tank_tightness_testing)
            ELSE NULL::text
        END AS tank_tightness_testing,
        CASE
            WHEN count(DISTINCT m.tank_inventory_control) <= 1 THEN max(m.tank_inventory_control)
            ELSE NULL::text
        END AS tank_inventory_control,
        CASE
            WHEN count(DISTINCT m.tank_groundwater_monitoring) <= 1 THEN max(m.tank_groundwater_monitoring)
            ELSE NULL::text
        END AS tank_groundwater_monitoring,
        CASE
            WHEN count(DISTINCT m.tank_vapor_monitoring) <= 1 THEN max(m.tank_vapor_monitoring)
            ELSE NULL::text
        END AS tank_vapor_monitoring,
        CASE
            WHEN count(DISTINCT m.tank_other_release_detection) <= 1 THEN max(m.tank_other_release_detection)
            ELSE NULL::text
        END AS tank_other_release_detection
   FROM mapped m
  GROUP BY m.facility_id, m.tank_id, m.compartment_id;

create or replace view sd_ust.v_ust_facility as
 WITH mapped AS (
         SELECT DISTINCT a."FacilityNumber"::character varying(50) AS facility_id,
            a."FacilityName"::character varying(100) AS facility_name,
            a."FacilityAddress1Text"::character varying(100) AS facility_address1,
            a."FacilityAddress2Text"::character varying(100) AS facility_address2,
            a."FacilityCity"::character varying(100) AS facility_city,
            a."FacilityCounty"::character varying(100) AS facility_county,
            a."FacilityZipCode"::character varying(10) AS facility_zip_code,
            'SD'::text AS facility_state,
            8 AS facility_epa_region,
            a."FacilityLatitudeValue"::double precision AS facility_latitude,
            a."FacilityLongitudeValue" AS facility_longitude,
            b.coordinate_source_id,
            a."OwnerName"::character varying(100) AS facility_owner_company_name
           FROM sd_ust.tanks a
             LEFT JOIN sd_ust.v_coordinate_source_xwalk b ON a."FacilityMethodDescription" = b.organization_value::text
          WHERE NOT (EXISTS ( SELECT 1
                   FROM sd_ust.erg_unregulated_facilities unreg
                  WHERE NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text) = unreg.facility_id::text)) AND COALESCE(b.exclude_from_query, 'N'::character varying)::text <> 'Y'::text
        ), duplicate_ids AS (
         SELECT mapped.facility_id
           FROM mapped
          GROUP BY mapped.facility_id
         HAVING count(*) > 1
        ), coordinates AS (
         SELECT DISTINCT ON (m.facility_id) m.facility_id,
            m.facility_latitude,
            m.facility_longitude,
            m.coordinate_source_id
           FROM mapped m
             JOIN duplicate_ids d USING (facility_id)
          ORDER BY m.facility_id, (m.facility_latitude IS NOT NULL AND m.facility_longitude IS NOT NULL AND (m.facility_latitude <> 0::double precision OR m.facility_longitude <> 0::double precision)) DESC, (m.coordinate_source_id IS NOT NULL) DESC, m.facility_latitude, m.facility_longitude, m.coordinate_source_id
        )
 SELECT m.facility_id,
    m.facility_name,
    m.facility_address1,
    m.facility_address2,
    m.facility_city,
    m.facility_county,
    m.facility_zip_code,
    m.facility_state,
    m.facility_epa_region,
    m.facility_latitude,
    m.facility_longitude,
    m.coordinate_source_id,
    m.facility_owner_company_name
   FROM mapped m
  WHERE NOT (EXISTS ( SELECT 1
           FROM duplicate_ids d
          WHERE d.facility_id::text = m.facility_id::text))
UNION ALL
 SELECT m.facility_id,
    min(NULLIF(TRIM(BOTH FROM m.facility_name), ''::text))::character varying(100) AS facility_name,
    min(NULLIF(TRIM(BOTH FROM m.facility_address1), ''::text))::character varying(100) AS facility_address1,
    min(NULLIF(TRIM(BOTH FROM m.facility_address2), ''::text))::character varying(100) AS facility_address2,
    min(NULLIF(TRIM(BOTH FROM m.facility_city), ''::text))::character varying(100) AS facility_city,
    min(NULLIF(TRIM(BOTH FROM m.facility_county), ''::text))::character varying(100) AS facility_county,
    min(NULLIF(TRIM(BOTH FROM m.facility_zip_code), ''::text))::character varying(10) AS facility_zip_code,
    min(NULLIF(TRIM(BOTH FROM m.facility_state), ''::text)) AS facility_state,
    max(m.facility_epa_region) AS facility_epa_region,
    max(g.facility_latitude) AS facility_latitude,
    max(g.facility_longitude) AS facility_longitude,
    max(g.coordinate_source_id) AS coordinate_source_id,
    min(NULLIF(TRIM(BOTH FROM m.facility_owner_company_name), ''::text))::character varying(100) AS facility_owner_company_name
   FROM mapped m
     JOIN coordinates g ON g.facility_id::text = m.facility_id::text
  GROUP BY m.facility_id;

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
                    WHEN NULLIF(TRIM(BOTH FROM a."TankCompartmentNumber"::text), ''::text) IS NULL THEN 1
                    ELSE NULLIF(TRIM(BOTH FROM a."TankCompartmentNumber"::text), ''::text)::integer
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
                CASE WHEN trim(a."TankPipingType") IN ('Safe Suction','Gravity Fed','Gravity Feed','Siphon')
                     THEN NULL::text ELSE CASE
                    WHEN lower(NULLIF(TRIM(BOTH FROM a."TankPipingReleaseDetection"), ''::text)) = ANY (ARRAY['campo/miller lld'::text, 'electronic lld'::text, 'incon lld'::text, 'mechanical lld'::text]) THEN 'Yes'::text
                    ELSE NULL::text
                END END AS piping_line_leak_detector,
                CASE WHEN trim(a."TankPipingType") IN ('Safe Suction','Gravity Fed','Gravity Feed','Siphon')
                     THEN NULL::text ELSE CASE
                    WHEN lower(NULLIF(TRIM(BOTH FROM b.annual_tightness_testing), ''::text)) = 'tightness testing'::text THEN 'Yes'::text
                    ELSE NULL::text
                END END AS piping_line_test_annual,
                CASE WHEN trim(a."TankPipingType") IN ('Safe Suction','Gravity Fed','Gravity Feed','Siphon')
                     THEN NULL::text ELSE CASE
                    WHEN NULLIF(TRIM(BOTH FROM b.three_year_tightness_testing), ''::text) = 'Tightness Testing'::text THEN 'Yes'::text
                    ELSE NULL::text
                END END AS piping_line_test3yr,
                CASE WHEN trim(a."TankPipingType") IN ('Safe Suction','Gravity Fed','Gravity Feed','Siphon')
                     THEN NULL::text ELSE CASE
                    WHEN lower(NULLIF(TRIM(BOTH FROM a."TankPipingReleaseDetection"), ''::text)) = 'groundwater monitoring'::text THEN 'Yes'::text
                    ELSE NULL::text
                END END AS piping_groundwater_monitoring,
                CASE WHEN trim(a."TankPipingType") IN ('Safe Suction','Gravity Fed','Gravity Feed','Siphon')
                     THEN NULL::text ELSE CASE
                    WHEN lower(NULLIF(TRIM(BOTH FROM a."TankPipingReleaseDetection"), ''::text)) = 'vapor monitoring'::text THEN 'Yes'::text
                    ELSE NULL::text
                END END AS piping_vapor_monitoring,
                CASE WHEN trim(a."TankPipingType") IN ('Safe Suction','Gravity Fed','Gravity Feed','Siphon')
                     THEN NULL::text ELSE CASE
                    WHEN lower(NULLIF(TRIM(BOTH FROM a."TankPipingReleaseDetection"), ''::text)) = ANY (ARRAY['secondary containment'::text, 'sump sensor'::text, 'ppm 4000'::text]) THEN 'Yes'::text
                    ELSE NULL::text
                END END AS piping_interstitial_monitoring,
                CASE WHEN trim(a."TankPipingType") IN ('Safe Suction','Gravity Fed','Gravity Feed','Siphon')
                     THEN NULL::text ELSE CASE
                    WHEN lower(NULLIF(TRIM(BOTH FROM a."TankPipingReleaseDetection"), ''::text)) = 's.i.r.'::text THEN 'Yes'::text
                    ELSE NULL::text
                END END AS piping_statistical_inventory_reconciliation,
            e.piping_wall_type_id,
                CASE
                    WHEN lower(NULLIF(TRIM(BOTH FROM a."TankPipingReleaseDetection"), ''::text)) = ANY (ARRAY['secondary containment'::text, 'concrete containment'::text]) THEN 'Yes'::text
                    ELSE NULL::text
                END AS pipe_secondary_containment_other
           FROM sd_ust.tanks a
             LEFT JOIN sd_ust.v_piping_tightness_testing b ON a."TankPipingType" = b."TankPipingType" AND a."TankPipingReleaseDetection" = b."TankPipingReleaseDetection"
             JOIN sd_ust.erg_piping c ON a."FacilityNumber" = c.facility_id::text
                AND a."TankNumber" = c.tank_id::double precision
                AND CASE
                    WHEN NULLIF(TRIM(BOTH FROM a."TankCompartmentNumber"::text), ''::text) IS NULL THEN 1
                    ELSE NULLIF(TRIM(BOTH FROM a."TankCompartmentNumber"::text), ''::text)::integer
                END = c.compartment_id
                AND a."TankPipingType" IS NOT DISTINCT FROM c.tank_piping_type
                AND a."TankPipingMaterial" IS NOT DISTINCT FROM c.tank_piping_material
                AND a."TankPipingReleaseDetection" IS NOT DISTINCT FROM c.tank_piping_release_detection
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

create or replace view sd_ust.v_ust_tank as
 WITH mapped AS (
         SELECT DISTINCT NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text)::character varying(50) AS facility_id,
            a."TankNumber"::integer AS tank_id,
            a."TankNumber"::character varying(50) AS tank_name,
            COALESCE(ts.tank_status_id, 8) AS tank_status_id,
                CASE
                    WHEN a."TankRemovedYear" = ANY (ARRAY['04/10/1991'::text, '11/15/1989'::text]) THEN to_date(a."TankRemovedYear", 'mm/dd/yyyy'::text)
                    ELSE to_date(a."TankRemovedYear"::character varying::text, 'yyyy'::text)
                END AS tank_closure_date,
                CASE
                    WHEN a."TankInstalledYear" = 1899::double precision THEN NULL::date
                    ELSE to_date(a."TankInstalledYear"::character varying::text, 'yyyy'::text)
                END AS tank_installation_date,
                CASE
                    WHEN NULLIF(TRIM(BOTH FROM a."TankCompartmentNumber"::text), ''::text) ~ '^[+-]?\d+(\.0+)?$'::text AND NULLIF(TRIM(BOTH FROM a."TankCompartmentNumber"::text), ''::text)::numeric > 1::numeric THEN 'Yes'::text
                    WHEN NULLIF(TRIM(BOTH FROM a."TankCompartmentNumber"::text), ''::text) ~ '^[+-]?\d+(\.0+)?$'::text THEN 'No'::text
                    ELSE NULL::text
                END AS compartmentalized_ust,
            n.number_of_compartments,
            b.tank_material_description_id,
                CASE
                    WHEN a."TankConstructionName" = ANY (ARRAY['DW/STIP3'::text, 'DW/STIP3/Compart'::text, 'STIP3'::text, 'STIP3/Compart'::text]) THEN 'Yes'::text
                    ELSE NULL::text
                END AS tank_corrosion_protection_sacrificial_anode,
                CASE
                    WHEN a."TankConstructionName" = ANY (ARRAY['Lined w/ Impressed'::text, 'Steel/Impressed'::text]) THEN 'Yes'::text
                    ELSE NULL::text
                END AS tank_corrosion_protection_impressed_current,
                CASE
                    WHEN a."TankConstructionName" = ANY (ARRAY['Lined Interior'::text, 'Lined w/ Impressed'::text, 'Painted Steel w/ Lining'::text]) THEN 'Yes'::text
                    ELSE NULL::text
                END AS tank_corrosion_protection_interior_lining,
            c.tank_secondary_containment_id
           FROM sd_ust.tanks a
             LEFT JOIN sd_ust.v_tank_material_description_xwalk b ON a."TankConstructionName" = b.organization_value::text
             LEFT JOIN sd_ust.v_tank_secondary_containment_xwalk c ON a."TankConstructionName" = c.organization_value::text
             LEFT JOIN sd_ust.v_tank_status_xwalk ts ON a."StatusName" = ts.organization_value::text
             LEFT JOIN sd_ust.erg_number_of_compartments n ON a."FacilityNumber" = n."FacilityNumber" AND a."TankNumber" = n."TankNumber"
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
                  WHERE parent.facility_id::text = NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text))) AND COALESCE(b.exclude_from_query, 'N'::character varying)::text <> 'Y'::text AND COALESCE(c.exclude_from_query, 'N'::character varying)::text <> 'Y'::text AND COALESCE(ts.exclude_from_query, 'N'::character varying)::text <> 'Y'::text
        ), preferred_status AS (
         SELECT DISTINCT ON (m.facility_id, m.tank_id) m.facility_id,
            m.tank_id,
            m.tank_status_id
           FROM mapped m
             JOIN tank_statuses ts ON ts.tank_status_id = m.tank_status_id
             JOIN compartment_statuses cs ON cs.compartment_status::text = ts.tank_status::text
          ORDER BY m.facility_id, m.tank_id, cs.status_hierarchy, m.tank_status_id
        )
 SELECT mapped.facility_id,
    mapped.tank_id,
        CASE
            WHEN count(DISTINCT mapped.tank_name) <= 1 THEN max(mapped.tank_name::text)
            ELSE NULL::text
        END::character varying(50) AS tank_name,
    ( SELECT ps.tank_status_id
           FROM preferred_status ps
          WHERE ps.facility_id::text = mapped.facility_id::text AND ps.tank_id = mapped.tank_id) AS tank_status_id,
        CASE
            WHEN count(DISTINCT mapped.tank_closure_date) <= 1 THEN max(mapped.tank_closure_date)
            ELSE NULL::date
        END AS tank_closure_date,
        CASE
            WHEN count(DISTINCT mapped.tank_installation_date) <= 1 THEN max(mapped.tank_installation_date)
            ELSE NULL::date
        END AS tank_installation_date,
        CASE
            WHEN count(DISTINCT mapped.compartmentalized_ust) <= 1 THEN max(mapped.compartmentalized_ust)
            ELSE NULL::text
        END AS compartmentalized_ust,
        CASE
            WHEN count(DISTINCT mapped.number_of_compartments) <= 1 THEN max(mapped.number_of_compartments)
            ELSE NULL::integer
        END AS number_of_compartments,
        CASE
            WHEN count(DISTINCT mapped.tank_material_description_id) <= 1 THEN max(mapped.tank_material_description_id)
            ELSE NULL::integer
        END AS tank_material_description_id,
        CASE
            WHEN count(DISTINCT mapped.tank_corrosion_protection_sacrificial_anode) <= 1 THEN max(mapped.tank_corrosion_protection_sacrificial_anode)
            ELSE NULL::text
        END AS tank_corrosion_protection_sacrificial_anode,
        CASE
            WHEN count(DISTINCT mapped.tank_corrosion_protection_impressed_current) <= 1 THEN max(mapped.tank_corrosion_protection_impressed_current)
            ELSE NULL::text
        END AS tank_corrosion_protection_impressed_current,
        CASE
            WHEN count(DISTINCT mapped.tank_corrosion_protection_interior_lining) <= 1 THEN max(mapped.tank_corrosion_protection_interior_lining)
            ELSE NULL::text
        END AS tank_corrosion_protection_interior_lining,
        CASE
            WHEN count(DISTINCT mapped.tank_secondary_containment_id) <= 1 THEN max(mapped.tank_secondary_containment_id)
            ELSE NULL::integer
        END AS tank_secondary_containment_id
   FROM mapped
  WHERE mapped.tank_id IS NOT NULL
  GROUP BY mapped.facility_id, mapped.tank_id;

create or replace view sd_ust.v_ust_tank_substance as
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
          WHERE parent.facility_id::text = NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text))) AND COALESCE(b.exclude_from_query, 'N'::character varying)::text <> 'Y'::text AND (EXISTS ( SELECT 1
           FROM valid_tanks tank_parent
          WHERE tank_parent.facility_id::text = NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text) AND tank_parent.tank_id =
                CASE
                    WHEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text) ~ '^[+-]?\d+$'::text THEN NULLIF(TRIM(BOTH FROM a."TankNumber"::text), ''::text)::integer
                    ELSE NULL::integer
                                END));

create or replace view sd_ust.v_ust_compartment_substance as
select distinct
        s.facility_id,
        s.tank_id,
        case
            when nullif(trim(a."TankCompartmentNumber"::text), '') is null then 1
            else nullif(trim(a."TankCompartmentNumber"::text), '')::integer
        end as compartment_id,
        s.substance_id
from sd_ust.v_ust_tank_substance s
join sd_ust.tanks a
    on a."FacilityNumber" = s.facility_id::text
 and a."TankNumber" = s.tank_id;
