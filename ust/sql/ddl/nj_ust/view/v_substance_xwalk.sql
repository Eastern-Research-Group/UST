create or replace view "nj_ust"."v_substance_xwalk" as
 SELECT a.organization_value,
    a.epa_value,
    b.substance_id
   FROM (v_ust_element_mapping a
     LEFT JOIN substances b ON (((a.epa_value)::text = (b.substance)::text)))
  WHERE ((a.ust_control_id = 36) AND ((a.epa_column_name)::text = 'substance_id'::text));