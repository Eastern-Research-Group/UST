-- Current live tn_ust.v_ust_* view definitions.
-- Exported UTC: 2026-10-23T21:41:04.741966+00:00
-- Includes views regardless of template metadata registration.
-- Ordered by dependencies within this export. Other source objects must exist.
-- Definitions only; ownership, grants, and comments are not exported.

BEGIN;

-- tn_ust.v_ust_facility
CREATE OR REPLACE VIEW "tn_ust"."v_ust_facility" AS
 SELECT DISTINCT a.facility_id,
    a.facility_name,
    f.owner_type_id,
    e.facility_type_id AS facility_type1,
    a.facility_address1,
    a.facility_address2,
    a.facility_city,
    a.facility_zip_code,
    a.facility_state,
    4 AS facility_epa_region,
    a.facility_latitude,
    a.facility_longitude,
    c."OWNER_NAME"::character varying(100) AS facility_owner_company_name,
        CASE
            WHEN d."Facilityid" IS NOT NULL THEN 'Yes'::text
            ELSE NULL::text
        END AS ust_reported_release,
    d.release_id::character varying(40) AS associated_ust_release_id
   FROM tn_ust.v_facilities a
     LEFT JOIN tn_ust.v_owner_types b ON a.facility_id::text = b.facility_id::text
     LEFT JOIN ( SELECT tn_facilities_merged."FACILITY_ID_UST",
            max(tn_facilities_merged."OWNER_NAME") AS "OWNER_NAME",
            max(tn_facilities_merged."FACILITY_TYPE") AS "FACILITY_TYPE"
           FROM tn_ust.tn_facilities_merged
          GROUP BY tn_facilities_merged."FACILITY_ID_UST") c ON a.facility_id::text = c."FACILITY_ID_UST"::text
     LEFT JOIN ( SELECT tn_environmental_sites."Facilityid",
            max(tn_environmental_sites.release_id::text) AS release_id
           FROM tn_ust.tn_environmental_sites
          GROUP BY tn_environmental_sites."Facilityid") d ON a.facility_id::text = d."Facilityid"
     LEFT JOIN tn_ust.v_facility_type_xwalk e ON c."FACILITY_TYPE" = e.organization_value::text
     LEFT JOIN tn_ust.v_owner_type_xwalk f ON b.owner_type = f.organization_value::text
     LEFT JOIN tn_ust.v_state_xwalk g ON a.facility_state::text = g.organization_value::text
  WHERE NOT (EXISTS ( SELECT 1
           FROM tn_ust.erg_unregulated_facilities unreg
          WHERE a.facility_id::text = unreg.facility_id::text)) AND COALESCE(e.exclude_from_query, 'N'::character varying)::text <> 'Y'::text AND COALESCE(f.exclude_from_query, 'N'::character varying)::text <> 'Y'::text AND COALESCE(g.exclude_from_query, 'N'::character varying)::text <> 'Y'::text;

