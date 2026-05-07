create or replace view "public"."v_release_mapped_table_types" as
 SELECT v_release_table_population_sql.release_control_id,
    v_release_table_population_sql.epa_table_name,
    v_release_table_population_sql.organization_table_name,
    'key'::text AS table_type
   FROM v_release_table_population_sql
  WHERE (((COALESCE(v_release_table_population_sql.primary_key, 'N'::character varying, 'Y'::character varying))::text = 'Y'::text) AND ((v_release_table_population_sql.organization_table_name)::text !~~ 'erg%id'::text) AND (v_release_table_population_sql.organization_table_name IS NOT NULL))
UNION ALL
 SELECT v_release_table_population_sql.release_control_id,
    v_release_table_population_sql.epa_table_name,
    v_release_table_population_sql.organization_table_name,
    'id'::text AS table_type
   FROM v_release_table_population_sql
  WHERE (((v_release_table_population_sql.organization_table_name)::text ~~ 'erg%id'::text) AND (v_release_table_population_sql.organization_table_name IS NOT NULL))
UNION ALL
 SELECT v_release_table_population_sql.release_control_id,
    v_release_table_population_sql.epa_table_name,
    v_release_table_population_sql.organization_table_name,
    'org'::text AS table_type
   FROM v_release_table_population_sql
  WHERE (((COALESCE(v_release_table_population_sql.primary_key, 'N'::character varying, 'Y'::character varying))::text <> 'Y'::text) AND (v_release_table_population_sql.organization_table_name IS NOT NULL))
UNION ALL
 SELECT v_release_table_population_sql.release_control_id,
    v_release_table_population_sql.epa_table_name,
    v_release_table_population_sql.organization_join_table AS organization_table_name,
    'join'::text AS table_type
   FROM v_release_table_population_sql
  WHERE (((COALESCE(v_release_table_population_sql.primary_key, 'N'::character varying, 'Y'::character varying))::text <> 'Y'::text) AND (v_release_table_population_sql.organization_join_table IS NOT NULL))
UNION ALL
 SELECT v_release_table_population_sql.release_control_id,
    v_release_table_population_sql.epa_table_name,
    v_release_table_population_sql.database_lookup_table AS organization_table_name,
    'lookup'::text AS table_type
   FROM v_release_table_population_sql
  WHERE (v_release_table_population_sql.database_lookup_table IS NOT NULL)
UNION ALL
 SELECT v_release_table_population_sql.release_control_id,
    v_release_table_population_sql.epa_table_name,
    v_release_table_population_sql.deagg_table_name AS organization_table_name,
    'deagg'::text AS table_type
   FROM v_release_table_population_sql
  WHERE (v_release_table_population_sql.deagg_table_name IS NOT NULL);