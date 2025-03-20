create or replace view "wv_ust"."v_ust_tank_substance_orig" as
 SELECT DISTINCT (x."Facility ID")::character varying(50) AS facility_id,
    (x."Tank Id")::integer AS tank_id,
    sx.substance_id
   FROM (wv_ust.erg_substance_datarows_deagg x
     LEFT JOIN wv_ust.v_substance_xwalk sx ON (((x."Substance")::text = (sx.organization_value)::text)))
  WHERE (x."Substance" IS NOT NULL);