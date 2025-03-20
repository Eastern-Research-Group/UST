create or replace view "tx_ust"."v_pipe_secondary_containment" as
 SELECT DISTINCT t.facility_id,
    t.tank_id,
        CASE
            WHEN ((t.piping_double_wall)::text = 'Y'::text) THEN 'Double walled'::text
            WHEN (((t.piping_synthetic_trench_liner)::text = 'Y'::text) OR ((t.piping_rigid_trench_liner)::text = 'Y'::text)) THEN 'Trench liner'::text
            ELSE NULL::text
        END AS "PipeSecondaryContainment"
   FROM tx_ust.tanks t;