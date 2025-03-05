create or replace view "public"."v_base_release_element_mapping" as
 SELECT a.release_element_mapping_id,
    a.release_control_id,
    b.organization_id,
    a.mapping_date,
    a.epa_table_name,
    a.epa_column_name,
    a.organization_table_name,
    a.organization_column_name,
    a.organization_join_table,
    a.organization_join_column,
    a.programmer_comments,
    a.organization_comments,
    a.deagg_table_name,
    a.deagg_column_name,
    a.epa_comments,
    a.organization_join_fk,
    a.organization_join_column2,
    a.organization_join_column3,
    a.organization_join_fk2,
    a.organization_join_fk3,
    a.query_logic,
    a.inferred_value_comment,
    c.table_sort_order,
    c.column_sort_order
   FROM ((release_element_mapping a
     JOIN v_release_control b ON ((a.release_control_id = b.release_control_id)))
     LEFT JOIN v_release_element_metadata c ON ((((a.epa_table_name)::text = (c.table_name)::text) AND ((a.epa_column_name)::text = (c.column_name)::text))))
  ORDER BY b.organization_id, c.table_sort_order, c.column_sort_order;