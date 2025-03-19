create or replace view "de_ust"."v_ust_compartment_substance" as
 SELECT DISTINCT x."FacilityID" AS facility_id,
    (x."TankID")::integer AS tank_id,
    (x."CompartmentID")::integer AS compartment_id,
    s.substance_id
   FROM (de_ust.compartment x
     LEFT JOIN de_ust.v_substance_xwalk s ON ((x."CompartmentSubstanceStored" = (s.organization_value)::text)))
  WHERE (s.substance_id IS NOT NULL);