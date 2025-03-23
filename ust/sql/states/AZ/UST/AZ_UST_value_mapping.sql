------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--ust_facility.owner_type_id

--select distinct "OwnerType" from az_ust."v_owner_type_mapping" where "OwnerType" is not null order by 1;
/* Organization values are:

City Government
Commercial
County Government
Federal Government - Non Military
Military
Private
School District
State Government - Non Military
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (568, 'Federal Government - Non Military', 'Federal Government - Non Military', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (568, 'State Government - Non Military', 'State Government - Non Military', null);


select * from ust_element_mapping where ust_element_mapping_id = 568;

select * from v_ust_element_mapping where ust_control_id = 14
and epa_column_name = 'owner_type_id' order by column_sort_order;

select * from az_ust.erg_ower_type_military_mapping 

select distinct "OwnerType" from az_ust.ust_facility order by 1;

City Government
Commercial
County Government
Federal Government
Private
School District
State Government


select epa_table_name, epa_column_name from 
				(select distinct epa_table_name, epa_column_name, table_sort_order, column_sort_order
				from public.v_ust_needed_mapping 
				where ust_control_id = 14
order by table_sort_order, column_sort_order) x



select distinct "OwnerType" 
from az_ust."ust_facility" where "OwnerType" is not null
and "OwnerType"::varchar not in
		(select organization_value from public.v_ust_element_mapping
		where ust_control_id = 14 and epa_column_name = 'owner_type_id'
		and organization_value is not null)
order by 1;







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
--ust_facility.facility_type1

--select distinct "FacilityType1" from az_ust."ust_facility" where "FacilityType1" is not null order by 1;
/* Organization values are:

AEROSPACE - AIRCRAFT MANUFACTURING
AGRICULTURE SERVICES AND CHEMICALS
AIRCRAFT REPAIR/MAINTENANCE FACILITY
AIRPLANE HANGAR
AIRPORT/AIRSTRIP
AMMUNITION & ORDINANCE MANUFACTURING
APARTMENTS/CONDOMINIUMS
AUTO SALVAGE YARD
AUTO/VEHICLE REPAIR FACILITY
BOAT BUILDER
BUSINESS PARK OR COMPLEX
CAFO - COMMERCIAL ANIMAL FEEDING OPERATION
CAMP (BOY SCOUT,CHURCH,ETC)
CAMPGROUND
CEMENT PLANT
CEMETERY
CHARTER SCHOOL
CHEMICAL MANUFACTURING OR SALES
CHURCH
CITY OWNED PLACE
CITY/COUNTY PARK
CLOSED MUNICPAL SOLID WASTE LANDFILL
COLLEGE OR UNIVERSITY
COMMERCIAL PROPERTY
COMPOSTING FACILITY
CONSTRUCTION - PAINTING/WALLPAPER
CONSTRUCTION DEBRIS LANDFILL
CONSTRUCTION PROJECT
COTTON GIN
COUNTRY CLUB
DAIRY
DAM
DRINKING WATER TREATMENT PLANT
DRY CLEANERS/LAUNDRY
DRY WELL
ELECTRICITY GENERATING PLANT
ELECTRONICS MANUFACTURING PLANT
EQUIPMENT YARD
FARM/RANCH
FIRE STATION
FISH HATCHERY
FOOD OR BEVERAGE PROCESSING PLANT
FOREST RANGER/WORK STATION
FOUNDRY/CASTING PLANT
FUEL STORAGE - BULK FUEL STORAGE
FURNITURE MANUFACTURING
GAS FILLING STATION - COMMERCIAL
GASOLINE FILLING STATION - FLEET
GOLF COURSE
GOVERNMENT FACILITY
GOVERNMENT SCHOOL
GROCERY STORE/CONVENIENCE STORE
HAZARDOUS WASTE TRANSFER FACILITY
HAZARDOUS WASTE TRANSPORTION COMPANY
HEALTH CLUB/SPA - GYM
HOTEL/MOTEL/LODGING
INCORRECT OR INADEQUATE LOCATIONAL INFORMATION
INDUSTRIAL PARK
INERT MATERIALS LANDFILL
LABORATORY/RESEARCH CENTER
LEAKING UNDERGROUND STORAGE TANK SITE
LIGHT INDUSTRY
LOGGING/TIMBER FACILITY
LPG FACILITY
LUMBER YARD/SALES
MACHINE SHOP
MANUFACTURING/INDUSTRIAL PLANT
MARINA
MEDICAL FACILITY
MEDICAL SUPPLY & EQUIPMENT MANUFACTURING
METAL FABRICATOR - METAL PRODUCTS
METAL PLATING FACILITY
MILITARY BASE
MINE OR MILL  SITE
MOBILE/MANUFACTURED HOME PARK
MORTUARY/CREMATORIUM
MUNICIPAL SOLID WASTE LANDFILL
NATIONAL PARK/MONUMENT
NEWSPAPER PUBLISHER
NON-MUNICIPAL SOLID WASTE LANDFILL
NURSERY - PLANT  OR PRODUCE GROWER
OFFICE BUILDING
OIL REFINING/CRUDE OIL PROCESSING FACILITY
PAINT BOOTH
PAPER MILL
PARKING LOT OR GARAGE
PERMIT TERMINATED LOCATION UNVERIFIED
PESTICIDE APPLICATOR/EXTERMINATOR
PETROLEUM CONTAMINATED SOILS (PCS) SITE
PIPELINE STATION
PLASTIC MANUFACTURING/MOLDING
POLICE STATION
POST OFFICE FACILITY
PRESCHOOL
PRINTER/PRINT SHOP
PRISON/JAIL
PRIVATE SCHOOL
PUBLIC SCHOOL
PUBLIC UTILITY
PUBLIC WORKS YARD OR BUILDING
RACE TRACK (AUTO)
RECREATION AREA
RECYCLING CENTER
REMEDIAL PROJECT
REMEDIATION AREA
RESIDENCE
RESIDENTIAL CARE FACILITY/NURSING HOME
RESORT
REST AREA
RESTAURANT/CAFE/BAR
RETAIL STORE
ROAD CONSTRUCTION PROJECT
ROAD/STREET
ROCK CRUSHING SITE
ROCK PRODUCTS SITE LOCATION
ROCK QUARRY
RUBBER PRODUCTS & FABRICATION
RV PARK
SAND AND GRAVEL OPERATIONS
SCHOOL DISTRICT FACILITY
SCRAP METAL SITE
SELF STORAGE COMPLEX
SERVICE CONTRACTOR'S FACILITY
SEWER LINE PROJECT
SHOPPING CENTER/STRIP MALL
SMELTER
STATE WQARF (SUPERFUND) SITE
STATE/COUNTY PARK
STORMWATER DISCHARGE POINT
STUDY AREA (NON-SPECIFIC)
TECHNICAL OR VOCATIONAL SCHOOL
TELECOMMUNICATION FACILITY
TIER II CELL SITE
TIRE SHOP
TOURIST ATTRACTION
TRADING POST
TRANSFER STATION
TRUCK STOP (RESTURANT/GAS STATION COMPLEX)
TRUCKING COMPANY
UNDEFINED PLACE TYPE
UNDERGROUND STORAGE TANK
USED OIL PROCESSOR
USED OIL STORAGE AND TRANSFER FACILITY
UST FACILITY
VACANT LOT - UNUSED LAND
VEHICLE SALES (AUTO/RV/MOTORSPORTS)
VEHICLE TEST TRACK - PROVING GROUNDS
VEHICLE WASH
VETERINARY CLINIC/ANIMAL HOSPITAL
VINEYARD/WINERY
WAREHOUSE
WASTE TIRE COLLECTION SITE
WASTEWATER TREATMENT PLANT
WATER SERVICE AREA
WATER TREATMENT PLANT
WELL FIELD
WILDLIFE REFUGE/PRESERVATION AREA
WOODWORKING - WOOD TREATMENT FACILITY
ZOO OR WILDLIFE PARK
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */


