create or replace view "dc_ust"."v_ust_tank_substance" as
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    (t."TankName")::integer AS tank_id,
        CASE
            WHEN (s.substance_id IS NULL) THEN 47
            ELSE s.substance_id
        END AS substance_id,
    (x."CompartmentSubstanceCASNO")::text AS substance_casno
   FROM ((dc_ust.compartment x
     JOIN dc_ust.tank t ON ((((x."FacilityID")::text = (t."FacilityID")::text) AND (x."TankID" = t."TankID"))))
     LEFT JOIN dc_ust.v_substance_xwalk s ON ((x."CompartmentSubstanceStored" = (s.organization_value)::text)))
  WHERE (x."CompartmentSubstanceStored" IS NOT NULL);