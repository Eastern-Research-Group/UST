create table substance_mapping(nc_substance varchar(1000), epa_substance varchar(400));
insert into substance_mapping values ('99.9% BIODIESEL','Diesel blend containing 99% to less than 100% biodiesel');
insert into substance_mapping values ('ACETONE','Solvent');
insert into substance_mapping values ('B99 Biodiesel','Diesel blend containing 99% to less than 100% biodiesel');
insert into substance_mapping values ('Bio','Biofuel/bioheat');
insert into substance_mapping values ('BIO-DIESEL (B99.9)','Diesel blend containing 99% to less than 100% biodiesel');
insert into substance_mapping values ('BIO-DIESEL(99.9)','Diesel blend containing 99% to less than 100% biodiesel');
insert into substance_mapping values ('Bio Diesel 100%','100% biodiesel (not federally regulated)');
insert into substance_mapping values ('BIODIESEL','Biofuel/bioheat');
insert into substance_mapping values ('BIODIESEL (B99.9)','Diesel blend containing 99% to less than 100% biodiesel');
insert into substance_mapping values ('BIODIESEL(B99.9)','Diesel blend containing 99% to less than 100% biodiesel');
insert into substance_mapping values ('Car Wash Runoff','Other');
insert into substance_mapping values ('DEF','Diesel exhaust fluid (DEF, not federally regulated)');
insert into substance_mapping values ('DEF NON REGULATED','Diesel exhaust fluid (DEF, not federally regulated)');
insert into substance_mapping values ('DEF TANK','Diesel exhaust fluid (DEF, not federally regulated)');
insert into substance_mapping values ('Diesel','Diesel fuel (b-unknown)');
insert into substance_mapping values ('Diesel Exhaust Fluid','Diesel exhaust fluid (DEF, not federally regulated)');
insert into substance_mapping values ('DIESEL EXHAUST FLUID','Diesel exhaust fluid (DEF, not federally regulated)');
insert into substance_mapping values ('DIESEL FUEL EXHAUST','Diesel exhaust fluid (DEF, not federally regulated)');
insert into substance_mapping values ('ETHANOL','Ethanol blend gasoline (e-unknown)');
insert into substance_mapping values ('ETHONAL > 10% GAS MIX','Ethanol blend gasoline (e-unknown)');
insert into substance_mapping values ('ETHYL ACETATE','Solvent');
insert into substance_mapping values ('FUEL ADDITIVE','Gasoline (unknown type)');
insert into substance_mapping values ('FUEL ADDITIVE TANK','Gasoline (unknown type)');
insert into substance_mapping values ('Fuel Oil','Gasoline (unknown type)');
insert into substance_mapping values ('Gasoline Additive - Lubrizol 9888','Gasoline (unknown type)');
insert into substance_mapping values ('Gasoline, Aviation','');
insert into substance_mapping values ('Gasoline, Gas Mix','Gasoline (unknown type)');
insert into substance_mapping values ('Heating Oil/Fuel','Heating/fuel oil # unknown');
insert into substance_mapping values ('Hexane','Gasoline (unknown type)');
insert into substance_mapping values ('Hydraulic Fluid','Other');
insert into substance_mapping values ('ISOPAR C','Solvent');
insert into substance_mapping values ('ISOPROPYL ALCOHOL','Solvent');
insert into substance_mapping values ('Kerosene, Kero Mix','Kerosene');
insert into substance_mapping values ('LUBRIZOL 9888','Gasoline (unknown type)');
insert into substance_mapping values ('METHYL ETHYL KETONE','Solvent');
insert into substance_mapping values ('Mixed OIl','Used oil/waste oil');
insert into substance_mapping values ('Motor Oil','Lube/motor oil (new)');
insert into substance_mapping values ('Never Contained Product-Empty','Other');
insert into substance_mapping values ('Never Used','Other');
insert into substance_mapping values ('NO PRODUCT EVER PLACED IN TANK','Other');
insert into substance_mapping values ('NON-ETH','Gasoline (non-ethanol)');
insert into substance_mapping values ('NOT INDICATED','Other');
insert into substance_mapping values ('O/W SEPARATOR','Other');
insert into substance_mapping values ('Oil-Water Separator','Other');
insert into substance_mapping values ('Oil-water seperator','Other');
insert into substance_mapping values ('OIL WATER MIXTURE','Other');
insert into substance_mapping values ('OIL WATER SEPARATION','Other');
insert into substance_mapping values ('OIL WATER SEPARATOR','Other');
insert into substance_mapping values ('oil water seperator','Other');
insert into substance_mapping values ('Oil, New/Used/Mix','Other');
insert into substance_mapping values ('Oil/Water Mix','Other');
insert into substance_mapping values ('OIL/WATER MIXED','Other');
insert into substance_mapping values ('Oil/Water Sep','Other');
insert into substance_mapping values ('OIL/WATER SEP','Other');
insert into substance_mapping values ('Oil/Water Sep <= 1%','Other');
insert into substance_mapping values ('Oil/Water Separator','Other');
insert into substance_mapping values ('OIL/WATER SEPARATOR','Other');
insert into substance_mapping values ('Oil/WaterSeparator','Other');
insert into substance_mapping values ('OW SEP','Other');
insert into substance_mapping values ('OWS','Other');
insert into substance_mapping values ('Petroleum','Petroleum products');
insert into substance_mapping values ('Petroleum Contact Water','Petroleum products');
insert into substance_mapping values ('PROPYL CELLUSOLVE','Solvent');
insert into substance_mapping values ('STODDARD SOLVENT','Solvent');
insert into substance_mapping values ('Tank never installed at location.','REMOVE THIS RECORD');
insert into substance_mapping values ('TOLUENE','Solvent');
insert into substance_mapping values ('ULTRAZOL 9888 MIXTURE','Gasoline (unknown type)');
insert into substance_mapping values ('unk','Unknown');
insert into substance_mapping values ('UNK','Unknown');
insert into substance_mapping values ('Unknown','Unknown');
insert into substance_mapping values ('water/petroleum','Petroleum products');