select * from ust_element_mapping where ust_control_id = 14 and epa_table_name = 'ust_facility'


update ust_element_mapping set organization_table_name = 'erg_facility_type_mapping',
	programmer_comments = 'Organization values GOVERNMENT FACILITY and RECREATION AREA mapped to several EPA values. Created a crosswalk table (erg_facility_type_mapping) and mapped those two facility types by FacilityName'
where ust_element_mapping_id = 3337;

select * from facility_types ;

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'facility_type1'
and lower(organization_value) like lower('%qua%')
order by 1, 2;

'Please verify'

insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3337, 'GOVERNMENT FACILITY', '', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (3337, 'RECREATION AREA', '', null);


select distinct "FacilityID","FacilityName","FacilityType1",epa_value
into az_ust.erg_facility_type_mapping
from az_ust.ust_facility a left join ust_element_value_mapping b 
	on a."FacilityType1" = b.organization_value
where b.ust_element_mapping_id = 3337

insert into az_ust.erg_facility_type_mapping
select distinct "FacilityID","FacilityName","FacilityType1", null 
from az_ust.ust_facility where "FacilityID" not in (select "FacilityID" from az_ust.erg_facility_type_mapping)

select distinct "FacilityType1", "FacilityName"
from az_ust.erg_facility_type_mapping
where epa_value is null and "FacilityType1" is not null
order by 1, 2;

