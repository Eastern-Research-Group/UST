create or replace view "me_ust"."v_ust_piping" as
 SELECT DISTINCT (x."REGISTRATION NUMBER")::text AS facility_id,
    (x."TANK NUMBER")::integer AS tank_id,
    (x."CHAMBER ID")::integer AS compartment_id,
    (t.piping_id)::text AS piping_id,
    ps.piping_style_id,
        CASE
            WHEN (x."PIPE LEAK DETECTION" = ANY (ARRAY['SEC_CONT_CONTIN_ELEC_MON'::text, 'SEC_CONT_MANUAL_MON'::text, 'SECONDARY_CONTAINMENT'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS pipe_secondary_containment_other,
        CASE
            WHEN (x."PIPE MATERIAL LABEL" = 'DOUBLE-WALLED CP STEEL'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_corrosion_protection_sacrificial_anode,
        CASE
            WHEN (x."PIPE LEAK DETECTION" = 'INLINE_LEAK_DETECTOR'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_line_leak_detector,
        CASE
            WHEN (x."PIPE MATERIAL LABEL" = ANY (ARRAY['COPPER'::text, 'COPPER WITH SECONDARY CONTAINMENT'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_copper,
        CASE
            WHEN (x."PIPE MATERIAL LABEL" = 'FLEXIBLE DOUBLE-WALLED PIPING'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_flex,
        CASE
            WHEN (x."PIPE MATERIAL LABEL" = 'GALVANIZED STEEL'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_gal_steel,
        CASE
            WHEN (x."PIPE MATERIAL LABEL" = 'NONE'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_no_piping,
        CASE
            WHEN (x."PIPE MATERIAL LABEL" = 'OTHER'::text) THEN 'Yes'::text
            WHEN (x."PIPE MATERIAL LABEL" <> ALL (ARRAY['GALVANIZED STEEL'::text, 'STAINLESS STEEL'::text, 'CARBON STEEL'::text, 'STEEL WITH CATHODIC PROTECTION'::text, 'DOUBLE-WALLED CP STEEL'::text, 'STEEL - BARE OR ASPHALT COATED'::text, 'STEEL WITH SECONDARY CONTAINMENT'::text, 'BLACK STEEL'::text, 'STEEL - BARE WITH INTERNAL LINING'::text, 'FLEXIBLE DOUBLE-WALLED PIPING'::text, 'NONE'::text])) THEN 'No'::text
            ELSE NULL::text
        END AS piping_material_other,
        CASE
            WHEN (x."PIPE MATERIAL LABEL" = 'STAINLESS STEEL'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_stainless_steel,
        CASE
            WHEN (x."PIPE MATERIAL LABEL" = ANY (ARRAY['CARBON STEEL'::text, 'STEEL WITH CATHODIC PROTECTION'::text, 'DOUBLE-WALLED CP STEEL'::text, 'STEEL - BARE OR ASPHALT COATED'::text, 'STEEL WITH SECONDARY CONTAINMENT'::text, 'BLACK STEEL'::text, 'STEEL - BARE WITH INTERNAL LINING'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_steel,
        CASE
            WHEN ((x."PIPE LEAK DETECTION" IS NOT NULL) AND (x."PIPE LEAK DETECTION" <> ALL (ARRAY['INLINE_LEAK_DETECTOR'::text, 'CONTINUOUS_VAPOR_MONITORING'::text, 'MONTHLY_SIR'::text, 'NONE'::text, 'UNKNOWN'::text]))) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_release_detection_other,
        CASE
            WHEN (x."PIPE LEAK DETECTION" = 'MONTHLY_SIR'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_statistical_inventory_reconciliation,
        CASE
            WHEN (x."PIPE LEAK DETECTION" = 'CONTINUOUS_VAPOR_MONITORING'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_vapor_monitoring
   FROM ((me_ust.tanks x
     JOIN me_ust.erg_piping_id t ON ((((x."REGISTRATION NUMBER")::text = (t.facility_id)::text) AND ((x."TANK NUMBER")::text = (t.tank_id)::text) AND ((x."CHAMBER ID")::text = (t.compartment_id)::text))))
     LEFT JOIN me_ust.v_piping_style_xwalk ps ON ((x."CHAMBER_PUMP_TYPE_LABEL" = (ps.organization_value)::text)));