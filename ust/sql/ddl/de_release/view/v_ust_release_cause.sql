create or replace view "de_release"."v_ust_release_cause" as
 SELECT DISTINCT x."LUSTID" AS release_id,
    x."CauseOfRelease1" AS cause_id
   FROM (de_release."Template" x
     LEFT JOIN de_release.v_coordinate_source_xwalk cs ON ((x."CoordinateSource" = (cs.organization_value)::text)));