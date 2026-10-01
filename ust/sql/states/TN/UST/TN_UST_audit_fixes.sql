-- VALUE MAPPING FIXES

select * from v_ust_mapping 
where ust_control_id = 35 
and epa_column_name = 'tank_status_id'

select * from v_ust_mapping 
where ust_control_id = 35 
and epa_column_name = 'compartment_status_id'


-- ust_compartment.compartment_status_id: unmapped value 'Permanently Out of Use - Removed from Ground' from tn_ust.v_compartment_status."Status"
-- Choose exactly one statement below, uncomment it, and replace the angle-bracket text.
-- MAP
 insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
 values (2985, 'Permanently Out of Use - Removed from Ground', 'Closed (removed from ground)', 'MAP', null, null);
-- EXCLUDE
-- insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (2985, 'Permanently Out of Use - Removed from Ground', null, 'EXCLUDE', 'Y', '<why source rows are excluded>');
-- INTENTIONALLY_NULL
-- insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (2985, 'Permanently Out of Use - Removed from Ground', null, 'INTENTIONALLY_NULL', null, '<why EPA value is intentionally null>');

select * from v_ust_mapping 
where ust_control_id = 35 
and epa_column_name = 'spill_bucket_wall_type_id'



-- ust_compartment.spill_bucket_wall_type_id: unmapped value 'Spill Bucket' from tn_ust.tn_compartments_merged."Spill Prevention"
-- Choose exactly one statement below, uncomment it, and replace the angle-bracket text.
-- MAP
-- insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (2995, 'Spill Bucket', '<VALID EPA VALUE>', 'MAP', null, null);
-- EXCLUDE
-- insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (2995, 'Spill Bucket', null, 'EXCLUDE', 'Y', '<why source rows are excluded>');
-- INTENTIONALLY_NULL
 insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
 values (2995, 'Spill Bucket', null, 'INTENTIONALLY_NULL', null, 'n/a');

select * from substances;

-- ust_compartment_substance.substance_id: unmapped value 'Hazardous Substance' from tn_ust.tn_compartments_merged."Product"
-- Choose exactly one statement below, uncomment it, and replace the angle-bracket text.
-- MAP
 insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
 values (3010, 'Hazardous Substance', 'Hazardous substance', 'MAP', null, null);
-- EXCLUDE
-- insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (3010, 'Hazardous Substance', null, 'EXCLUDE', 'Y', '<why source rows are excluded>');
-- INTENTIONALLY_NULL
-- insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (3010, 'Hazardous Substance', null, 'INTENTIONALLY_NULL', null, '<why EPA value is intentionally null>');

