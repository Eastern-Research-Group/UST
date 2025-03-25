------------------------------------------------------------------------------------------------------------------------------------------------------------------------



create or replace view de_ust.v_ust_facility as
 SELECT DISTINCT x."FacilityID" AS facility_id,
    x."FacilityName" AS facility_name,
    ot.owner_type_id,
    ft.facility_type_id AS facility_type1,
    x."FacilityAddress1" AS facility_address1,
    x."FacilityAddress2" AS facility_address2,
    x."FacilityCity" AS facility_city,
    x."FacilityCounty" AS facility_county,
    x."FacilityZipCode" AS facility_zip_code,
    'DE'::text AS facility_state,
    (x."FacilityEPARegion")::integer AS facility_epa_region,
    x."FacilityLatitude" AS facility_latitude,
    x."FacilityLongitude" AS facility_longitude,
    cs.coordinate_source_id,
    x."FacilityOwnerCompanyName" AS facility_owner_company_name,
    x."FacilityOperatorCompanyName" AS facility_operator_company_name,
        CASE
            WHEN (max(
            CASE
                WHEN (x."FinancialResponsibilityObtained" = 'Yes'::text) THEN 1
                ELSE 0
            END) OVER (PARTITION BY x."FacilityID") = 1) THEN 'Yes'::text
            WHEN (max(
            CASE
                WHEN (x."FinancialResponsibilityObtained" = 'No'::text) THEN 1
                ELSE 0
            END) OVER (PARTITION BY x."FacilityID") = 1) THEN 'No'::text
            WHEN (max(
            CASE
                WHEN (x."FinancialResponsibilityObtained" = 'Unknown'::text) THEN 1
                ELSE 0
            END) OVER (PARTITION BY x."FacilityID") = 1) THEN 'Unknown'::text
            ELSE 'N/A'::text
        END AS financial_responsibility_obtained,
        CASE
            WHEN (x."FinancialResponsibilityBondRatingTest" = 'YES'::text) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_bond_rating_test,
        CASE
            WHEN (x."FinancialResponsibilityCommercialInsurance" = 'YES'::text) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_commercial_insurance,
        CASE
            WHEN (x."FinancialResponsibilityGuarantee" = 'YES'::text) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_guarantee,
        CASE
            WHEN (x."FinancialResponsibilityLetterOfCredit" = 'YES'::text) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_letter_of_credit,
        CASE
            WHEN (x."FinancialResponsibilityLocalGovernmentFinancialTest" = 'YES'::text) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_local_government_financial_test,
        CASE
            WHEN (x."FinancialResponsibilitySelfInsuranceFinancialTest" = 'YES'::text) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_self_insurance_financial_test,
        CASE
            WHEN (x."FinancialResponsibilityStateFund" = 'Yes'::text) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_state_fund,
        CASE
            WHEN (x."FinancialResponsibilitySuretyBond" = 'YES'::text) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_surety_bond,
        CASE
            WHEN (x."FinancialResponsibilityTrustFund" = 'YES'::text) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_trust_fund,
        CASE
            WHEN (x."USTReportedRelease" = 'Yes'::text) THEN 'Yes'::text
            ELSE 'Unknown'::text
        END AS ust_reported_release,
    x."AssociatedLUSTID" AS associated_ust_release_id
   FROM ((((de_ust.facility x
     LEFT JOIN de_ust.v_owner_type_xwalk ot ON ((x."OwnerType" = (ot.organization_value)::text)))
     LEFT JOIN de_ust.v_facility_type_xwalk ft ON ((x."FacilityType1" = (ft.organization_value)::text)))
     LEFT JOIN de_ust.v_state_xwalk s ON ((x."FacilityState" = (s.organization_value)::text)))
     LEFT JOIN de_ust.v_coordinate_source_xwalk cs ON ((x."FacilityCoordinateSource" = (cs.organization_value)::text)))
 where x."FacilityID"::varchar(50) not in (select facility_id from de_ust.erg_unregulated_facilities);