select * from information_schema.columns 
where table_schema = 'public' and 
lower(column_name) like lower('%substance%')
order by table_name, column_name;

select * from information_schema.columns where table_schema = 'public' and data_type = 'timestamp without time zone'
and "table_name" = 'tblUST_DB1';

select * from public."qryLUST_Data";

select distinct "LUSTStatus" from public."qryLUST_Data" where "NFA" is null;

select * from public."tblPolType1";

select * from public."tblUST_DB1";

select distinct "Contamination" from public."tblUST_DB1";
No

NO
GW
sl
SL

select distinct "TypeCAP" from "tblUST_DB1";
N
B

P

select distinct "reg" from public."qryLUST_Data" ;

select * from public."tblPIRF1";

select * from "tblOwnership1";

select *
FROM ("tblPolType1" RIGHT JOIN 
	  ("tblOwnership1" RIGHT JOIN 
	   ((("tblUST_DB1" LEFT JOIN "tblPIRF1" ON "tblUST_DB1"."USTNum" = "tblPIRF1"."USTNum") 
		 LEFT JOIN "tblAccuracy1" ON "tblUST_DB1"."HCS_Res" = "tblAccuracy1"."HCS_Res") 
		LEFT JOIN "tblSourceType1" ON "tblPIRF1"."RSource" = "tblSourceType1"."TypeCode") 
	  ON "tblOwnership1"."Ownership" = "tblPIRF1"."Ownership") 
	 ON "tblPolType1"."TYPE CODE" = "tblPIRF1"."Type") 
	LEFT JOIN "tblConSource1" ON "tblPIRF1"."RSource" = "tblConSource1".ID
WHERE ((("tblUST_DB1"."Comm")='C') AND (("tblUST_DB1"."reg")='R'));

select * from "tblOwnership1"

select distinct "Ownership" from "tblPIRF1" order by 1;

select * from 
	(select a.*, cast(pir."Ownership" as bigint) as "OwnershipInt"
	from "tblUST_DB1" ldb left join "tblPIRF1" pir on ldb."USTNum" = pir."USTNum"
		left join "tblAccuracy1" acc on ldb."HCS_Res" = acc."HCS_Res"
		left join "tblSourceType1" src on pir."RSource" = src."TypeCode") as a
	where pir."Ownership" not in ('N','P')) as db1
	left join "tblOwnership1" own on own."Ownership" = db1."Ownership";


