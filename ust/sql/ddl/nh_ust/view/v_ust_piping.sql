create or replace view "nh_ust"."v_ust_piping" as
 SELECT DISTINCT (d.piping_id)::character varying(50) AS piping_id,
    d.facility_id,
    d.tank_id,
    d.compartment_id,
    px.piping_style_id,
        CASE
            WHEN (upper(TRIM(BOTH FROM x."PIPING_MATERIAL")) = 'FIBERGLASS'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_frp,
        CASE
            WHEN (upper(TRIM(BOTH FROM x."PIPING_MATERIAL")) = 'STEEL - BARE/GALV'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_gal_steel,
        CASE
            WHEN (upper(TRIM(BOTH FROM x."PIPING_MATERIAL")) = 'FLEXIBLE'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_flex,
        CASE
            WHEN (upper(TRIM(BOTH FROM x."PIPING_MATERIAL")) = 'STEEL ISOLATED'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_steel,
        CASE
            WHEN (upper(TRIM(BOTH FROM x."PIPING_MATERIAL")) = 'STEEL-CORR. PROT.'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_stainless_steel,
        CASE
            WHEN (upper(TRIM(BOTH FROM x."PIPING_MATERIAL")) = ANY (ARRAY['COPPER'::text, 'COPPER -CORR. PROT.'::text, 'COPPER ISOLATED'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_copper,
        CASE
            WHEN (upper(TRIM(BOTH FROM x."PIPING_MATERIAL")) = 'NO PIPING'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_no_piping,
        CASE
            WHEN (upper(TRIM(BOTH FROM x."PIPING_MATERIAL")) = ANY (ARRAY['PLASTIC PIPING'::text, 'COMPOSITE'::text, 'OTHER - MISCELLANEOUS'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_other,
        CASE
            WHEN (upper(TRIM(BOTH FROM x."PIPING_MATERIAL")) = 'UNKNOWN'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_unknown,
        CASE
            WHEN (upper(TRIM(BOTH FROM x."CORROSION_PROTECTION_PIPING")) = ANY (ARRAY['REPAIRED SA'::text, 'SACRAFICIAL ANODE'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_corrosion_protection_sacrificial_anode,
        CASE
            WHEN (upper(TRIM(BOTH FROM x."CORROSION_PROTECTION_PIPING")) = 'IMPRESSED CURRENT'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_corrosion_protection_impressed_current,
        CASE
            WHEN (upper(TRIM(BOTH FROM x."RELEASE_DETECTION_PIPING_TYPE")) = ANY (ARRAY['ARIZONA'::text, 'BRAVO'::text, 'CONTROL system'::text, 'EBW BULK/STICK II'::text, 'EMCO WHEATON'::text, 'EVO - FRANKLIN FUELS'::text, 'GILBARCO'::text, 'HASSTECH'::text, 'INCON'::text, 'INSITU'::text, 'INTERGY INC'::text, 'MONTIORING WELL'::text, 'OMNTEC'::text, 'OPW FUEL MGT SYS'::text, 'OTHER'::text, 'OWENS CORNING'::text, 'PNEUMERCATOR'::text, 'POLLULERT'::text, 'PREFERRED UTILITIES'::text, 'TANK GUARD'::text, 'TIGHTNESS TEST'::text, 'VEEDER ROOT'::text, 'WARWICK CONTROLS'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_release_detection_other,
        CASE
            WHEN (upper(TRIM(BOTH FROM x."PIPING_MATERIAL_SECONDARY_CONTAINMENT")) = 'YES'::text) THEN 'Yes'::text
            WHEN (upper(TRIM(BOTH FROM x."PIPING_MATERIAL_SECONDARY_CONTAINMENT")) = 'NO'::text) THEN 'No'::text
            ELSE NULL::text
        END AS pipe_secondary_containment_unknown
   FROM ((((nh_ust.tanks x
     JOIN nh_ust.erg_tank et ON ((((et.facility_id)::integer = x."FACILITY_ID") AND ((et.tank_name)::text = x."TANK_NUMBER"))))
     JOIN nh_ust.erg_compartment c ON ((((et.facility_id)::text = (c.facility_id)::text) AND (et.tank_id = c.tank_id))))
     JOIN nh_ust.erg_piping d ON ((((et.facility_id)::text = (d.facility_id)::text) AND (et.tank_id = d.tank_id) AND (c.compartment_id = d.compartment_id))))
     LEFT JOIN nh_ust.v_piping_style_xwalk px ON ((x."PIPING_SYSTEM" = (px.organization_value)::text)));