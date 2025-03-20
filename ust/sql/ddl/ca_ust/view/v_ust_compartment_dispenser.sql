create or replace view "ca_ust"."v_ust_compartment_dispenser" as
 SELECT DISTINCT (x."CERS ID")::character varying(50) AS facility_id,
    t.tank_id,
    t.compartment_id,
    (t.dispenser_id)::character varying(50) AS dispenser_id,
        CASE
            WHEN (x."Construction_Type" = ANY (ARRAY['Single-walled'::text, 'Double-walled'::text])) THEN 'Yes'::text
            WHEN (x."Construction_Type" = 'No Dispensers'::text) THEN 'No'::text
            ELSE NULL::text
        END AS dispenser_udc,
    wt.dispenser_udc_wall_type_id
   FROM ((ca_ust.tank x
     JOIN ca_ust.erg_dispenser_id t ON (((((x."CERS ID")::character varying(50))::text = (t.facility_id)::text) AND (((x."CERS TankID")::character varying(50))::text = (t.tank_name)::text))))
     LEFT JOIN ca_ust.v_dispenser_udc_wall_type_xwalk wt ON ((x."Construction_Type" = (wt.organization_value)::text)))
  WHERE (x."Construction_Type" IS NOT NULL);