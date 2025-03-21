create or replace view "il_ust"."v_tank_location_xwalk" as
 SELECT a.organization_value,
    a.epa_value,
    b.tank_location_id
   FROM (v_ust_element_mapping a
     LEFT JOIN tank_locations b ON (((a.epa_value)::text = (b.tank_location)::text)))
  WHERE ((a.ust_control_id = 27) AND ((a.epa_column_name)::text = 'tank_location_id'::text));