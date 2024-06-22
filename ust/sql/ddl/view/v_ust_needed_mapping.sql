create or replace view "public"."v_ust_needed_mapping" as
 SELECT a.ust_control_id,
    b.ust_element_mapping_id,
    a.epa_table_name,
    a.epa_column_name,
    a.organization_table_name,
    a.organization_column_name,
    b.programmer_comments,
    c.database_lookup_table,
    c.database_lookup_column,
    b.deagg_table_name,
    b.deagg_column_name,
        CASE
            WHEN (d.ust_element_mapping_id IS NULL) THEN 'N'::text
            ELSE 'Y'::text
        END AS mapping_complete
   FROM (((v_ust_element_mapping a
     JOIN ust_element_mapping b ON (((a.ust_control_id = b.ust_control_id) AND ((a.epa_table_name)::text = (b.epa_table_name)::text) AND ((a.epa_column_name)::text = (b.epa_column_name)::text))))
     LEFT JOIN ust_elements c ON (((a.epa_column_name)::text = (c.database_column_name)::text)))
     LEFT JOIN ( SELECT DISTINCT ust_element_value_mapping.ust_element_mapping_id
           FROM ust_element_value_mapping) d ON ((b.ust_element_mapping_id = d.ust_element_mapping_id)))
  WHERE (c.database_lookup_table IS NOT NULL);