create or replace view "wv_ust"."v_ust_tank" as
 SELECT DISTINCT (x."Facility ID")::character varying(50) AS facility_id,
    (x."Tank Id")::integer AS tank_id,
    ts.tank_status_id,
    (x."Regulated")::character varying(7) AS federally_regulated,
    (x."Closed")::date AS tank_closure_date,
    (x."Installed")::date AS tank_installation_date,
        CASE
            WHEN (x."Compartments" = 1) THEN 'No'::text
            WHEN (x."Compartments" > 1) THEN 'Yes'::text
            ELSE NULL::text
        END AS compartmentalized_ust,
    (x."Compartments")::integer AS number_of_compartments,
    md.tank_material_description_id
   FROM ((wv_ust.tanks x
     LEFT JOIN wv_ust.v_tank_status_xwalk ts ON ((x."Tank Status" = (ts.organization_value)::text)))
     LEFT JOIN wv_ust.v_tank_material_description_xwalk md ON ((x."Material" = (md.organization_value)::text)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM wv_ust.erg_unregulated_tanks unreg
          WHERE ((((x."Facility ID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."Tank Id")::integer = unreg.tank_id)))));