-- tn_ust.v_ust_tank
CREATE OR REPLACE VIEW "tn_ust"."v_ust_tank" AS
 SELECT DISTINCT a."Facility Id Ust"::character varying(50) AS facility_id,
    a."Tank Id"::integer AS tank_id,
    a."Tank Number"::character varying(50) AS tank_name,
    f.tank_status_id,
        CASE
            WHEN a."Regulated Status" = 'Regulated'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS federally_regulated,
        CASE
            WHEN a."Emergency Generator" = 'Emergency Generator'::text THEN 'Yes'::text
            WHEN a."Emergency Generator" = 'Not Emergency Generator'::text THEN 'No'::text
            ELSE NULL::text
        END AS emergency_generator,
    a."Date Tank Closed"::date AS tank_closure_date,
    a."Date Tank Installed"::date AS tank_installation_date,
    c.compartmentalized_ust,
    c.number_of_compartments::integer AS number_of_compartments,
    d.tank_material_description_id,
        CASE
            WHEN a."Tank Construction" = 'Cathodically Protected Steel-StiP3'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_sacrificial_anode,
    e.tank_secondary_containment_id
   FROM tn_ust.tn_compartments_merged a
     LEFT JOIN tn_ust.v_tank_status b ON a."Facility Id Ust"::character varying::text = b."Facility Id Ust"::character varying::text AND a."Tank Id"::integer = b."Tank Id"::integer
     LEFT JOIN tn_ust.v_tank_compartments c ON a."Facility Id Ust"::character varying::text = c."Facility Id Ust"::character varying::text AND a."Tank Id"::integer = c."Tank Id"::integer
     LEFT JOIN tn_ust.v_tank_material_description_xwalk d ON a."Tank Construction" = d.organization_value::text
     LEFT JOIN tn_ust.v_tank_secondary_containment_xwalk e ON a."Category Of Construction" = e.organization_value::text
     LEFT JOIN tn_ust.v_tank_status_xwalk f ON b."Status"::text = f.organization_value::text
  WHERE NOT (EXISTS ( SELECT 1
           FROM tn_ust.erg_unregulated_facilities unreg_fac
          WHERE a."Facility Id Ust"::character varying::text = unreg_fac.facility_id::text)) AND NOT (EXISTS ( SELECT 1
           FROM tn_ust.erg_unregulated_tanks unreg_tank
          WHERE a."Facility Id Ust"::character varying::text = unreg_tank.facility_id::text AND a."Tank Id"::integer = unreg_tank.tank_id)) AND (EXISTS ( SELECT 1
           FROM tn_ust.tn_facilities_merged parent
          WHERE parent."FACILITY_ID_UST"::text = a."Facility Id Ust"::character varying::text)) AND COALESCE(d.exclude_from_query, 'N'::character varying)::text <> 'Y'::text AND COALESCE(e.exclude_from_query, 'N'::character varying)::text <> 'Y'::text AND COALESCE(f.exclude_from_query, 'N'::character varying)::text <> 'Y'::text;

-- tn_ust.v_ust_compartment
CREATE OR REPLACE VIEW "tn_ust"."v_ust_compartment" AS
 SELECT DISTINCT a."Facility Id Ust"::character varying(50) AS facility_id,
    a."Tank Id"::integer AS tank_id,
    a."Compartment Id"::integer AS compartment_id,
    a."Compartment Letter"::character varying(50) AS compartment_name,
    f.compartment_status_id,
    a."Compartment Capacity"::integer AS compartment_capacity_gallons,
        CASE
            WHEN a."Overfill Prevention" = 'Ball Float Valves'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_ball_float_valve,
        CASE
            WHEN a."Overfill Prevention" = 'Automatic Shut Off Device'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_flow_shutoff_device,
        CASE
            WHEN a."Overfill Prevention" = 'Overfill Alarm'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_high_level_alarm,
        CASE
            WHEN a."Overfill Prevention" = 'Vent Whistle'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_other,
        CASE
            WHEN a."Overfill Prevention" = 'unknown'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_unknown,
        CASE
            WHEN a."Overfill Prevention" = 'Not Required'::text THEN 'Yes'::text
            ELSE NULL::text
        END::character varying(7) AS overfill_prevention_not_required,
        CASE
            WHEN d.spill_bucket_installed = 'Yes'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS spill_bucket_installed,
        CASE
            WHEN a."Spill Prevention" = 'Not Required'::text THEN 'Yes'::text
            ELSE NULL::text
        END::character varying(3) AS spill_prevention_not_required,
    g.spill_bucket_wall_type_id,
        CASE
            WHEN a."Compartment Release Detection" = 'Interstitial Monitoring'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_interstitial_monitoring,
        CASE
            WHEN a."Compartment Release Detection" = 'Automatic Tank Gauging'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_automatic_tank_gauging_release_detection,
        CASE
            WHEN a."Compartment Release Detection" = 'Continuous In Tank Leak Detection System - CITLDS'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS automatic_tank_gauging_continuous_leak_detection,
        CASE
            WHEN a."Compartment Release Detection" ~~ 'Manual%'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_manual_tank_gauging,
        CASE
            WHEN a."Compartment Release Detection" = 'Statistical Inventory Reconciliation (SIR)'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_statistical_inventory_reconciliation,
        CASE
            WHEN a."Compartment Release Detection" = 'Manual Tank Gauging and Tank Tightness Testing'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_tightness_testing,
        CASE
            WHEN a."Compartment Release Detection" = 'Inventory Control'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_inventory_control,
        CASE
            WHEN a."Compartment Release Detection" = 'Ground Water Monitoring'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_groundwater_monitoring
   FROM tn_ust.tn_compartments_merged a
     LEFT JOIN tn_ust.v_compartment_status b ON a."Facility Id Ust"::character varying::text = b."Facility Id Ust"::character varying::text AND a."Tank Id"::integer = b."Tank Id"::integer AND a."Compartment Id"::integer = b."Compartment Id"::integer
     LEFT JOIN tn_ust.v_spill_bucket_installed d ON a."Facility Id Ust"::character varying::text = d."Facility Id Ust"::character varying::text AND a."Tank Id"::integer = d."Tank Id"::integer AND a."Compartment Id"::integer = d."Compartment Id"::integer
     LEFT JOIN tn_ust.v_compartment_status_xwalk f ON b."Status" = f.organization_value::text
     LEFT JOIN tn_ust.v_spill_bucket_wall_type_xwalk g ON a."Spill Prevention" = g.organization_value::text
  WHERE NOT (EXISTS ( SELECT 1
           FROM tn_ust.erg_unregulated_facilities unreg_fac
          WHERE a."Facility Id Ust"::character varying::text = unreg_fac.facility_id::text)) AND NOT (EXISTS ( SELECT 1
           FROM tn_ust.erg_unregulated_tanks unreg_tank
          WHERE a."Facility Id Ust"::character varying::text = unreg_tank.facility_id::text AND a."Tank Id"::integer = unreg_tank.tank_id)) AND (EXISTS ( SELECT 1
           FROM tn_ust.v_ust_facility parent
          WHERE parent.facility_id::text = a."Facility Id Ust"::character varying::text)) AND COALESCE(f.exclude_from_query, 'N'::character varying)::text <> 'Y'::text AND COALESCE(g.exclude_from_query, 'N'::character varying)::text <> 'Y'::text;

