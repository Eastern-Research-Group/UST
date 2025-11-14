create or replace view "ia_release"."v_ust_release_source" as
 SELECT DISTINCT (x."LUSTID")::character varying(50) AS release_id,
    c.source_id
   FROM (ia_release.v_source x
     LEFT JOIN ia_release.v_source_xwalk c ON ((x.source_id = (c.organization_value)::text)))
  WHERE (x.source_id IS NOT NULL);