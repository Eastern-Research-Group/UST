create or replace view "public"."v_ust_control" as
 SELECT a.ust_control_id,
    a.organization_id,
    a.date_received,
    a.date_processed,
    a.data_source,
    a.comments,
    a.organization_compartment_flag,
        CASE
            WHEN (b.ust_control_id IS NOT NULL) THEN 'Y'::text
            ELSE 'N'::text
        END AS epa_tables_populated
   FROM (( SELECT max(ust_control.ust_control_id) AS ust_control_id,
            ust_control.organization_id,
            ust_control.date_received,
            ust_control.date_processed,
            ust_control.data_source,
            ust_control.comments,
            ust_control.organization_compartment_flag
           FROM ust_control
          WHERE (ust_control.organization_id IS NOT NULL)
          GROUP BY ust_control.organization_id, ust_control.date_received, ust_control.date_processed, ust_control.data_source, ust_control.comments, ust_control.organization_compartment_flag) a
     LEFT JOIN ( SELECT DISTINCT ust_facility.ust_control_id
           FROM ust_facility) b ON ((a.ust_control_id = b.ust_control_id)));