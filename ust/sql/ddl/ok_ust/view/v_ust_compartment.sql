create or replace view "ok_ust"."v_ust_compartment" as
 SELECT DISTINCT (x."FacilityID")::character varying(50) AS facility_id,
    (x."TankNumber")::integer AS tank_id,
    (x."CompartmentNumber")::integer AS compartment_id,
    vtsx.compartment_status_id,
    (x."Capacity")::integer AS compartment_capacity_gallons
   FROM ((ok_ust.erg_compartments_deduplicated x
     JOIN ok_ust.v_compartment_status_xwalk vtsx ON (((vtsx.organization_value)::text = x."CompartmentStatus")))
     JOIN ok_ust."OK_UST_Data" b ON (((b."FacilityID" = x."FacilityID") AND (b.tank_name = x."TankNumber"))));