select FacilityID,
 null as TankIDAssociatedwithRelease,
 r.remid as LUSTID, --OR spillnumber, but spillnumber IS sometimes NULL 
 null as FederallyReportableRelease,
 g.name as SiteName,
 g.address as SiteAddress,
 g.address2 as SiteAddress2,
 g.zip as Zipcode,
 c.countyname as County,
 'MO' as State,
 '7' as EPARegion,
 null as FacilityType,
 null as TribalSite,
 null as Tribe,
 ll.converted_lat as Latitude, 
 ll.converted_long as Longitude, 
 null as CoordinateSource,
 CASE WHEN r.ACTIVE = -1 THEN 'Active: general'
      WHEN r.active = 0 AND r.NOFURTHERACTION IS NOT NULL THEN 'No Further Action'
      WHEN r.active = 0 THEN 'Other' END as LUSTStatus,
 r.releasedate as ReportedDate,
 r.NOFURTHERACTION  as NFADate,
 CASE WHEN soil.remid IS NOT NULL THEN 'Yes' ELSE 'No' end as MediaImpactedSoil,
 CASE WHEN gw.remid IS NOT NULL THEN 'Yes' ELSE 'No' end as MediaImpactedGroundwater,
 CASE WHEN sw.remid IS NOT NULL THEN 'Yes' ELSE 'No' end as MediaImpactedSurfaceWater,
 null as SubstanceReleased1,
 null as QuantityReleased1,
 null as Unit1,
 null as SubstanceReleased2,
 null as QuantityReleased2,
 null as Unit2,
 null as SubstanceReleased3,
 null as AmountReleased3,
 null as Unit3,
 null as SubstanceReleased4,
 null as AmountReleased4,
 null as Unit4,
 null as SubstanceReleased5,
 null as AmountReleased5,
 null as Unit5,
 CASE WHEN s.RELEASEID = 3 THEN 'Dispenser'
      WHEN s.releaseid IN (5,6) THEN 'Other'
      WHEN s.RELEASEID = 2 THEN 'Piping'
      WHEN s.RELEASEID = 4 THEN 'Submersible turbine pump'
      WHEN s.RELEASEID = 1 THEN 'Tank'
      WHEN s.RELEASEID = 7 THEN 'Unknown' END as SourceOfRelease1, --need additional mapping help; see spreadsheet
 CASE WHEN c.remcauseid = 3 THEN 'Tank corrosion'
 	  WHEN c.remcauseid = 2 THEN 'Delivery overfill'
 	  WHEN c.remcauseid = 1 THEN 'Human error'
	  WHEN c.remcauseid in (4,5,6) THEN 'Other'
      WHEN c.remcauseid = 7 THEN 'Unknown' END as CauseOfRelease1, --need additional mapping help; see spreadsheet
 null as SourceOfRelease2,
 null as CauseOfRelease2,
 null as SourceOfRelease3,
 null as CauseOfRelease3,
 null as HowReleaseDetected,
 CASE WHEN t.REMTECHID = '0' THEN 'Air Sparging'
      WHEN t.remtechid = '6' THEN 'Excavation and Hauling'
      WHEN t.remtechid  IN ('7','E','F')  THEN 'Other'
      WHEN t.remtechid = '9' THEN 'Soil Vapor Extraction'
      WHEN t.remtechid = '8' THEN 'Duel phase extraction'
      WHEN t.remtechid = 'A' THEN 'Pump and treat'
      WHEN t.remtechid = 'B' THEN 'Monitored natural attenuation'
      WHEN t.remtechid = 'D' THEN 'Landfarming'
      WHEN t.remtechid = 'W' THEN 'Vacuum vaporizing well' 
      WHEN t.remtechid = 'Z' THEN 'Oxygen or oxydizer injection or placement in excavation' END as RemediationStrategy1, --need additional mapping help; see spreadsheet
 null as RemediationStrategy1StartDate,
 null as RemediationStrategy2,
 null as RemediationStrategy2StartDate,
 null as RemediationStrategy3,
 null as RemediationStrategy3StartDate,
 null as ClosedWithContamination,
 null as NoFurtherActionLetterURL,
 null as MilitaryDoDSite
FROM tblFacility f 
	LEFT JOIN tblGeoSite g ON f.FACILITYID = g.FACILITYID  
	LEFT JOIN tblGeoSite_LatLong ll ON f.FACILITYID = ll.FACILITYID
	LEFT JOIN tblcounty c ON g.county = c.COUNTYCODE 
	LEFT JOIN tblRemediation r ON f.facilityid = r.facilityid
	LEFT JOIN (SELECT DISTINCT remid FROM tblRemMediaAffected WHERE mediaaffectedid = 1) soil ON r.REMID = soil.remid
	LEFT JOIN (SELECT DISTINCT remid FROM tblRemMediaAffected WHERE mediaaffectedid = 2) gw ON r.remid = gw.remid
	LEFT JOIN (SELECT DISTINCT remid FROM tblRemMediaAffected WHERE mediaaffectedid = 4) sw ON r.remid = sw.remid
	LEFT JOIN (SELECT DISTINCT remid, releaseid FROM tblRemediationSource) s ON r.remid = s.remid --IS TBLSPILLSOURCE THE RIGHT LOOKUP TABLE??; this JOIN assumes one ROW per remid, which works FOR now but may NOT ALWAYS be the case
	LEFT JOIN (SELECT DISTINCT remid, remcauseid FROM tblRemediationCause) c ON r.remid = c.remid --IS TBLSPILLCAUSE THE RIGHT LOOKUP TABLE??; this JOIN assumes one ROW per remid, which works FOR now but may NOT ALWAYS be the case
	LEFT JOIN (SELECT DISTINCT remid, remtechid FROM tblRemTech) t ON r.remid = t.remid --this JOIN assumes one ROW per remid, which works FOR now but may NOT ALWAYS be the case
