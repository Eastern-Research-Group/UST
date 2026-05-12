create or replace view "il_ust"."v_ust_piping" as
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    x."TankID" AS tank_id,
    (x."CompartmentID")::integer AS compartment_id,
    (x."PipingID")::character varying(50) AS piping_id,
    ps.piping_style_id,
        CASE
            WHEN (x."SafeSuction" = 'Yes'::text) THEN 'Yes'::text
            WHEN (x."SafeSuction" = 'No'::text) THEN 'No'::text
            ELSE 'Unknown'::text
        END AS safe_suction,
        CASE
            WHEN (x."AmericanSuction" = 'Yes'::text) THEN 'Yes'::text
            WHEN (x."AmericanSuction" = 'No'::text) THEN 'No'::text
            ELSE 'Unknown'::text
        END AS american_suction,
    x."HighPressureOrBulkPiping" AS high_pressure_or_bulk_piping,
    x."PipingMaterialFRP" AS piping_material_frp,
    x."PipingMaterialGalSteel" AS piping_material_gal_steel,
    x."PipingMaterialStainlessSteel" AS piping_material_stainless_steel,
    x."PipingMaterialSteel" AS piping_material_steel,
    x."PipingMaterialCopper" AS piping_material_copper,
    x."PipingMaterialFlex" AS piping_material_flex,
    x."PipingMaterialNoPiping" AS piping_material_no_piping,
    x."PipingFlexConnector" AS piping_flex_connector,
    x."PipingCorrosionProtectionSacrificialAnode" AS piping_corrosion_protection_sacrificial_anode,
    x."PipingCorrosionProtectionImpressedCurrent" AS piping_corrosion_protection_impressed_current,
    x."PipingCorrosionProtectionCathodicNotRequired" AS piping_corrosion_protection_cathodic_not_required,
    x."PipingCorrosionProtectionOther" AS piping_corrosion_protection_other,
    x."PipingCorrosionProtectionUnknown" AS piping_corrosion_protection_unknown,
    x."PipingLineLeakDetector" AS piping_line_leak_detector,
    x."PipingAutomatedIntersticialMonitoring" AS piping_automated_interstitial_monitoring,
    x."PipingLineTestAnnual" AS piping_line_test_annual,
    x."PipingLineTest3yr" AS piping_line_test3yr,
    x."PipingGroundwaterMonitoring" AS piping_groundwater_monitoring,
    x."PipingVaporMonitoring" AS piping_vapor_monitoring,
    x."PipingInterstitialMonitoring" AS piping_interstitial_monitoring,
    x."PipingSubpartKLineTest" AS piping_subpart_k_line_test,
    x."PipingSubpartKOther" AS piping_subpart_k_other,
    x."PipeTankTopSump" AS pipe_tank_top_sump,
    tt.pipe_tank_top_sump_wall_type_id,
    wt.piping_wall_type_id,
    x."PipeSecondaryContainmentOther" AS pipe_secondary_containment_other
   FROM (((il_ust.piping x
     LEFT JOIN il_ust.v_piping_style_xwalk ps ON ((x."PipingStyle" = (ps.organization_value)::text)))
     LEFT JOIN il_ust.v_pipe_tank_top_sump_wall_type_xwalk tt ON ((x."PipeTankTopSumpWallType" = (tt.organization_value)::text)))
     LEFT JOIN il_ust.v_piping_wall_type_xwalk wt ON ((x."PipingWallType" = (wt.organization_value)::text)))
  WHERE ((NOT (EXISTS ( SELECT 1
           FROM il_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankName")::integer = unreg.tank_id))))) AND (NOT (EXISTS ( SELECT 1
           FROM il_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id))))));