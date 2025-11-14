create or replace view "de_release"."v_source_xwalk" as
 SELECT a.organization_value,
    a.epa_value,
    b.source_id
   FROM (v_release_element_mapping a
     LEFT JOIN sources b ON (((a.epa_value)::text = (b.source)::text)))
  WHERE ((a.release_control_id = 20) AND ((a.epa_column_name)::text = 'source_id'::text));