create or replace view "il_ust"."v_ust_tank_substance" as
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    x."TankID" AS tank_id,
    s.substance_id,
    x."CompartmentSubstanceCASNO" AS substance_casno
   FROM (il_ust.compartment x
     LEFT JOIN il_ust.v_substance_xwalk s ON ((x."CompartmentSubstanceStored" = (s.organization_value)::text)));