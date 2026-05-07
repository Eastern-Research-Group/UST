create or replace view "az_ust"."v_ust_compartment_substance" as
 SELECT a."FacilityID" AS facility_id,
    (a."TankName")::integer AS tank_id,
    b.compartment_id,
    c.substance_id
   FROM ((az_ust.ust_compartment a
     JOIN az_ust.erg_compartment_id b ON (((a."FacilityID" = (b.facility_id)::text) AND ((a."TankName")::text = (b.tank_name)::text) AND (a."CompartmentName" = (b.compartment_name)::text))))
     LEFT JOIN az_ust.v_substance_xwalk c ON ((a."CompartmentSubstanceStored" = (c.organization_value)::text)))
  WHERE ((c.substance_id IS NOT NULL) AND (EXISTS ( SELECT 1
           FROM az_ust.erg_v_ust_tank x
          WHERE ((a."FacilityID" = (x.facility_id)::text) AND (a."TankName" = x.tank_id)))) AND (NOT (EXISTS ( SELECT 1
           FROM az_ust.erg_unregulated_tanks unreg
          WHERE ((((a."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((a."TankName")::integer = unreg.tank_id))))));