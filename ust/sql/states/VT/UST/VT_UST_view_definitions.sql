------------------------------------------------------------------------------------------------------------------------------------------------------------------------



create or replace view vt_ust.v_ust_facility as
 WITH latlong AS (
         SELECT x_1."FacilityID" AS facility_id,
            x_1."FacilityLatitude",
            x_1."FacilityLongitude",
            row_number() OVER (PARTITION BY x_1."FacilityID" ORDER BY x_1."FacilityLatitude" DESC, x_1."FacilityLongitude" DESC NULLS LAST) AS row_num
           FROM vt_ust.facility x_1
        )
 SELECT DISTINCT (x."FacilityID")::character varying(50) AS facility_id,
    (x."FacilityName")::character varying(100) AS facility_name,
    ft.facility_type_id AS facility_type1,
    ot.owner_type_id,
    (x."FacilityAddress1")::character varying(100) AS facility_address1,
    (x."FacilityCity")::character varying(100) AS facility_city,
    (x."FacilityCounty")::character varying(50) AS facility_county,
    (x."FacilityZipCode")::character varying(10) AS facility_zip_code,
    s.facility_state,
    (x."FacilityEPARegion")::integer AS facility_epa_region,
    ll."FacilityLatitude" AS facility_latitude,
    ll."FacilityLongitude" AS facility_longitude,
    (x."FacilityOwnerCompanyName")::character varying(100) AS facility_owner_company_name,
    x."FacilityOperatorCompanyName" AS facility_operator_company_name,
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
    x."USTReportedRelease" AS ust_reported_release
   FROM ((((vt_ust.facility x
     JOIN latlong ll ON (((x."FacilityID" = ll.facility_id) AND (ll.row_num = 1))))
     LEFT JOIN vt_ust.v_facility_type_xwalk ft ON ((x."OwnerType" = (ft.organization_value)::text)))
     LEFT JOIN vt_ust.v_owner_type_xwalk ot ON ((x."FacilityType1" = (ot.organization_value)::text)))
     LEFT JOIN vt_ust.v_state_xwalk s ON ((x."FacilityState" = (s.organization_value)::text)))
  WHERE (x."FacilityType1" <> 'Wombat'::text)
 and x_1."FacilityID"::varchar(50) not in (select facility_id from vt_ust.erg_unregulated_facilities);



create or replace view vt_ust.v_ust_tank as
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    (x."TankID")::integer AS tank_id,
    x."TankName" AS tank_name,
    tl.tank_location_id,
    ts.tank_status_id,
    x."FederallyRegulated" AS federally_regulated,
    x."EmergencyGenerator" AS emergency_generator,
    x."MultipleTanks" AS multiple_tanks,
        CASE
            WHEN (x."TankInstallationDate" IS NULL) THEN NULL::date
            ELSE (concat((floor(x."TankInstallationDate"))::text, '-01-01'))::date
        END AS tank_installation_date,
    x."CompartmentalizedUST" AS compartmentalized_ust,
    (x."NumberOfCompartments")::integer AS number_of_compartments,
    tm.tank_material_description_id,
        CASE
            WHEN (x."TankCorrosionProtectionSacrificialAnode" = 'No YES'::text) THEN 'Yes'::text
            ELSE x."TankCorrosionProtectionSacrificialAnode"
        END AS tank_corrosion_protection_sacrificial_anode,
    x."TankCorrosionProtectionImpressedCurrent" AS tank_corrosion_protection_impressed_current,
    x."TankCorrosionProtectionCathodicNotRequired" AS tank_corrosion_protection_cathodic_not_required,
    x."TankCorrosionProtectionInteriorLining" AS tank_corrosion_protection_interior_lining,
    x."TankCorrosionProtectionOther" AS tank_corrosion_protection_other,
    tsc.tank_secondary_containment_id
   FROM ((((vt_ust.tank x
     LEFT JOIN vt_ust.v_tank_location_xwalk tl ON ((x."TankLocation" = (tl.organization_value)::text)))
     LEFT JOIN vt_ust.v_tank_status_xwalk ts ON ((x."TankStatus" = (ts.organization_value)::text)))
     LEFT JOIN vt_ust.v_tank_material_description_xwalk tm ON ((x."TankMaterialDescription" = (tm.organization_value)::text)))
     LEFT JOIN vt_ust.v_tank_secondary_containment_xwalk tsc ON ((x."TankSecondaryContainment" = (tsc.organization_value)::text)))
 where not exists
	(select 1 from vt_ust.erg_unregulated_tanks unreg
	where x."FacilityID"::varchar(50) = unreg.facility_id and x."TankID"::int = unreg.tank_id);



create or replace view vt_ust.v_ust_tank_substance as
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    (x."TankID")::integer AS tank_id,
    s.substance_id
   FROM (vt_ust.compartment x
     LEFT JOIN vt_ust.v_substance_xwalk s ON ((x."CompartmentSubstanceStored" = (s.organization_value)::text)))
  WHERE (x."CompartmentSubstanceStored" IS NOT NULL)
 and not exists
	(select 1 from vt_ust.erg_unregulated_tanks unreg
	where x."FacilityID"::varchar(50) = unreg.facility_id and x."TankID"::int = unreg.tank_id);



