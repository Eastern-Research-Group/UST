CREATE OR REPLACE VIEW public.v_ust_condensed_mapping AS
 SELECT DISTINCT v_ust_element_mapping.epa_table_name,
    v_ust_element_mapping.epa_column_name,
    v_ust_element_mapping.organization_table_name,
    v_ust_element_mapping.organization_column_name,
    v_ust_element_mapping.query_logic,
    v_ust_element_mapping.programmer_comments,
    v_ust_element_mapping.ust_element_mapping_id,
    v_ust_element_mapping.ust_control_id,
    v_ust_element_mapping.organization_id,
    v_ust_element_mapping.column_sort_order
   FROM v_ust_element_mapping;
