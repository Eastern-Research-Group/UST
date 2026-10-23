-- Preserve current TN facility eligibility while avoiding full facility-view expansion.
CREATE OR REPLACE VIEW tn_ust.v_ust_piping AS
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
           FROM (SELECT a.facility_id FROM (
    SELECT "FACILITY_ID_UST"::character varying(50) AS facility_id,
           'TN'::character varying(2) AS facility_state
    FROM tn_ust.tn_facilities_merged
) a
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
          WHERE a.facility_id::text = unreg.facility_id::text)) AND COALESCE(e.exclude_from_query, 'N'::character varying)::text <> 'Y'::text AND COALESCE(f.exclude_from_query, 'N'::character varying)::text <> 'Y'::text AND COALESCE(g.exclude_from_query, 'N'::character varying)::text <> 'Y'::text) parent
          WHERE parent.facility_id::text = a."Facility Id Ust"::character varying::text)) AND COALESCE(d.exclude_from_query, 'N'::character varying)::text <> 'Y'::text AND COALESCE(e.exclude_from_query, 'N'::character varying)::text <> 'Y'::text;