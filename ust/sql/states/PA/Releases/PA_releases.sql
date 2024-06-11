select * from "Tank_Cleanup_Incidents" ;

select * from information_schema.columns 
where table_schema = 'pa_release' and table_name = 'Tank_Cleanup_Incidents' 
order by ordinal_position;

alter table "Tank_Cleanup_Incidents" rename column "ï»¿REGION" to "REGION";

select * from "Tank_Cleanup_Incidents" ;

--used insert_control.py to insert into public.release_control

select * from public.release_control where release_control_id = 2;

update release_control set comments = 'ignore rows where "INCIDENT_TYPE" = ''AST''' where release_control_id = 2;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

select table_name
from public.release_element_table_sort_order
order by sort_order;
ust_release
ust_release_substance
ust_release_cause
ust_release_source
ust_release_corrective_action_strategy


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
select database_column_name 
from release_elements a join release_elements_tables b on a.element_id = b.element_id
where table_name = 'ust_release' 
order by sort_order;

facility_id
tank_id_associated_with_release
release_id
federally_reportable_release
site_name
site_address
site_address2
site_city
zipcode
county
state
epa_region
facility_type
tribal_site
tribe
latitude
longitude
coordinate_source
release_status
reported_date
nfa_date
media_impacted_soil
media_impacted_groundwater
media_impacted_surface_water
how_release_detected
closed_with_contamination
no_further_action_letter_url
military_dod_site

select * from release_element_mapping


select * from "Tank_Cleanup_Incidents";

select distinct "INCIDENT_TYPE" from "Tank_Cleanup_Incidents" order by 1;
AST
AST, USTPT
USTHZ
USTPT
select distinct "STATUS_DESCRIPTION" from "Tank_Cleanup_Incidents" order by 1;

select distinct "IMPACT_DESCRIPTION" from "Tank_Cleanup_Incidents" order by 1;

select distinct "SOURCE_OF_NOTIFICATION" from "Tank_Cleanup_Incidents" order by 1;
COMPL
COMPL, INSTL
COMPL, LKDET
COMPL, OWNER
DEP
ENVCO
ENVCO, OWNER
INSTL
INSTL, LKDET
INSTL, MAINT
INSTL, OPER
INSTL, OWNER
LKDET
MAINT
OPER
OWNER
UNDTD


select distinct "RELEASE_DISCOVERED" from "Tank_Cleanup_Incidents" order by 1;

select * from public.how_release_detected order by 1;
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

insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name)
values (2, 'ust_release', 'facility_id', 'Tank_Cleanup_Incidents', 'FACILITY_ID');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name)
values (2, 'ust_release', 'tank_id_associated_with_release', 'Tank_Cleanup_Incidents', 'TANK');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name)
values (2, 'ust_release', 'release_id', 'Tank_Cleanup_Incidents', 'INCIDENT_ID');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name)
values (2, 'ust_release', 'site_name', 'Tank_Cleanup_Incidents', 'FACILITY_NAME');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name)
values (2, 'ust_release', 'site_address', 'Tank_Cleanup_Incidents', 'ADDRESS1');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name)
values (2, 'ust_release', 'site_address2', 'Tank_Cleanup_Incidents', 'ADDRESS2');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name)
values (2, 'ust_release', 'site_city', 'Tank_Cleanup_Incidents', 'CITY');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name)
values (2, 'ust_release', 'zipcode', 'Tank_Cleanup_Incidents', 'ZIP');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name)
values (2, 'ust_release', 'latitude', 'Tank_Cleanup_Incidents', 'LATITUDE');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name)
values (2, 'ust_release', 'longitude', 'Tank_Cleanup_Incidents', 'LONGITUDE');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name)
values (2, 'ust_release', 'coordinate_source', 'Tank_Cleanup_Incidents', 'HOR_REF_DATUM');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name)
values (2, 'ust_release', 'release_status', 'Tank_Cleanup_Incidents', 'STATUS_DESCRIPTION');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name)
values (2, 'ust_release', 'reported_date', 'Tank_Cleanup_Incidents', 'CONFIRMED_DATE');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments)
values (2, 'ust_release', 'nfa_date', 'Tank_Cleanup_Incidents', 'STATUS_DATE', 'where "STATUS_DESCRIPTION" = ''Cleanup Completed''');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments)
values (2, 'ust_release', 'media_impacted_soil', 'Tank_Cleanup_Incidents', 'IMPACT_DESCRIPTION', 'where = ''Soil''');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments)
values (2, 'ust_release', 'media_impacted_groundwater', 'Tank_Cleanup_Incidents', 'IMPACT_DESCRIPTION', 'where = ''Ground Water''');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments)
values (2, 'ust_release', 'media_impacted_surface_water', 'Tank_Cleanup_Incidents', 'IMPACT_DESCRIPTION', 'where = ''Surface Water''');
insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name)
values (2, 'ust_release', 'how_release_detected', 'Tank_Cleanup_Incidents', 'RELEASE_DISCOVERED');

select * from release_element_mapping where release_control_id = 2 order by 1;


select database_column_name 
from release_elements a join release_elements_tables b on a.element_id = b.element_id
where table_name = 'ust_release_substance' 
order by sort_order;
substance_id
quantity_released
unit

select * from "Tank_Cleanup_Incidents";

insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name)
values (2, 'ust_release_substance', 'substance_id', 'Tank_Cleanup_Incidents', 'SUBSTANCE');

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
select database_column_name 
from release_elements a join release_elements_tables b on a.element_id = b.element_id
where table_name = 'ust_release_cause' 
order by sort_order;
cause_id

select * from "Tank_Cleanup_Incidents";

select * from sources;
Dispenser
Piping
Submersible turbine pump
Tank
Other
Unknown

