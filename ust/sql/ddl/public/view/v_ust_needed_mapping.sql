create or replace view "public"."v_ust_needed_mapping" as
 SELECT DISTINCT a.ust_control_id,
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
        END AS mapping_complete,
    tso.sort_order AS table_sort_order,
    eso.sort_order AS column_sort_order
   FROM ((((((v_ust_element_mapping a
     JOIN ust_element_mapping b ON (((a.ust_control_id = b.ust_control_id) AND ((a.epa_table_name)::text = (b.epa_table_name)::text) AND ((a.epa_column_name)::text = (b.epa_column_name)::text) AND ((a.organization_table_name)::text = (b.organization_table_name)::text) AND ((a.organization_column_name)::text = (b.organization_column_name)::text))))
     LEFT JOIN ust_elements c ON (((a.epa_column_name)::text = (c.database_column_name)::text)))
     LEFT JOIN ( SELECT DISTINCT ust_element_value_mapping.ust_element_mapping_id
           FROM ust_element_value_mapping) d ON ((b.ust_element_mapping_id = d.ust_element_mapping_id)))
     JOIN ust_element_table_sort_order tso ON (((a.epa_table_name)::text = (tso.table_name)::text)))
     JOIN ust_elements e ON (((a.epa_column_name)::text = (e.database_column_name)::text)))
     JOIN ust_elements_tables eso ON (((e.element_id = eso.element_id) AND ((a.epa_table_name)::text = (eso.table_name)::text))))
  WHERE (c.database_lookup_table IS NOT NULL);