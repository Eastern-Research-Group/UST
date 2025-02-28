create or replace view "public"."v_release_control" as
 SELECT b.release_control_id,
    b.organization_id,
    b.date_received,
    b.date_processed,
    b.data_source,
    b.comments,
        CASE
            WHEN (c.release_control_id IS NOT NULL) THEN 'Y'::text
            ELSE 'N'::text
        END AS epa_tables_populated
   FROM ((( SELECT release_control.organization_id,
            max(release_control.release_control_id) AS release_control_id
           FROM release_control
          WHERE (release_control.organization_id IS NOT NULL)
          GROUP BY release_control.organization_id) a
     JOIN release_control b ON ((a.release_control_id = b.release_control_id)))
     LEFT JOIN ( SELECT DISTINCT ust_release.release_control_id
           FROM ust_release) c ON ((b.release_control_id = c.release_control_id)));