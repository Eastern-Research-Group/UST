create or replace view "az_release"."v_ust_release_corrective_action_strategy" as
 SELECT DISTINCT (x.release_id)::character varying(50) AS release_id,
    s.corrective_action_strategy_id,
    (x.corrective_action_strategy_start_date)::date AS corrective_action_strategy_start_date
   FROM (az_release.v_corrective_action_strategy x
     JOIN az_release.v_corrective_action_strategy_xwalk s ON ((x.corrective_action_strategy = (s.organization_value)::text)));