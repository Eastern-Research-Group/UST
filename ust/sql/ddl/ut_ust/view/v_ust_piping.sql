create or replace view "ut_ust"."v_ust_piping" as
 SELECT DISTINCT (t.piping_id)::character varying(50) AS piping_id,
    (c.facility_id)::character varying(50) AS facility_id,
    t.tank_id,
    t.compartment_id,
        CASE c."PIPEMATDES"
            WHEN 'Fiberglass Reinforced Plastic'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_frp,
        CASE c."PIPEMATDES"
            WHEN 'Galvanized Steel'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_gal_steel,
        CASE c."PIPEMATDES"
            WHEN 'Bare Steel'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_steel,
        CASE c."PIPEMATDES"
            WHEN 'Copper'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_copper,
        CASE c."PIPEMATDES"
            WHEN 'Flexible Plastic'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_flex,
        CASE c."PIPEMATDES"
            WHEN 'No Piping'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_no_piping,
        CASE
            WHEN (c."PIPEMATDES" = ANY (ARRAY['Other'::text, 'Not Listed'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_other,
        CASE
            WHEN (c."PIPEMATDES" = ANY (ARRAY['Unknown'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_unknown,
        CASE
            WHEN (c."PIPEMODDES" = 'Secondary Containment'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS pipe_secondary_containment_other,
    (epcf.piping_corrosion_protection_sacrificial_anode)::character varying(7) AS piping_corrosion_protection_sacrificial_anode,
    epcof.piping_corrosion_protection_other,
    s.piping_wall_type_id
   FROM ((((ut_ust.ut_tank c
     JOIN ut_ust.erg_piping t ON ((((c.facility_id)::integer = t.facility_id) AND (c.tank_id = t.tank_id))))
     LEFT JOIN ut_ust.erg_piping_cp_fields epcf ON ((((c.facility_id)::integer = epcf.facility_id) AND (c.tank_id = epcf.tank_id))))
     LEFT JOIN ut_ust.erg_piping_cp_other_fields epcof ON ((((c.facility_id)::integer = epcof.facility_id) AND (c.tank_id = epcof.tank_id))))
     LEFT JOIN ut_ust.v_piping_wall_type_xwalk s ON (((s.organization_value)::text = c."PIPEMODDES")))
  WHERE ((c."FEDERALREG" = 'Yes'::text) AND (c."TANKSTATUS" <> 'Install in Process'::text) AND (c.facility_id IN ( SELECT y.facility_id
           FROM ut_ust.ut_facility y
          WHERE ((y."TANK" = 1) AND (y."OPENREGAST" = 0) AND (y."REGAST" = 0)))));