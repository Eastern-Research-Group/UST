-- Consolidate federally_regulated across surviving rows for each facility/tank.
-- Any Regulated source row yields Yes; otherwise the result stays NULL.
-- SELECT DISTINCT then removes rows differing only in the previous flag value.
-- Other attribute conflicts remain visible. Existing joins and filters are retained.
-- Based on TN_UST_current_view_definitions.sql exported 2026-10-23.

CREATE OR REPLACE VIEW "tn_ust"."v_ust_tank" AS
 SELECT DISTINCT a."Facility Id Ust"::character varying(50) AS facility_id,
    a."Tank Id"::integer AS tank_id,
    a."Tank Number"::character varying(50) AS tank_name,
    f.tank_status_id,
        CASE
            WHEN bool_or(a."Regulated Status" = 'Regulated'::text) OVER (
                PARTITION BY a."Facility Id Ust"::character varying(50),
                             a."Tank Id"::integer
            ) THEN 'Yes'::text
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
