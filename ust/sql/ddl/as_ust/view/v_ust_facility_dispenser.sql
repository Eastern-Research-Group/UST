create or replace view "as_ust"."v_ust_facility_dispenser" as
 SELECT DISTINCT b.facility_id,
    (a.dispenser_id)::character varying(50) AS dispenser_id,
    a.dispenser_udc
   FROM (as_ust.erg_facility_dispenser a
     LEFT JOIN as_ust.v_ust_facility b ON (((a.facility_id)::text = (b.facility_id)::text)));