create or replace view "dc_ust"."v_ust_compartment_substance" as
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    t."TankName" AS tank_id,
    x."CompartmentName" AS compartment_id,
    s.substance_id
   FROM ((dc_ust.compartment x
     LEFT JOIN dc_ust.tank t ON (((x."FacilityID" = t."FacilityID") AND (x."TankID" = t."TankID"))))
     LEFT JOIN dc_ust.v_substance_xwalk s ON ((x."CompartmentSubstanceStored" = (s.organization_value)::text)))
  WHERE ((x."CompartmentSubstanceStored" IS NOT NULL) AND (NOT (EXISTS ( SELECT 1
           FROM dc_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((t."TankName")::integer = unreg.tank_id))))));