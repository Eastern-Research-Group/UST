create or replace view "public"."v_view_names" as
 SELECT tables.table_schema AS schema_name,
    tables.table_name AS view_name
   FROM information_schema.tables
  WHERE (((tables.table_schema)::name <> ALL (ARRAY['information_schema'::name, 'pg_catalog'::name, 'pgagent'::name])) AND ((tables.table_type)::text ~~ '%VIEW'::text))
  ORDER BY tables.table_schema, tables.table_name;