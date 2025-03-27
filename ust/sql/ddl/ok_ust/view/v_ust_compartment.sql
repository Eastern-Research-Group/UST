create or replace view "ok_ust"."v_ust_compartment" as
 SELECT DISTINCT (a."FacilityID")::character varying(50) AS facility_id,
    (a."TankNumber")::integer AS tank_id,
    (a."CompartmentNumber")::integer AS compartment_id,
    b.compartment_status_id,
    (a."Capacity")::integer AS compartment_capacity_gallons
   FROM (ok_ust.erg_compartments_deduplicated a
     LEFT JOIN ok_ust.v_compartment_status_xwalk b ON ((a."CompartmentStatus" = (b.organization_value)::text)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM ok_ust.erg_unregulated_tanks unreg
          WHERE ((((a."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((a."TankNumber")::integer = unreg.tank_id)))));