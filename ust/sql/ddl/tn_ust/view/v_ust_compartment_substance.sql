create or replace view "tn_ust"."v_ust_compartment_substance" as
 SELECT DISTINCT (a."Tank Id")::integer AS tank_id,
    (a."Facility Id Ust")::character varying(50) AS facility_id,
    (a."Compartment Id")::integer AS compartment_id,
    b.substance_id
   FROM (tn_ust.tn_compartments a
     LEFT JOIN tn_ust.v_substance_xwalk b ON ((a."Product" = (b.organization_value)::text)))
  WHERE (((a."Regulated Status" = 'Regulated'::text) OR (a."Regulated Status" IS NULL)) AND (NOT (EXISTS ( SELECT 1
           FROM tn_ust.erg_unregulated_tanks unreg
          WHERE ((((a."Facility Id Ust")::character varying(50))::text = (unreg.facility_id)::text) AND ((a."Tank Id")::integer = unreg.tank_id))))));