select * from public."tblConSource1";
A	Tanks	21
B	Piping	22
C	Dispenser	23
D	Submersible Turbine Pump	24
E	Delivery Problem	25
F	Other	26
G	Unknown	27

select * from public."tblRelCause1";
1	Spill (Accidental)
2	UST Overfill
3	Corrosion
4	Physical or Mechanical Damage
5	UST Installation Problem
6	Other
7	Unknown
8	Spill (Intentional)
9	Equipment Failure

select * from public."tblRelDisc1";
4	Visual/Odor
6	Water Supply Well Contamination
7	Groundwater Contamination
8	Surface Water Contamination
9	Other (Specify in "Description" field above)
10	Observation of Release at Occurrence
11	Soil Contamination


select distinct "Reg" from public."tblUST_DB1" ;

select * from public."tblType1";
B	BOTH
N	NON PETROLEUM
P	PETROLEUM

select * from public."qryLUST_Data" where "NFA" is null;

select distinct "Substance" from public."qryLUST_Data" order by 1;



LUSTStatus
"Active
No Further Action
Unknown
Other"

SubstanceReleased1
QuantityReleased1
Unit1


DIESEL/VEGETABLE BLEND	Diesel fuel (b-unknown)
E01 - E10	Gasoline E-10 (E1-E10)
E11 - E20	Ethanol blend gasoline (e-unknown)
ETHANOL 100%	Other
GASOLINE/DIESEL/KEROSENE	Other
HEATING OIL	Heating/fuel oil # unknown
OTHER ORGANICS	Other
OTHER PETROLEUM PROD.	Other
WASTE Oil	Used oil/waste oil


select * from public."tblConSource1";
A	Tanks	21
B	Piping	22
C	Dispenser	23
D	Submersible Turbine Pump	24
E	Delivery Problem	25
F	Other	26
G	Unknown	27

select "IncidentNumber" from public."tblUST_DB1" group by "IncidentNumber" having count(*) > 1;

select * from public."tblUST_DB1" where "IncidentNumber" in 
	(select "IncidentNumber" from public."tblUST_DB1" group by "IncidentNumber" having count(*) > 1)
order by 1;

select * from public."qryLUST_Data" where "IncidentNumber" in 
	(select "IncidentNumber" from public."qryLUST_Data" group by "IncidentNumber" having count(*) > 1)
order by 1;

select * from public."qryLUST_Data" where "USTNum" is null;


select "IncidentNumber", "USTNum", "Substance" from public."qryLUST_Data" where "Substance" is not null order by 1, 2, 3;



select "IncidentNumber", "USTNum", count(*)
from public."vSubstances" s group by "IncidentNumber", "USTNum"
having count(*) > 2;
45282	WS-10114
41653	AS-4635
41619	AS-4581
32768	WI-7675
44116	WS-8870
33323	RA-4960

select * from public."vSubstances" where "IncidentNumber" = 45282 and "USTNum" = 'WS-10114';


create view "vSubstances" as 
select distinct "IncidentNumber", "USTNum", "Substance", 
		case when ld."Substance" = 'DIESEL/VEGETABLE BLEND' then 'Diesel fuel (b-unknown)'
	     when ld."Substance" = 'E01 - E10' then 'Gasoline E-10 (E1-E10)'
	     when ld."Substance" = 'E11 - E20' then 'Ethanol blend gasoline (e-unknown)'
	     when ld."Substance" = 'HEATING OIL' then 'Heating/fuel oil # unknown'
	     when ld."Substance" = 'WASTE Oil' then 'Used oil/waste oil' 
		 else 'Other' end as "SubstanceReleased" --see crosswalk in template
from "qryLUST_Data" ld where ld."Substance" is not null;

select "IncidentNumber", "USTNum", "SubstanceReleased" from "vSubstances" 
group by "IncidentNumber", "USTNum", "SubstanceReleased" having count(*) > 1
order by "IncidentNumber", "USTNum", "SubstanceReleased" ;

select * from "vSubstances" where "IncidentNumber" = 24532;

create view "vSubstances2" as
select a.*, row_number() over (partition by "IncidentNumber", "USTNum" order by "IncidentNumber", "USTNum") rn
from "vSubstances" a;


select distinct "IncidentNumber", "USTNum", "Substance"
from "qryLUST_Data" q left join "tbl"

