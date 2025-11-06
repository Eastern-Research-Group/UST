------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--ust_facility.facility_state

--select distinct "FACILITY_STATE" from pa_ust."facilities" where "FACILITY_STATE" is not null order by 1;
/* Organization values are:

PA
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3939, 'PA', 'PA', null);

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

--select distinct "STATUS" from pa_ust."tanks" where "STATUS" is not null order by 1;
/* Organization values are:

C
T
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3946, 'C', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3946, 'T', '', null);

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

--select distinct "tank_material_description" from pa_ust."v_tank_mat" where "tank_material_description" is not null order by 1;
/* Organization values are:

CATHODICALLY PROTECTED DOUBLE WALL STEEL (GALVANIC)
CATHODICALLY PROTECTED STEEL (GALVANIC)
CATHODICALLY PROTECTED STEEL (IMPRESSED CURRENT)
CATHODICALLY PROTECTED STEEL WITH LINER
CONCRETE
FIBERGLASS (DOUBLE WALL)
FIBERGLASS (SINGLE WALL)
OTHER
OTHER (COMPLIANT)
STEEL W/FRP COATING (ACT 100 OR EQUIVALENT) (SINGLE WALL)
STEEL W/FRP COATING W/ ANODES (SINGLE WALL)
STEEL W/LINED INTERIOR
STEEL W/PLASTIC OR FIBERGLASS JACKET (DOUBLE WALL)
STEEL W/PLASTIC OR FRP JACKET W/ ANODES (DOUBLE WALL)
UNKNOWN
UNPROTECTED STEEL (DOUBLE WALL)
UNPROTECTED STEEL (SINGLE WALL)
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3949, 'CATHODICALLY PROTECTED DOUBLE WALL STEEL (GALVANIC)', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3949, 'CATHODICALLY PROTECTED STEEL (GALVANIC)', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3949, 'CATHODICALLY PROTECTED STEEL (IMPRESSED CURRENT)', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3949, 'CATHODICALLY PROTECTED STEEL WITH LINER', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3949, 'CONCRETE', 'Concrete', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3949, 'FIBERGLASS (DOUBLE WALL)', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3949, 'FIBERGLASS (SINGLE WALL)', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3949, 'OTHER', 'Other', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3949, 'OTHER (COMPLIANT)', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3949, 'STEEL W/FRP COATING (ACT 100 OR EQUIVALENT) (SINGLE WALL)', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3949, 'STEEL W/FRP COATING W/ ANODES (SINGLE WALL)', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3949, 'STEEL W/LINED INTERIOR', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3949, 'STEEL W/PLASTIC OR FIBERGLASS JACKET (DOUBLE WALL)', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3949, 'STEEL W/PLASTIC OR FRP JACKET W/ ANODES (DOUBLE WALL)', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3949, 'UNKNOWN', 'Unknown', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3949, 'UNPROTECTED STEEL (DOUBLE WALL)', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3949, 'UNPROTECTED STEEL (SINGLE WALL)', '', null);

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

--select distinct "tank_secondary_containment" from pa_ust."v_tank_sec_cont" where "tank_secondary_containment" is not null order by 1;
/* Organization values are:

Double Wall
Jacketed
Single Wall
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3953, 'Double Wall', 'Double wall', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3953, 'Jacketed', 'Jacketed', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3953, 'Single Wall', 'Single wall', null);

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

--select distinct "SUBSTANCE_CODE" from pa_ust."tanks" where "SUBSTANCE_CODE" is not null order by 1;
/* Organization values are:

AVGAS
BIDSL
DIESL
GAS
GSHOL
HO
HO1
HZSUB
JET
KERO
LDGAS
NMO
OTHER
ULGAS
UMO
USDOL
WO
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3956, 'AVGAS', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3956, 'BIDSL', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3956, 'DIESL', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3956, 'GAS', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3956, 'GSHOL', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3956, 'HO', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3956, 'HO1', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3956, 'HZSUB', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3956, 'JET', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3956, 'KERO', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3956, 'LDGAS', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3956, 'NMO', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3956, 'OTHER', 'Other or mixture', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3956, 'ULGAS', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3956, 'UMO', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3956, 'USDOL', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3956, 'WO', '', null);

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
PA does not report at the Compartment level, but CompartmentStatus is required.

Copy the tank status mapping down to the compartment!
The lookup tables for compartment_statuses and tank_stasuses are the same.
 */

--select distinct "STATUS" from pa_ust."tanks" where "STATUS" is not null order by 1;
/* Organization values are:

C
T
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3960, 'C', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3960, 'T', '', null);

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

--select distinct "spill_bucket_wall_type" from pa_ust."v_spill_wall_type" where "spill_bucket_wall_type" is not null order by 1;
/* Organization values are:

Double
Single
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3969, 'Double', 'Double', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3969, 'Single', 'Single', null);

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
--ust_piping.piping_style_id

--select distinct "piping_style" from pa_ust."v_piping_style" where "piping_style" is not null order by 1;
/* Organization values are:

GRAVITY FED
NONE
PRESSURE
SUCTION: CHECK VALVE AT PUMP
SUCTION: CHECK VALVE AT TANK
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3981, 'GRAVITY FED', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3981, 'NONE', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3981, 'PRESSURE', 'Pressure', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3981, 'SUCTION: CHECK VALVE AT PUMP', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3981, 'SUCTION: CHECK VALVE AT TANK', '', null);

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

--select distinct "DESCRIPTION_1" from pa_ust."v_piping_wall_type" where "DESCRIPTION_1" is not null order by 1;
/* Organization values are:

BARE STEEL
CATHODICALLY PROTECTED, METALLIC
COPPER
Double wall, flexible primary
Double wall, metallic primary
Double wall, rigid (FRP) primary
FIBERGLASS
FLEXIBLE NON-METALLIC
JACKETED
MODIFICATION OF PIPING
NONE
OTHER (COMPLIANT)
TRENCH LINER
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4075, 'BARE STEEL', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4075, 'CATHODICALLY PROTECTED, METALLIC', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4075, 'COPPER', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4075, 'Double wall, flexible primary', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4075, 'Double wall, metallic primary', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4075, 'Double wall, rigid (FRP) primary', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4075, 'FIBERGLASS', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4075, 'FLEXIBLE NON-METALLIC', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4075, 'JACKETED', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4075, 'MODIFICATION OF PIPING', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4075, 'NONE', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4075, 'OTHER (COMPLIANT)', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4075, 'TRENCH LINER', '', null);

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
where ust_control_id = 40 and epa_column_name = 'tank_material_description_id'
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
