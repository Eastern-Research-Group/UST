create or replace view "trustd_ust"."v_tank_status" as
 SELECT DISTINCT v_ut_tank_system.facility_id,
    v_ut_tank_system.tank_name,
        CASE
            WHEN (v_ut_tank_system.tank_status = 'Permanently Out of Use'::text) THEN
            CASE
                WHEN (v_ut_tank_system.closure_status_desc = ANY (ARRAY['Tank closed in place'::text, 'Tank removed'::text, 'Tank removed from ground'::text])) THEN v_ut_tank_system.closure_status_desc
                ELSE NULL::text
            END
            ELSE v_ut_tank_system.tank_status
        END AS tank_status
   FROM trustd_ust.v_ut_tank_system;