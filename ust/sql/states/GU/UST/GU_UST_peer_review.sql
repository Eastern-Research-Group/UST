


/*********** v_ust_facility ***********/


--View definition for gu_ust.v_ust_facility:
 SELECT DISTINCT TRIM(BOTH FROM x."Permit Number") AS facility_id,
    x."Facility Name" AS facility_name,
    f.facility_type_id AS facility_type1,
    x."Address" AS facility_address1,
    x."City" AS facility_city,
    'GU'::text AS facility_state,
    9 AS facility_epa_region,
    l."Latitude" AS facility_latitude,
    l."Longitude" AS facility_longitude,
    x."Owner" AS facility_owner_company_name
   FROM ((gu_ust."Facility" x
     LEFT JOIN gu_ust.v_facility_type_xwalk f ON ((x."Facility Description" = (f.organization_value)::text)))
     LEFT JOIN gu_ust.lat_long l ON ((x."Permit Number" = l."AltFacilityID")))
  WHERE (NOT (((x."Permit Number")::character varying(50))::text IN ( SELECT erg_unregulated_facilities.facility_id
           FROM gu_ust.erg_unregulated_facilities)));;




/*********** v_ust_tank ***********/


--View definition for gu_ust.v_ust_tank:
 SELECT DISTINCT TRIM(BOTH FROM x."FacilityID") AS facility_id,
    (x."TankID")::integer AS tank_id,
    x."TankName" AS tank_name,
    ts.tank_status_id,
    x."FederallyRegulated" AS federally_regulated,
        CASE
            WHEN (x."MultipleTanks" <> 1) THEN 'Yes'::text
            WHEN (x."MultipleTanks" = 1) THEN 'No'::text
            ELSE NULL::text
        END AS multiple_tanks,
    (x."TankInstallationDate")::date AS tank_installation_date,
    m.tank_material_description_id,
        CASE
            WHEN (x."TankCorrosionProtectionSacrificialAnode" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_sacrificial_anode,
        CASE
            WHEN (x."TankCorrosionProtectionImpressedCurrent" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_impressed_current,
        CASE
            WHEN (x."TankCorrosionProtectionInteriorLining" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_interior_lining,
        CASE
            WHEN (x."TankCorrosionProtectionOther" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_other,
        CASE
            WHEN (x."TankCorrosionProtectionUnknown" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_unknown,
    sc.tank_secondary_containment_id
   FROM (((gu_ust."Tank" x
     LEFT JOIN gu_ust.v_tank_status_xwalk ts ON ((x."TankStatus" = (ts.organization_value)::text)))
     LEFT JOIN gu_ust.v_tank_material_description_xwalk m ON ((x."TankMaterialDescription" = (m.organization_value)::text)))
     LEFT JOIN gu_ust.v_tank_secondary_containment_xwalk sc ON ((x."TankSecondaryContainment" = (sc.organization_value)::text)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM gu_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id)))));;




/*********** v_ust_tank_substance ***********/


--View definition for gu_ust.v_ust_tank_substance:
 SELECT DISTINCT TRIM(BOTH FROM x."FacilityID") AS facility_id,
    x."TankID" AS tank_id,
        CASE
            WHEN (s.substance_id IS NULL) THEN 47
            ELSE s.substance_id
        END AS substance_id
   FROM ((gu_ust."Tank" x
     LEFT JOIN gu_ust."Compartment" c ON (((x."FacilityID" = c."FacilityID") AND (x."TankID" = c."TankID"))))
     LEFT JOIN gu_ust.v_substance_xwalk s ON ((c."CompartmentSubstanceStored" = (s.organization_value)::text)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM gu_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id)))));;




/*********** v_ust_compartment ***********/


