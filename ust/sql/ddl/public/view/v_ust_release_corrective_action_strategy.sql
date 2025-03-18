create or replace view "public"."v_ust_release_corrective_action_strategy" as
 SELECT b.release_control_id,
    b.release_id AS "ReleaseID",
    cas.corrective_action_strategy AS "CorrectiveActionStrategy",
    a.corrective_action_strategy_start_date AS "CorrectiveActionStrategyStartDate",
    a.corrective_action_strategy_comment AS "CorrectiveActionStrategyComment"
   FROM ((ust_release_corrective_action_strategy a
     JOIN ust_release b ON ((a.ust_release_id = b.ust_release_id)))
     JOIN corrective_action_strategies cas ON ((a.corrective_action_strategy_id = cas.corrective_action_strategy_id)));