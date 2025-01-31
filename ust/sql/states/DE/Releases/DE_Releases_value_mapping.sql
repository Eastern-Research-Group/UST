------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--state

--select distinct "State" from de_release."Template" where "State" is not null order by 1;
/* Organization values are:

DE
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (496, 'DE', 'DE', null);

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
--coordinate_source_id

--select distinct "CoordinateSource" from de_release."Template" where "CoordinateSource" is not null order by 1;
/* Organization values are:

Map interpolation
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (497, 'Map interpolation', 'Map interpolation', null);

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

--select distinct "LUSTStatus" from de_release."Template" where "LUSTStatus" is not null order by 1;
/* Organization values are:

Active
Cross-referenced
Inactive
Investigation
Monitoring
Refer
Remediation
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (504, 'Active', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (504, 'Cross-referenced', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (504, 'Inactive', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (504, 'Investigation', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (504, 'Monitoring', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (504, 'Refer', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (504, 'Remediation', '', null);

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
--release_discovered_id

--select distinct "HowReleaseDetected" from de_release."Template" where "HowReleaseDetected" is not null order by 1;
/* Organization values are:

Compliance Inspection
Discovered during construction activities
EPRB referral
Equipment failure
Inventory control
Observation
Offsite Impact
Referral from SIRB
Removal/Abandonment
Retrofit sampling
Site investigation
Stage II testing
Tank or line testing
Unknown
Unkown
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (509, 'Compliance Inspection', 'Compliance inspection', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (509, 'Discovered during construction activities', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (509, 'EPRB referral', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (509, 'Equipment failure', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (509, 'Inventory control', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (509, 'Observation', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (509, 'Offsite Impact', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (509, 'Referral from SIRB', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (509, 'Removal/Abandonment', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (509, 'Retrofit sampling', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (509, 'Site investigation', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (509, 'Stage II testing', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (509, 'Tank or line testing', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (509, 'Unknown', 'Unknown', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (509, 'Unkown', '', null);

--select release_discovered from public.release_discovered;
/* Valid EPA values are:

At tank system closure/removal
Off-site impact/third party (general)
Third-party drinking well
Vapor intrusion
Surface or storm water discharge, impact to utilities
Environmental assessment
Compliance inspection
Overfill
Automatic Tank Gauging (ATG)
Groundwater monitoring
Interstitial monitoring
Statistical Inventory Reconciliation (SIR)
Tank tightness testing
Vapor monitoring
Other
Unknown

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_release_element_mapping
where epa_column_name = 'release_discovered_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_lust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_lust_element_mapping
 * to do mapping, check public.release_discovered to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--source_id

--select distinct "SourceOfRelease1" from de_release."Template" where "SourceOfRelease1" is not null order by 1;
/* Organization values are:

Delivery problem
Dispenser
Fill Port Spill Bucket
Other
Piping
STP Sump
Submersible turbine pump
Tank
Unknown
Unknown source
Vapor Recovery Containment
Vent/vapor line
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (513, 'Delivery problem', 'Delivery problem', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (513, 'Dispenser', 'Dispenser', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (513, 'Fill Port Spill Bucket', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (513, 'Other', 'Other', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (513, 'Piping', 'Piping', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (513, 'STP Sump', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (513, 'Submersible turbine pump', 'Submersible turbine pump', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (513, 'Tank', 'Tank', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (513, 'Unknown', 'Unknown', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (513, 'Unknown source', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (513, 'Vapor Recovery Containment', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (513, 'Vent/vapor line', '', null);

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

--select distinct "CauseOfRelease1" from de_release."Template" where "CauseOfRelease1" is not null order by 1;
/* Organization values are:

Corrosion
Equipment Failure
Install problem
Other
Overfill
Physical or mechanical damage
Spill
Unknown
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (515, 'Corrosion', 'Corrosion', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (515, 'Equipment Failure', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (515, 'Install problem', 'Install problem', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (515, 'Other', 'Other', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (515, 'Overfill', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (515, 'Physical or mechanical damage', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (515, 'Spill', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (515, 'Unknown', 'Unknown', null);

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
Physical/mechanical damage
Historical

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
--corrective_action_strategy_id

--select distinct "CorrectiveActionStrategy1" from de_release."Template" where "CorrectiveActionStrategy1" is not null order by 1;
/* Organization values are:

Air Sparge
Excavation
Free Product Recovery
Groundwater Pumping
In-Situ Chemical Treatment - Other
Monitored Natural Attenuation
Multiphase Extraction
Other - Specify in Comments
Ozone Sparge
Soil Vapor Extraction
Vacuum Truck
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (517, 'Air Sparge', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (517, 'Excavation', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (517, 'Free Product Recovery', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (517, 'Groundwater Pumping', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (517, 'In-Situ Chemical Treatment - Other', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (517, 'Monitored Natural Attenuation', 'Monitored natural attenuation', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (517, 'Multiphase Extraction', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (517, 'Other - Specify in Comments', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (517, 'Ozone Sparge', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (517, 'Soil Vapor Extraction', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (517, 'Vacuum Truck', '', null);

--select corrective_action_strategy from public.corrective_action_strategies;
/* Valid EPA values are:

Air sparging/bio sparging
Air stripping
Alternative drinking water
Barrier wall - slurry wall, solid, or oleophobic
Bioventing
Capping
Carbon injection or placement in excavation
Chemical oxidation
Enclosed space pressurization
Enhanced anaerobic oxidative bioremediation
Excavation and hauling or treatment
In-situ groundwater remediation
LNAPL skimming
Monitored natural attenuation
Multi/dual-phase extraction (MPE)
Natural source zone depletion
Nutrient injection or placement in excavation
Oxidizer moitoring well socks
Oxygen or oxydizer injection or placement in excavation
Passive or bail product recovery
Point of use water treatment
Pump and treat
Soil vapor extraction (SVE)
Sub sealing/sub slab barrier
Subslab venting
Sulfate injection or surface placement
Surfactant injection
Treatment wall
Vacuum vaporizing well (UVB, ART)
Other
Unknown

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_release_element_mapping
where epa_column_name = 'corrective_action_strategy_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_lust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_lust_element_mapping
 * to do mapping, check public.corrective_action_strategies to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
