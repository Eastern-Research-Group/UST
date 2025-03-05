create or replace view "il_ust"."v_ust_compartment_substance" as
 SELECT DISTINCT (x."FacilityID")::character varying(50) AS facility_id,
    x."TankID" AS tank_id,
    x."CompartmentID" AS compartment_id,
    s.substance_id
   FROM (il_ust.compartment x
     LEFT JOIN il_ust.v_substance_xwalk s ON ((x."CompartmentSubstanceStored" = (s.organization_value)::text)));