


/*********** v_ust_facility ***********/


--View definition for nm_ust.v_ust_facility:
 WITH usage_f AS (
         SELECT x_1."FACILITY_ID",
            u_1."TANK_DETAIL_DESCRIPTION",
            row_number() OVER (PARTITION BY x_1."FACILITY_ID" ORDER BY u_1."TANK_DETAIL_CODE" DESC) AS row_num
           FROM (nm_ust."Info" x_1
             LEFT JOIN nm_ust.v_erg_usage u_1 ON (((x_1."TANK_ID")::double precision = u_1."TANK_ID")))
        ), facility_operator AS (
         SELECT x_1."FACILITY_ID",
            x_1."OPERATOR_NAME",
            row_number() OVER (PARTITION BY x_1."FACILITY_ID" ORDER BY x_1."OPERATOR_NAME" DESC NULLS LAST) AS row_num
           FROM nm_ust."Info" x_1
        ), facility_owner AS (
         SELECT x_1."FACILITY_ID",
            x_1."OWNER_NAME",
            row_number() OVER (PARTITION BY x_1."FACILITY_ID" ORDER BY x_1."OWNER_NAME" DESC NULLS LAST) AS row_num
           FROM nm_ust."Info" x_1
        ), lat_long AS (
         SELECT x_1."FACILITY_ID",
            x_1."FACILITY_LATITUDE",
            x_1."FACILITY_LONGITUDE",
            row_number() OVER (PARTITION BY x_1."FACILITY_ID" ORDER BY x_1."FACILITY_LATITUDE" DESC NULLS LAST) AS row_num
           FROM nm_ust."Info" x_1
        )
 SELECT DISTINCT (x."FACILITY_ID")::character varying AS facility_id,
    x."FACILITY_NAME" AS facility_name,
        CASE
            WHEN (u."TANK_DETAIL_DESCRIPTION" = ANY (ARRAY['EMERGENCY GENERATOR'::text, 'WASTE STORAGE'::text])) THEN NULL::integer
            ELSE ft.facility_type_id
        END AS facility_type1,
    x."FACILITY_ADDRESS_1" AS facility_address1,
    x."FACILITY_ADDRESS_2" AS facility_address2,
    x."FACILITY_CITY" AS facility_city,
    x."FACILITY_COUNTY" AS facility_county,
    x."FACILITY_ZIP_CODE" AS facility_zip_code,
    s.facility_state,
    6 AS facility_epa_region,
        CASE
            WHEN (x."TRIBAL_SITE" = 'Y'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS facility_tribal_site,
    ll."FACILITY_LATITUDE" AS facility_latitude,
    ll."FACILITY_LONGITUDE" AS facility_longitude,
    own."OWNER_NAME" AS facility_owner_company_name,
    fo_agg."OPERATOR_NAME" AS facility_operator_company_name
   FROM (((((((nm_ust."Info" x
     LEFT JOIN usage_f u ON (((x."FACILITY_ID" = u."FACILITY_ID") AND (u.row_num = 1))))
     LEFT JOIN facility_operator fo_agg ON (((x."FACILITY_ID" = fo_agg."FACILITY_ID") AND (fo_agg.row_num = 1))))
     LEFT JOIN facility_owner own ON (((x."FACILITY_ID" = own."FACILITY_ID") AND (own.row_num = 1))))
     LEFT JOIN lat_long ll ON (((x."FACILITY_ID" = ll."FACILITY_ID") AND (ll.row_num = 1))))
     LEFT JOIN nm_ust.v_facility_type_xwalk ft ON ((u."TANK_DETAIL_DESCRIPTION" = (ft.organization_value)::text)))
     LEFT JOIN nm_ust.v_state_xwalk s ON ((x."FACILITY_STATE" = (s.organization_value)::text)))
     JOIN nm_ust.v_tanks t ON ((x."FACILITY_ID" = t."FACILITY_ID")));;




/*********** v_ust_tank ***********/


--View definition for nm_ust.v_ust_tank:
 WITH tank_corrosion_protection AS (
         SELECT cp."TANK_ID",
            max(
                CASE
                    WHEN (cp."TANK_DETAIL_DESCRIPTION" = ANY (ARRAY['SACRIFICIAL ANODE UPGRADE ‐ TANK'::text, 'STI 86 CONTAINMENT SYSTEM'::text])) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS tank_corrosion_protection_sacrificial_anode,
            max(
                CASE
                    WHEN (cp."TANK_DETAIL_DESCRIPTION" = 'IMPRESSED CURRENT UPGRADE - TANK'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS tank_corrosion_protection_impressed_current,
            max(
                CASE
                    WHEN (cp."TANK_DETAIL_DESCRIPTION" = ANY (ARRAY['N/A ‐ Tank'::text, 'EXEMPT ‐ SITE NOT CORROSIVE'::text])) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS tank_corrosion_protection_cathodic_not_required,
            max(
                CASE
                    WHEN (cp."TANK_DETAIL_DESCRIPTION" = 'INTERIOR LINING UPGRADE'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS tank_corrosion_protection_interior_lining,
            max(
                CASE
                    WHEN (cp."TANK_DETAIL_DESCRIPTION" = 'EXEMPT ‐ SITE NOT CORROSIVE'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS tank_corrosion_protection_other,
            max(
                CASE
                    WHEN (cp."TANK_DETAIL_DESCRIPTION" = 'UNKNOWN - TANK'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS tank_corrosion_protection_unknown
           FROM nm_ust.v_erg_corrosion_prevention cp
          WHERE (cp."TANK_DETAIL_DESCRIPTION" <> ALL (ARRAY['N/A - Piping'::text, 'FLEX CONNECTOR - ISOLATION BOOT'::text, 'FLEX CONNECTOR - ANODE'::text, 'IMPRESSED CURRENT UPGRADE - PIPING'::text, 'SACRIFICIAL ANODE UPGRADE - PIPING'::text, 'NONE - PIPING'::text, 'CP PIPING - OTHER'::text, 'UNKNOWN - PIPING'::text, 'TOTAL CONTAINMENT JACKET'::text]))
          GROUP BY cp."TANK_ID"
        ), dates AS (
         SELECT x_1."TANK_ID",
            x_1."TANK_CLOSURE_DATE",
            x_1."TANK_INSTALLATION_DATE",
            row_number() OVER (PARTITION BY x_1."TANK_ID" ORDER BY x_1."TANK_INSTALLATION_DATE" DESC, x_1."TANK_CLOSURE_DATE" DESC NULLS LAST) AS row_num
           FROM nm_ust."Info" x_1
        ), em_gen AS (
         SELECT u."TANK_ID",
            u."TANK_DETAIL_DESCRIPTION"
           FROM nm_ust.v_erg_usage u
          WHERE (u."TANK_DETAIL_DESCRIPTION" = 'EMERGENCY GENERATOR'::text)
        ), tank_material AS (
         SELECT td."TANK_ID",
            td."TANK_DETAIL_DESCRIPTION",
            row_number() OVER (PARTITION BY td."TANK_ID" ORDER BY td."TANK_DETAIL_DESCRIPTION" DESC NULLS LAST) AS row_num
           FROM nm_ust.v_erg_tank_detail td
        ), tank_sc AS (
         SELECT sc_1."TANK_ID",
            sc_1."TANK_DETAIL_DESCRIPTION",
            row_number() OVER (PARTITION BY sc_1."TANK_ID" ORDER BY sc_1."TANK_DETAIL_DESCRIPTION" DESC NULLS LAST) AS row_num
           FROM nm_ust.v_erg_secondary_containment sc_1
        )
 SELECT DISTINCT (x."FACILITY_ID")::character varying AS facility_id,
    (x."TANK_ID")::integer AS tank_id,
    tl.tank_location_id,
    ts.tank_status_id,
        CASE
            WHEN (e."TANK_DETAIL_DESCRIPTION" = 'EMERGENCY GENERATOR'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS emergency_generator,
    (d."TANK_CLOSURE_DATE")::date AS tank_closure_date,
    (d."TANK_INSTALLATION_DATE")::date AS tank_installation_date,
    tmd.tank_material_description_id,
        CASE
            WHEN ((cp_agg.tank_corrosion_protection_sacrificial_anode IS NOT NULL) OR (cp_agg.tank_corrosion_protection_impressed_current IS NOT NULL) OR (cp_agg.tank_corrosion_protection_cathodic_not_required IS NOT NULL) OR (cp_agg.tank_corrosion_protection_interior_lining IS NOT NULL) OR (cp_agg.tank_corrosion_protection_other IS NOT NULL) OR (cp_agg.tank_corrosion_protection_unknown IS NOT NULL)) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_sacrificial_anode,
    cp_agg.tank_corrosion_protection_impressed_current,
    cp_agg.tank_corrosion_protection_cathodic_not_required,
    cp_agg.tank_corrosion_protection_interior_lining,
    cp_agg.tank_corrosion_protection_other,
    cp_agg.tank_corrosion_protection_unknown,
    tsc.tank_secondary_containment_id
   FROM ((((((((((nm_ust."Info" x
     LEFT JOIN nm_ust.v_tank_location_xwalk tl ON ((x."TANK_TYPE" = (tl.organization_value)::text)))
     LEFT JOIN nm_ust.v_tank_status_xwalk ts ON ((x."TANK_STATUS" = (ts.organization_value)::text)))
     LEFT JOIN tank_corrosion_protection cp_agg ON (((x."TANK_ID")::double precision = cp_agg."TANK_ID")))
     LEFT JOIN dates d ON (((x."TANK_ID" = d."TANK_ID") AND (d.row_num = 1))))
     LEFT JOIN em_gen e ON (((x."TANK_ID")::double precision = e."TANK_ID")))
     LEFT JOIN tank_material tm ON ((((x."TANK_ID")::double precision = tm."TANK_ID") AND (tm.row_num = 1))))
     LEFT JOIN nm_ust.v_tank_material_description_xwalk tmd ON ((tm."TANK_DETAIL_DESCRIPTION" = (tmd.organization_value)::text)))
     LEFT JOIN tank_sc sc ON ((((x."TANK_ID")::double precision = sc."TANK_ID") AND (sc.row_num = 1))))
     LEFT JOIN nm_ust.v_tank_secondary_containment_xwalk tsc ON ((sc."TANK_DETAIL_DESCRIPTION" = (tsc.organization_value)::text)))
     JOIN nm_ust.v_tanks t ON (((x."FACILITY_ID" = t."FACILITY_ID") AND (x."TANK_ID" = t."TANK_ID"))));;




/*********** v_ust_tank_substance ***********/


--View definition for nm_ust.v_ust_tank_substance:
 SELECT DISTINCT (x."FACILITY_ID")::character varying AS facility_id,
    (x."TANK_ID")::integer AS tank_id,
    s.substance_id
   FROM (((nm_ust."Info" x
     LEFT JOIN nm_ust.v_erg_contents c ON (((x."TANK_ID")::double precision = c."TANK_ID")))
     LEFT JOIN nm_ust.v_substance_xwalk s ON ((c."TANK_DETAIL_DESCRIPTION" = (s.organization_value)::text)))
     JOIN nm_ust.v_tanks t ON (((x."FACILITY_ID" = t."FACILITY_ID") AND (x."TANK_ID" = t."TANK_ID"))))
  WHERE (s.substance_id IS NOT NULL);;




/*********** v_ust_compartment ***********/


--View definition for nm_ust.v_ust_compartment:
 WITH tank_spill_prevention AS (
         SELECT sp."TANK_ID",
            max(
                CASE
                    WHEN (sp."TANK_DETAIL_DESCRIPTION" = 'BALL FLOAT VALVE'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS overfill_prevention_ball_float_valve,
            max(
                CASE
                    WHEN (sp."TANK_DETAIL_DESCRIPTION" = ANY (ARRAY['AUTOMATIC TANK FILL SHUT OFF'::text, 'FLAPPER VALVE'::text])) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS overfill_prevention_flow_shutoff_device,
            max(
                CASE
                    WHEN (sp."TANK_DETAIL_DESCRIPTION" = ANY (ARRAY['PRODUCT LEVEL SENSOR/ALARM'::text, 'CLOCK GAUGE WITH ALARM'::text])) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS overfill_prevention_high_level_alarm,
            max(
                CASE
                    WHEN (sp."TANK_DETAIL_DESCRIPTION" = 'APPROVED ALTERNATE METHOD - SPILL & OVERFILL'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS overfill_prevention_other,
            max(
                CASE
                    WHEN (sp."TANK_DETAIL_DESCRIPTION" = '< 25 GAL AT A TIME TRANS TANK'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS overfill_prevention_not_required,
            max(
                CASE
                    WHEN (sp."TANK_DETAIL_DESCRIPTION" = 'spill_bucket_installed'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS spill_bucket_installed,
            max(
                CASE
                    WHEN (sp."TANK_DETAIL_DESCRIPTION" = 'APPROVED ALTERNATE METHOD - SPILL & OVERFILL'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS spill_prevention_other,
            max(
                CASE
                    WHEN (sp."TANK_DETAIL_DESCRIPTION" = '< 25 GAL AT A TIME TRANS TANK'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS spill_prevention_not_required
           FROM nm_ust.v_erg_spill_prevention sp
          GROUP BY sp."TANK_ID"
        ), tank_release_detection AS (
         SELECT rd."TANK_ID",
            max(
                CASE
                    WHEN (rd."TANK_DETAIL_DESCRIPTION" = 'INTERSTITIAL MONITORING'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS tank_interstitial_monitoring,
            max(
                CASE
                    WHEN (rd."TANK_DETAIL_DESCRIPTION" = 'AUTOMATIC TANK GAUGING'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS tank_automatic_tank_gauging_release_detection,
            max(
                CASE
                    WHEN (rd."TANK_DETAIL_DESCRIPTION" = 'CSLD - CONTIN STAT LEAK DETECT'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS automatic_tank_gauging_continuous_leak_detection,
            max(
                CASE
                    WHEN (rd."TANK_DETAIL_DESCRIPTION" = 'MANUAL TANK GAUGING'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS tank_manual_tank_gauging,
            max(
                CASE
                    WHEN (rd."TANK_DETAIL_DESCRIPTION" = 'SIR - STAT INVENTORY RECONCIL'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS tank_statistical_inventory_reconciliation,
            max(
                CASE
                    WHEN (rd."TANK_DETAIL_DESCRIPTION" = 'TANK TIGHTNESS TEST W INV CONT'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS tank_tightness_testing,
            max(
                CASE
                    WHEN (rd."TANK_DETAIL_DESCRIPTION" = ANY (ARRAY['TANK TIGHTNESS TEST W INV CONT'::text, 'INVENTORY CONTROL W MTHLY REC'::text])) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS tank_inventory_control,
            max(
                CASE
                    WHEN (rd."TANK_DETAIL_DESCRIPTION" = 'GROUND WATER MONITORING'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS tank_groundwater_monitoring,
            max(
                CASE
                    WHEN (rd."TANK_DETAIL_DESCRIPTION" = ANY (ARRAY['VAPOR MONITORING'::text, 'TRACER'::text])) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS tank_vapor_monitoring,
            max(
                CASE
                    WHEN (rd."TANK_DETAIL_DESCRIPTION" = ANY (ARRAY['OTHER'::text, 'ABOVE GROUND - VISUAL INSPECTION'::text])) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS tank_other_release_detection
           FROM nm_ust.v_erg_tank_release_detection rd
          GROUP BY rd."TANK_ID"
        )
 SELECT DISTINCT (x."FACILITY_ID")::character varying AS facility_id,
    (x."TANK_ID")::integer AS tank_id,
    c.compartment_id,
    cs.compartment_status_id,
        CASE
            WHEN ((sp_agg.overfill_prevention_ball_float_valve IS NOT NULL) OR (sp_agg.overfill_prevention_flow_shutoff_device IS NOT NULL) OR (sp_agg.overfill_prevention_high_level_alarm IS NOT NULL) OR (sp_agg.overfill_prevention_other IS NOT NULL) OR (sp_agg.overfill_prevention_not_required IS NOT NULL) OR (sp_agg.spill_bucket_installed IS NOT NULL) OR (sp_agg.spill_prevention_other IS NOT NULL) OR (sp_agg.spill_prevention_not_required IS NOT NULL)) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_ball_float_valve,
    sp_agg.overfill_prevention_flow_shutoff_device,
    sp_agg.overfill_prevention_high_level_alarm,
    sp_agg.overfill_prevention_other,
    sp_agg.overfill_prevention_not_required,
    sp_agg.spill_bucket_installed,
    sp_agg.spill_prevention_other,
    sp_agg.spill_prevention_not_required,
        CASE
            WHEN ((rd_agg.tank_interstitial_monitoring IS NOT NULL) OR (rd_agg.tank_automatic_tank_gauging_release_detection IS NOT NULL) OR (rd_agg.automatic_tank_gauging_continuous_leak_detection IS NOT NULL) OR (rd_agg.tank_manual_tank_gauging IS NOT NULL) OR (rd_agg.tank_statistical_inventory_reconciliation IS NOT NULL) OR (rd_agg.tank_tightness_testing IS NOT NULL) OR (rd_agg.tank_inventory_control IS NOT NULL) OR (rd_agg.tank_groundwater_monitoring IS NOT NULL) OR (rd_agg.tank_vapor_monitoring IS NOT NULL) OR (rd_agg.tank_other_release_detection IS NOT NULL)) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_interstitial_monitoring,
    rd_agg.tank_automatic_tank_gauging_release_detection,
    rd_agg.automatic_tank_gauging_continuous_leak_detection,
    rd_agg.tank_manual_tank_gauging,
    rd_agg.tank_statistical_inventory_reconciliation,
    rd_agg.tank_tightness_testing,
    rd_agg.tank_inventory_control,
    rd_agg.tank_groundwater_monitoring,
    rd_agg.tank_vapor_monitoring,
    rd_agg.tank_other_release_detection
   FROM (((((nm_ust."Info" x
     LEFT JOIN nm_ust.erg_compartment_id c ON ((((x."FACILITY_ID")::text = (c.facility_id)::text) AND (x."TANK_ID" = c.tank_id))))
     LEFT JOIN nm_ust.v_compartment_status_xwalk cs ON ((x."TANK_STATUS" = (cs.organization_value)::text)))
     LEFT JOIN tank_spill_prevention sp_agg ON (((x."TANK_ID")::double precision = sp_agg."TANK_ID")))
     LEFT JOIN tank_release_detection rd_agg ON (((x."TANK_ID")::double precision = rd_agg."TANK_ID")))
     JOIN nm_ust.v_tanks t ON (((x."FACILITY_ID" = t."FACILITY_ID") AND (x."TANK_ID" = t."TANK_ID"))));;




/*********** v_ust_piping ***********/


--View definition for nm_ust.v_ust_piping:
 WITH piping AS (
         SELECT p."TANK_ID",
            max(
                CASE
                    WHEN (p."TANK_DETAIL_DESCRIPTION" = 'FIBERGLASS REINFORCED PLASTIC'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS piping_material_frp,
            max(
                CASE
                    WHEN (p."TANK_DETAIL_DESCRIPTION" = ANY (ARRAY['BARE OR GALVANIZED STEEL'::text, 'COATED STEEL'::text, 'WRAPPED STEEL'::text, 'BLACK STEEL'::text])) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS piping_material_steel,
            max(
                CASE
                    WHEN (p."TANK_DETAIL_DESCRIPTION" = 'COPPER'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS piping_material_copper,
            max(
                CASE
                    WHEN (p."TANK_DETAIL_DESCRIPTION" = 'FLEXIBLE PIPING'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS piping_material_flex,
            max(
                CASE
                    WHEN (p."TANK_DETAIL_DESCRIPTION" = 'OTHER'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS piping_material_other,
            max(
                CASE
                    WHEN (p."TANK_DETAIL_DESCRIPTION" = ANY (ARRAY['UNKNOWN'::text, 'UNDERGROUND'::text])) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS piping_material_unknown
           FROM nm_ust.v_erg_piping p
          GROUP BY p."TANK_ID"
        ), corrosion_prevention AS (
         SELECT cp."TANK_ID",
            max(
                CASE
                    WHEN (cp."TANK_DETAIL_DESCRIPTION" = ANY (ARRAY['FLEX CONNECTOR - ISOLATION BOOT'::text, 'FLEX CONNECTOR - ANODE'::text])) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS piping_flex_connector,
            max(
                CASE
                    WHEN (cp."TANK_DETAIL_DESCRIPTION" = 'SACRIFICIAL ANODE UPGRADE - PIPING'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS piping_corrosion_protection_sacrificial_anode,
            max(
                CASE
                    WHEN (cp."TANK_DETAIL_DESCRIPTION" = 'IMPRESSED CURRENT UPGRADE - PIPING'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS piping_corrosion_protection_impressed_current,
            max(
                CASE
                    WHEN (cp."TANK_DETAIL_DESCRIPTION" = 'N/A - Piping'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS piping_corrosion_protection_cathodic_not_required,
            max(
                CASE
                    WHEN (cp."TANK_DETAIL_DESCRIPTION" = ANY (ARRAY['EXEMPT - SITE NOT CORROSIVE'::text, 'CP PIPING - OTHER'::text])) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS piping_corrosion_protection_other,
            max(
                CASE
                    WHEN (cp."TANK_DETAIL_DESCRIPTION" = 'UNKNOWN - PIPING'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS piping_corrosion_protection_unknown
           FROM nm_ust.v_erg_corrosion_prevention cp
          GROUP BY cp."TANK_ID"
        ), piping_release_detection AS (
         SELECT rd."TANK_ID",
            max(
                CASE
                    WHEN (rd."TANK_DETAIL_DESCRIPTION" = ANY (ARRAY['MECHANICAL LINE LEAK DETECTOR'::text, 'ELECTRONIC LINE LEAK DETECTOR'::text])) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS piping_line_leak_detector,
            max(
                CASE
                    WHEN ((rd."TANK_DETAIL_DESCRIPTION" = 'LINE TIGHTNESS TESTING'::text) AND (p."TANK_DETAIL_DESCRIPTION" = 'PRESSURIZED'::text)) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS piping_line_test_annual,
            max(
                CASE
                    WHEN ((rd."TANK_DETAIL_DESCRIPTION" = 'LINE TIGHTNESS TESTING'::text) AND (p."TANK_DETAIL_DESCRIPTION" = ANY (ARRAY['SUCTION'::text, 'NONE - SIPHON SYSTEM'::text]))) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS piping_line_test3yr,
            max(
                CASE
                    WHEN (rd."TANK_DETAIL_DESCRIPTION" = 'GROUND WATER MONITORING'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS piping_groundwater_monitoring,
            max(
                CASE
                    WHEN (rd."TANK_DETAIL_DESCRIPTION" = 'VAPOR MONITORING'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS piping_vapor_monitoring,
            max(
                CASE
                    WHEN (rd."TANK_DETAIL_DESCRIPTION" = 'INTERSTITIAL MONITORING'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS piping_interstitial_monitoring,
            max(
                CASE
                    WHEN (rd."TANK_DETAIL_DESCRIPTION" = 'SIR - STATISTICAL INV RECON'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS piping_statistical_inventory_reconciliation,
            max(
                CASE
                    WHEN (rd."TANK_DETAIL_DESCRIPTION" = 'APPROVED ALTERNATE METHOD - PIPING'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS piping_release_detection_other
           FROM (nm_ust.v_erg_piping_release_detection rd
             LEFT JOIN nm_ust.v_erg_piping p ON ((rd."TANK_ID" = p."TANK_ID")))
          GROUP BY rd."TANK_ID"
        ), sec_contain AS (
         SELECT sc."TANK_ID",
            sc."TANK_DETAIL_DESCRIPTION",
            row_number() OVER (PARTITION BY sc."TANK_ID" ORDER BY sc."TANK_DETAIL_DESCRIPTION" DESC) AS row_num
           FROM nm_ust.v_erg_secondary_containment sc
          WHERE (sc."TANK_DETAIL_DESCRIPTION" = ANY (ARRAY['APPROVED ALTERNATE METHOD - PIPING'::text, 'DOUBLE WALLED PIPING'::text, 'EXEMPT - NEW UST MEETS EXEMPTION REQUIREMENTS'::text, 'NONE'::text, 'NOT APPLICABLE - PIPING'::text]))
        ), piping_style AS (
         SELECT ps_1."TANK_ID",
            ps_1."TANK_DETAIL_DESCRIPTION",
            row_number() OVER (PARTITION BY ps_1."TANK_ID" ORDER BY ps_1."TANK_DETAIL_DESCRIPTION" DESC) AS row_num
           FROM nm_ust.v_erg_piping ps_1
          WHERE (ps_1."TANK_DETAIL_DESCRIPTION" = ANY (ARRAY['NONE'::text, 'NONE - SIPHON SYSTEM'::text, 'OTHER'::text, 'PRESSURIZED'::text, 'SUCTION'::text, 'UNKNOWN'::text]))
        )
 SELECT DISTINCT (x."FACILITY_ID")::character varying AS facility_id,
    (x."TANK_ID")::integer AS tank_id,
    c.compartment_id,
    (pi.piping_id)::character varying AS piping_id,
    ps.piping_style_id,
        CASE
            WHEN ((p_agg.piping_material_frp IS NOT NULL) OR (p_agg.piping_material_steel IS NOT NULL) OR (p_agg.piping_material_copper IS NOT NULL) OR (p_agg.piping_material_flex IS NOT NULL) OR (p_agg.piping_material_other IS NOT NULL) OR (p_agg.piping_material_unknown IS NOT NULL)) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_frp,
    p_agg.piping_material_steel,
    p_agg.piping_material_copper,
    p_agg.piping_material_flex,
    p_agg.piping_material_other,
    p_agg.piping_material_unknown,
        CASE
            WHEN ((cp_agg.piping_flex_connector IS NOT NULL) OR (cp_agg.piping_corrosion_protection_sacrificial_anode IS NOT NULL) OR (cp_agg.piping_corrosion_protection_impressed_current IS NOT NULL) OR (cp_agg.piping_corrosion_protection_cathodic_not_required IS NOT NULL) OR (cp_agg.piping_corrosion_protection_other IS NOT NULL) OR (cp_agg.piping_corrosion_protection_unknown IS NOT NULL)) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_flex_connector,
    cp_agg.piping_corrosion_protection_sacrificial_anode,
    cp_agg.piping_corrosion_protection_impressed_current,
    cp_agg.piping_corrosion_protection_cathodic_not_required,
    cp_agg.piping_corrosion_protection_other,
    cp_agg.piping_corrosion_protection_unknown,
        CASE
            WHEN ((rd_agg.piping_line_leak_detector IS NOT NULL) OR (rd_agg.piping_line_test_annual IS NOT NULL) OR (rd_agg.piping_line_test3yr IS NOT NULL) OR (rd_agg.piping_groundwater_monitoring IS NOT NULL) OR (rd_agg.piping_vapor_monitoring IS NOT NULL) OR (rd_agg.piping_interstitial_monitoring IS NOT NULL) OR (rd_agg.piping_statistical_inventory_reconciliation IS NOT NULL) OR (rd_agg.piping_release_detection_other IS NOT NULL)) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_line_leak_detector,
    rd_agg.piping_line_test_annual,
    rd_agg.piping_line_test3yr,
    rd_agg.piping_groundwater_monitoring,
    rd_agg.piping_vapor_monitoring,
    rd_agg.piping_interstitial_monitoring,
    rd_agg.piping_statistical_inventory_reconciliation,
    rd_agg.piping_release_detection_other,
        CASE
            WHEN (sc_agg."TANK_DETAIL_DESCRIPTION" = ANY (ARRAY['EXEMPT - NEW UST MEETS EXEMPTION REQUIREMENTS'::text, 'NONE'::text, 'NOT APPLICABLE - PIPING'::text])) THEN NULL::integer
            ELSE pwt.piping_wall_type_id
        END AS piping_wall_type_id,
        CASE
            WHEN (sc_agg."TANK_DETAIL_DESCRIPTION" = 'APPROVED ALTERNATE METHOD - PIPING'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS pipe_secondary_containment_other
   FROM ((((((((((nm_ust."Info" x
     LEFT JOIN nm_ust.erg_compartment_id c ON ((((x."FACILITY_ID")::text = (c.facility_id)::text) AND (x."TANK_ID" = c.tank_id))))
     LEFT JOIN nm_ust.erg_piping_id pi ON ((((x."FACILITY_ID")::text = (pi.facility_id)::text) AND (x."TANK_ID" = pi.tank_id) AND (c.compartment_id = pi.compartment_id))))
     LEFT JOIN piping p_agg ON (((x."TANK_ID")::double precision = p_agg."TANK_ID")))
     LEFT JOIN piping_style ps_agg ON ((((x."TANK_ID")::double precision = ps_agg."TANK_ID") AND (ps_agg.row_num = 1))))
     LEFT JOIN nm_ust.v_piping_style_xwalk ps ON ((ps_agg."TANK_DETAIL_DESCRIPTION" = (ps.organization_value)::text)))
     LEFT JOIN corrosion_prevention cp_agg ON (((x."TANK_ID")::double precision = cp_agg."TANK_ID")))
     LEFT JOIN piping_release_detection rd_agg ON (((x."TANK_ID")::double precision = rd_agg."TANK_ID")))
     LEFT JOIN sec_contain sc_agg ON ((((x."TANK_ID")::double precision = sc_agg."TANK_ID") AND (sc_agg.row_num = 1))))
     LEFT JOIN nm_ust.v_piping_wall_type_xwalk pwt ON ((sc_agg."TANK_DETAIL_DESCRIPTION" = (pwt.organization_value)::text)))
     JOIN nm_ust.v_tanks t ON (((x."FACILITY_ID" = t."FACILITY_ID") AND (x."TANK_ID" = t."TANK_ID"))));;

