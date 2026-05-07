create or replace view "az_release"."v_cause_mapping" as
 SELECT DISTINCT x."LUSTID",
    x.cause_comment,
    x.epa_cause
   FROM ( SELECT DISTINCT a."LUSTID",
            a."CauseOfRelease1" AS cause_comment,
            b.epa_cause
           FROM (az_release.ust_release a
             JOIN az_release.erg_cause_mapping b ON (((a."CauseOfRelease1" = b.cause) AND (a."SourceOfRelease1" = b.source))))
          WHERE (a."CauseOfRelease1" IS NOT NULL)
        UNION ALL
         SELECT DISTINCT a."LUSTID",
            a."CauseOfRelease2" AS cause_comment,
            b.epa_cause
           FROM (az_release.ust_release a
             JOIN az_release.erg_cause_mapping b ON (((a."CauseOfRelease2" = b.cause) AND (a."SourceOfRelease2" = b.source))))
          WHERE (a."CauseOfRelease2" IS NOT NULL)
        UNION ALL
         SELECT DISTINCT a."LUSTID",
            a."CauseOfRelease3" AS cause_comment,
            b.epa_cause
           FROM (az_release.ust_release a
             JOIN az_release.erg_cause_mapping b ON (((a."CauseOfRelease3" = b.cause) AND (a."SourceOfRelease3" = b.source))))
          WHERE (a."CauseOfRelease3" IS NOT NULL)
        UNION ALL
         SELECT DISTINCT a."LUSTID",
            a."CauseOfRelease4" AS cause_comment,
            b.epa_cause
           FROM (az_release.ust_release a
             JOIN az_release.erg_cause_mapping b ON (((a."CauseOfRelease4" = b.cause) AND (a."SourceOfRelease4" = b.source))))
          WHERE (a."CauseOfRelease4" IS NOT NULL)) x;