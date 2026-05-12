create or replace view "nh_ust"."v_ust_piping" as
 SELECT DISTINCT epi.facility_id,
    epi.tank_id,
    epi.compartment_id,
    (epi.piping_id)::character varying(50) AS piping_id,
    c.piping_style_id,
        CASE
            WHEN (a."PIPING_SYSTEM" = 'SUCTION: NO VALVE AT TANK'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS safe_suction,
        CASE
            WHEN (a."PIPING_SYSTEM" = 'SUCTION: VALVE AT TANK'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS american_suction,
        CASE
            WHEN (a."PIPING_MATERIAL" = ANY (ARRAY['COPPER'::text, 'COPPER -CORR. PROT.'::text, 'COPPER ISOLATED'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_copper,
        CASE
            WHEN (a."PIPING_MATERIAL" = ANY (ARRAY['FLEXIBLE'::text, 'PLASTIC PIPING'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_flex,
        CASE
            WHEN (a."PIPING_MATERIAL" = 'FIBERGLASS'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_frp,
        CASE
            WHEN (a."PIPING_MATERIAL" = 'STEEL - BARE/GALV'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_gal_steel,
        CASE
            WHEN (a."PIPING_MATERIAL" = 'NO PIPING'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_no_piping,
        CASE
            WHEN (a."PIPING_MATERIAL" = ANY (ARRAY['COMPOSITE'::text, 'OTHER - MISCELLANEOUS'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_other,
        CASE
            WHEN (a."PIPING_MATERIAL" = ANY (ARRAY['STEEL-CORR. PROT.'::text, 'STEEL ISOLATED'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_steel,
        CASE
            WHEN (a."PIPING_MATERIAL" = 'UNKNOWN'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_unknown,
        CASE
            WHEN (epc.piping_corrosion_protection_sacrificial_anode = ANY (ARRAY['SACRAFICIAL ANODE'::text, 'REPAIRED SA'::text])) THEN 'Yes'::text
            WHEN (epc.piping_corrosion_protection_sacrificial_anode = 'STEEL-CORR. PROT.SACRAFICIAL ANODE (INFERRED)'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_corrosion_protection_sacrificial_anode,
        CASE
            WHEN (a."CORROSION_PROTECTION_PIPING" = 'IMPRESSED CURRENT'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_corrosion_protection_impressed_current,
        CASE
            WHEN (a."PIPING_MATERIAL_SECONDARY_CONTAINMENT" = 'YES'::text) THEN 'Yes'::text
            WHEN (a."PIPING_MATERIAL_SECONDARY_CONTAINMENT" = 'NO'::text) THEN 'No'::text
            ELSE NULL::text
        END AS pipe_secondary_containment_unknown,
        CASE
            WHEN (a."RELEASE_DETECTION_PIPING_TYPE" = ANY (ARRAY['EBW BULK/STICK II'::text, 'GILBARCO'::text, 'PREFERRED UTILITIES'::text, 'MONTIORING WELL'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_groundwater_monitoring,
        CASE
            WHEN (a."RELEASE_DETECTION_PIPING_TYPE" = ANY (ARRAY['ARIZONA'::text, 'EBW BULK/STICK II'::text, 'EMCO WHEATON'::text, 'EVO - FRANKLIN FUELS'::text, 'GILBARCO'::text, 'INCON'::text, 'OMNTEC'::text, 'OPW FUEL MGT SYS'::text, 'OTHER'::text, 'OWENS CORNING'::text, 'PNEUMERCATOR'::text, 'POLLULERT'::text, 'PREFERRED UTILITIES'::text, 'VEEDER ROOT'::text, 'WARWICK CONTROLS'::text, 'TANK GUARD'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_interstitial_monitoring,
        CASE
            WHEN (a."RELEASE_DETECTION_PIPING_TYPE" = ANY (ARRAY['EVO - FRANKLIN FUELS'::text, 'VEEDER ROOT'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_line_leak_detector
   FROM ((((((nh_ust.tanks a
     JOIN nh_ust.facilities b ON (((a."FACILITY_ID" = b."FACILITY_ID") AND (b."FACILITY_TYPE" <> 'PROPOSED FACILITY'::text))))
     JOIN nh_ust.erg_tank_id eti ON (((a."FACILITY_ID" = (eti.facility_id)::integer) AND (a."TANK_NUMBER" = (eti.tank_name)::text))))
     JOIN nh_ust.erg_compartment_id eci ON ((eti.tank_id = eci.tank_id)))
     JOIN nh_ust.erg_piping_id epi ON ((eci.compartment_id = epi.compartment_id)))
     LEFT JOIN nh_ust.v_piping_style_xwalk c ON ((a."PIPING_SYSTEM" = (c.organization_value)::text)))
     LEFT JOIN nh_ust.erg_piping_cp epc ON (((a."FACILITY_ID" = epc."FACILITY_ID") AND (a."TANK_NUMBER" = epc."TANK_NUMBER"))))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM nh_ust.erg_unregulated_tanks unreg
          WHERE ((((a."FACILITY_ID")::character varying(50))::text = (unreg.facility_id)::text) AND (eti.tank_id = unreg.tank_id)))));