create or replace view "nh_ust"."v_ust_facility_dispenser" as
 SELECT DISTINCT (di."FACILITY_ID")::character varying(50) AS facility_id,
    (di.dispenser_id)::character varying(50) AS dispenser_id
   FROM (nh_ust."UST_V2_template_03_01_24_DispenserInfo" di
     JOIN nh_ust.facilities a ON (((di."FACILITY_ID" = a."FACILITY_ID") AND (a."FACILITY_TYPE" <> 'PROPOSED FACILITY'::text))));