------------------------------------------------------------------------------------------------------------------------------------------------------------------------



create or replace view dc_ust.v_ust_facility as
 SELECT DISTINCT (x."FACILITYID")::character varying(50) AS facility_id,
    x."FacilityName" AS facility_name,
    ot.owner_type_id,
    ft.facility_type_id AS facility_type1,
    x."FacilityAddress1" AS facility_address1,
    x."FacilityCity" AS facility_city,
    (x."FacilityZipCode")::character varying(10) AS facility_zip_code,
    s.facility_state,
    (x."FacilityEPARegion")::integer AS facility_epa_region,
    x."FacilityLatitude" AS facility_latitude,
    x."FacilityLongitude" AS facility_longitude,
    cs.coordinate_source_id,
    x."FacilityOwnerCompanyName" AS facility_owner_company_name,
    x."FacilityOperatorCompanyName" AS facility_operator_company_name,
        CASE
            WHEN ((x."FacilityType1" = 'Federal Government - Non Military'::text) AND (x."FinancialResponsibilitySelfInsuranceFinancialTest" = 'Yes'::text)) THEN 'N/A'::text
            ELSE x."FinancialResponsibilityObtained"
        END AS financial_responsibility_obtained,
    x."FinancialResponsibilityBondRatingTest" AS financial_responsibility_bond_rating_test,
    x."FinancialResponsibilityCommercialInsurance" AS financial_responsibility_commercial_insurance,
    x."FinancialResponsibilityGuarantee" AS financial_responsibility_guarantee,
    x."FinancialResponsibilityLetterOfCredit" AS financial_responsibility_letter_of_credit,
    x."FinancialResponsibilityLocalGovernmentFinancialTest" AS financial_responsibility_local_government_financial_test,
    x."FinancialResponsibilityRiskRetentionGroup" AS financial_responsibility_risk_retention_group,
    x."FinancialResponsibilitySelfInsuranceFinancialTest" AS financial_responsibility_self_insurance_financial_test,
    x."FinancialResponsibilityStateFund" AS financial_responsibility_state_fund,
    x."FinancialResponsibilitySuretyBond" AS financial_responsibility_surety_bond,
    x."FinancialResponsibilityTrustFund" AS financial_responsibility_trust_fund,
    x."FinancialResponsibilityOtherMethod" AS financial_responsibility_other_method,
    x."USTReportedRelease" AS ust_reported_release,
    (x."AssociatedLUSTID")::text AS associated_ust_release_id
   FROM ((((dc_ust.facility x
     LEFT JOIN dc_ust.v_owner_type_xwalk ot ON ((x."OwnerType" = (ot.organization_value)::text)))
     LEFT JOIN dc_ust.v_facility_type_xwalk ft ON ((x."FacilityType1" = (ft.organization_value)::text)))
     LEFT JOIN dc_ust.v_state_xwalk s ON ((x."FacilityState" = (s.organization_value)::text)))
     LEFT JOIN dc_ust.v_coordinate_source_xwalk cs ON ((x."FacilityCoordinateSource" = (cs.organization_value)::text)))
 where x."FACILITYID"::varchar(50) not in (select facility_id from dc_ust.erg_unregulated_facilities);



create or replace view dc_ust.v_ust_tank as
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    (x."TankName")::integer AS tank_id,
    x."TankID" AS tank_name,
    tl.tank_location_id,
    ts.tank_status_id,
    x."FederallyRegulated" AS federally_regulated,
    x."EmergencyGenerator" AS emergency_generator,
    x."MultipleTanks" AS multiple_tanks,
    (x."TankClosureDate")::date AS tank_closure_date,
    (x."TankInstallationDate")::date AS tank_installation_date,
        CASE
            WHEN (c.comp_count > 1) THEN 'Yes'::text
            WHEN (c.comp_count = 1) THEN 'No'::text
            ELSE NULL::text
        END AS compartmentalized_ust,
    (c.comp_count)::integer AS number_of_compartments,
    tm.tank_material_description_id,
    x."TankCorrosionProtectionSacrificialAnode" AS tank_corrosion_protection_sacrificial_anode,
    x."TankCorrosionProtectionImpressedCurrent" AS tank_corrosion_protection_impressed_current,
    x."TankCorrosionProtectionCathodicNotRequired" AS tank_corrosion_protection_cathodic_not_required,
    x."TankCorrosionProtectionInteriorLining" AS tank_corrosion_protection_interior_lining,
    x."TankCorrosionProtectionOther" AS tank_corrosion_protection_other,
    x."TankCorrosionProtectionUnknown" AS tank_corrosion_protection_unknown,
    tsc.tank_secondary_containment_id,
    coi.cert_of_installation_id
   FROM ((((((dc_ust.tank x
     LEFT JOIN dc_ust.v_tank_location_xwalk tl ON ((x."TankLocation" = (tl.organization_value)::text)))
     LEFT JOIN dc_ust.v_tank_status_xwalk ts ON ((x."TankStatus" = (ts.organization_value)::text)))
     LEFT JOIN dc_ust.v_tank_material_description_xwalk tm ON ((x."TankMaterialDescription" = (tm.organization_value)::text)))
     LEFT JOIN dc_ust.v_tank_secondary_containment_xwalk tsc ON ((x."TankSecondaryContainment" = (tsc.organization_value)::text)))
     LEFT JOIN dc_ust.v_cert_of_installation_xwalk coi ON ((x."CertOfInstallation" = (coi.organization_value)::text)))
     LEFT JOIN ( SELECT compartment."TankID",
            count(compartment."CompartmentID") AS comp_count
           FROM dc_ust.compartment
          GROUP BY compartment."TankID") c ON ((x."TankID" = c."TankID")))
 where not exists
	(select 1 from dc_ust.erg_unregulated_tanks unreg
	where x."FacilityID"::varchar(50) = unreg.facility_id and x."TankName"::int = unreg.tank_id);



