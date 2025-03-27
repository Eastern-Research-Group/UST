create or replace view "vt_ust"."v_ust_compartment_substance" as
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    (x."TankID")::integer AS tank_id,
    x."CompartmentID" AS compartment_id,
    s.substance_id
   FROM ((vt_ust.compartment x
     LEFT JOIN vt_ust.facility f ON ((x."FacilityID" = f."FacilityID")))
     LEFT JOIN vt_ust.v_substance_xwalk s ON ((x."CompartmentSubstanceStored" = (s.organization_value)::text)))
  WHERE ((x."CompartmentSubstanceStored" IS NOT NULL) AND (NOT (EXISTS ( SELECT 1
           FROM vt_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id))))) AND (f."FacilityType1" <> 'Wombat'::text) AND (NOT (EXISTS ( SELECT 1
           FROM vt_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id))))));