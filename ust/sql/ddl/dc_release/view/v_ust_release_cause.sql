create or replace view "dc_release"."v_ust_release_cause" as
 SELECT DISTINCT (x."LUSTID")::text AS release_id,
    c.cause_id
   FROM (dc_release.release x
     LEFT JOIN dc_release.v_cause_xwalk c ON ((x."Cause Of Release1" = (c.organization_value)::text)));