create or replace view dc_ust.v_ust_tank_substance as
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    (t."TankName")::integer AS tank_id,
    s.substance_id,
    (x."CompartmentSubstanceCASNO")::text AS substance_casno
   FROM ((dc_ust.compartment x
     JOIN dc_ust.tank t ON ((((x."FacilityID")::text = (t."FacilityID")::text) AND (x."TankID" = t."TankID"))))
     LEFT JOIN dc_ust.v_substance_xwalk s ON ((x."CompartmentSubstanceStored" = (s.organization_value)::text)))
  WHERE (x."CompartmentSubstanceStored" IS NOT NULL)
 and not exists
	(select 1 from dc_ust.erg_unregulated_tanks unreg
	where x."FacilityID"::varchar(50) = unreg.facility_id and t."TankName"::int = unreg.tank_id);



create or replace view dc_ust.v_ust_compartment as
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    (t."TankName")::integer AS tank_id,
    (x."CompartmentName")::integer AS compartment_id,
    x."CompartmentID" AS compartment_name,
    cs.compartment_status_id,
    (x."CompartmentCapacityGallons")::integer AS compartment_capacity_gallons,
    x."OverfillPreventionBallFloatValve" AS overfill_prevention_ball_float_valve,
    x."OverfillPreventionFlowShutoffDevice" AS overfill_prevention_flow_shutoff_device,
    x."OverfillPreventionHighLevelAlarm" AS overfill_prevention_high_level_alarm,
    x."OverfillPreventionOther" AS overfill_prevention_other,
    x."OverfillPreventionUnknown" AS overfill_prevention_unknown,
    x."SpillBucketInstalled" AS spill_bucket_installed,
    x."TankInterstitialMonitoring" AS tank_interstitial_monitoring,
    x."TankAutomaticTankGaugingReleaseDetection" AS tank_automatic_tank_gauging_release_detection,
    x."AutomaticTankGauging ContinuousLeakDetection" AS automatic_tank_gauging_continuous_leak_detection,
    x."TankManualTankGauging" AS tank_manual_tank_gauging,
    x."TankStatisticalInventoryReconciliation" AS tank_statistical_inventory_reconciliation,
    x."TankTightnessTesting" AS tank_tightness_testing,
    x."TankInventoryControl" AS tank_inventory_control,
    x."TankGroundwaterMonitoring" AS tank_groundwater_monitoring,
    x."TankVaporMonitoring" AS tank_vapor_monitoring,
    x."TankSubpartKTightnessTesting" AS tank_subpart_k_tightness_testing,
    x."TankSubpartKOther" AS tank_subpart_k_other,
    x."TankOtherReleaseDetection" AS tank_other_release_detection
   FROM ((dc_ust.compartment x
     JOIN dc_ust.tank t ON ((((x."FacilityID")::text = (t."FacilityID")::text) AND (x."TankID" = t."TankID"))))
     LEFT JOIN dc_ust.v_compartment_status_xwalk cs ON ((x."CompartmentStatus" = (cs.organization_value)::text)))
 where not exists
	(select 1 from dc_ust.erg_unregulated_tanks unreg
	where x."FacilityID"::varchar(50) = unreg.facility_id and t."TankName"::int = unreg.tank_id);



