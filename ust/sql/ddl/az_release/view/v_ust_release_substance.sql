create or replace view "az_release"."v_ust_release_substance" as
 SELECT DISTINCT (x.release_id)::character varying(50) AS release_id,
    s.substance_id,
    s.organization_value AS substance_comment
   FROM (az_release.v_substances x
     JOIN az_release.v_substance_xwalk s ON ((x.substance = (s.organization_value)::text)))
  WHERE (s.substance_id IS NOT NULL);