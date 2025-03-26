CREATE OR REPLACE VIEW ia_release.v_substance_released_xwalk
AS SELECT a.organization_value,
    a.epa_value,
    b.substance_id
   FROM v_release_element_mapping a
     LEFT JOIN substances b ON a.epa_value::text = b.substance::text
  WHERE a.release_control_id = 16 AND a.epa_column_name::text = 'substance_id'::text;
  
