create or replace view "public"."v_ust_element_mapping" as
 SELECT c.organization_id,
    a.epa_table_name,
    a.epa_column_name,
    a.organization_table_name,
    a.organization_column_name,
    a.organization_join_table,
    a.organization_join_column,
    b.organization_value,
    b.epa_value,
    b.exclude_from_query,
    b.programmer_comments,
    b.epa_comments,
    b.organization_comments,
    c.ust_control_id,
    a.ust_element_mapping_id,
    b.ust_element_value_mapping_id
   FROM ((ust_element_mapping a
     LEFT JOIN ust_element_value_mapping b ON ((a.ust_element_mapping_id = b.ust_element_mapping_id)))
     JOIN ust_control c ON ((a.ust_control_id = c.ust_control_id)));