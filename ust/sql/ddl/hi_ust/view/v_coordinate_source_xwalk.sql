create or replace view "hi_ust"."v_coordinate_source_xwalk" as
 SELECT a.organization_value,
    a.epa_value,
    b.coordinate_source_id
   FROM (v_ust_element_mapping a
     LEFT JOIN coordinate_sources b ON (((a.epa_value)::text = (b.coordinate_source)::text)))
  WHERE ((a.ust_control_id = 24) AND ((a.epa_column_name)::text = 'coordinate_source_id'::text));