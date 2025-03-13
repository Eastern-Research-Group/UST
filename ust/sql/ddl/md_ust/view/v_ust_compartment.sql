create or replace view "md_ust"."v_ust_compartment" as
 SELECT DISTINCT c.facility_id,
    c.tank_id,
    c.compartment_id,
    (x."tblCompartment_Compartment")::character varying(50) AS compartment_name,
    ts.compartment_status_id,
    (x."Gallons")::integer AS compartment_capacity_gallons
   FROM ((md_ust.md_tanks_combined x
     JOIN md_ust.erg_compartment_id c ON (((((x."FacilityID")::character varying)::text = (c.facility_id)::text) AND ((x."TankID")::integer = c.tank_id) AND ((c.compartment_name)::text = x."tblCompartment_Compartment"))))
     LEFT JOIN md_ust.v_compartment_status_xwalk ts ON ((x."TankStatusDesc" = (ts.organization_value)::text)));