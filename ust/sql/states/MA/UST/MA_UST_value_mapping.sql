------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--ust_facility.owner_type_id

--select distinct "org_type_name" from ma_ust."erg_facility_info_org_type" where "org_type_name" is not null order by 1;
/* Organization values are:

Authority
Federal
Institutional (non-profit)
Municipal
Private
State
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4158, 'Authority', 'Other', 'please verify');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4158, 'Federal', 'Federal Government', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4158, 'Institutional (non-profit)', 'Other', 'please verify');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4158, 'Municipal', 'Local Government', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4158, 'Private', 'Private', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4158, 'State', 'State Government', null);

--select owner_type from public.owner_types;
/* Valid EPA values are:

Local Government
Commercial
Private
Military
Other
Tribal Government
Government (unspecified)
Federal Government
State Government

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'owner_type_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check public.owner_types to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--ust_facility.facility_type1

--select distinct "FAC TYPE" from ma_ust."erg_facility_final" where "FAC TYPE" is not null order by 1;
/* Organization values are:

Airport
Bulk Storage Fuel
Commercial
Farm
Government Entity
Institution
Manufacturing
Marina
Military
Non-Retail Motor Vehicle Fuel Dispensing
Other
Retail Motor Vehicle Fuel Dispensing
Utilities
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4159, 'Airport', 'Aviation/airport (non-rental car)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4159, 'Bulk Storage Fuel', 'Bulk plant storage/petroleum distributor', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4159, 'Commercial', 'Commercial', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4159, 'Farm', 'Agricultural/farm', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4159, 'Government Entity', 'Government (unspecified)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4159, 'Institution', 'School', 'please verify');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4159, 'Manufacturing', 'Commercial', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4159, 'Marina', 'Marina', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4159, 'Military', 'Military', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4159, 'Non-Retail Motor Vehicle Fuel Dispensing', 'Other', 'please verify');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4159, 'Other', 'Other', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4159, 'Retail Motor Vehicle Fuel Dispensing', 'Retail fuel sales (non-marina)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4159, 'Utilities', 'Utility', null);

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
Military
State/local government
Government (unspecified)
Federal government
Vacant

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'facility_type1'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check public.facility_types to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--ust_facility.facility_state

--select distinct "FAC STATE" from ma_ust."erg_facility_final" where "FAC STATE" is not null order by 1;
/* Organization values are:

MA
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4164, 'MA', 'MA', null);

--select state from public.states;
/* Valid EPA values are:

AK
AL
AR
AS
AZ
CA
CO
CT
DC
DE
FL
GA
GU
HI
IA
ID
IL
IN
KS
KY
LA
MA
MD
ME
MI
MN
MO
MP
MS
MT
NC
ND
NE
NH
NJ
NM
NV
NY
OH
OK
OR
PA
PR
RI
SC
SD
TN
TT
TX
UT
VA
VI
VT
WA
WI
WV
WY

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'facility_state'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check public.states to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--ust_tank.tank_status_id

--select distinct "STATUS" from ma_ust."Tank info" where "STATUS" is not null order by 1;
/* Organization values are:

In Use
Tank Closure In-Place
Tank Temporarily Out of Service
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4181, 'In Use', 'Currently in use', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4181, 'Tank Closure In-Place', 'Closed (in place)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4181, 'Tank Temporarily Out of Service', 'Temporarily out of service', null);

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

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'tank_status_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check public.tank_statuses to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--ust_tank.tank_material_description_id

--select distinct "TANK CONSTRUCT" from ma_ust."Tank info" where "TANK CONSTRUCT" is not null order by 1;
/* Organization values are:

Concrete (cathodic protection not required)
Double-walled metal tank (cathodic protection required)
Double-walled non-corrodible (including "composite") material (cathodic protection not required)
Field Constructed Tank Double Walled (cathodic protection not required)
Single-walled metal tank (cathodic protection required)
Single-walled metal tank with internal liner (cathodic protection required)
Single-walled non-corrodible (including "composite") material (cathodic protection not required)
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4185, 'Concrete (cathodic protection not required)', 'Concrete', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4185, 'Double-walled non-corrodible (including "composite") material (cathodic protection not required)', 'Composite/clad steel w/fiberglass reinforced plastic', 'please verify');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4185, 'Single-walled non-corrodible (including "composite") material (cathodic protection not required)', 'Composite/clad steel w/fiberglass reinforced plastic', 'please verify');

--select tank_material_description from public.tank_material_descriptions;
/* Valid EPA values are:

Fiberglass reinforced plastic
Asphalt coated or bare steel
Epoxy coated steel
Coated and cathodically protected steel
Jacketed steel
Concrete
Other
Unknown
Composite/clad steel w/fiberglass reinforced plastic
Cathodically protected steel without coating
Steel NEC
Urethane coated/clad steel (steel with/poly urethane)

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'tank_material_description_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check public.tank_material_descriptions to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--ust_tank.tank_secondary_containment_id

--select distinct "TANK CONSTRUCT" from ma_ust."Tank info" where "TANK CONSTRUCT" is not null order by 1;
/* Organization values are:

Concrete (cathodic protection not required)
Double-walled metal tank (cathodic protection required)
Double-walled non-corrodible (including "composite") material (cathodic protection not required)
Field Constructed Tank Double Walled (cathodic protection not required)
Single-walled metal tank (cathodic protection required)
Single-walled metal tank with internal liner (cathodic protection required)
Single-walled non-corrodible (including "composite") material (cathodic protection not required)
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4191, 'Double-walled metal tank (cathodic protection required)', 'Double wall', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4191, 'Double-walled non-corrodible (including "composite") material (cathodic protection not required)', 'Double wall', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4191, 'Field Constructed Tank Double Walled (cathodic protection not required)', 'Double wall', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4191, 'Single-walled metal tank (cathodic protection required)', 'Single wall', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4191, 'Single-walled metal tank with internal liner (cathodic protection required)', 'Single wall', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4191, 'Single-walled non-corrodible (including "composite") material (cathodic protection not required)', 'Single wall', null);

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

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'tank_secondary_containment_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check public.tank_secondary_containments to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--ust_tank_substance.substance_id

--select distinct "CONTENT" from ma_ust."Tank info" where "CONTENT" is not null order by 1;
/* Organization values are:

Aviation Gasoline
Bulk Heating or Fuel Oil (#2,#4,#6)
Diesel
E85
Gasoline
Hazardous Material
Jet Fuel
Kerosene
Unregulated Content
Virgin Motor Oils
Waste Oil
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4194, 'Aviation Gasoline', 'Aviation gasoline', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4194, 'Bulk Heating or Fuel Oil (#2,#4,#6)', 'Heating/fuel oil # unknown', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4194, 'Diesel', 'Diesel fuel (ASTM D975), can contain 0-5% biodiesel', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4194, 'E85', 'E-85/Flex Fuel (E51-E83)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4194, 'Gasoline', 'Gasoline (unknown type)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4194, 'Hazardous Material', 'Hazardous substance', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4194, 'Jet Fuel', 'Jet fuel', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4194, 'Kerosene', 'Kerosene', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4194, 'Virgin Motor Oils', 'Lube/motor oil (new)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4194, 'Waste Oil', 'Waste oil', null);

insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4194, 'Unregulated Content', '', null);

--
select substance from public.substances 
where inactive_flag is null and ust_flag is not null
order by substance_group, substance;

select * from public.substances 

/* Valid EPA values are:

Aviation biofuel
Aviation gasoline
Biojet (diesel)
Jet fuel
Sustainable aviation fuel/aviation fuel blend
Unknown aviation gas or jet fuel
Diesel blend (b-unknown)
Diesel blend containing 99% to less than 100% biodiesel
Diesel blend containing greater than 20% and less than 99% biodiesel
Diesel blends containing greater than 5% and up to 20% or less biodiesel
Diesel fuel (ASTM D975), can contain 0-5% biodiesel
Low sulfur diesel
Off-road diesel/dyed diesel
E-85/Flex Fuel (E51-E83)
E-98
Ethanol blend gasoline (e-unknown)
Gasoline (non-ethanol)
Gasoline (unknown type)
Gasoline E-10 (E1-E10)
Gasoline E-15 (E-11-E15)
Gasoline E-20
Gasoline E-30
Gasoline/ethanol blend containing more than 83% and less than 98% ethanol
Gasoline/ethanol blends containing greater than 15% and less than 51% ethanol
Leaded gasoline
Racing fuel
Biofuel/bioheat
Heating oil/fuel oil 1
Heating oil/fuel oil 2
Heating oil/fuel oil 4
Heating oil/fuel oil 5
Heating oil/fuel oil 6
Heating/fuel oil # unknown
Crude oil
Hydraulic oil
Kerosene
Lube/motor oil (new)
Oil unspecified
Transformer oil
Transmission fluid
Used oil
Used oil/waste oil (unspecified)
Waste oil
Antifreeze
Asphalt
Empty
Hazardous substance
Mineral spirits
Mixture
MTBE
Other
Petroleum product
Unknown
 * NOTE: Hazardous substances can be found in view public.v_hazardous_substances.
 * If the state included a CAS No., you can also try mapping it to public.v_casno.

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'substance_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check public.substances to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--ust_compartment.compartment_status_id

/*
MA does not report at the Compartment level, but CompartmentStatus is required.

Copy the tank status mapping down to the compartment!
The lookup tables for compartment_statuses and tank_stasuses are the same.
 */

