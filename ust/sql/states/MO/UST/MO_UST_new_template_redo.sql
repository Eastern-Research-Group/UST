select * from archive.ust_control where organization_id = 'MO'

----use insert_control.py to update ust_control 
--organization_id = 'MO'
--system_type = 'ust' # Accepted values are 'ust' or 'release'
--data_source = 'Access database downloaded from https://dnr.mo.gov/waste-recycling/sites-regulated-facilities/underground-storage-tanks-database' 
--date_received = '2022-09-08' # Defaults to datetime.today(). To use a date other tha-- public.ust_control definition
--date_processed = None # Defaults to datetime.today(). To use a date other than today, set as a string in the format of 'yyyy-mm-dd'.
--comments = None 
--
--Inserted into ust_control; ust_control_id = 7
--New control_id for MO is 7
--[Finished in 1.5s]

------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* FACILITIES */
------------------------------------------------------------------------------------------------------------------------------------------------------------------

--first see which elements have lookup tables
select distinct database_column_name, database_lookup_table
from ust_elements a join ust_elements_tables b on a.element_id = b.element_id
where table_name = 'ust_facility' and database_lookup_table is not null 
order by 1, 2;

coordinate_source_id	coordinate_sources
facility_type_id1	facility_types
facility_type_id2	facility_types
owner_type_id	owner_types


---------------------------------------------------------------------------------------------------------------------------------------------------------------
--coordinate_sources

select * from archive.v_ust_element_mapping where organization_id = 'MO' 


select * from information_schema.columns where table_schema = 'mo_ust' and column_name like '%coord%';
mo_ust_geocoded	originalcoordsrc
mo_ust_geocoded	gc_coordinate_source
--these tables are ERG-created tables; ignore. MO doesn't apear to have coordinate source data 

---------------------------------------------------------------------------------------------------------------------------------------------------------------
--facility_types
select * from mo_ust.tblfacilitytype 
A	Above Ground
B	Both
U	Under Ground
--this is not what the EPA template means by "facility type" so ignore it for now
-- (we will come back to it later when working on Tank Location, as that these values are in the EPA template)

---------------------------------------------------------------------------------------------------------------------------------------------------
--owner_types

select * from mo_ust.tblownertype;

select * from mo_ust.tblownerclass;
C	City
F	Federal
G	Government Owner
H	Hospital
L	Local
M	Marketer
N	Non-Marketer
O	County
P	Private Owner
S	State
U	Unclassified
Z	School

--create the element-level mapping: i.e. which state column will we use to get the EPA element we're looking for?
--organization_join_table and organization_join_column are optional and are used if the state is using a lookup table,
--which in this case they are
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, 
                                 organization_table_name, organization_column_name,
                                 organization_join_table, organization_join_column)
values (7, 'owner_types', 'owner_type', 'tblownerclass', 'ownerdescription', 'tblownertype', 'ownercode')
returning ust_element_mapping_id;
--2

--update and run this query to generate the base insert statements, which you then manually update
--with the mapped values and then run
select 'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (2, ''' || ownerdescription || ''', '''');' as vsql
from mo_ust.tblownerclass
order by 1;
--paste the results of this query below

--get the EPA values and then paste the correct ones into the SQL statements below
select * from owner_types;
1	Federal Government - Non Military
2	State Government - Non Military
3	Tribal Governernment
4	Local Government
5	Commercial
6	Private
7	Military
8	Other
--NOTE: there may be state values for which there is no EPA value. 
--This is OK - there can be null values for most fields in the EPA template - but when you later export the mapping
--for EPA to review, include ALL the state values, including those you didn't map, so EPA can review.
--ALSO, remember there is a programmer_comment field in both the ust_element_mapping and ust_element_value_mapping
--tables. If you are unsure about any mapping, alter the SQL statement for that value below to add the programmer_comment column 
--and add your comment. Then include that column when you output it later for EPA review. 

--you can also look in this archived view for the old mapping:
select * from archive.v_ust_element_mapping where organization_id = 'MO';

insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (2, 'City', 'Local Government');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (2, 'County', 'Local Government');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (2, 'Federal', 'Federal Government - Non Military');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (2, 'Government Owner', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (2, 'Hospital', 'Commercial');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (2, 'Local', 'Local Government');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (2, 'Marketer', 'Private');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (2, 'Non-Marketer', 'Private');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (2, 'Private Owner', 'Private');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (2, 'School', 'Local Government');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (2, 'State', 'State Government - Non Military');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (2, 'Unclassified', null);


----------------------------------------------------------------------------------------------------------------------------------------------------------------
--we've done all the lookup table mapping (coordinate source, facility type, and owner type), so move on to the rest of the elements: 

select database_column_name
from ust_elements a join ust_elements_tables b on a.element_id = b.element_id
where table_name = 'ust_facility' order by sort_order;


select * from mo_ust.tblfacility ;

--this is an example of one way to organize the mapping from state column name to EPA column name - do whatever works for you
--keep stuff like these helper tables in the state data schema though. 
create table mo_ust.erg_column_mapping (epa_table_name varchar(100),  
                                        epa_column_name varchar(100),
                                        org_table_name varchar(100),
                                        org_column_name varchar(100),
                                        notes varchar(4000));
                                       
--generate insert statements and then run them to populate the table:                                        
select 'insert into mo_ust.erg_column_mapping (epa_table_name, epa_column_name) values (''ust_facility'',''' || database_column_name || ''');'
from ust_elements a join ust_elements_tables b on a.element_id = b.element_id
where table_name = 'ust_facility' order by sort_order;

insert into mo_ust.erg_column_mapping (epa_table_name, epa_column_name) values ('ust_facility','facility_id');
insert into mo_ust.erg_column_mapping (epa_table_name, epa_column_name) values ('ust_facility','facility_name');
insert into mo_ust.erg_column_mapping (epa_table_name, epa_column_name) values ('ust_facility','owner_type_id');
insert into mo_ust.erg_column_mapping (epa_table_name, epa_column_name) values ('ust_facility','facility_type_id1');
insert into mo_ust.erg_column_mapping (epa_table_name, epa_column_name) values ('ust_facility','facility_type_id2');
insert into mo_ust.erg_column_mapping (epa_table_name, epa_column_name) values ('ust_facility','facility_address1');
insert into mo_ust.erg_column_mapping (epa_table_name, epa_column_name) values ('ust_facility','facility_address2');
insert into mo_ust.erg_column_mapping (epa_table_name, epa_column_name) values ('ust_facility','facility_city');
insert into mo_ust.erg_column_mapping (epa_table_name, epa_column_name) values ('ust_facility','facility_county');
insert into mo_ust.erg_column_mapping (epa_table_name, epa_column_name) values ('ust_facility','facility_zip_code');
insert into mo_ust.erg_column_mapping (epa_table_name, epa_column_name) values ('ust_facility','facility_state');
insert into mo_ust.erg_column_mapping (epa_table_name, epa_column_name) values ('ust_facility','facility_epa_region');
insert into mo_ust.erg_column_mapping (epa_table_name, epa_column_name) values ('ust_facility','facility_tribal_site');
insert into mo_ust.erg_column_mapping (epa_table_name, epa_column_name) values ('ust_facility','facility_tribe');
insert into mo_ust.erg_column_mapping (epa_table_name, epa_column_name) values ('ust_facility','facility_latitude');
insert into mo_ust.erg_column_mapping (epa_table_name, epa_column_name) values ('ust_facility','facility_longitude');
insert into mo_ust.erg_column_mapping (epa_table_name, epa_column_name) values ('ust_facility','coordinate_source_id');
insert into mo_ust.erg_column_mapping (epa_table_name, epa_column_name) values ('ust_facility','facility_owner_company_name');
insert into mo_ust.erg_column_mapping (epa_table_name, epa_column_name) values ('ust_facility','facility_operator_company_name');
insert into mo_ust.erg_column_mapping (epa_table_name, epa_column_name) values ('ust_facility','financial_responsibility_obtained');
insert into mo_ust.erg_column_mapping (epa_table_name, epa_column_name) values ('ust_facility','financial_responsibility_bond_rating_test');
insert into mo_ust.erg_column_mapping (epa_table_name, epa_column_name) values ('ust_facility','financial_responsibility_commercial_insurance');
insert into mo_ust.erg_column_mapping (epa_table_name, epa_column_name) values ('ust_facility','financial_responsibility_guarantee');
insert into mo_ust.erg_column_mapping (epa_table_name, epa_column_name) values ('ust_facility','financial_responsibility_letter_of_credit');
insert into mo_ust.erg_column_mapping (epa_table_name, epa_column_name) values ('ust_facility','financial_responsibility_local_government_financial_test');
insert into mo_ust.erg_column_mapping (epa_table_name, epa_column_name) values ('ust_facility','financial_responsibility_risk_retention_group');
insert into mo_ust.erg_column_mapping (epa_table_name, epa_column_name) values ('ust_facility','financial_responsibility_self_insurance_financial_test');
insert into mo_ust.erg_column_mapping (epa_table_name, epa_column_name) values ('ust_facility','financial_responsibility_state_fund');
insert into mo_ust.erg_column_mapping (epa_table_name, epa_column_name) values ('ust_facility','financial_responsibility_surety_bond');
insert into mo_ust.erg_column_mapping (epa_table_name, epa_column_name) values ('ust_facility','financial_responsibility_trust_fund');
insert into mo_ust.erg_column_mapping (epa_table_name, epa_column_name) values ('ust_facility','financial_responsibility_other_method');
insert into mo_ust.erg_column_mapping (epa_table_name, epa_column_name) values ('ust_facility','ust_reported_release');
insert into mo_ust.erg_column_mapping (epa_table_name, epa_column_name) values ('ust_facility','associated_ust_release_id');
insert into mo_ust.erg_column_mapping (epa_table_name, epa_column_name) values ('ust_facility','dispenser_id');
insert into mo_ust.erg_column_mapping (epa_table_name, epa_column_name) values ('ust_facility','dispenser_udc');
insert into mo_ust.erg_column_mapping (epa_table_name, epa_column_name) values ('ust_facility','dispenser_udc_wall_type');

--paste the SQL statements generated by this query below
select 'update mo_ust.erg_column_mapping set org_table_name = '''', org_column_name = '''' where epa_column_name = ''' || epa_column_name || ''';'
from  mo_ust.erg_column_mapping 
where epa_table_name = 'ust_facility' and org_column_name is null and epa_column_name not in 
	(select database_column_name from ust_elements where database_lookup_table is not null);

--then update the query below to search for matches for each column and update the sql statements below 
--hint: use as small a part of the column name as you can to match on (e.g. "fac" instead of "facility");
--also, sometimes states use abbreviations in column names, like 'fr' for "financial responsibility"
--when looking for associated LUST IDs, look for "lust" in addition to "release" - LUST has been only recently renamed "UST Releases"
select * from information_schema.columns 
where table_schema = 'mo_ust' 
--and table_name = 'tblgeosite'   --uncomment if you know the table you are looking in
and lower(column_name) like  '%disp%';

--as you go through them, run queries against the state data to make sure the columns contain the data you expect;
--for example, the region column in this table does not coorespond to the EPA Region in ust_facility. 
select distinct region from mo_ust.tblgeosite;
--this column contains states but it probably not the facilty location state, so don't map it
select distinct rpstate from mo_ust.tblfacility;
select distinct converted_lat from mo_ust.tblgeosite_latlong;
select * from mo_ust.tblgeosite_latlong;
select * From mo_ust.tblowner;
select * from mo_ust.tblremediation ;

--when searching for a column like '%disp%' I found these:
tbltankbycompartment	subdispensor
tbltankbycompartment	dispconnfittingprot
--this tells us that MO has their dispenser data at the COMPARTMENT level 
--remember, it may be at the Facility, Tank, OR Compartment level depending on the state, 
--so the dispenser columns repeat in all three EPA tables. We won't add it to the facility table here. 

--run the statements below (which were generated above and pasted here) that you have modified as you've worked through each of them:
update mo_ust.erg_column_mapping set org_table_name = 'tblfacility', org_column_name = 'facilityid' where epa_column_name = 'facility_id';
update mo_ust.erg_column_mapping set org_table_name = 'tblgeosite', org_column_name = 'NAME' where epa_column_name = 'facility_name';
update mo_ust.erg_column_mapping set org_table_name = 'tblgeosite', org_column_name = 'address' where epa_column_name = 'facility_address1';
update mo_ust.erg_column_mapping set org_table_name = 'tblgeosite', org_column_name = 'address2' where epa_column_name = 'facility_address2';
update mo_ust.erg_column_mapping set org_table_name = 'tblgeosite', org_column_name = 'city' where epa_column_name = 'facility_city';
update mo_ust.erg_column_mapping set org_table_name = 'tblcounty', org_column_name = 'countyname' where epa_column_name = 'facility_county';
update mo_ust.erg_column_mapping set org_table_name = 'tblgeosite', org_column_name = 'zip' where epa_column_name = 'facility_zip_code';
update mo_ust.erg_column_mapping set org_table_name = '', org_column_name = '' where epa_column_name = 'facility_state';
update mo_ust.erg_column_mapping set org_table_name = '', org_column_name = '' where epa_column_name = 'facility_epa_region';
update mo_ust.erg_column_mapping set org_table_name = '', org_column_name = '' where epa_column_name = 'facility_tribal_site';
update mo_ust.erg_column_mapping set org_table_name = '', org_column_name = '' where epa_column_name = 'facility_tribe';
update mo_ust.erg_column_mapping set org_table_name = 'tblgeosite_latlong', org_column_name = 'converted_lat' where epa_column_name = 'facility_latitude';
update mo_ust.erg_column_mapping set org_table_name = 'tblgeosite_latlong', org_column_name = 'converted_long' where epa_column_name = 'facility_longitude';
update mo_ust.erg_column_mapping set org_table_name = 'tblowner', org_column_name = 'NAME' where epa_column_name = 'facility_owner_company_name';
update mo_ust.erg_column_mapping set org_table_name = '', org_column_name = '' where epa_column_name = 'facility_operator_company_name';
update mo_ust.erg_column_mapping set org_table_name = '', org_column_name = '' where epa_column_name = 'financial_responsibility_obtained';
update mo_ust.erg_column_mapping set org_table_name = '', org_column_name = '' where epa_column_name = 'financial_responsibility_bond_rating_test';
update mo_ust.erg_column_mapping set org_table_name = '', org_column_name = '' where epa_column_name = 'financial_responsibility_commercial_insurance';
update mo_ust.erg_column_mapping set org_table_name = '', org_column_name = '' where epa_column_name = 'financial_responsibility_guarantee';
update mo_ust.erg_column_mapping set org_table_name = '', org_column_name = '' where epa_column_name = 'financial_responsibility_letter_of_credit';
update mo_ust.erg_column_mapping set org_table_name = '', org_column_name = '' where epa_column_name = 'financial_responsibility_local_government_financial_test';
update mo_ust.erg_column_mapping set org_table_name = '', org_column_name = '' where epa_column_name = 'financial_responsibility_risk_retention_group';
update mo_ust.erg_column_mapping set org_table_name = '', org_column_name = '' where epa_column_name = 'financial_responsibility_self_insurance_financial_test';
update mo_ust.erg_column_mapping set org_table_name = '', org_column_name = '' where epa_column_name = 'financial_responsibility_state_fund';
update mo_ust.erg_column_mapping set org_table_name = '', org_column_name = '' where epa_column_name = 'financial_responsibility_surety_bond';
update mo_ust.erg_column_mapping set org_table_name = '', org_column_name = '' where epa_column_name = 'financial_responsibility_trust_fund';
update mo_ust.erg_column_mapping set org_table_name = '', org_column_name = '' where epa_column_name = 'financial_responsibility_other_method';
--here I've manually added the notes column with a reminder to myself about how to handle this column as it's not a direct mapping
update mo_ust.erg_column_mapping set org_table_name = 'tblremediation', org_column_name = 'remid', notes = 'Set to Yes if this column is not null' where epa_column_name = 'ust_reported_release';
update mo_ust.erg_column_mapping set org_table_name = 'tblremediation', org_column_name = 'remid' where epa_column_name = 'associated_ust_release_id';
update mo_ust.erg_column_mapping set org_table_name = '', org_column_name = '' where epa_column_name = 'dispenser_id';
update mo_ust.erg_column_mapping set org_table_name = '', org_column_name = '' where epa_column_name = 'dispenser_udc';
update mo_ust.erg_column_mapping set org_table_name = '', org_column_name = '' where epa_column_name = 'dispenser_udc_wall_type';


--using the mapping above, we'll be creating a view that will help populate ust_facility; 
--these are the non-lookup table columns that we've mapped, so start with them
select * from mo_ust.erg_column_mapping where epa_table_name = 'ust_facility' and org_table_name is not null;
--go through each of the rows in the results of this query and add it to create view statement below

--update this query to figure out how to do each of the joins:
select * from information_schema.columns where table_schema = 'mo_ust' and column_name like '%county%';

--query the state tables that will be in the view to make sure they contain the data you are looking for
select * from mo_ust.tblfacilitylookup;
select distinct county from mo_ust.tblgeosite 
select * from mo_ust.tblcounty;
select * from mo_ust.tblowner;
select * from mo_ust.tblremediation;

--note that for the UST Release (aka LUST) data, the state may have multiple releases per facility; 
-- we only want the most recent one, so write you query so we only get one per facility
--remember that we are excluding Aboveground tanks (see the where clause)
--also, if the state didn't have a column for Facility State, set it to the state code 
-- because it's a required field in the EPA template 

--next, bring in the lookup tables:
select distinct epa_column_name, organization_table_name, organization_column_name, organization_join_table, organization_join_column 
from  ust_element_value_mapping a join ust_element_mapping b on a.ust_element_mapping_id = b.ust_element_mapping_id 
where ust_control_id = 7
order by 1, 2;
--see the join below to the query with a table aliases of "h" and "i"

create view mo_ust.v_ust_facility as
select distinct 
	a.facilityid as facility_id,
	b."NAME" as facility_name,
	b.address as facility_address1, 
	b.address2 as facility_address2,
	b.city as facility_city,
	c.countyname as facility_county,
	'MO' as facility_state,
	b.zip as facility_zip_code,
	d.converted_lat as facility_latitude,
	d.converted_long as facility_longitude,
	f."NAME" as facility_owner_company_name,
	case when g.facilityid is not null then 'Yes' end as ust_reported_release,
	g.remid as associated_ust_release_id,
	i.owner_type_id as owner_type_id
from mo_ust.tblfacility a left join mo_ust.tblgeosite b on a.facilityid = b.facilityid
	left join mo_ust.tblcounty c on b.county = c.countycode
	left join mo_ust.tblgeosite_latlong d on a.facilityid = d.facilityid
	left join mo_ust.tblfacilitylookup e on a.facilityid = e.facilityid
	left join mo_ust.tblowner f on e.ownerid = f.ownerid
	left join (select facilityid, max(remid) as remid from mo_ust.tblremediation group by facilityid) g on a.facilityid = g.facilityid
	left join (select z.ownerid, epa_value, organization_value
				from mo_ust.tblownerclass x join 
					(select epa_value, organization_value 
					from ust_element_mapping a join ust_element_value_mapping b on a.ust_element_mapping_id = b.ust_element_mapping_id 
					where ust_control_id = 7 and epa_table_name = 'owner_types' and epa_value is not null) y
						on x.ownerdescription = y.organization_value
					join mo_ust.tblownertype z on x.ownercode = z.ownerclass) h on e.ownerid = h.ownerid
	left join owner_types i on h.epa_value = i.owner_type;
--where a.facilitytype <> 'A';


--do the insert into ust_facility:

--use this query to build the insert statement columns
select column_name || ','
from information_schema.columns
where table_schema = 'mo_ust' and table_name = 'v_ust_facility';

--include the ust_control_id identified in the first step above (7)
insert into ust_facility (ust_control_id, facility_state, 
		facility_id,
		facility_name,
		facility_address1,
		facility_address2,
		facility_city,
		facility_county,
		facility_zip_code,
		facility_latitude,
		facility_longitude,
		facility_owner_company_name,
		ust_reported_release,
		associated_ust_release_id,
		owner_type_id)
select 7, facility_state,
	facility_id,
	facility_name,
	facility_address1,
	facility_address2,
	facility_city,
	facility_county,
	facility_zip_code,
	facility_latitude,
	facility_longitude,
	facility_owner_company_name,
	ust_reported_release,
	associated_ust_release_id,
	owner_type_id
from  mo_ust.v_ust_facility;

--...now move on to tanks, then compartments, then piping...

------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* TANKS */
------------------------------------------------------------------------------------------------------------------------------------------------------------------
--first see which elements have lookup tables
select distinct database_column_name, database_lookup_table
from ust_elements a join ust_elements_tables b on a.element_id = b.element_id
where table_name = 'ust_tank' and database_lookup_table is not null 
order by 1, 2;
tank_location_id				tank_locations
tank_material_description_id	tank_material_descriptions
tank_secondary_containment_id	tank_secondary_containments
tank_status_id					tank_statuses

------------------------------------------------------------------------------------------------------------------------------------------------------------------
--tank_locations

--see what we are looking for on the EPA side
select * from tank_locations
1	Underground (entirely buried)
2	Partially buried
3	Aboveground (tank bottom abovegrade)
4	Aboveground (tank bottom on-grade)
5	Unknown
6	Other

--as we discovered above, this information was in the state table tblfacility and lookup table tblfacilitytype, 
--so we'll copy it down to the tank level 
select * from mo_ust.tblfacilitytype
A	Above Ground
B	Both
U	Under Ground

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, 
                                 organization_table_name, organization_column_name,
                                 organization_join_table, organization_join_column)
values (7, 'tank_locations', 'tank_location', 'tblfacilitytype', 'description', 'tblfacility', 'facilitytype')
returning ust_element_mapping_id;
--3

select * from mo_ust.tblfacilitytype 

select 'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (3, ''' || description || ''', '''');' as vsql
from mo_ust.tblfacilitytype
order by 1;

select * from tank_locations

--check old/existing mapping
select * from archive.v_ust_element_mapping where organization_id = 'MO';

insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (3, 'Above Ground', 'Aboveground (tank bottom abovegrade)');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (3, 'Both', '');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value) values (3, 'Under Ground', 'Underground (entirely buried)');

------------------------------------------------------------------------------------------------------------------------------------------------------------------
--tank_material_descriptions
