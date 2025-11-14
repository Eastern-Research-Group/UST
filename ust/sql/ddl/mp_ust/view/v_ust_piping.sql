create or replace view "mp_ust"."v_ust_piping" as
 SELECT DISTINCT (c.piping_id)::character varying(50) AS piping_id,
    x.deq_id AS facility_id,
    x.tank_id,
    c.compartment_id,
    px.piping_style_id
   FROM ((mp_ust.erg_mp_ust_tanks x
     JOIN mp_ust.erg_piping c ON (((x.deq_id = (c.facility_id)::text) AND (x.tank_id = c.tank_id))))
     JOIN mp_ust.v_piping_style_xwalk px ON ((x.leak_detection_piping = (px.organization_value)::text)));