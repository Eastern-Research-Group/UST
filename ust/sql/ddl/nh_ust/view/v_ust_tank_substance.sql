create or replace view "nh_ust"."v_ust_tank_substance" as
 SELECT DISTINCT (x."FACILITY_ID")::character varying(50) AS facility_id,
    et.tank_id,
    sx.substance_id
   FROM ((nh_ust.tanks x
     JOIN nh_ust.erg_tank et ON ((((et.facility_id)::integer = x."FACILITY_ID") AND ((et.tank_name)::text = x."TANK_NUMBER"))))
     LEFT JOIN nh_ust.v_substance_xwalk sx ON ((x."SUBSTANCE_STORED" = (sx.organization_value)::text)))
  WHERE (x."SUBSTANCE_STORED" IS NOT NULL);