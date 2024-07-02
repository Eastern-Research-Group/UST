create or replace view "public"."v_ust_compartment_substance" as
 SELECT d.ust_control_id,
    d.facility_id AS "FacilityID",
    c.tank_id AS "TankID",
    c.tank_name AS "TankName",
    b.compartment_id AS "CompartmentID",
    b.compartment_name AS "CompartmentName",
    s.substance AS "Substance"
   FROM (((((ust_compartment_substance a
     JOIN ust_compartment b ON ((a.ust_compartment_id = b.ust_compartment_id)))
     JOIN ust_tank c ON ((b.ust_tank_id = c.ust_tank_id)))
     JOIN ust_facility d ON ((c.ust_facility_id = d.ust_facility_id)))
     LEFT JOIN ust_tank_substance ts ON ((c.ust_tank_id = ts.ust_tank_id)))
     LEFT JOIN substances s ON ((ts.substance_id = s.substance_id)));