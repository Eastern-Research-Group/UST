create or replace view "public"."v_ust_element_metadata" as
 SELECT b.table_name,
    a.database_column_name AS column_name,
    a.element_description,
    a.element_type,
    a.element_size,
    a.required,
    a.business_rule,
    a.database_lookup_table,
    a.element_name,
    c.sort_order AS table_sort_order,
    b.sort_order AS column_sort_order,
    a.in_use
   FROM ((ust_elements a
     JOIN ust_elements_tables b ON ((a.element_id = b.element_id)))
     JOIN ust_template_data_tables c ON (((b.table_name)::text = (c.table_name)::text)))
  ORDER BY c.sort_order, b.sort_order;