create or replace view "md_ust"."v_ust_compartment_substance" as
 SELECT DISTINCT c.facility_id,
    c.tank_id,
    sx.substance_id,
    c.compartment_id
   FROM ((md_ust.md_tanks_combined x
     JOIN md_ust.v_substance_xwalk sx ON ((x."SubstanceDesc" = (sx.organization_value)::text)))
     JOIN md_ust.erg_compartment_id c ON (((((x."FacilityID")::character varying)::text = (c.facility_id)::text) AND ((x."TankID")::integer = c.tank_id) AND ((c.compartment_name)::text = x."tblCompartment_Compartment"))));