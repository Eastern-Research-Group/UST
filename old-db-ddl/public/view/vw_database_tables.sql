CREATE OR REPLACE VIEW public.vw_database_tables AS
 SELECT t.table_schema,
    t.table_name,
    t.table_type
   FROM information_schema.schemata s
     JOIN information_schema.tables t ON s.schema_name::name = t.table_schema::name
  WHERE s.schema_owner::name <> 'postgres'::name AND t.table_schema::name <> 'archive'::name AND t.table_schema::name !~~ '%old'::text AND t.table_schema::name <> 'example'::name AND t.table_schema::name !~~ 'ust%'::text AND t.table_schema::name !~~ '%ast'::text AND t.table_schema::name <> 'oust'::name AND t.table_schema::name <> 'ia_ust_sites_ust'::name;
