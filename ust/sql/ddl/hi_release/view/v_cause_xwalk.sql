create or replace view "hi_release"."v_cause_xwalk" as
 SELECT a.organization_value,
    a.epa_value,
    b.cause_id
   FROM (v_release_element_mapping a
     LEFT JOIN causes b ON (((a.epa_value)::text = (b.cause)::text)))
  WHERE ((a.release_control_id = 14) AND ((a.epa_column_name)::text = 'cause_id'::text));