select * from "CA_LUST".remediations ;



select * from "CA_LUST".sites;

select * from  "CA_LUST".regulatory_activities where "ACTION_TYPE" = 'REMEDIATION'
2001-10-04 00:00:00

select "BEGIN_DATE","LEAK_REPORTED_DATE" 
from "CA_LUST".sites
where "GLOBAL_ID" = 'T0606700017'
1982-03-11 00:00:00	
1982-03-11 00:00:00


select distinct "CASE_TYPE" from sites order by 1;

delete from sites where "CASE_TYPE" not in ('LUST Cleanup Site','Military UST Site');;

LUST Cleanup Site
Military UST Site

select count(*) from sites;
42049

select count(*) from sites a join status_history b on a."GLOBAL_ID" = b."GLOBAL_ID";
183581

delete from status_history where "GLOBAL_ID" not in (select "GLOBAL_ID" from sites);

select count(*) from sites a join contacts b on a."GLOBAL_ID" = b."GLOBAL_ID";
59506

delete from contacts where "GLOBAL_ID" not in (select "GLOBAL_ID" from sites);


select distinct "STATUS" from status_history order by 1;
Completed - Case Closed
Informational Item
Open
Open - Active
Open - Assessment & Interim Remedial Action
Open - Case Begin Date
Open - Eligible for Closure
Open - Inactive
Open - Referred
Open - Remediation
Open - Reopen Case
Open - Site Assessment
Open - Verification Monitoring
Pending Review

select distinct "STATUS" from sites order by 1;
Completed - Case Closed
Informational Item
Open - Assessment & Interim Remedial Action
Open - Eligible for Closure
Open - Inactive
Open - Remediation
Open - Site Assessment
Open - Verification Monitoring

select distinct "COORDINATE_SOURCE" from sites order by 1;
"Map Interpolation
GPS
PLSS
Geocode
Other
Unknown"

select distinct "POTENTIAL_MEDIA_OF_CONCERN" from sites order by 1;


select distinct "POTENTIAL_CONTAMINANTS_OF_CONCERN" from sites order by 1;


select "GLOBAL_ID", "POTENTIAL_CONTAMINANTS_OF_CONCERN" from sites where "POTENTIAL_CONTAMINANTS_OF_CONCERN" is not null order by 1;

-----------------------------------------------------------------------------------------------------------------------
select * from substance_xwalk;

--see Python script
--create table global_id_substances ("GLOBAL_ID" text, "SUBSTANCE" text);

select * from global_id_substances order by 1, 2;

update global_id_substances set "SUBSTANCE" = replace("SUBSTANCE",'* ','');

select distinct "SUBSTANCE" from global_id_substances order by 1;

insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'1','Unknown');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'1-Trichloroethane (TCA)','Solvent');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'4-Dioxane','Solvent');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Acetone','Solvent');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Alcohols','Other');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Arsenic','Hazardous substance');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Asbestos Containing Materials (ACM)','Hazardous substance');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Asphalt','Other');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Aviation','Unknown aviation gas or jet fuel');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Benzene','Petroleum product');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'BTEX','Petroleum product');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Chlordane','Hazardous substance');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Chlorinated Hydrocarbons','Hazardous substance');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Chloroform','Hazardous substance');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Chromium','Hazardous substance');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Chromium VI','Hazardous substance');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Copper','Hazardous substance');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Crude Oil','Petroleum product');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Cyanide','Hazardous substance');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'DDD / DDE / DDT','Hazardous substance');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Dichloroethane (DCA)','Hazardous substance');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Dichloroethene (DCE)','Hazardous substance');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Diesel','Diesel fuel (b-unknown)');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Dioxin / Furans','Hazardous substance');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Endrin','Hazardous substance');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'ETHYL TERT-BUTYL ETHER (ETBE)','Gasoline (unknown type)');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Ethylbenzene','Petroleum product');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Freon','Hazardous substance');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Fuel Oxygenates','Gasoline (unknown type)');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Gasoline','Gasoline (unknown type)');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Heating Oil / Fuel Oil','Heating/fuel oil # unknown');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Kerosene','Kerosene');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Lead','Hazardous substance');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Mercury (elemental)','Hazardous substance');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Metals','Other');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Methane','Other');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'MTBE / TBA / Other Fuel Oxygenates','Gasoline (unknown type)');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Naphthalene','Petroleum product');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Nickel','Hazardous substance');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Other Acid or Corrosive','Other');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Other CFCs','Hazardous substance');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Other Chlorinated Hydrocarbons','Hazardous substance');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Other Insecticides / Pesticide / Fumigants / Herbicides','Other');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Other Metal','Other');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Other Petroleum','Petroleum product');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Other Solvent or Non-Petroleum Hydrocarbon','Solvent');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Pentachlorophenol (PCP)','Pentachlorophenol (PCP)');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Petroleum','Petroleum product');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Petroleum - Automotive gasolines','Gasoline (unknown type)');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Petroleum - Diesel fuels','Diesel fuel (b-unknown)');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Petroleum - Other','Petroleum product');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Petroleum - Waste Oil','Used oil/waste oil');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Polychlorinated biphenyls (PCBs)','Hazardous substance');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Polynuclear aromatic hydrocarbons (PAHs)','Petroleum product');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Silver','Hazardous substance');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Solvents','Solvent');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Stoddard solvent / Mineral Spriits / Distillates','Solvent');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'TDS','Other');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'TERT-AMYL METHYL ETHER (TAME)','Gasoline (unknown type)');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'TERT-BUTYL ALCOHOL (TBA)','Gasoline (unknown type)');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Tetrachloroethylene (PCE)','Solvent');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Toluene','Petroleum product');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Total Petroleum Hydrocarbons (TPH)','Petroleum product');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Trichloroethylene (TCE)','Solvent');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Vinyl chloride','Hazardous substance');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'VOLATILE ORGANIC COMPOUNDS','Other');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Volatile Organic Compounds (VOC)','Other');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Waste Oil / Motor / Hydraulic / Lubricating','Used oil/waste oil');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Xylene','Solvent');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Zinc','Hazardous substance');

update lust_element_value_mappings set epa_approved = 'Y', programmer_comments = 'Assuming prior mapping was approved; can''t find original template'
where element_db_mapping_id = 1;

