create or replace view "public"."v_release_needed_mapping_summary" as
 SELECT DISTINCT v_release_needed_mapping.release_control_id,
    v_release_needed_mapping.release_element_mapping_id,
    v_release_needed_mapping.epa_table_name,
    v_release_needed_mapping.epa_column_name,
        CASE
            WHEN (v_release_needed_mapping.deagg_table_name IS NOT NULL) THEN v_release_needed_mapping.deagg_table_name
            ELSE v_release_needed_mapping.organization_table_name
        END AS org_tab_name,
        CASE
            WHEN (v_release_needed_mapping.deagg_column_name IS NOT NULL) THEN v_release_needed_mapping.deagg_column_name
            ELSE v_release_needed_mapping.organization_column_name
        END AS org_col_name,
    v_release_needed_mapping.mapping_complete
   FROM v_release_needed_mapping;