create or replace view "public"."v_base_release_element_value_mapping" as
 SELECT DISTINCT a.release_element_value_mapping_id,
    a.release_element_mapping_id,
    b.release_control_id,
    c.organization_id,
    b.epa_table_name,
    b.epa_column_name,
    a.organization_value,
    a.epa_value,
    a.programmer_comments,
    a.epa_comments,
    a.organization_comments,
    a.exclude_from_query,
    d.table_sort_order,
    d.column_sort_order
   FROM (((release_element_value_mapping a
     JOIN release_element_mapping b ON ((a.release_element_mapping_id = b.release_element_mapping_id)))
     JOIN v_release_control c ON ((b.release_control_id = c.release_control_id)))
     LEFT JOIN v_release_element_metadata d ON ((((b.epa_table_name)::text = (d.table_name)::text) AND ((b.epa_column_name)::text = (d.column_name)::text))))
  ORDER BY c.organization_id, d.table_sort_order, d.column_sort_order;