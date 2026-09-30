CREATE OR REPLACE VIEW public.vw_database_table_row_counts AS
 WITH t AS (
         SELECT vw_database_tables.table_schema,
            vw_database_tables.table_name,
            vw_database_tables.table_type
           FROM vw_database_tables
          WHERE vw_database_tables.table_type::text = 'BASE TABLE'::text
        )
 SELECT t.table_schema,
    t.table_name,
    t.table_type,
    (xpath('/row/c/text()'::text, query_to_xml(format('select count(*) as c from %I.%I'::text, t.table_schema, t.table_name), false, true, ''::text)))[1]::text::integer AS num_rows
   FROM t;
