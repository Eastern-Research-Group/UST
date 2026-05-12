create or replace view "wv_ust"."v_owner_type_xwalk" as
 SELECT a.organization_value,
    a.epa_value,
    b.owner_type_id
   FROM (v_ust_element_mapping a
     LEFT JOIN owner_types b ON (((a.epa_value)::text = (b.owner_type)::text)))
  WHERE ((a.ust_control_id = 11) AND ((a.epa_column_name)::text = 'owner_type_id'::text));