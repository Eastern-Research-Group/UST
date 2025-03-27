create or replace view "me_ust"."v_ust_compartment_substance" as
 SELECT DISTINCT (x."REGISTRATION NUMBER")::character varying(50) AS facility_id,
    (x."TANK NUMBER")::integer AS tank_id,
    (x."CHAMBER ID")::integer AS compartment_id,
    s.substance_id
   FROM (me_ust.tanks x
     JOIN me_ust.v_substance_xwalk s ON ((x."PRODUCT STORED" = (s.organization_value)::text)))
  WHERE ((s.substance_id IS NOT NULL) AND (x."TANK STATUS" <> ALL (ARRAY['ACTIVE_NON_REGULATED'::text, 'NEVER_INSTALLED'::text, 'PLANNED'::text, 'TRANSFER'::text])) AND (NOT (EXISTS ( SELECT 1
           FROM me_ust.erg_unregulated_tanks unreg
          WHERE ((((x."REGISTRATION NUMBER")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TANK NUMBER")::integer = unreg.tank_id))))));