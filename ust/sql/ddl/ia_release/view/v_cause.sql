create or replace view "ia_release"."v_cause" as
 SELECT DISTINCT x."LUSTID",
    x.cause_id
   FROM ( SELECT "Template"."LUSTID",
            "Template"."CauseOfRelease1" AS cause_id
           FROM ia_release."Template"
        UNION ALL
         SELECT "Template"."LUSTID",
            "Template"."CauseOfRelease2" AS cause_id
           FROM ia_release."Template"
        UNION ALL
         SELECT "Template"."LUSTID",
            "Template"."CauseOfRelease3" AS cause_id
           FROM ia_release."Template") x
  WHERE (x.cause_id IS NOT NULL);