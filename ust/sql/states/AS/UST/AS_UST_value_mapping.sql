------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--ust_facility.owner_type_id

--select distinct "OwnerType" from as_ust."facility" where "OwnerType" is not null order by 1;
/* Organization values are:

Commercial
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, programmer_comments)
values (4323, 'Commercial', 'Commercial', 'MAP', null);

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

--select distinct "FacilityType1" from as_ust."facility" where "FacilityType1" is not null order by 1;
/* Organization values are:

Service Station
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, programmer_comments)
-- Choose MAP, EXCLUDE, or INTENTIONALLY_NULL before running this statement.
-- values (4324, 'Service Station', '<INSERT EPA VALUE>', 'MAP', null);

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
--ust_facility.facility_type2

--select distinct "FacilityType2" from as_ust."facility" where "FacilityType2" is not null order by 1;
/* Organization values are:

NA
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, programmer_comments)
-- Choose MAP, EXCLUDE, or INTENTIONALLY_NULL before running this statement.
-- values (4325, 'NA', '<INSERT EPA VALUE>', 'MAP', null);

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
where epa_column_name = 'facility_type2'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check public.facility_types to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--ust_facility.facility_state

--select distinct "FacilityState" from as_ust."facility" where "FacilityState" is not null order by 1;
/* Organization values are:

AS
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, programmer_comments)
values (4331, 'AS', 'AS', 'MAP', null);

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
--ust_tank.tank_location_id

--select distinct "TankLocation" from as_ust."tank" where "TankLocation" is not null order by 1;
/* Organization values are:

Underground entirely buried
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, programmer_comments)
-- Choose MAP, EXCLUDE, or INTENTIONALLY_NULL before running this statement.
-- values (4341, 'Underground entirely buried', '<INSERT EPA VALUE>', 'MAP', null);

--select tank_location from public.tank_locations;
/* Valid EPA values are:

Underground (entirely buried)
Partially buried
Aboveground (tank bottom abovegrade)
Aboveground (tank bottom on-grade)
Unknown
Other

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'tank_location_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check public.tank_locations to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--ust_tank.tank_status_id

--select distinct "TankStatus" from as_ust."tank" where "TankStatus" is not null order by 1;
/* Organization values are:

Active
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, programmer_comments)
-- Choose MAP, EXCLUDE, or INTENTIONALLY_NULL before running this statement.
-- values (4342, 'Active', '<INSERT EPA VALUE>', 'MAP', null);

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

--select distinct "TankMaterialDescription" from as_ust."tank" where "TankMaterialDescription" is not null order by 1;
/* Organization values are:

FRP
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, programmer_comments)
-- Choose MAP, EXCLUDE, or INTENTIONALLY_NULL before running this statement.
-- values (4352, 'FRP', '<INSERT EPA VALUE>', 'MAP', null);

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

--select distinct "TankSecondaryContainment" from as_ust."tank" where "TankSecondaryContainment" is not null order by 1;
/* Organization values are:

DW
SW
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, programmer_comments)
-- Choose MAP, EXCLUDE, or INTENTIONALLY_NULL before running this statement.
-- values (4359, 'DW', '<INSERT EPA VALUE>', 'MAP', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, programmer_comments)
-- Choose MAP, EXCLUDE, or INTENTIONALLY_NULL before running this statement.
-- values (4359, 'SW', '<INSERT EPA VALUE>', 'MAP', null);

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
--ust_tank.cert_of_installation_id

--select distinct "CertOfInstallation" from as_ust."tank" where "CertOfInstallation" is not null order by 1;
/* Organization values are:

NA
NA 
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, programmer_comments)
-- Choose MAP, EXCLUDE, or INTENTIONALLY_NULL before running this statement.
-- values (4360, 'NA', '<INSERT EPA VALUE>', 'MAP', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, programmer_comments)
-- Choose MAP, EXCLUDE, or INTENTIONALLY_NULL before running this statement.
-- values (4360, 'NA ', '<INSERT EPA VALUE>', 'MAP', null);

--select cert_of_installation from public.cert_of_installations;
/* Valid EPA values are:

Installer certified by tank and piping manufacturers
Installer certified or licensed by the implementing agency
Installation inspected by a registered engineer
Installation inspected and approved by implementing agency
Manufacturer's installation checklists have been completed
Another method allowed by implementing agency
Other method - specify
No
Unknown

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'cert_of_installation_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check public.cert_of_installations to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--ust_tank_substance.substance_id

--select distinct "CompartmentSubstanceStored" from as_ust."compartment" where "CompartmentSubstanceStored" is not null order by 1;
/* Organization values are:

Diesel
Gasoline (non-ethanol)
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, programmer_comments)
-- Choose MAP, EXCLUDE, or INTENTIONALLY_NULL before running this statement.
-- values (4364, 'Diesel', '<INSERT EPA VALUE>', 'MAP', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, programmer_comments)
values (4364, 'Gasoline (non-ethanol)', 'Gasoline (non-ethanol)', 'MAP', null);

--select substance from public.substances where inactive_flag is null and ust_flag is not null order by substance_group, substance;
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
Multiple products listed
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
AS does not report at the Compartment level, but CompartmentStatus is required.

Copy the tank status mapping down to the compartment!
The lookup tables for compartment_statuses and tank_stasuses are the same.
 */

--select distinct "CompartmentStatus" from as_ust."compartment" where "CompartmentStatus" is not null order by 1;
/* Organization values are:

Active
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, programmer_comments)
-- Choose MAP, EXCLUDE, or INTENTIONALLY_NULL before running this statement.
-- values (4369, 'Active', '<INSERT EPA VALUE>', 'MAP', null);

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
--ust_compartment_substance.substance_id

--select distinct "CompartmentSubstanceStored" from as_ust."compartment" where "CompartmentSubstanceStored" is not null order by 1;
/* Organization values are:

Diesel
Gasoline (non-ethanol)
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, programmer_comments)
-- Choose MAP, EXCLUDE, or INTENTIONALLY_NULL before running this statement.
-- values (4390, 'Diesel', '<INSERT EPA VALUE>', 'MAP', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, programmer_comments)
values (4390, 'Gasoline (non-ethanol)', 'Gasoline (non-ethanol)', 'MAP', null);

--select substance from public.substances where inactive_flag is null and ust_flag is not null order by substance_group, substance;
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
Multiple products listed
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
--ust_piping.piping_style_id

--select distinct "PipingStyle" from as_ust."piping" where "PipingStyle" is not null order by 1;
/* Organization values are:

Presssure
Pressure
Suction
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, programmer_comments)
-- Choose MAP, EXCLUDE, or INTENTIONALLY_NULL before running this statement.
-- values (4395, 'Presssure', '<INSERT EPA VALUE>', 'MAP', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, programmer_comments)
values (4395, 'Pressure', 'Pressure', 'MAP', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, programmer_comments)
values (4395, 'Suction', 'Suction', 'MAP', null);

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
Siphon

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

--select distinct "PipingWallType" from as_ust."piping" where "PipingWallType" is not null order by 1;
/* Organization values are:

DW
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, mapping_action, programmer_comments)
-- Choose MAP, EXCLUDE, or INTENTIONALLY_NULL before running this statement.
-- values (4422, 'DW', '<INSERT EPA VALUE>', 'MAP', null);

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
where ust_control_id = 34 and epa_column_name = 'tank_material_description_id'
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

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