MediaImpactedSoil
MediaImpactedGroundwater
MediaImpactedSurfaceWater


select distinct
	ld."FacilID" as "FacilityID", ld."USTNum" as "TankIDAssociatedwithRelease", ld."IncidentNumber" as "LUSTID",
	ld."IncidentName" as "FacilityName", --is this right?
	ld."Address" as "SiteAddress", ld."CityTown" as "SiteCity", ld."ZipCode" as "Zipcode", ld."County", ld."State", 4 as "EPARegion",
	ld."LatDec" as "Latitude", ld."LongDec" as "Longitude", 
	--What is the lookup for "LUSTStatus"?
	case when "NFA" is not null then 'No Further Action' else 'Active' end as "LUSTStatus", --is this right? 
	ld."DateReported" as "ReportedDate", ld."NFA" as "NFADate",
	--tblRelDisc1 seems to be a lookup table that would contain information related to MediaImpactedSoil, MediaImpactedGroundwater, MediaImpactedSurfaceWater
	--but I don't see any columns related to it
	s1."SubstanceReleased" as "SubstanceReleased1", --see template for crosswalk
	s2."SubstanceReleased" as "SubstanceReleased2", --some substances may be repeated b/c multiple NC substances mapped to the same EPA substance
	s3."SubstanceReleased" as "SubstanceReleased3" --can we get the amounts released and units?
from "tblUST_DB1" ld 
	left join (select * from "vSubstances2" where rn = 1) s1 on ld."IncidentNumber" = s1."IncidentNumber" and ld."USTNum" = s1."USTNum"
	left join (select * from "vSubstances2" where rn = 2) s2 on ld."IncidentNumber" = s2."IncidentNumber" and ld."USTNum" = s2."USTNum"
	left join (select * from "vSubstances2" where rn = 3) s3 on ld."IncidentNumber" = s3."IncidentNumber" and ld."USTNum" = s3."USTNum"
where "FacilID" is not null --why are some facility IDs null?
	and upper("Reg") = 'R' --does this mean federally reportable? If so, should we include all rows instead and set "FederallyReportableRelease" to "No" for the others?
	and upper("Comm") = 'C' --got this from Lust_Finder.txt; what does it mean?
;

















