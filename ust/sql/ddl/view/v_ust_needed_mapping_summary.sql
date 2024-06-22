create or replace view "public"."v_ust_needed_mapping_summary" as
 SELECT DISTINCT v_ust_needed_mapping.ust_control_id,
    v_ust_needed_mapping.ust_element_mapping_id,
    v_ust_needed_mapping.epa_table_name,
    v_ust_needed_mapping.epa_column_name,
        CASE
            WHEN (v_ust_needed_mapping.deagg_table_name IS NOT NULL) THEN v_ust_needed_mapping.deagg_table_name
            ELSE v_ust_needed_mapping.organization_table_name
        END AS org_tab_name,
        CASE
            WHEN (v_ust_needed_mapping.deagg_column_name IS NOT NULL) THEN v_ust_needed_mapping.deagg_column_name
            ELSE v_ust_needed_mapping.organization_column_name
        END AS org_col_name,
    v_ust_needed_mapping.mapping_complete
   FROM v_ust_needed_mapping;