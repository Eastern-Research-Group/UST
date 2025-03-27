create or replace view "hi_ust"."v_ust_tank_substance" as
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    (x."TankID")::integer AS tank_id,
    x."AltTankID" AS tank_name,
        CASE
            WHEN (s.substance_id IS NULL) THEN 47
            ELSE s.substance_id
        END AS substance_id
   FROM (hi_ust."tblTank" x
     LEFT JOIN hi_ust.v_substance_xwalk s ON ((x."SubstanceDesc" = (s.organization_value)::text)));