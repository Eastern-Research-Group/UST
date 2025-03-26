------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--owner_type_id

--select distinct "ownerTypeID" from ia_ust."tblustsite" where "ownerTypeID" is not null order by 1;
/* Organization values are:

1.0
2.0
3.0
4.0
5.0
6.0
7.0
8.0
9.0
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2718, '1.0', 'Local Government', 'Mapped by State in original SQL');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2718, '2.0', 'Federal Government - Non Military', 'Mapped by State in original SQL');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2718, '3.0', 'Tribal Government', 'Mapped by State in original SQL');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2718, '4.0', 'Local Government', 'Mapped by State in original SQL');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2718, '5.0', 'Local Government', 'Mapped by State in original SQL');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2718, '6.0', 'Private', 'Mapped by State in original SQL');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2718, '7.0', 'State Government - Non Military', 'Mapped by State in original SQL');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2718, '8.0', 'Other', 'Mapped by State in original SQL');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2718, '9.0', 'Other', 'Mapped by State in original SQL');

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
--facility_state

--select distinct "locStateCD" from ia_ust."tbllocation" where "locStateCD" is not null order by 1;
/* Organization values are:

34
AZ
CO
DE
IA
IL
KS
MN
NC
NE
OH
WI
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2724, '34', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2724, 'AZ', 'AZ', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2724, 'CO', 'CO', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2724, 'DE', 'DE', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2724, 'IA', 'IA', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2724, 'IL', 'IL', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2724, 'KS', 'KS', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2724, 'MN', 'MN', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2724, 'NC', 'NC', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2724, 'NE', 'NE', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2724, 'OH', 'OH', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2724, 'WI', 'WI', null);

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

--select distinct "colMthID" from ia_ust."tbllocation" where "colMthID" is not null order by 1;
/* Organization values are:

1.0
3.0
5.0
6.0
7.0
8.0
12.0
14.0
15.0
16.0
18.0
19.0
23.0
24.0
26.0
30.0
35.0
106.0
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2727, '1.0', 'Geocoded address', 'Mapped by State in original SQL');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2727, '3.0', 'Geocoded address', 'Mapped by State in original SQL');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2727, '5.0', 'Geocoded address', 'Mapped by State in original SQL');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2727, '6.0', 'Geocoded address', 'Mapped by State in original SQL');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2727, '7.0', 'Geocoded address', 'Mapped by State in original SQL');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2727, '8.0', 'Other', 'Mapped by State in original SQL');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2727, '12.0', 'GPS', 'Mapped by State in original SQL');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2727, '14.0', 'GPS', 'Mapped by State in original SQL');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2727, '15.0', 'GPS', 'Mapped by State in original SQL');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2727, '16.0', 'GPS', 'Mapped by State in original SQL');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2727, '18.0', 'Map interpolation', 'Mapped by State in original SQL');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2727, '19.0', 'Map interpolation', 'Mapped by State in original SQL');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2727, '23.0', 'PLSS', 'Mapped by State in original SQL');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2727, '24.0', '', 'Mapped by State in original SQL');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2727, '26.0', 'Other', 'Mapped by State in original SQL');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2727, '30.0', 'Map interpolation', 'Mapped by State in original SQL');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2727, '35.0', 'PLSS', 'Mapped by State in original SQL');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2727, '106.0', '', 'Mapped by State in original SQL');

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
--tank_status_id

/*
It looks like it is possible that IA has compartment statuses but not tank statuses.

To roll the compartment status up to the tank level, see the status_hierarchy and status_comment columns of the compartment_statuses lookup table.
Use the SQL MIN() function on the status_hierarchy column to get the status for the tank, but also see the status_comment to rule out "impossible" scenarios
 */

