create or replace view "nh_ust"."v_ust_tank_substance" as
 SELECT DISTINCT eti.facility_id,
    eti.tank_id,
    c.substance_id
   FROM (((nh_ust.tanks a
     LEFT JOIN nh_ust.v_substance_xwalk c ON ((a."SUBSTANCE_STORED" = (c.organization_value)::text)))
     JOIN nh_ust.erg_tank_id eti ON (((a."FACILITY_ID" = (eti.facility_id)::integer) AND (a."TANK_NUMBER" = (eti.tank_name)::text))))
     JOIN nh_ust.facilities fac ON (((a."FACILITY_ID" = fac."FACILITY_ID") AND (fac."FACILITY_TYPE" <> 'PROPOSED FACILITY'::text))))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM nh_ust.erg_unregulated_tanks unreg
          WHERE ((((a."FACILITY_ID")::character varying(50))::text = (unreg.facility_id)::text) AND (eti.tank_id = unreg.tank_id)))));