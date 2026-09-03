------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--ust_facility.owner_type_id

--select distinct "Owner Type" from wv_ust."AllFacilitiesDetails" where "Owner Type" is not null order by 1;
/* Organization values are:

Company
County
Federal
Individual
Municipality
State
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4257, 'Company', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4257, 'County', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4257, 'Federal', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4257, 'Individual', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4257, 'Municipality', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4257, 'State', '', null);

--select owner_type from public.owner_types;
/* Valid EPA values are:

Local Government
Commercial
Private
Military
Other
Tribal Government
Government (unspecified)
Federal Government
State Government

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

--select distinct "Facility Type" from wv_ust."AllFacilitiesDetails" where "Facility Type" is not null order by 1;
/* Organization values are:

AIR TAXI (AIRLINE)
AIRCRAFT OWNER
AUTO DEALERSHIP
COAL MINE
COMMERCIAL
CONSTRUCTION COMPANY
CONTRACTOR
FARM
FEDERAL GOVERNMENT
FEDERAL MILITARY
FEDERAL NON-MILITARY
GAS STATION
GOLF COURSE
HOSPITAL
INDUSTRIAL
LOCAL GOVERNMENT
NOT LISTED
OTHER
PETROLEUM DISTRIBUTOR
PUBLIC SCHOOL
RAILROAD
RESIDENTIAL
STATE GOVERNMENT
TRUCK/TRANSPORTER
UTILITIES
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4258, 'AIR TAXI (AIRLINE)', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4258, 'AIRCRAFT OWNER', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4258, 'AUTO DEALERSHIP', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4258, 'COAL MINE', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4258, 'COMMERCIAL', 'Commercial', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4258, 'CONSTRUCTION COMPANY', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4258, 'CONTRACTOR', 'Contractor', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4258, 'FARM', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4258, 'FEDERAL GOVERNMENT', 'Federal government', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4258, 'FEDERAL MILITARY', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4258, 'FEDERAL NON-MILITARY', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4258, 'GAS STATION', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4258, 'GOLF COURSE', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4258, 'HOSPITAL', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4258, 'INDUSTRIAL', 'Industrial', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4258, 'LOCAL GOVERNMENT', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4258, 'NOT LISTED', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4258, 'OTHER', 'Other', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4258, 'PETROLEUM DISTRIBUTOR', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4258, 'PUBLIC SCHOOL', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4258, 'RAILROAD', 'Railroad', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4258, 'RESIDENTIAL', 'Residential', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4258, 'STATE GOVERNMENT', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4258, 'TRUCK/TRANSPORTER', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4258, 'UTILITIES', '', null);

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
Military
State/local government
Government (unspecified)
Federal government
Vacant

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
--ust_tank.tank_status_id

--select distinct "Tank Status" from wv_ust."USTTanksPublic" where "Tank Status" is not null order by 1;
/* Organization values are:

Abandoned
Currently In Use
Currently In Use
Temporarily Out of Service
Permanently Out of Service
Temporarily Out of Service
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4281, 'Abandoned', 'Abandoned', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4281, 'Currently In Use', 'Currently in use', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4281, 'Currently In Use\nTemporarily Out of Service', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4281, 'Permanently Out of Service', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4281, 'Temporarily Out of Service', 'Temporarily out of service', null);

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

--select distinct "Material" from wv_ust."USTTanksPublic" where "Material" is not null order by 1;
/* Organization values are:

Carbon Steel Fiberglass Jacket
Composite
Composite (Fiberglass/polyurethane-coated)
Composite (Steel w/FRP or Epoxy Coating)
Epoxy Coated Steel
Fiberglass Reinforced Plastic
Not Listed
Other
Polyethylene Tank Jacket
Steel
UnKnown
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4288, 'Carbon Steel Fiberglass Jacket', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4288, 'Composite', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4288, 'Composite (Fiberglass/polyurethane-coated)', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4288, 'Composite (Steel w/FRP or Epoxy Coating)', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4288, 'Epoxy Coated Steel', 'Epoxy coated steel', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4288, 'Fiberglass Reinforced Plastic', 'Fiberglass reinforced plastic', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4288, 'Not Listed', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4288, 'Other', 'Other', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4288, 'Polyethylene Tank Jacket', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4288, 'Steel', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4288, 'UnKnown', 'Unknown', null);

--select tank_material_description from public.tank_material_descriptions;
/* Valid EPA values are:

Fiberglass reinforced plastic
Asphalt coated or bare steel
Epoxy coated steel
Coated and cathodically protected steel
Jacketed steel
Concrete
Other
Unknown
Composite/clad steel w/fiberglass reinforced plastic
Cathodically protected steel without coating
Steel NEC
Urethane coated/clad steel (steel with/poly urethane)

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

--select distinct "Active Tanks Construction" from wv_ust."AllFacilitiesDetails" where "Active Tanks Construction" is not null order by 1;
/* Organization values are:

Carbon Steel Fiberglass Jacket Double-Walled
Carbon Steel Fiberglass Jacket Double-WalledComposite (Steel w/FRP or Epoxy Coating) Double-Walled
Carbon Steel Fiberglass Jacket Double-WalledComposite (Steel w/FRP or Epoxy Coating) None
Composite (Fiberglass/polyurethane-coated) Double-Walled
Composite (Fiberglass/polyurethane-coated) Double-WalledComposite Double-Walled
Composite (Fiberglass/polyurethane-coated) Double-WalledComposite Double-WalledFiberglass Reinforced Plastic NoneSteel None
Composite (Fiberglass/polyurethane-coated) Double-WalledPolyethylene Tank Jacket Double-Walled
Composite (Fiberglass/polyurethane-coated) None
Composite (Fiberglass/polyurethane-coated) NoneComposite Double-WalledSteel None
Composite (Fiberglass/polyurethane-coated) NoneEpoxy Coated Steel None
Composite (Steel w/FRP or Epoxy Coating) Double-Walled
Composite (Steel w/FRP or Epoxy Coating) Double-WalledComposite Double-Walled
Composite (Steel w/FRP or Epoxy Coating) Double-WalledFiberglass Reinforced Plastic Double-Walled
Composite (Steel w/FRP or Epoxy Coating) Double-WalledPolyethylene Tank Jacket None
Composite (Steel w/FRP or Epoxy Coating) Double-WalledSteel None
Composite (Steel w/FRP or Epoxy Coating) None
Composite (Steel w/FRP or Epoxy Coating) NoneSteel None
Composite Double-Walled
Composite Double-WalledEpoxy Coated Steel Double-Walled
Composite Double-WalledEpoxy Coated Steel None
Composite Double-WalledFiberglass Reinforced Plastic Double-Walled
Composite Double-WalledFiberglass Reinforced Plastic None
Composite Double-WalledPolyethylene Tank Jacket Double-Walled
Composite Double-WalledPolyethylene Tank Jacket None
Composite Double-WalledSteel Double-Walled
Composite Double-WalledSteel None
Composite None
Epoxy Coated Steel Double-Walled
Epoxy Coated Steel None
Epoxy Coated Steel NoneSteel None
Fiberglass Reinforced Plastic Double-Walled
Fiberglass Reinforced Plastic Double-WalledFiberglass Reinforced Plastic Excavation Liner
Fiberglass Reinforced Plastic Double-WalledFiberglass Reinforced Plastic None
Fiberglass Reinforced Plastic Double-WalledFiberglass Reinforced Plastic NonePolyethylene Tank Jacket Double-Walled
Fiberglass Reinforced Plastic Double-WalledPolyethylene Tank Jacket Double-WalledSteel None
Fiberglass Reinforced Plastic Double-WalledPolyethylene Tank Jacket None
Fiberglass Reinforced Plastic Double-WalledSteel None
Fiberglass Reinforced Plastic Excavation Liner
Fiberglass Reinforced Plastic None
Fiberglass Reinforced Plastic NonePolyethylene Tank Jacket Double-Walled
Fiberglass Reinforced Plastic NoneSteel Excavation Liner
Fiberglass Reinforced Plastic NoneSteel None
Polyethylene Tank Jacket Double-Walled
Polyethylene Tank Jacket Double-WalledPolyethylene Tank Jacket None
Polyethylene Tank Jacket Excavation Liner
Polyethylene Tank Jacket None
Polyethylene Tank Jacket NoneSteel None
Steel Double-Walled
Steel Double-WalledSteel None
Steel Excavation Liner
Steel None
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Carbon Steel Fiberglass Jacket Double-Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Carbon Steel Fiberglass Jacket Double-WalledComposite (Steel w/FRP or Epoxy Coating) Double-Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Carbon Steel Fiberglass Jacket Double-WalledComposite (Steel w/FRP or Epoxy Coating) None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Composite (Fiberglass/polyurethane-coated) Double-Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Composite (Fiberglass/polyurethane-coated) Double-WalledComposite Double-Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Composite (Fiberglass/polyurethane-coated) Double-WalledComposite Double-WalledFiberglass Reinforced Plastic NoneSteel None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Composite (Fiberglass/polyurethane-coated) Double-WalledPolyethylene Tank Jacket Double-Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Composite (Fiberglass/polyurethane-coated) None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Composite (Fiberglass/polyurethane-coated) NoneComposite Double-WalledSteel None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Composite (Fiberglass/polyurethane-coated) NoneEpoxy Coated Steel None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Composite (Steel w/FRP or Epoxy Coating) Double-Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Composite (Steel w/FRP or Epoxy Coating) Double-WalledComposite Double-Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Composite (Steel w/FRP or Epoxy Coating) Double-WalledFiberglass Reinforced Plastic Double-Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Composite (Steel w/FRP or Epoxy Coating) Double-WalledPolyethylene Tank Jacket None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Composite (Steel w/FRP or Epoxy Coating) Double-WalledSteel None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Composite (Steel w/FRP or Epoxy Coating) None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Composite (Steel w/FRP or Epoxy Coating) NoneSteel None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Composite Double-Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Composite Double-WalledEpoxy Coated Steel Double-Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Composite Double-WalledEpoxy Coated Steel None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Composite Double-WalledFiberglass Reinforced Plastic Double-Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Composite Double-WalledFiberglass Reinforced Plastic None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Composite Double-WalledPolyethylene Tank Jacket Double-Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Composite Double-WalledPolyethylene Tank Jacket None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Composite Double-WalledSteel Double-Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Composite Double-WalledSteel None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Composite None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Epoxy Coated Steel Double-Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Epoxy Coated Steel None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Epoxy Coated Steel NoneSteel None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Fiberglass Reinforced Plastic Double-Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Fiberglass Reinforced Plastic Double-WalledFiberglass Reinforced Plastic Excavation Liner', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Fiberglass Reinforced Plastic Double-WalledFiberglass Reinforced Plastic None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Fiberglass Reinforced Plastic Double-WalledFiberglass Reinforced Plastic NonePolyethylene Tank Jacket Double-Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Fiberglass Reinforced Plastic Double-WalledPolyethylene Tank Jacket Double-WalledSteel None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Fiberglass Reinforced Plastic Double-WalledPolyethylene Tank Jacket None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Fiberglass Reinforced Plastic Double-WalledSteel None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Fiberglass Reinforced Plastic Excavation Liner', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Fiberglass Reinforced Plastic None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Fiberglass Reinforced Plastic NonePolyethylene Tank Jacket Double-Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Fiberglass Reinforced Plastic NoneSteel Excavation Liner', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Fiberglass Reinforced Plastic NoneSteel None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Polyethylene Tank Jacket Double-Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Polyethylene Tank Jacket Double-WalledPolyethylene Tank Jacket None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Polyethylene Tank Jacket Excavation Liner', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Polyethylene Tank Jacket None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Polyethylene Tank Jacket NoneSteel None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Steel Double-Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Steel Double-WalledSteel None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Steel Excavation Liner', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4317, 'Steel None', '', null);

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

--select distinct "substance" from wv_ust."erg_comp_substances" where "substance" is not null order by 1;
/* Organization values are:

AV Gas
Biodiesel
Crude Oil
DEF
Diesel
Diesel-offroad
Diesel-onroad
Diesel-ultra low sulfur
E85
Empty
Ethanol
Ethanol Free
ETHYLENE GLYCOL
Gasohol
Gasoline
Hazardous Substance
Heating Oil
Hydraulic Oil
Jet Fuel
Kerosene
Midgrade Unleaded
Mixture
Motor Oil
New Oil
Not Listed
Other
Premium Unleaded
Regular Unleaded
Unknown
Used Oil
Waste Oil
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4291, 'AV Gas', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4291, 'Biodiesel', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4291, 'Crude Oil', 'Crude oil', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4291, 'DEF', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4291, 'Diesel', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4291, 'Diesel-offroad', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4291, 'Diesel-onroad', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4291, 'Diesel-ultra low sulfur', 'Gasoline (unknown type)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4291, 'E85', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4291, 'Empty', 'Empty', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4291, 'Ethanol', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4291, 'Ethanol Free', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4291, 'ETHYLENE GLYCOL', 'Hazardous substance', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4291, 'Gasohol', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4291, 'Gasoline', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4291, 'Hazardous Substance', 'Hazardous substance', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4291, 'Heating Oil', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4291, 'Hydraulic Oil', 'Hydraulic oil', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4291, 'Jet Fuel', 'Jet fuel', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4291, 'Kerosene', 'Kerosene', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4291, 'Midgrade Unleaded', 'Gasoline (unknown type)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4291, 'Mixture', 'Mixture', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4291, 'Motor Oil', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4291, 'New Oil', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4291, 'Not Listed', 'Other or mixture', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4291, 'Other', 'Other', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4291, 'Premium Unleaded', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4291, 'Regular Unleaded', 'Gasoline (unknown type)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4291, 'Unknown', 'Unknown', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4291, 'Used Oil', 'Used oil', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4291, 'Waste Oil', 'Waste oil', null);

--select substance from public.substances where inactive_flag is null and ust_flag is not null order by substance_group, substance;
/* Valid EPA values are:

Aviation biofuel
Aviation gasoline
Biojet (diesel)
Jet fuel
Sustainable aviation fuel/aviation fuel blend
Unknown aviation gas or jet fuel
Diesel blend (b-unknown)
Diesel blend containing 99% to less than 100% biodiesel
Diesel blend containing greater than 20% and less than 99% biodiesel
Diesel blends containing greater than 5% and up to 20% or less biodiesel
Diesel fuel (ASTM D975), can contain 0-5% biodiesel
Low sulfur diesel
Off-road diesel/dyed diesel
E-85/Flex Fuel (E51-E83)
E-98
Ethanol blend gasoline (e-unknown)
Gasoline (non-ethanol)
Gasoline (unknown type)
Gasoline E-10 (E1-E10)
Gasoline E-15 (E-11-E15)
Gasoline E-20
Gasoline E-30
Gasoline/ethanol blend containing more than 83% and less than 98% ethanol
Gasoline/ethanol blends containing greater than 15% and less than 51% ethanol
Leaded gasoline
Racing fuel
Biofuel/bioheat
Heating oil/fuel oil 1
Heating oil/fuel oil 2
Heating oil/fuel oil 4
Heating oil/fuel oil 5
Heating oil/fuel oil 6
Heating/fuel oil # unknown
Crude oil
Hydraulic oil
Kerosene
Lube/motor oil (new)
Oil unspecified
Transformer oil
Transmission fluid
Used oil
Used oil/waste oil (unspecified)
Waste oil
Antifreeze
Asphalt
Empty
Hazardous substance
Mineral spirits
Mixture
MTBE
Multiple products listed
Other
Petroleum product
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
WV does not report at the Compartment level, but CompartmentStatus is required.

Copy the tank status mapping down to the compartment!
The lookup tables for compartment_statuses and tank_stasuses are the same.
 */

