------------------------------------------------------------------------------------------------------------------------



/*********** v_ust_tank ***********/
--There are 1066 rows in vt_ust.v_ust_tank that do not exist in public.v_ust_tank

select * from vt_ust.v_ust_tank a
where not exists
	(select 1 from public.v_ust_tank b
	where a.facility_id = b."FacilityID" and a.tank_id = b."TankID")
order by a.facility_id,a.tank_id;

--View definition for vt_ust.v_ust_tank:
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
  WHERE (NOT (EXISTS ( SELECT 1
           FROM vt_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id)))));


/*********** v_ust_tank_substance ***********/
--There are 1051 rows in vt_ust.v_ust_tank_substance that do not exist in public.v_ust_tank_substance

select * from vt_ust.v_ust_tank_substance a
where not exists
	(select 1 from public.v_ust_tank_substance b join public.substances c on b."Substance" = c.substance
	where a.facility_id = b."FacilityID" and a.tank_id = b."TankID" and a.substance_id = c."substance_id")
order by a.facility_id,a.tank_id,a.substance_id;

--View definition for vt_ust.v_ust_tank_substance:
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    (x."TankID")::integer AS tank_id,
    s.substance_id
   FROM (vt_ust.compartment x
     LEFT JOIN vt_ust.v_substance_xwalk s ON ((x."CompartmentSubstanceStored" = (s.organization_value)::text)))
  WHERE ((x."CompartmentSubstanceStored" IS NOT NULL) AND (NOT (EXISTS ( SELECT 1
           FROM vt_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id))))));


/*********** v_ust_compartment ***********/
--There are 1071 rows in vt_ust.v_ust_compartment that do not exist in public.v_ust_compartment

select * from vt_ust.v_ust_compartment a
where not exists
	(select 1 from public.v_ust_compartment b
	where a.facility_id = b."FacilityID" and a.tank_id = b."TankID" and a.compartment_id = b."CompartmentID")
order by a.facility_id,a.tank_id,a.compartment_id;

--View definition for vt_ust.v_ust_compartment:
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
  WHERE (NOT (EXISTS ( SELECT 1
           FROM vt_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id)))));


/*********** v_ust_compartment_substance ***********/
--There are 1099 rows in vt_ust.v_ust_compartment_substance that do not exist in public.v_ust_compartment_substance

select * from vt_ust.v_ust_compartment_substance a
where not exists
	(select 1 from public.v_ust_compartment_substance b join public.substances c on b."Substance" = c.substance
	where a.facility_id = b."FacilityID" and a.tank_id = b."TankID" and a.compartment_id = b."CompartmentID" and a.substance_id = c."substance_id")
order by a.facility_id,a.tank_id,a.compartment_id,a.substance_id;

--View definition for vt_ust.v_ust_compartment_substance:
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    (x."TankID")::integer AS tank_id,
    x."CompartmentID" AS compartment_id,
    s.substance_id
   FROM (vt_ust.compartment x
     LEFT JOIN vt_ust.v_substance_xwalk s ON ((x."CompartmentSubstanceStored" = (s.organization_value)::text)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM vt_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id)))));


/*********** v_ust_piping ***********/
--There are 1086 rows in vt_ust.v_ust_piping that do not exist in public.v_ust_piping

select * from vt_ust.v_ust_piping a
where not exists
	(select 1 from public.v_ust_piping b
	where a.facility_id = b."FacilityID" and a.tank_id = b."TankID" and a.compartment_id = b."CompartmentID" and a.piping_id = b."PipingID")
order by a.facility_id,a.tank_id,a.compartment_id,a.piping_id;

--View definition for vt_ust.v_ust_piping:
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
  WHERE (NOT (EXISTS ( SELECT 1
           FROM vt_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id)))));