--select distinct "statusDescription" from ia_ust."tlkcompstatus" where "statusDescription" is not null order by 1;
/* Organization values are:

AST Out-of-Service
Delivery Prohibition Enforced
Emergency power generator tank- active
Emergency power generator tank - r/f
Emergency power generators - temp closed
Farm Exempt
Non-regulated B100 - active
Non-regulated B100 - r/f
Non-regulated B100 - temp closed
Non-regulated DEF - active
Non-regulated DEF - r/f 
Non-regulated DEF - temp closed
Non-regulated farm tanks - temporarily closed
Non-regulated Farm/Res <1100 - r/f
Non-regulated Farm/Res <1100 -active
Non-regulated heating oil tank - active
Non-regulated heating oil tank - r/f
Non-regulated hoist oil tank - active
Non-regulated hoist oil tanks - r/f
Non-regulated Other - active
Non-regulated Other - r/f
Non-regulated Other - temp closed
Non-regulated tank - leaking
Pre-1974 tank site
Regulated tank - active
Regulated tanks - r/f
Regulated tanks - temp closed
Status Needed
Tank to be deleted.  Data entry error
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2746, 'AST Out-of-Service', 'Other', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2746, 'Delivery Prohibition Enforced', 'Other', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2746, 'Emergency power generator tank- active', 'Currently in use', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2746, 'Emergency power generator tank - r/f', 'Closed (removed from ground)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2746, 'Emergency power generators - temp closed', 'Temporarily out of service', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2746, 'Farm Exempt', 'Other', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2746, 'Non-regulated B100 - active', 'Currently in use', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2746, 'Non-regulated B100 - r/f', 'Closed (removed from ground)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2746, 'Non-regulated B100 - temp closed', 'Temporarily out of service', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2746, 'Non-regulated DEF - active', 'Currently in use', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2746, 'Non-regulated DEF - r/f ', 'Closed (removed from ground)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2746, 'Non-regulated DEF - temp closed', 'Temporarily out of service', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2746, 'Non-regulated farm tanks - temporarily closed', 'Temporarily out of service', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2746, 'Non-regulated Farm/Res <1100 - r/f', 'Closed (removed from ground)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2746, 'Non-regulated Farm/Res <1100 -active', 'Currently in use', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2746, 'Non-regulated heating oil tank - active', 'Currently in use', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2746, 'Non-regulated heating oil tank - r/f', 'Closed (removed from ground)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2746, 'Non-regulated hoist oil tank - active', 'Currently in use', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2746, 'Non-regulated hoist oil tanks - r/f', 'Closed (removed from ground)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2746, 'Non-regulated Other - active', 'Currently in use', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2746, 'Non-regulated Other - r/f', 'Closed (removed from ground)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2746, 'Non-regulated Other - temp closed', 'Temporarily out of service', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2746, 'Non-regulated tank - leaking', 'Other', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2746, 'Pre-1974 tank site', 'Other', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2746, 'Regulated tank - active', 'Currently in use', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2746, 'Regulated tanks - r/f', 'Closed (removed from ground)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2746, 'Regulated tanks - temp closed', 'Temporarily out of service', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2746, 'Status Needed', 'Unknown', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2746, 'Tank to be deleted.  Data entry error', '', null);

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

--select distinct "matConDescription" from ia_ust."tlkmaterialconstruction" where "matConDescription" is not null order by 1;
/* Organization values are:

Composite (steel with FRP)
Concrete
Double Wall Composite
Double Wall FRP
Double Wall Steel
FRP
Other
Stainless Steel
Steel
Steel Interior lined with Fiberglass
Steel with Polyethylene
Unknown
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2754, 'Composite (steel with FRP)', 'Composite/clad (steel w/fiberglass reinforced plastic)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2754, 'Concrete', 'Concrete', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2754, 'Double Wall Composite', 'Composite/clad (steel w/fiberglass reinforced plastic)', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2754, 'Double Wall FRP', 'Fiberglass reinforced plastic', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2754, 'Double Wall Steel', 'Steel (NEC)', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2754, 'FRP', 'Fiberglass reinforced plastic', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2754, 'Other', 'Other', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2754, 'Stainless Steel', 'Steel (NEC)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2754, 'Steel', 'Steel (NEC)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2754, 'Steel Interior lined with Fiberglass', 'Composite/clad (steel w/fiberglass reinforced plastic)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2754, 'Steel with Polyethylene', 'Jacketed steel', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2754, 'Unknown', 'Unknown', null);

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
--cert_of_installation_id

--select distinct "installationID" from ia_ust."treltanktoinstallation" where "installationID" is not null order by 1;
/* Organization values are:

1
2
3
4
5
6
7
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2759, '1', 'Installer certified by tank and piping manufacturers', 'Mapped by State in original SQL');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2759, '2', 'Installation inspected by a registered engineer', 'Mapped by State in original SQL');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2759, '3', 'Manufacturer''s installation checklists have been completed', 'Mapped by State in original SQL');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2759, '4', 'Other method - specify', 'Mapped by State in original SQL');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2759, '5', 'Installer certified or licensed by the implementing agency', 'Mapped by State in original SQL');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2759, '6', 'Installation inspected and approved by implementing agency', 'Mapped by State in original SQL');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2759, '7', 'Other method - specify', 'Mapped by State in original SQL');

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
--substance_id

--select distinct "contentDescription" from ia_ust."tlkcompcontent" where "contentDescription" is not null order by 1;
/* Organization values are:

Aviation Gas
B100
B2
B20
B5
B99
Bio Diesel
DEF
Diesel
Diesel Ultra Low Sulfur
Dyed Diesel
E10
E15
E85
E98
Empty
Fuel Additive
Gasoline-Leaded
Hazardous
Hazardous-Hexane
Hazardous - Benzene
Hazardous - Methanol
Hazardous - Mtbe
Hazardous - Xylene
Heating/Fuel Oil
Jet Fuel
Kerosene
Midgrade (89)
NR Other
Oil New
Oil Used
Other
Premium
Regular (87)
Super Unleaded
Unknown
Unleaded
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Aviation Gas', 'Aviation gasoline', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'B100', '100% biodiesel (B100, not federally regulated)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'B2', '80% renewable diesel, 20% biodiesel', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'B20', '80% renewable diesel, 20% biodiesel', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'B5', '95% renewable diesel, 5% biodiesel', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'B99', '99.9 percent renewable diesel, 0.01% biodiesel', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Bio Diesel', 'Diesel fuel (b-unknown)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'DEF', 'Diesel exhaust fluid (DEF, not federally regulated)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Diesel', 'Diesel fuel (b-unknown)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Diesel Ultra Low Sulfur', 'Diesel fuel (b-unknown)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Dyed Diesel', 'Off-road diesel/dyed diesel', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'E10', 'Gasoline E-10 (E1-E10)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'E15', 'Gasoline E-15 (E-11-E15)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'E85', 'E-85/Flex Fuel (E51-E83)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'E98', 'Gasoline/ethanol blend containing more than 83% and less than 98% ethanol', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Empty', 'Other or mixture', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Fuel Additive', 'Gasoline (unknown type)', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Gasoline-Leaded', 'Leaded gasoline', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Hazardous', 'Hazardous substance', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Hazardous-Hexane', 'Hazardous substance', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Hazardous - Benzene', 'Hazardous substance', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Hazardous - Methanol', 'Hazardous substance', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Hazardous - Mtbe', 'MTBE', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Hazardous - Xylene', 'Hazardous substance', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Heating/Fuel Oil', 'Heating/fuel oil # unknown', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Jet Fuel', 'Jet fuel A', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Kerosene', 'Kerosene', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Midgrade (89)', 'Gasoline (unknown type)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'NR Other', 'Other or mixture', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Oil New', 'Lube/motor oil (new)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Oil Used', 'Used oil/waste oil', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Other', 'Other or mixture', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Premium', 'Gasoline (unknown type)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Regular (87)', 'Gasoline (unknown type)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Super Unleaded', 'Gasoline (unknown type)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Unknown', 'Unknown', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Unleaded', 'Gasoline (unknown type)', 'Mapped by ERG');

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
--compartment_status_id

--select distinct "statusDescription" from ia_ust."tlkcompstatus" where "statusDescription" is not null order by 1;
/* Organization values are:

AST Out-of-Service
Delivery Prohibition Enforced
Emergency power generator tank- active
Emergency power generator tank - r/f
Emergency power generators - temp closed
Farm Exempt
Non-regulated B100 - active
Non-regulated B100 - r/f
Non-regulated B100 - temp closed
Non-regulated DEF - active
Non-regulated DEF - r/f 
Non-regulated DEF - temp closed
Non-regulated farm tanks - temporarily closed
Non-regulated Farm/Res <1100 - r/f
Non-regulated Farm/Res <1100 -active
Non-regulated heating oil tank - active
Non-regulated heating oil tank - r/f
Non-regulated hoist oil tank - active
Non-regulated hoist oil tanks - r/f
Non-regulated Other - active
Non-regulated Other - r/f
Non-regulated Other - temp closed
Non-regulated tank - leaking
Pre-1974 tank site
Regulated tank - active
Regulated tanks - r/f
Regulated tanks - temp closed
Status Needed
Tank to be deleted.  Data entry error
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2767, 'AST Out-of-Service', 'Other', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2767, 'Delivery Prohibition Enforced', 'Other', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2767, 'Emergency power generator tank- active', 'Currently in use', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2767, 'Emergency power generator tank - r/f', 'Closed (removed from ground)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2767, 'Emergency power generators - temp closed', 'Temporarily out of service', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2767, 'Farm Exempt', 'Other', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2767, 'Non-regulated B100 - active', 'Currently in use', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2767, 'Non-regulated B100 - r/f', 'Closed (removed from ground)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2767, 'Non-regulated B100 - temp closed', 'Temporarily out of service', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2767, 'Non-regulated DEF - active', 'Currently in use', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2767, 'Non-regulated DEF - r/f ', 'Closed (removed from ground)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2767, 'Non-regulated DEF - temp closed', 'Temporarily out of service', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2767, 'Non-regulated farm tanks - temporarily closed', 'Temporarily out of service', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2767, 'Non-regulated Farm/Res <1100 - r/f', 'Closed (removed from ground)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2767, 'Non-regulated Farm/Res <1100 -active', 'Currently in use', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2767, 'Non-regulated heating oil tank - active', 'Currently in use', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2767, 'Non-regulated heating oil tank - r/f', 'Closed (removed from ground)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2767, 'Non-regulated hoist oil tank - active', 'Currently in use', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2767, 'Non-regulated hoist oil tanks - r/f', 'Closed (removed from ground)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2767, 'Non-regulated Other - active', 'Currently in use', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2767, 'Non-regulated Other - r/f', 'Closed (removed from ground)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2767, 'Non-regulated Other - temp closed', 'Temporarily out of service', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2767, 'Non-regulated tank - leaking', 'Other', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2767, 'Pre-1974 tank site', 'Other', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2767, 'Regulated tank - active', 'Currently in use', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2767, 'Regulated tanks - r/f', 'Closed (removed from ground)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2767, 'Regulated tanks - temp closed', 'Temporarily out of service', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2767, 'Status Needed', 'Unknown', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2767, 'Tank to be deleted.  Data entry error', '', null);

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

--select distinct "Wall" from ia_ust."tbltankcompartment" where "Wall" is not null order by 1;
/* Organization values are:

Double
Single
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2774, 'Double', 'Double', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2774, 'Single', 'Single', null);

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
--substance_id

--select distinct "contentDescription" from ia_ust."tlkcompcontent" where "contentDescription" is not null order by 1;
/* Organization values are:

Aviation Gas
B100
B2
B20
B5
B99
Bio Diesel
DEF
Diesel
Diesel Ultra Low Sulfur
Dyed Diesel
E10
E15
E85
E98
Empty
Fuel Additive
Gasoline-Leaded
Hazardous
Hazardous-Hexane
Hazardous - Benzene
Hazardous - Methanol
Hazardous - Mtbe
Hazardous - Xylene
Heating/Fuel Oil
Jet Fuel
Kerosene
Midgrade (89)
NR Other
Oil New
Oil Used
Other
Premium
Regular (87)
Super Unleaded
Unknown
Unleaded
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Aviation Gas', 'Aviation gasoline', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'B100', '100% biodiesel (B100, not federally regulated)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'B2', '80% renewable diesel, 20% biodiesel', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'B20', '80% renewable diesel, 20% biodiesel', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'B5', '95% renewable diesel, 5% biodiesel', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'B99', '99.9 percent renewable diesel, 0.01% biodiesel', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Bio Diesel', 'Diesel fuel (b-unknown)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'DEF', 'Diesel exhaust fluid (DEF, not federally regulated)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Diesel', 'Diesel fuel (b-unknown)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Diesel Ultra Low Sulfur', 'Diesel fuel (b-unknown)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Dyed Diesel', 'Off-road diesel/dyed diesel', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'E10', 'Gasoline E-10 (E1-E10)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'E15', 'Gasoline E-15 (E-11-E15)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'E85', 'E-85/Flex Fuel (E51-E83)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'E98', 'Gasoline/ethanol blend containing more than 83% and less than 98% ethanol', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Empty', 'Other or mixture', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Fuel Additive', 'Gasoline (unknown type)', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Gasoline-Leaded', 'Leaded gasoline', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Hazardous', 'Hazardous substance', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Hazardous-Hexane', 'Hazardous substance', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Hazardous - Benzene', 'Hazardous substance', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Hazardous - Methanol', 'Hazardous substance', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Hazardous - Mtbe', 'MTBE', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Hazardous - Xylene', 'Hazardous substance', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Heating/Fuel Oil', 'Heating/fuel oil # unknown', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Jet Fuel', 'Jet fuel A', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Kerosene', 'Kerosene', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Midgrade (89)', 'Gasoline (unknown type)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'NR Other', 'Other or mixture', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Oil New', 'Lube/motor oil (new)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Oil Used', 'Used oil/waste oil', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Other', 'Other or mixture', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Premium', 'Gasoline (unknown type)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Regular (87)', 'Gasoline (unknown type)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Super Unleaded', 'Gasoline (unknown type)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Unknown', 'Unknown', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2763, 'Unleaded', 'Gasoline (unknown type)', 'Mapped by ERG');

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
--piping_style_id

--select distinct "pipeTypeID" from ia_ust."tblpipe" where "pipeTypeID" is not null order by 1;
/* Organization values are:

1.0
2.0
3.0
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2792, '1.0', 'Pressure', 'Mapped by State in Original SQL');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2792, '2.0', 'Suction', 'Mapped by State in Original SQL');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2792, '3.0', 'Suction', 'Mapped by State in Original SQL');

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
where ust_control_id = 32 and epa_column_name = 'tank_material_description_id'
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
