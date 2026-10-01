CREATE OR REPLACE VIEW public.v_ust_sort_order AS
 SELECT a.table_name,
    a.view_name,
    a.template_tab_name,
    a.sort_order AS table_sort_order,
    c.database_column_name AS column_name,
    b.sort_order AS column_sort_order
   FROM ust_template_data_tables a
     JOIN ust_elements_tables b ON a.table_name::text = b.table_name::text
     JOIN ust_elements c ON b.element_id = c.element_id;
