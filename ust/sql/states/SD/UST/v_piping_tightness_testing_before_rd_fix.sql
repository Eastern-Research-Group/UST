create or replace view sd_ust.v_piping_tightness_testing as
 SELECT DISTINCT tanks."TankPipingType",
    tanks."TankPipingReleaseDetection",
        CASE
            WHEN TRIM(BOTH FROM tanks."TankPipingReleaseDetection") = 'Tightness Testing'::text AND TRIM(BOTH FROM tanks."TankPipingType") = 'Pressure'::text THEN 'Tightness Testing'::text
            ELSE NULL::text
        END AS annual_tightness_testing,
        CASE
            WHEN TRIM(BOTH FROM tanks."TankPipingReleaseDetection") = 'Tightness Testing'::text AND (TRIM(BOTH FROM tanks."TankPipingType") = ANY (ARRAY['Safe Suction'::text, 'Suction'::text, 'Suction - Valve'::text])) THEN 'Tightness Testing'::text
            ELSE NULL::text
        END AS three_year_tightness_testing
   FROM sd_ust.tanks;