create or replace view "public"."v_cp_inferred" as
 SELECT ust_element_mapping.ust_control_id,
    'tank'::text AS cp_type
   FROM ust_element_mapping
  WHERE (((ust_element_mapping.epa_column_name)::text = 'tank_corrosion_protection_sacrificial_anode'::text) AND (ust_element_mapping.inferred_value_comment IS NOT NULL))
UNION ALL
 SELECT ust_element_mapping.ust_control_id,
    'piping'::text AS cp_type
   FROM ust_element_mapping
  WHERE (((ust_element_mapping.epa_column_name)::text = 'piping_corrosion_protection_sacrificial_anode'::text) AND (ust_element_mapping.inferred_value_comment IS NOT NULL));