create or replace view "public"."v_objects" as
 SELECT v_function_names.schema_name,
    'function'::text AS object_type,
    v_function_names.function_name AS object_name
   FROM v_function_names
UNION ALL
 SELECT v_table_names.schema_name,
    'table'::text AS object_type,
    v_table_names.table_name AS object_name
   FROM v_table_names
UNION ALL
 SELECT v_view_names.schema_name,
    'view'::text AS object_type,
    v_view_names.view_name AS object_name
   FROM v_view_names
UNION ALL
 SELECT v_constraint_names.schema_name,
    'constraint'::text AS object_type,
    v_constraint_names.constraint_name AS object_name
   FROM v_constraint_names
UNION ALL
 SELECT v_index_definitions.schema_name,
    'index'::text AS object_type,
    v_index_definitions.index_name AS object_name
   FROM v_index_definitions;