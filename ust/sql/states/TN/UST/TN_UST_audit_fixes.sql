-- SOURCE IDENTIFIER FIXES

-- ust_compartment.facility_id: unknown organization source column tn_ust.v_tn_compartments."Facility Id US"
-- Perhaps you meant: "Facility Id Ust"
update public.ust_element_mapping
set organization_column_name = '<Facility Id Ust'
where ust_element_mapping_id = 2980;

select * from ust_element_mapping where ust_element_mapping_id = 2980;


-- ust_compartment.facility_id: organization_column_name mapped as "<Facility Id Ust" but schema has "Facility Id Ust"
update public.ust_element_mapping
set organization_column_name = 'Facility Id Ust'
where ust_element_mapping_id = 2980;

-- VALUE MAPPING FIXES

-- ust_facility.owner_type_id: unmapped value 'Duplicate Facility' from tn_ust.v_owner_types.owner_type
-- Choose exactly one statement below, uncomment it, and replace the angle-bracket text.
-- MAP
-- insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (2956, 'Duplicate Facility', '<VALID EPA VALUE>', 'MAP', null, null);
-- EXCLUDE
 insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
 values (2956, 'Duplicate Facility', null, 'EXCLUDE', 'Y', 'Exclude these facilities per OUST');
-- INTENTIONALLY_NULL
-- insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (2956, 'Duplicate Facility', null, 'INTENTIONALLY_NULL', null, '<why EPA value is intentionally null>');


-- ust_facility.facility_type1: unmapped value 'Duplicate Facility' from tn_ust.tn_facilities."FACILITY_TYPE"
-- Choose exactly one statement below, uncomment it, and replace the angle-bracket text.
-- MAP
-- insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (2957, 'Duplicate Facility', '<VALID EPA VALUE>', 'MAP', null, null);
-- EXCLUDE
 insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
 values (2957, 'Duplicate Facility', null, 'EXCLUDE', 'Y', 'Exclude these facilities per OUST');
-- INTENTIONALLY_NULL
-- insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (2957, 'Duplicate Facility', null, 'INTENTIONALLY_NULL', null, '<why EPA value is intentionally null>');


-- ust_facility.facility_type1: unmapped value 'Farm less than 1101 not regulated' from tn_ust.tn_facilities."FACILITY_TYPE"
-- Choose exactly one statement below, uncomment it, and replace the angle-bracket text.
-- MAP
-- insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (2957, 'Farm less than 1101 not regulated', '<VALID EPA VALUE>', 'MAP', null, null);
-- EXCLUDE
 insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
 values (2957, 'Farm less than 1101 not regulated', null, 'EXCLUDE', 'Y', 'Exclude these facilities per OUST');
-- INTENTIONALLY_NULL
-- insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (2957, 'Farm less than 1101 not regulated', null, 'INTENTIONALLY_NULL', null, '<why EPA value is intentionally null>');


-- ust_facility.facility_type1: unmapped value 'Office Building or Complex' from tn_ust.tn_facilities."FACILITY_TYPE"
-- Choose exactly one statement below, uncomment it, and replace the angle-bracket text.
-- MAP
 insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
 values (2957, 'Office Building or Complex', 'Other', 'MAP', null, null);
-- EXCLUDE
-- insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (2957, 'Office Building or Complex', null, 'EXCLUDE', 'Y', '<why source rows are excluded>');
-- INTENTIONALLY_NULL
-- insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (2957, 'Office Building or Complex', null, 'INTENTIONALLY_NULL', null, '<why EPA value is intentionally null>');


-- ust_facility.facility_type1: unmapped value 'Residential above 1100' from tn_ust.tn_facilities."FACILITY_TYPE"
-- Choose exactly one statement below, uncomment it, and replace the angle-bracket text.
-- MAP
-- insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (2957, 'Residential above 1100', '<VALID EPA VALUE>', 'MAP', null, null);
-- EXCLUDE
 insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
 values (2957, 'Residential above 1100', null, 'EXCLUDE', 'Y', 'Exclude all residential facilities, even >1100, per OUST');
-- INTENTIONALLY_NULL
-- insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (2957, 'Residential above 1100', null, 'INTENTIONALLY_NULL', null, '<why EPA value is intentionally null>');


-- ust_facility.facility_type1: unmapped value 'Residential less than 1101 not regulated' from tn_ust.tn_facilities."FACILITY_TYPE"
-- Choose exactly one statement below, uncomment it, and replace the angle-bracket text.
-- MAP
-- insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (2957, 'Residential less than 1101 not regulated', '<VALID EPA VALUE>', 'MAP', null, null);
-- EXCLUDE
 insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
 values (2957, 'Residential less than 1101 not regulated', null, 'EXCLUDE', 'Y', 'Exclude these facilities per OUST');
-- INTENTIONALLY_NULL
-- insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (2957, 'Residential less than 1101 not regulated', null, 'INTENTIONALLY_NULL', null, '<why EPA value is intentionally null>');


-- ust_compartment.spill_bucket_wall_type_id: unmapped value 'Not Required' from tn_ust.v_tn_compartments."Spill Prevention"
-- Choose exactly one statement below, uncomment it, and replace the angle-bracket text.
-- MAP
-- insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (2995, 'Not Required', '<VALID EPA VALUE>', 'MAP', null, null);
-- EXCLUDE
-- insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (2995, 'Not Required', null, 'EXCLUDE', 'Y', '<why source rows are excluded>');
-- INTENTIONALLY_NULL
 insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
 values (2995, 'Not Required', null, 'INTENTIONALLY_NULL', null, 'per OUST');


-- ust_compartment_substance.substance_id: unmapped value 'ULSDiesel_Kerosene' from tn_ust.v_tn_compartments."Product"
-- Choose exactly one statement below, uncomment it, and replace the angle-bracket text.
-- MAP
 insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
 values (3010, 'ULSDiesel_Kerosene', 'Multiple products listed', 'MAP', null, null);

select * from substances where substance like 'Mult%'

-- EXCLUDE
-- insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (3010, 'ULSDiesel_Kerosene', null, 'EXCLUDE', 'Y', '<why source rows are excluded>');
-- INTENTIONALLY_NULL
-- insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (3010, 'ULSDiesel_Kerosene', null, 'INTENTIONALLY_NULL', null, '<why EPA value is intentionally null>');


-- ust_facility.facility_state: unmapped value 'TN' from tn_ust.v_facilities.facility_state
-- Choose exactly one statement below, uncomment it, and replace the angle-bracket text.
-- MAP
 insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
 values (4319, 'TN', 'TN', 'MAP', null, null);
-- EXCLUDE
-- insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (4319, 'TN', null, 'EXCLUDE', 'Y', '<why source rows are excluded>');
-- INTENTIONALLY_NULL
-- insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, exclude_from_query, programmer_comments)
-- values (4319, 'TN', null, 'INTENTIONALLY_NULL', null, '<why EPA value is intentionally null>');

