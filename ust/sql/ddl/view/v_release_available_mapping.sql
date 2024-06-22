create or replace view "public"."v_release_available_mapping" as
 SELECT m.release_control_id,
    m.epa_table_name,
    m.epa_column_name,
    e.database_lookup_table,
    e.database_lookup_column
   FROM ((release_elements_tables t
     JOIN release_elements e ON ((t.element_id = e.element_id)))
     JOIN release_element_mapping m ON ((((m.epa_table_name)::text = (t.table_name)::text) AND ((m.epa_column_name)::text = (e.database_column_name)::text))))
  WHERE ((e.database_lookup_table IS NOT NULL) AND ((e.database_lookup_table)::text <> 'states'::text));