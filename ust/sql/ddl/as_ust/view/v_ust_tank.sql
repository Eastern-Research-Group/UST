create or replace view "as_ust"."v_ust_tank" as
 SELECT DISTINCT f.facility_id,
    a.tank_id,
    (a.tank_name)::character varying(50) AS tank_name,
    b.tank_location_id,
    e.tank_status_id,
    a.federally_regulated,
    a.tank_installation_date,
    c.tank_material_description_id,
    d.tank_secondary_containment_id
   FROM (((((as_ust.erg_tank a
     LEFT JOIN as_ust.v_tank_location_xwalk b ON (((a.tank_location)::text = (b.organization_value)::text)))
     LEFT JOIN as_ust.v_tank_material_description_xwalk c ON (((a.tank_material_description)::text = (c.organization_value)::text)))
     LEFT JOIN as_ust.v_tank_secondary_containment_xwalk d ON (((a.tank_secondary_containment)::text = (d.organization_value)::text)))
     LEFT JOIN as_ust.v_tank_status_xwalk e ON (((a.tank_status)::text = (e.organization_value)::text)))
     LEFT JOIN as_ust.v_ust_facility f ON (((a.facility_id)::text = (f.facility_id)::text)));