create or replace view "md_ust"."v_ust_tank_substance" as
 SELECT DISTINCT (x."FacilityID")::character varying(50) AS facility_id,
    x."TankID" AS tank_id,
    sx.substance_id
   FROM (md_ust.md_tanks_combined x
     JOIN md_ust.v_substance_xwalk sx ON ((x."SubstanceDesc" = (sx.organization_value)::text)));