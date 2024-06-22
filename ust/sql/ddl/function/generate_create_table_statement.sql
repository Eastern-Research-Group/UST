create or replace function "public"."generate_create_table_statement" as
CREATE OR REPLACE FUNCTION public.generate_create_table_statement(p_schema_name character varying, p_table_name character varying)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_table_ddl   text;
    column_record record;
BEGIN
    FOR column_record IN 
          SELECT distinct
            b.nspname as schema_name,
            b.relname as table_name,
            a.attname as column_name,
            pg_catalog.format_type(a.atttypid, a.atttypmod) as column_type,
            CASE WHEN 
                (SELECT substring(pg_catalog.pg_get_expr(d.adbin, d.adrelid) for 128)
                 FROM pg_catalog.pg_attrdef d
                 WHERE d.adrelid = a.attrelid AND d.adnum = a.attnum AND a.atthasdef) IS NOT NULL THEN
                'DEFAULT '|| (SELECT substring(pg_catalog.pg_get_expr(d.adbin, d.adrelid) for 128)
                              FROM pg_catalog.pg_attrdef d
                              WHERE d.adrelid = a.attrelid AND d.adnum = a.attnum AND a.atthasdef)
            else '' END as column_default_value,
            CASE WHEN a.attnotnull = true THEN 'NOT NULL' else 'NULL' END as column_not_null,
  			case when a.attidentity = 'a' then 'generated always as identity' else '' end as column_identity,
            a.attnum as attnum,
            e.max_attnum as max_attnum
        FROM 
            pg_catalog.pg_attribute a
            INNER JOIN 
             (SELECT c.oid, n.nspname,  c.relname
              FROM pg_catalog.pg_class c
                   LEFT JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
              WHERE c.relname ~ ('^(' || p_table_name || ')$')
                AND pg_catalog.pg_table_is_visible(c.oid)
              ORDER BY 2, 3) b ON a.attrelid = b.oid
            INNER JOIN 
             (SELECT a.attrelid, max(a.attnum) as max_attnum
              FROM pg_catalog.pg_attribute a
              WHERE a.attnum > 0 AND NOT a.attisdropped
              GROUP BY a.attrelid) e ON a.attrelid = e.attrelid
            inner join 
            (select a.attrelid, a.attidentity from pg_catalog.pg_attribute a
            where a.attnum > 0 and not a.attisdropped) f
            on a.attrelid = f.attrelid
        WHERE a.attnum > 0 AND NOT a.attisdropped and b.nspname = p_schema_name
        ORDER BY a.attnum 
    LOOP
        IF column_record.attnum = 1 THEN
            v_table_ddl := 'CREATE TABLE ' || column_record.schema_name || 
           					'.' || column_record.table_name || ' (';
        ELSE
            v_table_ddl := v_table_ddl || ',';
        END IF;

        IF column_record.attnum <= column_record.max_attnum THEN
          v_table_ddl := v_table_ddl || chr(10) || '    ' || 
          				 column_record.column_name || ' ' || 
                     	 column_record.column_type || ' ' || 
                     	 column_record.column_default_value || ' ' ||
                     	 column_record.column_not_null || ' ' ||
                     	 column_record.column_identity;
        END IF;
    END LOOP;
    v_table_ddl := v_table_ddl||');';
    RETURN v_table_ddl;
END;
$function$
