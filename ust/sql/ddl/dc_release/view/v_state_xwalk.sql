create or replace view "dc_release"."v_state_xwalk" as
 SELECT a.organization_value,
    a.epa_value,
    b.state
   FROM (v_release_element_mapping a
     LEFT JOIN states b ON (((a.epa_value)::text = (b.state)::text)))
  WHERE ((a.release_control_id = 18) AND ((a.epa_column_name)::text = 'state'::text));