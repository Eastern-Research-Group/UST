create or replace view "public"."v_ust_unregulated_tanks_to_remove" as
 SELECT DISTINCT y.organization_id,
    x.ust_control_id,
    x."FacilityID",
    x."TankID",
    x."TankName"
   FROM (( SELECT a.ust_control_id,
            a."FacilityID",
            a."TankID",
            a."TankName"
           FROM (v_ust_tank_substance a
             JOIN ( SELECT DISTINCT a_1.ust_control_id,
                    a_1."FacilityID",
                    a_1.facility_type
                   FROM ( SELECT v_ust_facility.ust_control_id,
                            v_ust_facility."FacilityID",
                            v_ust_facility."FacilityType1" AS facility_type
                           FROM v_ust_facility
                        UNION ALL
                         SELECT v_ust_facility.ust_control_id,
                            v_ust_facility."FacilityID",
                            v_ust_facility."FacilityType2" AS facility_type
                           FROM v_ust_facility) a_1
                  WHERE (a_1.facility_type IS NOT NULL)) b ON (((a.ust_control_id = b.ust_control_id) AND ((a."FacilityID")::text = (b."FacilityID")::text))))
          WHERE (((a."Substance")::text ~~ 'Heating%'::text) AND ((b.facility_type)::text <> 'Bulk plant storage/petroleum distributor'::text))
        UNION ALL
         SELECT a.ust_control_id,
            a."FacilityID",
            a."TankID",
            a."TankName"
           FROM (( SELECT v_ust_compartment.ust_control_id,
                    v_ust_compartment."FacilityID",
                    v_ust_compartment."TankID",
                    v_ust_compartment."TankName",
                    sum(v_ust_compartment."CompartmentCapacityGallons") AS tank_capacity_gallons
                   FROM v_ust_compartment
                  GROUP BY v_ust_compartment.ust_control_id, v_ust_compartment."FacilityID", v_ust_compartment."TankID", v_ust_compartment."TankName") a
             JOIN ( SELECT DISTINCT x_1.ust_control_id,
                    x_1."FacilityID",
                    x_1.facility_type
                   FROM ( SELECT v_ust_facility.ust_control_id,
                            v_ust_facility."FacilityID",
                            v_ust_facility."FacilityType1" AS facility_type
                           FROM v_ust_facility
                        UNION ALL
                         SELECT v_ust_facility.ust_control_id,
                            v_ust_facility."FacilityID",
                            v_ust_facility."FacilityType2" AS facility_type
                           FROM v_ust_facility) x_1
                  WHERE ((x_1.facility_type IS NOT NULL) AND ((x_1.facility_type)::text = ANY ((ARRAY['Agricultural/farm'::character varying, 'Residential'::character varying])::text[])))) b ON (((a.ust_control_id = b.ust_control_id) AND ((a."FacilityID")::text = (b."FacilityID")::text))))
          WHERE (a.tank_capacity_gallons < 1100)) x
     JOIN ust_control y ON ((x.ust_control_id = y.ust_control_id)))
  ORDER BY y.organization_id, x."FacilityID", x."TankID";