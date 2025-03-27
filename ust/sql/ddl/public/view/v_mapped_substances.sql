create or replace view "public"."v_mapped_substances" as
 SELECT DISTINCT x.organization_value,
    x.epa_value
   FROM ( SELECT v_ust_element_mapping.organization_value,
            v_ust_element_mapping.epa_value
           FROM v_ust_element_mapping
          WHERE ((v_ust_element_mapping.epa_column_name)::text = 'substance_id'::text)
        UNION ALL
         SELECT v_release_element_mapping.organization_value,
            v_release_element_mapping.epa_value
           FROM v_release_element_mapping
          WHERE ((v_release_element_mapping.epa_column_name)::text = 'substance_id'::text)) x;