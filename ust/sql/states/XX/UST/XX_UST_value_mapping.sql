------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--tank_location_id

--select distinct "Tank Type" from example."Tanks" where "Tank Type" is not null order by 1;
/* Organization values are:

AST
UST
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into example.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, exclude_from_query)
values (18, 'AST', 'Aboveground (tank bottom abovegrade)', 'Y');
insert into example.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (18, 'UST', 'Underground (entirely buried)', null);

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
from example.v_ust_element_mapping
where epa_column_name = 'tank_location_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check example.tank_locations to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--tank_status_id

--select distinct "Tank Status Desc" from example."Tank Status Lookup" where "Tank Status Desc" is not null order by 1;
/* Organization values are:

Closed
Open
Temporarily Closed
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into example.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (13, 'Closed', 'Closed (general)', null);
insert into example.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (13, 'Open', 'Currently in use', null);
insert into example.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (13, 'Temporarily Closed', 'Temporarily out of service', null);

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
from example.v_ust_element_mapping
where epa_column_name = 'tank_status_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check example.tank_statuses to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--substance_id

--select distinct "Tank Substance" from example."erg_tank_substance_deagg" where "Tank Substance" is not null order by 1;
/* Organization values are:

Antifreeze
Diesel
Leaded Gasoline
Motor Oil
Premium Gasoline
Racing Gasoline
Unleaded Gasoline
Used Motor Oil
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into example.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (21, 'Antifreeze', 'Antifreeze', null);
insert into example.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (21, 'Diesel', 'Diesel fuel (b-unknown)', null);
insert into example.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (21, 'Leaded Gasoline', 'Leaded gasoline', null);
insert into example.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (21, 'Motor Oil', 'Lube/motor oil (new)', null);
insert into example.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (21, 'Premium Gasoline', 'Ethanol blend gasoline (e-unknown)', null);
insert into example.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (21, 'Racing Gasoline', 'Racing fuel', null);
insert into example.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (21, 'Unleaded Gasoline', 'Ethanol blend gasoline (e-unknown)', null);
insert into example.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (21, 'Used Motor Oil', 'Used oil/waste oil', null);

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
from example.v_ust_element_mapping
where epa_column_name = 'substance_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check example.substances to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--compartment_status_id

/*
XX does not report at the Compartment level, but CompartmentStatus is required.

Copy the tank status mapping down to the compartment!
The lookup tables for compartment_statuses and tank_stasuses are the same.
 */

--select distinct "Tank Status Desc" from example."Tank Status Lookup" where "Tank Status Desc" is not null order by 1;
/* Organization values are:

Closed
Open
Temporarily Closed
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into example.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (26, 'Closed', 'Closed (general)', null);
insert into example.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (26, 'Open', 'Currently in use', null);
insert into example.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (26, 'Temporarily Closed', 'Temporarily out of service', null);

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
from example.v_ust_element_mapping
where epa_column_name = 'compartment_status_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check example.compartment_statuses to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