create table lust_lookup (facility_id varchar(40), lust_id varchar(40));
insert into lust_lookup values ('-0000013407','MO-0857');
insert into lust_lookup values ('-0000031966','RA-28754');
insert into lust_lookup values (' 0-0-0000036574','RA-8349');
insert into lust_lookup values (' 0-0-005237','RA-7553');
insert into lust_lookup values (' 0-006458','RA-8252');
insert into lust_lookup values (' 0-016413','RA-7915');
insert into lust_lookup values (' 0-023048','RA-8130');
insert into lust_lookup values (' 0-031751','RA-7875');
insert into lust_lookup values (' 0-036101','RA-28729');
insert into lust_lookup values (' 0-036513','RA-7186');
insert into lust_lookup values ('00-0-000001060','FA-2279');
insert into lust_lookup values ('0--020105','WA-937');
insert into lust_lookup values ('0-0-00000002841','AS-4393');
insert into lust_lookup values ('0-0-00000004317','AS-4317');
insert into lust_lookup values ('0-0-00000004600','AS-1565');
insert into lust_lookup values ('0-0-00000009267','AS-1193');
insert into lust_lookup values ('0-0-0000001132','AS-28222');
insert into lust_lookup values ('0-0-00000012740','AS-3814');
insert into lust_lookup values ('0-0-00000014303','AS-4157');
insert into lust_lookup values ('0-0-00000033060','AS-916');
insert into lust_lookup values ('0-0-00000035484','AS-4048');
insert into lust_lookup values ('0-0-00000036364','AS-4474');
insert into lust_lookup values ('0-0-0000008226','MO-9314');
insert into lust_lookup values ('0-0-0000008556','MO-8897');
insert into lust_lookup values ('0-0-0000012239','WS-9409');
insert into lust_lookup values ('0-0-0000021650','WS-10182');
insert into lust_lookup values ('0-0-00000221663','RA-7941');
insert into lust_lookup values ('0-0-0000022572','RA-8345');
insert into lust_lookup values ('0-0-0000023420','AS-1366');
insert into lust_lookup values ('0-0-0000026200','WA-27450');
insert into lust_lookup values ('0-0-0000030759','RA-7573');
insert into lust_lookup values ('0-0-0000031258','RA-8347');
insert into lust_lookup values ('0-0-0000032432','RA-7745');
insert into lust_lookup values ('0-0-0000032757','WI-8102');
insert into lust_lookup values ('0-0-0000034352','RA-8346');
insert into lust_lookup values ('0-0-0000035529','AS-4277');
insert into lust_lookup values ('0-0-0000035728','RA-8348');
insert into lust_lookup values ('0-0-0000036820','WI-8012');
insert into lust_lookup values ('0-0-012647','FA-7971');
insert into lust_lookup values ('0-0-012916','FA-7777');
insert into lust_lookup values ('0-0-017827','MO-9194');
insert into lust_lookup values ('0-0-024428','RA-8146');
insert into lust_lookup values ('0-0-033616','AS-4424');
insert into lust_lookup values ('0-0-036302','FA-7974');
insert into lust_lookup values ('0-0-04167','WI-28154');
insert into lust_lookup values ('0-0-043','WA-27531');
insert into lust_lookup values ('0-0-09298','AS-4491');
insert into lust_lookup values ('0-0-19415','WS-9022');
insert into lust_lookup values ('0-0-36499','FA-28392');
insert into lust_lookup values ('0-0-42650','RA-27869');
insert into lust_lookup values ('0-0-42928','RA-8432');
insert into lust_lookup values ('0-00--000013592','AS-27726');
insert into lust_lookup values ('0-00-0000000381','WA-1588');
insert into lust_lookup values ('0-00-0000000381','WA-25828');
insert into lust_lookup values ('0-00-0000000381','WA-26633');
insert into lust_lookup values ('0-00-0000000381','WA-26634');
insert into lust_lookup values ('0-00-0000000841','WA-27243');
insert into lust_lookup values ('0-00-0000001188','AS-4269');
insert into lust_lookup values ('0-00-0000004035','WS-10099');
insert into lust_lookup values ('0-00-0000004035','WS-8995');
insert into lust_lookup values ('0-00-0000004381','AS-424');
insert into lust_lookup values ('0-00-0000004457','AS-4531');
insert into lust_lookup values ('0-00-0000004761','AS-3007');
insert into lust_lookup values ('0-00-0000005480','RA-7804');
insert into lust_lookup values ('0-00-0000005626','WS-8990');
insert into lust_lookup values ('0-00-0000007594','AS-1567');
insert into lust_lookup values ('0-00-0000008319','MO-28311');
insert into lust_lookup values ('0-00-0000008686','AS-1094');
insert into lust_lookup values ('0-00-0000009233','WS-8980');
insert into lust_lookup values ('0-00-0000010125','AS-4693');
insert into lust_lookup values ('0-00-0000011139','RA-28283');
insert into lust_lookup values ('0-00-0000011190','AS-4058');
insert into lust_lookup values ('0-00-0000011943','AS-4002');
insert into lust_lookup values ('0-00-0000011983','WA-27445');
insert into lust_lookup values ('0-00-0000012413','WA-27284');
insert into lust_lookup values ('0-00-0000012413','WA-27285');
insert into lust_lookup values ('0-00-0000013144','FA-7729');
insert into lust_lookup values ('0-00-0000021462','AS-4592');
insert into lust_lookup values ('0-00-0000023317','AS-4242');
insert into lust_lookup values ('0-00-0000023348','MO-9556');
insert into lust_lookup values ('0-00-0000024710','AS-2020');
insert into lust_lookup values ('0-00-0000025545','AS-4105');
insert into lust_lookup values ('0-00-0000026968','AS-4092');
insert into lust_lookup values ('0-00-0000028905','RA-8054');
insert into lust_lookup values ('0-00-000002944','WA-27380');
insert into lust_lookup values ('0-00-0000033220','AS-4101');
insert into lust_lookup values ('0-00-0000034104','WA-27343');
insert into lust_lookup values ('0-00-0000034475','WA-27442');
insert into lust_lookup values ('0-00-0000035225','WA-27260');
insert into lust_lookup values ('0-00-0000035325','FA-8038');
insert into lust_lookup values ('0-00-0000035722','WA-27627');
insert into lust_lookup values ('0-00-000003613','WA-27283');
insert into lust_lookup values ('0-00-000004042','RA-7769');
insert into lust_lookup values ('0-00-000005844','WS-9917');
insert into lust_lookup values ('0-00-000007557','MO-8817');
insert into lust_lookup values ('0-00-000028562','MO-9181');
insert into lust_lookup values ('0-00-00015807','MO-9215');
insert into lust_lookup values ('0-00-024165','WS-9175');
insert into lust_lookup values ('0-000000-32094','RA-7713');
insert into lust_lookup values ('0-000000-32094','RA-7770');
insert into lust_lookup values ('0-0000000004339','AS-762');
insert into lust_lookup values ('0-0000000011154','AS-4037');
insert into lust_lookup values ('0-0000000011207','AS-4074');
insert into lust_lookup values ('0-0000000012367','AS-4426');
insert into lust_lookup values ('0-0000000025228','AS-1723');
insert into lust_lookup values ('0-000000007889','AS-294');
insert into lust_lookup values ('0-000000014294','AS-764');
insert into lust_lookup values ('0-0000002804','WI-750');
insert into lust_lookup values ('0-00000031808','AS-4241');
insert into lust_lookup values ('0-0000004250','AS-4313');
insert into lust_lookup values ('0-0000005004','AS-4164');
insert into lust_lookup values ('0-0000006685','RA-7642');
insert into lust_lookup values ('0-0000012432','WA-27404');
insert into lust_lookup values ('0-0000012650','WA-27301');
insert into lust_lookup values ('0-0000015130','RA-7693');
insert into lust_lookup values ('0-000001625','RA-8206');
insert into lust_lookup values ('0-0000019055','WA-27610');
insert into lust_lookup values ('0-0000021534','RA-8364');
insert into lust_lookup values ('0-000002168','RA-8630');
insert into lust_lookup values ('0-0000022603','WA-27405');
insert into lust_lookup values ('0-0000023553','AS-4118');
insert into lust_lookup values ('0-000002439','RA-28382');
insert into lust_lookup values ('0-0000032225','RA-8529');
insert into lust_lookup values ('0-0000035816','WA-27330');
insert into lust_lookup values ('0-0000035846','AS-4234');
insert into lust_lookup values ('0-0000035890','WS-8868');
insert into lust_lookup values ('0-0000036752','RA-7246');
insert into lust_lookup values ('0-000017','WI-7766');
insert into lust_lookup values ('0-000020006','RA-2647');
insert into lust_lookup values ('0-000035024','WS-9519');
insert into lust_lookup values ('0-000036368','MO-8820');
insert into lust_lookup values ('0-000041428','RA-7995');
insert into lust_lookup values ('0-00004228','RA-8286');
insert into lust_lookup values ('0-000062','WA-27297');
insert into lust_lookup values ('0-000070','RA-1250');
insert into lust_lookup values ('0-00007534','AS-4671');
insert into lust_lookup values ('0-000097','WI-1122');
insert into lust_lookup values ('0-00012280','WA-27457');
insert into lust_lookup values ('0-0001502','MO-8652');
insert into lust_lookup values ('0-000158','AS-1727');
insert into lust_lookup values ('0-000169','AS-1246');
insert into lust_lookup values ('0-000234','WI-1093');
insert into lust_lookup values ('0-00025234','MO-8769');
insert into lust_lookup values ('0-000269','RA-1976');
insert into lust_lookup values ('0-000306','RA-1761');
insert into lust_lookup values ('0-000410','RA-1964');
insert into lust_lookup values ('0-000501','RA-2330');
insert into lust_lookup values ('0-000522','RA-1892');
insert into lust_lookup values ('0-000552','RA-2086');
insert into lust_lookup values ('0-000553','RA-1714');
insert into lust_lookup values ('0-000563','MO-8685');
insert into lust_lookup values ('0-000571','RA-2828');
insert into lust_lookup values ('0-000579','WA-1108');
insert into lust_lookup values ('0-000758','AS-1687');
insert into lust_lookup values ('0-000821','MO-8646');
insert into lust_lookup values ('0-000931','MO-3221');
insert into lust_lookup values ('0-000998','AS-1734');
insert into lust_lookup values ('0-0010243','AS-4159');
insert into lust_lookup values ('0-001041','RA-1971');
insert into lust_lookup values ('0-001129','RA-851');
insert into lust_lookup values ('0-001185','WI-7559');
insert into lust_lookup values ('0-001188','AS-894');
insert into lust_lookup values ('0-0011953','AS-3980');
insert into lust_lookup values ('0-0012320','FA-3224');
insert into lust_lookup values ('0-001255','WI-1234');
insert into lust_lookup values ('0-001309','WA-879');
insert into lust_lookup values ('0-001332','WA-1706');
insert into lust_lookup values ('0-001344','WA-593');
insert into lust_lookup values ('0-001346','RA-3691');
insert into lust_lookup values ('0-001371','RA-1853');
insert into lust_lookup values ('0-001381','AS-1241');
insert into lust_lookup values ('0-001448','AS-1054');
insert into lust_lookup values ('0-001452','WA-1589');
insert into lust_lookup values ('0-001474','RA-1295');
insert into lust_lookup values ('0-001507','WA-1812');
insert into lust_lookup values ('0-0015384','MO-9077');
insert into lust_lookup values ('0-0016101','RA-7281');
insert into lust_lookup values ('0-001637','AS-849');
insert into lust_lookup values ('0-001682','RA-2187');
insert into lust_lookup values ('0-001690','AS-1162');
insert into lust_lookup values ('0-001727','WA-27228');
insert into lust_lookup values ('0-001766','RA-2263');
insert into lust_lookup values ('0-001778','AS-1026');
insert into lust_lookup values ('0-001791','RA-1638');
insert into lust_lookup values ('0-001792','RA-1816');
insert into lust_lookup values ('0-0018100','WS-9133');
insert into lust_lookup values ('0-001820','WS-1705');
insert into lust_lookup values ('0-0019155','RA-7439');
insert into lust_lookup values ('0-001939','WS-3594');
insert into lust_lookup values ('0-001983','WI-1037');
insert into lust_lookup values ('0-001985','AS-1045');
insert into lust_lookup values ('0-001985','AS-4669');
insert into lust_lookup values ('0-001998','RA-2873');
insert into lust_lookup values ('0-001999','AS-1359');
insert into lust_lookup values ('0-002015','RA-1191');
insert into lust_lookup values ('0-002038','AS-1814');
insert into lust_lookup values ('0-002066','WI-1088');
insert into lust_lookup values ('0-002089','RA-2865');
insert into lust_lookup values ('0-002120','RA-892');
insert into lust_lookup values ('0-002208','WS-1731');