-- tn_ust.v_ust_compartment_substance
CREATE OR REPLACE VIEW "tn_ust"."v_ust_compartment_substance" AS
 SELECT DISTINCT a."Facility Id Ust"::character varying(50) AS facility_id,
    a."Tank Id"::integer AS tank_id,
    a."Compartment Id"::integer AS compartment_id,
    b.substance_id
   FROM tn_ust.tn_compartments_merged a
     LEFT JOIN tn_ust.v_substance_xwalk b ON a."Product" = b.organization_value::text
  WHERE b.substance_id IS NOT NULL AND NOT (EXISTS ( SELECT 1
           FROM tn_ust.erg_unregulated_facilities unreg_fac
          WHERE a."Facility Id Ust"::character varying::text = unreg_fac.facility_id::text)) AND NOT (EXISTS ( SELECT 1
           FROM tn_ust.erg_unregulated_tanks unreg_tank
          WHERE a."Facility Id Ust"::character varying::text = unreg_tank.facility_id::text AND a."Tank Id"::integer = unreg_tank.tank_id)) AND (EXISTS ( SELECT 1
           FROM tn_ust.v_ust_facility parent
          WHERE parent.facility_id::text = a."Facility Id Ust"::character varying::text)) AND COALESCE(b.exclude_from_query, 'N'::character varying)::text <> 'Y'::text;

