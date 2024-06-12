SELECT * FROM `tblFacilityType` 
A	Above Ground
B	Both
U	Under Ground

SELECT * FROM `tblFacilityStatus` ;
C	Closure
I	Inspection
L	Remediation
N	New Install
O	Other
R	Registered

SELECT * FROM `tblRemTech` 

SELECT * FROM `tblFacility` ;

SELECT * FROM tblTank;

SELECT * FROM `tblTankStatus` 
C	Currently In Use
N	New Install
P	Closed In Place
R	Removed
S	Change In Service
T	Out of Use

SELECT * FROM tbltanktype;
A	Above Ground
B	Below Ground

SELECT * FROM tbltank;

SELECT * FROM `tblTankByCompartment` tc JOIN tbltank t ON tc.TANKPK  = t.TANKPK ;

SELECT * FROM information_schema.columns WHERE upper(column_name) LIKE upper('%inspect%')
AND table_name <> 'USTQUERY2';

SELECT * FROM `tblPipeElectronicMechanicalLLD` ;

SELECT * FROM TBLTANKRLSDETECTION;

SELECT * FROM `tblTankRLSDetection` ;

SELECT * FROM `tblTankPipeReleaseDet` ;

SELECT count(*) FROM `tblTankByCompartment`;

SELECT * FROM `tblTankReleaseDetection` ;
0	Unknown
1	Automatic Tank Gauging\ATG
2	DIC/TTT
3	Manual Tank Gauging\MTG
5	Interstitial Monitoring
6	SIR
7	Vapor
8	Groundwater
9	Chemical Marker
10	Emergency Generator
11	None
12	CITLDS
13	Field Constructed Tank Method
22	Other

SELECT trd.tankcompartmentpk, rd.*
FROM `tblTankRLSDetection` trd JOIN tblTankReleaseDetection rd ON trd.TANKRELEASECODE  = rd.TANKRELEASEDETCODE
ORDER BY 1;

(SELECT tankcompartmentpk FROM tblTankRLSDetection WHERE TANKRELEASECODE = 5) interstitial 
(SELECT tankcompartmentpk FROM tblTankRLSDetection WHERE TANKRELEASECODE = 1) atg 
(SELECT tankcompartmentpk FROM tblTankRLSDetection WHERE TANKRELEASECODE = 3) mtg 
(SELECT tankcompartmentpk FROM tblTankRLSDetection WHERE TANKRELEASECODE = 6) sir
(SELECT tankcompartmentpk FROM tblTankRLSDetection WHERE TANKRELEASECODE = 2) tt
(SELECT tankcompartmentpk FROM tblTankRLSDetection WHERE TANKRELEASECODE = 8) gw
(SELECT tankcompartmentpk FROM tblTankRLSDetection WHERE TANKRELEASECODE = 7) vapor



SELECT * FROM `tblPipeReleaseDetection` ;
0	Unknown
1	Monthly ELLD testing
2	LTT
3	Interstitial
4	SIR
5	Vapor
6	Groundwater
7	Chemical Marker
8	None
9	Emergency Generator
10	ALLD (Automatic Line Leak Detection)
12	CITLDS
13	Airport Hydrant Method
22	Other

SELECT trd.tankcompartmentpk, trd.ELECTRONICORMECHANICALLLD , rd.*
FROM `tblTankPipeReleaseDet`  trd JOIN tblPipeReleaseDetection rd ON trd.PIPERELEASEDETCODE  = rd.PIPERELEASEDETCODE
WHERE ELECTRONICORMECHANICALLLD = 2
ORDER BY 1;

(SELECT tankcompartmentpk FROM tblTankPipeReleaseDet WHERE PIPERELEASEDETCODE = 1) elld
(SELECT tankcompartmentpk FROM tblTankPipeReleaseDet WHERE PIPERELEASEDETCODE = 3) atm


SELECT * FROM `tblTankMaterial` 

SELECT * FROM `tblPipeMaterial` ;

SELECT * FROM `tblPipingSystem` 
0	Suction
1	Pressure
2	Safe Suction
3	Unsafe Suction
4	Gravity
8	Manifold


SELECT * FROM `tblPipeProtection` 
1	Impressed
2	Sacrificial
6	Above Ground
15	Other

SELECT DISTINCT pipedoublewall FROM `tblTankByCompartment` ;

SELECT DISTINCT tankdoublewall FROM tbltank;

SELECT * FROM `tblTankSubstance` ORDER BY 1;

SELECT * FROM `tblTankMaterial` ;

SELECT COUNT(*) FROM TBLTANK WHERE TANKPK NOT IN (SELECT TANKPK FROM `tblTankByCompartment`)