create or replace view de_ust.v_ust_tank as
 SELECT DISTINCT ON (x."TankID") x."FacilityID" AS facility_id,
    (x."TankID")::integer AS tank_id,
    x."TankName" AS tank_name,
    tl.tank_location_id,
    ts.tank_status_id,
    x."FederallyRegulated" AS federally_regulated,
    x."FieldConstructed" AS field_constructed,
    x."EmergencyGenerator" AS emergency_generator,
    x."AirportHydrantSystem" AS airport_hydrant_system,
    x."MultipleTanks" AS multiple_tanks,
    (x."TankClosureDate")::date AS tank_closure_date,
    (x."TankInstallationDate")::date AS tank_installation_date,
    x."CompartmentalizedUST" AS compartmentalized_ust,
    (x."NumberOfCompartments")::integer AS number_of_compartments,
    tm.tank_material_description_id,
    x."TankCorrosionProtectionSacrificialAnode" AS tank_corrosion_protection_sacrificial_anode,
    x."TankCorrosionProtectionImpressedCurrent" AS tank_corrosion_protection_impressed_current,
    x."TankCorrosionProtectionCathodicNotRequired" AS tank_corrosion_protection_cathodic_not_required,
    x."TankCorrosionProtectionInteriorLining" AS tank_corrosion_protection_interior_lining,
    x."TankCorrosionProtectionOther" AS tank_corrosion_protection_other,
    x."TankCorrosionProtectionUnknown" AS tank_corrosion_protection_unknown,
    sc.tank_secondary_containment_id,
    c.cert_of_installation_id
   FROM (((((de_ust.tank x
     LEFT JOIN de_ust.v_cert_of_installation_xwalk c ON ((x."CertOfInstallation" = (c.organization_value)::text)))
     LEFT JOIN de_ust.v_tank_location_xwalk tl ON ((x."TankLocation" = (tl.organization_value)::text)))
     LEFT JOIN de_ust.v_tank_status_xwalk ts ON ((x."TankStatus" = (ts.organization_value)::text)))
     LEFT JOIN de_ust.v_tank_material_description_xwalk tm ON ((x."TankMaterialDescription" = (tm.organization_value)::text)))
     LEFT JOIN de_ust.v_tank_secondary_containment_xwalk sc ON ((x."TankSecondaryContainment" = (sc.organization_value)::text)))
  ORDER BY x."TankID", COALESCE(x."TankClosureDate", '1970-01-01 00:00:00'::timestamp without time zone) DESC, COALESCE(x."TankInstallationDate", '1970-01-01 00:00:00'::timestamp without time zone) DESC
 where not exists
	(select 1 from de_ust.erg_unregulated_tanks unreg
	where x."FacilityID"::varchar(50) = unreg.facility_id and x."TankID"::int = unreg.tank_id);



create or replace view de_ust.v_ust_tank_substance as
 SELECT DISTINCT x."FacilityID" AS facility_id,
    (x."TankID")::integer AS tank_id,
    s.substance_id,
    x."CompartmentSubstanceCASNO" AS substance_casno
   FROM (de_ust.compartment x
     LEFT JOIN de_ust.v_substance_xwalk s ON ((x."CompartmentSubstanceStored" = (s.organization_value)::text)))
  WHERE (s.substance_id IS NOT NULL)
 and not exists
	(select 1 from de_ust.erg_unregulated_tanks unreg
	where x."FacilityID"::varchar(50) = unreg.facility_id and x."TankID"::int = unreg.tank_id);



create or replace view de_ust.v_ust_compartment as
 SELECT DISTINCT x."FacilityID" AS facility_id,
    (x."TankID")::integer AS tank_id,
        CASE
            WHEN ((x."CompartmentID")::integer IS NULL) THEN 28718
            ELSE (x."CompartmentID")::integer
        END AS compartment_id,
    x."CompartmentName" AS compartment_name,
    cs.compartment_status_id,
    (x."CompartmentCapacityGallons")::integer AS compartment_capacity_gallons,
        CASE
            WHEN (x."OverfillPreventionOther" = 'Yes'::text) THEN 'Yes'::text
            WHEN (x."OverfillPreventionOther" = 'No'::text) THEN 'No'::text
            ELSE 'Unknown'::text
        END AS overfill_prevention_other,
    x."OverfillPreventionUnknown" AS overfill_prevention_unknown,
    x."OverfillPreventionNotRequired" AS overfill_prevention_not_required,
        CASE
            WHEN (x."SpillBucketInstalled" = 'Yes'::text) THEN 'Yes'::text
            ELSE 'No'::text
        END AS spill_bucket_installed,
    x."SpillPreventionNotRequired" AS spill_prevention_not_required,
    x."TankInterstitialMonitoring" AS tank_interstitial_monitoring,
    x."TankAutomaticTankGaugingReleaseDetection" AS tank_automatic_tank_gauging_release_detection,
    x."AutomaticTankGaugingContinuousLeakDetection" AS automatic_tank_gauging_continuous_leak_detection,
    x."TankManualTankGauging" AS tank_manual_tank_gauging,
    x."TankStatisticalInventoryReconciliation" AS tank_statistical_inventory_reconciliation,
    x."TankTightnessTesting" AS tank_tightness_testing,
    x."TankInventoryControl" AS tank_inventory_control,
    x."TankGroundwaterMonitoring" AS tank_groundwater_monitoring,
    x."TankVaporMonitoring" AS tank_vapor_monitoring,
    x."TankSubpartKTightnessTesting" AS tank_subpart_k_tightness_testing,
    x."TankSubpartKOther" AS tank_subpart_k_other,
    x."TankOtherReleaseDetection" AS tank_other_release_detection
   FROM (de_ust.compartment x
     LEFT JOIN de_ust.v_compartment_status_xwalk cs ON ((x."CompartmentStatus" = (cs.organization_value)::text)))
 where not exists
	(select 1 from de_ust.erg_unregulated_tanks unreg
	where x."FacilityID"::varchar(50) = unreg.facility_id and x."TankID"::int = unreg.tank_id);



