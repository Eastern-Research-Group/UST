create or replace view "public"."v_ust_available_mapping" as
 SELECT m.ust_control_id,
    m.epa_table_name,
    m.epa_column_name,
    e.database_lookup_table,
    e.database_lookup_column
   FROM ((ust_elements_tables t
     JOIN ust_elements e ON ((t.element_id = e.element_id)))
     JOIN ust_element_mapping m ON ((((m.epa_table_name)::text = (t.table_name)::text) AND ((m.epa_column_name)::text = (e.database_column_name)::text))))
  WHERE ((e.database_lookup_table IS NOT NULL) AND ((e.database_lookup_table)::text <> 'states'::text));