create or replace view "public"."v_ust_piping" as
 SELECT DISTINCT d.ust_control_id,
    d.facility_id AS "FacilityID",
    c.tank_id AS "TankID",
    c.tank_name AS "TankName",
    b.compartment_id AS "CompartmentID",
    b.compartment_name AS "CompartmentName",
    a.piping_id AS "PipingID",
    ps.piping_style AS "PipingStyle",
    a.safe_suction AS "SafeSuction",
    a.american_suction AS "AmericanSuction",
    a.high_pressure_or_bulk_piping AS "HighPressureOrBulkPiping",
    a.piping_material_frp AS "PipingMaterialFRP",
    a.piping_material_gal_steel AS "PipingMaterialGalSteel",
    a.piping_material_stainless_steel AS "PipingMaterialStainlessSteel",
    a.piping_material_steel AS "PipingMaterialSteel",
    a.piping_material_copper AS "PipingMaterialCopper",
    a.piping_material_flex AS "PipingMaterialFlex",
    a.piping_material_no_piping AS "PipingMaterialNoPiping",
    a.piping_material_other AS "PipingMaterialOther",
    a.piping_material_unknown AS "PipingMaterialUnknown",
    a.piping_flex_connector AS "PipingFlexConnector",
        CASE
            WHEN (x.cp_type = 'piping'::text) THEN (((a.piping_corrosion_protection_sacrificial_anode)::text || ' (inferred)'::text))::character varying
            ELSE a.piping_corrosion_protection_sacrificial_anode
        END AS "PipingCorrosionProtectionSacrificialAnode",
    a.piping_corrosion_protection_impressed_current AS "PipingCorrosionProtectionImpressedCurrent",
    a.piping_corrosion_protection_cathodic_not_required AS "PipingCorrosionProtectionCathodicNotRequired",
    a.piping_corrosion_protection_other AS "PipingCorrosionProtectionOther",
    a.piping_corrosion_protection_unknown AS "PipingCorrosionProtectionUnknown",
    a.piping_line_leak_detector AS "PipingLineLeakDetector",
    a.piping_automated_interstitial_monitoring AS "PipingAutomatedInterstitialMonitoring",
    a.piping_line_test_annual AS "PipingLineTestAnnual",
    a.piping_line_test3yr AS "PipingLineTest3yr",
    a.piping_groundwater_monitoring AS "PipingGroundwaterMonitoring",
    a.piping_vapor_monitoring AS "PipingVaporMonitoring",
    a.piping_automated_interstitial_monitoring AS "PipingInterstitialMonitoring",
    a.piping_statistical_inventory_reconciliation AS "PipingStatisticalInventoryReconciliation",
    a.piping_release_detection_other AS "PipingReleaseDetectionOther",
    a.piping_subpart_k_line_test AS "PipingSubpartKLineTest",
    a.piping_subpart_k_other AS "PipingSubpartKOther",
    a.pipe_tank_top_sump AS "PipeTankTopSump",
    pt.pipe_tank_top_sump_wall_type AS "PipeTankTopSumpWallType",
    pw.piping_wall_type AS "PipingWallType",
    a.pipe_trench_liner AS "PipeTrenchLiner",
    a.pipe_secondary_containment_other AS "PipeSecondaryContainmentOther",
    a.pipe_secondary_containment_unknown AS "PipeSecondaryContainmentUnknown",
    a.piping_comment AS "PipingComment"
   FROM (((((((ust_piping a
     JOIN ust_compartment b ON ((a.ust_compartment_id = b.ust_compartment_id)))
     JOIN ust_tank c ON ((b.ust_tank_id = c.ust_tank_id)))
     JOIN ust_facility d ON ((c.ust_facility_id = d.ust_facility_id)))
     LEFT JOIN piping_styles ps ON ((a.piping_style_id = ps.piping_style_id)))
     LEFT JOIN pipe_tank_top_sump_wall_types pt ON ((a.pipe_tank_top_sump_wall_type_id = pt.pipe_tank_top_sump_wall_type_id)))
     LEFT JOIN piping_wall_types pw ON ((a.piping_wall_type_id = pw.piping_wall_type_id)))
     LEFT JOIN v_cp_inferred x ON (((d.ust_control_id = x.ust_control_id) AND (x.cp_type = 'piping'::text))));