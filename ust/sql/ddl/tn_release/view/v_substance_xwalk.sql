create or replace view "tn_release"."v_substance_xwalk" as
 SELECT DISTINCT a.organization_value,
    a.epa_value,
    b.substance_id
   FROM (v_release_element_mapping a
     LEFT JOIN substances b ON (((a.epa_value)::text = (b.substance)::text)))
  WHERE ((a.release_control_id = 5) AND ((a.epa_column_name)::text = 'substance_id'::text));