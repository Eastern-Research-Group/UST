create or replace view "me_ust"."v_ust_tank_substance" as
 SELECT DISTINCT (x."REGISTRATION NUMBER")::text AS facility_id,
    (x."TANK NUMBER")::integer AS tank_id,
        CASE
            WHEN (s.substance_id IS NULL) THEN 47
            ELSE s.substance_id
        END AS substance_id
   FROM (me_ust.tanks x
     LEFT JOIN me_ust.v_substance_xwalk s ON ((x."PRODUCT STORED" = (s.organization_value)::text)));