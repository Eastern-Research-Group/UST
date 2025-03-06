create or replace view "hi_ust"."v_tank_secondary_containment_xwalk" as
 SELECT a.organization_value,
    a.epa_value,
    b.tank_secondary_containment_id
   FROM (v_ust_element_mapping a
     LEFT JOIN tank_secondary_containments b ON (((a.epa_value)::text = (b.tank_secondary_containment)::text)))
  WHERE ((a.ust_control_id = 24) AND ((a.epa_column_name)::text = 'tank_secondary_containment_id'::text));