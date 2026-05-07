create or replace view "public"."v_ust_mapped_table_types_all" as
 SELECT v_ust_table_population_sql.ust_control_id,
    v_ust_table_population_sql.epa_table_name,
    v_ust_table_population_sql.organization_table_name,
    'key'::text AS table_type,
    1 AS sort_order
   FROM v_ust_table_population_sql
  WHERE (((COALESCE(v_ust_table_population_sql.primary_key, 'N'::character varying, 'Y'::character varying))::text = 'Y'::text) AND ((v_ust_table_population_sql.organization_table_name)::text !~~ 'erg%id'::text) AND (v_ust_table_population_sql.organization_table_name IS NOT NULL))
UNION ALL
 SELECT v_ust_table_population_sql.ust_control_id,
    v_ust_table_population_sql.epa_table_name,
    v_ust_table_population_sql.organization_join_table AS organization_table_name,
    'id-join'::text AS table_type,
    2 AS sort_order
   FROM v_ust_table_population_sql
  WHERE (((v_ust_table_population_sql.organization_join_table)::text ~~ 'erg%id'::text) AND (v_ust_table_population_sql.organization_join_table IS NOT NULL))
UNION ALL
 SELECT v_ust_table_population_sql.ust_control_id,
    v_ust_table_population_sql.epa_table_name,
    v_ust_table_population_sql.organization_table_name,
    'id'::text AS table_type,
    3 AS sort_order
   FROM v_ust_table_population_sql
  WHERE (((v_ust_table_population_sql.organization_table_name)::text ~~ 'erg%id'::text) AND (v_ust_table_population_sql.organization_table_name IS NOT NULL))
UNION ALL
 SELECT v_ust_table_population_sql.ust_control_id,
    v_ust_table_population_sql.epa_table_name,
    v_ust_table_population_sql.organization_table_name,
    'org'::text AS table_type,
    4 AS sort_order
   FROM v_ust_table_population_sql
  WHERE (((COALESCE(v_ust_table_population_sql.primary_key, 'N'::character varying, 'Y'::character varying))::text <> 'Y'::text) AND (v_ust_table_population_sql.organization_table_name IS NOT NULL))
UNION ALL
 SELECT v_ust_table_population_sql.ust_control_id,
    v_ust_table_population_sql.epa_table_name,
    v_ust_table_population_sql.organization_join_table AS organization_table_name,
    'join'::text AS table_type,
    5 AS sort_order
   FROM v_ust_table_population_sql
  WHERE (v_ust_table_population_sql.organization_join_table IS NOT NULL)
UNION ALL
 SELECT v_ust_table_population_sql.ust_control_id,
    v_ust_table_population_sql.epa_table_name,
    v_ust_table_population_sql.deagg_table_name AS organization_table_name,
    'deagg'::text AS table_type,
    6 AS sort_order
   FROM v_ust_table_population_sql
  WHERE (v_ust_table_population_sql.deagg_table_name IS NOT NULL)
UNION ALL
 SELECT v_ust_table_population_sql.ust_control_id,
    v_ust_table_population_sql.epa_table_name,
    v_ust_table_population_sql.database_lookup_table AS organization_table_name,
    'lookup'::text AS table_type,
    7 AS sort_order
   FROM v_ust_table_population_sql
  WHERE (v_ust_table_population_sql.database_lookup_table IS NOT NULL);