select * from public.substances 
--where lower(substance) like lower('%toxa%')
where substance_group = 'Other'
order by 1;

insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'PAHs/PNAs','Hazardous substance');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Per- and Polyfluoroalkyl Substances (PFAS)','Hazardous substance');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Pesticide/Herbicides','Hazardous substance');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (1,'Toxaphene','Hazardous substance');


select * from substances_deagg ;

update substances_deagg s set epa_value = 
	(select epa_value from lust_element_value_mappings x
	where s."POTENTIAL_CONTAMINANTS_OF_CONCERN" = x.state_value 
	and element_db_mapping_id = 1)
where exists 
	(select 1 from lust_element_value_mappings x
	where s."POTENTIAL_CONTAMINANTS_OF_CONCERN" = x.state_value 
	and element_db_mapping_id = 1);
--
--update global_id_substances s set "EPA_SUBSTANCE" =
--	(select "EPA_SUBSTANCE"  from substance_xwalk x 
--	where s."SUBSTANCE" = x."CA_SUBSTANCE")
--where exists
--	(select "EPA_SUBSTANCE"  from substance_xwalk x 
--	where s."SUBSTANCE" = x."CA_SUBSTANCE");

create or replace view v_epa_substances as
select a.*, row_number() over (partition by "GLOBAL_ID" order by epa_value) rn 
from (select distinct "GLOBAL_ID", epa_value
	  from substances_deagg where epa_value is not null) a;

--create or replace view v_epa_substances as
--select a.*, row_number() over (partition by "GLOBAL_ID" order by "EPA_SUBSTANCE") rn 
--from (select distinct "GLOBAL_ID", "EPA_SUBSTANCE"
--	  from global_id_substances where "EPA_SUBSTANCE" is not null) a;	 
	
create or replace view v_epa_substances_cross as
select a."GLOBAL_ID", 
	a.epa_value substance1, b.epa_value substance2, c.epa_value substance3, d.epa_value substance4, e.epa_value substance5
from (select "GLOBAL_ID", epa_value from v_epa_substances where rn = 1) a 
	left join (select "GLOBAL_ID", epa_value from v_epa_substances where rn = 2) b on a."GLOBAL_ID" = b."GLOBAL_ID"
	left join (select "GLOBAL_ID", epa_value from v_epa_substances where rn = 3) c on a."GLOBAL_ID" = c."GLOBAL_ID"
	left join (select "GLOBAL_ID", epa_value from v_epa_substances where rn = 4) d on a."GLOBAL_ID" = d."GLOBAL_ID"
	left join (select "GLOBAL_ID", epa_value from v_epa_substances where rn = 5) e on a."GLOBAL_ID" = e."GLOBAL_ID";
		  
--create or replace view v_epa_substances_cross as
--select a."GLOBAL_ID", 
--	a."EPA_SUBSTANCE" substance1, b."EPA_SUBSTANCE" substance2, c."EPA_SUBSTANCE" substance3, d."EPA_SUBSTANCE" substance4, e."EPA_SUBSTANCE" substance5
--from (select "GLOBAL_ID", "EPA_SUBSTANCE" from v_epa_substances where rn = 1) a 
--	left join (select "GLOBAL_ID", "EPA_SUBSTANCE" from v_epa_substances where rn = 2) b on a."GLOBAL_ID" = b."GLOBAL_ID"
--	left join (select "GLOBAL_ID", "EPA_SUBSTANCE" from v_epa_substances where rn = 3) c on a."GLOBAL_ID" = c."GLOBAL_ID"
--	left join (select "GLOBAL_ID", "EPA_SUBSTANCE" from v_epa_substances where rn = 4) d on a."GLOBAL_ID" = d."GLOBAL_ID"
--	left join (select "GLOBAL_ID", "EPA_SUBSTANCE" from v_epa_substances where rn = 5) e on a."GLOBAL_ID" = e."GLOBAL_ID";
--	
-----------------------------------------------------------------------------------------------------------------------


select distinct "SOURCE" from sources order by 1;
Delivery Problem	Other
Dispenser	Dispenser
Other	Other
Piping	Piping
STP	Submersible Turbine Pump 
Tank	Tank

insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (9,'Delivery Problem','Other');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (9,'Other','Other');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (9,'STP','Submersible Turbine Pump');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (9,'Dispenser','Dispenser');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (9,'Piping','Piping');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (9,'Tank','Tank');


update sources_deagg s set epa_value = 
	(select epa_value from lust_element_value_mappings x
	where s."DISCHARGE_SOURCE" = x.state_value 
	and element_db_mapping_id = 9)
where exists 
	(select 1 from lust_element_value_mappings x
	where s."DISCHARGE_SOURCE" = x.state_value 
	and element_db_mapping_id = 9);

create or replace view v_epa_sources as
select a.*, row_number() over (partition by "GLOBAL_ID" order by epa_value) rn 
from (select distinct "GLOBAL_ID", epa_value
	  from sources_deagg where epa_value is not null) a;

--create or replace view v_epa_sources as
--select a.*, row_number() over (partition by "GLOBAL_ID" order by "EPA_SOURCE") rn 
--from (select distinct "GLOBAL_ID", "EPA_SOURCE"
--	  from sources where "EPA_SOURCE" is not null) a;

create or replace view v_epa_sources_cross as
select a."GLOBAL_ID", 
	a.epa_value source1, b.epa_value source2, c.epa_value source3, d.epa_value source4, e.epa_value source5, f.epa_value source6
from (select "GLOBAL_ID", epa_value from v_epa_sources where rn = 1) a 
	left join (select "GLOBAL_ID", epa_value from v_epa_sources where rn = 2) b on a."GLOBAL_ID" = b."GLOBAL_ID"
	left join (select "GLOBAL_ID", epa_value from v_epa_sources where rn = 3) c on a."GLOBAL_ID" = c."GLOBAL_ID"
	left join (select "GLOBAL_ID", epa_value from v_epa_sources where rn = 4) d on a."GLOBAL_ID" = d."GLOBAL_ID"
	left join (select "GLOBAL_ID", epa_value from v_epa_sources where rn = 5) e on a."GLOBAL_ID" = e."GLOBAL_ID"
	left join (select "GLOBAL_ID", epa_value from v_epa_sources where rn = 6) f on a."GLOBAL_ID" = f."GLOBAL_ID";

