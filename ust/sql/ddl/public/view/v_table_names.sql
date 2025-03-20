create or replace view "public"."v_table_names" as
 SELECT tables.table_schema AS schema_name,
    tables.table_name
   FROM information_schema.tables
  WHERE ((tables.table_schema)::name <> ALL (ARRAY['information_schema'::name, 'pg_catalog'::name, 'pgagent'::name]))
  ORDER BY tables.table_schema, tables.table_name;