


/*********** v_ust_facility ***********/


--View definition for sd_ust.v_ust_facility:
 WITH base AS (
         SELECT (a."FacilityNumber")::character varying(50) AS facility_id,
            (a."FacilityName")::character varying(100) AS facility_name,
            (a."FacilityAddress1Text")::character varying(100) AS facility_address1,
            (a."FacilityAddress2Text")::character varying(100) AS facility_address2,
            (a."FacilityCity")::character varying(100) AS facility_city,
            (a."FacilityCounty")::character varying(100) AS facility_county,
            (NULLIF(TRIM(BOTH FROM a."FacilityZipCode"), ''::text))::character varying(10) AS facility_zip_code,
            'SD'::text AS facility_state,
            8 AS facility_epa_region,
            (NULLIF(a."FacilityLatitudeValue", ''::text))::double precision AS facility_latitude,
            (NULLIF((a."FacilityLongitudeValue")::text, ''::text))::double precision AS facility_longitude,
            b.coordinate_source_id,
            (a."OwnerName")::character varying(100) AS facility_owner_company_name
           FROM (sd_ust.tanks a
             LEFT JOIN sd_ust.v_coordinate_source_xwalk b ON ((a."FacilityMethodDescription" = (b.organization_value)::text)))
          WHERE (a."FacilityType" = 'UST'::text)
        ), ranked AS (
         SELECT base.facility_id,
            base.facility_name,
            base.facility_address1,
            base.facility_address2,
            base.facility_city,
            base.facility_county,
            base.facility_zip_code,
            base.facility_state,
            base.facility_epa_region,
            base.facility_latitude,
            base.facility_longitude,
            base.coordinate_source_id,
            base.facility_owner_company_name,
            (((((base.facility_zip_code IS NOT NULL))::integer + (((base.facility_latitude IS NOT NULL) AND (base.facility_latitude <> (0)::double precision)))::integer) + (((base.facility_longitude IS NOT NULL) AND (base.facility_longitude <> (0)::double precision)))::integer) + ((base.facility_address1 IS NOT NULL))::integer) AS quality_score
           FROM base
        )
 SELECT DISTINCT ON (ranked.facility_id) ranked.facility_id,
    ranked.facility_name,
    ranked.facility_address1,
    ranked.facility_address2,
    ranked.facility_city,
    ranked.facility_county,
    ranked.facility_zip_code,
    ranked.facility_state,
    ranked.facility_epa_region,
    ranked.facility_latitude,
    ranked.facility_longitude,
    ranked.coordinate_source_id,
    ranked.facility_owner_company_name
   FROM ranked
  ORDER BY ranked.facility_id, ranked.quality_score DESC, (ranked.facility_zip_code IS NOT NULL) DESC, ((ranked.facility_latitude IS NOT NULL) AND (ranked.facility_latitude <> (0)::double precision)) DESC, ((ranked.facility_longitude IS NOT NULL) AND (ranked.facility_longitude <> (0)::double precision)) DESC;;




/*********** v_ust_tank ***********/


