create or replace view "de_ust"."v_ust_piping" as
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
  WHERE (NOT (EXISTS ( SELECT 1
           FROM de_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((c."TankID")::integer = unreg.tank_id)))));