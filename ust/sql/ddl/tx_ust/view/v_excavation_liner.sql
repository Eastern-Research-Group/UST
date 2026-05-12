create or replace view "tx_ust"."v_excavation_liner" as
 SELECT DISTINCT t.facility_id,
    t.tank_id,
        CASE
            WHEN (((t.tank_synthetic_trench_liner)::text = 'Y'::text) OR ((t.tank_rigid_trench_liner)::text = 'Y'::text)) THEN 'Yes'::text
            ELSE NULL::text
        END AS "ExcavationLiner"
   FROM tx_ust.tanks t;