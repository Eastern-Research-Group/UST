create or replace view "wv_ust"."v_ust_tank_substance" as
 SELECT DISTINCT (x."Facility ID")::character varying(50) AS facility_id,
    (x."Tank Id")::integer AS tank_id,
    sx.substance_id
   FROM (wv_ust.erg_substance_datarows_deagg x
     LEFT JOIN wv_ust.v_substance_xwalk sx ON (((x."Substance")::text = (sx.organization_value)::text)))
  WHERE ((x."Substance" IS NOT NULL) AND (NOT (EXISTS ( SELECT 1
           FROM wv_ust.erg_unregulated_tanks unreg
          WHERE ((((x."Facility ID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."Tank Id")::integer = unreg.tank_id))))));