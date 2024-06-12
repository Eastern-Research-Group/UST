----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name,
	state_join_table, state_join_column, state_join_column_fk)
values ('MO', '2023-06-20', 'OwnerType', 'tblownerclass', 'ownerdescription', 'tblowner', 'ownercode', 'ownerclass')
returning id;

select * from ust_element_db_mapping order by 1 desc;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (266, ''' || ownerdescription ||  ''', '''');'
from "MO_UST".tblownerclass
order by 1;

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (266, 'City', 'Local Government');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (266, 'County', 'Local Government');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (266, 'Federal', 'Federal Government - Non Military');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (266, 'Government Owner', '');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (266, 'Hospital', 'Commercial');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (266, 'Local', 'Local Government');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (266, 'Marketer', 'Private');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (266, 'Non-Marketer', 'Private');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (266, 'Private Owner', 'Private');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (266, 'School', 'Local Government');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (266, 'State', 'State Government - Non Military');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (266, 'Unclassified', '');

select * from "MO_UST".tblownerclass order by 1;

 CASE WHEN fed.ownerid IS NOT NULL THEN 'Federal Government - Non Military'
      WHEN state.ownerid IS NOT NULL THEN 'State Government - Non Military'
      WHEN localg.ownerid IS NOT NULL THEN 'Local Government'
 	  WHEN commercial.ownerid IS NOT NULL THEN 'Commercial'
 	  WHEN private.ownerid IS NOT NULL THEN 'Private' END as "OwnerType",

left join tblowner o on fl.ownerid = o.ownerid
left join (select distinct ownerid from tblownertype where ownerclass = 'h') commercial on o.ownerid = commercial.ownerid
left join (select distinct ownerid from tblownertype where ownerclass = 'f') fed on o.ownerid = fed.ownerid
left join (select distinct ownerid from tblownertype where ownerclass in ('c','l','o','z')) localg on o.ownerid = localg.ownerid
left join (select distinct ownerid from tblownertype where ownerclass in ('m','n','p')) private on o.ownerid = private.ownerid
left join (select distinct ownerid from tblownertype where ownerclass = 's') state on o.ownerid = state.ownerid

select * from owner_type;

----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name,
	state_join_table, state_join_column, state_join_column_fk)
values ('MO', '2023-06-20', 'TankLocation', 'tbltanktype', 'tanktypedescription', 'tbltank', 'tanktypecode', 'tanktype')
returning id;

select * from ust_element_db_mapping

update ust_element_db_mapping 
set state_table_name = 'tbltanktype', 
	state_column_name = 'tanktypedescription', 
	state_join_table = 'tbltank',
	state_join_column = 'tanktypecode',
	state_join_column_fk = 'tanktype'
where id = 258;

select * from "MO_UST".tbltanktype;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (258, ''' || tanktypedescription ||  ''', '''');'
from "MO_UST"."tbltanktype"
order by 1;


insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (258, 'Above Ground', 'Aboveground (tank bottom on-grade)'); --!!!!!????
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (258, 'Below Ground', 'Underground (entirely buried)');

select * from ust_element_value_mappings where element_db_mapping_id = 258;

update ust_element_value_mappings set state_value = 'Above Ground' where element_db_mapping_id = 258 and state_value = 'A';
update ust_element_value_mappings set state_value = 'Below Ground' where element_db_mapping_id = 258 and state_value = 'B';

 case when t.tanktype = 'A' then '' -- EPA values are Aboveground (tank bottom  abovegrade)", Aboveground (tank bottom on-grade)", and Partially Buried
      when t.tanktype = 'B' then 'Underground (entirely buried)' end as "TankLocation",

      select * from tank_location;
      
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name,
	state_join_table, state_join_column, state_join_column_fk)
values ('MO', '2023-06-20', 'TankStatus', 'tbltankstatus', 'tankstatusdescription', 'tbltank', 'tankstatuscode', 'status')
returning id;

update ust_element_db_mapping 
set state_table_name = 'tbltankstatus', 
	state_column_name = 'tankstatusdescription', 
	state_join_table = 'tbltank',
	state_join_column = 'tankstatuscode',
	state_join_column_fk = 'status'
where id = 259;