SELECT TANKPK, COUNT(*) AS NUMCOMPARTMENTS FROM `tblTankByCompartment` GROUP BY TANKPK HAVING COUNT(*) = 1;

SELECT DISTINCT pipeprotection FROM `tblTankByCompartment` 

SELECT * FROM `tblPipeReleaseDetection` ;

SELECT DISTINCT spillprotection FROM `tblTankByCompartment` ;
-1
0

SELECT * FROM `tblSpillCause` ;
1	Spill
2	Overfill
3	Corrosion
4	Physical or Mechanical Damage
5	Install Problem
6	Other(specify)
7	UNKNOWN

SELECT * FROM `tblSpillSource` ;
1	Tank
2	Piping
3	Dispenser
4	Submersible Turbine Pump Area
5	Delivery Problem
6	Other(specify)
7	UNKNOWN

SELECT * FROM `tblOverFill` ;
1	Auto Shutoff
2	Ball Valve
3	Alarm
4	Present
5	NotRequired
15	NONE

SELECT * FROM `tblTankOverFillProt` ;

SELECT tc.TANKCOMPARTMENTPK, op.TYPEOVERFILLPROT, vf.SPILLOVERFILLDESCRIPTION 
FROM `tblTankByCompartment` tc JOIN `tblTankOverFillProt` op ON tc.TANKCOMPARTMENTPK  = op.TANKCOMPARTMENTPK 
 LEFT JOIN `tblOverFill` vf ON op.TYPEOVERFILLPROT  = vf.SPILLOVERFILLCODE 

 SELECT * FROM `tblTankExternalProtection` ;
 1	Impressed
2	Sacrificial

SELECT * FROM `tblTankInternalProtection` ;
0	No
1	Yes
2	Other


SELECT * FROM `tblRemediation` ;

SELECT * FROM tblowner;

SELECT ownerid, count(*) FROM tblOwner GROUP BY ownerid HAVING count(*) > 1;

SELECT facilityid, count(*) FROM `tblFacilityLookup` GROUP BY facilityid HAVING count(*) > 1;

SELECT * FROM `tblFacilityLookup`  WHERE FACILITYID = 'ST0001630'

SELECT * FROM tblownertype;

SELECT ownerid, count(*) FROM tblownertype GROUP BY ownerid HAVING count(*) > 1 ORDER BY 2 desc;

SELECT * FROM tblownertype WHERE OWNERID = 'OW03087'

G
L
C

 CASE WHEN ot.ownerclass = 'H' THEN 'Commercial'
 	  WHEN ot.ownerclass = 'F' THEN 'Federal Government - Non Military'
      WHEN ot.ownerclass IN ('C','L','O','Z') THEN 'Local Government'
	  WHEN ot.ownerclass IN ('M','N','P') THEN 'Private'
      WHEN ot.ownerclass = 'S' THEN 'State Government - Non Military' END as OwnerType,

      SELECT * FROM tblownertype ORDER BY ownerid;
      
     SELECT * FROM `tblOwnerClass` ;
     
    SELECT ownerid, count(*) FROM (
SELECT DISTINCT o.ownerid, 
	CASE WHEN ownerclass = 'H' THEN 'Commercial'
	     WHEN ownerclass = 'F' THEN 'Federal Government - Non Military'
	     WHEN ownerclass IN ('C','L','O','Z') THEN 'Local Government'
	     WHEN ownerclass IN ('M','N','P') THEN 'Private'
	     WHEN ownerclass = 'S' THEN 'State Government - Non Military' END AS OwnerType
FROM tblownertype o JOIN tblFacilityLookup f ON f.ownerid = o.OWNERID 
AND f.ownerinactivewfacility = 0 AND ownerclass IS NOT NULL)
GROUP BY ownerid HAVING count(*) > 1;
TTG

SELECT * FROM  tblOwnerType a JOIN  tblOwnerType b ON a.ownerid = b.OWNERID 
	JOIN tblFacilityLookup o ON a.ownerid = o.OWNERID 
WHERE a.ownerclass = 'F' AND a.ownerclass <> b.ownerclass
AND o.ownerinactivewfacility = 0;
      
SELECT DISTINCT b.ownerclass FROM tblownertype a JOIN  tblOwnerType b ON a.ownerid = b.OWNERID 
JOIN tblFacilityLookup o ON a.ownerid = o.OWNERID
WHERE a.OWNERCLASS  = 'G' AND a.ownerclass <> b.ownerclass
AND o.ownerinactivewfacility = 0
ORDER BY 1;