select distinct "LUSTStatus" from "qryLUST_Data" order by 1;

select * from "tblCAP1"


5)	What is the lookup for "RemediationStrategy" from "qryLUST_Data"?
	Lookup table is tblCAP,
	Values are A = Air Sparging & Soil Vapor Extraction, B = Biosparging, C = CAP in Accordance with .0106[c], D = Dual Phase Extraction, E = Excavation, F = Free Product Skimming System, I = Internal Combustion Engines, K = CAP in Accordance with .0106[k], L = CAP in Accordance with .0106[l], M = CAP in Accordance with .0106[m], N = Natural Attenuation (not an L-CAP), O = Other Type of System, P = Pump & Treat, R = Biofluid Reactor, S = SV, T = Monitoring Only, U = UVB/KGB, V = AFVR, data stored in field TypeCAP in tblUST_DB

	
	select * from "tblRelDisc1" trd 
	
4	Visual/Odor
6	Water Supply Well Contamination
7	Groundwater Contamination
8	Surface Water Contamination
9	Other (Specify in "Description" field above)
10	Observation of Release at Occurrence
11	Soil Contamination

select distinct "HowReleaseDetected" from "qryLUST_Data" order by 1;
1.0
2.0
3.0
4.0
5.0
6.0
7.0
8.0
9.0
11.0

select distinct "RCause" from "qryLUST_Data" order by 1;
1
2
3
4
5
6
7
A
C
D
E

select distinct "Plume" from "qryLUST_Data" order by 1;
Delivery Problem
Dispenser
Other
Piping
Submersible Turbine Pump
Tanks
Unknown


select distinct "RCause" from "tblPIRF1" order by 1;