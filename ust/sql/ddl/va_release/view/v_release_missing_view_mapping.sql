create or replace view "va_release"."v_release_missing_view_mapping" as
 SELECT a.release_element_mapping_id,
    a.release_control_id,
    a.mapping_date,
    a.epa_table_name,
    a.epa_column_name,
    a.organization_table_name,
    a.organization_column_name,
    a.organization_join_table,
    a.organization_join_column,
    a.programmer_comments,
    a.organization_comments,
    a.deagg_table_name,
    a.deagg_column_name
   FROM release_element_mapping a
  WHERE (NOT (EXISTS ( SELECT 1
           FROM information_schema.columns b
          WHERE ((('v_'::text || (a.epa_table_name)::text) = (b.table_name)::name) AND ((a.epa_column_name)::text = (b.column_name)::name)))));