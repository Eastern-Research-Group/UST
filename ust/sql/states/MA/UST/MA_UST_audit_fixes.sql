-- VALUE MAPPING FIXES

-- ust_tank.tank_secondary_containment_id: unmapped value 'Concrete (cathodic protection not required)' from ma_ust."Tank info"."TANK CONSTRUCT"
-- Choose exactly one statement below, uncomment it, and replace the angle-bracket text.
-- MAP
 insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
 values (4191, 'Concrete (cathodic protection not required)', '<VALID EPA VALUE>', 'MAP', null, null);
-- EXCLUDE
 insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
 values (4191, 'Concrete (cathodic protection not required)', null, 'EXCLUDE', 'Y', '<why source rows are excluded>');
 --INTENTIONALLY_NULL
 insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
 values (4191, 'Concrete (cathodic protection not required)', null, 'INTENTIONALLY_NULL', null, 'Per OUST: Note, only tracking CP for metallic tanks so CP not required should not be mapped');





-- ust_tank_substance.substance_id: unmapped value 'Unregulated Content' from ma_ust."Tank info"."CONTENT"
-- Choose exactly one statement below, uncomment it, and replace the angle-bracket text.
-- MAP
 insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
 values (4194, 'Unregulated Content', '<VALID EPA VALUE>', 'MAP', null, null);
 --EXCLUDE
 insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
 values (4194, 'Unregulated Content', null, 'EXCLUDE', 'Y', 'Unregulated substance');
 --INTENTIONALLY_NULL
 insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
 values (4194, 'Unregulated Content', null, 'INTENTIONALLY_NULL', null, '<why EPA value is intentionally null>');

select * from ma_ust.erg_unregulated_tanks


with reason "Non-regulated substance"