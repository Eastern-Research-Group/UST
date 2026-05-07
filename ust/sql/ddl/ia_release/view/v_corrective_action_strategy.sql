create or replace view "ia_release"."v_corrective_action_strategy" as
 SELECT DISTINCT x."LUSTID",
    x.corrective_action_strategy_id,
    x.corrective_action_strategy_start_date
   FROM ( SELECT "Template"."LUSTID",
            "Template"."CorrectiveActionStrategy1" AS corrective_action_strategy_id,
            "Template"."CorrectiveActionStrategy1StartDate" AS corrective_action_strategy_start_date
           FROM ia_release."Template"
        UNION ALL
         SELECT "Template"."LUSTID",
            "Template"."CorrectiveActionStrategy2" AS corrective_action_strategy_id,
            "Template"."CorrectiveActionStrategy2StartDate" AS corrective_action_strategy_start_date
           FROM ia_release."Template") x
  WHERE (x.corrective_action_strategy_id IS NOT NULL);