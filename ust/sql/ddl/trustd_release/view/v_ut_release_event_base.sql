create or replace view "trustd_release"."v_ut_release_event_base" as
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
    c.release_event_desc,
    c.sequence
   FROM ((trustd_ust.ut_release_event a
     JOIN ( SELECT ut_release_event.release_id,
            COALESCE(max(ut_release_event.event_date), 'X'::text) AS event_date
           FROM trustd_ust.ut_release_event
          GROUP BY ut_release_event.release_id) b ON (((a.release_id = b.release_id) AND (COALESCE(a.event_date, 'X'::text) = COALESCE(b.event_date, 'X'::text)))))
     JOIN trustd_ust.ut_release_event_type c ON ((a.release_event_type_id = (c.release_event_type_id)::double precision)));