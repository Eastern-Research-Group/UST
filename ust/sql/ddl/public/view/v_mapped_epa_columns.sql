create or replace view "public"."v_mapped_epa_columns" as
 SELECT DISTINCT a.table_schema,
    a.epa_table_name,
    a.epa_column_name,
        CASE
            WHEN (b.table_sort_order IS NOT NULL) THEN b.table_sort_order
            ELSE c.table_sort_order
        END AS table_sort_order,
        CASE
            WHEN (b.column_sort_order IS NOT NULL) THEN b.column_sort_order
            ELSE c.column_sort_order
        END AS column_sort_order
   FROM ((( SELECT (lower((v_ust_element_mapping.organization_id)::text) || '_ust'::text) AS table_schema,
            v_ust_element_mapping.epa_table_name,
            v_ust_element_mapping.epa_column_name
           FROM v_ust_element_mapping
        UNION ALL
         SELECT (lower((v_release_element_mapping.organization_id)::text) || '_release'::text) AS table_schema,
            v_release_element_mapping.epa_table_name,
            v_release_element_mapping.epa_column_name
           FROM v_release_element_mapping) a
     LEFT JOIN v_ust_element_metadata b ON ((((a.epa_table_name)::text = (b.table_name)::text) AND ((a.epa_column_name)::text = (b.column_name)::text))))
     LEFT JOIN v_release_element_metadata c ON ((((a.epa_table_name)::text = (c.table_name)::text) AND ((a.epa_column_name)::text = (c.column_name)::text))));