--select distinct "STATUS" from ma_ust."Tank info" where "STATUS" is not null order by 1;
/* Organization values are:

In Use
Tank Closure In-Place
Tank Temporarily Out of Service
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4199, 'In Use', 'Currently in use', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4199, 'Tank Closure In-Place', 'Closed (in place)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4199, 'Tank Temporarily Out of Service', 'Temporarily out of service', null);

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

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'compartment_status_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check public.compartment_statuses to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--ust_piping.piping_style_id

--select distinct "PIPE TYPE" from ma_ust."Tank info" where "PIPE TYPE" is not null order by 1;
/* Organization values are:

European suction system
Non-European suction System
Pressurized piping system with electronic automatic line leak detection
Pressurized piping system with mechanical automatic line leak detection
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4221, 'European suction system', 'Suction', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4221, 'Non-European suction System', 'Suction', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4221, 'Pressurized piping system with electronic automatic line leak detection', 'Pressure', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4221, 'Pressurized piping system with mechanical automatic line leak detection', 'Pressure', null);

--select piping_style from public.piping_styles;
/* Valid EPA values are:

Suction
Pressure
Hydrant
Other
Unknown
No piping
Non-operational e.g., fill line, vent line, gravity
Aboveground/not regulated

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'piping_style_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check public.piping_styles to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--ust_piping.piping_wall_type_id

--select distinct "PIPE CONSTRUCT" from ma_ust."Tank info" where "PIPE CONSTRUCT" is not null order by 1;
/* Organization values are:

Double-walled non-corrodible material (No corrosion protection required)
Double walled metal (Corrosion protection required)
Single-walled metal (Corrosion protection required)
Single-walled non-corrodible material (No corrosion protection required)
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4231, 'Double-walled non-corrodible material (No corrosion protection required)', 'Double wall', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4231, 'Double walled metal (Corrosion protection required)', 'Double wall', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4231, 'Single-walled metal (Corrosion protection required)', 'Single wall', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4231, 'Single-walled non-corrodible material (No corrosion protection required)', 'Single wall', null);

--select piping_wall_type from public.piping_wall_types;
/* Valid EPA values are:

Single wall
Double wall
Other

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'piping_wall_type_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check public.piping_wall_types to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* If the source data contains tank material information for cathodically protected steel and doesn't
 * contain explicit cathodic protection elements, we can infer the cathodic protection, which will default to
 * sacraficial anodes because they are more prevelant than impressed current (per OUST).
 * Run the SQL below to insert rows into public.ust_element mapping if these conditions apply to this data.
 */

