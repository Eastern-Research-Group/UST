create or replace view "public"."v_ust_table_population" as
 SELECT x.ust_control_id,
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
    x.database_lookup_table,
    x.database_lookup_column,
    x.deagg_table_name,
    x.deagg_column_name,
    x.table_sort_order,
    x.column_sort_order
   FROM ( SELECT a.ust_control_id,
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
            b.database_lookup_table,
            b.database_lookup_column,
            a.deagg_table_name,
            a.deagg_column_name,
            d.sort_order AS table_sort_order,
            c.sort_order AS column_sort_order
           FROM ((((ust_element_mapping a
             JOIN ust_elements b ON (((a.epa_column_name)::text = (b.database_column_name)::text)))
             JOIN ust_elements_tables c ON (((b.element_id = c.element_id) AND ((a.epa_table_name)::text = (c.table_name)::text))))
             JOIN ust_template_data_tables d ON (((c.table_name)::text = (d.table_name)::text)))
             JOIN information_schema.columns e ON ((((a.epa_table_name)::text = (e.table_name)::name) AND ((a.epa_column_name)::text = (e.column_name)::name) AND ((e.table_schema)::name = 'public'::name))))
        UNION ALL
         SELECT a.ust_control_id,
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
            b.database_lookup_table,
            b.database_lookup_column,
            a.deagg_table_name,
            a.deagg_column_name,
            d.sort_order AS table_sort_order,
            c.sort_order AS column_sort_order
           FROM ((((ust_element_mapping a
             JOIN ust_elements b ON (((a.epa_column_name)::text = (b.database_column_name)::text)))
             JOIN ust_elements_tables c ON (((b.element_id = c.element_id) AND ((a.epa_table_name)::text = (c.table_name)::text))))
             JOIN ust_template_data_tables d ON (((c.table_name)::text = (d.table_name)::text)))
             JOIN information_schema.columns e ON ((((a.epa_table_name)::text = (e.table_name)::name) AND ((a.epa_column_name)::text = (e.column_name)::name) AND ((e.table_schema)::name = 'public'::name)))),
            ( SELECT 'ust_tank'::character varying(100) AS epa_table_name
                UNION ALL
                 SELECT 'ust_tank_substance'::character varying(100) AS epa_table_name
                UNION ALL
                 SELECT 'ust_compartment'::character varying(100) AS epa_table_name
                UNION ALL
                 SELECT 'ust_compartment_substance'::character varying(100) AS epa_table_name
                UNION ALL
                 SELECT 'ust_piping'::character varying(100) AS epa_table_name
                UNION ALL
                 SELECT 'ust_facility_dispenser'::character varying(100) AS epa_table_name
                UNION ALL
                 SELECT 'ust_tank_dispenser'::character varying(100) AS epa_table_name
                UNION ALL
                 SELECT 'ust_compartment_dispenser'::character varying(100) AS epa_table_name) z
          WHERE ((a.epa_column_name)::text = 'ust_id'::text)) x
  ORDER BY x.ust_control_id, x.epa_table_name, x.table_sort_order, x.column_sort_order;