--View definition for sd_ust.v_ust_tank:
 WITH compartment_counts AS (
         SELECT (a."FacilityNumber")::character varying(50) AS facility_id,
            (a."TankNumber")::integer AS tank_id,
            (count(DISTINCT a."TankCompartmentNumber"))::integer AS number_of_compartments
           FROM sd_ust.tanks a
          WHERE ((a."FacilityType" = 'UST'::text) AND (a."TankNumber" IS NOT NULL))
          GROUP BY ((a."FacilityNumber")::character varying(50)), ((a."TankNumber")::integer)
        ), scored AS (
         SELECT (a."FacilityNumber")::character varying(50) AS facility_id,
            (a."TankNumber")::integer AS tank_id,
            (a."TankNumber")::character varying(50) AS tank_name,
            COALESCE(d.tank_status_id, 8) AS tank_status_id,
                CASE
                    WHEN (a."TankRemovedYear" = ANY (ARRAY['04/10/1991'::text, '11/15/1989'::text])) THEN to_date(a."TankRemovedYear", 'mm/dd/yyyy'::text)
                    ELSE to_date(a."TankRemovedYear", 'yyyy'::text)
                END AS tank_closure_date,
                CASE
                    WHEN (a."TankInstalledYear" = '1899'::double precision) THEN NULL::date
                    ELSE to_date((a."TankInstalledYear")::text, 'yyyy'::text)
                END AS tank_installation_date,
            b.tank_material_description_id,
                CASE
                    WHEN (a."TankConstructionName" = ANY (ARRAY['DW/STIP3'::text, 'DW/STIP3/Compart'::text, 'STIP3'::text, 'STIP3/Compart'::text])) THEN 'Yes'::text
                    ELSE NULL::text
                END AS tank_corrosion_protection_sacrificial_anode,
                CASE
                    WHEN (a."TankConstructionName" = ANY (ARRAY['Lined w/ Impressed'::text, 'Steel/Impressed'::text])) THEN 'Yes'::text
                    ELSE NULL::text
                END AS tank_corrosion_protection_impressed_current,
                CASE
                    WHEN (a."TankConstructionName" = ANY (ARRAY['Lined Interior'::text, 'Lined w/ Impressed'::text, 'Painted Steel w/ Lining'::text])) THEN 'Yes'::text
                    ELSE NULL::text
                END AS tank_corrosion_protection_interior_lining,
            c.tank_secondary_containment_id,
            ((((((d.tank_status_id IS NOT NULL))::integer + ((b.tank_material_description_id IS NOT NULL))::integer) + ((c.tank_secondary_containment_id IS NOT NULL))::integer) + ((a."TankInstalledYear" IS NOT NULL))::integer) + ((a."TankRemovedYear" IS NOT NULL))::integer) AS quality_score
           FROM (((sd_ust.tanks a
             LEFT JOIN sd_ust.v_tank_material_description_xwalk b ON ((a."TankConstructionName" = (b.organization_value)::text)))
             LEFT JOIN sd_ust.v_tank_secondary_containment_xwalk c ON ((a."TankConstructionName" = (c.organization_value)::text)))
             LEFT JOIN sd_ust.v_tank_status_xwalk d ON ((a."StatusName" = (d.organization_value)::text)))
          WHERE ((a."FacilityType" = 'UST'::text) AND (a."TankNumber" IS NOT NULL))
        ), ranked AS (
         SELECT s.facility_id,
            s.tank_id,
            s.tank_name,
            s.tank_status_id,
            s.tank_closure_date,
            s.tank_installation_date,
            s.tank_material_description_id,
            s.tank_corrosion_protection_sacrificial_anode,
            s.tank_corrosion_protection_impressed_current,
            s.tank_corrosion_protection_interior_lining,
            s.tank_secondary_containment_id,
            s.quality_score,
            row_number() OVER (PARTITION BY s.facility_id, s.tank_id ORDER BY s.quality_score DESC, s.tank_closure_date DESC NULLS LAST, s.tank_installation_date DESC NULLS LAST) AS rn
           FROM scored s
        )
 SELECT r.facility_id,
    r.tank_id,
    r.tank_name,
    r.tank_status_id,
    r.tank_closure_date,
    r.tank_installation_date,
        CASE
            WHEN (COALESCE(cc.number_of_compartments, 0) > 1) THEN 'Yes'::text
            ELSE 'No'::text
        END AS compartmentalized_ust,
    COALESCE(cc.number_of_compartments, 0) AS number_of_compartments,
    r.tank_material_description_id,
    r.tank_corrosion_protection_sacrificial_anode,
    r.tank_corrosion_protection_impressed_current,
    r.tank_corrosion_protection_interior_lining,
    r.tank_secondary_containment_id
   FROM (ranked r
     LEFT JOIN compartment_counts cc ON ((((cc.facility_id)::text = (r.facility_id)::text) AND (cc.tank_id = r.tank_id))))
  WHERE (r.rn = 1);;




/*********** v_ust_tank_substance ***********/


--View definition for sd_ust.v_ust_tank_substance:
 SELECT DISTINCT (x."FacilityNumber")::character varying(50) AS facility_id,
    c.tank_id,
    sx.substance_id
   FROM ((sd_ust.tanks x
     JOIN sd_ust.v_ust_tank c ON (((x."FacilityNumber" = (c.facility_id)::text) AND (x."TankNumber" = ((c.tank_name)::integer)::double precision))))
     LEFT JOIN sd_ust.v_substance_xwalk sx ON ((x."TankProduct" = (sx.organization_value)::text)))
  WHERE ((x."TankProduct" IS NOT NULL) AND (x."FacilityType" = 'UST'::text));;




/*********** v_ust_compartment ***********/