insert into public.ust_element_mapping
    (ust_control_id, epa_table_name, epa_column_name, 
    organization_table_name, organization_column_name, 
    organization_join_table, organization_join_fk, organization_join_column2, organization_join_fk2, organization_join_column3, organization_join_fk3,
    query_logic, inferred_value_comment)
select ust_control_id, 'ust_tank', 'tank_corrosion_protection_sacrificial_anode', organization_table_name, organization_column_name, 
    organization_join_table, organization_join_fk, organization_join_column2, organization_join_fk2, organization_join_column3, organization_join_fk3,
    'when tank_material_description_id in (5,6) then ''Yes'' else null', 'Inferred from tank material'
from public.ust_element_mapping a
where ust_control_id = 42 and epa_column_name = 'tank_material_description_id'
and exists 
    (select 1 from public.ust_element_value_mapping b 
    where a.ust_element_mapping_id = b.ust_element_mapping_id 
    and epa_value like '%athod%')
and not exists 
    (select 1 from public.ust_element_mapping b 
    where a.ust_control_id = b.ust_control_id
    and b.epa_column_name like 'tank_corrosion_protection%')
and not exists
    (select 1 from public.ust_element_mapping b 
    where a.ust_control_id = b.ust_control_id
    and b.epa_column_name = 'tank_corrosion_protection_sacrificial_anode');

