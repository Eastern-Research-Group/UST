------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--ust_facility.owner_type_id

--select distinct "Owner Type:" from hi_ust."tblContactAffiliation" where "Owner Type:" is not null order by 1;
/* Organization values are:

Corporation
Corporation, Authorized Representive
Corporation, Principal Executive Officer
Federal Government, Military
Govt Entity, Authorized Employee
Govt Entity, Principal Executive Officer
Govt Entity, Ranking Elected Official
Kahului Service, Inc. DBA Lloyd's Kahului Chevron
Local Government
Marketer
Mauna Kea Resort
Non-Marketer
Oahu Country Club
Owner - UST Conversio
Owner - UST Conversion
Partnership, General Partner
Servco Pacific Inc. DBA Vehicle Processing Center
Sole Proprietorship, Proprietor
State Government
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3107, 'Corporation', 'Commercial', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3107, 'Corporation, Authorized Representive', 'Commercial', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3107, 'Corporation, Principal Executive Officer', 'Commercial', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3107, 'Federal Government, Military', 'Military', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3107, 'Govt Entity, Authorized Employee', 'Federal Government - Non Military', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3107, 'Govt Entity, Principal Executive Officer', 'Federal Government - Non Military', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3107, 'Govt Entity, Ranking Elected Official', 'Federal Government - Non Military', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3107, 'Kahului Service, Inc. DBA Lloyd''s Kahului Chevron', 'Commercial', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3107, 'Local Government', 'Local Government', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3107, 'Marketer', 'Other', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3107, 'Mauna Kea Resort', 'Commercial', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3107, 'Non-Marketer', 'Other', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3107, 'Oahu Country Club', 'Commercial', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3107, 'Owner - UST Conversio', 'Other', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3107, 'Owner - UST Conversion', 'Other', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3107, 'Partnership, General Partner', 'Other', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3107, 'Servco Pacific Inc. DBA Vehicle Processing Center', 'Commercial', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3107, 'Sole Proprietorship, Proprietor', 'Commercial', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3107, 'State Government', 'State Government - Non Military', 'Please Verify; Mapped by ERG');

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

--select distinct "Facility Description" from hi_ust."tblFacility" where "Facility Description" is not null order by 1;
/* Organization values are:

Air Taxi (Airline)
Aircraft Owner
Airline
Auto Dealership
Baseyard
Car Rental
Cleaner Laundromat
Commercial
Communication Site
Contractor
Farm
Federal Military
Federal Non-Military
fire station
Fire Station
Gas Station
Golf Course
Hospital
Industrial
Local Government
Not Listed
Other
OTHER
Petroleum Distributor
Police Station
Railroad
Residential
RESIDENTIAL
Resort Hotel
School
Service Center
State Government
Truck/Transporter
Trucking Transporter
Utilities
Utility
Wastewater Plant
Wholesaler Retailer
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3108, 'Air Taxi (Airline)', 'Aviation/airport (non-rental car)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3108, 'Aircraft Owner', 'Aviation/airport (non-rental car)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3108, 'Airline', 'Aviation/airport (non-rental car)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3108, 'Auto Dealership', 'Auto dealership/auto maintenance & repair', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3108, 'Baseyard', 'Other', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3108, 'Car Rental', 'Rental Car', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3108, 'Cleaner Laundromat', 'Commercial', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3108, 'Commercial', 'Commercial', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3108, 'Communication Site', 'Telecommunication facility', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3108, 'Contractor', 'Contractor', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3108, 'Farm', 'Agricultural/farm', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3108, 'Federal Military', 'Military', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3108, 'Federal Non-Military', 'Federal government, non-military', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3108, 'fire station', 'State/local government', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3108, 'Fire Station', 'State/local government', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3108, 'Gas Station', 'Retail fuel sales (non-marina)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3108, 'Golf Course', 'Other', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3108, 'Hospital', 'Hospital (or other medical)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3108, 'Industrial', 'Industrial', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3108, 'Local Government', 'State/local government', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3108, 'Not Listed', 'Other', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3108, 'Other', 'Other', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3108, 'OTHER', 'Other', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3108, 'Petroleum Distributor', 'Bulk plant storage/petroleum distributor', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3108, 'Police Station', 'State/local government', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3108, 'Railroad', 'Railroad', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3108, 'Residential', 'Residential', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3108, 'RESIDENTIAL', 'Residential', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3108, 'Resort Hotel', 'Commercial', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3108, 'School', 'School', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3108, 'Service Center', 'Auto dealership/auto maintenance & repair', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3108, 'State Government', 'State/local government', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3108, 'Truck/Transporter', 'Trucking/transport/fleet operation', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3108, 'Trucking Transporter', 'Trucking/transport/fleet operation', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3108, 'Utilities', 'Utility', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3108, 'Utility', 'Utility', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3108, 'Wastewater Plant', 'Utility', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3108, 'Wholesaler Retailer', 'Wholesale', 'Mapped by ERG');

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

--select distinct "State" from hi_ust."tlkpZIP" where "State" is not null order by 1;
/* Organization values are:

AB
AK
AL
AR
AZ
BC
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
MB
MD
ME
MH
MI
MN
MO
MP
MS
MT
NB
NC
ND
NE
NF
NH
NJ
NM
NS
NT
NV
NY
OH
OK
ON
OR
PA
PE
PQ
PR
PW
RI
SC
SD
SK
TN
TX
UT
VA
VI
VT
WA
WI
WV
WY
XX
YT
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */

insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'AK', 'AK', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'AL', 'AL', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'AR', 'AR', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'AZ', 'AZ', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'CA', 'CA', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'CO', 'CO', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'CT', 'CT', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'DC', 'DC', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'DE', 'DE', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'FL', 'FL', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'GA', 'GA', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'GU', 'GU', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'HI', 'HI', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'IA', 'IA', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'ID', 'ID', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'IL', 'IL', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'IN', 'IN', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'KS', 'KS', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'KY', 'KY', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'LA', 'LA', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'MA', 'MA', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'MD', 'MD', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'ME', 'ME', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'MI', 'MI', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'MN', 'MN', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'MO', 'MO', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'MP', 'MP', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'MS', 'MS', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'MT', 'MT', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'NC', 'NC', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'ND', 'ND', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'NE', 'NE', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'NH', 'NH', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'NJ', 'NJ', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'NM', 'NM', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'NV', 'NV', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'NY', 'NY', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'OH', 'OH', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'OK', 'OK', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'OR', 'OR', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'PA', 'PA', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'PR', 'PR', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'RI', 'RI', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'SC', 'SC', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'SD', 'SD', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'TN', 'TN', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'TX', 'TX', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'UT', 'UT', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'VA', 'VA', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'VI', 'VI', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'VT', 'VT', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'WA', 'WA', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'WI', 'WI', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'WV', 'WV', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3113, 'WY', 'WY', null);

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
--ust_facility.coordinate_source_id

