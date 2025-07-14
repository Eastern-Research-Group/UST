------------------------------------------------------------------------------------------------------------------------



/*********** v_ust_compartment ***********/
--There are 7 rows in gu_ust.v_ust_compartment that do not exist in public.v_ust_compartment

select * from gu_ust.v_ust_compartment a
where not exists
	(select 1 from public.v_ust_compartment b
	where a.facility_id = b."FacilityID" and a.tank_id = b."TankID" and a.compartment_id = b."CompartmentID")
order by a.facility_id,a.tank_id,a.compartment_id;

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
     LEFT JOIN gu_ust.erg_compartment_id c ON (((x."FacilityID" = (c.facility_id)::text) AND ((x."TankID")::integer = c.tank_id))))
     LEFT JOIN gu_ust."Tank" t ON (((x."FacilityID" = t."FacilityID") AND (x."TankID" = t."TankID"))))
     LEFT JOIN gu_ust.v_compartment_status_xwalk cs ON ((t."TankStatus" = (cs.organization_value)::text)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM gu_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id)))));


/*********** v_ust_compartment_substance ***********/
--There are 7 rows in gu_ust.v_ust_compartment_substance that do not exist in public.v_ust_compartment_substance

select * from gu_ust.v_ust_compartment_substance a
where not exists
	(select 1 from public.v_ust_compartment_substance b join public.substances c on b."Substance" = c.substance
	where a.facility_id = b."FacilityID" and a.tank_id = b."TankID" and a.compartment_id = b."CompartmentID" and a.substance_id = c."substance_id")
order by a.facility_id,a.tank_id,a.compartment_id,a.substance_id;

--View definition for gu_ust.v_ust_compartment_substance:
 SELECT DISTINCT TRIM(BOTH FROM x."FacilityID") AS facility_id,
    x."TankID" AS tank_id,
    c.compartment_id,
        CASE
            WHEN (s.substance_id IS NULL) THEN 47
            ELSE s.substance_id
        END AS substance_id
   FROM ((gu_ust."Compartment" x
     LEFT JOIN gu_ust.erg_compartment_id c ON (((x."FacilityID" = (c.facility_id)::text) AND ((x."TankID")::integer = c.tank_id))))
     LEFT JOIN gu_ust.v_substance_xwalk s ON ((x."CompartmentSubstanceStored" = (s.organization_value)::text)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM gu_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id)))));


/*********** v_ust_piping ***********/
--There are 7 rows in gu_ust.v_ust_piping that do not exist in public.v_ust_piping

select * from gu_ust.v_ust_piping a
where not exists
	(select 1 from public.v_ust_piping b
	where a.facility_id = b."FacilityID" and a.tank_id = b."TankID" and a.compartment_id = b."CompartmentID" and a.piping_id = b."PipingID")
order by a.facility_id,a.tank_id,a.compartment_id,a.piping_id;

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
     LEFT JOIN gu_ust.erg_compartment_id c ON (((x."FacilityID" = (c.facility_id)::text) AND ((x."TankID")::integer = c.tank_id))))
     LEFT JOIN gu_ust.erg_piping_id p ON (((x."FacilityID" = (p.facility_id)::text) AND ((x."TankID")::integer = p.tank_id) AND (c.compartment_id = p.compartment_id))))
     LEFT JOIN gu_ust.v_piping_style_xwalk ps ON ((x."PipingStyle" = (ps.organization_value)::text)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM gu_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id)))));