create or replace view "ut_ust"."v_tank_material_description_xwalk" as
 SELECT a.organization_value,
    a.epa_value,
    b.tank_material_description_id
   FROM (v_ust_element_mapping a
     LEFT JOIN tank_material_descriptions b ON (((a.epa_value)::text = (b.tank_material_description)::text)))
  WHERE ((a.ust_control_id = 19) AND ((a.epa_column_name)::text = 'tank_material_description_id'::text));