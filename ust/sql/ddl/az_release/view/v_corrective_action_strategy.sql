create or replace view "az_release"."v_corrective_action_strategy" as
 SELECT DISTINCT x.release_id,
    x.corrective_action_strategy,
    x.corrective_action_strategy_start_date
   FROM ( SELECT ust_release."LUSTID" AS release_id,
            ust_release."CorrectiveActionStrategy1" AS corrective_action_strategy,
            ust_release."CorrectiveActionStrategy1StartDate" AS corrective_action_strategy_start_date
           FROM az_release.ust_release
        UNION ALL
         SELECT ust_release."LUSTID" AS release_id,
            ust_release."CorrectiveActionStrategy2" AS corrective_action_strategy,
            ust_release."CorrectiveActionStrategy2StartDate" AS corrective_action_strategy_start_date
           FROM az_release.ust_release
        UNION ALL
         SELECT ust_release."LUSTID" AS release_id,
            ust_release."CorrectiveActionStrategy3" AS corrective_action_strategy,
            ust_release."CorrectiveActionStrategy3StartDate" AS corrective_action_strategy_start_date
           FROM az_release.ust_release
        UNION ALL
         SELECT ust_release."LUSTID" AS release_id,
            ust_release."CorrectiveActionStrategy4" AS corrective_action_strategy,
            ust_release."CorrectiveActionStrategy4StartDate" AS corrective_action_strategy_start_date
           FROM az_release.ust_release
        UNION ALL
         SELECT ust_release."LUSTID" AS release_id,
            ust_release."CorrectiveActionStrategy5" AS corrective_action_strategy,
            ust_release."CorrectiveActionStrategy5StartDate" AS corrective_action_strategy_start_date
           FROM az_release.ust_release
        UNION ALL
         SELECT ust_release."LUSTID" AS release_id,
            ust_release."CorrectiveActionStrategy6" AS corrective_action_strategy,
            ust_release."CorrectiveActionStrategy6StartDate" AS corrective_action_strategy_start_date
           FROM az_release.ust_release) x
  WHERE (x.corrective_action_strategy IS NOT NULL);