select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (259, ''' || tankstatusdescription ||  ''', '''');'
from "MO_UST".tbltankstatus
order by 1;

select * from "MO_UST".tbltankstatus order by 1;



insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (259, 'Currently In Use', 'Currently in use');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (259, 'New Install', 'Currently in use');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (259, 'Closed In Place', 'Closed (in place)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (259, 'Removed', 'Closed (removed from ground)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (259, 'Change In Service', 'Closed (general)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (259, 'Out of Use', 'Closed (general)');

select * from ust_element_value_mappings where element_db_mapping_id = 259;


select * from v_ust_element_mapping where element_name = 'TankStatus'

CASE WHEN t.status IN ('C','N') THEN 'Currently in use'
      WHEN t.status = 'P' THEN 'Closed (in place)' 
      WHEN t.status = 'R' THEN 'Closed (removed from ground)' 
      WHEN t.status = 'S' THEN 'Closed (general)' --CHANGE IN service
      WHEN t.status = 'T' THEN 'Closed (general)' END as "TankStatus", --OUT OF use
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name,
	state_join_table, state_join_column, state_join_column_fk)
values ('MO', '2023-06-20', 'CompartmentSubstanceStored', 'tbltanksubstance', 'tanksubstancedescription', 'tbltank', 'tanksubstancecode', 'substance')
returning id;

update ust_element_db_mapping 
set state_table_name = 'tbltanksubstance', 
	state_column_name = 'tanksubstancedescription', 
	state_join_table = 'tbltank',
	state_join_column = 'tanksubstancecode',
	state_join_column_fk = 'substance'
where id = 260;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (260, ''' || tanksubstancedescription ||  ''', '''');'
from "MO_UST".tbltanksubstance
order by 1;    

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (260, 'AV Gas (Aviation)', 'Aviation gasoline');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (260, 'B-5 or > Biodiesel', '95% renewable diesel", 5% biodiesel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (260, 'Diesel', 'Diesel fuel (b-unknown)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (260, 'Dyed Diesel', 'Off-road diesel/dyed diesel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (260, 'E15/ Ethanol', 'Gasoline E-15 (E-11-E15)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (260, 'E85/Ethanol', 'E-85/Flex Fuel (E51-E83)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (260, 'E98/ Ethanol', 'Gasoline/ethanol blend containing more than 83% and less than 98% ethanol');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (260, 'Empty', null);
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (260, 'Gasoline, Including Blends', 'Gasoline (unknown type)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (260, 'Hazardous Substance', 'Hazardous substance');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (260, 'Jet Fuel', 'Jet fuel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (260, 'Kerosene', 'Kerosene');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (260, 'Midgrade Gas', 'Gasoline (unknown type)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (260, 'New Oil', 'Lube/motor oil (new)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (260, 'Other', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (260, 'Premium EO (Without Ethanol)', 'Gasoline (non-ethanol)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (260, 'Premium Unleaded', 'Gasoline (unknown type)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (260, 'Unknown', 'Unknown');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (260, 'Unleaded / Regular', 'Gasoline (unknown type)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (260, 'Unspecified Petroleum', 'Petroleum products');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (260, 'Used Oil', 'Used oil/waste oil');

select * from "MO_UST".tbltanksubstance order by 1;


 CASE WHEN tc.substance = 'E' THEN 'E-85/Flex Fuel (E51-E83)'
      WHEN tc.substance = 'Y' THEN '95% renewable diesel", 5% biodiesel'
      WHEN tc.substance = 'A' THEN 'Aviation gasoline'
      WHEN tc.substance = 'D' THEN 'Diesel fuel (b-unknown)'
      WHEN tc.substance = 'F' THEN 'Gasoline (non-ethanol)'
      WHEN tc.substance IN ('U','M','P','R') THEN 'Gasoline (unknown type)'
      WHEN tc.substance = 'C' THEN 'Gasoline E-15 (E-11-E15)'
      WHEN tc.substance = 'B' THEN 'Gasoline/ethanol blend containing more than 83% and less than 98% ethanol' --E98/ Ethanol; mapping IS probably wrong
      WHEN tc.substance = 'T' THEN 'Hazardous substance'
      WHEN tc.substance = 'J' THEN 'Jet fuel'
      WHEN tc.substance = 'K' THEN 'Kerosene'
      WHEN tc.substance = 'N' THEN 'Lube/motor oil (new)'
      WHEN tc.substance = 'G' THEN 'Off-road diesel/dyed diesel'
      WHEN tc.substance = 'O' THEN 'Other'
      WHEN tc.substance = 'V' THEN 'Petroleum products'
      WHEN tc.substance = 'W' THEN 'Used oil/waste oil'
      WHEN tc.substance = 'Z' THEN 'Unknown'
      END as "CompartmentSubstanceStored",
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('MO', '2023-06-20', 'TankWallType', 'tbltank', 'tankdoublewall')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (261, ''' || tankdoublewall ||  ''', '''');'
from "MO_UST".tbltank
order by 1;  

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (261, '-1', 'Double');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (261, '0', 'Single');

select * from ust_element_value_mappings where element_db_mapping_id = 261;

CASE WHEN t.tankdoublewall = -1 THEN 'Double' 
      WHEN t.tankdoublewall = 0 THEN 'Single' END as "TankWallType", 
      
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name,
	state_join_table, state_join_column, state_join_column_fk)
values ('MO', '2023-06-20', 'MaterialDescription', 'tbltankmaterial', 'tankmaterialdescription', 'tbltank', 'tankmaterialcode', 'tankmaterial')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (262, ''' || tankmaterialdescription ||  ''', '''');'
from "MO_UST".tbltankmaterial
order by 1;        
      
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (262, 'Clad Steel', 'Composite/clad (steel w/fiberglass reinforced plastic)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (262, 'Fiberglass', 'Fiberglass reinforced plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (262, 'Other', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (262, 'Steel', 'Asphalt coated or bare steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (262, 'Unknown', 'Unknown');

select * from "MO_UST".tbltankmaterial order by 1;

 CASE WHEN t.tankmaterial = 0 THEN 'Unknown'
      WHEN t.tankmaterial = 1 THEN 'Asphalt coated or bare steel' 
      WHEN t.tankmaterial = 2 THEN 'Composite/clad (steel w/fiberglass reinforced plastic)' 
      WHEN t.tankmaterial = 3 THEN 'Fiberglass reinforced plastic' 
      WHEN t.tankmaterial = 4 THEN 'Other' end as "MaterialDescription",
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name,
	state_join_table, state_join_column, state_join_column_fk)
values ('MO', '2023-06-20', 'PipingMaterialDescription', 'tblpipematerial', 'pipematerialdescription', 'tbltankbycompartment', 'pipematerialcode', 'pipematerial')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (263, ''' || pipematerialdescription ||  ''', '''');'
from "MO_UST".tblpipematerial
order by 1;         

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (263, 'APT Flex', 'Flex Piping');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (263, 'Combination', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (263, 'Copper', 'Copper');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (263, 'Environ', 'Flex Piping');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (263, 'EnvironFlex', 'Flex Piping');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (263, 'Fiberglass(FRP)', 'Fiberglass Reinforced Plastic');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (263, 'Flex Pipe', 'Flex Piping');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (263, 'None', 'No Piping');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (263, 'Other', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (263, 'Semi Rigid', '');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (263, 'Steel', 'Steel');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (263, 'TC-BlueFlex', 'Flex Piping');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (263, 'Unknown', 'Unknown');

select * from  "MO_UST".tblpipematerial order by 1;         

CASE WHEN tc.pipematerial = 3 THEN 'Copper'
 	  WHEN tc.pipematerial = 2 THEN 'Fiberglass Reinforced Plastic'
 	  WHEN tc.pipematerial IN (6,7,8,10,11) THEN 'Flex Piping'
 	  WHEN tc.pipematerial = 5 THEN 'No Piping'
 	  WHEN tc.pipematerial in (4,9) THEN 'Other'
 	  WHEN tc.pipematerial = 1 THEN 'Steel'
 	  WHEN tc.pipematerial = 0 THEN 'Unknown'
 	  WHEN tc.pipematerial = 12 THEN '' --???
 	END as "PipingMaterialDescription",
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name,
	state_join_table, state_join_column, state_join_column_fk)
values ('MO', '2023-06-20', 'PipingStyle', 'tblpipingsystem', 'tankpipingsystemdescription', 'tbltankbycompartment', 'tankpipingsystemcode', 'pipesystem')
returning id;

select * from ust_element_db_mapping order by 1 desc;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (264, ''' || tankpipingsystemdescription ||  ''', '''');'
from "MO_UST".tblpipingsystem
order by 1;         
 	
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (264, 'Gravity', 'Non-operational (e.g., fill line, vent line, gravity)');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (264, 'Manifold', 'Other');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (264, 'Pressure', 'Pressure');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (264, 'Safe Suction', 'Suction');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (264, 'Suction', 'Suction');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (264, 'Unsafe Suction', 'Suction');

select * from "MO_UST".tblpipingsystem order by 1;

 CASE WHEN tc.pipesystem IN (0,2,3) THEN 'Suction'
 	  WHEN tc.pipesystem  = 1 THEN 'Pressure'
 	  WHEN tc.pipesystem  = 4 THEN 'Non-operational (e.g., fill line, vent line, gravity)'
 	  WHEN tc.pipesystem  = 8 THEN '' --Manifold
 	 end as "PipingStyle",
 	 
 	 select * from v_ust_element_mapping where element_name = 'PipingStyle'
 	 
 	 select * from piping_style;
----------------------------------------------------------------------------------------------------------------------------------
insert into ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('MO', '2023-06-20', 'PipingWallType', 'tbltankbycompartment', 'pipedoublewall')
returning id;

select distinct 
'insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (265, ''' || pipedoublewall ||  ''', '''');'
from "MO_UST".tbltankbycompartment
order by 1;    

insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (265, '-1', 'Double');
insert into ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (265, '0', 'Single');
 	 
select * from ust_element_value_mappings where element_db_mapping_id = 265;

 CASE WHEN tc.pipedoublewall = -1 THEN 'Double'
      WHEN tc.pipedoublewall = 0 THEN 'Single' END as "PipingWallType", 
      
      
      
------------------------------------------------------------------------------------------------------------------------------------------------------
drop view "MO_UST".v_ust_base;
create view "MO_UST".v_ust_base as
SELECT distinct 
 g.facilityid as "FacilityID",
 g."NAME" as "FacilityName",
 ot.epa_value as "OwnerType",
 g.address as "FacilityAddress1",
 g.address2 as "FacilityAddress2",
 g.zip as "FacilityZipCode",
 c.countyname as "FacilityCounty",
 f.facareacode || f.facphoneprefix || f.facphonesuffix as "FacilityPhoneNumber",
 'MO' as "FacilityState",
 7 as "FacilityEPARegion",
 ll.converted_lat as "FacilityLatitude", 
 ll.converted_long as "FacilityLongitude", 
 o."NAME" as "FacilityOwnerCompanyName", --this appears to sometimes be a first/last name but it's only one field and can't programmatically know which are person's names and which company names
 o.address as "FacilityOwnerAddress1",
 o.address2 as "FacilityOwnerAddress2",
 o.city as "FacilityOwnerCity",
 o.county as "FacilityOwnerCounty",
 o.zip as "FacilityOwnerZipCode",
 o.state as "FacilityOwnerState",
 o.areacode || o.phoneprefix || o.phonesuffix as "FacilityOwnerPhoneNumber",
 o.ow_email as "FacilityOwnerEmail",
 f.contact as "FacilityOperatorName",
 f.contactareacode || f.contactphoneprefix || f.contactphonesuffix as "FacilityOperatorPhoneNumber", 
 f.emailaddress1 as "FacilityOperatorEmail", 
 t.tankid as "TankID",
 tl.epa_value as "TankLocation",
 tc.compartmentno  as "CompartmentID",
 ts.epa_value as "TankStatus",
 t.dateclosed as "ClosureDate",
 t.tankinstallationdate  as "InstallationDate",
 CASE WHEN tn.numcompartments > 1 THEN 'Yes' ELSE 'No' end as "CompartmentalizedUST",
 tn.numcompartments as "NumberofCompartments",
 css.epa_value as "CompartmentSubstanceStored",
 tc.capacity as "CompartmentCapacityGallons",
 twt.epa_value as "TankWallType", 
 md.epa_value as "MaterialDescription",
 pmd.epa_value as "PipingMaterialDescription",
 ps.epa_value as "PipingStyle",
 pwt.epa_value as "PipingWallType", 
 CASE WHEN t.tankexternalprotection = 2 THEN 'Yes' END as "TankCorrosionProtectionSacrificialAnode",
 CASE WHEN t.tankexternalprotection = 2 THEN 'Unknown' END as "TankCorrosionProtectionAnodesInstalledOrRetrofitted",
 CASE WHEN t.tankexternalprotection = 1 THEN 'Yes' END as "TankCorrosionProtectionImpressedCurrent",
 CASE WHEN t.tankexternalprotection = 1 THEN 'Unknown' END as "TankCorrosionProtectionImpressedCurrentInstalledOrRetrofitted",
 CASE WHEN tc.pipeprotection = 2 THEN 'Yes' end as "PipingCorrosionProtectionSacrificialAnodes",
 CASE WHEN tc.pipeprotection = 2 THEN 'Unknown' end as "PipingCorrosionProtectionAnodesInstalledOrRetrofitted",
 CASE WHEN tc.pipeprotection = 1 THEN 'Yes' end as "PipingCorrosionProtectionImpressedCurrent",
 CASE WHEN tc.pipeprotection = 1 THEN 'Unknown' end as "PipingCorrosionProtectionImpressedCurrentInstalledOrRetrofitted",
 CASE WHEN tc.pipeprotection = 6 THEN 'Yes' end as "PipingCorrosionProtectionCathodicNotRequired", 
 CASE WHEN ballvalve.tankcompartmentpk IS NOT NULL THEN 'Yes' end as "BallFloatValve",
 CASE WHEN autoshutoff.tankcompartmentpk IS NOT NULL THEN 'Yes' end as "FlowShutoffDevice",
 CASE WHEN alarm.tankcompartmentpk IS NOT NULL THEN 'Yes' end as "HighLevelAlarm",
 CASE WHEN tc.spillprotection = -1 THEN 'Yes' 
      WHEN tc.spillprotection = 0 THEN 'No' END as "SpillBucketInstalled", 
 CASE WHEN atg.tankcompartmentpk IS NOT NULL THEN 'Yes' end as "AutomaticTankGauging",
 CASE WHEN atg.tankcompartmentpk IS NOT NULL THEN 'Unknown' end as "AutomaticTankGaugingReleaseDetection",
 CASE WHEN atg.tankcompartmentpk IS NOT NULL THEN 'Unknown' end as "AutomaticTankGaugingContinuousLeakDetection",
 CASE WHEN mtg.tankcompartmentpk IS NOT NULL THEN 'Yes' end as "ManualTankGauging",
 CASE WHEN sir.tankcompartmentpk IS NOT NULL THEN 'Yes' end as "StatisticalInventoryReconciliation",
 CASE WHEN tt.tankcompartmentpk IS NOT NULL THEN 'Yes' end as "TankTightnessTesting",
 CASE WHEN gw.tankcompartmentpk IS NOT NULL THEN 'Yes' end as "GroundwaterMonitoring",
 CASE WHEN vapor.tankcompartmentpk IS NOT NULL THEN 'Yes' end as "VaporMonitoring",
 CASE WHEN elld.tankcompartmentpk IS NOT NULL THEN 'Yes' end as "ElectronicLineLeak",
 CASE WHEN alld.tankcompartmentpk IS NOT NULL THEN 'Yes' end as "MechanicalLineLeak",
 CASE WHEN atm.tankcompartmentpk IS NOT NULL THEN 'Yes' end as "AutomatedIntersticialMonitoring",
 CASE WHEN rem.facilityid IS NOT NULL THEN 'Yes' end as "USTReportedRelease",
 rem.remid as "AssociatedLUSTID"
from "MO_UST".tblfacility f left join
	(select facilityid, case when r = 5 then 'Federal Government - Non Military'
	                        when r = 4 then 'State Government - Non Military'
	                        when r = 3 then 'Local Government'
	                        when r = 2 then 'Commercial'
	                        when r = 1 then 'Private'
	                        when r = 0 then null end as epa_value 
	from
		(select facilityid, max(r) as r from 
			(select fl.facilityid, case when epa_value = 'Federal Government - Non Military' then 5 
			                           when epa_value = 'State Government - Non Military' then 4
			                           when epa_value = 'Local Government' then 3
			                           when epa_value = 'Commercial' then 2
			                           when epa_value = 'Private' then 1
			                           else 0 end as r
			from v_ust_element_mapping a join "MO_UST".tblownerclass toc on a.state_value = toc.ownerdescription 
				join "MO_UST".tblownertype tot on toc.ownercode = tot.ownerclass 
				join "MO_UST".tblfacilitylookup fl on tot.ownerid = fl.ownerid
			where a.state = 'MO' and a.element_name = 'OwnerType') a
		group by facilityid) b) ot on f.facilityid = ot.facilityid
left join "MO_UST".tblgeosite g on f.facilityid  = g.facilityid  
left join "MO_UST".tblgeosite_latlong ll on f.facilityid = ll.facilityid
left join "MO_UST".tblcounty c on g.county = c.countycode 
left join "MO_UST".tblfacilitylookup fl on f.facilityid = fl.facilityid
left join "MO_UST".tblowner o on fl.ownerid = o.ownerid
left join "MO_UST".tbltank t on f.facilityid = t.facilityid
left join "MO_UST".tbltankbycompartment tc on t.tankpk = tc.tankpk 
left join (select tankpk, count(*) as "numcompartments" from "MO_UST".tbltankbycompartment group by tankpk) tn 
	on t.tankpk = tn.tankpk
left join "MO_UST".tbltankstatus tts on t.status = tts.tankstatuscode
left join (select distinct state_value, epa_value from v_ust_element_mapping where state = 'MO' and element_name = 'TankStatus') ts on ts.state_value = tts.tankstatusdescription 
left join "MO_UST".tbltanktype ttt on t.tanktype = ttt.tanktypecode
left join (select distinct state_value, epa_value from v_ust_element_mapping where state = 'MO' and element_name = 'TankLocation') tl on tl.state_value = ttt.tanktypedescription
left join "MO_UST".tblpipingsystem tps on tc.pipesystem = tps.tankpipingsystemcode
left join (select distinct state_value, epa_value from v_ust_element_mapping where state = 'MO' and element_name = 'PipingStyle') ps on ps.state_value = tps.tankpipingsystemdescription
left join (select distinct state_value, epa_value from v_ust_element_mapping where state = 'MO' and element_name = 'TankWallType') twt on twt.state_value = t.tankdoublewall::text
left join "MO_UST".tbltanksubstance tsub on tc.substance = tsub.tanksubstancecode
left join (select distinct state_value, epa_value from v_ust_element_mapping where state = 'MO' and element_name = 'CompartmentSubstanceStored') css on css.state_value = tsub.tanksubstancedescription
left join "MO_UST".tbltankmaterial tmat on t.tankmaterial = tmat.tankmaterialcode
left join (select distinct state_value, epa_value from v_ust_element_mapping where state = 'MO' and element_name = 'MaterialDescription') md on md.state_value = tmat.tankmaterialdescription
left join (select distinct state_value, epa_value from v_ust_element_mapping where state = 'MO' and element_name = 'PipingWallType') pwt on pwt.state_value = tc.pipedoublewall::text
left join "MO_UST".tblpipematerial pmat on tc.pipematerial = pmat.pipematerialcode
left join (select distinct state_value, epa_value from v_ust_element_mapping where state = 'MO' and element_name = 'PipingMaterialDescription') pmd on pmd.state_value = pmat.pipematerialdescription
left join (select distinct tankcompartmentpk from "MO_UST".tbltankoverfillprot where typeoverfillprot = 1) autoshutoff 
	on tc.tankcompartmentpk = autoshutoff.tankcompartmentpk
left join (select distinct tankcompartmentpk from "MO_UST".tbltankoverfillprot where typeoverfillprot = 2) ballvalve 
	on tc.tankcompartmentpk = ballvalve.tankcompartmentpk	
left join (select distinct tankcompartmentpk from "MO_UST".tbltankoverfillprot where typeoverfillprot = 3) alarm 
	on tc.tankcompartmentpk = alarm.tankcompartmentpk	
left join (select distinct tankcompartmentpk from "MO_UST".tbltankrlsdetection where tankreleasecode = 5) interstitial 
	on tc.tankcompartmentpk = interstitial.tankcompartmentpk
left join (select distinct tankcompartmentpk from "MO_UST".tbltankrlsdetection where tankreleasecode = 1) atg  
	on tc.tankcompartmentpk = atg.tankcompartmentpk
left join (select distinct tankcompartmentpk from "MO_UST".tbltankrlsdetection where tankreleasecode = 3) mtg  
	on tc.tankcompartmentpk = mtg.tankcompartmentpk
left join (select distinct tankcompartmentpk from "MO_UST".tbltankrlsdetection where tankreleasecode = 6) sir 
	on tc.tankcompartmentpk = sir.tankcompartmentpk
left join (select distinct tankcompartmentpk from "MO_UST".tbltankrlsdetection where tankreleasecode = 2) tt 
	on tc.tankcompartmentpk = tt.tankcompartmentpk
left join (select distinct tankcompartmentpk from "MO_UST".tbltankrlsdetection where tankreleasecode = 8) gw 
	on tc.tankcompartmentpk = gw.tankcompartmentpk
left join (select distinct tankcompartmentpk from "MO_UST".tbltankrlsdetection where tankreleasecode = 7) vapor 
	on tc.tankcompartmentpk = vapor.tankcompartmentpk
left join (select distinct tankcompartmentpk from "MO_UST".tbltankpipereleasedet where pipereleasedetcode = 1) elld
	on tc.tankcompartmentpk = elld.tankcompartmentpk
left join (select distinct tankcompartmentpk from "MO_UST".tbltankpipereleasedet where electronicormechanicallld = 2) alld
	on tc.tankcompartmentpk = alld.tankcompartmentpk
left join (select distinct tankcompartmentpk from "MO_UST".tbltankpipereleasedet where pipereleasedetcode = 3) atm
	on tc.tankcompartmentpk = atm.tankcompartmentpk
left join (select facilityid, max(remid) remid from "MO_UST".tblremediation group by facilityid) rem
	on f.facilityid = rem.facilityid
where ownerinactivewfacility = 0
and tanktype <> 'A' --???
order by g.facilityid, t.tankid;



select distinct element_name, state_table_name, state_column_name, state_join_table, state_join_column, state_join_column_fk 
from v_ust_element_mapping
where state = 'MO';


select * From  "MO_UST".tblgeosite;






select * from v_ust_element_mapping where state = 'MO' and element_name = 'OwnerType' 

select facilityid, case when r = 5 then 'Federal Government - Non Military'
                        when r = 4 then 'State Government - Non Military'
                        when r = 3 then 'Local Government'
                        when r = 2 then 'Commercial'
                        when r = 1 then 'Private'
                        when r = 0 then null end as epa_value 
from
	(select facilityid, max(r) as r from 
		(select fl.facilityid, case when epa_value = 'Federal Government - Non Military' then 5 
		                           when epa_value = 'State Government - Non Military' then 4
		                           when epa_value = 'Local Government' then 3
		                           when epa_value = 'Commercial' then 2
		                           when epa_value = 'Private' then 1
		                           else 0 end as r
		from v_ust_element_mapping a join "MO_UST".tblownerclass toc on a.state_value = toc.ownerdescription 
			join "MO_UST".tblownertype tot on toc.ownercode = tot.ownerclass 
			join "MO_UST".tblfacilitylookup fl on tot.ownerid = fl.ownerid
		where a.state = 'MO' and a.element_name = 'OwnerType') a
	group by facilityid) b;


select distinct epa_value from v_ust_element_mapping where state = 'MO' and element_name = 'OwnerType'  order by 1;

Commercial	NI0000393
Private	NI0000393
Private	NI0000404
Local Government	NI0000405
Private	NI0000405

select * from owner_type;
Federal Government - Non Military
State Government - Non Military
Tribal Governernment
Local Government
Commercial
Private
Military