-- tn_ust.v_ust_piping
CREATE OR REPLACE VIEW "tn_ust"."v_ust_piping" AS
 SELECT DISTINCT a."Facility Id Ust"::character varying(50) AS facility_id,
    a."Tank Id"::integer AS tank_id,
    a."Compartment Id"::integer AS compartment_id,
    c.piping_id::character varying(50) AS piping_id,
    d.piping_style_id,
        CASE
            WHEN a."Piping Material" = ANY (ARRAY['Rigid Plastic - (NUPI - Western Fiberglass -UPP - Brugg)'::text, 'Fiberglass FRP - (Ameron Dualoy - Smith Fibercast))'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_frp,
        CASE
            WHEN a."Piping Material" = 'Steel'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_steel,
        CASE
            WHEN a."Piping Material" = 'Copper'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_copper,
        CASE
            WHEN a."Piping Material" = 'Flexible Plastic (APT - OPW Pieces - Environ - etc)'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_flex,
        CASE
            WHEN a."Piping Material" = 'No Piping'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_no_piping,
    b.piping_line_leak_detector::character varying(7) AS piping_line_leak_detector,
        CASE
            WHEN a."Leak Detection Periodic" = ANY (ARRAY['ELLD .1 Annual'::text, 'ELLD .2 Monthly'::text, 'Annual LTT'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_line_test_annual,
        CASE
            WHEN a."Leak Detection Periodic" = '3 Year LTT'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_line_test3yr,
        CASE
            WHEN a."Leak Detection Periodic" = 'Groundwater Monitoring'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_groundwater_monitoring,
        CASE
            WHEN a."Leak Detection Periodic" = 'Vapor Monitoring'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_vapor_monitoring,
        CASE
            WHEN a."Leak Detection Periodic" = 'Interstitial Monitoring for Piping'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_interstitial_monitoring,
        CASE
            WHEN a."Leak Detection Periodic" = 'Statistical Inventory Reconciliation'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_statistical_inventory_reconciliation,
        CASE
            WHEN a."Leak Detection Periodic" = 'Other or No Method of Release Detection'::text AND a."Leak Detection Cat" <> 'None Required'::text AND a."Piping Type" <> 'Suction'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_release_detection_other,
    e.piping_wall_type_id
   FROM tn_ust.tn_compartments_merged a
     LEFT JOIN tn_ust.v_piping_line_leak_detector b ON a."Facility Id Ust"::character varying::text = b."Facility Id Ust"::character varying::text AND a."Tank Id"::integer = b."Tank Id"::integer AND a."Compartment Id"::integer = b."Compartment Id"::integer
     LEFT JOIN tn_ust.erg_piping_id c ON a."Facility Id Ust"::character varying::text = c.facility_id::character varying::text AND a."Tank Id"::integer = c.tank_id AND a."Compartment Id"::integer = c.compartment_id
     LEFT JOIN tn_ust.v_piping_style_xwalk d ON a."Piping Type" = d.organization_value::text
     LEFT JOIN tn_ust.v_piping_wall_type_xwalk e ON a."Pipe Construction Type" = e.organization_value::text
  WHERE NOT (EXISTS ( SELECT 1
           FROM tn_ust.erg_unregulated_facilities unreg_fac
          WHERE a."Facility Id Ust"::character varying::text = unreg_fac.facility_id::text)) AND NOT (EXISTS ( SELECT 1
           FROM tn_ust.erg_unregulated_tanks unreg_tank
          WHERE a."Facility Id Ust"::character varying::text = unreg_tank.facility_id::text AND a."Tank Id"::integer = unreg_tank.tank_id)) AND (EXISTS ( SELECT 1
           FROM tn_ust.v_ust_facility parent
          WHERE parent.facility_id::text = a."Facility Id Ust"::character varying::text)) AND COALESCE(d.exclude_from_query, 'N'::character varying)::text <> 'Y'::text AND COALESCE(e.exclude_from_query, 'N'::character varying)::text <> 'Y'::text;

-- tn_ust.v_ust_tank_substance
CREATE OR REPLACE VIEW "tn_ust"."v_ust_tank_substance" AS
 SELECT DISTINCT a."Facility Id Ust"::character varying(50) AS facility_id,
    a."Tank Id"::integer AS tank_id,
    b.substance_id
   FROM tn_ust.tn_compartments_merged a
     LEFT JOIN tn_ust.v_substance_xwalk b ON a."Product" = b.organization_value::text
  WHERE b.substance_id IS NOT NULL AND NOT (EXISTS ( SELECT 1
           FROM tn_ust.erg_unregulated_facilities unreg_fac
          WHERE a."Facility Id Ust"::character varying::text = unreg_fac.facility_id::text)) AND NOT (EXISTS ( SELECT 1
           FROM tn_ust.erg_unregulated_tanks unreg_tank
          WHERE a."Facility Id Ust"::character varying::text = unreg_tank.facility_id::text AND a."Tank Id"::integer = unreg_tank.tank_id)) AND (EXISTS ( SELECT 1
           FROM tn_ust.v_ust_facility parent
          WHERE parent.facility_id::text = a."Facility Id Ust"::character varying::text)) AND COALESCE(b.exclude_from_query, 'N'::character varying)::text <> 'Y'::text;

COMMIT;
