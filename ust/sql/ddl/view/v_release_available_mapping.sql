create or replace view "public"."v_release_available_mapping" as
 SELECT m.release_control_id,
    m.epa_table_name,
    m.epa_column_name,
    e.database_lookup_table,
    e.database_lookup_column,
    s.sort_order AS table_sort_order,
    t.sort_order AS column_sort_order
   FROM (((release_elements_tables t
     JOIN release_elements e ON ((t.element_id = e.element_id)))
     JOIN release_element_mapping m ON ((((m.epa_table_name)::text = (t.table_name)::text) AND ((m.epa_column_name)::text = (e.database_column_name)::text))))
     JOIN release_element_table_sort_order s ON (((t.table_name)::text = (s.table_name)::text)))
  WHERE ((e.database_lookup_table IS NOT NULL) AND ((e.database_lookup_table)::text <> 'states'::text));