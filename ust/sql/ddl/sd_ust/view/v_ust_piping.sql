create or replace view "sd_ust"."v_ust_piping" as
 SELECT DISTINCT (c.piping_id)::character varying(50) AS piping_id,
    c.facility_id,
    c.tank_id,
    c.compartment_id,
    px.piping_style_id,
        CASE x."TankPipingType"
            WHEN 'Safe Suction'::text THEN 'Y'::text
            ELSE NULL::text
        END AS safe_suction,
        CASE x."TankPipingType"
            WHEN 'Suction'::text THEN 'Y'::text
            ELSE NULL::text
        END AS american_suction,
    NULL::text AS high_pressure_or_bulk_piping,
        CASE
            WHEN (x."TankPipingMaterial" ~~ '%Fiberglass%'::text) THEN 'Y'::text
            ELSE NULL::text
        END AS piping_material_frp,
        CASE x."TankPipingMaterial"
            WHEN 'Galvanized Steel'::text THEN 'Y'::text
            ELSE NULL::text
        END AS piping_material_gal_steel,
        CASE x."TankPipingMaterial"
            WHEN 'Stainless Steel'::text THEN 'Y'::text
            ELSE NULL::text
        END AS piping_material_stainless_steel,
        CASE x."TankPipingMaterial"
            WHEN 'Copper'::text THEN 'Y'::text
            ELSE NULL::text
        END AS piping_material_copper,
        CASE
            WHEN (x."TankPipingMaterial" = ANY (ARRAY['None'::text, 'Not Applicable'::text])) THEN 'Y'::text
            ELSE NULL::text
        END AS piping_material_no_piping,
        CASE x."TankPipingMaterial"
            WHEN 'Unknown'::text THEN 'Y'::text
            ELSE NULL::text
        END AS piping_material_unknown,
        CASE
            WHEN (x."TankPipingMaterial" = ANY (ARRAY['Black Steel'::text, 'Cath. Protection'::text, 'Cath. Steel'::text, 'Coated Steel'::text, 'Steel'::text, 'Steel/Aboveground'::text, 'Steel/Cont'::text])) THEN 'Y'::text
            ELSE NULL::text
        END AS piping_material_steel,
        CASE
            WHEN (x."TankPipingMaterial" = ANY (ARRAY['DW Ameron'::text, 'DW APT'::text, 'DW Environ'::text, 'DW Flex'::text, 'DW MarinaFlex'::text, 'DW OPW'::text, 'DW Poly'::text, 'SW Ameron'::text, 'SW APT'::text, 'SW Flex'::text, 'Total Containment'::text])) THEN 'Y'::text
            ELSE NULL::text
        END AS piping_material_flex,
        CASE x."TankPipingReleaseDetection"
            WHEN 'Groundwater Monitoring'::text THEN 'Y'::text
            ELSE NULL::text
        END AS piping_groundwater_monitoring,
        CASE x."TankPipingReleaseDetection"
            WHEN 'Vapor Monitoring'::text THEN 'Y'::text
            ELSE NULL::text
        END AS piping_vapor_monitoring,
        CASE x."TankPipingReleaseDetection"
            WHEN 'S.I.R.'::text THEN 'Y'::text
            ELSE NULL::text
        END AS piping_statistical_inventory_reconciliation,
    pwx.piping_wall_type_id,
        CASE x."TankPipingReleaseDetection"
            WHEN 'Secondary Containment'::text THEN 'Y'::text
            ELSE NULL::text
        END AS pipe_secondary_containment_other,
        CASE x."TankPipingReleaseDetection"
            WHEN 'Unknown'::text THEN 'Y'::text
            ELSE NULL::text
        END AS pipe_secondary_containment_unknown,
        CASE
            WHEN (x."TankPipingMaterial" = ANY (ARRAY['Cath. Protection'::text, 'Cath. Steel'::text])) THEN 'Y'::text
            ELSE NULL::text
        END AS piping_corrosion_protection_sacrificial_anode,
        CASE
            WHEN (x."TankPipingReleaseDetection" = ANY (ARRAY['None'::text, 'Not Applicable'::text, 'Unknown'::text])) THEN 'EPA has no acceptable mapping to the State Release Detection values for this piping data.'::text
            ELSE NULL::text
        END AS piping_comment
   FROM (((sd_ust.tanks x
     JOIN sd_ust.erg_piping c ON (((x."FacilityNumber" = (c.facility_id)::text) AND (x."TankNumber" = (c.tank_id)::double precision))))
     LEFT JOIN sd_ust.v_piping_style_xwalk px ON ((x."TankProduct" = (px.organization_value)::text)))
     LEFT JOIN sd_ust.v_piping_wall_type_xwalk pwx ON ((x."TankProduct" = (pwx.organization_value)::text)))
  WHERE (x."FacilityType" = 'UST'::text);