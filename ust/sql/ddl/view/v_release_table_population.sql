create or replace view "public"."v_release_table_population" as
 SELECT x.release_control_id,
    x.epa_table_name,
    x.epa_column_name,
    x.data_type,
    x.character_maximum_length,
    x.data_type_complete,
    x.organization_table_name,
    x.organization_column_name,
    x.programmer_comments,
    x.organization_join_table,
    x.organization_join_column,
    x.organization_join_fk,
    x.database_lookup_table,
    x.database_lookup_column,
    x.deagg_table_name,
    x.deagg_column_name,
    x.table_sort_order,
    x.column_sort_order,
    x.primary_key,
    x.organization_join_column2,
    x.organization_join_fk2,
    x.organization_join_column3,
    x.organization_join_fk3
   FROM ( SELECT a.release_control_id,
            a.epa_table_name,
            a.epa_column_name,
            e.data_type,
            e.character_maximum_length,
                CASE
                    WHEN (e.character_maximum_length IS NOT NULL) THEN (((('::'::text || (e.data_type)::text) || '('::text) || e.character_maximum_length) || ')'::text)
                    ELSE ('::'::text || (e.data_type)::text)
                END AS data_type_complete,
            a.organization_table_name,
            a.organization_column_name,
            a.programmer_comments,
            a.organization_join_table,
            a.organization_join_column,
            a.organization_join_fk,
            b.database_lookup_table,
            b.database_lookup_column,
            a.deagg_table_name,
            a.deagg_column_name,
            d.sort_order AS table_sort_order,
            c.sort_order AS column_sort_order,
            c.primary_key,
            a.organization_join_column2,
            a.organization_join_fk2,
            a.organization_join_column3,
            a.organization_join_fk3
           FROM ((((release_element_mapping a
             JOIN release_elements b ON (((a.epa_column_name)::text = (b.database_column_name)::text)))
             JOIN release_elements_tables c ON (((b.element_id = c.element_id) AND ((a.epa_table_name)::text = (c.table_name)::text))))
             JOIN release_template_data_tables d ON (((c.table_name)::text = (d.table_name)::text)))
             JOIN information_schema.columns e ON ((((a.epa_table_name)::text = (e.table_name)::name) AND ((a.epa_column_name)::text = (e.column_name)::name) AND ((e.table_schema)::name = 'public'::name))))
        UNION ALL
         SELECT a.release_control_id,
            z.epa_table_name,
            a.epa_column_name,
            e.data_type,
            e.character_maximum_length,
                CASE
                    WHEN (e.character_maximum_length IS NOT NULL) THEN (((('::'::text || (e.data_type)::text) || '('::text) || e.character_maximum_length) || ')'::text)
                    ELSE ('::'::text || (e.data_type)::text)
                END AS data_type_complete,
            a.organization_table_name,
            a.organization_column_name,
            a.programmer_comments,
            a.organization_join_table,
            a.organization_join_column,
            a.organization_join_fk,
            b.database_lookup_table,
            b.database_lookup_column,
            a.deagg_table_name,
            a.deagg_column_name,
            d.sort_order AS table_sort_order,
            c.sort_order AS column_sort_order,
            c.primary_key,
            a.organization_join_column2,
            a.organization_join_fk2,
            a.organization_join_column3,
            a.organization_join_fk3
           FROM ((((release_element_mapping a
             JOIN release_elements b ON (((a.epa_column_name)::text = (b.database_column_name)::text)))
             JOIN release_elements_tables c ON (((b.element_id = c.element_id) AND ((a.epa_table_name)::text = (c.table_name)::text))))
             JOIN release_template_data_tables d ON (((c.table_name)::text = (d.table_name)::text)))
             JOIN information_schema.columns e ON ((((a.epa_table_name)::text = (e.table_name)::name) AND ((a.epa_column_name)::text = (e.column_name)::name) AND ((e.table_schema)::name = 'public'::name)))),
            ( SELECT 'ust_release_substance'::character varying(100) AS epa_table_name
                UNION ALL
                 SELECT 'ust_release_source'::character varying(100) AS "varchar"
                UNION ALL
                 SELECT 'ust_release_cause'::character varying(100) AS "varchar"
                UNION ALL
                 SELECT 'ust_release_corrective_action_strategy'::character varying(100) AS "varchar") z
          WHERE ((a.epa_column_name)::text = 'release_id'::text)) x
  ORDER BY x.release_control_id, x.epa_table_name, x.table_sort_order, x.column_sort_order;