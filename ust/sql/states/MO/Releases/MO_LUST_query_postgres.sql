
----------------------------------------------------------------------------------------------------------------------------------
insert into lust_element_db_mapping (state", mapping_date", element_name", state_table_name", state_column_name",
	state_join_table", state_join_column", state_join_column_fk)
values ('MO'", '2023-06-20'", 'TankStatus'", 'tbltankstatus'", 'tankstatusdescription'", 'tbltank'", 'tankstatuscode'", 'status')
returning id;

select * from "MO_UST".tblRemediation

select distinct 
'insert into lust_element_value_mappings (element_db_mapping_id", state_value", epa_value) values (259", ''' || tankstatusdescription ||  '''", '''');'
from "MO_UST".tbltankstatus
order by 1;
----------------------------------------------------------------------------------------------------------------------------------

drop view "MO_LUST".v_lust_base;
create view "MO_LUST".v_lust_base as 
select f.facilityid as "FacilityID",
 r.remid as "LUSTID", --OR spillnumber", but spillnumber is sometimes NULL 
 g."NAME" as "SiteName",
 g.address as "SiteAddress",
 g.address2 as "SiteAddress2",
 g.zip as "Zipcode",
 c.countyname as "County",
 'MO' as "State",
 7 as "EPARegion",
 ll.converted_lat as "Latitude", 
 ll.converted_long as "Longitude", 
 CASE WHEN r.active = -1 THEN 'Active: general'
      WHEN r.active = 0 AND r.nofurtheraction IS NOT NULL THEN 'No Further Action'
      WHEN r.active = 0 THEN 'Other' END as "LUSTStatus",
 r.releasedate as "ReportedDate",
 r.nofurtheraction  as "NFADate",
 CASE WHEN soil.remid IS NOT NULL THEN 'Yes' ELSE 'No' end as "MediaImpactedSoil",
 CASE WHEN gw.remid IS NOT NULL THEN 'Yes' ELSE 'No' end as "MediaImpactedGroundwater",
 CASE WHEN sw.remid IS NOT NULL THEN 'Yes' ELSE 'No' end as "MediaImpactedSurfaceWater",
 CASE WHEN t.remtechid = '0' THEN 'Air Sparging'
      WHEN t.remtechid = '6' THEN 'Excavation and Hauling'
      WHEN t.remtechid  IN ('7','E','F')  THEN 'Other'
      WHEN t.remtechid = '9' THEN 'Soil Vapor Extraction'
      WHEN t.remtechid = '8' THEN 'Duel phase extraction'
      WHEN t.remtechid = 'A' THEN 'Pump and treat'
      WHEN t.remtechid = 'B' THEN 'Monitored natural attenuation'
      WHEN t.remtechid = 'D' THEN 'Landfarming'
      WHEN t.remtechid = 'W' THEN 'Vacuum vaporizing well' 
      WHEN t.remtechid = 'Z' THEN 'Oxygen or oxydizer injection or placement in excavation' END as "RemediationStrategy1" --need additional mapping help; see spreadsheet
FROM "MO_UST".tblFacility f 
	LEFT JOIN "MO_UST".tblGeoSite g ON f.facilityid = g.facilityid  
	LEFT JOIN "MO_UST".tblGeoSite_latlong ll ON f.facilityid = ll.facilityid
	LEFT JOIN "MO_UST".tblcounty c ON g.county = c.countycode 
	JOIN "MO_UST".tblRemediation r ON f.facilityid = r.facilityid
	LEFT JOIN (SELECT DISTINCT remid FROM "MO_UST".tblremmediaaffected WHERE mediaaffectedid = '1') soil ON r.remid = soil.remid
	LEFT JOIN (SELECT DISTINCT remid FROM "MO_UST".tblremmediaaffected WHERE mediaaffectedid = '2') gw ON r.remid = gw.remid
	LEFT JOIN (SELECT DISTINCT remid FROM "MO_UST".tblremmediaaffected WHERE mediaaffectedid = '4') sw ON r.remid = sw.remid
	LEFT JOIN (SELECT DISTINCT remid, remtechid FROM "MO_UST".tblRemTech) t ON r.remid = t.remid ;   --this JOIN assumes one ROW per remid", which works FOR now but may NOT ALWAYS be the case
----------------------------------------------------------------------------------------------------------------------------------
	
select * from "MO_LUST".v_lust_base where "LUSTID" is not null;	
	
select distinct element_name", state_table_name", state_column_name", state_join_table", state_join_column", state_join_column_fk 
from v_lust_element_mapping
where state = 'MO';