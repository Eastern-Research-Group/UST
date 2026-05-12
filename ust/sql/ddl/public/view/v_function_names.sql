create or replace view "public"."v_function_names" as
 SELECT ns.nspname AS schema_name,
    p.proname AS function_name,
    p.oid
   FROM (pg_proc p
     JOIN pg_namespace ns ON ((p.pronamespace = ns.oid)))
  WHERE (ns.nspname <> ALL (ARRAY['information_schema'::name, 'pg_catalog'::name, 'pgagent'::name]))
  ORDER BY ns.nspname, p.proname;