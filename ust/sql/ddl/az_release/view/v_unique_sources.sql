create or replace view "az_release"."v_unique_sources" as
 SELECT DISTINCT x.source
   FROM ( SELECT DISTINCT ust_release."SourceOfRelease1" AS source
           FROM az_release.ust_release
          WHERE (ust_release."SourceOfRelease1" IS NOT NULL)
        UNION ALL
         SELECT DISTINCT ust_release."SourceOfRelease2" AS source
           FROM az_release.ust_release
          WHERE (ust_release."SourceOfRelease2" IS NOT NULL)
        UNION ALL
         SELECT DISTINCT ust_release."SourceOfRelease3" AS source
           FROM az_release.ust_release
          WHERE (ust_release."SourceOfRelease3" IS NOT NULL)
        UNION ALL
         SELECT DISTINCT ust_release."SourceOfRelease4" AS source
           FROM az_release.ust_release
          WHERE (ust_release."SourceOfRelease4" IS NOT NULL)
        UNION ALL
         SELECT DISTINCT (ust_release."SourceOfRelease5")::text AS source
           FROM az_release.ust_release
          WHERE (ust_release."SourceOfRelease5" IS NOT NULL)) x;