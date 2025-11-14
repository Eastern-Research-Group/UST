create or replace view "public"."v_ust_tank_secondary_containment_mapping" as
 SELECT b.organization_value,
    b.epa_value,
    b.programmer_comments,
    b.epa_comments,
    b.organization_comments,
    a.ust_control_id
   FROM (ust_element_mapping a
     JOIN ust_element_value_mapping b ON ((a.ust_element_mapping_id = b.ust_element_mapping_id)))
  WHERE ((a.epa_column_name)::text ~~ 'tank_secondary_containment%'::text);