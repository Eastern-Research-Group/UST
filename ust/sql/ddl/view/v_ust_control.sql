create or replace view "public"."v_ust_control" as
 SELECT b.ust_control_id,
    b.organization_id,
    b.date_received,
    b.date_processed,
    b.data_source,
    b.comments,
    b.organization_compartment_flag,
        CASE
            WHEN (c.ust_control_id IS NOT NULL) THEN 'Y'::text
            ELSE 'N'::text
        END AS epa_tables_populated
   FROM ((( SELECT ust_control.organization_id,
            max(ust_control.ust_control_id) AS ust_control_id
           FROM ust_control
          WHERE (ust_control.organization_id IS NOT NULL)
          GROUP BY ust_control.organization_id) a
     JOIN ust_control b ON ((a.ust_control_id = b.ust_control_id)))
     LEFT JOIN ( SELECT DISTINCT ust_facility.ust_control_id
           FROM ust_facility) c ON ((b.ust_control_id = c.ust_control_id)));