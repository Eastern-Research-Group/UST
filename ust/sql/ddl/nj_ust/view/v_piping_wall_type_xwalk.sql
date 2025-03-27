create or replace view "nj_ust"."v_piping_wall_type_xwalk" as
 SELECT a.organization_value,
    a.epa_value,
    b.piping_wall_type_id
   FROM (v_ust_element_mapping a
     LEFT JOIN piping_wall_types b ON (((a.epa_value)::text = (b.piping_wall_type)::text)))
  WHERE ((a.ust_control_id = 36) AND ((a.epa_column_name)::text = 'piping_wall_type_id'::text));