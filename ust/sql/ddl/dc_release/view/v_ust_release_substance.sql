create or replace view "dc_release"."v_ust_release_substance" as
 SELECT DISTINCT (x."LUSTID")::text AS release_id,
        CASE
            WHEN (s.substance_id IS NULL) THEN 47
            ELSE s.substance_id
        END AS substance_id,
    x."Quantity Released1" AS quantity_released,
    x."Unit1" AS unit
   FROM (dc_release.release x
     LEFT JOIN dc_release.v_substance_xwalk s ON (((x."Substance Released1")::text = (s.organization_value)::text)));