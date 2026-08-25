


/*********** v_ust_facility ***********/


--View definition for ma_ust.v_ust_facility:
 WITH src AS (
         SELECT (a."Facility ID#")::character varying(50) AS facility_id,
            (a."FAC NAME")::character varying(100) AS facility_name,
            d.facility_type_id AS facility_type1,
            (a."FAC ADD 1")::character varying(100) AS facility_address1,
            (a."FAC ADD 2")::character varying(100) AS facility_address2,
            (a."FAC CITY")::character varying(100) AS facility_city,
            (a."FAC ZIP")::character varying(10) AS facility_zip_code,
                CASE
                    WHEN (a."FAC STATE" IS NOT NULL) THEN (a."FAC STATE")::character varying(2)
                    ELSE 'MA'::character varying(2)
                END AS facility_state,
            (a."FAC LAT")::double precision AS facility_latitude,
            (a."FAC LONG")::double precision AS facility_longitude,
            e.owner_type_id,
            b.fr_type_name
           FROM ((((ma_ust.erg_facility_final a
             LEFT JOIN ma_ust.erg_facility_info_fr_type b ON ((((a."Facility ID#")::character varying(50))::text = b.facility_id)))
             LEFT JOIN ma_ust.v_facility_type_xwalk d ON ((a."FAC TYPE" = (d.organization_value)::text)))
             LEFT JOIN ma_ust.erg_facility_info_org_type c ON ((((a."Facility ID#")::character varying(50))::text = c.facility_id)))
             LEFT JOIN ma_ust.v_owner_type_xwalk e ON ((c.org_type_name = (e.organization_value)::text)))
          WHERE (NOT (EXISTS ( SELECT 1
                   FROM ma_ust.erg_unregulated_facilities unreg
                  WHERE (((a."Facility ID#")::character varying(50))::text = (unreg.facility_id)::text))))
        )
 SELECT src.facility_id,
    (max((src.facility_name)::text))::character varying(100) AS facility_name,
    min(src.owner_type_id) AS owner_type_id,
    min(src.facility_type1) AS facility_type1,
    (max((src.facility_address1)::text))::character varying(100) AS facility_address1,
    (max((src.facility_address2)::text))::character varying(100) AS facility_address2,
    (max((src.facility_city)::text))::character varying(100) AS facility_city,
    (max((src.facility_zip_code)::text))::character varying(10) AS facility_zip_code,
    (max((src.facility_state)::text))::character varying(2) AS facility_state,
    1 AS facility_epa_region,
    max(src.facility_latitude) AS facility_latitude,
    max(src.facility_longitude) AS facility_longitude,
        CASE
            WHEN bool_or((src.fr_type_name IS NOT NULL)) THEN 'Yes'::text
            ELSE NULL::text
        END AS financial_responsibility_obtained,
        CASE
            WHEN bool_or((src.fr_type_name = 'Local Government Bond Rating Test'::text)) THEN 'Yes'::text
            ELSE NULL::text
        END AS financial_responsibility_bond_rating_test,
        CASE
            WHEN bool_or((src.fr_type_name = 'Commercial Insurance'::text)) THEN 'Yes'::text
            ELSE NULL::text
        END AS financial_responsibility_commercial_insurance,
        CASE
            WHEN bool_or((src.fr_type_name = 'Guarantee'::text)) THEN 'Yes'::text
            ELSE NULL::text
        END AS financial_responsibility_guarantee,
        CASE
            WHEN bool_or((src.fr_type_name = 'Irrevocable Standby Letter of Credit'::text)) THEN 'Yes'::text
            ELSE NULL::text
        END AS financial_responsibility_letter_of_credit,
        CASE
            WHEN bool_or((src.fr_type_name = 'Local Government Financial Test of Insurance'::text)) THEN 'Yes'::text
            ELSE NULL::text
        END AS financial_responsibility_local_government_financial_test,
        CASE
            WHEN bool_or((src.fr_type_name = 'Risk Retention Group Coverage'::text)) THEN 'Yes'::text
            ELSE NULL::text
        END AS financial_responsibility_risk_retention_group,
        CASE
            WHEN bool_or((src.fr_type_name = 'Financial Test of Insurance'::text)) THEN 'Yes'::text
            ELSE NULL::text
        END AS financial_responsibility_self_insurance_financial_test,
        CASE
            WHEN bool_or((src.fr_type_name = 'Surety Bond'::text)) THEN 'Yes'::text
            ELSE NULL::text
        END AS financial_responsibility_surety_bond,
        CASE
            WHEN bool_or((src.fr_type_name = 'Trust Fund"'::text)) THEN 'Yes'::text
            ELSE NULL::text
        END AS financial_responsibility_trust_fund,
        CASE
            WHEN bool_or((src.fr_type_name = ANY (ARRAY['Local Government Fund'::text, 'Local Government Guarantee'::text]))) THEN 'Yes'::text
            ELSE NULL::text
        END AS financial_responsibility_other_method
   FROM src
  GROUP BY src.facility_id;;




