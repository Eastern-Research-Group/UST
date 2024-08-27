------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--facility_type1

--select distinct "UST Facility Type" from ca_ust."facility" where "UST Facility Type" is not null order by 1;
/* Organization values are:

Farm
Fuel Distribution
Motor Vehicle Fueling
Other
Processor
*/

/*
Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
*/
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1099, 'Farm', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1099, 'Fuel Distribution', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1099, 'Motor Vehicle Fueling', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1099, 'Other', 'Other', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1099, 'Processor', '', null);

--select facility_type from public.facility_types;
/* Valid EPA values are:

Agricultural/farm
Auto dealership/auto maintenance & repair
Aviation/airport (non-rental car)
Bulk plant storage/petroleum distributor
Commercial
Contractor
Hospital (or other medical)
Industrial
Marina
Railroad
Rental Car
Residential
Retail fuel sales (non-marina)
School
Telecommunication facility
Trucking/transport/fleet operation
Utility
Wholesale
Other
Unknown

Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'facility_type1'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
to do mapping, check public.facility_types to find the updated epa_value.
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--tank_status_id

--select distinct "Type of Action" from ca_ust."tank" where "Type of Action" is not null order by 1;
/* Organization values are:

AST Change to UST
Confirmed/Updated Information
New Permit
Renewal Permit
Split Facility
Temporary UST Closure
UST Change to AST
UST Permanent Closure on Site
UST Removal
*/

/*
Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
*/
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1130, 'AST Change to UST', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1130, 'Confirmed/Updated Information', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1130, 'New Permit', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1130, 'Renewal Permit', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1130, 'Split Facility', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1130, 'Temporary UST Closure', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1130, 'UST Change to AST', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1130, 'UST Permanent Closure on Site', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1130, 'UST Removal', '', null);

--select tank_status from public.tank_statuses;
/* Valid EPA values are:

Currently in use
Temporarily out of service
Closed (removed from ground)
Closed (in place)
Closed (general)
Abandoned
Other
Unknown

Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'tank_status_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
to do mapping, check public.tank_statuses to find the updated epa_value.
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--tank_material_description_id

--select distinct "Tank Primary _Containment _Construction " from ca_ust."tank" where "Tank Primary _Containment _Construction " is not null order by 1;
/* Organization values are:

Fiberglass
Internal Bladder
Other
Steel
Steel + Internal Lining
Unknown
*/

/*
Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
*/
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1136, 'Fiberglass', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1136, 'Internal Bladder', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1136, 'Other', 'Other', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1136, 'Steel', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1136, 'Steel + Internal Lining', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1136, 'Unknown', 'Unknown', null);

--select tank_material_description from public.tank_material_descriptions;
/* Valid EPA values are:

Fiberglass reinforced plastic
Asphalt coated or bare steel
Composite/clad (steel w/fiberglass reinforced plastic)
Epoxy coated steel
Coated and cathodically protected steel
Cathodically protected steel (without coating)
Jacketed steel
Steel (NEC)
Concrete
Other
Unknown

Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'tank_material_description_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
to do mapping, check public.tank_material_descriptions to find the updated epa_value.
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--tank_secondary_containment_id

--select distinct "Tank Secondary _Containment _Construction " from ca_ust."tank" where "Tank Secondary _Containment _Construction " is not null order by 1;
/* Organization values are:

Exterior Membrane Liner
Fiberglass
Jacketed
Other
Steel
Unknown
*/

/*
Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
*/
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1140, 'Exterior Membrane Liner', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1140, 'Fiberglass', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1140, 'Jacketed', 'Jacketed', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1140, 'Other', 'Other', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1140, 'Steel', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1140, 'Unknown', 'Unknown', null);

--select tank_secondary_containment from public.tank_secondary_containments;
/* Valid EPA values are:

Single wall
Double wall
Triple wall
Jacketed
Excavation liner
Vault
Tank-within-a-tank retrofit (UL standard 1856)
Other
Unknown

Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'tank_secondary_containment_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
to do mapping, check public.tank_secondary_containments to find the updated epa_value.
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--substance_id

--select distinct "Tank Contents " from ca_ust."tank" where "Tank Contents " is not null order by 1;
/* Organization values are:

Aviation  Gas
Biodiesel 100
Biodiesel B6  B99
Diesel
E85
Ethanol
Jet Fuel
Kerosene
Midgrade Unleaded
Other Non-petroleum
Other Petroleum
Petroleum Blend Fuel
Premium Unleaded
Regular Unleaded
Used Oil
*/

/*
Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
*/
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1141, 'Aviation  Gas', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1141, 'Biodiesel 100', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1141, 'Biodiesel B6  B99', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1141, 'Diesel', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1141, 'E85', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1141, 'Ethanol', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1141, 'Jet Fuel', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1141, 'Kerosene', 'Kerosene', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1141, 'Midgrade Unleaded', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1141, 'Other Non-petroleum', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1141, 'Other Petroleum', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1141, 'Petroleum Blend Fuel', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1141, 'Premium Unleaded', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1141, 'Regular Unleaded', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1141, 'Used Oil', '', null);

