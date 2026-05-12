create or replace view "hi_release"."v_ust_release_cause" as
 SELECT DISTINCT (x."LUSTID")::character varying(50) AS release_id,
    c.cause_id
   FROM (hi_release.release x
     JOIN hi_release.v_cause_xwalk c ON ((x."CauseOfRelease1" = (c.organization_value)::text)))
  WHERE ((x."CauseOfRelease1" IS NOT NULL) AND (c.cause_id IS NOT NULL));