create or replace view "or_ust"."v_ust" as
 SELECT DISTINCT NULL::integer AS ust_id,
    NULL::integer AS ust_facilities_id,
    (f.facilityid)::character varying AS "FacilityID",
    (f."Name")::character varying AS "FacilityName",
    (ot.epa_value)::character varying AS "OwnerType",
    NULL::character varying AS "FacilityType1",
    NULL::character varying AS "FacilityType2",
    loc.line_1_addr AS "FacilityAddress1",
    NULL::character varying AS "FacilityAddress2",
    loc.city_txt AS "FacilityCity",
    NULL::character varying AS "FacilityCounty",
    loc.zip_cd AS "FacilityZipCode",
    NULL::character varying AS "FacilityPhoneNumber",
    'OR'::text AS "FacilityState",
    10 AS "FacilityEPARegion",
    (fts.epa_value)::character varying AS "FacilityTribalSite",
    NULL::character varying AS "FacilityTribe",
    (loc.lat_decimal_coord)::double precision AS "FacilityLatitude",
    (loc.long_decimal_coord)::double precision AS "FacilityLongitude",
    'Unknown'::text AS "FacilityCoordinateSource",
    NULL::character varying AS "FacilityOwnerCompanyName",
    (o.lastname)::character varying AS "FacilityOwnerLastName",
    (o.firstname)::character varying AS "FacilityOwnerFirstName",
    (o.street)::character varying AS "FacilityOwnerAddress1",
    NULL::character varying AS "FacilityOwnerAddress2",
    (o.city)::character varying AS "FacilityOwnerCity",
    NULL::character varying AS "FacilityOwnerCounty",
    (o.zip)::character varying AS "FacilityOwnerZipCode",
    (o.state)::character varying AS "FacilityOwnerState",
    (o.phone)::character varying AS "FacilityOwnerPhoneNumber",
    NULL::character varying AS "FacilityOwnerEmail",
    NULL::character varying AS "FacilityOperatorCompanyName",
    (p.lastname)::character varying AS "FacilityOperatorLastName",
    (p.firstname)::character varying AS "FacilityOperatorFirstName",
    (p.street)::character varying AS "FacilityOperatorAddress1",
    NULL::character varying AS "FacilityOperatorAddress2",
    (p.city)::character varying AS "FacilityOperatorCity",
    NULL::character varying AS "FacilityOperatorCounty",
    (p.zip)::character varying AS "FacilityOperatorZipCode",
    (p.state)::character varying AS "FacilityOperatorState",
    (p.phone)::character varying AS "FacilityOperatorPhoneNumber",
    NULL::character varying AS "FacilityOperatorEmail",
    NULL::character varying AS "FinancialResponsibilityBondRatingTest",
    NULL::character varying AS "FinancialResponsibilityCommercialInsurance",
    (frg.epa_value)::character varying AS "FinancialResponsibilityGuarantee",
    (frlc.epa_value)::character varying AS "FinancialResponsibilityLetterOfCredit",
    (frlg.epa_value)::character varying AS "FinancialResponsibilityLocalGovernmentFinancialTest",
    NULL::character varying AS "FinancialResponsibilityRiskRetentionGroup",
    (frsi.epa_value)::character varying AS "FinancialResponsibilitySelfInsuranceFinancialTest",
    NULL::character varying AS "FinancialResponsibilityStateFund",
    (frsb.epa_value)::character varying AS "FinancialResponsibilitySuretyBond",
    (frtf.epa_value)::character varying AS "FinancialResponsibilityTrustFund",
    (fro.epa_value)::character varying AS "FinancialResponsibilityOtherMethod",
    NULL::character varying AS "FinancialResponsibilityNotRequired",
        CASE
            WHEN (fr.facilityid IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS "FinancialResponsibilityObtained",
    NULL::character varying AS "Compliance",
    (t.tankcode)::character varying AS "TankID",
    NULL::character varying AS "TankLocation",
    (freg.epa_value)::character varying AS "FederallyRegulated",
    (ts.epa_value)::character varying AS "TankStatus",
    NULL::character varying AS "FieldConstructed",
    NULL::character varying AS "EmergencyGenerator",
    NULL::character varying AS "AirportHydrantSystem",
    (mt.epa_value)::character varying AS "MultipleTanks",
    (t.decommissiondate)::date AS "ClosureDate",
    NULL::date AS "InstallationDate",
    NULL::character varying AS "CompartmentalizedUST",
    NULL::integer AS "NumberOfCompartments",
    (tsub.epa_value)::character varying AS "TankSubstanceStored",
    NULL::character varying AS "CompartmentID",
    NULL::character varying AS "CompartmentSubstanceStored",
    NULL::integer AS "TankCapacityGallons",
    NULL::integer AS "CompartmentCapacityGallons",
    (lt.epa_value)::character varying AS "LinedTank",
    (el.epa_value)::character varying AS "ExcavationLiner",
    (wt.epa_value)::character varying AS "TankWallType",
    (md.epa_value)::character varying AS "MaterialDescription",
        CASE
            WHEN (t.tanklastrepairdate IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS "TankRepaired",
    (t.tanklastrepairdate)::date AS "TankRepairDate",
    NULL::character varying AS "CertOfInstallation",
    (pmd.epa_value)::character varying AS "PipingMaterialDescription",
    NULL::character varying AS "PipingFlexConnector",
    (ps.epa_value)::character varying AS "PipingStyle",
    NULL::character varying AS "PipingWallType",
    NULL::character varying AS "PipingUDC",
        CASE
            WHEN (t.pipelastrepairdate IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS "PipingRepaired",
    (t.pipelastrepairdate)::date AS "PipingRepairDate",
    (tcpsa.epa_value)::character varying AS "TankCorrosionProtectionSacrificialAnode",
        CASE
            WHEN (tcpsa.epa_value IS NOT NULL) THEN 'Unknown'::text
            ELSE NULL::text
        END AS "TankCorrosionProtectionAnodeInstalledOrRetrofitted",
    (tcpic.epa_value)::character varying AS "TankCorrosionProtectionImpressedCurrent",
        CASE
            WHEN (tcpic.epa_value IS NOT NULL) THEN 'Unknown'::text
            ELSE NULL::text
        END AS "TankCorrosionProtectionImpressedCurrentInstalledOrRetrofitted",
    NULL::character varying AS "TankCorrosionProtectionCathodicNotRequired",
    NULL::character varying AS "TankCorrosionProtectionInteriorLining",
    NULL::character varying AS "TankCorrosionProtectionOther",
    NULL::character varying AS "TankCorrosionProtectionUnknown",
    NULL::character varying AS "TankCorrosionProtectionLinedPostinstallation",
    NULL::character varying AS "PipingCorrosionProtectionSacrificialAnode",
    NULL::character varying AS "PipingCorrosionProtectionAnodeInstalledOrRetrofitted",
    NULL::character varying AS "PipingCorrosionProtectionImpressedCurrent",
    NULL::character varying AS "PipingCorrosionProtectionImpressedCurrentInstalledOrRetrofitted",
    NULL::character varying AS "PipingCorrosionProtectionCathodicNotRequired",
    NULL::character varying AS "PipingCorrosionProtectionExternalCoating",
    NULL::character varying AS "PipingCorrosionProtectionOther",
    NULL::character varying AS "PipingCorrosionProtectionUnknown",
    (bfv.epa_value)::character varying AS "BallFloatValve",
    (fsd.epa_value)::character varying AS "FlowShutoffDevice",
    (hla.epa_value)::character varying AS "HighLevelAlarm",
    NULL::character varying AS "OverfillProtectionPrimary",
    NULL::character varying AS "OverfillProtectionSecondary",
    NULL::date AS "PrimaryOverfillInstallDate",
    NULL::date AS "SecondaryOverfillInstallDate",
    (sb.epa_value)::character varying AS "SpillBucketInstalled",
    NULL::character varying AS "SpillBucketWallType",
    NULL::character varying AS "DrainPresent",
    NULL::character varying AS "PumpPresent",
    NULL::character varying AS "InterstitialMonitoringContinualElectric",
    NULL::character varying AS "InterstitialMonitoringManual",
    (atg.epa_value)::character varying AS "AutomaticTankGauging",
    NULL::character varying AS "AutomaticTankGaugingReleaseDetection",
    NULL::character varying AS "AutomaticTankGaugingContinuousLeakDetection",
    (mtg.epa_value)::character varying AS "ManualTankGauging",
    (sir.epa_value)::character varying AS "StatisticalInventoryReconciliation",
    (tt.epa_value)::character varying AS "TankTightnessTesting",
    (gw.epa_value)::character varying AS "GroundwaterMonitoring",
    NULL::character varying AS "SubpartK",
    (vm.epa_value)::character varying AS "VaporMonitoring",
    (ell.epa_value)::character varying AS "ElectronicLineLeak",
    (mll.epa_value)::character varying AS "MechanicalLineLeak",
    (im.epa_value)::character varying AS "AutomatedIntersticialMonitoring",
    (ss.epa_value)::character varying AS "SafeSuction",
    (us.epa_value)::character varying AS "AmericanSuction",
    NULL::character varying AS "PipingSubpartK",
    (hp.epa_value)::character varying AS "HighPressure",
    NULL::character varying AS "PrimaryReleaseDetectionType",
    NULL::character varying AS "SecondReleaseDetectionType",
    NULL::character varying AS "PipeSecondaryContainment",
    NULL::date AS "PipeInstallDate",
    NULL::character varying AS "USTReportedRelease",
    NULL::character varying AS "AssociatedLUSTID",
    NULL::date AS "LastInspectionDate"
   FROM ((((((((((((((((((((((((((((((((((((((((((((((((((or_ust.facility f
     LEFT JOIN or_ust.businesstype b ON ((f.businesstype = b."BusinessType")))
     LEFT JOIN ( SELECT v_ust_element_mapping.state_value,
            v_ust_element_mapping.epa_value
           FROM archive.v_ust_element_mapping
          WHERE ((v_ust_element_mapping.control_id = 7) AND ((v_ust_element_mapping.element_name)::text = 'FacilityTribalSite'::text))) fts ON ((((f.isindianland)::character varying)::text = (fts.state_value)::text)))
     LEFT JOIN archive.v_ust_element_mapping ot ON ((((ot.state_value)::text = b."Name") AND (ot.control_id = 7) AND ((ot.element_name)::text = 'OwerType'::text))))
     LEFT JOIN or_ust.owners_and_permittees_locations loc ON ((f.facilityid = loc.facilityid)))
     LEFT JOIN ( SELECT DISTINCT owners_and_permittees.facilityid,
            owners_and_permittees.firstname,
            owners_and_permittees.lastname,
            owners_and_permittees.phone,
            owners_and_permittees.street,
            owners_and_permittees.city,
            owners_and_permittees.state,
            owners_and_permittees.zip
           FROM or_ust.owners_and_permittees
          WHERE ((owners_and_permittees.affiltypecd)::text = 'OWN'::text)) o ON ((f.facilityid = o.facilityid)))
     LEFT JOIN ( SELECT DISTINCT owners_and_permittees.facilityid,
            owners_and_permittees.firstname,
            owners_and_permittees.lastname,
            owners_and_permittees.phone,
            owners_and_permittees.street,
            owners_and_permittees.city,
            owners_and_permittees.state,
            owners_and_permittees.zip
           FROM or_ust.owners_and_permittees
          WHERE ((owners_and_permittees.affiltypecd)::text = 'PMT'::text)) p ON ((f.facilityid = p.facilityid)))
     LEFT JOIN ( SELECT DISTINCT a.facilityid,
            c.epa_value
           FROM ((or_ust.financialresponsibility a
             JOIN or_ust.financialresponsibilitytype b_1 ON ((a.financialresponsibilitytypeid = b_1.financialresponsibilitytypeid)))
             JOIN archive.v_ust_element_mapping c ON ((((b_1."Name")::text = (c.state_value)::text) AND (c.control_id = 7) AND ((c.element_name)::text = 'FinancialResponsibilityGuarantee'::text))))) frg ON ((f.facilityid = frg.facilityid)))
     LEFT JOIN ( SELECT DISTINCT a.facilityid,
            c.epa_value
           FROM ((or_ust.financialresponsibility a
             JOIN or_ust.financialresponsibilitytype b_1 ON ((a.financialresponsibilitytypeid = b_1.financialresponsibilitytypeid)))
             JOIN archive.v_ust_element_mapping c ON ((((b_1."Name")::text = (c.state_value)::text) AND (c.control_id = 7) AND ((c.element_name)::text = 'FinancialResponsibilityLetterOfCredit'::text))))) frlc ON ((f.facilityid = frlc.facilityid)))
     LEFT JOIN ( SELECT DISTINCT a.facilityid,
            c.epa_value
           FROM ((or_ust.financialresponsibility a
             JOIN or_ust.financialresponsibilitytype b_1 ON ((a.financialresponsibilitytypeid = b_1.financialresponsibilitytypeid)))
             JOIN archive.v_ust_element_mapping c ON ((((b_1."Name")::text = (c.state_value)::text) AND (c.control_id = 7) AND ((c.element_name)::text = 'FinancialResponsibilityLocalGovernmentFinancialTest'::text))))) frlg ON ((f.facilityid = frlg.facilityid)))
     LEFT JOIN ( SELECT DISTINCT a.facilityid,
            c.epa_value
           FROM ((or_ust.financialresponsibility a
             JOIN or_ust.financialresponsibilitytype b_1 ON ((a.financialresponsibilitytypeid = b_1.financialresponsibilitytypeid)))
             JOIN archive.v_ust_element_mapping c ON ((((b_1."Name")::text = (c.state_value)::text) AND (c.control_id = 7) AND ((c.element_name)::text = 'FinancialResponsibilitySelfInsuranceFinancialTest'::text))))) frsi ON ((f.facilityid = frsi.facilityid)))
     LEFT JOIN ( SELECT DISTINCT a.facilityid,
            c.epa_value
           FROM ((or_ust.financialresponsibility a
             JOIN or_ust.financialresponsibilitytype b_1 ON ((a.financialresponsibilitytypeid = b_1.financialresponsibilitytypeid)))
             JOIN archive.v_ust_element_mapping c ON ((((b_1."Name")::text = (c.state_value)::text) AND (c.control_id = 7) AND ((c.element_name)::text = 'FinancialResponsibilitySuretyBond'::text))))) frsb ON ((f.facilityid = frsb.facilityid)))
     LEFT JOIN ( SELECT DISTINCT a.facilityid,
            c.epa_value
           FROM ((or_ust.financialresponsibility a
             JOIN or_ust.financialresponsibilitytype b_1 ON ((a.financialresponsibilitytypeid = b_1.financialresponsibilitytypeid)))
             JOIN archive.v_ust_element_mapping c ON ((((b_1."Name")::text = (c.state_value)::text) AND (c.control_id = 7) AND ((c.element_name)::text = 'FinancialResponsibilityTrustFund'::text))))) frtf ON ((f.facilityid = frtf.facilityid)))
     LEFT JOIN ( SELECT DISTINCT a.facilityid,
            c.epa_value
           FROM ((or_ust.financialresponsibility a
             JOIN or_ust.financialresponsibilitytype b_1 ON ((a.financialresponsibilitytypeid = b_1.financialresponsibilitytypeid)))
             JOIN archive.v_ust_element_mapping c ON ((((b_1."Name")::text = (c.state_value)::text) AND (c.control_id = 7) AND ((c.element_name)::text = 'FinancialResponsibilityOtherMethod'::text))))) fro ON ((f.facilityid = fro.facilityid)))
     LEFT JOIN ( SELECT DISTINCT financialresponsibility.facilityid
           FROM or_ust.financialresponsibility) fr ON ((f.facilityid = fr.facilityid)))
     LEFT JOIN or_ust.tank t ON ((f.facilityid = t.facilityid)))
     LEFT JOIN ( SELECT a.tankstatustypeid,
            b_1.epa_value
           FROM (or_ust.tankstatustype a
             JOIN archive.v_ust_element_mapping b_1 ON ((((a."Name")::text = (b_1.state_value)::text) AND (b_1.control_id = 7) AND ((b_1.element_name)::text = 'TankStatus'::text))))) ts ON ((t.tankstatustypeid = ts.tankstatustypeid)))
     LEFT JOIN ( SELECT DISTINCT a.tankid,
            c.epa_value
           FROM ((or_ust.tankconstruction a
             JOIN or_ust.constructiontype b_1 ON ((a.constructiontypeid = b_1.constructiontypeid)))
             JOIN archive.v_ust_element_mapping c ON ((((b_1."Name")::text = (c.state_value)::text) AND (c.control_id = 7) AND ((c.element_name)::text = 'MultipleTanks'::text))))) mt ON ((t.tankid = mt.tankid)))
     LEFT JOIN ( SELECT DISTINCT a.tankid,
            c.epa_value
           FROM ((or_ust.tanksubstance a
             JOIN or_ust.substancetype b_1 ON ((a.substancetypeid = b_1.substancetypeid)))
             JOIN archive.v_ust_element_mapping c ON ((((b_1."Name")::text = (c.state_value)::text) AND (c.control_id = 7) AND ((c.element_name)::text = 'TankSubstanceStored'::text))))) tsub ON ((t.tankid = tsub.tankid)))
     LEFT JOIN ( SELECT DISTINCT a.tankid,
            c.epa_value
           FROM ((or_ust.tankconstruction a
             JOIN or_ust.constructiontype b_1 ON ((a.constructiontypeid = b_1.constructiontypeid)))
             JOIN archive.v_ust_element_mapping c ON ((((b_1."Name")::text = (c.state_value)::text) AND (c.control_id = 7) AND ((c.element_name)::text = 'LinedTank'::text))))) lt ON ((t.tankid = lt.tankid)))
     LEFT JOIN ( SELECT DISTINCT a.tankid,
            c.epa_value
           FROM ((or_ust.tankconstruction a
             JOIN or_ust.constructiontype b_1 ON ((a.constructiontypeid = b_1.constructiontypeid)))
             JOIN archive.v_ust_element_mapping c ON ((((b_1."Name")::text = (c.state_value)::text) AND (c.control_id = 7) AND ((c.element_name)::text = 'ExcavationLiner'::text))))) el ON ((t.tankid = el.tankid)))
     LEFT JOIN ( SELECT DISTINCT a.tankid,
            c.epa_value
           FROM ((or_ust.tankconstruction a
             JOIN or_ust.constructiontype b_1 ON ((a.constructiontypeid = b_1.constructiontypeid)))
             JOIN archive.v_ust_element_mapping c ON ((((b_1."Name")::text = (c.state_value)::text) AND (c.control_id = 7) AND ((c.element_name)::text = 'TankWallType'::text))))) wt ON ((t.tankid = wt.tankid)))
     LEFT JOIN ( SELECT DISTINCT a.tankid,
            c.epa_value
           FROM ((or_ust.tankconstruction a
             JOIN or_ust.constructiontype b_1 ON ((a.constructiontypeid = b_1.constructiontypeid)))
             JOIN archive.v_ust_element_mapping c ON ((((b_1."Name")::text = (c.state_value)::text) AND (c.control_id = 7) AND ((c.element_name)::text = 'MaterialDescription'::text))))) md ON ((t.tankid = md.tankid)))
     LEFT JOIN ( SELECT DISTINCT a.tankid,
            c.epa_value
           FROM ((or_ust.tankconstruction a
             JOIN or_ust.constructiontype b_1 ON ((a.constructiontypeid = b_1.constructiontypeid)))
             JOIN archive.v_ust_element_mapping c ON ((((b_1."Name")::text = (c.state_value)::text) AND (c.control_id = 7) AND ((c.element_name)::text = 'PipingMaterialDescription'::text))))) pmd ON ((t.tankid = pmd.tankid)))
     LEFT JOIN ( SELECT DISTINCT a.tankid,
            c.epa_value
           FROM ((or_ust.tankpipingtype a
             JOIN or_ust.pipingtype b_1 ON ((a.pipingtypeid = b_1.pipingtypeid)))
             JOIN archive.v_ust_element_mapping c ON ((((b_1."Name")::text = (c.state_value)::text) AND (c.control_id = 7) AND ((c.element_name)::text = 'PipingStyle'::text))))
          WHERE (b_1.isactive = '1'::"bit")) ps ON ((t.tankid = ps.tankid)))
     LEFT JOIN or_ust.corrosionprotectiontype cpt ON ((cpt."CorrosionProtectionType" = t.corrosionprotectiontypeid)))
     LEFT JOIN ( SELECT DISTINCT a.spilldevicetypeid,
            b_1.epa_value
           FROM (or_ust.spilldevicetype a
             JOIN archive.v_ust_element_mapping b_1 ON ((((a."Name")::text = (b_1.state_value)::text) AND (b_1.control_id = 7) AND ((b_1.element_name)::text = 'SpillBucketInstalled'::text))))) sb ON ((t.spilldevicetypeid = sb.spilldevicetypeid)))
     LEFT JOIN ( SELECT DISTINCT a.tankid,
            c.epa_value
           FROM ((or_ust.tankreleasedetection a
             JOIN or_ust.releasedetectiontype b_1 ON ((a.releasedetectiontypeid = b_1.releasedetectiontypeid)))
             JOIN archive.v_ust_element_mapping c ON ((((b_1."Name")::text = (c.state_value)::text) AND (c.control_id = 7) AND ((c.element_name)::text = 'AutomaticTankGauging'::text) AND ((c.state_value)::text = 'Automatic tank gauging'::text))))) atg ON ((t.tankid = atg.tankid)))
     LEFT JOIN ( SELECT DISTINCT a.tankid,
            c.epa_value
           FROM ((or_ust.tankreleasedetection a
             JOIN or_ust.releasedetectiontype b_1 ON ((a.releasedetectiontypeid = b_1.releasedetectiontypeid)))
             JOIN archive.v_ust_element_mapping c ON ((((b_1."Name")::text = (c.state_value)::text) AND (c.control_id = 7) AND ((c.element_name)::text = 'ManualTankGauging'::text) AND ((c.state_value)::text = 'Manual tank gauging'::text))))) mtg ON ((t.tankid = mtg.tankid)))
     LEFT JOIN ( SELECT DISTINCT a.tankid,
            c.epa_value
           FROM ((or_ust.tankreleasedetection a
             JOIN or_ust.releasedetectiontype b_1 ON ((a.releasedetectiontypeid = b_1.releasedetectiontypeid)))
             JOIN archive.v_ust_element_mapping c ON ((((b_1."Name")::text = (c.state_value)::text) AND (c.control_id = 7) AND ((c.element_name)::text = 'StatisticalInventoryReconciliation'::text) AND ((c.state_value)::text = 'SIR'::text))))) sir ON ((t.tankid = sir.tankid)))
     LEFT JOIN ( SELECT DISTINCT a.tankid,
            c.epa_value
           FROM ((or_ust.tankreleasedetection a
             JOIN or_ust.releasedetectiontype b_1 ON ((a.releasedetectiontypeid = b_1.releasedetectiontypeid)))
             JOIN archive.v_ust_element_mapping c ON ((((b_1."Name")::text = (c.state_value)::text) AND (c.control_id = 7) AND ((c.element_name)::text = 'TankTightnessTesting'::text) AND ((c.state_value)::text = 'Tank tightness testing'::text))))) tt ON ((t.tankid = tt.tankid)))
     LEFT JOIN ( SELECT DISTINCT a.tankid,
            c.epa_value
           FROM ((or_ust.tankreleasedetection a
             JOIN or_ust.releasedetectiontype b_1 ON ((a.releasedetectiontypeid = b_1.releasedetectiontypeid)))
             JOIN archive.v_ust_element_mapping c ON ((((b_1."Name")::text = (c.state_value)::text) AND (c.control_id = 7) AND ((c.element_name)::text = 'GroundwaterMonitoring'::text) AND ((c.state_value)::text = 'Groundwater monitoring'::text))))) gw ON ((t.tankid = gw.tankid)))
     LEFT JOIN ( SELECT DISTINCT a.tankid,
            c.epa_value
           FROM ((or_ust.tankreleasedetection a
             JOIN or_ust.releasedetectiontype b_1 ON ((a.releasedetectiontypeid = b_1.releasedetectiontypeid)))
             JOIN archive.v_ust_element_mapping c ON ((((b_1."Name")::text = (c.state_value)::text) AND (c.control_id = 7) AND ((c.element_name)::text = 'VaporMonitoring'::text) AND ((c.state_value)::text = 'Vapor monitoring'::text))))) vm ON ((t.tankid = vm.tankid)))
     LEFT JOIN ( SELECT DISTINCT a.tankid,
            c.epa_value
           FROM ((or_ust.tankreleasedetection a
             JOIN or_ust.releasedetectiontype b_1 ON ((a.releasedetectiontypeid = b_1.releasedetectiontypeid)))
             JOIN archive.v_ust_element_mapping c ON ((((b_1."Name")::text = (c.state_value)::text) AND (c.control_id = 7) AND ((c.element_name)::text = 'ElectronicLineLeak'::text) AND ((c.state_value)::text = 'Electronic'::text))))) ell ON ((t.tankid = ell.tankid)))
     LEFT JOIN ( SELECT DISTINCT a.tankid,
            c.epa_value
           FROM ((or_ust.tankreleasedetection a
             JOIN or_ust.releasedetectiontype b_1 ON ((a.releasedetectiontypeid = b_1.releasedetectiontypeid)))
             JOIN archive.v_ust_element_mapping c ON ((((b_1."Name")::text = (c.state_value)::text) AND (c.control_id = 7) AND ((c.element_name)::text = 'MechanicalLineLeak'::text) AND ((c.state_value)::text = 'Mechanical'::text))))) mll ON ((t.tankid = mll.tankid)))
     LEFT JOIN ( SELECT DISTINCT a.tankid,
            c.epa_value
           FROM ((or_ust.tankreleasedetection a
             JOIN or_ust.releasedetectiontype b_1 ON ((a.releasedetectiontypeid = b_1.releasedetectiontypeid)))
             JOIN archive.v_ust_element_mapping c ON ((((b_1."Name")::text = (c.state_value)::text) AND (c.control_id = 7) AND ((c.element_name)::text = 'AutomatedIntersticialMonitoring'::text) AND ((c.state_value)::text = 'Interstitial Monitoring'::text))))) im ON ((t.tankid = im.tankid)))
     LEFT JOIN ( SELECT DISTINCT a.tankid,
            c.epa_value
           FROM ((or_ust.tankpipingtype a
             JOIN or_ust.pipingtype b_1 ON ((a.pipingtypeid = b_1.pipingtypeid)))
             JOIN archive.v_ust_element_mapping c ON ((((b_1."Name")::text = (c.state_value)::text) AND (c.control_id = 7) AND ((c.element_name)::text = 'SafeSuction'::text) AND ((c.state_value)::text = '"Safe Suction" (no valve at tank)'::text))))) ss ON ((t.tankid = ss.tankid)))
     LEFT JOIN ( SELECT DISTINCT a.tankid,
            c.epa_value
           FROM ((or_ust.tankpipingtype a
             JOIN or_ust.pipingtype b_1 ON ((a.pipingtypeid = b_1.pipingtypeid)))
             JOIN archive.v_ust_element_mapping c ON ((((b_1."Name")::text = (c.state_value)::text) AND (c.control_id = 7) AND ((c.element_name)::text = 'AmericanSuction'::text) AND ((c.state_value)::text = '"U.S. Suction" (valve at tank)'::text))))) us ON ((t.tankid = us.tankid)))
     LEFT JOIN ( SELECT DISTINCT a.tankid,
            c.epa_value
           FROM ((or_ust.tankpipingtype a
             JOIN or_ust.pipingtype b_1 ON ((a.pipingtypeid = b_1.pipingtypeid)))
             JOIN archive.v_ust_element_mapping c ON ((((b_1."Name")::text = (c.state_value)::text) AND (c.control_id = 7) AND ((c.element_name)::text = 'HighPressure'::text) AND ((c.state_value)::text = 'Pressure'::text))))) hp ON ((t.tankid = hp.tankid)))
     LEFT JOIN or_ust.tankstatustype tst ON ((t.tankstatustypeid = tst.tankstatustypeid)))
     LEFT JOIN or_ust.corrosionprotectiontype cptt ON ((t.corrosionprotectiontypeid = cptt."CorrosionProtectionType")))
     LEFT JOIN ( SELECT v_ust_element_mapping.state_value,
            v_ust_element_mapping.epa_value
           FROM archive.v_ust_element_mapping
          WHERE ((v_ust_element_mapping.control_id = 7) AND ((v_ust_element_mapping.element_name)::text = 'TankCorrosionProtectionSacrificialAnode'::text))) tcpsa ON (((tcpsa.state_value)::text = cptt."Name")))
     LEFT JOIN or_ust.corrosionprotectiontype cptt2 ON ((t.corrosionprotectiontypeid = cptt."CorrosionProtectionType")))
     LEFT JOIN ( SELECT v_ust_element_mapping.state_value,
            v_ust_element_mapping.epa_value
           FROM archive.v_ust_element_mapping
          WHERE ((v_ust_element_mapping.control_id = 7) AND ((v_ust_element_mapping.element_name)::text = 'TankCorrosionProtectionImpressedCurrent'::text))) tcpic ON (((tcpic.state_value)::text = cptt2."Name")))
     LEFT JOIN ( SELECT v_ust_element_mapping.state_value,
            v_ust_element_mapping.epa_value
           FROM archive.v_ust_element_mapping
          WHERE ((v_ust_element_mapping.control_id = 7) AND ((v_ust_element_mapping.element_name)::text = 'FederallyRegulated'::text))) freg ON (((freg.state_value)::text = ((f.isregulatedfacility)::character varying)::text)))
     LEFT JOIN or_ust.overfilldevicetype odtt ON ((t.overfilldevicetypeid = odtt.overfilldevicetypeid)))
     LEFT JOIN ( SELECT v_ust_element_mapping.state_value,
            v_ust_element_mapping.epa_value
           FROM archive.v_ust_element_mapping
          WHERE ((v_ust_element_mapping.control_id = 7) AND ((v_ust_element_mapping.element_name)::text = 'BallFloatValve'::text))) bfv ON (((bfv.state_value)::text = ((odtt.overfilldevicetypeid)::character varying)::text)))
     LEFT JOIN or_ust.overfilldevicetype odtt2 ON ((t.overfilldevicetypeid = odtt.overfilldevicetypeid)))
     LEFT JOIN ( SELECT v_ust_element_mapping.state_value,
            v_ust_element_mapping.epa_value
           FROM archive.v_ust_element_mapping
          WHERE ((v_ust_element_mapping.control_id = 7) AND ((v_ust_element_mapping.element_name)::text = 'FlowShutoffDevice'::text))) fsd ON (((fsd.state_value)::text = ((odtt2.overfilldevicetypeid)::character varying)::text)))
     LEFT JOIN or_ust.overfilldevicetype odtt3 ON ((t.overfilldevicetypeid = odtt.overfilldevicetypeid)))
     LEFT JOIN ( SELECT v_ust_element_mapping.state_value,
            v_ust_element_mapping.epa_value
           FROM archive.v_ust_element_mapping
          WHERE ((v_ust_element_mapping.control_id = 7) AND ((v_ust_element_mapping.element_name)::text = 'HighLevelAlarm'::text))) hla ON (((hla.state_value)::text = ((odtt3.overfilldevicetypeid)::character varying)::text)))
  WHERE ((tst."Name")::text <> ALL (ARRAY[('Unregulated'::character varying)::text, ('Change in Service'::character varying)::text]));