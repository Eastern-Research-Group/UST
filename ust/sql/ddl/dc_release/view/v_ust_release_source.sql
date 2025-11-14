create or replace view "dc_release"."v_ust_release_source" as
 SELECT DISTINCT (x."LUSTID")::text AS release_id,
    s.source_id
   FROM (dc_release.release x
     LEFT JOIN dc_release.v_source_xwalk s ON ((x."Source Of Release1" = (s.organization_value)::text)));