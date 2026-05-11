------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--release_status_id

--select distinct "Currentstatus" from tn_release."ust_all-tn-environmental-sites" where "Currentstatus" is not null order by 1;
/* Organization values are:

0 Suspected Release - RD records
0a Suspected Release - Closed
1 Tank Closure
13 Abandoned Facility Project
1a Completed Tank Closure
1b Closure Application Expired
1c Line Closure
1d Completed Line Closure
2 Site Check
3 Release Investigation
6 Corrective Action
7 Closure Monitoring
8 Case Closed
9 Other
*/

/*
Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
*/
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (71, '0 Suspected Release - RD records', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (71, '0a Suspected Release - Closed', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (71, '1 Tank Closure', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (71, '13 Abandoned Facility Project', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (71, '1a Completed Tank Closure', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (71, '1b Closure Application Expired', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (71, '1c Line Closure', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (71, '1d Completed Line Closure', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (71, '2 Site Check', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (71, '3 Release Investigation', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (71, '6 Corrective Action', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (71, '7 Closure Monitoring', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (71, '8 Case Closed', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (71, '9 Other', '', null);

--select release_status from public.release_statuses;
/* Valid EPA values are:

Active: general
Active: post corrective action monitoring
Active: corrective action
Active: site investigation
Active: stalled
No further action
Unknown
Other

Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_release_element_mapping
where epa_column_name = 'release_status_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_lust_element_mapping.
Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_lust_element_mapping
to do mapping, check public.release_statuses to find the updated epa_value.
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--how_release_detected_id

--select distinct "Howdiscovered" from tn_release."ust_all-tn-environmental-sites" where "Howdiscovered" is not null order by 1;
/* Organization values are:

1 At Closure
2 Release Detection
3 On-site Impact
3 On-Site Impact
4 Off-site Impact
4 Off-Site Impact
5 Site Check
6 Tightness Test
6 Tightness Testing
7 Environmental Audit
8 Other
9 Unknown
*/

/*
Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
*/
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (74, '1 At Closure', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (74, '2 Release Detection', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (74, '3 On-site Impact', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (74, '3 On-Site Impact', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (74, '4 Off-site Impact', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (74, '4 Off-Site Impact', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (74, '5 Site Check', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (74, '6 Tightness Test', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (74, '6 Tightness Testing', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (74, '7 Environmental Audit', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (74, '8 Other', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (74, '9 Unknown', '', null);

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

Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_release_element_mapping
where epa_column_name = 'how_release_detected_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_lust_element_mapping.
Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_lust_element_mapping
to do mapping, check public.how_release_detected to find the updated epa_value.
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--substance_id

--select distinct "Productreleased" from tn_release."ust_all-tn-environmental-sites" where "Productreleased" is not null order by 1;
/* Organization values are:

Diesel, Jet Fuel, Kerosene
Diesel, Jet Fuel, Kerosene, Waste Oil, Used Oil
Gasoline
Gasoline, Diesel, Jet Fuel, Kerosene
Gasoline, Diesel, Jet Fuel, Kerosene, Waste Oil, Used Oil
Unknown
Waste Oil, Used Oil
*/

--ORGANIZATION VALUES MAY NEED TO BE DEAGGREGATED!
--Review the organization values above. If there are multiple values in a single row, the values need to be deaggregated before proceeding.
--If there is a space before or after the delimiter in the organization value, INCLUDE the space in your delimiter variable.

/*
To deaggregate the organization values run deagg.py, setting the variables below:

ust_or_release = 'release' # valid values are 'ust' or 'release'
control_id = 5
table_name = 'ust_all-tn-environmental-sites'
column_name = 'Productreleased' 
delimiter = ', ' # defaults to ','; delimiter from the column beging deaggregated in the state table. Use \n for hard returns.
drop_existing = True # defaults to False; if True will drop existing deagg table with the same name


select * from tn_release."ust_all-tn-environmental-sites" where "Productreleased" is not null;

After running deagg.py, run the SQL below to view the value deagg table:
*/
select * from tn_release.erg_productreleased_deagg order by 2;

/*
Next, run script deagg_rows.py to create deaggregate the facility, tank, or compartment-level rows. Set the script variables below, substituting XXXXX and ZZZZZ
for a list of the columns in the source data you need to group by (e.g. ["FacilityID","TankID","ComartmentID"]).

ust_or_release = 'release' # valid values are 'ust' or 'release'
control_id = 5
data_table_name = 'ust_all-tn-environmental-sites'
data_table_pk_cols = ['XXXXX','ZZZZZ'] # list of column names that the new table should be grouped by 
delimiter = ', ' # defaults to ','; delimiter from the column beging deaggregated in the state table. Use \n for hard returns.
deagg_table_name = 'erg_productreleased_deagg'
drop_existing = True # defaults to False. Set to True to drop the _datarows_deagg table before beginning (if you need to redo it)


After running deagg_rows.py, run the SQL below to view the rows deagg table:
*/
select * from tn_release.erg_productreleased_datarows_deagg order by 2;

/*
Now, go back and update table public.release_element_mapping to point to the deaggregated data:
*/
update public.release_element_mapping set deagg_table_name = 'erg_productreleased_deagg', deagg_column_name = 'Productreleased'
where release_control_id = 5 and epa_column_name = 'substance_id';

/*
Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
*/
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (75, 'Diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (75, 'Gasoline', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (75, 'Jet Fuel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (75, 'Kerosene', 'Kerosene', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (75, 'Unknown', 'Unknown', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (75, 'Used Oil', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (75, 'Waste Oil', '', null);

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
Racing fuel
Biofuel/bioheat
Heating oil/fuel oil 1
Heating oil/fuel oil 2
Heating oil/fuel oil 4
Heating oil/fuel oil 5
Heating oil/fuel oil 6
Heating/fuel oil # unknown
Lube/motor oil (new)
Used oil/waste oil
Antifreeze
Denatured ethanol (98%)
Diesel exhaust fluid (DEF, not federally regulated)
Hazardous substance
Kerosene
Marine fuel
Non-federally regulated substance (general)
Other or mixture
Petroleum product
Solvent
Unknown

Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_release_element_mapping
where epa_column_name = 'substance_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_lust_element_mapping.
Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_lust_element_mapping
to do mapping, check public.substances to find the updated epa_value.
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--cause_id

--select distinct "Cause" from tn_release."ust_all-tn-environmental-sites" where "Cause" is not null order by 1;
/* Organization values are:

1 Spill
2 Overfill
3 Human Error
4 Corrosion
5 Pipe Failure
6 Mechanical Failure
7 Unknown
8 Other
Corrosion
Human Error
Install Problem
Mechanical Failure
Other
Overfill
Pipe Failure
Spill
Unknown
*/

/*
Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
*/
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (76, '1 Spill', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (76, '2 Overfill', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (76, '3 Human Error', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (76, '4 Corrosion', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (76, '5 Pipe Failure', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (76, '6 Mechanical Failure', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (76, '7 Unknown', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (76, '8 Other', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (76, 'Corrosion', 'Corrosion', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (76, 'Human Error', 'Human error', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (76, 'Install Problem', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (76, 'Mechanical Failure', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (76, 'Other', 'Other', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (76, 'Overfill', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (76, 'Pipe Failure', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (76, 'Spill', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (76, 'Unknown', 'Unknown', null);

--select cause from public.causes;
/* Valid EPA values are:

Corrosion
Damage to dispenser
Damage to dispenser hose
Delivery overfill
Delivery problem
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

Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_release_element_mapping
where epa_column_name = 'cause_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_lust_element_mapping.
Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_lust_element_mapping
to do mapping, check public.causes to find the updated epa_value.
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 12/27/2024 Update one value mapping for how release dicvovered
select * from release_element_value_mapping 
where release_element_mapping_id=74 ;

update release_element_value_mapping 
set epa_value='Environmental assessment', programmer_comments='OUST directed us to use ''Environmental assessment'' per our call on 9/25.'
where release_element_mapping_id=74 and release_element_value_mapping_id=127;
