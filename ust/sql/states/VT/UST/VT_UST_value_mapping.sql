------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--ust_facility.owner_type_id

--select distinct "FacilityType1" from vt_ust."facility" where "FacilityType1" is not null order by 1;
/* Organization values are:

Commercial
Municipal
Retail
Wombat
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1835, 'Commercial', 'Commercial', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1835, 'Municipal', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1835, 'Retail', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1835, 'Wombat', '', null);

--select owner_type from public.owner_types;
/* Valid EPA values are:

Federal Government - Non Military
State Government - Non Military
Local Government
Commercial
Private
Military
Other
Tribal Government

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

--select distinct "OwnerType" from vt_ust."facility" where "OwnerType" is not null order by 1;
/* Organization values are:

Bulk
Industrial/Commercial
Institutional
Retail
Service Station
State
Town
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1836, 'Bulk', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1836, 'Industrial/Commercial', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1836, 'Institutional', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1836, 'Retail', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1836, 'Service Station', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1836, 'State', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1836, 'Town', '', null);

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
Federal government, non-military
Military
State/local government

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

--select distinct "FacilityState" from vt_ust."facility" where "FacilityState" is not null order by 1;
/* Organization values are:

Vt
VT
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1841, 'Vt', 'VT', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1841, 'VT', 'VT', null);

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

--select distinct "TankLocation" from vt_ust."tank" where "TankLocation" is not null order by 1;
/* Organization values are:

Aboveground (tank bottom abovegrade)
Underground (entirely buried)
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1863, 'Aboveground (tank bottom abovegrade)', 'Aboveground (tank bottom abovegrade)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1863, 'Underground (entirely buried)', 'Underground (entirely buried)', null);

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

--select distinct "TankStatus" from vt_ust."tank" where "TankStatus" is not null order by 1;
/* Organization values are:

ACTIVE
ACTIVE PULLED
PULLED
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1864, 'ACTIVE', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1864, 'ACTIVE PULLED', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1864, 'PULLED', '', null);

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

--select distinct "TankMaterialDescription" from vt_ust."tank" where "TankMaterialDescription" is not null order by 1;
/* Organization values are:

Fiberglass jacketed steel
Fiberglass jacketed steel lined
Fiberglass reinforced plastic
Lined steel with impressed current system
Polyethylene jacketed steel
Polyethylene jacketed steel lined
Protected fiberthane steel tank
Protected steel
Protected steel fiberglass lined
Protected Steel Lined Supp anodes
Protected Steel with supplemental anodes
PSteel with impressed current
Unprotected Steel
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1873, 'Fiberglass jacketed steel', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1873, 'Fiberglass jacketed steel lined', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1873, 'Fiberglass reinforced plastic', 'Fiberglass reinforced plastic', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1873, 'Lined steel with impressed current system', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1873, 'Polyethylene jacketed steel', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1873, 'Polyethylene jacketed steel lined', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1873, 'Protected fiberthane steel tank', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1873, 'Protected steel', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1873, 'Protected steel fiberglass lined', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1873, 'Protected Steel Lined Supp anodes', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1873, 'Protected Steel with supplemental anodes', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1873, 'PSteel with impressed current', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1873, 'Unprotected Steel', '', null);

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

--select distinct "TankSecondaryContainment" from vt_ust."tank" where "TankSecondaryContainment" is not null order by 1;
/* Organization values are:

Double wall
Jacketed
Unknown
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1880, 'Double wall', 'Double wall', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1880, 'Jacketed', 'Jacketed', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1880, 'Unknown', 'Unknown', null);

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

--select distinct "CompartmentSubstanceStored" from vt_ust."compartment" where "CompartmentSubstanceStored" is not null order by 1;
/* Organization values are:

#6 fuel &/or waste veg oil
Additive
Aviation Fuel
Chemical
Diesel
Diesel/Fuel Oil
Diesel/Kerosene
Fuel Oil #2 or #4
Fuel Oil #5 or #6
Gasoline
Hydraulic Oil
Jet Fuel
Kerosene
Lube Oil
No product
Off Road Diesel
Other
Unknown
Used Oil
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3357, '#6 fuel &/or waste veg oil', 'Used oil/waste oil', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3357, 'Additive', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3357, 'Aviation Fuel', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3357, 'Chemical', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3357, 'Diesel', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3357, 'Diesel/Fuel Oil', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3357, 'Diesel/Kerosene', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3357, 'Fuel Oil #2 or #4', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3357, 'Fuel Oil #5 or #6', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3357, 'Gasoline', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3357, 'Hydraulic Oil', 'Hydraulic oil', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3357, 'Jet Fuel', 'Jet fuel A', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3357, 'Kerosene', 'Kerosene', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3357, 'Lube Oil', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3357, 'No product', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3357, 'Off Road Diesel', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3357, 'Other', 'Other or mixture', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3357, 'Unknown', 'Unknown', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3357, 'Used Oil', 'Used oil/waste oil', null);

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
Leaded gasoline
Racing fuel
Biofuel/bioheat
Heating oil/fuel oil 1
Heating oil/fuel oil 2
Heating oil/fuel oil 4
Heating oil/fuel oil 5
Heating oil/fuel oil 6
Heating/fuel oil # unknown
Hydraulic oil
Lube/motor oil (new)
Used oil/waste oil
Antifreeze
Denatured ethanol (98%)
Diesel exhaust fluid (DEF, not federally regulated)
Hazardous substance
Kerosene
Marine fuel
MTBE
Non-federally regulated substance (general)
Other or mixture
Petroleum product
Solvent
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

--select distinct "CompartmentStatus" from vt_ust."compartment" where "CompartmentStatus" is not null order by 1;
/* Organization values are:

ACTIVE
PULLED
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1888, 'ACTIVE', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1888, 'PULLED', '', null);

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
--ust_compartment.spill_bucket_wall_type_id

--select distinct "SpillBucketWallType" from vt_ust."compartment" where "SpillBucketWallType" is not null order by 1;
/* Organization values are:

Double-Walled
Single-Walled
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1900, 'Double-Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1900, 'Single-Walled', '', null);

--select spill_bucket_wall_type from public.spill_bucket_wall_types;
/* Valid EPA values are:

Single
Double
Unknown

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'spill_bucket_wall_type_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check public.spill_bucket_wall_types to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--ust_compartment_substance.substance_id

--select distinct "CompartmentSubstanceStored" from vt_ust."compartment" where "CompartmentSubstanceStored" is not null order by 1;
/* Organization values are:

#6 fuel &/or waste veg oil
Additive
Aviation Fuel
Chemical
Diesel
Diesel/Fuel Oil
Diesel/Kerosene
Fuel Oil #2 or #4
Fuel Oil #5 or #6
Gasoline
Hydraulic Oil
Jet Fuel
Kerosene
Lube Oil
No product
Off Road Diesel
Other
Unknown
Used Oil
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3358, '#6 fuel &/or waste veg oil', 'Used oil/waste oil', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3358, 'Additive', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3358, 'Aviation Fuel', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3358, 'Chemical', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3358, 'Diesel', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3358, 'Diesel/Fuel Oil', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3358, 'Diesel/Kerosene', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3358, 'Fuel Oil #2 or #4', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3358, 'Fuel Oil #5 or #6', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3358, 'Gasoline', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3358, 'Hydraulic Oil', 'Hydraulic oil', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3358, 'Jet Fuel', 'Jet fuel A', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3358, 'Kerosene', 'Kerosene', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3358, 'Lube Oil', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3358, 'No product', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3358, 'Off Road Diesel', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3358, 'Other', 'Other or mixture', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3358, 'Unknown', 'Unknown', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3358, 'Used Oil', 'Used oil/waste oil', null);

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
Leaded gasoline
Racing fuel
Biofuel/bioheat
Heating oil/fuel oil 1
Heating oil/fuel oil 2
Heating oil/fuel oil 4
Heating oil/fuel oil 5
Heating oil/fuel oil 6
Heating/fuel oil # unknown
Hydraulic oil
Lube/motor oil (new)
Used oil/waste oil
Antifreeze
Denatured ethanol (98%)
Diesel exhaust fluid (DEF, not federally regulated)
Hazardous substance
Kerosene
Marine fuel
MTBE
Non-federally regulated substance (general)
Other or mixture
Petroleum product
Solvent
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

--select distinct "PipingStyle" from vt_ust."piping" where "PipingStyle" is not null order by 1;
/* Organization values are:

Non-Operational
Pressure
Suction
Unknown
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1920, 'Non-Operational', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1920, 'Pressure', 'Pressure', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1920, 'Suction', 'Suction', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1920, 'Unknown', 'Unknown', null);

--select piping_style from public.piping_styles;
/* Valid EPA values are:

Suction
Pressure
Hydrant
Non-operational (e.g., fill line, vent line, gravity)
Other
Unknown
No piping

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
where ust_control_id = 26 and epa_column_name = 'tank_material_description_id'
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
