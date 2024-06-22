create or replace view "public"."v_ust_release_source" as
 SELECT b.release_control_id,
    b.release_id AS "ReleaseID",
    s.source AS "SourceOfRelease"
   FROM ((ust_release_source a
     JOIN ust_release b ON ((a.ust_release_id = b.ust_release_id)))
     JOIN sources s ON ((a.source_id = s.source_id)));