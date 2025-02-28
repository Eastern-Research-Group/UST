create or replace view "vt_ust"."v_ust_piping" as
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
    x."PipingAutomatedIntersticialMonitoring" AS piping_automated_intersticial_monitoring,
    x."PipingLineTestAnnual" AS piping_line_test_annual,
    x."PipingLineTest3yr" AS piping_line_test3yr,
    x."PipingInterstitialMonitoring" AS piping_interstitial_monitoring,
    x."PipeTankTopSump" AS pipe_tank_top_sump
   FROM (vt_ust.piping x
     LEFT JOIN vt_ust.v_piping_style_xwalk ps ON ((x."PipingStyle" = (ps.organization_value)::text)))
  WHERE (x."FacilityID" IN ( SELECT f."FacilityID"
           FROM vt_ust.facility f));