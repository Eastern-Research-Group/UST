
7085 WINCHESTER RD & BUDDY WILIAMSON, NEW MARKET, AL, 35761, US

create or replace function parse_address(address_string varchar, address_part varchar) returns varchar as $$
	declare 
		r varchar;
	begin
		case when address_part = 'street' then 
			r = charindex(',', address_string, (charindex(',', address_string, 1))+1)
		end case;
		return r;
	end;
$$ LANGUAGE SQL;
	
select parse_address('7085 WINCHESTER RD & BUDDY WILIAMSON, NEW MARKET, AL, 35761, US', 'street')


select split_part('7085 WINCHESTER RD & BUDDY WILIAMSON, NEW MARKET, AL, 35761, US', ', ',4) 


7085 WINCHESTER RD & BUDDY WILIAMSON
NEW MARKET
AL
35761

charindex('_', [TEXT], (charindex('_', [TEXT], 1))+1)	


select distinct s."Address", split_part(s."Address", ', ',3) from "USTSites" s 
where split_part(s."Address", ', ',3) <> 'AL'

select * from "USTSites" u  where "Address" = '3300 CRESTWOOD BLVD, SUITE 104, IRONDALE, AL, 35210, US'

select distinct "Site Types" from "USTSites" u 

3300 CRESTWOOD BLVD, SUITE 104, IRONDALE, AL, 35210, US

--zip
select "Address",
		split_part(s."Address", ', ',1) as "FacilityAddress1",
		case when (char_length("Address")-char_length(replace("Address",', ','')))/char_length(', ' ) = 5 
            then split_part(s."Address", ', ',2) end as "FacilityAddress2",
		case when (char_length("Address")-char_length(replace("Address",', ','')))/char_length(', ' ) = 4 
            then split_part(s."Address", ', ',3) else split_part(s."Address", ', ',4) end as "FacilityState",
		case when (char_length("Address")-char_length(replace("Address",', ','')))/char_length(', ' ) = 4 
            then split_part(s."Address", ', ',4) else split_part(s."Address", ', ',5) end as "FacilityZipCode"
from "USTSites" s
 where "Address" = '3300 CRESTWOOD BLVD, SUITE 104, IRONDALE, AL, 35210, US'

(CHAR_LENGTH(name) - CHAR_LENGTH(REPLACE(name, 'o', ''))) 
    / CHAR_LENGTH('o');
   





select distinct "Substance Stored" 
from "UTanks" u  order by 1;
Hazardous Substance
Petroleum

select distinct "Petroleum Product" 
from "UTanks" u  order by 1;


select distinct "Tank Usage"  from "UTanks" u order by 1;

select * from "UTanks" t;

Interstitial Monitoring



create table substance_mapping(al_substance varchar(400), epa_substance varchar(400));


select t."Petroleum Product", count(*) from "UTanks" t where  t."Petroleum Product" not in 
	(select al_substance from substance_mapping sm)
group by t."Petroleum Product";

delete from substance_mapping;

