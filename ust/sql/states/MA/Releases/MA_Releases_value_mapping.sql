------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--ust_release.state

--select distinct "State" from ma_release."vw_releases" where "State" is not null order by 1;
/* Organization values are:

MA
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (542, 'MA', 'MA', null);

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
--ust_release.facility_type_id

--select distinct "FACILITY TYPE" from ma_release."vw_releases" where "FACILITY TYPE" is not null order by 1;
/* Organization values are:

Auto dealership/auto maintenance & repair
Aviation/airport (non-rental car)
Bulk plant storage/petroleum distributor
Commercial
Federally owned
Hospital (or other medical)
Industrial
Marina
Other
Railroad
Rental car
Residential
RESIDENTIAL
Retail fuel sales (non-marina)
School
Telecommunication facility
Trucking/transport/fleet operation
Unknown
Utility
Wholesale
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (591, 'Auto dealership/auto maintenance & repair', 'Auto dealership/auto maintenance & repair', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (591, 'Aviation/airport (non-rental car)', 'Aviation/airport (non-rental car)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (591, 'Bulk plant storage/petroleum distributor', 'Bulk plant storage/petroleum distributor', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (591, 'Commercial', 'Commercial', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (591, 'Federally owned', 'Federal government, non-military', 'OUST key vocabulary mapping');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (591, 'Hospital (or other medical)', 'Hospital (or other medical)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (591, 'Industrial', 'Industrial', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (591, 'Marina', 'Marina', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (591, 'Other', 'Other', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (591, 'Railroad', 'Railroad', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (591, 'Rental car', 'Rental Car', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (591, 'Residential', 'Residential', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (591, 'RESIDENTIAL', 'Residential', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (591, 'Retail fuel sales (non-marina)', 'Retail fuel sales (non-marina)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (591, 'School', 'School', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (591, 'Telecommunication facility', 'Telecommunication facility', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (591, 'Trucking/transport/fleet operation', 'Trucking/transport/fleet operation', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (591, 'Unknown', 'Unknown', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (591, 'Utility', 'Utility', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (591, 'Wholesale', 'Wholesale', null);

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
--ust_release.coordinate_source_id

--select distinct "CoordinateSource" from ma_release."vw_releases" where "CoordinateSource" is not null order by 1;
/* Organization values are:

GIS
Map Interpolation
Other
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (594, 'GIS', 'Other', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (594, 'Map Interpolation', 'Map interpolation', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (594, 'Other', 'Other', null);

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
and lower(organization_value) like lower('%gis%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_lust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_lust_element_mapping
 * to do mapping, check public.coordinate_sources to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--ust_release.release_status_id

--select distinct "LUSTStatus" from ma_release."vw_releases" where "LUSTStatus" is not null order by 1;
/* Organization values are:

Active: CorrectiveAction
Active: post CorrectiveAction monitoring
Active: site investigation
Active: stalled
No further action
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (595, 'Active: CorrectiveAction', 'Active: corrective action', 'OUST key vocabulary mapping');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (595, 'Active: post CorrectiveAction monitoring', 'Active: post corrective action monitoring', 'OUST key vocabulary mapping');
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (595, 'Active: site investigation', 'Active: site investigation', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (595, 'Active: stalled', 'Active: stalled', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (595, 'No further action', 'No further action', null);

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
--ust_release.release_discovered_id

--select distinct "HowReleaseDetected" from ma_release."vw_releases" where "HowReleaseDetected" is not null order by 1;
/* Organization values are:

At tank removal
GW monitoring well
Inspection
Interstial monitor
Other
Statistical inventory Reconciliation (SIR)
Tank tightness testing
Third party (well water, vapor instrusion, etc.)
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (616, 'At tank removal', 'At tank system closure/removal',  'OUST key vocabulary mapping'	);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (616, 'GW monitoring well', 'Groundwater monitoring',  'OUST key vocabulary mapping'	);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (616, 'Inspection', 'Compliance inspection',  'OUST key vocabulary mapping'	);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (616, 'Interstial monitor', 'Interstitial monitoring',  'OUST key vocabulary mapping'	);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (616, 'Other', 'Other', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (616, 'Statistical inventory Reconciliation (SIR)', 'Statistical Inventory Reconciliation (SIR)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (616, 'Tank tightness testing', 'Tank tightness testing', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (616, 'Third party (well water, vapor instrusion, etc.)', 'Off-site impact/third party (general)',  'OUST key vocabulary mapping'	);

delete from  public.release_element_value_mapping where 
 release_element_mapping_id = 616 and organization_value  = 'Third party (well water, vapor instrusion, etc.)'


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
--ust_release_substance.substance_id

--select distinct "substance_released" from ma_release."vw_release_substances" where "substance_released" is not null order by 1;
/* Organization values are:

Aviation gasoline
Diesel fuel (b-unknown)
Gasoline (unknown type)
Heating oil/fuel oil 2
Heating/fuel oil # unknown
Jet fuel A
Kerosene
Lube/motor oil (new)
Other
Petroleum product
Solvent
Solvents
Unknown
Unknown aviation gas or jet fuel
Used oil/waste oil
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (607, 'Aviation gasoline', 'Aviation gasoline', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (607, 'Diesel fuel (b-unknown)', 'Diesel fuel (b-unknown)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (607, 'Gasoline (unknown type)', 'Gasoline (unknown type)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (607, 'Heating oil/fuel oil 2', 'Heating oil/fuel oil 2', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (607, 'Heating/fuel oil # unknown', 'Heating/fuel oil # unknown', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (607, 'Jet fuel A', 'Jet fuel A', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (607, 'Kerosene', 'Kerosene', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (607, 'Lube/motor oil (new)', 'Lube/motor oil (new)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (607, 'Other', 'Other or mixture', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (607, 'Petroleum product', 'Petroleum product', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (607, 'Solvent', 'Solvent', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (607, 'Solvents', 'Solvent', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (607, 'Unknown', 'Unknown', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (607, 'Unknown aviation gas or jet fuel', 'Unknown aviation gas or jet fuel', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (607, 'Used oil/waste oil', 'Used oil/waste oil', null);

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
from public.v_release_element_mapping
where epa_column_name = 'substance_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_lust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_lust_element_mapping
 * to do mapping, check public.substances to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--ust_release_source.source_id

--select distinct "SourceOfRelease" from ma_release."vw_release_sources" where "SourceOfRelease" is not null order by 1;
/* Organization values are:

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
values (611, 'Dispenser', 'Dispenser', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (611, 'Other', 'Other', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (611, 'Piping', 'Piping', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (611, 'Submersible Turbine Pump', 'Submersible turbine pump', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (611, 'Tank', 'Tank', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (611, 'Unknown', 'Unknown', null);

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
--ust_release_cause.cause_id

--select distinct "cause" from ma_release."vw_release_causes" where "cause" is not null order by 1;
/* Organization values are:

Damage to dispenser
Delivery overfill
Delivery problem
Human error
Motor vehicle accident
Other
Piping failure
Spill bucket failure
Tank corrosion
Tank damage
Tank Damage
Tank removal
Unknown
Weather/natural disaster
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (613, 'Damage to dispenser', 'Damage to dispenser', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (613, 'Delivery overfill', 'Delivery overfill', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (613, 'Delivery problem', 'Delivery overfill', 'OUST key vocabulary mapping'	);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (613, 'Human error', 'Human error', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (613, 'Motor vehicle accident', 'Motor vehicle accident', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (613, 'Other', 'Other', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (613, 'Piping failure', 'Piping failure', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (613, 'Spill bucket failure', 'Spill bucket failure', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (613, 'Tank corrosion', 'Tank corrosion', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (613, 'Tank damage', 'Tank damage', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (613, 'Tank Damage', 'Tank damage', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (613, 'Tank removal', 'Tank removal', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (613, 'Unknown', 'Unknown', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (613, 'Weather/natural disaster', 'Weather/natural disaster (i.e., hurricane, flooding, fire, earthquake)',  'OUST key vocabulary mapping'	);

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
--ust_release_corrective_action_strategy.corrective_action_strategy_id

--select distinct "corrective_action_strategy" from ma_release."vw_release_corrective_action_strategy" where "corrective_action_strategy" is not null order by 1;
/* Organization values are:

Air sparging/bio sparging
Air stripping
Alternative drinking water
Capping
Chemical oxidation
Enhanced anaerobic oxidative bioremediation
Excavation and hauling or treatment
In-situ groundwater remediation
Monitored natural attenuation
Multi/dual-phase extraction (MPE)
Other
Oxidizer moitoring well socks
Passive or bail product recovery
Point of use water treatment
Pump and treat
Soil vapor extraction (SVE)
Subslab venting
Surfactant injection
Unknown
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (615, 'Air sparging/bio sparging', 'Air sparging/bio sparging', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (615, 'Air stripping', 'Air stripping', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (615, 'Alternative drinking water', 'Alternative drinking water', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (615, 'Capping', 'Capping', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (615, 'Chemical oxidation', 'Chemical oxidation', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (615, 'Enhanced anaerobic oxidative bioremediation', 'Enhanced anaerobic oxidative bioremediation', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (615, 'Excavation and hauling or treatment', 'Excavation and hauling or treatment', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (615, 'In-situ groundwater remediation', 'In-situ groundwater remediation', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (615, 'Monitored natural attenuation', 'Monitored natural attenuation', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (615, 'Multi/dual-phase extraction (MPE)', 'Multi/dual-phase extraction (MPE)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (615, 'Other', 'Other', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (615, 'Oxidizer moitoring well socks', 'Oxidizer moitoring well socks', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (615, 'Passive or bail product recovery', 'Passive or bail product recovery', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (615, 'Point of use water treatment', 'Point of use water treatment', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (615, 'Pump and treat', 'Pump and treat', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (615, 'Soil vapor extraction (SVE)', 'Soil vapor extraction (SVE)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (615, 'Subslab venting', 'Subslab venting', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (615, 'Surfactant injection', 'Surfactant injection', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (615, 'Unknown', 'Unknown', null);

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
Subslab venting
Sulfate injection or surface placement
Surfactant injection
Treatment wall
Vacuum vaporizing well (UVB, ART)
Other
Unknown
Slab sealing/sub-slab barrier

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
