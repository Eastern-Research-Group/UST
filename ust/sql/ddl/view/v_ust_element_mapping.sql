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
    b.ust_element_value_mapping_id,
    a.organization_join_column2,
    a.organization_join_column3,
    a.organization_join_fk,
    a.organization_join_fk2,
    a.organization_join_fk3,
    d.table_sort_order,
    d.column_sort_order,
    a.query_logic
   FROM (((ust_element_mapping a
     LEFT JOIN ust_element_value_mapping b ON ((a.ust_element_mapping_id = b.ust_element_mapping_id)))
     JOIN ust_control c ON ((a.ust_control_id = c.ust_control_id)))
     LEFT JOIN v_ust_element_metadata d ON ((((a.epa_table_name)::text = (d.table_name)::text) AND ((a.epa_column_name)::text = (d.column_name)::text))));