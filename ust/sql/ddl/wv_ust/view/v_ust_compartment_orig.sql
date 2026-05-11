create or replace view "wv_ust"."v_ust_compartment_orig" as
 SELECT DISTINCT (x."Facility ID")::character varying(50) AS facility_id,
    (x."Tank Id")::integer AS tank_id,
    c.compartment_id,
    cx.compartment_status_id,
    (x."Capacity")::integer AS compartment_capacity_gallons
   FROM ((wv_ust.tanks x
     JOIN wv_ust.erg_compartment c ON (((x."Facility ID" = c.facility_id) AND (x."Tank Id" = c.tank_id))))
     LEFT JOIN wv_ust.v_compartment_status_xwalk cx ON ((x."Tank Status" = (cx.organization_value)::text)));