-- SOURCE IDENTIFIER FIXES

-- ust_tank.number_of_compartments: organization_column_name mapped as "NumberofCompartments" but schema has "NumberOfCompartments"
update public.ust_element_mapping
set organization_column_name = 'NumberOfCompartments'
where ust_element_mapping_id = 4351;
