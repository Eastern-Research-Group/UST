create or replace view "public"."v_release_row_count_summary" as
 SELECT a.table_name,
    a.num_rows,
    b.sort_order,
    a.release_control_id
   FROM (( SELECT v_ust_release.release_control_id,
            'Release'::text AS table_name,
            count(*) AS num_rows
           FROM v_ust_release
          GROUP BY v_ust_release.release_control_id
        UNION ALL
         SELECT v_ust_release_substance.release_control_id,
            'Substance'::text AS table_name,
            count(*) AS num_rows
           FROM v_ust_release_substance
          GROUP BY v_ust_release_substance.release_control_id
        UNION ALL
         SELECT v_ust_release_source.release_control_id,
            'Source'::text AS table_name,
            count(*) AS num_rows
           FROM v_ust_release_source
          GROUP BY v_ust_release_source.release_control_id
        UNION ALL
         SELECT v_ust_release_cause.release_control_id,
            'Cause'::text AS table_name,
            count(*) AS num_rows
           FROM v_ust_release_cause
          GROUP BY v_ust_release_cause.release_control_id
        UNION ALL
         SELECT v_ust_release_corrective_action_strategy.release_control_id,
            'Corrective Action Strategy'::text AS table_name,
            count(*) AS num_rows
           FROM v_ust_release_corrective_action_strategy
          GROUP BY v_ust_release_corrective_action_strategy.release_control_id) a
     JOIN release_template_data_tables b ON ((a.table_name = (b.template_tab_name)::text)));