/* There is no generated query we can run to automatically infer Piping corrosion protection, so the following
 * inserts need to be carefully reviewed. DELETE any of the SQL statements below that don't make sense and
 * ONLY RUN THOSE THAT DEFINITELY REFER TO CORROSION PROTECTION!
 */

--BEFORE RUNNING THIS INSERT STATEMENT, MAKE SURE THE ORGANIZATION VALUE MEANS THAT CORROSION PROTECTION APPLIES TO THE PIPING!


--BEFORE RUNNING THIS INSERT STATEMENT, MAKE SURE THE ORGANIZATION VALUE MEANS THAT CORROSION PROTECTION APPLIES TO THE PIPING!
insert into public.ust_element_mapping
     (ust_control_id, epa_table_name, epa_column_name, 
     organization_table_name, organization_column_name, 
     query_logic, inferred_value_comment)
values(42, 'ust_piping', 'piping_corrosion_protection_sacrificial_anode', 'Tank info', 'PIPE CONSTRUCT', 
     'when "PIPE CONSTRUCT" = ''Double walled metal (Corrosion protection required)'' then ''Yes'' else null', 'Inferred from Tank info.PIPE CONSTRUCT')
on conflict (ust_control_id, epa_table_name, epa_column_name) 
do update set organization_table_name = excluded.organization_table_name,
              organization_column_name = excluded.organization_column_name,
              query_logic = excluded.query_logic,
              inferred_value_comment = excluded.inferred_value_comment;

--BEFORE RUNNING THIS INSERT STATEMENT, MAKE SURE THE ORGANIZATION VALUE MEANS THAT CORROSION PROTECTION APPLIES TO THE PIPING!
insert into public.ust_element_mapping
     (ust_control_id, epa_table_name, epa_column_name, 
     organization_table_name, organization_column_name, 
     query_logic, inferred_value_comment)
values(42, 'ust_piping', 'piping_corrosion_protection_sacrificial_anode', 'Tank info', 'PIPE CONSTRUCT', 
     'when "PIPE CONSTRUCT" = ''Single-walled metal (Corrosion protection required)'' then ''Yes'' else null', 'Inferred from Tank info.PIPE CONSTRUCT')
on conflict (ust_control_id, epa_table_name, epa_column_name) 
do update set organization_table_name = excluded.organization_table_name,
              organization_column_name = excluded.organization_column_name,
              query_logic = excluded.query_logic,
              inferred_value_comment = excluded.inferred_value_comment;

--BEFORE RUNNING THIS INSERT STATEMENT, MAKE SURE THE ORGANIZATION VALUE MEANS THAT CORROSION PROTECTION APPLIES TO THE PIPING!
--insert into public.ust_element_mapping
--     (ust_control_id, epa_table_name, epa_column_name, 
--     organization_table_name, organization_column_name, 
--     query_logic, inferred_value_comment)
--values(42, 'ust_piping', 'piping_corrosion_protection_sacrificial_anode', 'Tank info', 'PIPE CONSTRUCT', 
--     'when "PIPE CONSTRUCT" = ''Single-walled non-corrodible material (No corrosion protection required)'' then ''Yes'' else null', 'Inferred from Tank info.PIPE CONSTRUCT')
--on conflict (ust_control_id, epa_table_name, epa_column_name) 
--do update set organization_table_name = excluded.organization_table_name,
--              organization_column_name = excluded.organization_column_name,
--              query_logic = excluded.query_logic,
--              inferred_value_comment = excluded.inferred_value_comment;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
