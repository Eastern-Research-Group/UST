

select * from "NC_LUST"."UST_FINDER_011123" ; 


--What do codes GW, NO, and SL mean in "Contamination" column? GW=groundwater, SL=soil, NO=?
--What is column Expr1018?
--What is column InterCons?
--What are columns Comm and reg?
--What is column TypeCAP?
--What is column ReleaseCode?
--What is column PETOPT?

select * from "NC_LUST"."tblRelDisc1" trd 

create or replace view "NC_LUST".v_lust_base as 
select 
	a."FacilID" as "FacilityID",
	a."USTNum" as "LUSTID",
	a."IncidentName" as "SiteName",
	a."Address" as "SiteAddress",
	a."CityTown" as "SiteCity",
	a."ZipCode" as "Zipcode",
	a."State" as "State",
	4 as "EPARegion",
	a."LatDec" as "Latitude",
	a."LongDec" as "Longitude",
	case when upper("HCS_Ref") like '%GPS%' then 'GPS'
	     when lower("HCS_Ref") like '%google%' or lower("HCS_Ref") like '%map%' then 'Map Interpolation'
	     when lower("HCS_Ref") like '%geocode%' or  lower("HCS_Ref") like '%address%' then 'Geocode'
	     when lower("HCS_Ref") like 'unk%' then 'Unknown'
		end as "StateCoordinateSource", --there are others unmapped
	null as "LUSTStatus", --per NC, CurrStatus " is just an internally used indicator as to whether the file is physically still in the office or if it has been sent to electronic archive.  It will not be relevant"
	a."DateReported" as "ReportedDate",
	"CloseOut" as "NFADate",  --is this correct?
	case when a."HowReleaseDetected" = 11 then 'Yes' end as "MediaImpactedSoil",
	case when a."HowReleaseDetected" = 7 then 'Yes' end as "MediaImpactedGroundwater",
	case when a."HowReleaseDetected" = 8 then 'Yes' end as "MediaImpactedSurfaceWater",
	case when "TYPE NAME" = 'DIESEL/VEGETABLE BLEND' then 'Diesel fuel (b-unknown)'
	     when "TYPE NAME" = 'E01 - E10' then 'Gasoline E-10 (E1-E10)'
	     when "TYPE NAME" = 'E11 - E20' then 'Gasoline E-15 (E-11-E15)'
	     when "TYPE NAME" = 'GASOLINE/DIESEL/KEROSENE' then 'Petroleum products'
	     when "TYPE NAME" = 'OTHER PETROLEUM PROD.' then 'Petroleum products'
	     when "TYPE NAME" = 'HEATING OIL' then 'Heating/fuel oil # unknown'	
		 when "TYPE NAME" = 'OTHER ORGANICS' then	'Other'
		 when upper("TYPE NAME") = 'WASTE OIL' then 'Used oil/waste oil'
		 when "TYPE NAME" is not null then 'Petroleum products' end as "SubstanceReleased1",
	case when "Sources" = 'A' then 'Dispenser'
	     when "Sources" = 'B' then 'Piping'
	     when "Sources" = 'C' then 'Tank'
	     when "Sources" = 'D' then 'Other'
	     when "Sources" = 'E' then 'Unknown' end as "SourceOfRelease1",
	case when "Plume" = 'Delivery Problem' then 'Delivery Problem'
		 when "Plume" = 'Dispenser' then 'Dispenser Spill'
		 when "Plume" = 'Other' then 'Other'
		 when "Plume" = 'Piping' then 'Piping failure'
		 when "Plume" = 'Unknown' then 'Unknown' end as "CauseOfRelease1",
	case when "HowReleaseDetected" = 7 then 'GW Monitoring Well'
	     when "HowReleaseDetected" = 10 then 'Inspection'
	     when "HowReleaseDetected" in (1,2,3,9) then 'Other'
	     when "HowReleaseDetected" in (4,6,8,11) then 'Third party (well water, vapor intrusion, etc.)' end as "HowReleaseDetected",
	case when a."IncidentNumber" is not null and "CloseOut" is not null and "LURFiled" is not null then 'Yes' end as "ClosedWithContamination",
	null as "NoFurtherActionLetterURL",
	null as "MilitaryDoDSite"
from "NC_LUST"."UST_FINDER_011123" a;	
	
	
from "tblUST_DB1" a left join "qryLUST_Data" b on a."IncidentNumber" = b."IncidentNumber"
	left join "tblPIRF1" c on a."USTNum" = c."USTNum"
where "Substance" <> 'ETHANOL 100%'
and a."Comm" = 'C' and a."Reg" = 'R'
order by a."FacilID", a."USTNum";



