create or replace view "as_ust"."v_ust_piping" as
 SELECT DISTINCT f.facility_id,
    (a.tank_id)::integer AS tank_id,
    a.compartment_id,
    (a.piping_id)::character varying(50) AS piping_id,
    c.piping_style_id,
    (a.safesuction)::character varying(7) AS safe_suction,
    (a.piping_material_frp)::character varying(3) AS piping_material_frp,
    (a.piping_material_steel)::character varying(3) AS piping_material_steel,
    (a.piping_material_flex)::character varying(3) AS piping_material_flex,
    (a.piping_flex_connector)::character varying(7) AS piping_flex_connector,
    (a.piping_line_leak_detector)::character varying(7) AS piping_line_leak_detector,
    (a.piping_line_test_annual)::character varying(7) AS piping_line_test_annual,
    (a.piping_line_test3yr)::character varying(7) AS piping_line_test3yr,
    (a.piping_release_detection_other)::character varying(7) AS piping_release_detection_other,
    (a.pipe_tank_topsump)::character varying(7) AS pipe_tank_top_sump,
    b.pipe_tank_top_sump_wall_type_id,
    d.piping_wall_type_id
   FROM ((((as_ust.erg_piping a
     LEFT JOIN as_ust.v_pipe_tank_top_sump_wall_type_xwalk b ON ((a.pipe_tank_topsump_walltype = (b.organization_value)::text)))
     LEFT JOIN as_ust.v_piping_style_xwalk c ON ((a.piping_style = (c.organization_value)::text)))
     LEFT JOIN as_ust.v_piping_wall_type_xwalk d ON ((a.piping_wall_type = (d.organization_value)::text)))
     LEFT JOIN as_ust.v_ust_facility f ON ((a.facility_id = (f.facility_id)::text)));