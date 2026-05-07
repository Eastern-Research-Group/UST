create or replace view "hi_release"."v_ust_release_source" as
 SELECT DISTINCT (x."LUSTID")::character varying(50) AS release_id,
    s.source_id
   FROM (hi_release.release x
     LEFT JOIN hi_release.v_source_xwalk s ON ((x."SourceOfRelease1" = (s.organization_value)::text)))
  WHERE (x."SourceOfRelease1" IS NOT NULL);