SELECT * FROM tblownertype WHERE ownerclass  = 'G'  AND ownerid NOT  IN
	(SELECT ownerid FROM tblownertype WHERE ownerclass <> 'G')
      
60705	
46251	


16509


SELECT count(*) 
FROM tblFacility f LEFT JOIN tblFacilityLookup fl ON f.facilityid = fl.facilityid 
LEFT JOIN tblOwner o ON fl.ownerid = o.ownerid
LEFT JOIN (SELECT DISTINCT ownerid FROM tblOwnerType WHERE ownerclass = 'H') commercial ON o.ownerid = commercial.ownerid
LEFT JOIN (SELECT DISTINCT ownerid FROM tblOwnerType WHERE ownerclass = 'F') fed ON o.ownerid = fed.ownerid
LEFT JOIN (SELECT DISTINCT ownerid FROM tblOwnerType WHERE ownerclass IN ('C','L','O','Z')) localg ON o.ownerid = localg.ownerid
LEFT JOIN (SELECT DISTINCT ownerid FROM tblOwnerType WHERE ownerclass IN ('M','N','P')) private ON o.ownerid = private.ownerid
LEFT JOIN (SELECT DISTINCT ownerid FROM tblOwnerType WHERE ownerclass = 'S') state ON o.ownerid = state.ownerid
LEFT JOIN tblTank t ON f.facilityid = t.facilityid
LEFT JOIN tblTankByCompartment tc ON t.tankpk = tc.tankpk 
WHERE ownerinactivewfacility = 0
LEFT JOIN (SELECT TANKPK, COUNT(*) AS NUMCOMPARTMENTS FROM `tblTankByCompartment` GROUP BY TANKPK) TN 
	ON t.tankpk = tn.tankpk
LEFT JOIN (SELECT DISTINCT TANKCOMPARTMENTPK FROM tblTankOverFillProt WHERE TYPEOVERFILLPROT = 1) autoshutoff 
	ON tc.TANKCOMPARTMENTPK = autoshutoff.TANKCOMPARTMENTPK
LEFT JOIN (SELECT DISTINCT TANKCOMPARTMENTPK FROM tblTankOverFillProt WHERE TYPEOVERFILLPROT = 2) ballvalve 
	ON tc.TANKCOMPARTMENTPK = ballvalve.TANKCOMPARTMENTPK	
LEFT JOIN (SELECT DISTINCT TANKCOMPARTMENTPK FROM tblTankOverFillProt WHERE TYPEOVERFILLPROT = 3) alarm 
	ON tc.TANKCOMPARTMENTPK = alarm.TANKCOMPARTMENTPK	
LEFT JOIN (SELECT DISTINCT tankcompartmentpk FROM tblTankRLSDetection WHERE TANKRELEASECODE = 5) interstitial 
	ON tc.TANKCOMPARTMENTPK = interstitial.TANKCOMPARTMENTPK
LEFT JOIN (SELECT DISTINCT tankcompartmentpk FROM tblTankRLSDetection WHERE TANKRELEASECODE = 1) atg  
	ON tc.TANKCOMPARTMENTPK = atg.TANKCOMPARTMENTPK
LEFT JOIN (SELECT DISTINCT tankcompartmentpk FROM tblTankRLSDetection WHERE TANKRELEASECODE = 3) mtg  
	ON tc.TANKCOMPARTMENTPK = mtg.TANKCOMPARTMENTPK
LEFT JOIN (SELECT DISTINCT tankcompartmentpk FROM tblTankRLSDetection WHERE TANKRELEASECODE = 6) sir 
	ON tc.TANKCOMPARTMENTPK = sir.TANKCOMPARTMENTPK
LEFT JOIN (SELECT DISTINCT tankcompartmentpk FROM tblTankRLSDetection WHERE TANKRELEASECODE = 2) tt 
	ON tc.TANKCOMPARTMENTPK = tt.TANKCOMPARTMENTPK
LEFT JOIN (SELECT DISTINCT tankcompartmentpk FROM tblTankRLSDetection WHERE TANKRELEASECODE = 8) gw 
	ON tc.TANKCOMPARTMENTPK = gw.TANKCOMPARTMENTPK
LEFT JOIN (SELECT DISTINCT tankcompartmentpk FROM tblTankRLSDetection WHERE TANKRELEASECODE = 7) vapor 
	ON tc.TANKCOMPARTMENTPK = vapor.TANKCOMPARTMENTPK
LEFT JOIN (SELECT DISTINCT tankcompartmentpk FROM tblTankPipeReleaseDet WHERE PIPERELEASEDETCODE = 1) elld
	ON tc.TANKCOMPARTMENTPK = elld.TANKCOMPARTMENTPK
