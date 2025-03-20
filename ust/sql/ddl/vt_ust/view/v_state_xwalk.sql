create or replace view "vt_ust"."v_state_xwalk" as
 SELECT a.organization_value,
    a.epa_value,
    b.facility_state
   FROM (v_ust_element_mapping a
     LEFT JOIN states b ON (((a.epa_value)::text = (b.state)::text)))
  WHERE ((a.ust_control_id = 26) AND ((a.epa_column_name)::text = 'facility_state'::text));