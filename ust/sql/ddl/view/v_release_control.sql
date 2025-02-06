create or replace view "public"."v_release_control" as
 SELECT a.release_control_id,
    a.organization_id,
    a.date_received,
    a.date_processed,
    a.data_source,
    a.comments,
        CASE
            WHEN (b.release_control_id IS NOT NULL) THEN 'Y'::text
            ELSE 'N'::text
        END AS epa_tables_populated
   FROM (( SELECT max(release_control.release_control_id) AS release_control_id,
            release_control.organization_id,
            release_control.date_received,
            release_control.date_processed,
            release_control.data_source,
            release_control.comments
           FROM release_control
          WHERE (release_control.organization_id IS NOT NULL)
          GROUP BY release_control.organization_id, release_control.date_received, release_control.date_processed, release_control.data_source, release_control.comments) a
     LEFT JOIN ( SELECT DISTINCT ust_release.release_control_id
           FROM ust_release) b ON ((a.release_control_id = b.release_control_id)));