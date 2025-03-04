create or replace view "ia_release"."v_ust_release_substance" as
 SELECT DISTINCT (x."LUSTID")::character varying(50) AS release_id,
    c.substance_id,
    x.quantity_released,
    x.unit
   FROM (ia_release.v_substance_released x
     LEFT JOIN ia_release.v_substance_released_xwalk c ON ((x.substance_released = (c.organization_value)::text)))
  WHERE (x.substance_released IS NOT NULL);