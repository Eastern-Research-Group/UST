create or replace view "sd_ust"."v_ust_tank_substance" as
 SELECT DISTINCT (x."FacilityNumber")::character varying(50) AS facility_id,
    c.tank_id,
    sx.substance_id
   FROM ((sd_ust.tanks x
     JOIN sd_ust.v_ust_tank c ON (((x."FacilityNumber" = (c.facility_id)::text) AND (x."TankNumber" = ((c.tank_name)::integer)::double precision))))
     LEFT JOIN sd_ust.v_substance_xwalk sx ON ((x."TankProduct" = (sx.organization_value)::text)))
  WHERE ((x."TankProduct" IS NOT NULL) AND (x."FacilityType" = 'UST'::text));