insert into substance_mapping values ('Other, DEF - 	Diesel Exhaust Fluid','Diesel exhaust fluid (DEF, not federally regulated)');
insert into substance_mapping values ('100% biodiesel (Not Regulated)','100% biodiesel (not federally regulated)');
insert into substance_mapping values ('Aviation fuel (JP-4; etc.)','Unknown aviation gas or jet fuel');
insert into substance_mapping values ('Diesel containing greater than 20% biodiesel','Diesel blend containing greater than 20% and less than 99% biodiesel');
insert into substance_mapping values ('Diesel containing less than or equal to 20% biodiesel','Diesel blends containing greater than 5% and up to 20% or less biodiesel');
insert into substance_mapping values ('E85','E-85/Flex Fuel (E51-E83)');
insert into substance_mapping values ('Ethanol free gasoline','Gasoline (non-ethanol)');
insert into substance_mapping values ('Gasoline containing greater than 10% ethanol','Ethanol blend gasoline (e-unknown)');
insert into substance_mapping values ('Kerosene','Kerosene');
insert into substance_mapping values ('Mid-grade gasoline','Ethanol blend gasoline (e-unknown)');
insert into substance_mapping values ('Off road diesel','Off-road diesel/dyed diesel');
insert into substance_mapping values ('On road diesel','Diesel fuel (b-unknown)');
insert into substance_mapping values ('Other, #4FUELOIL','Heating oil/fuel oil 4');
insert into substance_mapping values ('Other, #5FUELOIL','Heating oil/fuel oil 5');
insert into substance_mapping values ('Other, #6CRUDEOIL','Petroleum product');
insert into substance_mapping values ('Other, #6FUELOIL','Heating/fuel oil # unknown');
insert into substance_mapping values ('Other, .','Other');
insert into substance_mapping values ('Other, \','Other');
insert into substance_mapping values ('Other, 100 % UNL','Gasoline (unknown type)');
insert into substance_mapping values ('Other, 100%','Other');
insert into substance_mapping values ('Other, 100% GAS','Gasoline (unknown type)');
insert into substance_mapping values ('Other, 100% UN','Gasoline (unknown type)');
insert into substance_mapping values ('Other, 100%OFFRD','Off-road diesel/dyed diesel');
insert into substance_mapping values ('Other, 10W30','Lube/motor oil (new)');
insert into substance_mapping values ('Other, 10W40','Lube/motor oil (new)');
insert into substance_mapping values ('Other, 30 W','Lube/motor oil (new)');
insert into substance_mapping values ('Other, 30 WT OIL','Lube/motor oil (new)');
insert into substance_mapping values ('Other, 523 PAINT','Petroleum product');
insert into substance_mapping values ('Other, 5W40 OIL','Lube/motor oil (new)');
insert into substance_mapping values ('Other, 650 PAINT','Petroleum product');
insert into substance_mapping values ('Other, 89 (BOAT)','Marine fuel');
insert into substance_mapping values ('Other, 90W GEAR','Lube/motor oil (new)');
insert into substance_mapping values ('Other, A','Other');
insert into substance_mapping values ('Other, A/F','Other');
insert into substance_mapping values ('Other, ACETONE','Solvent');
insert into substance_mapping values ('Other, ACRYLONITR','Other');
insert into substance_mapping values ('Other, ACTUSL OIL','Petroleum product');
insert into substance_mapping values ('Other, ADDITIVE','Other');
insert into substance_mapping values ('Other, AIRALON','Other');
insert into substance_mapping values ('Other, ALCOHOL','Other');
insert into substance_mapping values ('Other, ALIPHAHYDR','Hazardous substance');
insert into substance_mapping values ('Other, ALYD RESIN','Other');
insert into substance_mapping values ('Other, ANTIFREEZE','Antifreeze');
insert into substance_mapping values ('Other, AROM OIL','Petroleum product');
insert into substance_mapping values ('Other, ASPHALT','Petroleum product');
insert into substance_mapping values ('Other, AUTODIESEL','Diesel fuel (b-unknown)');
insert into substance_mapping values ('Other, AVGAS','Aviation gasoline');
insert into substance_mapping values ('Other, B-10','Diesel blends containing greater than 5% and up to 20% or less biodiesel');
insert into substance_mapping values ('Other, B-99','Diesel blend containing 99% to less than 100% biodiesel');
insert into substance_mapping values ('Other, B-99.9','Diesel blend containing 99% to less than 100% biodiesel');
insert into substance_mapping values ('Other, B100','100% biodiesel (not federally regulated)');
insert into substance_mapping values ('Other, B99','Diesel blend containing 99% to less than 100% biodiesel');
insert into substance_mapping values ('Other, BIODIESEL','Diesel fuel (b-unknown)');
insert into substance_mapping values ('Other, BITUMINOUS','Other');
insert into substance_mapping values ('Other, BUNKER"C"','Marine fuel');
insert into substance_mapping values ('Other, CONV','Gasoline (unknown type)');
insert into substance_mapping values ('Other, CONV UNL','Gasoline (unknown type)');
insert into substance_mapping values ('Other, CONV UNLEADED','Gasoline (unknown type)');
insert into substance_mapping values ('Other, D.E.F.','Diesel exhaust fluid (DEF, not federally regulated)');
insert into substance_mapping values ('Other, DEF','Diesel exhaust fluid (DEF, not federally regulated)');
insert into substance_mapping values ('Other, DEF - Diesel Exhaust Fluid','Diesel exhaust fluid (DEF, not federally regulated)');
insert into substance_mapping values ('Other, DETERGENT','Other');
insert into substance_mapping values ('Other, DRAIN OIL','Used oil/waste oil');
insert into substance_mapping values ('Other, DRAIN TANK','Other');
insert into substance_mapping values ('Other, DSL & GAS','Petroleum product');
insert into substance_mapping values ('Other, E-15','Gasoline E-15 (E-11-E15)');
insert into substance_mapping values ('Other, E10','Gasoline E-10 (E1-E10)');
insert into substance_mapping values ('Other, E85','E-85/Flex Fuel (E51-E83)');
insert into substance_mapping values ('Other, E89 MARINE','Marine fuel');
insert into substance_mapping values ('Other, EFREE','Other');
insert into substance_mapping values ('Other, EMPTY','Other');
insert into substance_mapping values ('Other, ENGINE OIL','Lube/motor oil (new)');
insert into substance_mapping values ('Other, ETH FREE','Gasoline (non-ethanol)');
insert into substance_mapping values ('Other, ETHAN 100%','Petroleum product');
insert into substance_mapping values ('Other, ETHANOL','Petroleum product');
insert into substance_mapping values ('Other, ETHANOL 85','E-85/Flex Fuel (E51-E83)');
insert into substance_mapping values ('Other, ETHANOL FR','Ethanol blend gasoline (e-unknown)');
insert into substance_mapping values ('Other, EXEMPTED','Other');
insert into substance_mapping values ('Other, FILLEDWATR','Other');
insert into substance_mapping values ('Other, FINISHLUBE','Used oil/waste oil');
insert into substance_mapping values ('Other, FLRWASHWAT','Other');
insert into substance_mapping values ('Other, FLUID','Other');
insert into substance_mapping values ('Other, FLUSH OIL','Used oil/waste oil');
insert into substance_mapping values ('Other, FUEL','Petroleum product');
insert into substance_mapping values ('Other, FUEL OIL','Petroleum product');
insert into substance_mapping values ('Other, GAS','Gasoline (unknown type)');
insert into substance_mapping values ('Other, GAS ADDITI','Petroleum product');
insert into substance_mapping values ('Other, GAS/DSLMIX','Petroleum product');
insert into substance_mapping values ('Other, GASOLINE','Gasoline (unknown type)');
insert into substance_mapping values ('Other, GEAR LUBE','Lube/motor oil (new)');
insert into substance_mapping values ('Other, GEAR OIL','Lube/motor oil (new)');
insert into substance_mapping values ('Other, HEA-2','Heating oil/fuel oil 2');
insert into substance_mapping values ('Other, HEATING','Heating/fuel oil # unknown');
insert into substance_mapping values ('Other, HEATINGOIL','Heating/fuel oil # unknown');
insert into substance_mapping values ('Other, HEPTANE','Petroleum product');
insert into substance_mapping values ('Other, HEXANE','Petroleum product');
insert into substance_mapping values ('Other, HOLDING','Other');
insert into substance_mapping values ('Other, HYD OIL','Lube/motor oil (new)');
insert into substance_mapping values ('Other, HYDR FLUID','Lube/motor oil (new)');
insert into substance_mapping values ('Other, HYDRAL OIL','Lube/motor oil (new)');
insert into substance_mapping values ('Other, HYDRAULIC','Lube/motor oil (new)');
insert into substance_mapping values ('Other, HYDRLC OIL','Lube/motor oil (new)');
insert into substance_mapping values ('Other, HYDROL OIL','Lube/motor oil (new)');
insert into substance_mapping values ('Other, HYDROLIC','Lube/motor oil (new)');
insert into substance_mapping values ('Other, ISOBUTYL','Other');
insert into substance_mapping values ('Other, ISOPROPYL','Other');
insert into substance_mapping values ('Other, JET-A','Jet fuel A');
insert into substance_mapping values ('Other, JET A','Jet fuel A');
insert into substance_mapping values ('Other, JET FUEL','Unknown aviation gas or jet fuel');
insert into substance_mapping values ('Other, K1','Heating/fuel oil 1');
insert into substance_mapping values ('Other, KERMAC','Petroleum product');
insert into substance_mapping values ('Other, LIGHT OILS','Petroleum product');
insert into substance_mapping values ('Other, LQDCAUSTIC','Solvent');
insert into substance_mapping values ('Other, LUBE OIL','Lube/motor oil (new)');
insert into substance_mapping values ('Other, LUBRIZOL','Other');
insert into substance_mapping values ('Other, MARINE','Marine fuel');
insert into substance_mapping values ('Other, MARINE FUE','Marine fuel');
insert into substance_mapping values ('Other, MED RESIN','Other');
insert into substance_mapping values ('Other, METHANOL','Petroleum product');
insert into substance_mapping values ('Other, MINERAL','Petroleum product');
insert into substance_mapping values ('Other, MISREGIST','Other');
insert into substance_mapping values ('Other, MIX','Other');
insert into substance_mapping values ('Other, MNRL OIL','Petroleum product');
insert into substance_mapping values ('Other, MNRLSPIRIT','Petroleum product');
insert into substance_mapping values ('Other, MOTOR OIL','Lube/motor oil (new)');
insert into substance_mapping values ('Other, MSPRIT/GAS','Petroleum product');
insert into substance_mapping values ('Other, N/A','Unknown');
insert into substance_mapping values ('Other, NaOH','Hazardous substance');
insert into substance_mapping values ('Other, NAPHA','Petroleum product');
insert into substance_mapping values ('Other, NAPHSPIRIT','Other');
insert into substance_mapping values ('Other, NEEDS PREV','Other');
insert into substance_mapping values ('Other, NEW OIL','Lube/motor oil (new)');
insert into substance_mapping values ('Other, NO ETH GAS','Gasoline (non-ethanol)');
insert into substance_mapping values ('Other, NO ETH UNL','Gasoline (non-ethanol)');
insert into substance_mapping values ('Other, NO ETHANOL','Gasoline (non-ethanol)');
insert into substance_mapping values ('Other, NOETHNOL','Gasoline (non-ethanol)');
insert into substance_mapping values ('Other, NOETHYNOL','Gasoline (non-ethanol)');
insert into substance_mapping values ('Other, NON-ETH UN','Gasoline (non-ethanol)');
insert into substance_mapping values ('Other, NON-ETHAN','Gasoline (non-ethanol)');
insert into substance_mapping values ('Other, NON-ETHANL','Gasoline (non-ethanol)');
insert into substance_mapping values ('Other, NON-ETHANO','Gasoline (non-ethanol)');
insert into substance_mapping values ('Other, NON E10','Gasoline (non-ethanol)');
insert into substance_mapping values ('Other, NON ETH 87','Gasoline (non-ethanol)');
insert into substance_mapping values ('Other, NON ETHANO','Gasoline (non-ethanol)');
insert into substance_mapping values ('Other, non ethanol','Gasoline (non-ethanol)');
insert into substance_mapping values ('Other, NON PCBOIL','Lube/motor oil (new)');
insert into substance_mapping values ('Other, NONE','Other');
insert into substance_mapping values ('Other, NONETHANOL','Gasoline (non-ethanol)');
insert into substance_mapping values ('Other, NONPCBDIEL','Diesel fuel (b-unknown)');
insert into substance_mapping values ('Other, NOT USED','Other');
insert into substance_mapping values ('Other, OFF-RD DIE','Off-road diesel/dyed diesel');
insert into substance_mapping values ('Other, OFF-RD DSL','Off-road diesel/dyed diesel');
insert into substance_mapping values ('Other, OFF-ROAD','Off-road diesel/dyed diesel');
insert into substance_mapping values ('Other, OFF-ROAD D','Off-road diesel/dyed diesel');
insert into substance_mapping values ('Other, OFF RD DSL','Off-road diesel/dyed diesel');
insert into substance_mapping values ('Other, OFF ROAD','Off-road diesel/dyed diesel');
insert into substance_mapping values ('Other, OFF/EFREE','Off-road diesel/dyed diesel');
insert into substance_mapping values ('Other, OFFROAD','Off-road diesel/dyed diesel');
insert into substance_mapping values ('Other, OIL C/ H2O','Petroleum product');
insert into substance_mapping values ('Other, OIL/H20 SE','Petroleum product');
insert into substance_mapping values ('Other, OTHER','Other');
insert into substance_mapping values ('Other, PANEL OIL','Lube/motor oil (new)');
insert into substance_mapping values ('Other, PCP','Other');
insert into substance_mapping values ('Other, PE1','Other');
insert into substance_mapping values ('Other, PE2','Other');
insert into substance_mapping values ('Other, PET DISTIL','Petroleum product');
insert into substance_mapping values ('Other, PET NAPTHA','Petroleum product');
insert into substance_mapping values ('Other, PETRO SOLV','Solvent');
insert into substance_mapping values ('Other, PETROL','Petroleum product');
insert into substance_mapping values ('Other, PHOSPHORUS','Other');
insert into substance_mapping values ('Other, PROCESS','Other');
insert into substance_mapping values ('Other, PROPYLENE','Petroleum product');
insert into substance_mapping values ('Other, RACING GAS','Racing fuel/leaded gasoline');
insert into substance_mapping values ('Other, RACINGFUEL','Racing fuel/leaded gasoline');
insert into substance_mapping values ('Other, RDA-S2','Hazardous substance');
insert into substance_mapping values ('Other, REC 90','Gasoline (non-ethanol)');
insert into substance_mapping values ('Other, RUB SOLVNT','Solvent');
insert into substance_mapping values ('Other, S','Other');
insert into substance_mapping values ('Other, S-150','Lube/motor oil (new)');
insert into substance_mapping values ('Other, SAE 10 OIL','Lube/motor oil (new)');
insert into substance_mapping values ('Other, SAE 30 OIL','Lube/motor oil (new)');
insert into substance_mapping values ('Other, SAE 90 OIL','Lube/motor oil (new)');
insert into substance_mapping values ('Other, SAND','Non-Federally Regulated Substance (general)');
insert into substance_mapping values ('Other, SHORT RESN','Other');
insert into substance_mapping values ('Other, SKIM OIL','Lube/motor oil (new)');
insert into substance_mapping values ('Other, SLOP','Other');
insert into substance_mapping values ('Other, SOLVENT','Solvent');
insert into substance_mapping values ('Other, STD-87','Petroleum product');
insert into substance_mapping values ('Other, STD87','Petroleum product');
insert into substance_mapping values ('Other, STODDARDS','Solvent');
insert into substance_mapping values ('Other, STR-87','Lube/motor oil (new)');
insert into substance_mapping values ('Other, SUNDEX 790','Petroleum product');
insert into substance_mapping values ('Other, SUNTHENE','Lube/motor oil (new)');
insert into substance_mapping values ('Other, TELLUS OIL','Lube/motor oil (new)');
insert into substance_mapping values ('Other, TRANS OIL','Lube/motor oil (new)');
insert into substance_mapping values ('Other, TRANSFLUID','Lube/motor oil (new)');
insert into substance_mapping values ('Other, ULS DIESEL','Diesel fuel (b-unknown)');
insert into substance_mapping values ('Other, UNKNOWN','Unknown');
insert into substance_mapping values ('Other, UNL NON-ET','Gasoline (non-ethanol)');
insert into substance_mapping values ('Other, UNLNON-ETH','Gasoline (non-ethanol)');
insert into substance_mapping values ('Other, USED OIL','Used oil/waste oil');
insert into substance_mapping values ('Other, VARNISH','Petroleum product');
insert into substance_mapping values ('Other, VARSOL','Petroleum product');
insert into substance_mapping values ('Other, VEGGIE OIL','Petroleum product');
insert into substance_mapping values ('Other, VIRGIN OIL','Petroleum product');
insert into substance_mapping values ('Other, VM&PNAPTHA','Lube/motor oil (new)');
insert into substance_mapping values ('Other, WASTE OIL','Used oil/waste oil');
insert into substance_mapping values ('Other, WATER','Other');
insert into substance_mapping values ('Other, WATER/SLOP','Other');
insert into substance_mapping values ('Other, X','Other');
insert into substance_mapping values ('Other, X-DEF','Other');
insert into substance_mapping values ('Other, XC','Other');
insert into substance_mapping values ('Other, XZ','Other');
insert into substance_mapping values ('Other, Z','Other');
insert into substance_mapping values ('Premium gasoline','Gasoline (unknown type)');
insert into substance_mapping values ('Unleaded gasoline','Gasoline (unknown type)');
insert into substance_mapping values ('Used oil','Used oil/waste oil');
insert into substance_mapping values ('Virgin oil','Lube/motor oil (new)');
