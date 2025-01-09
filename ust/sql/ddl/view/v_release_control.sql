create or replace view "public"."v_release_control" as
 SELECT max(release_control.release_control_id) AS release_control_id,
    release_control.organization_id,
    release_control.date_received,
    release_control.date_processed,
    release_control.data_source,
    release_control.comments
   FROM release_control
  WHERE (release_control.organization_id IS NOT NULL)
  GROUP BY release_control.organization_id, release_control.date_received, release_control.date_processed, release_control.data_source, release_control.comments;