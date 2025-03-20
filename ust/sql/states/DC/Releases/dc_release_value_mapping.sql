------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--state

--select distinct "State" from dc_release."release" where "State" is not null order by 1;
/* Organization values are:

DC
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (468, 'DC', 'DC', null);

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

--select distinct "Facility Type" from dc_release."release" where "Facility Type" is not null order by 1;
/* Organization values are:

Auto dealership/auto maintenance & repair
Bulk plant storage/petroleum distributor
Commercial
Contractor
Hospital (or other medical)
Industrial
Other
Railroad
Residential
Retail fuel sales (non-marina)
School
Trucking/transport/fleet operation
Unknown
Utility
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (470, 'Auto dealership/auto maintenance & repair', 'Auto dealership/auto maintenance & repair', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (470, 'Bulk plant storage/petroleum distributor', 'Bulk plant storage/petroleum distributor', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (470, 'Commercial', 'Commercial', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (470, 'Contractor', 'Contractor', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (470, 'Hospital (or other medical)', 'Hospital (or other medical)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (470, 'Industrial', 'Industrial', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (470, 'Other', 'Other', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (470, 'Railroad', 'Railroad', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (470, 'Residential', 'Residential', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (470, 'Retail fuel sales (non-marina)', 'Retail fuel sales (non-marina)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (470, 'School', 'School', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (470, 'Trucking/transport/fleet operation', 'Trucking/transport/fleet operation', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (470, 'Unknown', 'Unknown', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (470, 'Utility', 'Utility', null);

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

--select distinct "Coordinate Source" from dc_release."release" where "Coordinate Source" is not null order by 1;
/* Organization values are:

Geocoded address
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (473, 'Geocoded address', 'Geocoded address', null);

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

--select distinct "LUSTStatus" from dc_release."release" where "LUSTStatus" is not null order by 1;
/* Organization values are:

Active: general
No further action
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (474, 'Active: general', 'Active: general / open release', 'Mapped by ERG');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (474, 'No further action', 'No further action', null);

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
--substance_id

--select distinct "Substance Released1" from dc_release."release" where "Substance Released1" is not null order by 1;
/* Organization values are:

Diesel fuel (b-unknown)
Gasoline (unknown type)
Heating/fuel oil # unknown
Kerosene
Unknown
Wast/Used Oil
Waste/Used Oil
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (480, 'Diesel fuel (b-unknown)', 'Diesel fuel (b-unknown)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (480, 'Gasoline (unknown type)', 'Gasoline (unknown type)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (480, 'Heating/fuel oil # unknown', 'Heating/fuel oil # unknown', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (480, 'Kerosene', 'Kerosene', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (480, 'Unknown', 'Unknown', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (480, 'Wast/Used Oil', 'Used oil/waste oil', 'Mapped by ERG');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (480, 'Waste/Used Oil', 'Used oil/waste oil', 'Mapped by ERG');

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
from public.v_release_element_mapping
where epa_column_name = 'substance_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_lust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_lust_element_mapping
 * to do mapping, check public.substances to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--source_id

--select distinct "Source Of Release1" from dc_release."release" where "Source Of Release1" is not null order by 1;
/* Organization values are:

Dispenser
Other
Piping
Tank
Unknown
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (483, 'Dispenser', 'Dispenser', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (483, 'Other', 'Other', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (483, 'Piping', 'Piping', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (483, 'Tank', 'Tank', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (483, 'Unknown', 'Unknown', null);

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

--select distinct "Cause Of Release1" from dc_release."release" where "Cause Of Release1" is not null order by 1;
/* Organization values are:

Corrosion
Delivery overfill
Other
Unknown
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (484, 'Corrosion', 'Corrosion', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (484, 'Delivery overfill', 'Delivery overfill', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (484, 'Other', 'Other', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (484, 'Unknown', 'Unknown', null);

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

--select distinct "Corrective Action Strategy1" from dc_release."release" where "Corrective Action Strategy1" is not null order by 1;
/* Organization values are:

Excavation and hauling or treatment
Other
Pump and treat
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (485, 'Excavation and hauling or treatment', 'Excavation and hauling or treatment', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (485, 'Other', 'Other', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (485, 'Pump and treat', 'Pump and treat', null);

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
