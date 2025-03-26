------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--owner_type_id

--select distinct "OwnerType" from il_ust."facility" where "OwnerType" is not null order by 1;
/* Organization values are:

Federal Government - Non Military
Local Government
Military
Private
State Government
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1958, 'Federal Government - Non Military', 'Federal Government - Non Military', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1958, 'Local Government', 'Local Government', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1958, 'Military', 'Military', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1958, 'Private', 'Private', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1958, 'State Government', 'State Government - Non Military', 'Mapped by ERG');

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
--facility_type1

--select distinct "FacilityType1" from il_ust."facility" where "FacilityType1" is not null order by 1;
/* Organization values are:

Agricultural/farm
Auto dealership/auto maintenance & repair
Aviation/airport (non-rental car)
Bulk plant storage/petroleum distributor
Commercial
Hospital (or other medical)
Industrial
Marina
Other
Railroad
Retail fuel sales (non-marina)
School
Trucking/transport/fleet operation
Utility
Wholesale
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1959, 'Agricultural/farm', 'Agricultural/farm', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1959, 'Auto dealership/auto maintenance & repair', 'Auto dealership/auto maintenance & repair', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1959, 'Aviation/airport (non-rental car)', 'Aviation/airport (non-rental car)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1959, 'Bulk plant storage/petroleum distributor', 'Bulk plant storage/petroleum distributor', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1959, 'Commercial', 'Commercial', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1959, 'Hospital (or other medical)', 'Hospital (or other medical)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1959, 'Industrial', 'Industrial', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1959, 'Marina', 'Marina', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1959, 'Other', 'Other', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1959, 'Railroad', 'Railroad', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1959, 'Retail fuel sales (non-marina)', 'Retail fuel sales (non-marina)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1959, 'School', 'School', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1959, 'Trucking/transport/fleet operation', 'Trucking/transport/fleet operation', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1959, 'Utility', 'Utility', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1959, 'Wholesale', 'Wholesale', null);

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
--facility_type2

--select distinct "FacilityType2" from il_ust."facility" where "FacilityType2" is not null order by 1;
/* Organization values are:

Airport
Attended Self-Service Station
Attended Self-Service/Unattended Self-Service
Auto Dealer
Bulk / Unattended Self-Service
Bulk Plant
City / Town
Commercial / Retail
Construction
County
Farm
Federal (Military)
Federal (Non-Military)
Fire Department
Full Service Station
Golf Course
Hospital
Industrial / Manufacturing
Landfill
Marina
Nuclear Power Station
Petroleum Distributor
Private Institution
Railway
School/College
State
Trucking Company
Unattended Self-Service Station
Utility
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1960, 'Airport', 'Aviation/airport (non-rental car)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1960, 'Attended Self-Service Station', 'Retail fuel sales (non-marina)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1960, 'Attended Self-Service/Unattended Self-Service', 'Retail fuel sales (non-marina)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1960, 'Auto Dealer', 'Auto dealership/auto maintenance & repair', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1960, 'Bulk / Unattended Self-Service', 'Retail fuel sales (non-marina)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1960, 'Bulk Plant', 'Bulk plant storage/petroleum distributor', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1960, 'City / Town', 'State/local government', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1960, 'Commercial / Retail', 'Commercial', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1960, 'Construction', 'Contractor', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1960, 'County', 'State/local government', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1960, 'Farm', 'Agricultural/farm', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1960, 'Federal (Military)', 'Military', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1960, 'Federal (Non-Military)', 'Federal government, non-military', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1960, 'Fire Department', 'Other', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1960, 'Full Service Station', 'Retail fuel sales (non-marina)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1960, 'Golf Course', 'Other', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1960, 'Hospital', 'Hospital (or other medical)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1960, 'Industrial / Manufacturing', 'Industrial', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1960, 'Landfill', 'Other', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1960, 'Marina', 'Marina', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1960, 'Nuclear Power Station', 'Utility', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1960, 'Petroleum Distributor', 'Bulk plant storage/petroleum distributor', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1960, 'Private Institution', 'Other', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1960, 'Railway', 'Railroad', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1960, 'School/College', 'School', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1960, 'State', 'State/local government', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1960, 'Trucking Company', 'Trucking/transport/fleet operation', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1960, 'Unattended Self-Service Station', 'Retail fuel sales (non-marina)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1960, 'Utility', 'Utility', null);

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
where epa_column_name = 'facility_type2'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check public.facility_types to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--facility_state

--select distinct " FacilityState" from il_ust."facility" where " FacilityState" is not null order by 1;
/* Organization values are:

IL
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1966, 'IL', 'IL', null);

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
--coordinate_source_id

--select distinct "FacilityCoordinateSource" from il_ust."facility" where "FacilityCoordinateSource" is not null order by 1;
/* Organization values are:

Geocoded address
Unknown
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1970, 'Geocoded address', 'Geocoded address', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1970, 'Unknown', 'Unknown', null);

--select coordinate_source from public.coordinate_sources;
/* Valid EPA values are:

Map interpolation
GPS
PLSS
Geocoded address
Other
Unknown

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'coordinate_source_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check public.coordinate_sources to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--tank_location_id

--select distinct "TankLocation" from il_ust."tank" where "TankLocation" is not null order by 1;
/* Organization values are:

Aboveground
Underground
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1989, 'Aboveground', 'Aboveground (tank bottom abovegrade)', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1989, 'Underground', 'Underground (entirely buried)', 'Mapped by ERG');

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
--tank_status_id

--select distinct "TankStatus" from il_ust."tank" where "TankStatus" is not null order by 1;
/* Organization values are:

Abandoned
Closed (removed from ground)
Currently in use
Other
Temporarily out of service
Unknown
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1990, 'Abandoned', 'Abandoned', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1990, 'Closed (removed from ground)', 'Closed (removed from ground)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1990, 'Currently in use', 'Currently in use', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1990, 'Other', 'Other', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1990, 'Temporarily out of service', 'Temporarily out of service', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1990, 'Unknown', 'Unknown', null);

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
--tank_material_description_id

--select distinct "TankMaterialDescription" from il_ust."tank" where "TankMaterialDescription" is not null order by 1;
/* Organization values are:

Asphalt coated or bare steel
Cathodically protected steel (without coating)
Coated and cathodically protected steel
Composite/clad(steel w/fiberglass reinforced plastic)
Fiberglass reinforced plastic
Jacketed steel
Other
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2042, 'Asphalt coated or bare steel', 'Asphalt coated or bare steel', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2042, 'Cathodically protected steel (without coating)', 'Cathodically protected steel (without coating)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2042, 'Coated and cathodically protected steel', 'Coated and cathodically protected steel', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2042, 'Composite/clad(steel w/fiberglass reinforced plastic)', 'Composite/clad (steel w/fiberglass reinforced plastic)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2042, 'Fiberglass reinforced plastic', 'Fiberglass reinforced plastic', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2042, 'Jacketed steel', 'Jacketed steel', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2042, 'Other', 'Other', null);

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
--tank_secondary_containment_id

--select distinct "TankSecondaryContainment" from il_ust."tank" where "TankSecondaryContainment" is not null order by 1;
/* Organization values are:

Double Wall
Other
Single Wall
Tank-within-a-tank retrofit (UL standard 1856
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2049, 'Double Wall', 'Double wall', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2049, 'Other', 'Other', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2049, 'Single Wall', 'Single wall', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2049, 'Tank-within-a-tank retrofit (UL standard 1856', 'Tank-within-a-tank retrofit (UL standard 1856)', 'Mapped by ERG');

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
--cert_of_installation

--select distinct "CertOfInstallation" from il_ust."tank" where "CertOfInstallation" is not null order by 1;
/* Organization values are:

Installer certified or licensed by the implementing agency
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2050, 'Installer certified or licensed by the implementing agency', 'Installer certified or licensed by the implementing agency', null);

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
where epa_column_name = 'cert_of_installation'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check public.cert_of_installations to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--substance_id

--select distinct "CompartmentSubstanceStored" from il_ust."compartment" where "CompartmentSubstanceStored" is not null order by 1;
/* Organization values are:

ASTM D975 diesel (known 100% renewable diesel)
Aviation gasoline
Denatured ethanol (98%)
Diesel blend containing 99% to less than 100% biodiesel
Diesel blends containing greater than 5% and up to 20% or less biodiesel
Diesel fuel (b-unknown)
Diesel fuel (known to contain 0% biodiesel)
E-85/Flex Fuel (E51-E83)
Ethanol blend gasoline (e-unknown)
Gasoline (non-ethanol)
Gasoline (unknown type)
Gasoline E-10 (E1-E10)
Gasoline E-15 (E-11-E15)
Hazardous substance
Heating oil/fuel oil 2
Heating oil/fuel oil 6
Heating/fuel oil # unknown
Jet fuel A
Kerosene
Lube/motor oil (new)
Off-road diesel/dyed diesel
Other or mixture
Other unlisted blend containing any other mixture of diesel, renewable diesel, or 20% biodiesel or less
Other unlisted blend containing any other mixture of diesel, renewable diesel, or more than 20% biodiesel
Racing fuel
Solvent
Unknown
Unknown aviation gas or jet fuel
Used oil/waste oil
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2054, 'ASTM D975 diesel (known 100% renewable diesel)', 'ASTM D975 diesel (known 100% renewable diesel)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2054, 'Aviation gasoline', 'Aviation gasoline', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2054, 'Denatured ethanol (98%)', 'Denatured ethanol (98%)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2054, 'Diesel blend containing 99% to less than 100% biodiesel', 'Diesel blend containing 99% to less than 100% biodiesel', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2054, 'Diesel blends containing greater than 5% and up to 20% or less biodiesel', 'Diesel blends containing greater than 5% and up to 20% or less biodiesel', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2054, 'Diesel fuel (b-unknown)', 'Diesel fuel (b-unknown)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2054, 'Diesel fuel (known to contain 0% biodiesel)', 'Diesel fuel (known to contain 0% biodiesel)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2054, 'E-85/Flex Fuel (E51-E83)', 'E-85/Flex Fuel (E51-E83)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2054, 'Ethanol blend gasoline (e-unknown)', 'Ethanol blend gasoline (e-unknown)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2054, 'Gasoline (non-ethanol)', 'Gasoline (non-ethanol)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2054, 'Gasoline (unknown type)', 'Gasoline (unknown type)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2054, 'Gasoline E-10 (E1-E10)', 'Gasoline E-10 (E1-E10)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2054, 'Gasoline E-15 (E-11-E15)', 'Gasoline E-15 (E-11-E15)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2054, 'Hazardous substance', 'Hazardous substance', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2054, 'Heating oil/fuel oil 2', 'Heating oil/fuel oil 2', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2054, 'Heating oil/fuel oil 6', 'Heating oil/fuel oil 6', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2054, 'Heating/fuel oil # unknown', 'Heating/fuel oil # unknown', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2054, 'Jet fuel A', 'Jet fuel A', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2054, 'Kerosene', 'Kerosene', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2054, 'Lube/motor oil (new)', 'Lube/motor oil (new)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2054, 'Off-road diesel/dyed diesel', 'Off-road diesel/dyed diesel', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2054, 'Other or mixture', 'Other or mixture', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2054, 'Other unlisted blend containing any other mixture of diesel, renewable diesel, or 20% biodiesel or less', 'Other unlisted blend containing any other mixture of diesel, renewable diesel, or 20% biodiesel or less', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2054, 'Other unlisted blend containing any other mixture of diesel, renewable diesel, or more than 20% biodiesel', 'Other unlisted blend containing any other mixture of diesel, renewable diesel, or more than 20% biodiesel', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2054, 'Racing fuel', 'Racing fuel', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2054, 'Solvent', 'Solvent', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2054, 'Unknown', 'Unknown', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2054, 'Unknown aviation gas or jet fuel', 'Unknown aviation gas or jet fuel', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2054, 'Used oil/waste oil', 'Used oil/waste oil', null);

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
--compartment_status_id

--select distinct "CompartmentStatus" from il_ust."compartment" where "CompartmentStatus" is not null order by 1;
/* Organization values are:

Abandoned
Closed (removed from ground)
Currently in use
Other
Temporarily out of service
Unknown
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2060, 'Abandoned', 'Abandoned', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2060, 'Closed (removed from ground)', 'Closed (removed from ground)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2060, 'Currently in use', 'Currently in use', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2060, 'Other', 'Other', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2060, 'Temporarily out of service', 'Temporarily out of service', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2060, 'Unknown', 'Unknown', null);

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
--spill_bucket_wall_type_id

--select distinct "SpillBucketWallType" from il_ust."compartment" where "SpillBucketWallType" is not null order by 1;
/* Organization values are:

Double
Single
Unknown
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2071, 'Double', 'Double', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2071, 'Single', 'Single', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2071, 'Unknown', 'Unknown', null);

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
--piping_style_id

--select distinct "PipingStyle" from il_ust."piping" where "PipingStyle" is not null order by 1;
/* Organization values are:

No piping
Non-operational (e.g., fill line, vent line, gravity)
Other
Pressure
Suction
Unknown
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2091, 'No piping', 'No piping', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2091, 'Non-operational (e.g., fill line, vent line, gravity)', 'Non-operational (e.g., fill line, vent line, gravity)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2091, 'Other', 'Other', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2091, 'Pressure', 'Pressure', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2091, 'Suction', 'Suction', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2091, 'Unknown', 'Unknown', null);

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
--pipe_tank_top_sump_wall_type_id

--select distinct "PipeTankTopSumpWallType" from il_ust."piping" where "PipeTankTopSumpWallType" is not null order by 1;
/* Organization values are:

Double
Single
Unknown
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2120, 'Double', 'Double', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2120, 'Single', 'Single', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2120, 'Unknown', 'Unknown', null);

--select pipe_tank_top_sump_wall_type from public.pipe_tank_top_sump_wall_types;
/* Valid EPA values are:

Single
Double
Unknown

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'pipe_tank_top_sump_wall_type_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check public.pipe_tank_top_sump_wall_types to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--piping_wall_type_id

--select distinct "PipingWallType" from il_ust."piping" where "PipingWallType" is not null order by 1;
/* Organization values are:

Double walled
Single walled
Unknown
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2121, 'Double walled', 'Double walled', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2121, 'Single walled', 'Single walled', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2121, 'Unknown', 'Other', 'Mapped by ERG');

--select piping_wall_type from public.piping_wall_types;
/* Valid EPA values are:

Single walled
Double walled
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
