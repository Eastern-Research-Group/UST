create or replace view "public"."v_cui_data_elements" as
 SELECT (lower((b.organization_id)::text) || '_ust'::text) AS table_schema,
    a.organization_table_name,
    a.organization_column_name,
    a.ust_control_id AS control_id,
    b.organization_id,
    'ust'::text AS ust_or_release
   FROM (ust_element_mapping a
     JOIN ust_control b ON ((a.ust_control_id = b.ust_control_id)))
  WHERE (((a.epa_table_name)::text = 'ust_facility'::text) AND ((a.epa_column_name)::text = 'facility_name'::text))
UNION ALL
 SELECT (lower((b.organization_id)::text) || '_release'::text) AS table_schema,
    a.organization_table_name,
    a.organization_column_name,
    a.release_control_id AS control_id,
    b.organization_id,
    'release'::text AS ust_or_release
   FROM (release_element_mapping a
     JOIN release_control b ON ((a.release_control_id = b.release_control_id)))
  WHERE (((a.epa_table_name)::text = 'ust_release'::text) AND ((a.epa_column_name)::text = 'site_name'::text));