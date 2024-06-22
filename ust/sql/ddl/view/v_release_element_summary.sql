create or replace view "public"."v_release_element_summary" as
 SELECT b.table_name AS mapping_table_name,
    a.database_column_name AS mapping_column_name
   FROM ((release_elements a
     JOIN release_elements_tables b ON ((a.element_id = b.element_id)))
     JOIN release_template_data_tables c ON (((b.table_name)::text = (c.table_name)::text)))
  ORDER BY c.sort_order, b.sort_order;