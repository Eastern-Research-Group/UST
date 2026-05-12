create or replace view "public"."v_ust_release_substance" as
 SELECT b.release_control_id,
    b.release_id AS "ReleaseID",
    s.substance AS "SubstanceReleased",
    a.quantity_released AS "QuantityReleased",
    a.unit AS "Unit",
    a.substance_comment AS "SubstanceComment"
   FROM ((ust_release_substance a
     JOIN ust_release b ON ((a.ust_release_id = b.ust_release_id)))
     JOIN substances s ON ((a.substance_id = s.substance_id)));