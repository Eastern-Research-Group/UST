create or replace view "pa_release"."v_how_release_detected_xwalk" as
 SELECT a.organization_value,
    a.epa_value,
    b.how_release_detected_id
   FROM (v_release_element_mapping a
     LEFT JOIN how_release_detected b ON (((a.epa_value)::text = (b.how_release_detected)::text)))
  WHERE ((a.release_control_id = 2) AND ((a.epa_column_name)::text = 'how_release_detected_id'::text));