create or replace view "trustd_ust"."v_ust_base" as
 SELECT DISTINCT (f.land_location_id)::text AS "FacilityID",
    "left"(f.facility_desc, 100) AS "FacilityName",
    ot.epa_value AS "OwnerType",
    ft.epa_value AS "FacilityType1",
    "left"(ll.address_1, 100) AS "FacilityAddress1",
    ll.address_2 AS "FacilityAddress2",
    ll.city AS "FacilityCity",
    (ll.zip)::text AS "FacilityZipCode",
    ll.county AS "FacilityCounty",
    "left"(ll.phone, 40) AS "FacilityPhoneNumber",
    ll.state AS "FacilityState",
        CASE
            WHEN (rg.region_key ~~ 'R%'::text) THEN (replace(rg.region_key, 'R'::text, ''::text))::integer
            ELSE NULL::integer
        END AS "FacilityEPARegion",
        CASE
            WHEN ((ll.tribe_owned = ANY (ARRAY['True'::text, 'TRUE'::text, 'Y'::text])) OR (ll.tribe_id IS NOT NULL)) THEN 'Yes'::text
            WHEN (ll.tribe_owned = ANY (ARRAY['False'::text, 'FALSE'::text, 'N'::text])) THEN 'No'::text
            ELSE NULL::text
        END AS "FacilityTribalSite",
        CASE
            WHEN ((ll.tribe IS NOT NULL) AND (t.current_name IS NULL)) THEN "left"(ll.tribe, 200)
            WHEN (t.current_name IS NOT NULL) THEN "left"(t.current_name, 200)
            ELSE NULL::text
        END AS "FacilityTribe",
    ll.latitude AS "FacilityLatitude",
    ll.longitude AS "FacilityLongitude",
    fcs.epa_value AS "FacilityCoordinateSource",
    substr(fo.responsible_entity_name, 1, 100) AS "FacilityOwnerCompanyName",
    fo.address_1 AS "FacilityOwnerAddress1",
    fo.address_2 AS "FacilityOwnerAddress2",
    fo.city AS "FacilityOwnerCity",
    fo.county AS "FacilityOwnerCounty",
    (fo.zip)::text AS "FacilityOwnerZipCode",
    fo.state AS "FacilityOwnerState",
    fo.phone AS "FacilityOwnerPhoneNumber",
    fo.email_addr AS "FacilityOwnerEmail",
    substr(fop.facility_operator_name, 1, 100) AS "FacilityOperatorCompanyName",
    fop.address_1 AS "FacilityOperatorAddress1",
    fop.address_2 AS "FacilityOperatorAddress2",
    fop.city AS "FacilityOperatorCity",
    fop.county AS "FacilityOperatorCounty",
    (fop.zip)::text AS "FacilityOperatorZipCode",
    fop.state AS "FacilityOperatorState",
    fop.phone AS "FacilityOperatorPhoneNumber",
    ( SELECT DISTINCT 'Yes'::text
           FROM trustd_ust.ut_financial_responsibility fr
          WHERE ((fr.fr_type = 'Local Govt. Bond Rating Test'::text) AND (fr.facility_id = f.facility_id))) AS "FinancialResponsibilityBondRatingTest",
    ( SELECT DISTINCT 'Yes'::text
           FROM trustd_ust.ut_financial_responsibility fr
          WHERE ((fr.fr_type = 'Insurance'::text) AND (fr.facility_id = f.facility_id))) AS "FinancialResponsibilityCommercialInsurance",
    ( SELECT DISTINCT 'Yes'::text
           FROM trustd_ust.ut_financial_responsibility fr
          WHERE ((fr.fr_type = 'Guarantee'::text) AND (fr.facility_id = f.facility_id))) AS "FinancialResponsibilityGuarantee",
    ( SELECT DISTINCT 'Yes'::text
           FROM trustd_ust.ut_financial_responsibility fr
          WHERE ((fr.fr_type = 'Letter of Credit'::text) AND (fr.facility_id = f.facility_id))) AS "FinancialResponsibilityLetterOfCredit",
    ( SELECT DISTINCT 'Yes'::text
           FROM trustd_ust.ut_financial_responsibility fr
          WHERE ((fr.fr_type = 'Local Govt. Financial Test'::text) AND (fr.facility_id = f.facility_id))) AS "FinancialResponsibilityLocalGovernmentFinancialTest",
    ( SELECT DISTINCT 'Yes'::text
           FROM trustd_ust.ut_financial_responsibility fr
          WHERE ((fr.fr_type = 'Risk Retention Group'::text) AND (fr.facility_id = f.facility_id))) AS "FinancialResponsibilityRiskRetentionGroup",
    ( SELECT DISTINCT 'Yes'::text
           FROM trustd_ust.ut_financial_responsibility fr
          WHERE ((fr.fr_type = 'Self Insured'::text) AND (fr.facility_id = f.facility_id))) AS "FinancialResponsibilitySelfInsuranceFinancialTest",
    ( SELECT DISTINCT 'Yes'::text
           FROM trustd_ust.ut_financial_responsibility fr
          WHERE ((fr.fr_type = 'State Fund'::text) AND (fr.facility_id = f.facility_id))) AS "FinancialResponsibilityStateFund",
    ( SELECT DISTINCT 'Yes'::text
           FROM trustd_ust.ut_financial_responsibility fr
          WHERE ((fr.fr_type = 'Surety Bond'::text) AND (fr.facility_id = f.facility_id))) AS "FinancialResponsibilitySuretyBond",
    ( SELECT DISTINCT 'Yes'::text
           FROM trustd_ust.ut_financial_responsibility fr
          WHERE ((fr.fr_type = ANY (ARRAY['Trust Fund'::text, 'Standby Trust Fund'::text])) AND (fr.facility_id = f.facility_id))) AS "FinancialResponsibilityTrustFund",
    ( SELECT string_agg(DISTINCT fr.fr_type, '; '::text ORDER BY fr.fr_type) AS fr_type
           FROM trustd_ust.ut_financial_responsibility fr
          WHERE ((fr.fr_type <> ALL (ARRAY['Guarantee'::text, 'Insurance'::text, 'Letter of Credit'::text, 'Local Govt. Bond Rating Test'::text, 'Local Govt. Financial Test'::text, 'Risk Retention Group'::text, 'Self Insured'::text, 'Standby Trust Fund'::text, 'State Fund'::text, 'Surety Bond'::text, 'Trust Fund'::text, 'Govt. Entity: Federal Covered'::text, 'Govt. Entity: State Covered'::text])) AND (fr.facility_id = f.facility_id))) AS "FinancialResponsibilityOtherMethod",
    ( SELECT DISTINCT 'Yes'::text
           FROM trustd_ust.ut_financial_responsibility fr
          WHERE ((fr.fr_type ~~ 'Govt. Entity%'::text) AND (fr.facility_id = f.facility_id))) AS "FinancialResponsibilityNotRequired",
    ts.tank_name AS "TankID",
    'Yes'::text AS "FederallyRegulated",
    tsc.compartment_name AS "CompartmentID",
    tst.epa_value AS "TankStatus",
    mt.epa_value AS "ManifoldedTanks",
    (ts.date_closed)::date AS "ClosureDate",
    (ts.date_installed)::date AS "InstallationDate",
    vc.compartmentalized AS "CompartmentalizedUST",
    vc.num_compartments AS "NumberOfCompartments",
    css.epa_value AS "CompartmentSubstanceStored",
    ts.tank_capacity AS "TankCapacityGallons",
    tsc.compartment_capacity AS "CompartmentCapacityGallons",
    el.epa_value AS "ExcavationLiner",
    twt.epa_value AS "TankWallType",
    md.epa_value AS "MaterialDescription",
        CASE
            WHEN (ts.tank_repaired = true) THEN 'Yes'::text
            WHEN (ts.tank_repaired = false) THEN 'No'::text
            ELSE NULL::text
        END AS "TankRepaired",
    pmd.epa_value AS "PipingMaterialDescription",
    ps.epa_value AS "PipingStyle",
    pwt.epa_value AS "PipingWallType",
    pr.epa_value AS "PipingRepaired",
    tcpic.epa_value AS "TankCorrosionProtectionImpressedCurrent",
    tcpsa.epa_value AS "TankCorrosionProtectionSacrificialAnode",
    pcpic.epa_value AS "PipingCorrosionProtectionImpressedCurrent",
    pcpsa.epa_value AS "PipingCorrosionProtectionSacrificialAnode",
    bfv.epa_value AS "BallFloatValve",
    fsd.epa_value AS "FlowShutoffDevice",
    hla.epa_value AS "HighLevelAlarm",
    sbi.epa_value AS "SpillBucketInstalled",
    sbwt.epa_value AS "SpillBucketWallType",
    atg.epa_value AS "AutomaticTankGauging",
        CASE
            WHEN (atg.epa_value IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS "AutomaticTankGaugingReleaseDetection",
        CASE
            WHEN (atg.epa_value IS NOT NULL) THEN 'Unknown'::text
            ELSE NULL::text
        END AS "AutomaticTankGaugingContinuousLeakDetection",
    mtg.epa_value AS "ManualTankGauging",
    sir.epa_value AS "StatisticalInventoryReconciliation",
    ttt.epa_value AS "TankTightnessTesting",
    gm.epa_value AS "GroundwaterMonitoring",
    vm.epa_value AS "VaporMonitoring",
    elld.epa_value AS "ElectronicLineLeakDetector",
    mlld.epa_value AS "MechanicalLineLeakDetector",
        CASE
            WHEN (r.release_id IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS "USTReportedRelease",
    r.release_id AS "AssociatedLUSTID"
   FROM (((((((((((((((((((((((((((((((((((((((((((((((trustd_ust.ut_facility f
     LEFT JOIN trustd_ust.v_most_recent_land_use_type lu ON ((f.land_location_id = lu.land_location_id)))
     LEFT JOIN trustd_ust.ut_land_use_type lut ON ((lut.land_use_type_id = lu.land_use_type_id)))
     LEFT JOIN ( SELECT v_ust_element_mapping.state_value,
            v_ust_element_mapping.epa_value
           FROM archive.v_ust_element_mapping
          WHERE ((v_ust_element_mapping.control_id = 18) AND ((v_ust_element_mapping.element_name)::text = 'OwnerType'::text))) ot ON ((lut.land_use_type_desc = (ot.state_value)::text)))
     LEFT JOIN ( SELECT v_ust_element_mapping.state_value,
            v_ust_element_mapping.epa_value
           FROM archive.v_ust_element_mapping
          WHERE ((v_ust_element_mapping.control_id = 18) AND ((v_ust_element_mapping.element_name)::text = 'FacilityType1'::text))) ft ON ((lut.land_use_type_desc = (ft.state_value)::text)))
     LEFT JOIN trustd_ust.ut_land_location ll ON ((f.land_location_id = ll.land_location_id)))
     LEFT JOIN trustd_ust.ut_tribes t ON ((ll.tribe_id = (t.tribe_id)::double precision)))
     LEFT JOIN trustd_ust.st_regions rg ON ((t.region_id = rg.region_id)))
     LEFT JOIN ( SELECT v_ust_element_mapping.state_value,
            v_ust_element_mapping.epa_value
           FROM archive.v_ust_element_mapping
          WHERE ((v_ust_element_mapping.control_id = 18) AND ((v_ust_element_mapping.element_name)::text = 'FacilityCoordinateSource'::text))) fcs ON ((ll.lat_lon_source = (fcs.state_value)::text)))
     LEFT JOIN ( SELECT lre.facility_id,
            lre.responsible_entity_name,
            lre.address_1,
            lre.address_2,
            lre.city,
            lre.state,
            lre.zip,
            lre.county,
            lre.phone,
            lre.email_addr,
            lre.rn
           FROM ( SELECT fh.facility_id,
                    lre_1.responsible_entity_name,
                    lre_1.address_1,
                    lre_1.address_2,
                    lre_1.city,
                    lre_1.state,
                    lre_1.zip,
                    lre_1.county,
                    lre_1.phone,
                    lre_1.email_addr,
                    row_number() OVER (PARTITION BY fh.facility_id ORDER BY fh.end_date DESC, fh.date_observed DESC NULLS LAST, fh.ut_facility_owner_hist_id DESC) AS rn
                   FROM (trustd_ust.ut_facility_owner_hist fh
                     JOIN trustd_ust.ut_legally_responsible_entity lre_1 ON ((lre_1.responsible_entity_id = fh.responsible_entity_id)))) lre
          WHERE (lre.rn = 1)) fo ON ((f.facility_id = fo.facility_id)))
     LEFT JOIN ( SELECT c.facility_id,
            d.facility_operator_id,
            d.facility_operator_name,
            d.address_1,
            d.address_2,
            d.city,
            d.county,
            d.state,
            d.zip,
            d.phone,
            d.fax,
            d.operator_comment,
            d.contact_name,
            d.tax_id,
            d.created_by,
            d.created_date,
            d.updated_by,
            d.updated_date,
            d.email_addr
           FROM (trustd_ust.ut_facility_operator d
             JOIN ( SELECT a.facility_id,
                    a.facility_operator_id
                   FROM (trustd_ust.ut_facility_oper_hist a
                     JOIN ( SELECT ut_facility_oper_hist.facility_id,
                            max(ut_facility_oper_hist.ut_facility_oper_hist_id) AS ut_facility_oper_hist_id
                           FROM trustd_ust.ut_facility_oper_hist
                          WHERE (ut_facility_oper_hist.end_date IS NULL)
                          GROUP BY ut_facility_oper_hist.facility_id) b ON ((a.ut_facility_oper_hist_id = b.ut_facility_oper_hist_id)))) c ON ((c.facility_operator_id = (d.facility_operator_id)::double precision)))) fop ON ((f.facility_id = fop.facility_id)))
     LEFT JOIN trustd_ust.v_ut_tank_system ts ON ((f.facility_id = ts.facility_id)))
     LEFT JOIN trustd_ust.ut_tank_system_comp tsc ON ((ts.tank_system_id = tsc.tank_system_id)))
     LEFT JOIN trustd_ust.v_compartments vc ON ((tsc.tank_system_id = vc.tank_system_id)))
     LEFT JOIN trustd_ust.v_tank_status vts ON (((ts.facility_id = vts.facility_id) AND (ts.tank_name = vts.tank_name))))
     LEFT JOIN ( SELECT v_ust_element_mapping.state_value,
            v_ust_element_mapping.epa_value
           FROM archive.v_ust_element_mapping
          WHERE ((v_ust_element_mapping.control_id = 18) AND ((v_ust_element_mapping.element_name)::text = 'TankStatus'::text))) tst ON ((vts.tank_status = (tst.state_value)::text)))
     LEFT JOIN trustd_ust.v_substances vs ON ((tsc.tank_system_comp_id = vs.tank_system_comp_id)))
     LEFT JOIN trustd_ust.ut_substance_type st ON (((vs.ut_substance_type_id)::integer = st.ut_substance_type_id)))
     LEFT JOIN ( SELECT v_ust_element_mapping.state_value,
            v_ust_element_mapping.epa_value,
            v_ust_element_mapping.exclude_from_query
           FROM archive.v_ust_element_mapping
          WHERE ((v_ust_element_mapping.control_id = 18) AND ((v_ust_element_mapping.element_name)::text = 'CompartmentSubstanceStored'::text))) css ON ((st.ut_substance_desc = (css.state_value)::text)))
     LEFT JOIN ( SELECT v_ust_element_mapping.state_value,
            v_ust_element_mapping.epa_value
           FROM archive.v_ust_element_mapping
          WHERE ((v_ust_element_mapping.control_id = 18) AND ((v_ust_element_mapping.element_name)::text = 'PipingRepaired'::text))) pr ON (((tsc.pipe_repaired)::text = (pr.state_value)::text)))
     LEFT JOIN ( SELECT v_ust_element_mapping.state_value,
            v_ust_element_mapping.epa_value
           FROM archive.v_ust_element_mapping
          WHERE ((v_ust_element_mapping.control_id = 18) AND ((v_ust_element_mapping.element_name)::text = 'SpillBucketInstalled'::text))) sbi ON ((tsc.spill_installed = (sbi.state_value)::text)))
     LEFT JOIN trustd_ust.ut_spill_prevention_type spt ON ((tsc.spill_preventions = (spt.ut_spill_prevention_type_id)::double precision)))
     LEFT JOIN ( SELECT v_ust_element_mapping.state_value,
            v_ust_element_mapping.epa_value
           FROM archive.v_ust_element_mapping
          WHERE ((v_ust_element_mapping.control_id = 18) AND ((v_ust_element_mapping.element_name)::text = 'SpillBucketWallType'::text))) sbwt ON ((spt.ut_spill_prevention_desc = (sbwt.state_value)::text)))
     LEFT JOIN ( SELECT DISTINCT a.state_value,
            a.epa_value,
            c.tank_system_id
           FROM ((archive.v_ust_element_mapping a
             JOIN trustd_ust.ut_tank_attribute_type b ON (((a.state_value)::text = b.ut_tank_attribute_desc)))
             JOIN trustd_ust.v_tank_attributes c ON ((b.ut_tank_attribute_type_id = (c.ut_tank_attribute_type_id)::integer)))
          WHERE ((a.control_id = 18) AND ((a.element_name)::text = 'TankWallType'::text))) twt ON ((ts.tank_system_id = twt.tank_system_id)))
     LEFT JOIN ( SELECT DISTINCT a.state_value,
            a.epa_value,
            c.tank_system_id
           FROM ((archive.v_ust_element_mapping a
             JOIN trustd_ust.ut_tank_attribute_type b ON (((a.state_value)::text = b.ut_tank_attribute_desc)))
             JOIN trustd_ust.v_tank_attributes c ON ((b.ut_tank_attribute_type_id = (c.ut_tank_attribute_type_id)::integer)))
          WHERE ((a.control_id = 18) AND ((a.element_name)::text = 'ManifoldedTanks'::text))) mt ON ((ts.tank_system_id = mt.tank_system_id)))
     LEFT JOIN ( SELECT DISTINCT a.state_value,
            a.epa_value,
            c.tank_system_id
           FROM ((archive.v_ust_element_mapping a
             JOIN trustd_ust.ut_tank_attribute_type b ON (((a.state_value)::text = b.ut_tank_attribute_desc)))
             JOIN trustd_ust.v_tank_attributes c ON ((b.ut_tank_attribute_type_id = (c.ut_tank_attribute_type_id)::integer)))
          WHERE ((a.control_id = 18) AND ((a.element_name)::text = 'MaterialDescription'::text))) md ON ((ts.tank_system_id = md.tank_system_id)))
     LEFT JOIN ( SELECT DISTINCT a.state_value,
            a.epa_value,
            c.tank_system_id
           FROM ((archive.v_ust_element_mapping a
             JOIN trustd_ust.ut_tank_attribute_type b ON (((a.state_value)::text = b.ut_tank_attribute_desc)))
             JOIN trustd_ust.v_tank_attributes c ON ((b.ut_tank_attribute_type_id = (c.ut_tank_attribute_type_id)::integer)))
          WHERE ((a.control_id = 18) AND ((a.element_name)::text = 'ExcavationLiner'::text))) el ON ((ts.tank_system_id = el.tank_system_id)))
     LEFT JOIN ( SELECT DISTINCT a.state_value,
            a.epa_value,
            c.tank_system_id
           FROM ((archive.v_ust_element_mapping a
             JOIN trustd_ust.ut_tank_attribute_type b ON (((a.state_value)::text = b.ut_tank_attribute_desc)))
             JOIN trustd_ust.v_tank_attributes c ON ((b.ut_tank_attribute_type_id = (c.ut_tank_attribute_type_id)::integer)))
          WHERE ((a.control_id = 18) AND ((a.element_name)::text = 'TankCorrosionProtectionImpressedCurrent'::text))) tcpic ON ((ts.tank_system_id = tcpic.tank_system_id)))
     LEFT JOIN ( SELECT DISTINCT a.state_value,
            a.epa_value,
            c.tank_system_id
           FROM ((archive.v_ust_element_mapping a
             JOIN trustd_ust.ut_tank_attribute_type b ON (((a.state_value)::text = b.ut_tank_attribute_desc)))
             JOIN trustd_ust.v_tank_attributes c ON ((b.ut_tank_attribute_type_id = (c.ut_tank_attribute_type_id)::integer)))
          WHERE ((a.control_id = 18) AND ((a.element_name)::text = 'TankCorrosionProtectionSacrificialAnode'::text))) tcpsa ON ((ts.tank_system_id = tcpsa.tank_system_id)))
     LEFT JOIN ( SELECT DISTINCT a.state_value,
            a.epa_value,
            c.tank_system_comp_id
           FROM ((archive.v_ust_element_mapping a
             JOIN trustd_ust.ut_piping_attribute_type b ON (((a.state_value)::text = b.ut_piping_attribute_desc)))
             JOIN trustd_ust.v_piping_attributes c ON ((b.ut_piping_attribute_type_id = (c.ut_piping_attribute_type_id)::integer)))
          WHERE ((a.control_id = 18) AND ((a.element_name)::text = 'PipingMaterialDescription'::text))) pmd ON ((tsc.tank_system_comp_id = pmd.tank_system_comp_id)))
     LEFT JOIN ( SELECT DISTINCT a.state_value,
            a.epa_value,
            c.tank_system_comp_id
           FROM ((archive.v_ust_element_mapping a
             JOIN trustd_ust.ut_piping_attribute_type b ON (((a.state_value)::text = b.ut_piping_attribute_desc)))
             JOIN trustd_ust.v_piping_attributes c ON ((b.ut_piping_attribute_type_id = (c.ut_piping_attribute_type_id)::integer)))
          WHERE ((a.control_id = 18) AND ((a.element_name)::text = 'PipingWallType'::text))) pwt ON ((tsc.tank_system_comp_id = pwt.tank_system_comp_id)))
     LEFT JOIN ( SELECT DISTINCT a.state_value,
            a.epa_value,
            c.tank_system_comp_id
           FROM ((archive.v_ust_element_mapping a
             JOIN trustd_ust.ut_piping_attribute_type b ON (((a.state_value)::text = b.ut_piping_attribute_desc)))
             JOIN trustd_ust.v_piping_attributes c ON ((b.ut_piping_attribute_type_id = (c.ut_piping_attribute_type_id)::integer)))
          WHERE ((a.control_id = 18) AND ((a.element_name)::text = 'PipingCorrosionProtectionImpressedCurrent'::text))) pcpic ON ((tsc.tank_system_comp_id = pcpic.tank_system_comp_id)))
     LEFT JOIN ( SELECT DISTINCT a.state_value,
            a.epa_value,
            c.tank_system_comp_id
           FROM ((archive.v_ust_element_mapping a
             JOIN trustd_ust.ut_piping_attribute_type b ON (((a.state_value)::text = b.ut_piping_attribute_desc)))
             JOIN trustd_ust.v_piping_attributes c ON ((b.ut_piping_attribute_type_id = (c.ut_piping_attribute_type_id)::integer)))
          WHERE ((a.control_id = 18) AND ((a.element_name)::text = 'PipingCorrosionProtectionSacrificialAnode'::text))) pcpsa ON ((tsc.tank_system_comp_id = pcpsa.tank_system_comp_id)))
     LEFT JOIN trustd_ust.v_piping_deliveries vpd ON ((tsc.tank_system_comp_id = vpd.tank_system_comp_id)))
     LEFT JOIN trustd_ust.ut_piping_delivery_type pdt ON (((vpd.ut_piping_delivery_type_id)::integer = pdt.ut_piping_delivery_type_id)))
     LEFT JOIN ( SELECT v_ust_element_mapping.state_value,
            v_ust_element_mapping.epa_value
           FROM archive.v_ust_element_mapping
          WHERE ((v_ust_element_mapping.control_id = 18) AND ((v_ust_element_mapping.element_name)::text = 'PipingStyle'::text))) ps ON ((pdt.ut_piping_delivery_desc = (ps.state_value)::text)))
     LEFT JOIN ( SELECT a.state_value,
            a.epa_value,
            c.tank_system_comp_id
           FROM ((archive.v_ust_element_mapping a
             JOIN trustd_ust.ut_overfill_protection_type b ON (((a.state_value)::text = b.ut_overfill_protection_desc)))
             JOIN trustd_ust.v_overfill_protections c ON ((b.ut_overfill_protection_type_id = (c.ut_overfill_protection_type_id)::integer)))
          WHERE ((a.control_id = 18) AND ((a.element_name)::text = 'FlowShutoffDevice'::text))) fsd ON ((tsc.tank_system_comp_id = fsd.tank_system_comp_id)))
     LEFT JOIN ( SELECT a.state_value,
            a.epa_value,
            c.tank_system_comp_id
           FROM ((archive.v_ust_element_mapping a
             JOIN trustd_ust.ut_overfill_protection_type b ON (((a.state_value)::text = b.ut_overfill_protection_desc)))
             JOIN trustd_ust.v_overfill_protections c ON ((b.ut_overfill_protection_type_id = (c.ut_overfill_protection_type_id)::integer)))
          WHERE ((a.control_id = 18) AND ((a.element_name)::text = 'BallFloatValve'::text))) bfv ON ((tsc.tank_system_comp_id = bfv.tank_system_comp_id)))
     LEFT JOIN ( SELECT a.state_value,
            a.epa_value,
            c.tank_system_comp_id
           FROM ((archive.v_ust_element_mapping a
             JOIN trustd_ust.ut_overfill_protection_type b ON (((a.state_value)::text = b.ut_overfill_protection_desc)))
             JOIN trustd_ust.v_overfill_protections c ON ((b.ut_overfill_protection_type_id = (c.ut_overfill_protection_type_id)::integer)))
          WHERE ((a.control_id = 18) AND ((a.element_name)::text = 'HighLevelAlarm'::text))) hla ON ((tsc.tank_system_comp_id = hla.tank_system_comp_id)))
     LEFT JOIN ( SELECT a.state_value,
            a.epa_value,
            c.tank_system_comp_id
           FROM ((archive.v_ust_element_mapping a
             JOIN trustd_ust.ut_release_detection_type b ON (((a.state_value)::text = b.ut_release_detection_desc)))
             JOIN trustd_ust.v_tank_release_detections c ON ((b.ut_release_detection_type_id = (c.ut_release_detection_type_id)::integer)))
          WHERE ((a.control_id = 18) AND ((a.element_name)::text = 'AutomaticTankGauging'::text))) atg ON ((tsc.tank_system_comp_id = atg.tank_system_comp_id)))
     LEFT JOIN ( SELECT a.state_value,
            a.epa_value,
            c.tank_system_comp_id
           FROM ((archive.v_ust_element_mapping a
             JOIN trustd_ust.ut_release_detection_type b ON (((a.state_value)::text = b.ut_release_detection_desc)))
             JOIN trustd_ust.v_tank_release_detections c ON ((b.ut_release_detection_type_id = (c.ut_release_detection_type_id)::integer)))
          WHERE ((a.control_id = 18) AND ((a.element_name)::text = 'ManualTankGauging'::text))) mtg ON ((tsc.tank_system_comp_id = mtg.tank_system_comp_id)))
     LEFT JOIN ( SELECT a.state_value,
            a.epa_value,
            c.tank_system_comp_id
           FROM ((archive.v_ust_element_mapping a
             JOIN trustd_ust.ut_release_detection_type b ON (((a.state_value)::text = b.ut_release_detection_desc)))
             JOIN trustd_ust.v_tank_release_detections c ON ((b.ut_release_detection_type_id = (c.ut_release_detection_type_id)::integer)))
          WHERE ((a.control_id = 18) AND ((a.element_name)::text = 'StatisticalInventoryReconciliation'::text))) sir ON ((tsc.tank_system_comp_id = sir.tank_system_comp_id)))
     LEFT JOIN ( SELECT a.state_value,
            a.epa_value,
            c.tank_system_comp_id
           FROM ((archive.v_ust_element_mapping a
             JOIN trustd_ust.ut_release_detection_type b ON (((a.state_value)::text = b.ut_release_detection_desc)))
             JOIN trustd_ust.v_tank_release_detections c ON ((b.ut_release_detection_type_id = (c.ut_release_detection_type_id)::integer)))
          WHERE ((a.control_id = 18) AND ((a.element_name)::text = 'TankTightnessTesting'::text))) ttt ON ((tsc.tank_system_comp_id = ttt.tank_system_comp_id)))
     LEFT JOIN ( SELECT a.state_value,
            a.epa_value,
            c.tank_system_comp_id
           FROM ((archive.v_ust_element_mapping a
             JOIN trustd_ust.ut_release_detection_type b ON (((a.state_value)::text = b.ut_release_detection_desc)))
             JOIN trustd_ust.v_tank_release_detections c ON ((b.ut_release_detection_type_id = (c.ut_release_detection_type_id)::integer)))
          WHERE ((a.control_id = 18) AND ((a.element_name)::text = 'GroundwaterMonitoring'::text))) gm ON ((tsc.tank_system_comp_id = gm.tank_system_comp_id)))
     LEFT JOIN ( SELECT a.state_value,
            a.epa_value,
            c.tank_system_comp_id
           FROM ((archive.v_ust_element_mapping a
             JOIN trustd_ust.ut_release_detection_type b ON (((a.state_value)::text = b.ut_release_detection_desc)))
             JOIN trustd_ust.v_tank_release_detections c ON ((b.ut_release_detection_type_id = (c.ut_release_detection_type_id)::integer)))
          WHERE ((a.control_id = 18) AND ((a.element_name)::text = 'VaporMonitoring'::text))) vm ON ((tsc.tank_system_comp_id = vm.tank_system_comp_id)))
     LEFT JOIN ( SELECT a.state_value,
            a.epa_value,
            c.tank_system_comp_id
           FROM ((archive.v_ust_element_mapping a
             JOIN trustd_ust.ut_release_detection_type b ON (((a.state_value)::text = b.ut_release_detection_desc)))
             JOIN trustd_ust.v_tank_release_detections c ON ((b.ut_release_detection_type_id = (c.ut_release_detection_type_id)::integer)))
          WHERE ((a.control_id = 18) AND ((a.element_name)::text = 'ElectronicLineLeakDetector'::text))) elld ON ((tsc.tank_system_comp_id = elld.tank_system_comp_id)))
     LEFT JOIN ( SELECT a.state_value,
            a.epa_value,
            c.tank_system_comp_id
           FROM ((archive.v_ust_element_mapping a
             JOIN trustd_ust.ut_release_detection_type b ON (((a.state_value)::text = b.ut_release_detection_desc)))
             JOIN trustd_ust.v_tank_release_detections c ON ((b.ut_release_detection_type_id = (c.ut_release_detection_type_id)::integer)))
          WHERE ((a.control_id = 18) AND ((a.element_name)::text = 'MechanicalLineLeakDetector'::text))) mlld ON ((tsc.tank_system_comp_id = mlld.tank_system_comp_id)))
     LEFT JOIN ( SELECT a.land_location_id,
            max(a.release_id) AS release_id
           FROM (trustd_ust.ut_release a
             JOIN ( SELECT re.release_id,
                    max(re.event_date) AS event_date
                   FROM (trustd_ust.ut_release_event re
                     JOIN trustd_ust.ut_release_event_type ret ON ((re.release_event_type_id = (ret.release_event_type_id)::double precision)))
                  WHERE ((ret.release_event_desc = 'Confirmed Release'::text) AND (NOT (re.release_id IN ( SELECT re_1.release_id
                           FROM (trustd_ust.ut_release_event re_1
                             JOIN trustd_ust.ut_release_event_type ret_1 ON ((re_1.release_event_type_id = (ret_1.release_event_type_id)::double precision)))
                          WHERE (ret_1.release_event_desc = 'Determination of Non-Jurisdiction'::text)))))
                  GROUP BY re.release_id) b ON ((a.release_id = b.release_id)))
          GROUP BY a.land_location_id) r ON ((f.land_location_id = r.land_location_id)))
  WHERE ((ll.land_status <> 'Not Indian Country'::text) AND (ts.federal_regulated_tank = true) AND ((COALESCE(css.exclude_from_query, 'X'::character varying))::text <> 'Y'::text))
  ORDER BY (f.land_location_id)::text;