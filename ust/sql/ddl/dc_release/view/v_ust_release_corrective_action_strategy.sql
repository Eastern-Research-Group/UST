create or replace view "dc_release"."v_ust_release_corrective_action_strategy" as
 SELECT DISTINCT (x."LUSTID")::text AS release_id,
        CASE
            WHEN (cas.corrective_action_strategy_id IS NULL) THEN 31
            ELSE cas.corrective_action_strategy_id
        END AS corrective_action_strategy_id,
        CASE
            WHEN ((x."LUSTID")::text = '2017009'::text) THEN '2019-03-18'::date
            ELSE (x."Corrective Action Strategy1Start Date")::date
        END AS corrective_action_strategy_start_date
   FROM (dc_release.release x
     LEFT JOIN dc_release.v_corrective_action_strategy_xwalk cas ON ((x."Corrective Action Strategy1" = (cas.organization_value)::text)));