LEFT JOIN (SELECT DISTINCT tankcompartmentpk FROM tblTankPipeReleaseDet WHERE ELECTRONICORMECHANICALLLD = 2) alld
	ON tc.TANKCOMPARTMENTPK = alld.TANKCOMPARTMENTPK
LEFT JOIN (SELECT DISTINCT tankcompartmentpk FROM tblTankPipeReleaseDet WHERE PIPERELEASEDETCODE = 3) atm
	ON tc.TANKCOMPARTMENTPK = atm.TANKCOMPARTMENTPK
LEFT JOIN (SELECT FACILITYID, max(remid) remid FROM tblRemediation GROUP BY FACILITYID) rem
	ON f.FACILITYID = rem.FACILITYID

select * from tblTank;

select * from tblTankType;




SELECT 
 g.FacilityID as FacilityID,
 t.*
-- CASE WHEN t.status IN ('C','N') THEN 'Currently in use'
--      WHEN t.status = 'P' THEN 'Closed (in place)' 
--      WHEN t.status = 'R' THEN 'Closed (removed from ground)' 
--      WHEN t.status = 'S' THEN '' --CHANGE IN service
--      WHEN t.status = 'T' THEN '' END as TankStatus, --OUT OF use
 
FROM tblFacility f LEFT JOIN tblFacilityLookup fl ON f.facilityid = fl.facilityid 
LEFT JOIN tblOwner o ON fl.ownerid = o.ownerid
LEFT JOIN (SELECT DISTINCT ownerid FROM tblOwnerType WHERE ownerclass = 'H') commercial ON o.ownerid = commercial.ownerid
LEFT JOIN (SELECT DISTINCT ownerid FROM tblOwnerType WHERE ownerclass = 'F') fed ON o.ownerid = fed.ownerid
LEFT JOIN (SELECT DISTINCT ownerid FROM tblOwnerType WHERE ownerclass IN ('C','L','O','Z')) localg ON o.ownerid = localg.ownerid
LEFT JOIN (SELECT DISTINCT ownerid FROM tblOwnerType WHERE ownerclass IN ('M','N','P')) private ON o.ownerid = private.ownerid
LEFT JOIN (SELECT DISTINCT ownerid FROM tblOwnerType WHERE ownerclass = 'S') state ON o.ownerid = state.ownerid
LEFT JOIN tblGeoSite g ON f.FACILITYID  = g.FACILITYID  
LEFT JOIN tblGeoSite_LatLong ll ON f.FACILITYID = ll.FACILITYID
LEFT JOIN tblcounty c ON g.county = c.COUNTYCODE 
LEFT JOIN tblTank t ON f.facilityid = t.facilityid
LEFT JOIN tblTankByCompartment tc ON t.tankpk = tc.tankpk 
LEFT JOIN (SELECT TANKPK, COUNT(*) as NUMCOMPARTMENTS FROM tblTankByCompartment GROUP BY TANKPK) TN 
	ON t.tankpk = tn.tankpk
LEFT JOIN (SELECT DISTINCT TANKCOMPARTMENTPK FROM tblTankOverFillProt WHERE TYPEOVERFILLPROT = 1) autoshutoff 
	ON tc.TANKCOMPARTMENTPK = autoshutoff.TANKCOMPARTMENTPK
LEFT JOIN (SELECT DISTINCT TANKCOMPARTMENTPK FROM tblTankOverFillProt WHERE TYPEOVERFILLPROT = 2) ballvalve 
	ON tc.TANKCOMPARTMENTPK = ballvalve.TANKCOMPARTMENTPK	
LEFT JOIN (SELECT DISTINCT TANKCOMPARTMENTPK FROM tblTankOverFillProt WHERE TYPEOVERFILLPROT = 3) alarm 
	ON tc.TANKCOMPARTMENTPK = alarm.TANKCOMPARTMENTPK	
LEFT JOIN (SELECT DISTINCT tankcompartmentpk FROM tblTankRLSDetection WHERE TANKRELEASECODE = 5) interstitial 
	ON tc.TANKCOMPARTMENTPK = interstitial.TANKCOMPARTMENTPK
LEFT JOIN (SELECT DISTINCT tankcompartmentpk FROM tblTankRLSDetection WHERE TANKRELEASECODE = 1) atg  
	ON tc.TANKCOMPARTMENTPK = atg.TANKCOMPARTMENTPK
LEFT JOIN (SELECT DISTINCT tankcompartmentpk FROM tblTankRLSDetection WHERE TANKRELEASECODE = 3) mtg  
	ON tc.TANKCOMPARTMENTPK = mtg.TANKCOMPARTMENTPK
