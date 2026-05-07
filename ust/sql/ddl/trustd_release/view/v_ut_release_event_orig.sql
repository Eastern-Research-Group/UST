create or replace view "trustd_release"."v_ut_release_event_orig" as
 SELECT a.release_event_id,
    a.release_id,
    a.release_event_type_id,
    a.event_date,
    a.event_note,
    a.created_by,
    a.created_date,
    a.updated_by,
    a.updated_date,
    a.source_of_funding,
    a.stalled,
    a.status_date,
    a.release_status_type_id,
    a.stalled_category_id,
    a.release_event_desc,
    a.sequence
   FROM (trustd_release.v_ut_release_event_base a
     JOIN ( SELECT v_ut_release_event_base.release_id,
            COALESCE(min(v_ut_release_event_base.sequence), (999)::double precision) AS sequence
           FROM trustd_release.v_ut_release_event_base
          GROUP BY v_ut_release_event_base.release_id) b ON (((a.release_id = b.release_id) AND (a.sequence = b.sequence))));