--create or replace view v_epa_sources_cross as
--select a."GLOBAL_ID", 
--	a."EPA_SOURCE" source1, b."EPA_SOURCE" source2, c."EPA_SOURCE" source3, d."EPA_SOURCE" source4, e."EPA_SOURCE" source5, f."EPA_SOURCE" source6
--from (select "GLOBAL_ID", "EPA_SOURCE" from v_epa_sources where rn = 1) a 
--	left join (select "GLOBAL_ID", "EPA_SOURCE" from v_epa_sources where rn = 2) b on a."GLOBAL_ID" = b."GLOBAL_ID"
--	left join (select "GLOBAL_ID", "EPA_SOURCE" from v_epa_sources where rn = 3) c on a."GLOBAL_ID" = c."GLOBAL_ID"
--	left join (select "GLOBAL_ID", "EPA_SOURCE" from v_epa_sources where rn = 4) d on a."GLOBAL_ID" = d."GLOBAL_ID"
--	left join (select "GLOBAL_ID", "EPA_SOURCE" from v_epa_sources where rn = 5) e on a."GLOBAL_ID" = e."GLOBAL_ID"
--	left join (select "GLOBAL_ID", "EPA_SOURCE" from v_epa_sources where rn = 6) f on a."GLOBAL_ID" = f."GLOBAL_ID";

-----------------------------------------------------------------------------------------------------------------------
create table causes ("GLOBAL_ID" text, "CAUSE" text);

select distinct "CAUSE" from causes order by 1;
Corrosion	Corrosion
Install Problem	Other
Other	Other
Overfill	Delivery Overfill
Physc / Mech Damage	Damage to Dispenser
Spill	Dispenser Spill
Unknown	Unknown


insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (6,'Corrosion','Corrosion');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (6,'Install Problem','Other');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (6,'Other','Other');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (6,'Overfill','Delivery overfill');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (6,'Physc / Mech Damage','Damage to dispenser');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (6,'Spill','Dispenser spill');
insert into public.lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (6,'Unknown','Unknown');

--
--alter table causes add "EPA_CAUSE" text;
--update causes set "EPA_CAUSE" = 'Other' where "CAUSE" in ('Install Problem','Other');
--update causes set "EPA_CAUSE" = 'Delivery Overfill' where "CAUSE" = 'Overfill';
--update causes set "EPA_CAUSE" = 'Damage to Dispenser' where "CAUSE" = 'Physc / Mech Damage';
--update causes set "EPA_CAUSE" = 'Dispenser Spill' where "CAUSE" = 'Spill';
--update causes set "EPA_CAUSE" = "CAUSE";

update causes_deagg s set epa_value = 
	(select epa_value from lust_element_value_mappings x
	where s."DISCHARGE_CAUSE" = x.state_value 
	and element_db_mapping_id = 6)
where exists 
	(select 1 from lust_element_value_mappings x
	where s."DISCHARGE_CAUSE" = x.state_value 
	and element_db_mapping_id = 6);


create or replace view v_epa_causes as
select a.*, row_number() over (partition by "GLOBAL_ID" order by epa_value) rn 
from (select distinct "GLOBAL_ID", epa_value
	  from causes_deagg where epa_value is not null) a;

select max(rn) from v_epa_causes;

create or replace view v_epa_causes_cross as
select a."GLOBAL_ID", 
	a.epa_value cause1, b.epa_value cause2, c.epa_value cause3, d.epa_value cause4, e.epa_value cause5, f.epa_value cause6
from (select "GLOBAL_ID", epa_value from v_epa_causes where rn = 1) a 
	left join (select "GLOBAL_ID", epa_value from v_epa_causes where rn = 2) b on a."GLOBAL_ID" = b."GLOBAL_ID"
	left join (select "GLOBAL_ID", epa_value from v_epa_causes where rn = 3) c on a."GLOBAL_ID" = c."GLOBAL_ID"
	left join (select "GLOBAL_ID", epa_value from v_epa_causes where rn = 4) d on a."GLOBAL_ID" = d."GLOBAL_ID"
	left join (select "GLOBAL_ID", epa_value from v_epa_causes where rn = 5) e on a."GLOBAL_ID" = e."GLOBAL_ID"
	left join (select "GLOBAL_ID", epa_value from v_epa_causes where rn = 6) f on a."GLOBAL_ID" = f."GLOBAL_ID";

--create or replace view v_epa_causes_cross as
--select a."GLOBAL_ID", 
--	a."EPA_CAUSE" cause1, b."EPA_CAUSE" cause2, c."EPA_CAUSE" cause3, d."EPA_CAUSE" cause4, e."EPA_CAUSE" cause5, f."EPA_CAUSE" cause6
--from (select "GLOBAL_ID", "EPA_CAUSE" from v_epa_causes where rn = 1) a 
--	left join (select "GLOBAL_ID", "EPA_CAUSE" from v_epa_causes where rn = 2) b on a."GLOBAL_ID" = b."GLOBAL_ID"
--	left join (select "GLOBAL_ID", "EPA_CAUSE" from v_epa_causes where rn = 3) c on a."GLOBAL_ID" = c."GLOBAL_ID"
--	left join (select "GLOBAL_ID", "EPA_CAUSE" from v_epa_causes where rn = 4) d on a."GLOBAL_ID" = d."GLOBAL_ID"
--	left join (select "GLOBAL_ID", "EPA_CAUSE" from v_epa_causes where rn = 5) e on a."GLOBAL_ID" = e."GLOBAL_ID"
--	left join (select "GLOBAL_ID", "EPA_CAUSE" from v_epa_causes where rn = 6) f on a."GLOBAL_ID" = f."GLOBAL_ID";

-----------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------
update sites set "RB_CASE_NUMBER" = '01-' || substr("RB_CASE_NUMBER",1,4)
where   "RB_CASE_NUMBER" like '%00:00:00';

-----------------------------------------------------------------------------------------------------------------------

select 'null as "' || element_name || '",'
from lust_elements order by element_position;


Open - Inactive
Open - Active
Open - Verification Monitoring
Completed - Case Closed
Informational Item / Review Complete
Open - Long Term Management
Open - Assessment & Interim Remedial Action
Open - Eligible for Closure
Open - Remediation
Open - Site Assessment

