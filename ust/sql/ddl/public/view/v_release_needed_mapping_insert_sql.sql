create or replace view "public"."v_release_needed_mapping_insert_sql" as
 SELECT DISTINCT a.release_control_id,
    a.epa_table_name,
    a.epa_column_name,
    a.mapping_complete,
    (((((((('select distinct 
	''insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments) values ('' || '::text || a.release_element_mapping_id) || ' || '', '''''' || "'::text) || (a.org_col_name)::text) || '" || '''''', '''''''', null);''
from '::text) || lower((b.organization_id)::text)) || '_release."'::text) || (a.org_tab_name)::text) || '" order by 1;'::text) AS insert_sql
   FROM (v_release_needed_mapping_summary a
     JOIN release_control b ON ((a.release_control_id = b.release_control_id)));