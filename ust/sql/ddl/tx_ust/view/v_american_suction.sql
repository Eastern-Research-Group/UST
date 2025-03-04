create or replace view "tx_ust"."v_american_suction" as
 SELECT DISTINCT t.facility_id,
    t.tank_id,
        CASE
            WHEN ((c.piping_rd_exempt)::text = 'N'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS "AmericanSuction"
   FROM (tx_ust.tanks t
     JOIN tx_ust.compartments c ON ((((t.facility_id)::text = (c.facility_id)::text) AND ((t.tank_id)::text = (c.tank_id)::text))))
  WHERE ((t.piping_type)::text = 'S'::text);