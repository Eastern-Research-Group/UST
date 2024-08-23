create or replace view "public"."v_ust_element_mapping_for_export" as
 SELECT d.template_tab_name AS table_name,
    b.element_name,
    a.organization_table_name,
    a.organization_column_name,
    a.programmer_comments,
    a.epa_comments,
    a.organization_comments,
    a.epa_table_name,
    a.epa_column_name,
    a.ust_element_mapping_id,
    a.ust_control_id,
    d.sort_order AS table_sort_order,
    c.sort_order AS column_sort_order
   FROM (((ust_element_mapping a
     LEFT JOIN ust_elements b ON (((a.epa_column_name)::text = (b.database_column_name)::text)))
     LEFT JOIN ust_elements_tables c ON (((b.element_id = c.element_id) AND ((a.epa_table_name)::text = (c.table_name)::text))))
     LEFT JOIN ust_template_data_tables d ON (((a.epa_table_name)::text = (d.table_name)::text)))
  ORDER BY a.ust_control_id, d.sort_order, c.sort_order;