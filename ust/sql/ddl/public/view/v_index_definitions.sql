create or replace view "public"."v_index_definitions" as
 SELECT pg_indexes.schemaname AS schema_name,
    pg_indexes.tablename AS table_name,
    pg_indexes.indexname AS index_name,
    pg_indexes.indexdef AS index_def
   FROM pg_indexes
  WHERE (pg_indexes.schemaname <> ALL (ARRAY['information_schema'::name, 'pg_catalog'::name, 'pgagent'::name]))
  ORDER BY pg_indexes.schemaname, pg_indexes.tablename, pg_indexes.indexname;