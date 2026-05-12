create or replace view "public"."v_constraint_names" as
 SELECT nsp.nspname AS schema_name,
    rel.relname AS table_name,
    con.conname AS constraint_name
   FROM ((pg_constraint con
     JOIN pg_class rel ON ((rel.oid = con.conrelid)))
     JOIN pg_namespace nsp ON ((nsp.oid = con.connamespace)))
  WHERE (nsp.nspname <> ALL (ARRAY['information_schema'::name, 'pg_catalog'::name, 'pgagent'::name]))
  ORDER BY nsp.nspname, rel.relname, con.conname;