LEFT JOIN (SELECT DISTINCT tankcompartmentpk FROM tblTankRLSDetection WHERE TANKRELEASECODE = 6) sir 
	ON tc.TANKCOMPARTMENTPK = sir.TANKCOMPARTMENTPK
LEFT JOIN (SELECT DISTINCT tankcompartmentpk FROM tblTankRLSDetection WHERE TANKRELEASECODE = 2) tt 
	ON tc.TANKCOMPARTMENTPK = tt.TANKCOMPARTMENTPK
LEFT JOIN (SELECT DISTINCT tankcompartmentpk FROM tblTankRLSDetection WHERE TANKRELEASECODE = 8) gw 
	ON tc.TANKCOMPARTMENTPK = gw.TANKCOMPARTMENTPK
LEFT JOIN (SELECT DISTINCT tankcompartmentpk FROM tblTankRLSDetection WHERE TANKRELEASECODE = 7) vapor 
	ON tc.TANKCOMPARTMENTPK = vapor.TANKCOMPARTMENTPK
LEFT JOIN (SELECT DISTINCT tankcompartmentpk FROM tblTankPipeReleaseDet WHERE PIPERELEASEDETCODE = 1) elld
	ON tc.TANKCOMPARTMENTPK = elld.TANKCOMPARTMENTPK
LEFT JOIN (SELECT DISTINCT tankcompartmentpk FROM tblTankPipeReleaseDet WHERE ELECTRONICORMECHANICALLLD = 2) alld
	ON tc.TANKCOMPARTMENTPK = alld.TANKCOMPARTMENTPK
LEFT JOIN (SELECT DISTINCT tankcompartmentpk FROM tblTankPipeReleaseDet WHERE PIPERELEASEDETCODE = 3) atm
	ON tc.TANKCOMPARTMENTPK = atm.TANKCOMPARTMENTPK
LEFT JOIN (SELECT FACILITYID, max(remid) remid FROM tblRemediation GROUP BY FACILITYID) rem
	ON f.FACILITYID = rem.FACILITYID
WHERE ownerinactivewfacility = 0 and  t.status = 'S';



	----------------------------------------------------------------------------
	
SELECT * FROM `tblMediaAffected` ;	

SELECT * FROM `tblReleaseSiteType` 
A	Above Ground
B	Both Above Below
U	Below Ground
X	UNKNOWN

SELECT * FROM `tblRemediationTechniques` WHERE id IN (SELECT remtechid FROM `tblRemTech`)
0	Air Sparging
1	Phase I
2	Source Investigation
3	CA
4	Groundwater Monitoring
5	Free Product Recovery
6	Excavation
7	Other
8	Dual  Phase
9	Soil Vapor Extraction
A	Pump & Treat
B	Natural Attenuation
D	Land Farming
E	Tank Closure
F	Land Fill
S	Exsitu Soil Wash
T	Exsitu Thermal
W	High Vacuum Extraction
Z	Oxygen Releasing Material

SELECT * FROM tblremtech;

SELECT releaseid, count(*) FROM `tblRemediationSource` GROUP BY releaseid;
2	540
7	2391
3	54
4	20
5	25
1	564
6	54

SELECT remid, releaseid, count(*) FROM (SELECT DISTINCT remid, releaseid FROM `tblRemediationSource`)
GROUP BY remid, releaseid HAVING count(*) > 1;

SELECT remid, remcauseid, count(*) FROM (SELECT DISTINCT remid, remcauseid FROM `tblRemediationCause`)
GROUP BY remid, remcauseid HAVING count(*) > 1;

SELECT remid, remtechid, count(*) FROM (SELECT DISTINCT remid, remtechid FROM `tblRemTech`)
GROUP BY remid, remtechid HAVING count(*) > 1;

SELECT * FROM `tblRemediationSource`  WHERE remid IN ('R006863', 'R008803');

SELECT * FROM `tblRemediationTechniques` 

SELECT remid, comments FROM `tblRemediation`  WHERE lower(comments) LIKE '%> dtl%'

SELECT * FROM `tblRemediation` 

SELECT REMID  
FROM `tblRemediationSource` s WHERE 

SELECT * FROM tblgeosite;

SELECT * FROM TBLGEOSOURCECODE ;

SELECT * FROM `tblSpillSource` ORDER BY 2;

SELECT * FROM `tblSpillCause` ORDER BY 2;

SELECT * FROM `tblReleaseSiteType` ;

SELECT * FROM `tblRemediationSource` ;

SELECT * FROM `tblRemReferred` ;
SELECT facilityid, count(*) FROM tblgeosite GROUP BY FACILITYID HAVING count(*) > 1;