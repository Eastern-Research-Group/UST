create or replace view "public"."v_release_table_row_count" as
 SELECT v_ust_release.release_control_id,
    1 AS sort_order,
    'ust_release'::text AS table_name,
    count(*) AS num_rows
   FROM v_ust_release
  GROUP BY v_ust_release.release_control_id
UNION ALL
 SELECT v_ust_release_substance.release_control_id,
    2 AS sort_order,
    'ust_release_substance'::text AS table_name,
    count(*) AS num_rows
   FROM v_ust_release_substance
  GROUP BY v_ust_release_substance.release_control_id
UNION ALL
 SELECT v_ust_release_source.release_control_id,
    3 AS sort_order,
    'ust_release_source'::text AS table_name,
    count(*) AS num_rows
   FROM v_ust_release_source
  GROUP BY v_ust_release_source.release_control_id
UNION ALL
 SELECT v_ust_release_cause.release_control_id,
    4 AS sort_order,
    'ust_release_cause'::text AS table_name,
    count(*) AS num_rows
   FROM v_ust_release_cause
  GROUP BY v_ust_release_cause.release_control_id
UNION ALL
 SELECT v_ust_release_corrective_action_strategy.release_control_id,
    5 AS sort_order,
    'ust_release_corrective_action_strategy'::text AS table_name,
    count(*) AS num_rows
   FROM v_ust_release_corrective_action_strategy
  GROUP BY v_ust_release_corrective_action_strategy.release_control_id;