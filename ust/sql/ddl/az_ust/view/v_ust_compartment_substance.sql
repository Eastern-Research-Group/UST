create or replace view "az_ust"."v_ust_compartment_substance" as
 SELECT DISTINCT (x."FacilityID")::character varying(50) AS facility_id,
    (x."TankName")::integer AS tank_id,
    c.compartment_id,
    sx.substance_id,
    sx.organization_value AS substance_comment
   FROM ((az_ust.ust_compartment x
     JOIN az_ust.erg_compartment c ON (((x."FacilityID" = (c.facility_id)::text) AND ((x."TankName")::integer = c.tank_id) AND (x."CompartmentName" = (c.compartment_name)::text))))
     LEFT JOIN az_ust.v_substance_xwalk sx ON ((x."CompartmentSubstanceStored" = (sx.organization_value)::text)))
  WHERE (x."CompartmentSubstanceStored" IS NOT NULL);