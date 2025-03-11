create or replace view "trustd_release"."v_impacted_media" as
 SELECT ut_release.release_id,
    ut_impacted_media_type_id.ut_impacted_media_type_id
   FROM trustd_ust.ut_release,
    LATERAL unnest(string_to_array(ut_release.impacted_media_new, ':'::text)) ut_impacted_media_type_id(ut_impacted_media_type_id);