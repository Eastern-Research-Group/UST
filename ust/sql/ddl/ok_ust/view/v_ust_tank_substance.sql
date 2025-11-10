create or replace view "ok_ust"."v_ust_tank_substance" as
 SELECT DISTINCT (a."FacilityID")::character varying(50) AS facility_id,
    (a."TankNumber")::integer AS tank_id,
    c.substance_id
   FROM (ok_ust.erg_compartments_deduplicated a
     JOIN ok_ust.v_substance_xwalk c ON ((a."Substance" = (c.organization_value)::text)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM ok_ust.erg_unregulated_tanks unreg
          WHERE ((((a."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((a."TankNumber")::integer = unreg.tank_id)))));