create or replace view "ca_ust"."v_ust_tank_substance" as
 SELECT DISTINCT (x."CERS ID")::character varying(50) AS facility_id,
    t.tank_id,
    sx.substance_id
   FROM ((ca_ust.tank x
     JOIN ca_ust.erg_tank_id t ON (((((x."CERS ID")::character varying(50))::text = (t.facility_id)::text) AND (((x."CERS TankID")::character varying(50))::text = (t.tank_name)::text))))
     LEFT JOIN ca_ust.v_substance_xwalk sx ON ((x."Tank Contents " = (sx.organization_value)::text)))
  WHERE (x."Tank Contents " IS NOT NULL);