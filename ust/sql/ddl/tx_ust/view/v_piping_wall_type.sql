create or replace view "tx_ust"."v_piping_wall_type" as
 SELECT DISTINCT t.facility_id,
    t.tank_id,
        CASE
            WHEN ((t.piping_single_wall)::text = 'Y'::text) THEN 'Single walled'::text
            WHEN ((t.piping_double_wall)::text = 'Y'::text) THEN 'Double walled'::text
            ELSE NULL::text
        END AS "PipingWallType"
   FROM tx_ust.tanks t;