select * from causes;
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
unknown

select distinct "SOURCE_CAUSE_OF_RELEASE" from "Tank_Cleanup_Incidents" order by 1;
ACCND
ACCND, CONT, DISP, PHMEF, SPCB
ACCND, DISP
ACCND, PAST
ACCND, PUST
ACCND, SUBTP
ACCND, TANK
CONT
CONT, CORR, OVER, PHMEF, PUST, TANK
CONT, DISP
CONT, DISP, PUST
CONT, DISP, PUST, SPCB
CONT, HOSE, OTHR
CONT, INFNP, PUST
CONT, OVER, SPCB, SUBTP
CONT, PAST
CONT, PUST
CONT, SPCB
CONT, SUBTP
CONT, TANK
CORR
CORR, DISP
CORR, DISP, FLTYI, PUST
CORR, DISP, OVER
CORR, DISP, PUST
CORR, FLTYI
CORR, OTHR
CORR, PAST, TANK
CORR, PHMEF
CORR, PUST
CORR, SPCB
CORR, SUBTP
CORR, TANK
CORR, UNDTD
DISP
DISP, HOSE, VEHIC
DISP, OTHR
DISP, OTHR, TANK
DISP, OVER
DISP, OVER, SPCB
DISP, OVER, TANK
DISP, PAST, SPILL, TANK
DISP, PHMEF
DISP, PHMEF, PUST
DISP, PSNR
DISP, PUST
DISP, PUST, SPCB, TANK
DISP, PUST, SUBTP, TANK
DISP, PUST, TANK
DISP, PUST, VEHIC
DISP, SPCB
DISP, SPILL
DISP, SUBTP
DISP, SUBTP, TANK
DISP, TANK
DISP, UNDTD
DISP, VEHIC
FLTYI
FLTYI, PHMEF
FLTYI, PUST
HOSE
INFNP
OTHR
OTHR, PAST, TANK
OTHR, PUST
OTHR, TANK
OTHR, TANK, UNDTD
OVER
OVER, PSNR
OVER, PUST
OVER, SPILL
OVER, TANK
PAST
PAST, PHMEF
PAST, PUST, UNDTD
PAST, SPILL
PAST, TANK
PAST, UNDTD
PHMEF
PHMEF, PUST
PHMEF, SPCB
PHMEF, SUBTP
PHMEF, TANK
PHMEF, UNDTD
PHMEF, UNDTD, VEHIC
PSNR
PSNR, PUST
PSNR, TANK
PSNR, UNDTD
PUST
PUST, SPCB, SUBTP, UNDTD
PUST, SUBTP
PUST, TANK
PUST, UNDTD
SPCB
SPCB, TANK
SPILL
SUBTP
TANK
TANK, UNDTD
UNDTD
UNDTD, VEHIC
VEHIC


insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments)
values (2, 'ust_release_cause', 'cause_id', 'Tank_Cleanup_Incidents', 'SOURCE_CAUSE_OF_RELEASE', 'Column is comma-separated and also includes sources');

insert into release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments)
values (2, 'ust_release_source', 'source_id', 'Tank_Cleanup_Incidents', 'SOURCE_CAUSE_OF_RELEASE', 'Column is comma-separated and also includes causes');

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
select database_column_name 
from release_elements a join release_elements_tables b on a.element_id = b.element_id
where table_name = 'ust_release_corrective_action_strategy' 
order by sort_order;
corrective_action_strategy
corrective_action_strategy_start_date

select * from public.corrective_action_strategies order by 1;
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

select * from "Tank_Cleanup_Incidents";


------------------------------------------------------------------------------------------------------------------------------------------------------------------------

select epa_table_name, epa_column_name
from v_release_available_mapping 
where release_control_id = 2 order by 1, 2;


select distinct b.release_element_mapping_id , a.epa_table_name, a.epa_column_name, 
	'"' || a.organization_table_name  || '"' as organization_table_name, 
	'"' || a.organization_column_name  || '"' as organization_column_name, 
	b.programmer_comments, c.database_lookup_table, c.database_lookup_column
from public.v_release_element_mapping a join public.release_element_mapping  b
	on a.release_control_id = b.release_control_id and a.epa_table_name = b.epa_table_name and a.epa_column_name = b.epa_column_name 
	left join release_elements c on a.epa_column_name = c.database_column_name 
where a.release_control_id = 2 and c.database_lookup_table is not null
and b.release_element_mapping_id not in 
	(select release_element_mapping_id from release_element_value_mapping)
order by 2, 3;



------------------------------------------------------------------------------------------------------------------------------------------------------------------------


select distinct 
	'insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value) values (' || 22 || ', ''' || "HOR_REF_DATUM" || ''', '''');'
from "Tank_Cleanup_Incidents"
order by 1;
 
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value) values (22, 'NAD27', 'Map interpolation');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value) values (22, 'NAD83', 'Map interpolation');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value) values (22, 'UNK', 'Unknown');
insert into release_element_value_mapping (release_element_mapping_id, organization_value, epa_value) values (22, 'WGS84', 'Map interpolation');

select distinct state_value, epa_value
from archive.v_lust_element_mapping 
where element_name like '%Coord%'
--and lower(state_value) like '%jet%'
order by 1, 2;
Estimated								Map interpolation
Geocode									Geocoded address
GPS_EPA									GPS
GPS_State								GPS
GPS_Tribe								GPS
Legacy Verified							Other
OnlineMapGoogle							Map interpolation
OnlineMapMS								Map interpolation
Site Assessment Report by MCE Environmental dated 2/12/2003	Other
Trimble, collected 5/3/2010				Other
Trimble, collected 5/4/2010				Other
Trimble, collected 5/5/2010				Other

select * from public.coordinate_sources order by 1;
