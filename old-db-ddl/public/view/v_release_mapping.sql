CREATE OR REPLACE VIEW public.v_release_mapping AS
 SELECT v_release_element_mapping.epa_table_name,
    v_release_element_mapping.epa_column_name,
    v_release_element_mapping.organization_table_name,
    v_release_element_mapping.organization_column_name,
    v_release_element_mapping.organization_value,
    v_release_element_mapping.epa_value,
    v_release_element_mapping.query_logic,
    v_release_element_mapping.programmer_comments,
    v_release_element_mapping.release_element_mapping_id,
    v_release_element_mapping.release_element_value_mapping_id,
    v_release_element_mapping.release_control_id,
    v_release_element_mapping.organization_id
   FROM v_release_element_mapping;
