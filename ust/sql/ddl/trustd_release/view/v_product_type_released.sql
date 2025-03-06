create or replace view "trustd_release"."v_product_type_released" as
 SELECT a.release_id,
    a.ut_substance_type_id,
    row_number() OVER (PARTITION BY a.release_id) AS rn
   FROM ( SELECT ut_release.release_id,
            ut_substance_type_id.ut_substance_type_id
           FROM trustd_ust.ut_release,
            LATERAL unnest(string_to_array(ut_release.product_type_released, ':'::text)) ut_substance_type_id(ut_substance_type_id)) a;