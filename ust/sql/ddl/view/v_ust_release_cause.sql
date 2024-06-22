create or replace view "public"."v_ust_release_cause" as
 SELECT b.release_control_id,
    b.release_id AS "ReleaseID",
    s.cause AS "CauseOfRelease"
   FROM ((ust_release_cause a
     JOIN ust_release b ON ((a.ust_release_id = b.ust_release_id)))
     JOIN causes s ON ((a.cause_id = s.cause_id)));