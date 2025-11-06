create or replace view "public"."v_data_view_columns" as
 SELECT a.table_schema,
    d.table_name,
    a.column_name,
        CASE
            WHEN (b.table_sort_order IS NOT NULL) THEN b.table_sort_order
            ELSE c.table_sort_order
        END AS table_sort_order,
        CASE
            WHEN (b.column_sort_order IS NOT NULL) THEN b.column_sort_order
            ELSE c.column_sort_order
        END AS column_sort_order
   FROM (((information_schema.columns a
     JOIN ( SELECT ust_template_data_tables.table_name,
            ust_template_data_tables.view_name
           FROM ust_template_data_tables
        UNION ALL
         SELECT release_template_data_tables.table_name,
            release_template_data_tables.view_name
           FROM release_template_data_tables) d ON (((a.table_name)::name = (d.view_name)::text)))
     LEFT JOIN v_ust_element_metadata b ON ((((d.table_name)::text = (b.table_name)::text) AND ((a.column_name)::name = (b.column_name)::text))))
     LEFT JOIN v_release_element_metadata c ON ((((d.table_name)::text = (c.table_name)::text) AND ((a.column_name)::name = (c.column_name)::text))))
  WHERE (((a.table_schema)::name ~~ '%_ust'::text) OR ((a.table_schema)::name ~~ '%_release'::text));