select * from public.lust_element_db_mapping order by 1 desc;

insert into lust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('CA', '2023-02-01', 'LUSTStatus', 'sites', 'STATUS');

52

select * from lust_status order by 1;

select * from public.lust_element_value_mappings;

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (52, 'Open - Inactive', 'Active: stalled');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (52, 'Open - Active', 'Active: general');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (52, 'Open - Verification Monitoring', 'Active: general');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (52, 'Completed - Case Closed', 'No further action');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (52, 'Informational Item / Review Complete', 'Other');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (52, 'Open - Long Term Management', 'Active: general');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (52, 'Open - Assessment & Interim Remedial Action', 'Active: remediation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (52, 'Open - Eligible for Closure', 'Active: general');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (52, 'Open - Remediation', 'Active: remediation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (52, 'Open - Site Assessment', 'Active: site investigation');


insert into lust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('CA', '2023-02-01', 'CoordinateSource', 'sites', 'COORDINATE_SOURCE');


select * from public.coordinate_source order by 1;

select distinct "COORDINATE_SOURCE" from sites;
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (53, 'Manual Entry on Screens - GPS', 'GPS');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (53, '* Unknown', 'Unknown');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (53, '* CMT HP-L4 GPS unit', 'GPS');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (53, '* Historical Geocode - Approximate Match', 'Geocoded address');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (53, '* Digitized From APN (Acessor Parcel Maps)', 'Map interpolation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (53, '* GeoTracker web moving tool', 'Map interpolation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (53, 'Manual Entry on Screens', 'Map interpolation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (53, 'Google Geocode', 'Geocoded address');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (53, '* Historical Geocode - Street Match', 'Geocoded address');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (53, '* Historical Geocode - Zip Code Match', 'Geocoded address');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (53, '* USGS Quad map', 'Map interpolation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (53, '* Historical Map Move', 'Map interpolation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (53, '* Historical Geocode - Exact Address Match', 'Geocoded address');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (53, 'Google Map Move', 'Map interpolation');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (53, '* High Quality GPS', 'GPS');


select distinct "POTENTIAL_MEDIA_OF_CONCERN" from sites;

select d.element_name, v.state_value, v.epa_value, v.programmer_comments 
from lust_element_value_mappings v join lust_element_db_mapping d on v.element_db_mapping_id = d.id
where v.element_db_mapping_id = get_current_mapping_id('LUST', 'CA', d.element_name)
order by 1, 2, 3;

select * from lust_status order by 1;

select * from public.coordinate_source order by 1;

select distinct element_name, state_table_name , state_column_name 
from v_lust_element_mapping where state = 'CA' order by 1;

select * from lust_element_value_mappings where state = ''

select distinct "POTENTIAL_MEDIA_OF_CONCERN" from "CA_LUST".sites order by 1;
----------------------------------------------------------------------------------------------------------------------------------

insert into lust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('CA', '2023-03-28', 'MediaImpactedSoil', 'sites', 'POTENTIAL_MEDIA_OF_CONCERN')
returning id;

select distinct "POTENTIAL_MEDIA_OF_CONCERN" from "CA_LUST".sites order by 1;

select distinct 
'insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, ''' || "POTENTIAL_MEDIA_OF_CONCERN" ||  ''', ''Yes'');'
from "CA_LUST".sites where "POTENTIAL_MEDIA_OF_CONCERN" like '%Soil%' 
order by 1;  
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Contaminated Surface / Structure, Indoor Air, Soil, Soil Vapor', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Indoor Air, Other Groundwater (uses other than drinking water), Sediments, Soil, Soil Vapor', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Indoor Air, Other Groundwater (uses other than drinking water), Sediments, Soil, Soil Vapor, Surface water, Under Investigation, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Indoor Air, Other Groundwater (uses other than drinking water), Soil Vapor, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Indoor Air, Other Groundwater (uses other than drinking water), Soil, Soil Vapor', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Indoor Air, Other Groundwater (uses other than drinking water), Soil, Soil Vapor, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Indoor Air, Other Groundwater (uses other than drinking water), Soil, Soil Vapor, Surface water, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Indoor Air, Other Groundwater (uses other than drinking water), Soil, Soil Vapor, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Indoor Air, Other Groundwater (uses other than drinking water), Soil, Soil Vapor, Under Investigation, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Indoor Air, Other Groundwater (uses other than drinking water), Soil, Soil Vapor, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Indoor Air, Sediments, Soil, Soil Vapor', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Indoor Air, Soil', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Indoor Air, Soil Vapor, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Indoor Air, Soil Vapor, Under Investigation, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Indoor Air, Soil, Soil Vapor', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Indoor Air, Soil, Soil Vapor, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Indoor Air, Soil, Soil Vapor, Under Investigation, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Indoor Air, Soil, Soil Vapor, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Indoor Air, Soil, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Other Groundwater (uses other than drinking water), Soil', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Other Groundwater (uses other than drinking water), Soil Vapor', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Other Groundwater (uses other than drinking water), Soil, Soil Vapor', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Other Groundwater (uses other than drinking water), Soil, Soil Vapor, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Other Groundwater (uses other than drinking water), Soil, Soil Vapor, Surface water, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Other Groundwater (uses other than drinking water), Soil, Soil Vapor, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Other Groundwater (uses other than drinking water), Soil, Soil Vapor, Under Investigation, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Other Groundwater (uses other than drinking water), Soil, Soil Vapor, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Other Groundwater (uses other than drinking water), Soil, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Other Groundwater (uses other than drinking water), Soil, Surface water, Under Investigation, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Other Groundwater (uses other than drinking water), Soil, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Other Groundwater (uses other than drinking water), Soil, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Sediments, Soil, Soil Vapor', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Sediments, Soil, Soil Vapor, Surface water, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Sediments, Soil, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Sediments, Soil, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Sediments, Soil, Under Investigation, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Sediments, Soil, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Soil', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Soil Vapor', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Soil Vapor, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Soil Vapor, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Soil, Soil Vapor', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Soil, Soil Vapor, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Soil, Soil Vapor, Surface water, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Soil, Soil Vapor, Surface water, Under Investigation, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Soil, Soil Vapor, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Soil, Soil Vapor, Under Investigation, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Soil, Soil Vapor, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Soil, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Soil, Surface water, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Soil, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Soil, Under Investigation, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Aquifer used for drinking water supply, Soil, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Contaminated Surface / Structure, Indoor Air, Other Groundwater (uses other than drinking water), Soil Vapor', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Contaminated Surface / Structure, Indoor Air, Other Groundwater (uses other than drinking water), Soil, Soil Vapor', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Contaminated Surface / Structure, Other Groundwater (uses other than drinking water), Soil', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Contaminated Surface / Structure, Soil', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Contaminated Surface / Structure, Soil, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Indoor Air, Other Groundwater (uses other than drinking water), Sediments, Soil, Soil Vapor', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Indoor Air, Other Groundwater (uses other than drinking water), Sediments, Soil, Soil Vapor, Surface water, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Indoor Air, Other Groundwater (uses other than drinking water), Sediments, Soil, Soil Vapor, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Indoor Air, Other Groundwater (uses other than drinking water), Soil Vapor', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Indoor Air, Other Groundwater (uses other than drinking water), Soil Vapor, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Indoor Air, Other Groundwater (uses other than drinking water), Soil Vapor, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Indoor Air, Other Groundwater (uses other than drinking water), Soil, Soil Vapor', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Indoor Air, Other Groundwater (uses other than drinking water), Soil, Soil Vapor, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Indoor Air, Other Groundwater (uses other than drinking water), Soil, Soil Vapor, Surface water, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Indoor Air, Other Groundwater (uses other than drinking water), Soil, Soil Vapor, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Indoor Air, Other Groundwater (uses other than drinking water), Soil, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Indoor Air, Soil Vapor', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Indoor Air, Soil, Soil Vapor', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Indoor Air, Soil, Soil Vapor, Surface water, Under Investigation, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Indoor Air, Soil, Soil Vapor, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Indoor Air, Soil, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Other Groundwater (uses other than drinking water), Sediments, Soil', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Other Groundwater (uses other than drinking water), Sediments, Soil, Soil Vapor', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Other Groundwater (uses other than drinking water), Sediments, Soil, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Other Groundwater (uses other than drinking water), Sediments, Soil, Surface water, Under Investigation, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Other Groundwater (uses other than drinking water), Sediments, Soil, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Other Groundwater (uses other than drinking water), Soil', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Other Groundwater (uses other than drinking water), Soil Vapor', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Other Groundwater (uses other than drinking water), Soil Vapor, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Other Groundwater (uses other than drinking water), Soil, Soil Vapor', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Other Groundwater (uses other than drinking water), Soil, Soil Vapor, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Other Groundwater (uses other than drinking water), Soil, Soil Vapor, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Other Groundwater (uses other than drinking water), Soil, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Other Groundwater (uses other than drinking water), Soil, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Other Groundwater (uses other than drinking water), Soil, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Sediments, Soil', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Sediments, Soil, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Soil', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Soil Vapor', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Soil Vapor, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Soil Vapor, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Soil, Soil Vapor', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Soil, Soil Vapor, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Soil, Soil Vapor, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Soil, Soil Vapor, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Soil, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Soil, Surface water, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Soil, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Soil, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (54, 'Under Investigation, Soil', 'Yes');
----------------------------------------------------------------------------------------------------------------------------------

insert into lust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('CA', '2023-03-28', 'MediaImpactedGroundwater', 'sites', 'POTENTIAL_MEDIA_OF_CONCERN')
returning id;

select distinct "POTENTIAL_MEDIA_OF_CONCERN" from "CA_LUST".sites order by 1;

select distinct 
'insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, ''' || "POTENTIAL_MEDIA_OF_CONCERN" ||  ''', ''Yes'');'
from "CA_LUST".sites where "POTENTIAL_MEDIA_OF_CONCERN" like '%Groundwater%' 
order by 1;  

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Aquifer used for drinking water supply, Indoor Air, Other Groundwater (uses other than drinking water), Sediments, Soil, Soil Vapor', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Aquifer used for drinking water supply, Indoor Air, Other Groundwater (uses other than drinking water), Sediments, Soil, Soil Vapor, Surface water, Under Investigation, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Aquifer used for drinking water supply, Indoor Air, Other Groundwater (uses other than drinking water), Soil Vapor, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Aquifer used for drinking water supply, Indoor Air, Other Groundwater (uses other than drinking water), Soil, Soil Vapor', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Aquifer used for drinking water supply, Indoor Air, Other Groundwater (uses other than drinking water), Soil, Soil Vapor, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Aquifer used for drinking water supply, Indoor Air, Other Groundwater (uses other than drinking water), Soil, Soil Vapor, Surface water, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Aquifer used for drinking water supply, Indoor Air, Other Groundwater (uses other than drinking water), Soil, Soil Vapor, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Aquifer used for drinking water supply, Indoor Air, Other Groundwater (uses other than drinking water), Soil, Soil Vapor, Under Investigation, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Aquifer used for drinking water supply, Indoor Air, Other Groundwater (uses other than drinking water), Soil, Soil Vapor, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Aquifer used for drinking water supply, Indoor Air, Other Groundwater (uses other than drinking water), Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Aquifer used for drinking water supply, Other Groundwater (uses other than drinking water)', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Aquifer used for drinking water supply, Other Groundwater (uses other than drinking water), Soil', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Aquifer used for drinking water supply, Other Groundwater (uses other than drinking water), Soil Vapor', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Aquifer used for drinking water supply, Other Groundwater (uses other than drinking water), Soil, Soil Vapor', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Aquifer used for drinking water supply, Other Groundwater (uses other than drinking water), Soil, Soil Vapor, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Aquifer used for drinking water supply, Other Groundwater (uses other than drinking water), Soil, Soil Vapor, Surface water, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Aquifer used for drinking water supply, Other Groundwater (uses other than drinking water), Soil, Soil Vapor, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Aquifer used for drinking water supply, Other Groundwater (uses other than drinking water), Soil, Soil Vapor, Under Investigation, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Aquifer used for drinking water supply, Other Groundwater (uses other than drinking water), Soil, Soil Vapor, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Aquifer used for drinking water supply, Other Groundwater (uses other than drinking water), Soil, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Aquifer used for drinking water supply, Other Groundwater (uses other than drinking water), Soil, Surface water, Under Investigation, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Aquifer used for drinking water supply, Other Groundwater (uses other than drinking water), Soil, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Aquifer used for drinking water supply, Other Groundwater (uses other than drinking water), Soil, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Aquifer used for drinking water supply, Other Groundwater (uses other than drinking water), Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Aquifer used for drinking water supply, Other Groundwater (uses other than drinking water), Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Aquifer used for drinking water supply, Well used for drinking water supply, Other Groundwater (uses other than drinking water)', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Contaminated Surface / Structure, Indoor Air, Other Groundwater (uses other than drinking water), Soil Vapor', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Contaminated Surface / Structure, Indoor Air, Other Groundwater (uses other than drinking water), Soil, Soil Vapor', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Contaminated Surface / Structure, Other Groundwater (uses other than drinking water), Soil', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Indoor Air, Other Groundwater (uses other than drinking water)', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Indoor Air, Other Groundwater (uses other than drinking water), Sediments, Soil, Soil Vapor', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Indoor Air, Other Groundwater (uses other than drinking water), Sediments, Soil, Soil Vapor, Surface water, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Indoor Air, Other Groundwater (uses other than drinking water), Sediments, Soil, Soil Vapor, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Indoor Air, Other Groundwater (uses other than drinking water), Soil Vapor', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Indoor Air, Other Groundwater (uses other than drinking water), Soil Vapor, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Indoor Air, Other Groundwater (uses other than drinking water), Soil Vapor, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Indoor Air, Other Groundwater (uses other than drinking water), Soil, Soil Vapor', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Indoor Air, Other Groundwater (uses other than drinking water), Soil, Soil Vapor, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Indoor Air, Other Groundwater (uses other than drinking water), Soil, Soil Vapor, Surface water, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Indoor Air, Other Groundwater (uses other than drinking water), Soil, Soil Vapor, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Indoor Air, Other Groundwater (uses other than drinking water), Soil, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Other Groundwater (uses other than drinking water)', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Other Groundwater (uses other than drinking water), Sediments, Soil', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Other Groundwater (uses other than drinking water), Sediments, Soil, Soil Vapor', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Other Groundwater (uses other than drinking water), Sediments, Soil, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Other Groundwater (uses other than drinking water), Sediments, Soil, Surface water, Under Investigation, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Other Groundwater (uses other than drinking water), Sediments, Soil, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Other Groundwater (uses other than drinking water), Sediments, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Other Groundwater (uses other than drinking water), Soil', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Other Groundwater (uses other than drinking water), Soil Vapor', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Other Groundwater (uses other than drinking water), Soil Vapor, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Other Groundwater (uses other than drinking water), Soil, Soil Vapor', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Other Groundwater (uses other than drinking water), Soil, Soil Vapor, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Other Groundwater (uses other than drinking water), Soil, Soil Vapor, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Other Groundwater (uses other than drinking water), Soil, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Other Groundwater (uses other than drinking water), Soil, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Other Groundwater (uses other than drinking water), Soil, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Other Groundwater (uses other than drinking water), Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Other Groundwater (uses other than drinking water), Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (55, 'Other Groundwater (uses other than drinking water), Well used for drinking water supply', 'Yes');
----------------------------------------------------------------------------------------------------------------------------------

insert into lust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('CA', '2023-03-28', 'MediaImpactedSurfaceWater', 'sites', 'POTENTIAL_MEDIA_OF_CONCERN')
returning id;

select distinct "POTENTIAL_MEDIA_OF_CONCERN" from "CA_LUST".sites order by 1;

select distinct 
'insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (56, ''' || "POTENTIAL_MEDIA_OF_CONCERN" ||  ''', ''Yes'');'
from "CA_LUST".sites where "POTENTIAL_MEDIA_OF_CONCERN" like '%Surface water%' 
order by 1;  

insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (56, 'Aquifer used for drinking water supply, Indoor Air, Other Groundwater (uses other than drinking water), Sediments, Soil, Soil Vapor, Surface water, Under Investigation, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (56, 'Aquifer used for drinking water supply, Indoor Air, Other Groundwater (uses other than drinking water), Soil, Soil Vapor, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (56, 'Aquifer used for drinking water supply, Indoor Air, Other Groundwater (uses other than drinking water), Soil, Soil Vapor, Surface water, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (56, 'Aquifer used for drinking water supply, Indoor Air, Soil, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (56, 'Aquifer used for drinking water supply, Other Groundwater (uses other than drinking water), Soil, Soil Vapor, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (56, 'Aquifer used for drinking water supply, Other Groundwater (uses other than drinking water), Soil, Soil Vapor, Surface water, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (56, 'Aquifer used for drinking water supply, Other Groundwater (uses other than drinking water), Soil, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (56, 'Aquifer used for drinking water supply, Other Groundwater (uses other than drinking water), Soil, Surface water, Under Investigation, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (56, 'Aquifer used for drinking water supply, Other Groundwater (uses other than drinking water), Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (56, 'Aquifer used for drinking water supply, Sediments, Soil, Soil Vapor, Surface water, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (56, 'Aquifer used for drinking water supply, Sediments, Soil, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (56, 'Aquifer used for drinking water supply, Soil, Soil Vapor, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (56, 'Aquifer used for drinking water supply, Soil, Soil Vapor, Surface water, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (56, 'Aquifer used for drinking water supply, Soil, Soil Vapor, Surface water, Under Investigation, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (56, 'Aquifer used for drinking water supply, Soil, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (56, 'Aquifer used for drinking water supply, Soil, Surface water, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (56, 'Aquifer used for drinking water supply, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (56, 'Aquifer used for drinking water supply, Surface water, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (56, 'Indoor Air, Other Groundwater (uses other than drinking water), Sediments, Soil, Soil Vapor, Surface water, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (56, 'Indoor Air, Other Groundwater (uses other than drinking water), Soil Vapor, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (56, 'Indoor Air, Other Groundwater (uses other than drinking water), Soil, Soil Vapor, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (56, 'Indoor Air, Other Groundwater (uses other than drinking water), Soil, Soil Vapor, Surface water, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (56, 'Indoor Air, Soil, Soil Vapor, Surface water, Under Investigation, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (56, 'Other Groundwater (uses other than drinking water), Sediments, Soil, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (56, 'Other Groundwater (uses other than drinking water), Sediments, Soil, Surface water, Under Investigation, Well used for drinking water supply', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (56, 'Other Groundwater (uses other than drinking water), Sediments, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (56, 'Other Groundwater (uses other than drinking water), Soil, Soil Vapor, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (56, 'Other Groundwater (uses other than drinking water), Soil, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (56, 'Other Groundwater (uses other than drinking water), Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (56, 'Sediments, Soil, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (56, 'Soil, Soil Vapor, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (56, 'Soil, Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (56, 'Soil, Surface water, Under Investigation', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (56, 'Surface water', 'Yes');
insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (56, 'Well used for drinking water supply, Surface water', 'Yes');


	case when "POTENTIAL_MEDIA_OF_CONCERN" like '%Soil%' then 'Yes' end as "MediaImpactedSoil",
	case when "POTENTIAL_MEDIA_OF_CONCERN" like '%Groundwater%' then 'Yes' end as "MediaImpactedGroundwater",
	case when "POTENTIAL_MEDIA_OF_CONCERN" like '%Surface water%' then 'Yes' end as "MediaImpactedSurfaceWater",

----------------------------------------------------------------------------------------------------------------------------------

--corrective action mapping approved by Alex 4/12/2023
	
Capping					 													= Capping
Dual Phase Extraction 														= Duel/Multi-phase extraction
Ex Situ Biological Treatment 												= Excavation and hauling or treatment
Ex Situ Physical/Chemical Treatment (other than P&T, SVE, or Excavation)  	= Excavation and hauling or treatment
Ex Situ Thermal Treatment													= Excavation and hauling or treatment
Excavation						 											= Excavation and hauling or treatment
Free Product Removal 														= Excavation and hauling or treatment
In Situ Biological Treatment      											= Natural source zone depletion
In Situ Physical/Chemical Treatment (other than SVE)						= In-situ groundwater remediation
In Situ Thermal Treatment													= In Situ Thermal Treatment
Monitored Natural Attenuation     											= Monitored natural attenuation
Other (Use Description Field)												= Other
Permeable Reactive Barrier													= Sub sealing/sub slab barrier
Pump & Treat (P&T) Groundwater 												= Pump and treat
Soil Vapor Extraction (SVE) 												= Soil vapor extraction (SVE)
	


insert into lust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('CA', '2023-03-28', 'MediaImpactedSurfaceWater', 'sites', 'POTENTIAL_MEDIA_OF_CONCERN')
returning id;

select distinct "POTENTIAL_MEDIA_OF_CONCERN" from "CA_LUST".sites order by 1;

select distinct 
'insert into lust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (56, ''' || "POTENTIAL_MEDIA_OF_CONCERN" ||  ''', ''Yes'');'
from "CA_LUST".sites where "POTENTIAL_MEDIA_OF_CONCERN" like '%Surface water%' 
order by 1;  



select distinct "ACTION_TYPE" from "CA_LUST".regulatory_activities

select distinct "ACTION" from "CA_LUST".regulatory_activities where "ACTION_TYPE" = 'REMEDIATION' order by 1;

select * from "CA_LUST".regulatory_activities where "ACTION_TYPE" = 'REMEDIATION'

select "CA_LUST"


----------------------------------------------------------------------------------------------------------------------------------------------	
select * from v_lust_element_mapping where state = 'CA' and element_name like '%Cause%';

update lust_element_value_mappings set epa_value = 'Other' where id = 81;

select * from v_lust_element_mapping where state = 'CA' and element_name like '%Remedi%' order by state_value;

select * from v_lust_element_mapping where state = 'CA' order by element_name, state_value;

----------------------------------------------------------------------------------------------------------------------------------------------

create view "CA_LUST".v_lust as 
select 
	s."GLOBAL_ID" as "FacilityID",
	null as "TankIDAssociatedwithRelease",
	s."RB_CASE_NUMBER" as "LUSTID",
	null as "FederallyReportableRelease",
	s."BUSINESS_NAME" as "SiteName",
	s."STREET_NUMBER" || ' ' || s."STREET_NAME" as "SiteAddress",
	null as "SiteAddress2",
	s."CITY" as "SiteCity",
	s."ZIP" as "Zipcode",
	s."COUNTY" as "County",
	s."STATE" as "State",
	s."EPA_REGION" as "EPARegion",
	null as "FacilityType",
	null as "TribalSite",
	null as "Tribe",
	s."LATITUDE" as "Latitude",
	s."LONGITUDE" as "Longitude",
   	coord.epa_value as "CoordinateSource",
	status.epa_value as "LUSTStatus",
	"LEAK_REPORTED_DATE" as "ReportedDate",
	"NO_FURTHER_ACTION_DATE" as "NFADate",
	mis.epa_value as "MediaImpactedSoil",
	mig.epa_value as "MediaImpactedGroundwater",
	misw.epa_value as "MediaImpactedSurfaceWater",
b.substance1 as "SubstanceReleased1", --column is "potential contaminants of concern", not "substance released"; no order assigned to this comma-separated field; non-related contaminants included as well
	s."QUANTITY_RELEASED_GALLONS" as "QuantityReleased1", --unable to determine quantity when multiple "potential contaminants of concern"
	case when s."QUANTITY_RELEASED_GALLONS" is not null then 'Gallons' end as "Unit1",
b.substance2 as "SubstanceReleased2",
	null as "QuantityReleased2",
	null as "Unit2",
b.substance3 as "SubstanceReleased3",
	null as "QuantityReleased3",
	null as "Unit3",
b.substance4 as "SubstanceReleased4",
	null as "QuantityReleased4",
	null as "Unit4",
b.substance5 as "SubstanceReleased5",
	null as "QuantityReleased5",
	null as "Unit5",
src.source1 as "SourceOfRelease1",
c.cause1 as "CauseOfRelease1",
src.source2 as "SourceOfRelease2",
c.cause2 as "CauseOfRelease2",
src.source3 as "SourceOfRelease3",
c.cause3 as "CauseOfRelease3",
src.source4 as "SourceOfRelease4",
c.cause4 as "CauseOfRelease4",
src.source5 as "SourceOfRelease5",
c.cause5 as "CauseOfRelease5",
	null as "HowReleaseDetected",
	null as "RemediationStrategy1",
	null as "RemediationStrategy1StartDate",
	null as "RemediationStrategy2",
	null as "RemediationStrategy2StartDate",
	null as "RemediationStrategy3",
	null as "RemediationStrategy3StartDate",
	null as "ClosedWithContamination",
	null as "NoFurtherActionLetterURL",
	null as "MilitaryDoDSite"
from "CA_LUST".sites s 
	left join (select state_value, epa_value from v_lust_element_mapping where state = 'CA' and element_name =  'LUSTStatus') status on s."STATUS" = status.state_value
	left join (select state_value, epa_value from v_lust_element_mapping where state = 'CA' and element_name =  'CoordinateSource') coord on s."COORDINATE_SOURCE" = coord.state_value
	left join (select state_value, epa_value from v_lust_element_mapping where state = 'CA' and element_name =  'MediaImpactedSoil') mis on s."POTENTIAL_MEDIA_OF_CONCERN" = mis.state_value
	left join (select state_value, epa_value from v_lust_element_mapping where state = 'CA' and element_name =  'MediaImpactedGroundwater') mig on s."POTENTIAL_MEDIA_OF_CONCERN" = mig.state_value
	left join (select state_value, epa_value from v_lust_element_mapping where state = 'CA' and element_name =  'MediaImpactedSurfaceWater') misw on s."POTENTIAL_MEDIA_OF_CONCERN" = misw.state_value
	left join "CA_LUST".v_epa_substances_cross b on s."GLOBAL_ID" = b."GLOBAL_ID"
	left join "CA_LUST".v_epa_sources_cross src on s."GLOBAL_ID" = src."GLOBAL_ID"
	left join "CA_LUST".v_epa_causes_cross c on s."GLOBAL_ID" = c."GLOBAL_ID"
where "CASE_TYPE" in ('LUST Cleanup Site','Military UST Site')
order by s."GLOBAL_ID", "RB_CASE_NUMBER";


select distinct element_db_mapping_id, element_name, state_table_name, state_column_name from v_lust_element_mapping where state = 'CA' order by 1;

-----------------------------------------------------------------------------------------------------------------------




--old
select s."GLOBAL_ID" as "FacilityID",
	   s."RB_CASE_NUMBER" as "LUSTID",
	   s."BUSINESS_NAME" as "SiteName",
	   s."STREET_NUMBER" || ' ' || s."STREET_NAME" as "SiteAddress",
	   s."CITY" as "SiteCity",
	   s."ZIP" as "Zipcode",
	   s."COUNTY" as "County",
	   s."STATE" as "State",
	   s."EPA_REGION" as "EPARegion",
	   s."LATITUDE" as "Latitude",
	   s."LONGITUDE" as "Longitude",
	   case when "COORDINATE_SOURCE" like '%Geocode%' then 'Geocode'
	        when "COORDINATE_SOURCE" like '%GPS%' then 'GPS'
			when lower("COORDINATE_SOURCE") like '% map%' or "COORDINATE_SOURCE" like '%GeoTracker%' or "COORDINATE_SOURCE" = 'Manual Entry on Screens' then 'Map Interpolation'
			when "COORDINATE_SOURCE" like '%Unknown%' then 'Unknown'
			when "COORDINATE_SOURCE" is not null then 'Other' end as "CoordinateSource",
	  case when "STATUS" like '%Open%' then 'Active'
	       when "STATUS" = 'Informational Item' then 'Other'
		   when "STATUS" like '%Closed%' then 'No Further Action' end as "LUSTStatus",
	  "LEAK_REPORTED_DATE" as "ReportedDate",
	  "NO_FURTHER_ACTION_DATE" as "NFADate",
	  case when "POTENTIAL_MEDIA_OF_CONCERN" like '%Soil%' then 'Yes' end as "MediaImpactedSoil",
	  case when "POTENTIAL_MEDIA_OF_CONCERN" like '%Groundwater%' then 'Yes' end as "MediaImpactedGroundwater",
	  case when "POTENTIAL_MEDIA_OF_CONCERN" like '%Surface water%' then 'Yes' end as "MediaImpactedSurfaceWater",
	  b.substance1 as "SubstanceReleased1", --column is "potential contaminants of concern", not "substance released"; no order assigned to this comma-separated field; non-related contaminants included as well
	  s."QUANTITY_RELEASED_GALLONS" as "QuantityReleased1", --unable to determine quantity when multiple "potential contaminants of concern"
	  case when s."QUANTITY_RELEASED_GALLONS" is not null then 'Gallons' end as "Unit1",
	  b.substance2 as "SubstanceReleased2", --column is "potential contaminants of concern", not "substance released"; no order assigned to this comma-separated field; non-related contaminants included as well
	  b.substance3 as "SubstanceReleased3", --column is "potential contaminants of concern", not "substance released"; no order assigned to this comma-separated field; non-related contaminants included as well
	  b.substance4 as "SubstanceReleased4", --column is "potential contaminants of concern", not "substance released"; no order assigned to this comma-separated field; non-related contaminants included as well
	  b.substance5 as "SubstanceReleased5", --column is "potential contaminants of concern", not "substance released"; no order assigned to this comma-separated field; non-related contaminants included as well
	  src.source1 as "SourceOfRelease1",
	  c.cause1 as "CauseOfRelease1",
	  src.source2 as "SourceOfRelease2",
	  c.cause2 as "CauseOfRelease2",
	  src.source3 as "SourceOfRelease3",
	  c.cause3 as "CauseOfRelease3",
	  src.source4 as "SourceOfRelease4",
	  c.cause4 as "CauseOfRelease4",
	  src.source5 as "SourceOfRelease5",
	  c.cause5 as "CauseOfRelease5",
	  src.source6 as "SourceOfRelease6",
	  c.cause6 as "CauseOfRelease6"
from sites s left join v_epa_substances_cross b on s."GLOBAL_ID" = b."GLOBAL_ID"
	left join v_epa_sources_cross src on s."GLOBAL_ID" = src."GLOBAL_ID"
	left join v_epa_causes_cross c on s."GLOBAL_ID" = c."GLOBAL_ID"
order by 1, 2;



