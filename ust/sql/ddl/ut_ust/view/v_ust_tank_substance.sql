create or replace view "ut_ust"."v_ust_tank_substance" as
 SELECT DISTINCT (x.facility_id)::character varying(50) AS facility_id,
    x.tank_id,
    sx.substance_id
   FROM (ut_ust.erg_substance x
     LEFT JOIN ut_ust.v_substance_xwalk sx ON ((x.substance = (sx.organization_value)::text)))
  WHERE (sx.substance_id IS NOT NULL);