create or replace view "public"."v_mapped_substances_detail" as
 SELECT DISTINCT x.organization_id,
    x.control_id,
    x.mapping_table,
    x.element_value_mapping_id,
    x.organization_value,
    x.epa_value
   FROM ( SELECT v_ust_element_mapping.organization_id,
            v_ust_element_mapping.ust_control_id AS control_id,
            'ust_element_value_mapping'::text AS mapping_table,
            v_ust_element_mapping.ust_element_value_mapping_id AS element_value_mapping_id,
            v_ust_element_mapping.organization_value,
            v_ust_element_mapping.epa_value
           FROM v_ust_element_mapping
          WHERE ((v_ust_element_mapping.epa_column_name)::text = 'substance_id'::text)
        UNION ALL
         SELECT v_release_element_mapping.organization_id,
            v_release_element_mapping.release_control_id AS control_id,
            'release_element_value_mapping'::text AS mapping_table,
            v_release_element_mapping.release_element_value_mapping_id AS element_value_mapping_id,
            v_release_element_mapping.organization_value,
            v_release_element_mapping.epa_value
           FROM v_release_element_mapping
          WHERE ((v_release_element_mapping.epa_column_name)::text = 'substance_id'::text)) x;