CREATE OR REPLACE VIEW public.v_release_element_summary_sql AS
 SELECT ((('insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (ZZ,'''::text || v_release_element_summary.mapping_table_name::text) || ''','''::text) || v_release_element_summary.mapping_column_name::text) || ''',''ORG_TAB_NAME'',''ORG_COL_NAME'',null);'::text AS sql_statement
   FROM v_release_element_summary;