--View definition for gu_ust.v_ust_compartment:
 SELECT DISTINCT TRIM(BOTH FROM x."FacilityID") AS facility_id,
    (x."TankID")::integer AS tank_id,
    c.compartment_id,
        CASE
            WHEN (cs.compartment_status_id IS NULL) THEN 8
            ELSE cs.compartment_status_id
        END AS compartment_status_id,
    (x."CompartmentCapacityGallons")::integer AS compartment_capacity_gallons,
        CASE
            WHEN (x."OverfillPreventionBallFloatValve" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_ball_float_valve,
        CASE
            WHEN (x."OverfillPreventionFlowShutoffDevice" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_flow_shutoff_device,
        CASE
            WHEN (x."OverfillPreventionHighLevelAlarm" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_high_level_alarm,
        CASE
            WHEN (x."OverfillPreventionOther" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_other,
        CASE
            WHEN (x."OverfillPreventionUnknown" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_unknown,
        CASE
            WHEN (x."SpillBucketInstalled" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS spill_bucket_installed,
        CASE
            WHEN (x."TankInterstitialMonitoring" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_interstitial_monitoring,
        CASE
            WHEN (x."TankAutomaticTankGaugingReleaseDetection" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_automatic_tank_gauging_release_detection,
        CASE
            WHEN (x."AutomaticTankGaugingContinuousLeakDetection" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS automatic_tank_gauging_continuous_leak_detection,
        CASE
            WHEN (x."TankManualTankGauging" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_manual_tank_gauging,
        CASE
            WHEN (x."TankTightnessTesting" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_tightness_testing,
        CASE
            WHEN (x."TankInventoryControl" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_inventory_control,
        CASE
            WHEN (x."TankVaporMonitoring" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_vapor_monitoring,
        CASE
            WHEN (x."TankSubpartKOther" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_subpart_k_other,
        CASE
            WHEN (x."TankOtherReleaseDetection" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_other_release_detection
   FROM (((gu_ust."Compartment" x
     LEFT JOIN gu_ust.erg_compartment_id c ON (((TRIM(BOTH FROM x."FacilityID") = TRIM(BOTH FROM c.facility_id)) AND ((x."TankID")::integer = c.tank_id))))
     LEFT JOIN gu_ust."Tank" t ON (((TRIM(BOTH FROM x."FacilityID") = TRIM(BOTH FROM t."FacilityID")) AND (x."TankID" = t."TankID"))))
     LEFT JOIN gu_ust.v_compartment_status_xwalk cs ON ((t."TankStatus" = (cs.organization_value)::text)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM gu_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id)))));;




/*********** v_ust_compartment_substance ***********/


--View definition for gu_ust.v_ust_compartment_substance:
 SELECT DISTINCT TRIM(BOTH FROM x."FacilityID") AS facility_id,
    x."TankID" AS tank_id,
    c.compartment_id,
        CASE
            WHEN (s.substance_id IS NULL) THEN 47
            ELSE s.substance_id
        END AS substance_id
   FROM ((gu_ust."Compartment" x
     LEFT JOIN gu_ust.erg_compartment_id c ON (((TRIM(BOTH FROM x."FacilityID") = TRIM(BOTH FROM c.facility_id)) AND ((x."TankID")::integer = c.tank_id))))
     LEFT JOIN gu_ust.v_substance_xwalk s ON ((x."CompartmentSubstanceStored" = (s.organization_value)::text)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM gu_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id)))));;




/*********** v_ust_piping ***********/


--View definition for gu_ust.v_ust_piping:
 SELECT DISTINCT TRIM(BOTH FROM x."FacilityID") AS facility_id,
    (x."TankID")::integer AS tank_id,
    c.compartment_id,
    (p.piping_id)::text AS piping_id,
    ps.piping_style_id,
        CASE
            WHEN (x."SafeSuction" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS safe_suction,
        CASE
            WHEN (x."AmericanSuction" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS american_suction,
        CASE
            WHEN (x."HighPressureOrBulkPiping" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS high_pressure_or_bulk_piping,
        CASE
            WHEN (x."PipingMaterialFRP" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_frp,
        CASE
            WHEN (x."PipingMaterialGalSteel" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_gal_steel,
        CASE
            WHEN (x."PipingMaterialSteel" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_steel,
        CASE
            WHEN (x."PipingMaterialFlex" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_flex,
        CASE
            WHEN (x."PipingMaterialOther" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_other,
        CASE
            WHEN (x."PipingMaterialUnknown" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_unknown,
        CASE
            WHEN (x."PipingCorrosionProtectionOther" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_corrosion_protection_other,
        CASE
            WHEN (x."PipingCorrosionProtectionUnknown" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_corrosion_protection_unknown,
        CASE
            WHEN (x."PipingLineLeakDetector" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_line_leak_detector,
        CASE
            WHEN (x."PipingLineTestAnnual" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_line_test_annual,
        CASE
            WHEN (x."PipingLineTest3yr" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_line_test3yr,
        CASE
            WHEN (x."PipingInterstitialMonitoring" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_interstitial_monitoring,
        CASE
            WHEN (x."PipingStatisticalInventoryReconciliation" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_statistical_inventory_reconciliation,
        CASE
            WHEN (x."PipingSubpartKOther" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_subpart_k_other,
        CASE
            WHEN (x."PipeSecondaryContainmentOther" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS pipe_secondary_containment_other,
        CASE
            WHEN (x."PipeSecondaryContainmentUnknown" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS pipe_secondary_containment_unknown
   FROM (((gu_ust."Piping" x
     LEFT JOIN gu_ust.erg_compartment_id c ON (((TRIM(BOTH FROM x."FacilityID") = TRIM(BOTH FROM c.facility_id)) AND ((x."TankID")::integer = c.tank_id))))
     LEFT JOIN gu_ust.erg_piping_id p ON (((TRIM(BOTH FROM x."FacilityID") = TRIM(BOTH FROM p.facility_id)) AND ((x."TankID")::integer = p.tank_id) AND (c.compartment_id = p.compartment_id))))
     LEFT JOIN gu_ust.v_piping_style_xwalk ps ON ((x."PipingStyle" = (ps.organization_value)::text)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM gu_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id)))));;

