create or replace view "public"."v_ust_table_row_count" as
 SELECT v_ust_facility.ust_control_id,
    1 AS sort_order,
    'ust_facility'::text AS table_name,
    count(*) AS num_rows
   FROM v_ust_facility
  GROUP BY v_ust_facility.ust_control_id
UNION ALL
 SELECT v_ust_tank.ust_control_id,
    2 AS sort_order,
    'ust_tank'::text AS table_name,
    count(*) AS num_rows
   FROM v_ust_tank
  GROUP BY v_ust_tank.ust_control_id
UNION ALL
 SELECT v_ust_compartment.ust_control_id,
    3 AS sort_order,
    'ust_compartment'::text AS table_name,
    count(*) AS num_rows
   FROM v_ust_compartment
  GROUP BY v_ust_compartment.ust_control_id
UNION ALL
 SELECT v_ust_piping.ust_control_id,
    4 AS sort_order,
    'ust_piping'::text AS table_name,
    count(*) AS num_rows
   FROM v_ust_piping
  GROUP BY v_ust_piping.ust_control_id;