create or replace view "ia_release"."v_source" as
 SELECT DISTINCT x."LUSTID",
    x.source_id
   FROM ( SELECT "Template"."LUSTID",
            "Template"."SourceOfRelease1" AS source_id
           FROM ia_release."Template"
        UNION ALL
         SELECT "Template"."LUSTID",
            "Template"."SourceOfRelease2" AS source_id
           FROM ia_release."Template"
        UNION ALL
         SELECT "Template"."LUSTID",
            "Template"."SourceOfRelease3" AS source_id
           FROM ia_release."Template") x
  WHERE (x.source_id IS NOT NULL);