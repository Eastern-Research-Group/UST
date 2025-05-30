create or replace view "public"."v_ust_table_population_sql" as
 SELECT v_ust_table_population.ust_control_id,
    v_ust_table_population.epa_table_name,
    v_ust_table_population.epa_column_name,
    v_ust_table_population.query_logic,
    v_ust_table_population.programmer_comments,
    v_ust_table_population.data_type,
    v_ust_table_population.character_maximum_length,
    v_ust_table_population.organization_table_name,
    v_ust_table_population.organization_column_name,
    (('"'::text || (v_ust_table_population.organization_table_name)::text) || '"'::text) AS organization_table_name_qtd,
    (('"'::text || (v_ust_table_population.organization_column_name)::text) || '"'::text) AS organization_column_name_qtd,
        CASE
            WHEN (v_ust_table_population.database_lookup_column IS NOT NULL) THEN ((((v_ust_table_population.epa_column_name)::text || ' as '::text) || (v_ust_table_population.epa_column_name)::text) || ','::text)
            ELSE (((((('"'::text || (v_ust_table_population.organization_column_name)::text) || '"'::text) || v_ust_table_population.data_type_complete) || ' as '::text) || (v_ust_table_population.epa_column_name)::text) || ','::text)
        END AS selected_column,
    v_ust_table_population.organization_join_table,
    v_ust_table_population.organization_join_column,
    v_ust_table_population.organization_join_fk,
    v_ust_table_population.organization_join_column2,
    v_ust_table_population.organization_join_fk2,
    v_ust_table_population.organization_join_column3,
    v_ust_table_population.organization_join_fk3,
    (('"'::text || (v_ust_table_population.organization_join_table)::text) || '"'::text) AS organization_join_table_qtd,
    (('"'::text || (v_ust_table_population.organization_join_column)::text) || '"'::text) AS organization_join_column_qtd,
    (('"'::text || (v_ust_table_population.organization_join_fk)::text) || '"'::text) AS organization_join_fk_qtd,
    (('"'::text || (v_ust_table_population.organization_join_column2)::text) || '"'::text) AS organization_join_column_qtd2,
    (('"'::text || (v_ust_table_population.organization_join_fk2)::text) || '"'::text) AS organization_join_fk_qtd2,
    (('"'::text || (v_ust_table_population.organization_join_column3)::text) || '"'::text) AS organization_join_column_qtd3,
    (('"'::text || (v_ust_table_population.organization_join_fk3)::text) || '"'::text) AS organization_join_fk_qtd3,
    v_ust_table_population.database_lookup_table,
    v_ust_table_population.database_lookup_column,
    v_ust_table_population.deagg_table_name,
    v_ust_table_population.deagg_column_name,
    v_ust_table_population.table_sort_order,
    v_ust_table_population.column_sort_order,
    v_ust_table_population.primary_key
   FROM v_ust_table_population;