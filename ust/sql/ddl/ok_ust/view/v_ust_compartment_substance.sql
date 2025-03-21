create or replace view "ok_ust"."v_ust_compartment_substance" as
 SELECT DISTINCT (x."FacilityID")::character varying(50) AS facility_id,
    (x."TankNumber")::integer AS tank_id,
    (x."CompartmentNumber")::integer AS compartment_id,
    vtsx.substance_id
   FROM ((ok_ust.erg_compartments_deduplicated x
     JOIN ok_ust.v_substance_xwalk vtsx ON (((vtsx.organization_value)::text = x."Substance")))
     JOIN ok_ust."OK_UST_Data" b ON (((b."FacilityID" = x."FacilityID") AND (b.tank_name = x."TankNumber"))))
  WHERE (x."Substance" IS NOT NULL);