select * from ust_element_mapping uem 
where uem.ust_control_id = 30 and uem.epa_column_name = 'piping_id';

select * from dc_ust.tank
where "TankName" > 10;

update ust_element_mapping 
set programmer_comments = 'Switching tank name and id for mapping to the EPA values.'
where ust_element_mapping_id = 3096;

update ust_control 
set organization_compartment_flag = 'N'
where ust_control_id = 30;

update ust_element_value_mapping
set organization_value = 'Manufacturer"s installation checklists aave been completed'
where ust_element_value_mapping_id = 1965;

select * from ust_element_value_mapping uevm 
where ust_element_mapping_id = 2309;

select * from v_ust_element_mapping 
where organization_id = 'DC' and epa_column_name = 'cert_of_installation_id';

update ust_element_value_mapping 
set programmer_comments = 'Values of Unknown will not be mapped and will be null in the template'
where ust_element_value_mapping_id = 1987;

update ust_element_mapping
set epa_column_name = 'cert_of_installation_id'
where ust_control_id = 30 and epa_column_name = 'cert_of_installation';

select * from ust_element_value_mapping 
where ust_element_mapping_id = 2308;

select "Dispenser ID"
from dc_ust.dispenser d 
group by "Dispenser ID" 
having count(*) > 1;

select * from dc_ust.dispenser
where "Dispenser ID" = '5000362-6' or "Dispenser ID" = '5000362-5'

select * from ust_facility_dispenser
where ust_facility_id = 1058275

select * from ust_element_allowed_values
where column_name = 'financial_responsibility_obtained'

select * from ust_element_mapping
where ust_control_id = 30;

update ust_element_mapping
set programmer_comments = null 
where ust_element_mapping_id = 2513;

delete from release_control 
where release_control_id = 17;

select "LUSTID"
from dc_release."release"
order by "LUSTID" desc 

select * from ust_element_allowed_values
where ust_element_allowed_values.column_name = 'financial_responsibility_obtained';

select * from ust_element_mapping 
where ust_element_mapping.ust_control_id = 30;

delete from ust_element_mapping
where ust_element_mapping_id = 3341;

select facility_id, tank_id, compartment_id, substance_id, count(*) num_rows from dc_ust.v_ust_compartment_substance 
 group by facility_id, tank_id, compartment_id, substance_id having count(*) > 1;

select facility_id, tank_id, compartment_id, substance_id, count(*) num_rows from dc_ust.v_ust_compartment_substance 
 group by facility_id, tank_id, compartment_id, substance_id having count(*) > 1;

update ust_element_mapping uem
set epa_comments = 'Looks like DC mapped federal gov as self-insured but needs to be mapped to FR obtained = NA',
programmer_comments = 'mapping all federal gov facilities to N/A per epa_comments',
query_logic = 'when x."facility_type1" = ''Federal Government - Non Military'' and x."FinancialResponsibilitySelfInsuranceFinancialTest" = ''Yes'' then N/A 
	else x."FinancialResponsibilityObtained"'
where ust_element_mapping_id = 2273;

update ust_element_mapping uem 
set epa_comments = 'DC has 34 compartmentalized tanks but lists all their tanks as having a single compartment.  If they don’t have the number of compartments in their data then they should not fill out the field.',
programmer_comments = 'mapping the number_of_compartments by using query logic, instead of the given values per epa_comments',
query_logic = 'left join ( select "TankID", count("CompartmentID") as comp_count
		from dc_ust."compartment"
		group by "TankID"
	) c on x."TankID" = c."TankID"',
organization_table_name = 'compartment',
organization_column_name = 'CompartmentID',
organization_join_table = 'tank',
organization_join_column = 'TankID'
where ust_element_mapping_id = 2300;

select * from dc_ust.compartment c 
where c."CompartmentSubstanceStored" = 'Hazardous substance' and c."CompartmentStatus" = 'Currently in use';