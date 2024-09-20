create or replace view "public"."v_ust_element_mapping_joins" as
 SELECT a.epa_table_name,
    a.epa_column_name,
    a.organization_table_name,
    a.organization_column_name,
    a.organization_join_table,
    a.organization_join_column,
    a.organization_join_fk,
    a.organization_join_column2,
    a.organization_join_fk2,
    a.organization_join_column3,
    a.organization_join_fk3,
    a.ust_element_mapping_id,
    a.ust_control_id,
    b.sort_order AS table_sort_order,
    d.sort_order AS column_sort_order
   FROM (((ust_element_mapping a
     LEFT JOIN ust_element_table_sort_order b ON (((a.epa_table_name)::text = (b.table_name)::text)))
     LEFT JOIN ust_elements c ON (((a.epa_column_name)::text = (c.database_column_name)::text)))
     LEFT JOIN ust_elements_tables d ON (((c.element_id = d.element_id) AND ((b.table_name)::text = (d.table_name)::text))));