--select substance from public.substances order by substance_group, substance;
/* Valid EPA values are:

Aviation biofuel
Aviation gasoline
Biojet (diesel)
Jet fuel A
Jet fuel B
Sustainable aviation fuel/aviation fuel blend
Unknown aviation gas or jet fuel
100% biodiesel (B100, not federally regulated)
80% renewable diesel, 20% biodiesel
95% renewable diesel, 5% biodiesel
99.9 percent renewable diesel, 0.01% biodiesel
ASTM D975 diesel (known 100% renewable diesel)
Diesel blend containing 99% to less than 100% biodiesel
Diesel blend containing greater than 20% and less than 99% biodiesel
Diesel blends containing greater than 5% and up to 20% or less biodiesel
Diesel fuel (ASTM D975), can contain 0-5% biodiesel
Diesel fuel (b-unknown)
Diesel fuel (known to contain 0% biodiesel)
Off-road diesel/dyed diesel
Other unlisted blend containing any other mixture of diesel, renewable diesel, or 20% biodiesel or less
Other unlisted blend containing any other mixture of diesel, renewable diesel, or more than 20% biodiesel
E-85/Flex Fuel (E51-E83)
Ethanol blend gasoline (e-unknown)
Gasoline (non-ethanol)
Gasoline (unknown type)
Gasoline E-10 (E1-E10)
Gasoline E-15 (E-11-E15)
Gasoline/ethanol blend containing more than 83% and less than 98% ethanol
Gasoline/ethanol blends E16-E50
Racing fuel
Biofuel/bioheat
Heating oil/fuel oil 1
Heating oil/fuel oil 2
Heating oil/fuel oil 4
Heating oil/fuel oil 5
Heating oil/fuel oil 6
Heating/fuel oil # unknown
Lube/motor oil (new)
Used oil/waste oil
Antifreeze
Denatured ethanol (98%)
Diesel exhaust fluid (DEF, not federally regulated)
Hazardous substance
Kerosene
Marine fuel
Non-federally regulated substance (general)
Other or mixture
Petroleum product
Solvent
Unknown

Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'substance_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
to do mapping, check public.substances to find the updated epa_value.
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--compartment_status_id

/*
CA does not report at the Compartment level, but CompartmentStatus is required.

Copy the tank status mapping down to the compartment!
The lookup tables for compartment_statuses and tank_stasuses are the same.
*/

--select distinct "Type of Action" from ca_ust."tank" where "Type of Action" is not null order by 1;
/* Organization values are:

AST Change to UST
Confirmed/Updated Information
New Permit
Renewal Permit
Split Facility
Temporary UST Closure
UST Change to AST
UST Permanent Closure on Site
UST Removal
*/

/*
Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
*/
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1173, 'AST Change to UST', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1173, 'Confirmed/Updated Information', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1173, 'New Permit', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1173, 'Renewal Permit', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1173, 'Split Facility', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1173, 'Temporary UST Closure', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1173, 'UST Change to AST', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1173, 'UST Permanent Closure on Site', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1173, 'UST Removal', '', null);

--select compartment_status from public.compartment_statuses;
/* Valid EPA values are:

Currently in use
Temporarily out of service
Closed (removed from ground)
Closed (in place)
Closed (general)
Abandoned
Other
Unknown

Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'compartment_status_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
to do mapping, check public.compartment_statuses to find the updated epa_value.
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--piping_style_id

--select distinct "Piping_System Type" from ca_ust."tank" where "Piping_System Type" is not null order by 1;
/* Organization values are:

23 CCR Â§2636(a)(3) Suction
Conventional Suction
Gravity
Pressure
*/

/*
Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
*/
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1161, '23 CCR Â§2636(a)(3) Suction', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1161, 'Conventional Suction', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1161, 'Gravity', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1161, 'Pressure', 'Pressure', null);

--select piping_style from public.piping_styles;
/* Valid EPA values are:

Suction
Pressure
Hydrant
Non-operational (e.g., fill line, vent line, gravity)
Other
Unknown
No piping

Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'piping_style_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
to do mapping, check public.piping_styles to find the updated epa_value.
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--pipe_tank_top_sump_wall_type_id

--select distinct "Piping/Turbine _Containment _Sump" from ca_ust."tank" where "Piping/Turbine _Containment _Sump" is not null order by 1;
/* Organization values are:

Double-walled
Single-walled
*/

/*
Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
*/
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1168, 'Double-walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1168, 'Single-walled', '', null);

--select pipe_tank_top_sump_wall_type from public.pipe_tank_top_sump_wall_types;
/* Valid EPA values are:

Single
Double
Unknown

Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'pipe_tank_top_sump_wall_type_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
to do mapping, check public.pipe_tank_top_sump_wall_types to find the updated epa_value.
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--piping_wall_type_id

--select distinct "Piping_Construction" from ca_ust."tank" where "Piping_Construction" is not null order by 1;
/* Organization values are:

Double-walled
Other
Single-walled
*/

/*
Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
*/
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1169, 'Double-walled', 'Double walled', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1169, 'Other', 'Other', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1169, 'Single-walled', 'Single walled', null);

--select piping_wall_type from public.piping_wall_types;
/* Valid EPA values are:

Single walled
Double walled
Other

Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'piping_wall_type_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
to do mapping, check public.piping_wall_types to find the updated epa_value.
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------