alter table az_ust.erg_facility_type_mapping add constraint erg_facility_type_mapping_pk primary key ("FacilityID")

update az_ust.erg_facility_type_mapping
set epa_value = 'Federal government, non-military' where "FacilityName" like '%FEDERAL%'
or "FacilityName" like 'US%'

update az_ust.erg_facility_type_mapping
set epa_value = 'State/local government'
where epa_value is null and "FacilityType1" = 'GOVERNMENT FACILITY'

select 'update az_ust.erg_facility_type_mapping set epa_value = '''' where "FacilityName" = ''' || "FacilityName" || ''';'
from az_ust.erg_facility_type_mapping
where epa_value is null and "FacilityType1" is not null
order by 1;


update az_ust.erg_facility_type_mapping set epa_value = 'Commercial' where "FacilityName" = 'AMERICA WEST ARENA/FRMR STATION';
update az_ust.erg_facility_type_mapping set epa_value = 'Commercial' where "FacilityName" = 'APACHE DRIVE-IN THEATER';
update az_ust.erg_facility_type_mapping set epa_value = 'Commercial' where "FacilityName" = 'CASTLES N COASTERS';
update az_ust.erg_facility_type_mapping set epa_value = 'State/local government' where "FacilityName" = 'CITY OF SCOTTSDALE - WESTWORLD';
update az_ust.erg_facility_type_mapping set epa_value = 'State/local government' where "FacilityName" = 'COMMUNITY RECREATION CENTER';
update az_ust.erg_facility_type_mapping set epa_value = 'Commercial' where "FacilityName" = 'FORT VALLEY LODGE';
update az_ust.erg_facility_type_mapping set epa_value = 'Commercial' where "FacilityName" = 'GOLF N STUFF';
update az_ust.erg_facility_type_mapping set epa_value = 'Commercial' where "FacilityName" = 'GOLFLAND SUNSPLASH';
update az_ust.erg_facility_type_mapping set epa_value = 'Commercial' where "FacilityName" = 'ISLAND OF BIG SURF';
update az_ust.erg_facility_type_mapping set epa_value = 'Commercial' where "FacilityName" = 'OLD TUCSON FAMOUS MOVIE LOCATION';
update az_ust.erg_facility_type_mapping set epa_value = 'Other' where "FacilityName" = 'PHOENIX SUNS PRACTICE FACILITY';
update az_ust.erg_facility_type_mapping set epa_value = 'State/local government' where "FacilityName" = 'PIMA DYNAMITE TRAILHEAD';
update az_ust.erg_facility_type_mapping set epa_value = 'Trucking/transport/fleet operation' where "FacilityName" = 'PRODUCE HAULING - FORMER';
update az_ust.erg_facility_type_mapping set epa_value = 'State/local government' where "FacilityName" = 'RILLITO REGIONAL PARK';
update az_ust.erg_facility_type_mapping set epa_value = 'Other' where "FacilityName" = 'RIO SALADO FUN PARK';
update az_ust.erg_facility_type_mapping set epa_value = 'Commercial' where "FacilityName" = 'SUN CITY RECREATION CENTER - WILLOCREEK';
update az_ust.erg_facility_type_mapping set epa_value = 'Residential' where "FacilityName" = 'SUN LAKES HOMEOWNERS ASSOCIATION #1';
update az_ust.erg_facility_type_mapping set epa_value = 'Commercial' where "FacilityName" = 'TURF PARADISE';
update az_ust.erg_facility_type_mapping set epa_value = 'Residential' where "FacilityName" = 'VILLAGE OF OAK CREEK ASSOCIATION';

select * from facility_types 

Federal government, non-military
Military
State/local government

select distinct "FacilityName" from az_ust.ust_facility where "FacilityType1" = 'ROAD/STREET'
order by 1;





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
and lower(organization_value) like lower('%manu%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check public.facility_types to find the updated epa_value.
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
where ust_control_id = 14 and epa_column_name = 'tank_material_description_id'
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



select column_sort_order as column_id, 
					epa_column_name, organization_column_name, 
					selected_column, query_logic,
					organization_table_name
from public.v_ust_table_population_sql
where ust_control_id = 14 and epa_table_name = 'ust_tank'
and column_sort_order is not null
order by column_sort_order