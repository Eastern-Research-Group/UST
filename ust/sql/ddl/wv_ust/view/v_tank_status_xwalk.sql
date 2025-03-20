create or replace view "wv_ust"."v_tank_status_xwalk" as
 SELECT a.organization_value,
    a.epa_value,
    b.tank_status_id
   FROM (v_ust_element_mapping a
     LEFT JOIN tank_statuses b ON (((a.epa_value)::text = (b.tank_status)::text)))
  WHERE ((a.ust_control_id = 11) AND ((a.epa_column_name)::text = 'tank_status_id'::text));