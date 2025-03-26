------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--state

--select distinct "State" from ia_release."Template" where "State" is not null order by 1;
/* Organization values are:

IA
OH
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (437, 'IA', 'IA', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (437, 'OH', 'IA', null);

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

--select distinct "CoordinateSource" from ia_release."Template" where "CoordinateSource" is not null order by 1;
/* Organization values are:

Geocoded address
GPS
Map interpolation
Other
PLSS
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (443, 'Geocoded address', 'Geocoded address', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (443, 'GPS', 'GPS', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (443, 'Map interpolation', 'Map interpolation', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (443, 'Other', 'Other', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (443, 'PLSS', 'PLSS', null);

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

--select distinct "LUSTStatus" from ia_release."Template" where "LUSTStatus" is not null order by 1;
/* Organization values are:

Active: general
No further action
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (444, 'Active: general', 'Active: general / open release', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (444, 'No further action', 'No further action', null);

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

--select distinct "HowReleaseDetected" from ia_release."Template" where "HowReleaseDetected" is not null order by 1;
/* Organization values are:

At tank removal
Other
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (450, 'At tank removal', 'At tank removal', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (450, 'Other', 'Other', null);

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

--select distinct "source_id" from ia_release."v_source" where "source_id" is not null order by 1;
/* Organization values are:

Dispenser
Other
Piping
Submersible turbine pump
Tank
Unknown
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (456, 'Dispenser', 'Dispenser', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (456, 'Other', 'Other', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (456, 'Piping', 'Piping', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (456, 'Submersible turbine pump', 'Submersible turbine pump', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (456, 'Tank', 'Tank', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (456, 'Unknown', 'Unknown', null);

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

--select distinct "cause_id" from ia_release."v_cause" where "cause_id" is not null order by 1;
/* Organization values are:

Flex connector failure
Other
Overfill (general)
Piping failure
Spill bucket failure
Tank corrosion
Tank damage
Unknown
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (453, 'Flex connector failure', 'Flex connector failure', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (453, 'Other', 'Other', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (453, 'Overfill (general)', 'Overfill (general)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (453, 'Piping failure', 'Piping failure', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (453, 'Spill bucket failure', 'Spill bucket failure', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (453, 'Tank corrosion', 'Tank corrosion', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (453, 'Tank damage', 'Tank damage', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (453, 'Unknown', 'Unknown', null);

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
--corrective_action_strategy_id

--select distinct "corrective_action_strategy_id" from ia_release."v_corrective_action_strategy" where "corrective_action_strategy_id" is not null order by 1;
/* Organization values are:

Bio-remediation: Active
Bio-remediation: Passive
Groundwater Treatment: Air Sparging
Groundwater Treatment: Bioligical
Groundwater Treatment: Injection Nutrient(s)
Groundwater Treatment: Injection Oxygen
Groundwater Treatment: Injection Treated Groundwater
Groundwater Treatment: Other
Over-excavation:Land Application
Over-excavation:On-Site
Over-excavation:Other
Over-excavation:Sanitary Landfill
Over-excavation:Thru Over-excavation
Soil Venting:Active
Surface Treatment: Air Stripper
Surface Treatment: Biological
Surface Treatment: Carbon Absorbtion
Surface Treatment: Other
Surface Treatment: Other Aerate
Treated discharge to Sanitary Sewer
Treated discharge to Storm Sewer
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (454, 'Bio-remediation: Active', 'Bioventing', 'Please Verify');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (454, 'Bio-remediation: Passive', 'Bioventing', 'Please Verify');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (454, 'Groundwater Treatment: Air Sparging', 'Air sparging/bio sparging', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (454, 'Groundwater Treatment: Bioligical', 'Air sparging/bio sparging', 'Please Verify');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (454, 'Groundwater Treatment: Injection Nutrient(s)', 'Nutrient injection or placement in excavation', 'Please Verify');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (454, 'Groundwater Treatment: Injection Oxygen', 'Oxygen or oxydizer injection or placement in excavation', 'Please Verify');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (454, 'Groundwater Treatment: Injection Treated Groundwater', 'In-situ groundwater remediation', 'Please Verify');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (454, 'Groundwater Treatment: Other', 'Other', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (454, 'Over-excavation:Land Application', 'Excavation and hauling or treatment', 'Please Verify');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (454, 'Over-excavation:On-Site', 'Excavation and hauling or treatment', 'Please Verify');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (454, 'Over-excavation:Other', 'Excavation and hauling or treatment', 'Please Verify');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (454, 'Over-excavation:Sanitary Landfill', 'Excavation and hauling or treatment', 'Please Verify');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (454, 'Over-excavation:Thru Over-excavation', 'Excavation and hauling or treatment', 'Please Verify');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (454, 'Soil Venting:Active', 'Soil vapor extraction (SVE)', 'Please Verify');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (454, 'Surface Treatment: Air Stripper', 'Air stripping', 'Please Verify');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (454, 'Surface Treatment: Biological', 'Other', 'Please Verify');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (454, 'Surface Treatment: Carbon Absorbtion', 'Carbon injection or placement in excavation', 'Please Verify');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (454, 'Surface Treatment: Other', 'Other', 'Please Verify');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (454, 'Surface Treatment: Other Aerate', 'Other', 'Please Verify');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (454, 'Treated discharge to Sanitary Sewer', 'Other', 'Please Verify');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (454, 'Treated discharge to Storm Sewer', 'Other', 'Please Verify');

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
-- substance_id

insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (457, 'Kerosene', 'Kerosene', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (457, 'Gasoline', 'Gasoline (unknown type)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (457, 'Unknown', 'Unknown', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (457, 'Diesel', 'Diesel fuel (b-unknown)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (457, 'Other Petroleum', 'Petroleum product', 'Please Verify');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (457, 'Waste Oil', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (457, 'Hydraulic Oil', 'Hydraulic oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (457, 'Fuel Oil', 'Heating/fuel oil # unknown', 'Please Verify');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (457, 'Non-Petroleum Product', 'Other or mixture', 'Please Verify');