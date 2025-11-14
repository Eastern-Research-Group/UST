create or replace view "az_release"."v_ust_release_source" as
 SELECT DISTINCT (a.release_id)::character varying(50) AS release_id,
    b.source_id,
    b.organization_value AS source_comment
   FROM (az_release.v_source a
     JOIN az_release.v_source_xwalk b ON ((a.source = (b.organization_value)::text)));