/*********** v_ust_tank ***********/


--View definition for ma_ust.v_ust_tank:
 SELECT DISTINCT (a."Facility ID#")::character varying(50) AS facility_id,
    (a."TANK ID#")::integer AS tank_id,
    d.tank_status_id,
        CASE
            WHEN (a."STATUS" = 'Tank Closure In-Place'::text) THEN (a."STATUS DATE")::date
            ELSE NULL::date
        END AS tank_closure_date,
    (a."INSTALL DATE")::date AS tank_installation_date,
        CASE
            WHEN (a."NUMBER OF COMPARTMENT" > (1)::double precision) THEN 'Yes'::text
            ELSE NULL::text
        END AS compartmentalized_ust,
    (a."NUMBER OF COMPARTMENT")::integer AS number_of_compartments,
    b.tank_material_description_id,
        CASE
            WHEN (a."TANK CORROSION TYPE" = ANY (ARRAY['Manufactured Sacrificial Anode (Galvanic) System'::text, 'Field Constructed Sacrificial Anode (Galvanic) System'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_sacrificial_anode,
        CASE
            WHEN (a."TANK CORROSION TYPE" = 'Field Constructed Impressed Current System'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_impressed_current,
        CASE
            WHEN (a."TANK CONSTRUCT" ~~ '%cathodic protection not required%'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_cathodic_not_required,
    c.tank_secondary_containment_id
   FROM (((ma_ust."Tank info" a
     LEFT JOIN ma_ust.v_tank_material_description_xwalk b ON ((a."TANK CONSTRUCT" = (b.organization_value)::text)))
     LEFT JOIN ma_ust.v_tank_secondary_containment_xwalk c ON ((a."TANK CONSTRUCT" = (c.organization_value)::text)))
     LEFT JOIN ma_ust.v_tank_status_xwalk d ON ((a."STATUS" = (d.organization_value)::text)))
  WHERE ((NOT (EXISTS ( SELECT 1
           FROM ma_ust.erg_unregulated_tanks unreg
          WHERE ((((a."Facility ID#")::character varying(50))::text = (unreg.facility_id)::text) AND ((a."TANK ID#")::integer = unreg.tank_id))))) AND (NOT (EXISTS ( SELECT 1
           FROM ma_ust.erg_unregulated_facilities unreg_fac
          WHERE (((a."Facility ID#")::character varying(50))::text = (unreg_fac.facility_id)::text)))));;




/*********** v_ust_tank_substance ***********/


--View definition for ma_ust.v_ust_tank_substance:
 SELECT DISTINCT (a."Facility ID#")::character varying(50) AS facility_id,
    (a."TANK ID#")::integer AS tank_id,
    b.substance_id
   FROM (ma_ust."Tank info" a
     JOIN ma_ust.v_substance_xwalk b ON ((a."CONTENT" = (b.organization_value)::text)))
  WHERE ((b.substance_id IS NOT NULL) AND (NOT (EXISTS ( SELECT 1
           FROM ma_ust.erg_unregulated_tanks unreg
          WHERE ((((a."Facility ID#")::character varying(50))::text = (unreg.facility_id)::text) AND ((a."TANK ID#")::integer = unreg.tank_id))))) AND (EXISTS ( SELECT 1
           FROM ma_ust.erg_facility_final x
          WHERE (((a."Facility ID#")::character varying(50))::text = ((x."Facility ID#")::character varying(50))::text))) AND (NOT (EXISTS ( SELECT 1
           FROM ma_ust.erg_unregulated_tanks unreg
          WHERE (((a."Facility ID#")::character varying(50))::text = (unreg.facility_id)::text)))));;




/*********** v_ust_compartment ***********/


--View definition for ma_ust.v_ust_compartment:
 WITH src AS (
         SELECT a."Facility ID#",
            a."TANK ID#",
            a."INSTALL DATE",
            a."LONG",
            a."LAT",
            a."NUMBER OF COMPARTMENT",
            a."CAPACITY",
            a."USE TYPE",
            a."CONTENT",
            a."STATUS",
            a."STATUS DATE",
            a."TANK CONSTRUCT",
            a."TANK LEAK DETECT",
            a."PIPE INSTALL DATE",
            a."PIPE TYPE",
            a."PIPE CONSTRUCT",
            a."PIPE LEAK DETECT",
            a."PIPE LEAK INSTALL",
            a."SUBMERSIBLE SUMP",
            a."SUBMERSIBLE SUMP INSTALL",
            a."TURBINE SUMP",
            a."TURBINE SUMP SENSOR",
            a."INTERMEDIATE SUMP",
            a."INTERMEDIATE SUMP SENSOR",
            a."SPILL BUCKET INSTALLED",
            a."SPILL BUCKET SENSOR",
            a."OVERFILL PROTECT INSTALLED",
            a."OVERFILL PROTECT TYPE",
            a."AUTOMATIC LINE LEAK DTECT",
            a."TANK CORROSION TYPE",
            a."LEAK CORROSION TYPE",
            (a."Facility ID#")::character varying(50) AS facility_id,
            (a."TANK ID#")::integer AS tank_id,
            row_number() OVER (PARTITION BY ((a."Facility ID#")::character varying(50)), ((a."TANK ID#")::integer) ORDER BY a.ctid) AS rn
           FROM ma_ust."Tank info" a
          WHERE ((NOT (EXISTS ( SELECT 1
                   FROM ma_ust.erg_unregulated_tanks unreg
                  WHERE ((((a."Facility ID#")::character varying(50))::text = (unreg.facility_id)::text) AND ((a."TANK ID#")::integer = unreg.tank_id))))) AND (NOT (EXISTS ( SELECT 1
                   FROM ma_ust.erg_unregulated_facilities unreg_fac
                  WHERE (((a."Facility ID#")::character varying(50))::text = (unreg_fac.facility_id)::text)))) AND (EXISTS ( SELECT 1
                   FROM ma_ust.v_ust_facility fac
                  WHERE (((a."Facility ID#")::character varying(50))::text = (fac.facility_id)::text))))
        ), id_map AS (
         SELECT erg_compartment_id.facility_id,
            erg_compartment_id.tank_id,
            erg_compartment_id.compartment_id,
            row_number() OVER (PARTITION BY erg_compartment_id.facility_id, erg_compartment_id.tank_id ORDER BY erg_compartment_id.compartment_id) AS rn
           FROM ma_ust.erg_compartment_id
        ), status_xwalk AS (
         SELECT v_compartment_status_xwalk.organization_value,
            min(v_compartment_status_xwalk.compartment_status_id) AS compartment_status_id
           FROM ma_ust.v_compartment_status_xwalk
          GROUP BY v_compartment_status_xwalk.organization_value
        )
 SELECT s.facility_id,
    s.tank_id,
    x.compartment_id,
    b.compartment_status_id,
    (s."CAPACITY")::integer AS compartment_capacity_gallons,
        CASE
            WHEN (s."OVERFILL PROTECT TYPE" = 'Ball Float'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_ball_float_valve,
        CASE
            WHEN (s."OVERFILL PROTECT TYPE" = 'Automatic shut-off valve'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_flow_shutoff_device,
        CASE
            WHEN (s."OVERFILL PROTECT TYPE" = 'High level alarm'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_high_level_alarm,
        CASE
            WHEN (s."SPILL BUCKET SENSOR" = 'Y'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS spill_bucket_installed,
        CASE
            WHEN (s."TANK LEAK DETECT" = 'Continuous Interstitial Monitoring'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_interstitial_monitoring,
        CASE
            WHEN (s."TANK LEAK DETECT" = ANY (ARRAY['In-Tank Monitoring with Statistical Inventory Reconciliation Vendor'::text, 'In-Tank Monitoring System'::text, 'In tank monitor up to 2 gal per hour'::text, 'In tank monitor w/ detection rate up to 1 gal/hr'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_automatic_tank_gauging_release_detection,
        CASE
            WHEN (s."TANK LEAK DETECT" = 'Continuous In-Tank Monitoring System'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS automatic_tank_gauging_continuous_leak_detection,
        CASE
            WHEN (s."TANK LEAK DETECT" = ANY (ARRAY['Manual Tank Gauging (1,000G or less capacity tank)'::text, 'Manual Tank Gauging (1,000G or more capacity tank)'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_manual_tank_gauging,
        CASE
            WHEN (s."TANK LEAK DETECT" = 'In-Tank Monitoring with Statistical Inventory Reconciliation Vendor'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_statistical_inventory_reconciliation,
        CASE
            WHEN (s."TANK LEAK DETECT" = ANY (ARRAY['Annual Bulk Tightness Test'::text, 'Annual tightness test w/ detection rate 0.5 gal/hr'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_tightness_testing,
        CASE
            WHEN (s."TANK LEAK DETECT" = 'Soil Vapor Monitoring'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_vapor_monitoring
   FROM ((src s
     JOIN id_map x ON ((((s.facility_id)::text = (x.facility_id)::text) AND (s.tank_id = x.tank_id) AND (s.rn = x.rn))))
     LEFT JOIN status_xwalk b ON ((s."STATUS" = (b.organization_value)::text)));;




/*********** v_ust_piping ***********/


--View definition for ma_ust.v_ust_piping:
 WITH src AS (
         SELECT a."Facility ID#",
            a."TANK ID#",
            a."INSTALL DATE",
            a."LONG",
            a."LAT",
            a."NUMBER OF COMPARTMENT",
            a."CAPACITY",
            a."USE TYPE",
            a."CONTENT",
            a."STATUS",
            a."STATUS DATE",
            a."TANK CONSTRUCT",
            a."TANK LEAK DETECT",
            a."PIPE INSTALL DATE",
            a."PIPE TYPE",
            a."PIPE CONSTRUCT",
            a."PIPE LEAK DETECT",
            a."PIPE LEAK INSTALL",
            a."SUBMERSIBLE SUMP",
            a."SUBMERSIBLE SUMP INSTALL",
            a."TURBINE SUMP",
            a."TURBINE SUMP SENSOR",
            a."INTERMEDIATE SUMP",
            a."INTERMEDIATE SUMP SENSOR",
            a."SPILL BUCKET INSTALLED",
            a."SPILL BUCKET SENSOR",
            a."OVERFILL PROTECT INSTALLED",
            a."OVERFILL PROTECT TYPE",
            a."AUTOMATIC LINE LEAK DTECT",
            a."TANK CORROSION TYPE",
            a."LEAK CORROSION TYPE",
            (a."Facility ID#")::character varying(50) AS facility_id,
            (a."TANK ID#")::integer AS tank_id,
            row_number() OVER (PARTITION BY ((a."Facility ID#")::character varying(50)), ((a."TANK ID#")::integer) ORDER BY a.ctid) AS rn
           FROM ma_ust."Tank info" a
          WHERE ((NOT (EXISTS ( SELECT 1
                   FROM ma_ust.erg_unregulated_tanks unreg
                  WHERE ((((a."Facility ID#")::character varying(50))::text = (unreg.facility_id)::text) AND ((a."TANK ID#")::integer = unreg.tank_id))))) AND (NOT (EXISTS ( SELECT 1
                   FROM ma_ust.erg_unregulated_facilities unreg_fac
                  WHERE (((a."Facility ID#")::character varying(50))::text = (unreg_fac.facility_id)::text)))) AND (EXISTS ( SELECT 1
                   FROM ma_ust.v_ust_facility fac
                  WHERE (((a."Facility ID#")::character varying(50))::text = (fac.facility_id)::text))))
        ), id_map AS (
         SELECT erg_compartment_id.facility_id,
            erg_compartment_id.tank_id,
            erg_compartment_id.compartment_id,
            row_number() OVER (PARTITION BY erg_compartment_id.facility_id, erg_compartment_id.tank_id ORDER BY erg_compartment_id.compartment_id) AS rn
           FROM ma_ust.erg_compartment_id
        ), piping_map AS (
         SELECT erg_piping_id.facility_id,
            erg_piping_id.tank_id,
            erg_piping_id.compartment_id,
            erg_piping_id.piping_id,
            row_number() OVER (PARTITION BY erg_piping_id.facility_id, erg_piping_id.tank_id, erg_piping_id.compartment_id ORDER BY erg_piping_id.piping_id) AS rn
           FROM ma_ust.erg_piping_id
        ), tank_top_sump AS (
         SELECT vw_erg_pipe_tank_top_sump."Facility ID#",
            vw_erg_pipe_tank_top_sump."TANK ID#",
            (min(vw_erg_pipe_tank_top_sump.pipe_tank_top_sump))::character varying(7) AS pipe_tank_top_sump
           FROM ma_ust.vw_erg_pipe_tank_top_sump
          GROUP BY vw_erg_pipe_tank_top_sump."Facility ID#", vw_erg_pipe_tank_top_sump."TANK ID#"
        )
 SELECT src.facility_id,
    src.tank_id,
    id_map.compartment_id,
    (piping_map.piping_id)::character varying(50) AS piping_id,
    c.piping_style_id,
        CASE
            WHEN (src."PIPE TYPE" = 'European suction system'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS safe_suction,
        CASE
            WHEN (src."PIPE TYPE" = 'Non-European suction System'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS american_suction,
        CASE
            WHEN (src."PIPE TYPE" = ANY (ARRAY['Pressurized piping system with electronic automatic line leak detection'::text, 'Pressurized piping system with mechanical automatic line leak detection'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS high_pressure_or_bulk_piping,
        CASE
            WHEN (src."PIPE CONSTRUCT" = 'Single-walled metal (Corrosion protection required)'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_corrosion_protection_sacrificial_anode,
        CASE
            WHEN (src."LEAK CORROSION TYPE" = 'Field Constructed Impressed Current System'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_corrosion_protection_impressed_current,
        CASE
            WHEN (src."PIPE LEAK DETECT" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_line_leak_detector,
        CASE
            WHEN (src."PIPE LEAK DETECT" = 'Annual Automatic Line Leak Detection Test'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_line_test_annual,
        CASE
            WHEN (src."PIPE LEAK DETECT" = 'Continuous Interstitial Space Monitoring'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_interstitial_monitoring,
        CASE
            WHEN (src."PIPE LEAK DETECT" = 'In-tank monitoring with SIR (if installed prior to May 28, 1999)'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_statistical_inventory_reconciliation,
        CASE
            WHEN (src."PIPE LEAK DETECT" = ANY (ARRAY['Annual tightness test of Non-European suction systems (only if installed prior to 1/1/1989) without '::text, 'Annual Tightness Test of Single-Walled Pressurized Piping Systems'::text, 'Quarterly visual inspection and annual product line tightness test (only if installed prior to 5/28/'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_release_detection_other,
    tank_top_sump.pipe_tank_top_sump,
    d.piping_wall_type_id
   FROM (((((src
     JOIN id_map ON ((((src.facility_id)::text = (id_map.facility_id)::text) AND (src.tank_id = id_map.tank_id) AND (src.rn = id_map.rn))))
     JOIN piping_map ON ((((id_map.facility_id)::text = (piping_map.facility_id)::text) AND (id_map.tank_id = piping_map.tank_id) AND (id_map.compartment_id = piping_map.compartment_id))))
     LEFT JOIN ma_ust.v_piping_style_xwalk c ON ((src."PIPE TYPE" = (c.organization_value)::text)))
     LEFT JOIN ma_ust.v_piping_wall_type_xwalk d ON ((src."PIPE CONSTRUCT" = (d.organization_value)::text)))
     LEFT JOIN tank_top_sump ON (((src."Facility ID#" = tank_top_sump."Facility ID#") AND (src."TANK ID#" = tank_top_sump."TANK ID#"))));;




/*********** v_ust_facility_dispenser ***********/


--View definition for ma_ust.v_ust_facility_dispenser:
 SELECT DISTINCT (a."Facility ID#")::character varying(50) AS facility_id,
    (a.dispenser_number)::character varying(50) AS dispenser_id
   FROM ma_ust."Dispenser info" a
  WHERE ((NOT (EXISTS ( SELECT 1
           FROM ma_ust.erg_unregulated_tanks unreg
          WHERE (((a."Facility ID#")::character varying(50))::text = (unreg.facility_id)::text)))) AND (NOT (EXISTS ( SELECT 1
           FROM ma_ust.erg_unregulated_facilities unreg_fac
          WHERE (((a."Facility ID#")::character varying(50))::text = (unreg_fac.facility_id)::text)))) AND (EXISTS ( SELECT 1
           FROM ma_ust.v_ust_facility fac
          WHERE (((a."Facility ID#")::character varying(50))::text = (fac.facility_id)::text))));;

