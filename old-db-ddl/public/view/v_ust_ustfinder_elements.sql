CREATE OR REPLACE VIEW public.v_ust_ustfinder_elements AS
 SELECT b.table_name,
    a.element_name,
    a.database_column_name,
    c.geo_export_sort_order AS table_sort_order,
    b.sort_order AS column_sort_order
   FROM ust_elements a
     JOIN ust_elements_tables b ON a.element_id = b.element_id
     JOIN ust_element_table_sort_order c ON b.table_name::text = c.table_name::text
  WHERE a.displayed_in_ustfinder::text = 'Y'::text
  ORDER BY c.geo_export_sort_order, b.sort_order;
