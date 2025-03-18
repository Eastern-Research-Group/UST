create or replace view "ok_ust"."v_ust_tank_substance" as
 SELECT DISTINCT (x."FacilityID")::character varying(50) AS facility_id,
    (x.tank_name)::integer AS tank_id,
    vtsx.substance_id
   FROM ((ok_ust."OK_UST_Data" x
     JOIN ok_ust.erg_compartments_deduplicated b ON (((x."FacilityID" = b."FacilityID") AND (x.tank_name = b."TankNumber"))))
     JOIN ok_ust.v_substance_xwalk vtsx ON (((vtsx.organization_value)::text = b."Substance")))
  WHERE (b."Substance" IS NOT NULL);