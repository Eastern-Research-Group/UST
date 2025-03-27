create or replace view "de_ust"."v_ust_tank_substance" as
 SELECT DISTINCT x."FacilityID" AS facility_id,
    (x."TankID")::integer AS tank_id,
    s.substance_id,
    x."CompartmentSubstanceCASNO" AS substance_casno
   FROM (de_ust.compartment x
     LEFT JOIN de_ust.v_substance_xwalk s ON ((x."CompartmentSubstanceStored" = (s.organization_value)::text)))
  WHERE ((s.substance_id IS NOT NULL) AND (NOT (EXISTS ( SELECT 1
           FROM de_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id))))));