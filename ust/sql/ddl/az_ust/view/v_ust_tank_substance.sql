create or replace view "az_ust"."v_ust_tank_substance" as
 SELECT DISTINCT (x."FacilityID")::character varying(50) AS facility_id,
    (x."TankName")::integer AS tank_id,
    sx.substance_id
   FROM (az_ust.ust_compartment x
     LEFT JOIN az_ust.v_substance_xwalk sx ON ((x."CompartmentSubstanceStored" = (sx.organization_value)::text)))
  WHERE (x."CompartmentSubstanceStored" IS NOT NULL);