create or replace view "mp_ust"."v_ust_tank_substance" as
 SELECT DISTINCT (x.deq_id)::character varying(50) AS facility_id,
    x.tank_id,
    sx.substance_id
   FROM (mp_ust.erg_mp_ust_tanks x
     LEFT JOIN mp_ust.v_substance_xwalk sx ON ((x.tank_contents = (sx.organization_value)::text)))
  WHERE (x.tank_contents IS NOT NULL);