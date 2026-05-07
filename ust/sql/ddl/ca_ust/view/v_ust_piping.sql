create or replace view "ca_ust"."v_ust_piping" as
 SELECT DISTINCT (x."CERS ID")::character varying(50) AS facility_id,
    t.tank_id,
    t.compartment_id,
    (t.piping_id)::character varying(50) AS piping_id,
    ps.piping_style_id,
        CASE
            WHEN (x."Primary_Containment_Construction" = 'Fiberglass'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_frp,
        CASE
            WHEN (x."Primary_Containment_Construction" = 'Steel'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_steel,
        CASE
            WHEN (x."Primary_Containment_Construction" = 'Flexible'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_flex,
        CASE
            WHEN (x."Primary_Containment_Construction" = 'Other'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_other,
        CASE
            WHEN (x."Primary_Containment_Construction" = 'Unknown'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_unknown,
    (x."Containment _Sump")::character varying(7) AS pipe_tank_top_sump,
    tt.pipe_tank_top_sump_wall_type_id,
    wt.piping_wall_type_id,
        CASE
            WHEN (x."Secondary _Containment _Construction" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS pipe_secondary_containment_other
   FROM ((((ca_ust.tank x
     JOIN ca_ust.erg_piping_id t ON (((((x."CERS ID")::character varying(50))::text = (t.facility_id)::text) AND (((x."CERS TankID")::character varying(50))::text = (t.tank_name)::text))))
     LEFT JOIN ca_ust.v_piping_style_xwalk ps ON ((x."Piping_System Type" = (ps.organization_value)::text)))
     LEFT JOIN ca_ust.v_pipe_tank_top_sump_wall_type_xwalk tt ON ((x."Piping/Turbine _Containment _Sump" = (tt.organization_value)::text)))
     LEFT JOIN ca_ust.v_piping_wall_type_xwalk wt ON ((x."Piping_Construction" = (wt.organization_value)::text)));