create or replace view vt_ust.v_ust_compartment as
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    (x."TankID")::integer AS tank_id,
    (x."CompartmentID")::integer AS compartment_id,
    x."CompartmentName" AS compartment_name,
    cs.compartment_status_id,
    (floor(x."CompartmentCapacityGallons"))::integer AS compartment_capacity_gallons,
    x."OverfillPreventionBallFloatValve" AS overfill_prevention_ball_float_valve,
    x."OverfillPreventionFlowShutoffDevice" AS overfill_prevention_flow_shutoff_device,
    x."OverfillPreventionHighLevelAlarm" AS overfill_prevention_high_level_alarm,
    x."OverfillPreventionOther" AS overfill_prevention_other,
    x."OverfillPreventionUnknown" AS overfill_prevention_unknown,
    x."OverfillPreventionNotRequired" AS overfill_prevention_not_required,
        CASE
            WHEN (x."SpillBucketInstalled" = 'Yes'::text) THEN 'Yes'::text
            WHEN (x."SpillBucketInstalled" = 'No'::text) THEN 'No'::text
            ELSE NULL::text
        END AS spill_bucket_installed,
    x."ConcreteBermInstalled" AS concrete_berm_installed,
    x."SpillPreventionOther" AS spill_prevention_other,
    x."SpillPreventionNotRequired" AS spill_prevention_not_required,
    sb.spill_bucket_wall_type_id,
    x."TankInterstitialMonitoring" AS tank_interstitial_monitoring,
        CASE
            WHEN (x."TankAutomaticTankGaugingReleaseDetection" = 'Yes'::text) THEN 'Yes'::text
            ELSE 'Unknown'::text
        END AS tank_automatic_tank_gauging_release_detection,
    x."TankManualTankGauging" AS tank_manual_tank_gauging,
    x."TankStatisticalInventoryReconciliation" AS tank_statistical_inventory_reconciliation
   FROM ((vt_ust.compartment x
     LEFT JOIN vt_ust.v_compartment_status_xwalk cs ON ((x."CompartmentStatus" = (cs.organization_value)::text)))
     LEFT JOIN vt_ust.v_spill_bucket_wall_type_xwalk sb ON ((x."SpillBucketWallType" = (sb.organization_value)::text)))
 where not exists
	(select 1 from vt_ust.erg_unregulated_tanks unreg
	where x."FacilityID"::varchar(50) = unreg.facility_id and x."TankID"::int = unreg.tank_id);



create or replace view vt_ust.v_ust_compartment_substance as
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    (x."TankID")::integer AS tank_id,
    x."CompartmentID" AS compartment_id,
    s.substance_id
   FROM (vt_ust.compartment x
     LEFT JOIN vt_ust.v_substance_xwalk s ON ((x."CompartmentSubstanceStored" = (s.organization_value)::text)))
 where not exists
	(select 1 from vt_ust.erg_unregulated_tanks unreg
	where x."FacilityID"::varchar(50) = unreg.facility_id and x."TankID"::int = unreg.tank_id);



create or replace view vt_ust.v_ust_piping as
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    x."TankID" AS tank_id,
    (x."PipingID")::character varying(50) AS piping_id,
    (x."CompartmentID")::integer AS compartment_id,
    ps.piping_style_id,
    x."PipingMaterialFRP" AS piping_material_frp,
    x."PipingMaterialGalSteel" AS piping_material_gal_steel,
    x."PipingMaterialStainlessSteel" AS piping_material_stainless_steel,
    x."PipingMaterialSteel" AS piping_material_steel,
    x."PipingMaterialCopper" AS piping_material_copper,
    x."PipingMaterialFlex" AS piping_material_flex,
    x."PipingMaterialNoPiping" AS piping_material_no_piping,
    x."PipingMaterialOther" AS piping_material_other,
    x."PipingMaterialUnknown" AS piping_material_unknown,
    x."PipingFlexConnector" AS piping_flex_connector,
    x."PipingCorrosionProtectionSacrificialAnode" AS piping_corrosion_protection_sacrificial_anode,
    x."PipingCorrosionProtectionImpressedCurrent" AS piping_corrosion_protection_impressed_current,
    x."PipingCorrosionProtectionCathodicNotRequired" AS piping_corrosion_protection_cathodic_not_required,
    x."PipingCorrosionProtectionOther" AS piping_corrosion_protection_other,
    x."PipingCorrosionProtectionUnknown" AS piping_corrosion_protection_unknown,
        CASE
            WHEN (x."PipingLineLeakDetector" IS NOT NULL) THEN 'Yes'::text
            ELSE 'Unknown'::text
        END AS piping_line_leak_detector,
    x."PipingAutomatedIntersticialMonitoring" AS piping_automated_interstitial_monitoring,
    x."PipingLineTestAnnual" AS piping_line_test_annual,
    x."PipingLineTest3yr" AS piping_line_test3yr,
    x."PipingInterstitialMonitoring" AS piping_interstitial_monitoring,
    x."PipeTankTopSump" AS pipe_tank_top_sump
   FROM (vt_ust.piping x
     LEFT JOIN vt_ust.v_piping_style_xwalk ps ON ((x."PipingStyle" = (ps.organization_value)::text)))
 where not exists
	(select 1 from vt_ust.erg_unregulated_tanks unreg
	where x."FacilityID"::varchar(50) = unreg.facility_id and x."TankID"::int = unreg.tank_id);