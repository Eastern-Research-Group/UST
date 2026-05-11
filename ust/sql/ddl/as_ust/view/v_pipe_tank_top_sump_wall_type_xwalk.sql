create or replace view "as_ust"."v_pipe_tank_top_sump_wall_type_xwalk" as
 SELECT a.organization_value,
    a.epa_value,
    b.pipe_tank_top_sump_wall_type_id
   FROM (v_ust_element_mapping a
     LEFT JOIN pipe_tank_top_sump_wall_types b ON (((a.epa_value)::text = (b.pipe_tank_top_sump_wall_type)::text)))
  WHERE ((a.ust_control_id = 34) AND ((a.epa_column_name)::text = 'pipe_tank_top_sump_wall_type_id'::text));