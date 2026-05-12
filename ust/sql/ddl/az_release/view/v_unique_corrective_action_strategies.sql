create or replace view "az_release"."v_unique_corrective_action_strategies" as
 SELECT DISTINCT x.corrective_action_strategy
   FROM ( SELECT DISTINCT ust_release."CorrectiveActionStrategy1" AS corrective_action_strategy
           FROM az_release.ust_release
          WHERE (ust_release."CorrectiveActionStrategy1" IS NOT NULL)
        UNION ALL
         SELECT DISTINCT ust_release."CorrectiveActionStrategy2" AS corrective_action_strategy
           FROM az_release.ust_release
          WHERE (ust_release."CorrectiveActionStrategy2" IS NOT NULL)
        UNION ALL
         SELECT DISTINCT ust_release."CorrectiveActionStrategy3" AS corrective_action_strategy
           FROM az_release.ust_release
          WHERE (ust_release."CorrectiveActionStrategy3" IS NOT NULL)
        UNION ALL
         SELECT DISTINCT ust_release."CorrectiveActionStrategy4" AS corrective_action_strategy
           FROM az_release.ust_release
          WHERE (ust_release."CorrectiveActionStrategy4" IS NOT NULL)
        UNION ALL
         SELECT DISTINCT ust_release."CorrectiveActionStrategy5" AS corrective_action_strategy
           FROM az_release.ust_release
          WHERE (ust_release."CorrectiveActionStrategy5" IS NOT NULL)
        UNION ALL
         SELECT DISTINCT ust_release."CorrectiveActionStrategy6" AS corrective_action_strategy
           FROM az_release.ust_release
          WHERE (ust_release."CorrectiveActionStrategy6" IS NOT NULL)
        UNION ALL
         SELECT DISTINCT (ust_release."CorrectiveActionStrategy7")::text AS corrective_action_strategy
           FROM az_release.ust_release
          WHERE (ust_release."CorrectiveActionStrategy7" IS NOT NULL)) x;