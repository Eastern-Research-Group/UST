create or replace view "tn_ust"."v_ust_piping" as
 SELECT DISTINCT (z.piping_id)::character varying(50) AS piping_id,
    (a."Tank Id")::integer AS tank_id,
    (a."Facility Id Ust")::character varying(50) AS facility_id,
    (a."Compartment Id")::integer AS compartment_id,
    c.piping_style_id,
        CASE
            WHEN (a."Piping Material" = ANY (ARRAY['Rigid Plastic - (NUPI - Western Fiberglass -UPP - Brugg)'::text, 'Fiberglass FRP - (Ameron Dualoy - Smith Fibercast)'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_frp,
        CASE
            WHEN (a."Piping Material" = 'Steel'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_steel,
        CASE
            WHEN (a."Piping Material" = 'Copper'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_copper,
        CASE
            WHEN (a."Piping Material" = 'Flexible Plastic (APT - OPW Pieces - Environ - etc)'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_flex,
        CASE
            WHEN (a."Piping Material" = 'No Piping'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_no_piping,
        CASE
            WHEN (a."Piping Material" = ANY (ARRAY['Gasoline'::text, 'Gasoline_ULSDiesel'::text, 'Hazardous Substance'::text, 'Kerosene'::text, 'Other'::text, 'ULSDiesel_Kerosene '::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_other,
        CASE
            WHEN (a."Leak Detection Periodic" = ANY (ARRAY['Annual LTT'::text, '3 Year LTT'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_line_leak_detector,
        CASE
            WHEN (a."Leak Detection Periodic" = 'Annual LTT'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_line_test_annual,
        CASE
            WHEN (a."Leak Detection Periodic" = '3 Year LTT'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_line_test3yr,
        CASE
            WHEN (a."Leak Detection Periodic" = 'Groundwater Monitoring'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_groundwater_monitoring,
        CASE
            WHEN (a."Leak Detection Periodic" = 'Vapor Monitoring'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_vapor_monitoring,
        CASE
            WHEN (a."Leak Detection Periodic" = 'Interstitial Monitoring for Piping'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_interstitial_monitoring,
        CASE
            WHEN (a."Leak Detection Periodic" = 'Statistical Inventory Reconciliation'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_statistical_inventory_reconciliation,
        CASE
            WHEN (a."Leak Detection Periodic" = ANY (ARRAY['ELLD .1 Annual'::text, 'ELLD .2 Monthly'::text, 'None Required'::text, 'Other or No Method of Release Detection'::text, 'Pipe Leak Detection Not Listed'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_release_detection_other,
    d.piping_wall_type_id
   FROM (((tn_ust.tn_compartments a
     JOIN tn_ust.erg_piping_id z ON ((((z.facility_id)::text = ((a."Facility Id Ust")::character varying(50))::text) AND (z.tank_id = a."Tank Id") AND (z.compartment_id = a."Compartment Id"))))
     LEFT JOIN tn_ust.v_piping_style_xwalk c ON ((a."Piping Type" = (c.organization_value)::text)))
     LEFT JOIN tn_ust.v_piping_wall_type_xwalk d ON ((a."Pipe Construction Type" = (d.organization_value)::text)))
  WHERE (((a."Regulated Status" = 'Regulated'::text) OR (a."Regulated Status" IS NULL)) AND (NOT (EXISTS ( SELECT 1
           FROM tn_ust.erg_unregulated_tanks unreg
          WHERE ((((a."Facility Id Ust")::character varying(50))::text = (unreg.facility_id)::text) AND ((a."Tank Id")::integer = unreg.tank_id))))));