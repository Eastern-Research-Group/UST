create or replace view "dc_ust"."v_ust_tank_substance" as
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    (t."TankName")::integer AS tank_id,
    s.substance_id,
    (x."CompartmentSubstanceCASNO")::text AS substance_casno
   FROM ((dc_ust.compartment x
     JOIN dc_ust.tank t ON ((((x."FacilityID")::text = (t."FacilityID")::text) AND (x."TankID" = t."TankID"))))
     LEFT JOIN dc_ust.v_substance_xwalk s ON ((x."CompartmentSubstanceStored" = (s.organization_value)::text)))
  WHERE ((x."CompartmentSubstanceStored" IS NOT NULL) AND (NOT (EXISTS ( SELECT 1
           FROM dc_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((t."TankName")::integer = unreg.tank_id))))));