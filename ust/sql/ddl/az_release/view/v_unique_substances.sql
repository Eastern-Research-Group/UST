create or replace view "az_release"."v_unique_substances" as
 SELECT DISTINCT x.substance
   FROM ( SELECT DISTINCT ust_release."SubstanceReleased1" AS substance
           FROM az_release.ust_release
          WHERE (ust_release."SubstanceReleased1" IS NOT NULL)
        UNION ALL
         SELECT DISTINCT ust_release."SubstanceReleased2" AS substance
           FROM az_release.ust_release
          WHERE (ust_release."SubstanceReleased2" IS NOT NULL)
        UNION ALL
         SELECT DISTINCT ust_release."SubstanceReleased3" AS substance
           FROM az_release.ust_release
          WHERE (ust_release."SubstanceReleased3" IS NOT NULL)
        UNION ALL
         SELECT DISTINCT ust_release."SubstanceReleased4" AS substance
           FROM az_release.ust_release
          WHERE (ust_release."SubstanceReleased4" IS NOT NULL)
        UNION ALL
         SELECT DISTINCT (ust_release."SubstanceReleased5")::text AS substance
           FROM az_release.ust_release
          WHERE (ust_release."SubstanceReleased5" IS NOT NULL)) x;