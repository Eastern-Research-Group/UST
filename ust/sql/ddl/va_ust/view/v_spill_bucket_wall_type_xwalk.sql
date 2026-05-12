create or replace view "va_ust"."v_spill_bucket_wall_type_xwalk" as
 SELECT a.organization_value,
    a.epa_value,
    b.spill_bucket_wall_type_id
   FROM (v_ust_element_mapping a
     LEFT JOIN spill_bucket_wall_types b ON (((a.epa_value)::text = (b.spill_bucket_wall_type)::text)))
  WHERE ((a.ust_control_id = 8) AND ((a.epa_column_name)::text = 'spill_bucket_wall_type_id'::text));