create or replace view dc_ust.v_ust_compartment_substance as
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    t."TankName" AS tank_id,
    x."CompartmentName" AS compartment_id,
    s.substance_id
   FROM ((dc_ust.compartment x
     LEFT JOIN dc_ust.tank t ON (((x."FacilityID" = t."FacilityID") AND (x."TankID" = t."TankID"))))
     LEFT JOIN dc_ust.v_substance_xwalk s ON ((x."CompartmentSubstanceStored" = (s.organization_value)::text)))
  WHERE (x."CompartmentSubstanceStored" IS NOT NULL)
 and not exists
	(select 1 from dc_ust.erg_unregulated_tanks unreg
	where x."FacilityID"::varchar(50) = unreg.facility_id and t."TankName"::int = unreg.tank_id);



create or replace view dc_ust.v_ust_piping as
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    (t."TankName")::integer AS tank_id,
    (c."CompartmentName")::integer AS compartment_id,
    x."PipingID" AS piping_id,
    ps.piping_style_id,
    x."Safe Suction" AS safe_suction,
    x."American Suction" AS american_suction,
    x."Piping Material FRP" AS piping_material_frp,
    x."Piping Material Gal Steel" AS piping_material_gal_steel,
    x."Piping Material Stainless Steel" AS piping_material_stainless_steel,
    x."Piping Material Steel" AS piping_material_steel,
    x."Piping Material Copper" AS piping_material_copper,
    x."Piping Material Flex" AS piping_material_flex,
    x."Piping Material No Piping" AS piping_material_no_piping,
    x."Piping Material Other" AS piping_material_other,
    x."Piping Material Unknown" AS piping_material_unknown,
    x."Piping Corrosion Protection Sacrificial Anode" AS piping_corrosion_protection_sacrificial_anode,
    x."Piping Corrosion Protection Impressed Current" AS piping_corrosion_protection_impressed_current,
    x."Piping Corrosion Protection Cathodic Not Required" AS piping_corrosion_protection_cathodic_not_required,
    x."Piping Corrosion Protection Other" AS piping_corrosion_protection_other,
    x."Piping Corrosion Protection Unknown" AS piping_corrosion_protection_unknown,
    x."Piping Line Leak Detector" AS piping_line_leak_detector,
    x."Piping Automated Intersticial Monitoring" AS piping_automated_interstitial_monitoring,
    x."Piping Line Test Annual" AS piping_line_test_annual,
    x."Piping Line Test3yr" AS piping_line_test3yr,
    x."Piping Groundwater Monitoring" AS piping_groundwater_monitoring,
    x."Piping Vapor Monitoring" AS piping_vapor_monitoring,
    x."Piping Interstitial Monitoring" AS piping_interstitial_monitoring,
    x."Piping Statistical Inventory Reconciliation" AS piping_statistical_inventory_reconciliation,
    x."Piping Release Detection Other" AS piping_release_detection_other,
    x."Piping Subpart KLine Test" AS piping_subpart_k_line_test,
    x."Piping Subpart KOther" AS piping_subpart_k_other,
    x."Pipe Tank Top Sump" AS pipe_tank_top_sump,
    pw.piping_wall_type_id,
    x."Pipe Trench Liner" AS pipe_trench_liner,
    x."Pipe Secondary Containment Other" AS pipe_secondary_containment_other,
    x."Pipe Secondary Containment Unknown" AS pipe_secondary_containment_unknown
   FROM ((((dc_ust.piping x
     JOIN dc_ust.tank t ON ((((x."FacilityID")::text = (t."FacilityID")::text) AND (x."TankID" = t."TankID"))))
     JOIN dc_ust.compartment c ON ((((x."FacilityID")::text = (c."FacilityID")::text) AND (x."CompartmentID" = c."CompartmentID"))))
     LEFT JOIN dc_ust.v_piping_style_xwalk ps ON ((x."Piping Style" = (ps.organization_value)::text)))
     LEFT JOIN dc_ust.v_piping_wall_type_xwalk pw ON ((x."Piping Wall Type" = (pw.organization_value)::text)))
 where not exists
	(select 1 from dc_ust.erg_unregulated_tanks unreg
	where x."FacilityID"::varchar(50) = unreg.facility_id and t."TankName"::int = unreg.tank_id);



create or replace view dc_ust.v_ust_facility_dispenser as
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    x."Dispenser ID" AS dispenser_id,
    max(x."Dispenser UDC") AS dispenser_udc
   FROM dc_ust.dispenser x
  GROUP BY x."FacilityID", x."Dispenser ID"
 where x."FacilityID"::varchar(50) not in (select facility_id from dc_ust.erg_unregulated_facilities);