--View definition for sd_ust.v_ust_compartment:
 SELECT DISTINCT c.facility_id,
    c.tank_id,
    c.compartment_id,
    (x."TankCompartmentNumber")::character varying(50) AS compartment_name,
    (x."TankCapacityAmount")::integer AS compartment_capacity_gallons,
        CASE x."TankOverfillProtection"
            WHEN 'Ball Float Valves'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_ball_float_valve,
        CASE x."TankOverfillProtection"
            WHEN 'Automatic Shutoff Device'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_flow_shutoff_device,
        CASE x."TankOverfillProtection"
            WHEN 'Overfill Alarm'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_high_level_alarm,
        CASE x."TankOverfillProtection"
            WHEN 'Other'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_other,
        CASE x."TankSpillProtection"
            WHEN 'Spill Bucket'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS spill_bucket_installed,
        CASE
            WHEN (x."TankReleaseDetection" = ANY (ARRAY['Secondary Containment'::text, 'Double Walled'::text, 'Interstitial Monitoring'::text, 'Concrete Vault'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_interstitial_monitoring,
        CASE
            WHEN (x."TankReleaseDetection" = ANY (ARRAY['In-Tank Monitor'::text, 'Automatic Tank Gauging'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_automatic_tank_gauging_release_detection,
        CASE x."TankReleaseDetection"
            WHEN 'Manual Gauging'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_manual_tank_gauging,
        CASE x."TankReleaseDetection"
            WHEN 'S.I.R.'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_statistical_inventory_reconciliation,
        CASE x."TankReleaseDetection"
            WHEN 'Tightness Testing'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_tightness_testing,
        CASE x."TankReleaseDetection"
            WHEN 'Inventory Control'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_inventory_control,
        CASE x."TankReleaseDetection"
            WHEN 'Groundwater Monitoring'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_groundwater_monitoring,
        CASE x."TankReleaseDetection"
            WHEN 'Other'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_other_release_detection,
        CASE x."TankReleaseDetection"
            WHEN 'Vapor Monitoring'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_vapor_monitoring,
    COALESCE(ts.tank_status_id, 8) AS compartment_status_id
   FROM ((sd_ust.tanks x
     JOIN sd_ust.erg_compartment c ON (((x."FacilityNumber" = (c.facility_id)::text) AND (x."TankNumber" = (c.tank_id)::double precision))))
     LEFT JOIN sd_ust.v_tank_status_xwalk ts ON ((x."StatusName" = (ts.organization_value)::text)))
  WHERE (x."FacilityType" = 'UST'::text);;




/*********** v_ust_piping ***********/


--View definition for sd_ust.v_ust_piping:
 SELECT DISTINCT (NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text))::character varying(50) AS facility_id,
        CASE
            WHEN (NULLIF(TRIM(BOTH FROM (a."TankNumber")::text), ''::text) ~ '^[+-]?\d+$'::text) THEN (NULLIF(TRIM(BOTH FROM (a."TankNumber")::text), ''::text))::integer
            ELSE NULL::integer
        END AS tank_id,
        CASE
            WHEN (NULLIF(TRIM(BOTH FROM (b.compartment_id)::text), ''::text) ~ '^[+-]?\d+$'::text) THEN (NULLIF(TRIM(BOTH FROM (b.compartment_id)::text), ''::text))::integer
            ELSE NULL::integer
        END AS compartment_id,
    (b.piping_id)::character varying(50) AS piping_id,
    c.piping_style_id,
        CASE
            WHEN (NULLIF(TRIM(BOTH FROM a."TankPipingType"), ''::text) = 'Safe Suction'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS safe_suction,
        CASE
            WHEN (NULLIF(TRIM(BOTH FROM a."TankPipingType"), ''::text) = 'Pressure'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS high_pressure_or_bulk_piping,
        CASE
            WHEN (lower(NULLIF(TRIM(BOTH FROM a."TankPipingMaterial"), ''::text)) ~~ '%fiberglass%'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_frp,
        CASE
            WHEN (lower(NULLIF(TRIM(BOTH FROM a."TankPipingMaterial"), ''::text)) = ANY (ARRAY['galvanized steel'::text, 'steel - bare/galv'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_gal_steel,
        CASE
            WHEN (lower(NULLIF(TRIM(BOTH FROM a."TankPipingMaterial"), ''::text)) = ANY (ARRAY['stainless steel'::text, 'pipingmaterialstainlesssteel'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_stainless_steel,
        CASE
            WHEN (lower(NULLIF(TRIM(BOTH FROM a."TankPipingMaterial"), ''::text)) = ANY (ARRAY['black steel'::text, 'cath. protection'::text, 'cath. steel'::text, 'coated steel'::text, 'steel'::text, 'steel/aboveground'::text, 'steel/cont'::text, 'bare steel'::text, 'steel isolated'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_steel,
        CASE
            WHEN (lower(NULLIF(TRIM(BOTH FROM a."TankPipingMaterial"), ''::text)) = ANY (ARRAY['copper'::text, 'copper -corr. prot.'::text, 'copper isolated'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_copper,
        CASE
            WHEN (lower(NULLIF(TRIM(BOTH FROM a."TankPipingMaterial"), ''::text)) = ANY (ARRAY['dw ameron'::text, 'dw apt'::text, 'dw environ'::text, 'dw flex'::text, 'dw marinaflex'::text, 'dw opw'::text, 'dw poly'::text, 'sw ameron'::text, 'sw apt'::text, 'sw flex'::text, 'total containment'::text, 'flexible'::text, 'flexible plastic'::text, 'flex piping'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_flex,
        CASE
            WHEN (lower(NULLIF(TRIM(BOTH FROM a."TankPipingMaterial"), ''::text)) = ANY (ARRAY['none'::text, 'not applicable'::text, 'pipingmaterialnopiping'::text, 'no piping'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_no_piping,
        CASE
            WHEN (lower(NULLIF(TRIM(BOTH FROM a."TankPipingMaterial"), ''::text)) = 'unknown'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_unknown,
        CASE
            WHEN (lower(NULLIF(TRIM(BOTH FROM a."TankPipingMaterial"), ''::text)) = ANY (ARRAY['cath. protection'::text, 'cath. steel'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_corrosion_protection_sacrificial_anode,
        CASE
            WHEN (lower(NULLIF(TRIM(BOTH FROM a."TankPipingReleaseDetection"), ''::text)) = ANY (ARRAY['campo/miller lld'::text, 'electronic lld'::text, 'incon lld'::text, 'mechanical lld'::text, 'ppm 4000'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_line_leak_detector,
        CASE
            WHEN (lower(NULLIF(TRIM(BOTH FROM a."TankPipingReleaseDetection"), ''::text)) = 'tightness testing'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_line_test_annual,
        CASE
            WHEN (lower(NULLIF(TRIM(BOTH FROM a."TankPipingReleaseDetection"), ''::text)) = 'groundwater monitoring'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_groundwater_monitoring,
        CASE
            WHEN (lower(NULLIF(TRIM(BOTH FROM a."TankPipingReleaseDetection"), ''::text)) = 'vapor monitoring'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_vapor_monitoring,
        CASE
            WHEN (lower(NULLIF(TRIM(BOTH FROM a."TankPipingReleaseDetection"), ''::text)) = ANY (ARRAY['secondary containment'::text, 'sump sensor'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_interstitial_monitoring,
        CASE
            WHEN (lower(NULLIF(TRIM(BOTH FROM a."TankPipingReleaseDetection"), ''::text)) = 's.i.r.'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_statistical_inventory_reconciliation,
    d.piping_wall_type_id,
        CASE
            WHEN (lower(NULLIF(TRIM(BOTH FROM a."TankPipingReleaseDetection"), ''::text)) = ANY (ARRAY['secondary containment'::text, 'concrete containment'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS pipe_secondary_containment_other
   FROM (((sd_ust.tanks a
     LEFT JOIN sd_ust.erg_piping b ON (((
        CASE
            WHEN (NULLIF(TRIM(BOTH FROM (a."TankNumber")::text), ''::text) ~ '^[+-]?\d+$'::text) THEN (NULLIF(TRIM(BOTH FROM (a."TankNumber")::text), ''::text))::integer
            ELSE NULL::integer
        END = b.tank_id) AND (NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text) = (b.facility_id)::text))))
     LEFT JOIN sd_ust.v_piping_style_xwalk c ON ((a."TankPipingType" = (c.organization_value)::text)))
     LEFT JOIN sd_ust.v_piping_wall_type_xwalk d ON ((a."TankPipingMaterial" = (d.organization_value)::text)))
  WHERE ((NOT (EXISTS ( SELECT 1
           FROM sd_ust.erg_unregulated_facilities unreg_fac
          WHERE (NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text) = (unreg_fac.facility_id)::text)))) AND (NOT (EXISTS ( SELECT 1
           FROM sd_ust.erg_unregulated_tanks unreg_tank
          WHERE ((NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text) = (unreg_tank.facility_id)::text) AND (
                CASE
                    WHEN (NULLIF(TRIM(BOTH FROM (a."TankNumber")::text), ''::text) ~ '^[+-]?\d+$'::text) THEN (NULLIF(TRIM(BOTH FROM (a."TankNumber")::text), ''::text))::integer
                    ELSE NULL::integer
                END = unreg_tank.tank_id))))) AND (EXISTS ( SELECT 1
           FROM sd_ust.v_ust_facility parent
          WHERE ((parent.facility_id)::text = NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text)))));;

