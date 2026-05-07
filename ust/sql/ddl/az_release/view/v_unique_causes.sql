create or replace view "az_release"."v_unique_causes" as
 SELECT DISTINCT x.cause
   FROM ( SELECT DISTINCT ust_release."CauseOfRelease1" AS cause
           FROM az_release.ust_release
          WHERE (ust_release."CauseOfRelease1" IS NOT NULL)
        UNION ALL
         SELECT DISTINCT ust_release."CauseOfRelease2" AS cause
           FROM az_release.ust_release
          WHERE (ust_release."CauseOfRelease2" IS NOT NULL)
        UNION ALL
         SELECT DISTINCT ust_release."CauseOfRelease3" AS cause
           FROM az_release.ust_release
          WHERE (ust_release."CauseOfRelease3" IS NOT NULL)
        UNION ALL
         SELECT DISTINCT ust_release."CauseOfRelease4" AS cause
           FROM az_release.ust_release
          WHERE (ust_release."CauseOfRelease4" IS NOT NULL)
        UNION ALL
         SELECT DISTINCT (ust_release."CauseOfRelease5")::text AS cause
           FROM az_release.ust_release
          WHERE (ust_release."CauseOfRelease5" IS NOT NULL)) x;