--select distinct "Tank Status" from wv_ust."USTTanksPublic" where "Tank Status" is not null order by 1;
/* Organization values are:

Abandoned
Currently In Use
Currently In Use
Temporarily Out of Service
Permanently Out of Service
Temporarily Out of Service
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4295, 'Abandoned', 'Abandoned', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4295, 'Currently In Use', 'Currently in use', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4295, 'Currently In Use\nTemporarily Out of Service', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4295, 'Permanently Out of Service', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4295, 'Temporarily Out of Service', 'Temporarily out of service', null);

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

--select distinct "Active Spill Prevention" from wv_ust."AllFacilitiesDetails" where "Active Spill Prevention" is not null order by 1;
/* Organization values are:

Double Walled Spill Bucket
Double Walled Spill BucketSpill Bucket
Not Required
Not RequiredSpill Bucket
Spill Basin
Spill BasinSpill Bucket
Spill Bucket
Spill BucketSpill Containment
Spill Containment
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4302, 'Double Walled Spill Bucket', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4302, 'Double Walled Spill BucketSpill Bucket', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4302, 'Not Required', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4302, 'Not RequiredSpill Bucket', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4302, 'Spill Basin', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4302, 'Spill BasinSpill Bucket', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4302, 'Spill Bucket', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4302, 'Spill BucketSpill Containment', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4302, 'Spill Containment', '', null);

--select spill_bucket_wall_type from public.spill_bucket_wall_types;
/* Valid EPA values are:

Unknown
Single wall
Double wall

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

--select distinct "substance" from wv_ust."erg_comp_substances" where "substance" is not null order by 1;
/* Organization values are:

AV Gas
Biodiesel
Crude Oil
DEF
Diesel
Diesel-offroad
Diesel-onroad
Diesel-ultra low sulfur
E85
Empty
Ethanol
Ethanol Free
ETHYLENE GLYCOL
Gasohol
Gasoline
Hazardous Substance
Heating Oil
Hydraulic Oil
Jet Fuel
Kerosene
Midgrade Unleaded
Mixture
Motor Oil
New Oil
Not Listed
Other
Premium Unleaded
Regular Unleaded
Unknown
Used Oil
Waste Oil
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4306, 'AV Gas', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4306, 'Biodiesel', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4306, 'Crude Oil', 'Crude oil', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4306, 'DEF', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4306, 'Diesel', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4306, 'Diesel-offroad', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4306, 'Diesel-onroad', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4306, 'Diesel-ultra low sulfur', 'Gasoline (unknown type)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4306, 'E85', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4306, 'Empty', 'Empty', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4306, 'Ethanol', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4306, 'Ethanol Free', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4306, 'ETHYLENE GLYCOL', 'Hazardous substance', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4306, 'Gasohol', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4306, 'Gasoline', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4306, 'Hazardous Substance', 'Hazardous substance', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4306, 'Heating Oil', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4306, 'Hydraulic Oil', 'Hydraulic oil', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4306, 'Jet Fuel', 'Jet fuel', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4306, 'Kerosene', 'Kerosene', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4306, 'Midgrade Unleaded', 'Gasoline (unknown type)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4306, 'Mixture', 'Mixture', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4306, 'Motor Oil', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4306, 'New Oil', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4306, 'Not Listed', 'Other or mixture', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4306, 'Other', 'Other', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4306, 'Premium Unleaded', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4306, 'Regular Unleaded', 'Gasoline (unknown type)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4306, 'Unknown', 'Unknown', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4306, 'Used Oil', 'Used oil', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4306, 'Waste Oil', 'Waste oil', null);

--select substance from public.substances where inactive_flag is null and ust_flag is not null order by substance_group, substance;
/* Valid EPA values are:

Aviation biofuel
Aviation gasoline
Biojet (diesel)
Jet fuel
Sustainable aviation fuel/aviation fuel blend
Unknown aviation gas or jet fuel
Diesel blend (b-unknown)
Diesel blend containing 99% to less than 100% biodiesel
Diesel blend containing greater than 20% and less than 99% biodiesel
Diesel blends containing greater than 5% and up to 20% or less biodiesel
Diesel fuel (ASTM D975), can contain 0-5% biodiesel
Low sulfur diesel
Off-road diesel/dyed diesel
E-85/Flex Fuel (E51-E83)
E-98
Ethanol blend gasoline (e-unknown)
Gasoline (non-ethanol)
Gasoline (unknown type)
Gasoline E-10 (E1-E10)
Gasoline E-15 (E-11-E15)
Gasoline E-20
Gasoline E-30
Gasoline/ethanol blend containing more than 83% and less than 98% ethanol
Gasoline/ethanol blends containing greater than 15% and less than 51% ethanol
Leaded gasoline
Racing fuel
Biofuel/bioheat
Heating oil/fuel oil 1
Heating oil/fuel oil 2
Heating oil/fuel oil 4
Heating oil/fuel oil 5
Heating oil/fuel oil 6
Heating/fuel oil # unknown
Crude oil
Hydraulic oil
Kerosene
Lube/motor oil (new)
Oil unspecified
Transformer oil
Transmission fluid
Used oil
Used oil/waste oil (unspecified)
Waste oil
Antifreeze
Asphalt
Empty
Hazardous substance
Mineral spirits
Mixture
MTBE
Multiple products listed
Other
Petroleum product
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

--select distinct "Active Pipes Construction" from wv_ust."AllFacilitiesDetails" where "Active Pipes Construction" is not null order by 1;
/* Organization values are:

Above Ground Exempt
Above Ground ExemptFRP Exempt
Above Ground None
Above Ground NoneFRP Double WalledSteel Double Walled
Flexible Plastic -  Double Walled Double Walled
Flexible Plastic -  Double Walled Double WalledFlexible Plastic -  Double Walled None
Flexible Plastic -  Double Walled Double WalledFlexible Plastic -  Double Walled Secondary Containment
Flexible Plastic -  Double Walled Double WalledFlexible Plastic - Single Walled Double Walled
Flexible Plastic -  Double Walled Double WalledFlexible Plastic Double Walled
Flexible Plastic -  Double Walled Double WalledFlexible Plastic Double WalledFlexible Plastic NoneFRP None
Flexible Plastic -  Double Walled Double WalledFRP -  Double Walled Double Walled
Flexible Plastic -  Double Walled Double WalledFRP Double Walled
Flexible Plastic -  Double Walled Double WalledFRP None
Flexible Plastic -  Double Walled Double WalledFRP NoneSteel Double Walled
Flexible Plastic -  Double Walled None
Flexible Plastic -  Double Walled NoneFlexible Plastic -  Double Walled Secondary Containment
Flexible Plastic -  Double Walled NoneFlexible Plastic - Single Walled None
Flexible Plastic -  Double Walled NoneFlexible Plastic Double Walled
Flexible Plastic -  Double Walled Secondary Containment
Flexible Plastic - Single Walled Double Walled
Flexible Plastic - Single Walled None
Flexible Plastic Double Walled
Flexible Plastic Double WalledFlexible Plastic None
Flexible Plastic Double WalledFRP -  Double Walled Double Walled
Flexible Plastic Double WalledFRP Double Walled
Flexible Plastic Double WalledFRP Double WalledFRP None
Flexible Plastic Double WalledFRP None
Flexible Plastic Double WalledFRP Secondary Containment
Flexible Plastic Double WalledSteel Double Walled
Flexible Plastic None
Flexible Plastic NoneFlexible Plastic Secondary Containment
Flexible Plastic NoneFRP None
Flexible Plastic Secondary Containment
FRP -  Double Walled Double Walled
FRP -  Double Walled Secondary Containment
FRP Double Walled
FRP Double WalledFRP None
FRP Double WalledFRP Secondary Containment
FRP Double WalledSteel Double Walled
FRP None
FRP NoneFRP Secondary Containment
FRP NoneNo Piping None
FRP Secondary Containment
No Piping None
Steel Double Walled
Steel None
Steel Pipe within Chase Double Walled
Steel Secondary Containment
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'Above Ground Exempt', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'Above Ground ExemptFRP Exempt', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'Above Ground None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'Above Ground NoneFRP Double WalledSteel Double Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'Flexible Plastic -  Double Walled Double Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'Flexible Plastic -  Double Walled Double WalledFlexible Plastic -  Double Walled None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'Flexible Plastic -  Double Walled Double WalledFlexible Plastic -  Double Walled Secondary Containment', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'Flexible Plastic -  Double Walled Double WalledFlexible Plastic - Single Walled Double Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'Flexible Plastic -  Double Walled Double WalledFlexible Plastic Double Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'Flexible Plastic -  Double Walled Double WalledFlexible Plastic Double WalledFlexible Plastic NoneFRP None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'Flexible Plastic -  Double Walled Double WalledFRP -  Double Walled Double Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'Flexible Plastic -  Double Walled Double WalledFRP Double Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'Flexible Plastic -  Double Walled Double WalledFRP None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'Flexible Plastic -  Double Walled Double WalledFRP NoneSteel Double Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'Flexible Plastic -  Double Walled None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'Flexible Plastic -  Double Walled NoneFlexible Plastic -  Double Walled Secondary Containment', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'Flexible Plastic -  Double Walled NoneFlexible Plastic - Single Walled None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'Flexible Plastic -  Double Walled NoneFlexible Plastic Double Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'Flexible Plastic -  Double Walled Secondary Containment', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'Flexible Plastic - Single Walled Double Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'Flexible Plastic - Single Walled None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'Flexible Plastic Double Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'Flexible Plastic Double WalledFlexible Plastic None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'Flexible Plastic Double WalledFRP -  Double Walled Double Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'Flexible Plastic Double WalledFRP Double Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'Flexible Plastic Double WalledFRP Double WalledFRP None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'Flexible Plastic Double WalledFRP None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'Flexible Plastic Double WalledFRP Secondary Containment', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'Flexible Plastic Double WalledSteel Double Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'Flexible Plastic None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'Flexible Plastic NoneFlexible Plastic Secondary Containment', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'Flexible Plastic NoneFRP None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'Flexible Plastic Secondary Containment', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'FRP -  Double Walled Double Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'FRP -  Double Walled Secondary Containment', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'FRP Double Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'FRP Double WalledFRP None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'FRP Double WalledFRP Secondary Containment', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'FRP Double WalledSteel Double Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'FRP None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'FRP NoneFRP Secondary Containment', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'FRP NoneNo Piping None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'FRP Secondary Containment', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'No Piping None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'Steel Double Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'Steel None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'Steel Pipe within Chase Double Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4311, 'Steel Secondary Containment', '', null);

--select piping_style from public.piping_styles;
/* Valid EPA values are:

Suction
Pressure
Hydrant
Other
Unknown
No piping
Non-operational e.g., fill line, vent line, gravity
Aboveground/not regulated
Siphon

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

--select distinct "Active Pipes Construction" from wv_ust."AllFacilitiesDetails" where "Active Pipes Construction" is not null order by 1;
/* Organization values are:

Above Ground Exempt
Above Ground ExemptFRP Exempt
Above Ground None
Above Ground NoneFRP Double WalledSteel Double Walled
Flexible Plastic -  Double Walled Double Walled
Flexible Plastic -  Double Walled Double WalledFlexible Plastic -  Double Walled None
Flexible Plastic -  Double Walled Double WalledFlexible Plastic -  Double Walled Secondary Containment
Flexible Plastic -  Double Walled Double WalledFlexible Plastic - Single Walled Double Walled
Flexible Plastic -  Double Walled Double WalledFlexible Plastic Double Walled
Flexible Plastic -  Double Walled Double WalledFlexible Plastic Double WalledFlexible Plastic NoneFRP None
Flexible Plastic -  Double Walled Double WalledFRP -  Double Walled Double Walled
Flexible Plastic -  Double Walled Double WalledFRP Double Walled
Flexible Plastic -  Double Walled Double WalledFRP None
Flexible Plastic -  Double Walled Double WalledFRP NoneSteel Double Walled
Flexible Plastic -  Double Walled None
Flexible Plastic -  Double Walled NoneFlexible Plastic -  Double Walled Secondary Containment
Flexible Plastic -  Double Walled NoneFlexible Plastic - Single Walled None
Flexible Plastic -  Double Walled NoneFlexible Plastic Double Walled
Flexible Plastic -  Double Walled Secondary Containment
Flexible Plastic - Single Walled Double Walled
Flexible Plastic - Single Walled None
Flexible Plastic Double Walled
Flexible Plastic Double WalledFlexible Plastic None
Flexible Plastic Double WalledFRP -  Double Walled Double Walled
Flexible Plastic Double WalledFRP Double Walled
Flexible Plastic Double WalledFRP Double WalledFRP None
Flexible Plastic Double WalledFRP None
Flexible Plastic Double WalledFRP Secondary Containment
Flexible Plastic Double WalledSteel Double Walled
Flexible Plastic None
Flexible Plastic NoneFlexible Plastic Secondary Containment
Flexible Plastic NoneFRP None
Flexible Plastic Secondary Containment
FRP -  Double Walled Double Walled
FRP -  Double Walled Secondary Containment
FRP Double Walled
FRP Double WalledFRP None
FRP Double WalledFRP Secondary Containment
FRP Double WalledSteel Double Walled
FRP None
FRP NoneFRP Secondary Containment
FRP NoneNo Piping None
FRP Secondary Containment
No Piping None
Steel Double Walled
Steel None
Steel Pipe within Chase Double Walled
Steel Secondary Containment
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'Above Ground Exempt', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'Above Ground ExemptFRP Exempt', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'Above Ground None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'Above Ground NoneFRP Double WalledSteel Double Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'Flexible Plastic -  Double Walled Double Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'Flexible Plastic -  Double Walled Double WalledFlexible Plastic -  Double Walled None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'Flexible Plastic -  Double Walled Double WalledFlexible Plastic -  Double Walled Secondary Containment', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'Flexible Plastic -  Double Walled Double WalledFlexible Plastic - Single Walled Double Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'Flexible Plastic -  Double Walled Double WalledFlexible Plastic Double Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'Flexible Plastic -  Double Walled Double WalledFlexible Plastic Double WalledFlexible Plastic NoneFRP None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'Flexible Plastic -  Double Walled Double WalledFRP -  Double Walled Double Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'Flexible Plastic -  Double Walled Double WalledFRP Double Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'Flexible Plastic -  Double Walled Double WalledFRP None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'Flexible Plastic -  Double Walled Double WalledFRP NoneSteel Double Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'Flexible Plastic -  Double Walled None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'Flexible Plastic -  Double Walled NoneFlexible Plastic -  Double Walled Secondary Containment', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'Flexible Plastic -  Double Walled NoneFlexible Plastic - Single Walled None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'Flexible Plastic -  Double Walled NoneFlexible Plastic Double Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'Flexible Plastic -  Double Walled Secondary Containment', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'Flexible Plastic - Single Walled Double Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'Flexible Plastic - Single Walled None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'Flexible Plastic Double Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'Flexible Plastic Double WalledFlexible Plastic None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'Flexible Plastic Double WalledFRP -  Double Walled Double Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'Flexible Plastic Double WalledFRP Double Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'Flexible Plastic Double WalledFRP Double WalledFRP None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'Flexible Plastic Double WalledFRP None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'Flexible Plastic Double WalledFRP Secondary Containment', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'Flexible Plastic Double WalledSteel Double Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'Flexible Plastic None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'Flexible Plastic NoneFlexible Plastic Secondary Containment', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'Flexible Plastic NoneFRP None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'Flexible Plastic Secondary Containment', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'FRP -  Double Walled Double Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'FRP -  Double Walled Secondary Containment', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'FRP Double Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'FRP Double WalledFRP None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'FRP Double WalledFRP Secondary Containment', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'FRP Double WalledSteel Double Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'FRP None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'FRP NoneFRP Secondary Containment', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'FRP NoneNo Piping None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'FRP Secondary Containment', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'No Piping None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'Steel Double Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'Steel None', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'Steel Pipe within Chase Double Walled', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (4316, 'Steel Secondary Containment', '', null);

--select piping_wall_type from public.piping_wall_types;
/* Valid EPA values are:

Single wall
Double wall
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
where ust_control_id = 11 and epa_column_name = 'tank_material_description_id'
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
