create or replace view "va_ust"."v_ust_tank_substance" as
 SELECT DISTINCT (a.tank_facility_id)::character varying(50) AS facility_id,
    (a.index)::integer AS tank_id,
    b.substance_id
   FROM (va_ust.tanks a
     LEFT JOIN va_ust.v_substance_xwalk b ON (((a.contents)::text = (b.organization_value)::text)))
  WHERE (((a.tank_type)::text = 'UST'::text) AND ((a.federally_regulated_tank)::text = 'Yes'::text) AND (a.contents IS NOT NULL));