create or replace view "public"."v_release_used_source_tables" as
 SELECT DISTINCT a.release_control_id,
    a.table_name
   FROM ( SELECT release_element_mapping.release_control_id,
            release_element_mapping.organization_table_name AS table_name
           FROM release_element_mapping
        UNION ALL
         SELECT release_element_mapping.release_control_id,
            release_element_mapping.organization_join_table
           FROM release_element_mapping
        UNION ALL
         SELECT release_element_mapping.release_control_id,
            release_element_mapping.deagg_table_name
           FROM release_element_mapping) a
  WHERE (a.table_name IS NOT NULL);