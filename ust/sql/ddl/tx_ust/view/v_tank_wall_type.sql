create or replace view "tx_ust"."v_tank_wall_type" as
 SELECT DISTINCT t.facility_id,
    t.tank_id,
        CASE
            WHEN ((t.tank_single_wall)::text = 'Y'::text) THEN 'Single'::text
            WHEN ((t.tank_double_wall)::text = 'Y'::text) THEN 'Double'::text
            ELSE NULL::text
        END AS "TankWallType"
   FROM tx_ust.tanks t;