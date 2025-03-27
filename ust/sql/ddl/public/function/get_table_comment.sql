create or replace function "public"."get_table_comment" as
CREATE OR REPLACE FUNCTION public.get_table_comment(p_table_name text, p_schema_name text DEFAULT NULL::text)
 RETURNS text
 LANGUAGE sql
AS $function$
    SELECT obj_description((CASE 
       WHEN strpos($1, '.')>0 THEN $1
       WHEN $2 IS NULL THEN 'public.'||$1
       ELSE $2||'.'||$1
            END)::regclass, 'pg_class');
 $function$
