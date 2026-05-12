create or replace view "ne_ust"."v_ust_base" as
 SELECT DISTINCT t."Facility ID" AS "FacilityID",
    t."Facility Name" AS "FacilityName",
    t."Facility Address" AS "FacilityAddress1",
    t."Facility City" AS "FacilityCity",
    t."Facility County" AS "FacilityCounty",
    t."Facility Zip" AS "FacilityZipCode",
    'NE'::text AS "FacilityState",
    7 AS "FacilityEPARegion",
    t."Owner Name" AS "FacilityOwnerCompanyName",
    t."Owner Address" AS "FacilityOwnerAddress1",
    t."Owner City" AS "FacilityOwnerCity",
    t."Owner Zip" AS "FacilityOwnerZipCode",
    t."Owner State" AS "FacilityOwnerState",
    'Yes'::text AS "FinancialResponsibilityTrustFund",
    t."Tank #" AS "TankID",
        CASE
            WHEN (tt.cnt > 0) THEN 'Yes'::text
            ELSE 'No'::text
        END AS "FederallyRegulated",
    ts.epa_value AS "TankStatus",
    t."Tank Installed" AS "InstallationDate",
    tss.epa_value AS "TankSubstanceStored",
    t."Tank Size" AS "TankCapacityGallons",
    el.epa_value AS "ExcavationLiner",
    wt.epa_value AS "TankWallType",
    md.epa_value AS "MaterialDescription",
    pmd.epa_value AS "PipingMaterialDescription",
        CASE
            WHEN (lower(t."Piping Const. Material") ~~ '%double%'::text) THEN 'Double walled'::text
            ELSE NULL::text
        END AS "PipingWallType",
        CASE
            WHEN (lower(t."Tank Ext Prot") ~~ '%sacrificial%'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS "TankCorrosionProtectionSacrificialAnode",
        CASE
            WHEN (lower(t."Tank Ext Prot") ~~ '%sacrificial%'::text) THEN 'Unknown'::text
            ELSE NULL::text
        END AS "TankCorrosionProtectionSacrificialAnodeInstalledOrRetrofitted",
        CASE
            WHEN (lower(t."Tank Ext Prot") ~~ '%impressed%'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS "TankCorrosionProtectionImpressedCurrent",
        CASE
            WHEN (lower(t."Tank Ext Prot") ~~ '%impressed%'::text) THEN 'Unknown'::text
            ELSE NULL::text
        END AS "TankCorrosionProtectionImpressedCurrentInstalledOrRetrofitted"
   FROM ((((((((ne_ust.tanks t
     LEFT JOIN ne_ust.facilities f ON ((t."Facility ID" = f."Facility ID")))
     LEFT JOIN ( SELECT tanks."Facility ID",
            count(*) AS cnt
           FROM ne_ust.tanks
          WHERE (tanks."Tank Type" = 'Federally Regulated'::text)
          GROUP BY tanks."Facility ID") tt ON ((t."Facility ID" = tt."Facility ID")))
     LEFT JOIN ( SELECT v_ust_element_mapping.state_value,
            v_ust_element_mapping.epa_value
           FROM archive.v_ust_element_mapping
          WHERE (((v_ust_element_mapping.organization_id)::text = 'NE'::text) AND ((v_ust_element_mapping.element_name)::text = 'TankStatus'::text))) ts ON ((t."Tank Usage Status" = (ts.state_value)::text)))
     LEFT JOIN ( SELECT v_ust_element_mapping.state_value,
            v_ust_element_mapping.epa_value
           FROM archive.v_ust_element_mapping
          WHERE (((v_ust_element_mapping.organization_id)::text = 'NE'::text) AND ((v_ust_element_mapping.element_name)::text = 'ExcavationLiner'::text))) el ON ((t."Tank Sec Contain" = (el.state_value)::text)))
     LEFT JOIN ( SELECT v_ust_element_mapping.state_value,
            v_ust_element_mapping.epa_value
           FROM archive.v_ust_element_mapping
          WHERE (((v_ust_element_mapping.organization_id)::text = 'NE'::text) AND ((v_ust_element_mapping.element_name)::text = 'TankWallType'::text))) wt ON ((t."Tank Int Prot" = (wt.state_value)::text)))
     LEFT JOIN ( SELECT v_ust_element_mapping.state_value,
            v_ust_element_mapping.epa_value
           FROM archive.v_ust_element_mapping
          WHERE (((v_ust_element_mapping.organization_id)::text = 'NE'::text) AND ((v_ust_element_mapping.element_name)::text = 'MaterialDescription'::text))) md ON ((t."Tank Constr." = (md.state_value)::text)))
     LEFT JOIN ( SELECT v_ust_element_mapping.state_value,
            v_ust_element_mapping.epa_value
           FROM archive.v_ust_element_mapping
          WHERE (((v_ust_element_mapping.organization_id)::text = 'NE'::text) AND ((v_ust_element_mapping.element_name)::text = 'PipingMaterialDescription'::text))) pmd ON ((t."Piping Const. Material" = (pmd.state_value)::text)))
     LEFT JOIN ( SELECT v_ust_element_mapping.state_value,
            v_ust_element_mapping.epa_value
           FROM archive.v_ust_element_mapping
          WHERE (((v_ust_element_mapping.organization_id)::text = 'NE'::text) AND ((v_ust_element_mapping.element_name)::text = 'TankSubstanceStored'::text))) tss ON ((t."Tank Contents" = (tss.state_value)::text)));