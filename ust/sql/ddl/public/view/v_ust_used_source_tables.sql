create or replace view "public"."v_ust_used_source_tables" as
 SELECT DISTINCT a.ust_control_id,
    a.table_name
   FROM ( SELECT ust_element_mapping.ust_control_id,
            ust_element_mapping.organization_table_name AS table_name
           FROM ust_element_mapping
        UNION ALL
         SELECT ust_element_mapping.ust_control_id,
            ust_element_mapping.organization_join_table
           FROM ust_element_mapping
        UNION ALL
         SELECT ust_element_mapping.ust_control_id,
            ust_element_mapping.deagg_table_name
           FROM ust_element_mapping) a
  WHERE (a.table_name IS NOT NULL);