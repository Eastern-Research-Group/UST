------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--facility_type1

--select distinct "FACILITY USE CODE" from me_ust."tanks" where "FACILITY USE CODE" is not null order by 1;
/* Organization values are:

AGGREGATE MINING
CHEMICAL STORAGE
COMBINED FILE
COMMERCIAL
FARM
FEDERAL FACILITY
HYDRAULIC LIFTS
INDUSTRIAL
MULTIPLE RESIDENCE
PRIVATE FUELING  
PUBLIC FACILITY
RETAIL OIL
SINGLE RESIDENCE
STATE FACILITY
TOWN "&" SCHOOL
UNKNOWN ADDRESS
WHOLESALE OIL
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2546, 'AGGREGATE MINING', 'Other', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2546, 'CHEMICAL STORAGE', 'Bulk plant storage/petroleum distributor', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2546, 'COMBINED FILE', 'Other', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2546, 'COMMERCIAL', 'Commercial', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2546, 'FARM', 'Agricultural/farm', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2546, 'FEDERAL FACILITY', 'Federal government, non-military', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2546, 'HYDRAULIC LIFTS', 'Other', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2546, 'INDUSTRIAL', 'Industrial', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2546, 'MULTIPLE RESIDENCE', 'Residential', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2546, 'PRIVATE FUELING  ', 'Other', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2546, 'PUBLIC FACILITY', 'Other', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2546, 'RETAIL OIL', 'Retail fuel sales (non-marina)', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2546, 'SINGLE RESIDENCE', 'Residential', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2546, 'STATE FACILITY', 'State/local government', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2546, 'TOWN "&" SCHOOL', 'School', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2546, 'UNKNOWN ADDRESS', 'Unknown', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2546, 'WHOLESALE OIL', 'Wholesale', 'Please Verify; Mapped by ERG');

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
--tank_location_id

--select distinct "TANK ABOVE BELOW" from me_ust."tanks" where "TANK ABOVE BELOW" is not null order by 1;
/* Organization values are:

ABOVEGROUND
BELOWGROUND
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2557, 'ABOVEGROUND', 'Aboveground (tank bottom abovegrade)', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2557, 'BELOWGROUND', 'Underground (entirely buried)', 'mapped by ERG');

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

--select distinct "TANK STATUS" from me_ust."tanks" where "TANK STATUS" is not null order by 1;
/* Organization values are:

ABANDONED_IN_PLACE
ACTIVE
ACTIVE_NON_REGULATED
COMBINED_FILE
NEVER_INSTALLED
OUT_OF_SERVICE
PLANNED
PLANNED_FOR_ABANDONMENT
PLANNED_FOR_REMOVAL
REMOVED
TRANSFER
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2558, 'ABANDONED_IN_PLACE', 'Abandoned', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2558, 'ACTIVE', 'Currently in use', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2558, 'ACTIVE_NON_REGULATED', 'Currently in use', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2558, 'COMBINED_FILE', 'Other', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2558, 'NEVER_INSTALLED', 'Other', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2558, 'OUT_OF_SERVICE', 'Closed (general)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2558, 'PLANNED', 'Other', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2558, 'PLANNED_FOR_ABANDONMENT', 'Other', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2558, 'PLANNED_FOR_REMOVAL', 'Other', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2558, 'REMOVED', 'Closed (removed from ground)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2558, 'TRANSFER', 'Other', 'Please Verify; Mapped by ERG');

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

--select distinct "TANK MATERIAL LABEL" from me_ust."tanks" where "TANK MATERIAL LABEL" is not null order by 1;
/* Organization values are:

BLACK STEEL
COMPOSITE - F/GLASS - BONDED TO STEEL
COMPOSITE - SECONDARY CONTAINMENT
COMPOSITE WITH CATHODIC PROTECTION
CONCRETE
COPPER
DOUBLE-WALLED CP STEEL
F/GLASS - PETROLEUM
F/GLASS - SEC CONTAIN - PETRO & ALCOHOL
F/GLASS - SEC CONTAINMENT - PETRO ONLY
F/GLASS SINGLE-WALLED
FLEXIBLE DOUBLE-WALLED PIPING
FLEXIBLE SINGLE-WALLED PIPING
HYDRAULIC
JACKETED TANK - DOUBLE-WALLED
NONE
PVC
STAINLESS STEEL
STEEL - BARE OR ASPHALT COATED.
STEEL - BARE WITH INTERNAL LINING.
STEEL - COATED
STEEL WITH CATHODIC PROTECTION.
STEEL WITH SECONDARY CONTAINMENT.
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2565, 'BLACK STEEL', 'Asphalt coated or bare steel', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2565, 'COMPOSITE - F/GLASS - BONDED TO STEEL', 'Composite/clad (steel w/fiberglass reinforced plastic)', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2565, 'COMPOSITE - SECONDARY CONTAINMENT', 'Composite/clad (steel w/fiberglass reinforced plastic)', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2565, 'COMPOSITE WITH CATHODIC PROTECTION', 'Cathodically protected steel (without coating)', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2565, 'CONCRETE', 'Concrete', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2565, 'COPPER', 'Other', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2565, 'DOUBLE-WALLED CP STEEL', 'Cathodically protected steel (without coating)', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2565, 'F/GLASS - PETROLEUM', 'Fiberglass reinforced plastic', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2565, 'F/GLASS - SEC CONTAIN - PETRO & ALCOHOL', 'Fiberglass reinforced plastic', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2565, 'F/GLASS - SEC CONTAINMENT - PETRO ONLY', 'Fiberglass reinforced plastic', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2565, 'F/GLASS SINGLE-WALLED', 'Fiberglass reinforced plastic', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2565, 'FLEXIBLE DOUBLE-WALLED PIPING', 'Other', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2565, 'FLEXIBLE SINGLE-WALLED PIPING', 'Other', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2565, 'HYDRAULIC', 'Other', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2565, 'JACKETED TANK - DOUBLE-WALLED', 'Jacketed steel', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2565, 'NONE', 'Other', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2565, 'PVC', 'Other', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2565, 'STAINLESS STEEL', 'Steel (NEC)', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2565, 'STEEL - BARE OR ASPHALT COATED.', 'Asphalt coated or bare steel', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2565, 'STEEL - BARE WITH INTERNAL LINING.', 'Asphalt coated or bare steel', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2565, 'STEEL - COATED', 'Coated and cathodically protected steel', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2565, 'STEEL WITH CATHODIC PROTECTION.', 'Cathodically protected steel (without coating)', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2565, 'STEEL WITH SECONDARY CONTAINMENT.', 'Steel (NEC)', 'Please Verify; Mapped by ERG');

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
--substance_id

--select distinct "PRODUCT STORED" from me_ust."tanks" where "PRODUCT STORED" is not null order by 1;
/* Organization values are:

#1 FUEL OIL - KEROSENE
#2 FUEL OIL
#4 FUEL OIL
#5 FUEL OIL
#6 FUEL OIL
ANIMAL FATS/REMAINS
ANTI-FREEZE
ASPHALT
AVIATION GASOLINE
BIO 1-74
BIO 100
BIO 75-99
CHEMICAL
CORROSIVE
CRUDE OIL
DIESEL
E-100
E-85
GASOLINE UNSPECIFIED
GLYCEROL
HAZARDOUS CHEMICAL - SPECIFIED IN REPORT
HAZARDOUS CHEMICAL - UNSPECIFIED
HYDRAULIC OIL
JET FUEL
JP1
JP4
LEADED GASOLINE
LUBE OIL
METHANOL
NON-CHEMICAL NON-OIL SPECIFIED IN REPORT
NON-CHEMICAL NON-OIL UNSPECIFIED
NON-HAZARDOUS CHEMICAL - SPECIFIED IN REPORT
NON-HAZARDOUS CHEMICAL - UNSPECIFIED
NONE
OIL - OTHER - SPECIFIED IN REPORT
PETROLEUM CONTAMINATED WASTEWATER
PREMIUM UNLEADED
REGULAR GASOLINE
TRANSFORMER OIL
TRANSMISSION OIL
UNKNOWN SUBSTANCE
UNLEADED GASOLINE
UNLEADED PLUS
UNSPECIFIED FUEL OIL
UNSPECIFIED MOTOR FUEL
UNSPECIFIED OIL
WASTE OIL (AS HAZ CHEM)
WASTE OIL/USED MOTOR OIL
WATER STORAGE
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, '#1 FUEL OIL - KEROSENE', 'Kerosene', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, '#2 FUEL OIL', 'Heating oil/fuel oil 2', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, '#4 FUEL OIL', 'Heating oil/fuel oil 4', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, '#5 FUEL OIL', 'Heating oil/fuel oil 5', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, '#6 FUEL OIL', 'Heating oil/fuel oil 6', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'ANIMAL FATS/REMAINS', 'Other or mixture', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'ANTI-FREEZE', 'Antifreeze', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'ASPHALT', 'Petroleum product', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'AVIATION GASOLINE', 'Aviation gasoline', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'BIO 1-74', 'Diesel fuel (b-unknown)', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'BIO 100', '100% biodiesel (B100, not federally regulated)', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'BIO 75-99', 'Diesel fuel (b-unknown)', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'CHEMICAL', 'Other or mixture', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'CORROSIVE', 'Other or mixture', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'CRUDE OIL', 'Petroleum product', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'DIESEL', 'Diesel fuel (b-unknown)', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'E-100', 'Denatured ethanol (98%)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'E-85', 'E-85/Flex Fuel (E51-E83)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'GASOLINE UNSPECIFIED', 'Gasoline (unknown type)', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'GLYCEROL', 'Solvent', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'HAZARDOUS CHEMICAL - SPECIFIED IN REPORT', 'Hazardous substance', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'HAZARDOUS CHEMICAL - UNSPECIFIED', 'Hazardous substance', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'HYDRAULIC OIL', 'Hydraulic oil', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'JET FUEL', 'Unknown aviation gas or jet fuel', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'JP1', 'Unknown aviation gas or jet fuel', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'JP4', 'Unknown aviation gas or jet fuel', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'LEADED GASOLINE', 'Leaded gasoline', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'LUBE OIL', 'Lube/motor oil (new)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'METHANOL', 'Hazardous substance', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'NON-CHEMICAL NON-OIL SPECIFIED IN REPORT', 'Other or mixture', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'NON-CHEMICAL NON-OIL UNSPECIFIED', 'Other or mixture', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'NON-HAZARDOUS CHEMICAL - SPECIFIED IN REPORT', 'Other or mixture', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'NON-HAZARDOUS CHEMICAL - UNSPECIFIED', 'Other or mixture', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'NONE', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'OIL - OTHER - SPECIFIED IN REPORT', 'Other or mixture', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'PETROLEUM CONTAMINATED WASTEWATER', 'Other or mixture', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'PREMIUM UNLEADED', 'Gasoline (unknown type)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'REGULAR GASOLINE', 'Gasoline (unknown type)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'TRANSFORMER OIL', 'Lube/motor oil (new)', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'TRANSMISSION OIL', 'Lube/motor oil (new)', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'UNKNOWN SUBSTANCE', 'Unknown', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'UNLEADED GASOLINE', 'Gasoline (unknown type)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'UNLEADED PLUS', 'Gasoline (unknown type)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'UNSPECIFIED FUEL OIL', 'Heating/fuel oil # unknown', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'UNSPECIFIED MOTOR FUEL', 'Heating/fuel oil # unknown', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'UNSPECIFIED OIL', 'Heating/fuel oil # unknown', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'WASTE OIL (AS HAZ CHEM)', 'Used oil/waste oil', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'WASTE OIL/USED MOTOR OIL', 'Used oil/waste oil', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2568, 'WATER STORAGE', 'Other or mixture', null);

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

--select distinct "TANK STATUS LABEL" from me_ust."tanks" where "TANK STATUS LABEL" is not null order by 1;
/* Organization values are:

ABANDONED IN PLACE
ACTIVE
ACTIVE NON-REGULATED
COMBINED FILE
NEVER INSTALLED
OUT OF SERVICE
PLANNED FOR ABANDONMENT
PLANNED FOR INSTALLATION
PLANNED FOR REMOVAL
REMOVED
TRANSFER
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2572, 'ABANDONED IN PLACE', 'Abandoned', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2572, 'ACTIVE', 'Currently in use', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2572, 'ACTIVE NON-REGULATED', 'Currently in use', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2572, 'COMBINED FILE', 'Other', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2572, 'NEVER INSTALLED', 'Other', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2572, 'OUT OF SERVICE', 'Closed (general)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2572, 'PLANNED FOR ABANDONMENT', 'Other', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2572, 'PLANNED FOR INSTALLATION', 'Other', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2572, 'PLANNED FOR REMOVAL', 'Other', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2572, 'REMOVED', 'Closed (removed from ground)', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2572, 'TRANSFER', 'Other', 'Please Verify; Mapped by ERG');

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
--piping_style_id

--select distinct "CHAMBER_PUMP_TYPE_LABEL" from me_ust."tanks" where "CHAMBER_PUMP_TYPE_LABEL" is not null order by 1;
/* Organization values are:

NONE
PRESSURIZED
SIPHON
SUCTION
SUCTION & RETURN
TANK MOUNTED
UNKNOWN
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2583, 'NONE', 'No piping', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2583, 'PRESSURIZED', 'Pressure', 'Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2583, 'SIPHON', 'Other', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2583, 'SUCTION', 'Suction', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2583, 'SUCTION & RETURN', 'Suction', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2583, 'TANK MOUNTED', 'Other', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2583, 'UNKNOWN', 'Unknown', null);

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
where ust_control_id = 31 and epa_column_name = 'tank_material_description_id'
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

--BEFORE RUNNING THIS INSERT STATEMENT, MAKE SURE THE ORGANIZATION VALUE MEANS THAT CORROSION PROTECTION APPLIES TO THE PIPING!
insert into public.ust_element_mapping
	 (ust_control_id, epa_table_name, epa_column_name, 
	 organization_table_name, organization_column_name, 
	 query_logic, inferred_value_comment)
values(31, 'ust_piping', 'piping_corrosion_protection_sacrificial_anode', 'tanks', 'PIPE MATERIAL LABEL', 
	 'when "PIPE MATERIAL LABEL" = ''DOUBLE-WALLED CP STEEL'' then ''Yes'' else null', 'Inferred from tanks.PIPE MATERIAL LABEL')
on conflict (ust_control_id, epa_table_name, epa_column_name) 
do update set organization_table_name = excluded.organization_table_name,
              organization_column_name = excluded.organization_column_name,
              query_logic = excluded.query_logic,
              inferred_value_comment = excluded.inferred_value_comment;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