--select distinct "HorizontalCollectionMethodName" from hi_ust."tblFacility" where "HorizontalCollectionMethodName" is not null order by 1;
/* Organization values are:

address Matching
Address Matching
Adress Matching
GPS
Map
On Base
Zip Code
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3116, 'address Matching', 'Geocoded address', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3116, 'Address Matching', 'Geocoded address', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3116, 'Adress Matching', 'Geocoded address', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3116, 'GPS', 'GPS', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3116, 'Map', 'Geocoded address', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3116, 'On Base', 'Other', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3116, 'Zip Code', 'Other', null);

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
--ust_tank.tank_status_id

--select distinct "TankStatusDesc" from hi_ust."tblTank" where "TankStatusDesc" is not null order by 1;
/* Organization values are:

Currently in Use
Currently In Use
Not installed
Permanently out of Use
Permanently Out of Use
PERMANENTLY OUT OF USE
Temporarily out of Use
Temporarily Out of Use
To be installed
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3134, 'Currently in Use', 'Currently in use', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3134, 'Currently In Use', 'Currently in use', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3134, 'Permanently out of Use', 'Closed (general)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3134, 'Permanently Out of Use', 'Closed (general)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3134, 'PERMANENTLY OUT OF USE', 'Closed (general)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3134, 'Temporarily out of Use', 'Temporarily out of service', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3134, 'Temporarily Out of Use', 'Temporarily out of service', 'Mapped by ERG');

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

--select distinct "TankMatDesc" from hi_ust."tblTank" where "TankMatDesc" is not null order by 1;
/* Organization values are:

Asphalt Coated or Bare Steel
Bare Steel
Cathodically Protected Steel
Composite (Steel w/ FRP)
Concrete
Epoxy Coated Steel
Fiberglass Reinforced Plastic
Not Listed
Other
Polyethylene Tank Jacket
Unknown
UNKNOWN
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3141, 'Asphalt Coated or Bare Steel', 'Asphalt coated or bare steel', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3141, 'Bare Steel', 'Asphalt coated or bare steel', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3141, 'Cathodically Protected Steel', 'Cathodically protected steel (without coating)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3141, 'Composite (Steel w/ FRP)', 'Composite/clad (steel w/fiberglass reinforced plastic)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3141, 'Concrete', 'Concrete', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3141, 'Epoxy Coated Steel', 'Epoxy coated steel', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3141, 'Fiberglass Reinforced Plastic', 'Fiberglass reinforced plastic', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3141, 'Not Listed', 'Other', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3141, 'Other', 'Other', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3141, 'Polyethylene Tank Jacket', 'Other', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3141, 'Unknown', 'Unknown', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3141, 'UNKNOWN', 'Unknown', null);

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

--select distinct "TankModsDesc" from hi_ust."tblTank" where "TankModsDesc" is not null order by 1;
/* Organization values are:

Double-Walled
Excavation Liner
Lined Interior
NONE
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3146, 'Double-Walled', 'Double wall', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3146, 'Excavation Liner', 'Excavation liner', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3146, 'Lined Interior', 'Excavation liner', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3146, 'NONE', 'Other', 'Mapped by ERG');

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

--select distinct "SubstanceDesc" from hi_ust."tblTank" where "SubstanceDesc" is not null order by 1;
/* Organization values are:

Diesel
DIESEL
Gasohol
Gasoline
GASOLINE
Hazardous Substance
Heating Oil
Kerosene
Mixture
Not Listed
Other
Unknown
Used Oil
USED OIL
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3150, 'Diesel', 'Diesel fuel (b-unknown)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3150, 'DIESEL', 'Diesel fuel (b-unknown)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3150, 'Gasohol', 'Ethanol blend gasoline (e-unknown)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3150, 'Gasoline', 'Gasoline (unknown type)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3150, 'GASOLINE', 'Gasoline (unknown type)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3150, 'Hazardous Substance', 'Hazardous substance', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3150, 'Heating Oil', 'Heating/fuel oil # unknown', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3150, 'Kerosene', 'Kerosene', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3150, 'Mixture', 'Other or mixture', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3150, 'Not Listed', 'Other or mixture', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3150, 'Other', 'Other or mixture', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3150, 'Unknown', 'Unknown', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3150, 'Used Oil', 'Used oil/waste oil', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3150, 'USED OIL', 'Used oil/waste oil', null);

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

/*
HI does not report at the Compartment level, but CompartmentStatus is required.

Copy the tank status mapping down to the compartment!
The lookup tables for compartment_statuses and tank_stasuses are the same.
 */

--select distinct "TankStatusDesc" from hi_ust."tblTank" where "TankStatusDesc" is not null order by 1;
/* Organization values are:

Currently in Use
Currently In Use
Not installed
Permanently out of Use
Permanently Out of Use
PERMANENTLY OUT OF USE
Temporarily out of Use
Temporarily Out of Use
To be installed
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3154, 'Currently in Use', 'Currently in use', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3154, 'Currently In Use', 'Currently in use', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3154, 'Permanently out of Use', 'Closed (general)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3154, 'Permanently Out of Use', 'Closed (general)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3154, 'PERMANENTLY OUT OF USE', 'Closed (general)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3154, 'Temporarily out of Use', 'Temporarily out of service', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3154, 'Temporarily Out of Use', 'Temporarily out of service', null);

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

--select distinct "PipeTypeDesc" from hi_ust."tblTank" where "PipeTypeDesc" is not null order by 1;
/* Organization values are:

Gravity Feed
Not Listed
Pressurized
Safe Suction
SAFE SUCTION
U.S. Suction
U.S. SUCTION
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3172, 'Gravity Feed', 'Non-operational (e.g., fill line, vent line, gravity)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3172, 'Not Listed', 'Other', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3172, 'Pressurized', 'Pressure', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3172, 'Safe Suction', 'Suction', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3172, 'SAFE SUCTION', 'Suction', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3172, 'U.S. Suction', 'Suction', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3172, 'U.S. SUCTION', 'Suction', null);

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
--ust_piping.piping_wall_type_id

--select distinct "PipeModDesc" from hi_ust."tblTank" where "PipeModDesc" is not null order by 1;
/* Organization values are:

Cathodically Protected
Double-Walled
NONE
Secondary Containment
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3175, 'Cathodically Protected', 'Other', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3175, 'Double-Walled', 'Double walled', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3175, 'NONE', 'Other', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3175, 'Secondary Containment', 'Other', null);

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
where ust_control_id = 37 and epa_column_name = 'tank_material_description_id'
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
