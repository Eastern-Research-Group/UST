------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--state

--select distinct "State" from hi_release."release" where "State" is not null order by 1;
/* Organization values are:

HI
XX
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (397, 'HI', 'HI', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (397, 'XX', 'HI', null);

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
from public.v_release_element_mapping
where epa_column_name = 'state'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_lust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_lust_element_mapping
 * to do mapping, check public.states to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--facility_type_id

--select distinct "FacilityType" from hi_release."release" where "FacilityType" is not null order by 1;
/* Organization values are:

Air Taxi (Airline)
Aircraft Owner
Airline
Auto Dealership
Baseyard
Car Rental
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
Petroleum Distributor
Police Station
Railroad
Residential
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
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (407, 'Air Taxi (Airline)', 'Aviation/airport (non-rental car)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (407, 'Aircraft Owner', 'Aviation/airport (non-rental car)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (407, 'Airline', 'Aviation/airport (non-rental car)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (407, 'Auto Dealership', 'Auto dealership/auto maintenance & repair', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (407, 'Baseyard', 'Other', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (407, 'Car Rental', 'Rental Car', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (407, 'Commercial', 'Commercial', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (407, 'Communication Site', 'Telecommunication facility', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (407, 'Contractor', 'Contractor', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (407, 'Farm', 'Agricultural/farm', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (407, 'Federal Military', 'Military', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (407, 'Federal Non-Military', 'Federal government, non-military', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (407, 'fire station', 'Other', 'Please Verify');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (407, 'Fire Station', 'Other', 'Please Verify');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (407, 'Gas Station', 'Retail fuel sales (non-marina)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (407, 'Golf Course', 'Other', 'Please Verify');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (407, 'Hospital', 'Hospital (or other medical)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (407, 'Industrial', 'Industrial', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (407, 'Local Government', 'State/local government', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (407, 'Not Listed', 'Unknown', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (407, 'Other', 'Other', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (407, 'Petroleum Distributor', 'Bulk plant storage/petroleum distributor', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (407, 'Police Station', 'Other', 'Please Verify');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (407, 'Railroad', 'Railroad', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (407, 'Residential', 'Residential', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (407, 'Resort Hotel', 'Commercial', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (407, 'School', 'School', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (407, 'Service Center', 'Auto dealership/auto maintenance & repair', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (407, 'State Government', 'State/local government', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (407, 'Truck/Transporter', 'Trucking/transport/fleet operation', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (407, 'Trucking Transporter', 'Trucking/transport/fleet operation', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (407, 'Utilities', 'Utility', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (407, 'Utility', 'Utility', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (407, 'Wastewater Plant', 'Utility', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (407, 'Wholesaler Retailer', 'Wholesale', null);

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
from public.v_release_element_mapping
where epa_column_name = 'facility_type_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_lust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_lust_element_mapping
 * to do mapping, check public.facility_types to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--coordinate_source_id

--select distinct "HorizontalCollectionMethodName" from hi_release."release" where "HorizontalCollectionMethodName" is not null order by 1;
/* Organization values are:

address Matching
Address Matching
GPS
Map
On Base
Zip Code
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (401, 'address Matching', 'Geocoded address', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (401, 'Address Matching', 'Geocoded address', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (401, 'GPS', 'GPS', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (401, 'Map', 'Map interpolation', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (401, 'On Base', 'Other', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (401, 'Zip Code', 'Other', null);

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
from public.v_release_element_mapping
where epa_column_name = 'coordinate_source_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_lust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_lust_element_mapping
 * to do mapping, check public.coordinate_sources to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--release_status_id

--select distinct "LUSTLatestStatus" from hi_release."release" where "LUSTLatestStatus" is not null order by 1;
/* Organization values are:

Active Remediation
Case Transferred to HEER (DERA)
Case Transferred to HEER (regulated)
Case Transferred to HW (unregulated)
Confirmed Release
Consolidated releases
Exposure Prevention Management Plan
LUST Cleanup Initiated
Monitored Natural Attenuation
Remedy Decision Pending (ongoing monitoring)
Site Assessment Completed (delineated)
Site Assessment Ongoing
Site Cleanup Completed (NFA)
Site Cleanup Completed (NFA) with Restrictions
Site Cleanup Completed with EHE
Site Cleanup Completed with EHE/EHMP
Site Cleanup Completed with EHMP
Soil Vapor Sampling
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (402, 'Active Remediation', 'Active: corrective action', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (402, 'Case Transferred to HEER (DERA)', 'Other', 'lease Verify');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (402, 'Case Transferred to HEER (regulated)', 'Other', 'Please Verify');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (402, 'Case Transferred to HW (unregulated)', 'Other', 'Please Verify');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (402, 'Confirmed Release', 'Active: general / open release', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (402, 'Consolidated releases', 'Active: general / open release', 'Please Verify');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (402, 'Exposure Prevention Management Plan', 'Active: site investigation', 'Please Verify');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (402, 'LUST Cleanup Initiated', 'Active: corrective action', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (402, 'Monitored Natural Attenuation', 'Active: post corrective action monitoring', 'Please Verify');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (402, 'Remedy Decision Pending (ongoing monitoring)', 'Active: site investigation', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (402, 'Site Assessment Completed (delineated)', 'Active: site investigation', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (402, 'Site Assessment Ongoing', 'Active: site investigation', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (402, 'Site Cleanup Completed (NFA)', 'No further action', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (402, 'Site Cleanup Completed (NFA) with Restrictions', 'No further action', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (402, 'Site Cleanup Completed with EHE', 'Active: post corrective action monitoring', 'Please Verify');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (402, 'Site Cleanup Completed with EHE/EHMP', 'Active: post corrective action monitoring', 'Please Verify');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (402, 'Site Cleanup Completed with EHMP', 'Active: post corrective action monitoring', 'Please Verify');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (402, 'Soil Vapor Sampling', 'Active: post corrective action monitoring', 'Please Verify');

--select release_status from public.release_statuses;
/* Valid EPA values are:

Active: post corrective action monitoring
Active: corrective action
Active: site investigation
Active: stalled
No further action
Unknown
Other
Active: general / open release

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_release_element_mapping
where epa_column_name = 'release_status_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_lust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_lust_element_mapping
 * to do mapping, check public.release_statuses to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--how_release_detected_id

--select distinct "HowReleaseDetected" from hi_release."release" where "HowReleaseDetected" is not null order by 1;
/* Organization values are:

Baseline Site Assessment
closure
Leak Detection
Off-site Discovery
Other
Tank Removal
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (405, 'Baseline Site Assessment', 'Inspection', 'Or Environmental audit, Please verify');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (405, 'closure', 'Other', 'Please Verify');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (405, 'Leak Detection', 'Other', 'Please Verify');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (405, 'Off-site Discovery', 'Third party (well water, vapor intrusion, etc.)', 'mapping was used during pilot');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (405, 'Other', 'Other', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (405, 'Tank Removal', 'At tank removal', null);

--select how_release_detected from public.how_release_detected;
/* Valid EPA values are:

At tank removal
GW monitoring well
Inspection
Interstial monitor
Overfill alarm
Statistical Inventory Reconciliation (SIR)
Tank tightness testing
Third party (well water, vapor intrusion, etc.)
Vapor monitoring
Visual (overfill)
Other
Unknown
Environmental audit

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_release_element_mapping
where epa_column_name = 'how_release_detected_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_lust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_lust_element_mapping
 * to do mapping, check public.how_release_detected to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--source_id

--select distinct "SourceOfRelease1" from hi_release."release" where "SourceOfRelease1" is not null order by 1;
/* Organization values are:

Delivery
Dispenser
Other
Piping
Submersible Turbine Pump
Tank
Unknown
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (410, 'Delivery', 'Delivery problem', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (410, 'Dispenser', 'Dispenser', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (410, 'Other', 'Other', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (410, 'Piping', 'Piping', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (410, 'Submersible Turbine Pump', 'Submersible turbine pump', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (410, 'Tank', 'Tank', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (410, 'Unknown', 'Unknown', null);

--select source from public.sources;
/* Valid EPA values are:

Dispenser
Piping
Submersible turbine pump
Tank
Other
Unknown
Delivery problem

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_release_element_mapping
where epa_column_name = 'source_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_lust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_lust_element_mapping
 * to do mapping, check public.sources to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--cause_id

--select distinct "CauseOfRelease1" from hi_release."release" where "CauseOfRelease1" is not null order by 1;
/* Organization values are:

Corrosion
Install Problem
Leaking Piping
Leaking Tank
Leaking Tank and Piping
Other
Overfill
Phys/Mech Damage
Spill
Unknown
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (408, 'Corrosion', 'Corrosion', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (408, 'Install Problem', 'Install problem', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (408, 'Leaking Piping', 'Piping failure', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (408, 'Leaking Tank', 'Tank damage', 'Please Verify');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (408, 'Leaking Tank and Piping', 'General spill', 'Please Verify');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (408, 'Other', 'Other', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (408, 'Overfill', 'Overfill (general)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (408, 'Phys/Mech Damage', 'Physical/mechnical damage', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (408, 'Spill', 'General spill', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (408, 'Unknown', 'Unknown', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (408, 'Unknown', 'Unknown', 'mapped by ERG');

--select cause from public.causes;
/* Valid EPA values are:

Corrosion
Damage to dispenser
Damage to dispenser hose
Delivery overfill
Dispenser spill
Dope/sealant
Flex connector failure
Human error
Motor vehicle accident
Overfill (general)
Piping failure
Shear valve failure
Spill bucket failure
Tank corrosion
Tank damage
Tank removal
Weather/natural disaster (i.e., hurricane, flooding, fire, earthquake)
Other
Unknown
Install problem
General spill
Physical/mechnical damage

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_release_element_mapping
where epa_column_name = 'cause_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_lust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_lust_element_mapping
 * to do mapping, check public.causes to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
