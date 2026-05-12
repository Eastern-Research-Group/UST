create or replace view "or_release"."v_lust_base" as
 SELECT DISTINCT (i."FacilityId")::text AS "FacilityID",
    (i."LustId")::text AS "LUSTID",
        CASE
            WHEN (i."RegulatedTankInd" = true) THEN 'Yes'::text
            WHEN (i."RegulatedTankInd" = false) THEN 'No'::text
            ELSE NULL::text
        END AS "FederallyReportableRelease",
    i."SiteName",
    i."SiteAddress",
    i."SiteCity",
    i."SiteZip" AS "Zipcode",
    'OR'::text AS "State",
    10 AS "EPARegion",
        CASE
            WHEN (m."ClosedDate" IS NULL) THEN 'Active: general'::text
            ELSE 'No further action'::text
        END AS "LUSTStatus",
    (i."ReceivedDate")::date AS "ReportedDate",
    (m."ClosedDate")::date AS "NFADate",
        CASE
            WHEN (a."SLMediaInd" = true) THEN 'Yes'::text
            WHEN (a."SLMediaInd" = false) THEN 'No'::text
            ELSE NULL::text
        END AS "MediaImpactedSoil",
        CASE
            WHEN (a."GWMediaInd" = true) THEN 'Yes'::text
            WHEN (a."GWMediaInd" = false) THEN 'No'::text
            ELSE NULL::text
        END AS "MediaImpactedGroundwater",
        CASE
            WHEN (a."SWMediaInd" = true) THEN 'Yes'::text
            WHEN (a."SWMediaInd" = false) THEN 'No'::text
            ELSE NULL::text
        END AS "MediaImpactedSurfaceWater",
    ( SELECT sr_1."SubstanceReleased"
           FROM or_release.v_substance_released sr_1
          WHERE ((sr_1.rn = 1) AND (sr_1."LustId" = i."LustId"))) AS "SubstanceReleased1",
    ( SELECT sr_1."AmountReleased"
           FROM or_release.v_substance_released sr_1
          WHERE ((sr_1.rn = 1) AND (sr_1."LustId" = i."LustId"))) AS "QuantityReleased1",
    'gallons'::text AS "Unit1",
    ( SELECT sr_1."SubstanceReleased"
           FROM or_release.v_substance_released sr_1
          WHERE ((sr_1.rn = 2) AND (sr_1."LustId" = i."LustId"))) AS "SubstanceReleased2",
    ( SELECT sr_1."AmountReleased"
           FROM or_release.v_substance_released sr_1
          WHERE ((sr_1.rn = 2) AND (sr_1."LustId" = i."LustId"))) AS "QuantityReleased2",
    'gallons'::text AS "Unit2",
    ( SELECT sr_1."SubstanceReleased"
           FROM or_release.v_substance_released sr_1
          WHERE ((sr_1.rn = 3) AND (sr_1."LustId" = i."LustId"))) AS "SubstanceReleased3",
    ( SELECT sr_1."AmountReleased"
           FROM or_release.v_substance_released sr_1
          WHERE ((sr_1.rn = 3) AND (sr_1."LustId" = i."LustId"))) AS "QuantityReleased3",
    'gallons'::text AS "Unit3",
    ( SELECT sr_1."SubstanceReleased"
           FROM or_release.v_substance_released sr_1
          WHERE ((sr_1.rn = 4) AND (sr_1."LustId" = i."LustId"))) AS "SubstanceReleased4",
    ( SELECT sr_1."AmountReleased"
           FROM or_release.v_substance_released sr_1
          WHERE ((sr_1.rn = 4) AND (sr_1."LustId" = i."LustId"))) AS "QuantityReleased4",
    'gallons'::text AS "Unit4",
    ( SELECT sr_1."SubstanceReleased"
           FROM or_release.v_substance_released sr_1
          WHERE ((sr_1.rn = 5) AND (sr_1."LustId" = i."LustId"))) AS "SubstanceReleased5",
    ( SELECT sr_1."AmountReleased"
           FROM or_release.v_substance_released sr_1
          WHERE ((sr_1.rn = 5) AND (sr_1."LustId" = i."LustId"))) AS "QuantityReleased5",
    'gallons'::text AS "Unit5",
    sr.epa_value AS "SourceOfRelease1",
    cr.epa_value AS "CauseOfRelease1",
    hrd.epa_value AS "HowReleaseDetected",
    ( SELECT rs."RemediationStrategy"
           FROM or_release.v_remediation_strategy rs
          WHERE ((rs.rn = 1) AND (rs."LustId" = i."LustId"))) AS "CorrectiveActionStrategy1",
    ( SELECT (rs."RemediationStrategyStartDate")::date AS "RemediationStrategyStartDate"
           FROM or_release.v_remediation_strategy rs
          WHERE ((rs.rn = 1) AND (rs."LustId" = i."LustId"))) AS "RemediationStrategyStartDate1",
    ( SELECT rs."RemediationStrategy"
           FROM or_release.v_remediation_strategy rs
          WHERE ((rs.rn = 2) AND (rs."LustId" = i."LustId"))) AS "CorrectiveActionStrategy2",
    ( SELECT (rs."RemediationStrategyStartDate")::date AS "RemediationStrategyStartDate"
           FROM or_release.v_remediation_strategy rs
          WHERE ((rs.rn = 2) AND (rs."LustId" = i."LustId"))) AS "RemediationStrategyStartDate2",
    ( SELECT rs."RemediationStrategy"
           FROM or_release.v_remediation_strategy rs
          WHERE ((rs.rn = 3) AND (rs."LustId" = i."LustId"))) AS "CorrectiveActionStrategy3",
    ( SELECT (rs."RemediationStrategyStartDate")::date AS "RemediationStrategyStartDate"
           FROM or_release.v_remediation_strategy rs
          WHERE ((rs.rn = 3) AND (rs."LustId" = i."LustId"))) AS "RemediationStrategyStartDate3",
        CASE
            WHEN (i."SiteTypeCode" = ANY (ARRAY['RBCA'::text, 'GW'::text, 'POCKET'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS "ClosedWithContamination"
   FROM (((((or_release."Incident" i
     LEFT JOIN or_release."Management" m ON ((i."LustId" = m."LustId")))
     LEFT JOIN or_release."Assessment" a ON ((i."LustId" = a."LustId")))
     LEFT JOIN ( SELECT a_1.state_value AS epa_value,
            b."ReleaseSourceId"
           FROM (archive.v_lust_element_mapping a_1
             JOIN or_release."AssessmentSourceType" b ON (((a_1.state_value)::text = b."ReleaseSourceDescription")))
          WHERE ((a_1.control_id = 13) AND ((a_1.element_name)::text = 'SourceOfRelease1'::text))) sr ON ((sr."ReleaseSourceId" = a."ReleaseSourceId")))
     LEFT JOIN ( SELECT a_1.state_value AS epa_value,
            b."ReleaseCauseCode"
           FROM (archive.v_lust_element_mapping a_1
             JOIN or_release."AssessmentReleaseType" b ON (((a_1.state_value)::text = b."ReleaseCauseDescription")))
          WHERE ((a_1.control_id = 13) AND ((a_1.element_name)::text = 'CauseOfRelease1'::text))) cr ON ((cr."ReleaseCauseCode" = a."ReleaseCauseCode")))
     LEFT JOIN ( SELECT a_1.state_value AS epa_value,
            b."DiscoveryCode"
           FROM (archive.v_lust_element_mapping a_1
             JOIN or_release."AssessmentDiscoveryType" b ON (((a_1.state_value)::text = b."DiscoveryDescription")))
          WHERE ((a_1.control_id = 13) AND ((a_1.element_name)::text = 'HowReleaseDetected'::text))) hrd ON ((hrd."DiscoveryCode" = a."DiscoveryCode")))
  WHERE (i."FacilityId" IS NOT NULL);