create or replace view de_ust.v_ust_compartment_substance as
 SELECT DISTINCT x."FacilityID" AS facility_id,
    (x."TankID")::integer AS tank_id,
    (x."CompartmentID")::integer AS compartment_id,
    s.substance_id
   FROM (de_ust.compartment x
     LEFT JOIN de_ust.v_substance_xwalk s ON ((x."CompartmentSubstanceStored" = (s.organization_value)::text)))
  WHERE (s.substance_id IS NOT NULL)
 and not exists
	(select 1 from de_ust.erg_unregulated_tanks unreg
	where x."FacilityID"::varchar(50) = unreg.facility_id and x."TankID"::int = unreg.tank_id);



create or replace view de_ust.v_ust_piping as
 SELECT DISTINCT x."FacilityID" AS facility_id,
    (c."TankID")::integer AS tank_id,
    (c."CompartmentID")::integer AS compartment_id,
    (t.piping_id)::text AS piping_id,
    ps.piping_style_id,
    x."SafeSuction" AS safe_suction,
    x."AmericanSuction" AS american_suction,
    x."HighPressureOrBulkPiping" AS high_pressure_or_bulk_piping,
    x."PipingMaterialFRP" AS piping_material_frp,
    x."PipingMaterialGalSteel" AS piping_material_gal_steel,
    x."PipingMaterialStainlessSteel" AS piping_material_stainless_steel,
    x."PipingMaterialSteel" AS piping_material_steel,
    x."PipingMaterialCopper" AS piping_material_copper,
    x."PipingMaterialFlex" AS piping_material_flex,
    x."PipingMaterialNoPiping" AS piping_material_no_piping,
    x."PipingMaterialOther" AS piping_material_other,
    x."PipingMaterialUnknown" AS piping_material_unknown,
    x."PipingCorrosionProtectionSacrificialAnode" AS piping_corrosion_protection_sacrificial_anode,
    x."PipingCorrosionProtectionImpressedCurrent" AS piping_corrosion_protection_impressed_current,
    x."PipingCorrosionProtectionCathodicNotRequired" AS piping_corrosion_protection_cathodic_not_required,
    x."PipingCorrosionProtectionOther" AS piping_corrosion_protection_other,
    x."PipingCorrosionProtectionUnknown" AS piping_corrosion_protection_unknown,
    x."PipingLineLeakDetector" AS piping_line_leak_detector,
    x."PipingAutomatedIntersticialMonitoring" AS piping_automated_interstitial_monitoring,
    x."PipingLineTestAnnual" AS piping_line_test_annual,
    x."PipingGroundwaterMonitoring" AS piping_groundwater_monitoring,
    x."PipingVaporMonitoring" AS piping_vapor_monitoring,
    x."PipingInterstitialMonitoring" AS piping_interstitial_monitoring,
    x."PipingStatisticalInventoryReconciliation" AS piping_statistical_inventory_reconciliation,
    x."PipingReleaseDetectionOther" AS piping_release_detection_other,
    x."PipingSubpartKLineTest" AS piping_subpart_k_line_test,
    x."PipingSubpartKOther" AS piping_subpart_k_other,
    x."PipeTankTopSump" AS pipe_tank_top_sump,
    wt.piping_wall_type_id,
    x."PipeSecondaryContainmentOther" AS pipe_secondary_containment_other,
    x."PipeSecondaryContainmentUnknown" AS pipe_secondary_containment_unknown
   FROM ((((de_ust.piping x
     JOIN de_ust.compartment c ON (((((x."FacilityID")::character varying(50))::text = ((c."FacilityID")::character varying(50))::text) AND (x."TankName" = c."TankName"))))
     JOIN de_ust.erg_piping_id t ON (((((x."FacilityID")::character varying(50))::text = (t.facility_id)::text) AND (((x."TankName")::character varying(50))::text = (t.tank_name)::text) AND ((x."CompartmentID")::text = (t.compartment_id)::text))))
     LEFT JOIN de_ust.v_piping_style_xwalk ps ON ((x."PipingStyle" = (ps.organization_value)::text)))
     LEFT JOIN de_ust.v_piping_wall_type_xwalk wt ON ((x."PipingWallType" = (wt.organization_value)::text)))
 where not exists
	(select 1 from de_ust.erg_unregulated_tanks unreg
	where x."FacilityID"::varchar(50) = unreg.facility_id and x."TankID"::int = unreg.tank_id);