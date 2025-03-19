create or replace view "az_ust"."v_ust_piping" as
 SELECT DISTINCT (x."FacilityID")::character varying(50) AS facility_id,
    (x."TankName")::integer AS tank_id,
    p.compartment_id,
    (p.piping_id)::character varying(50) AS piping_id,
    ps.piping_style_id,
    (x."PipingMaterialFRP")::character varying(3) AS piping_material_frp,
    (x."PipingMaterialSteel")::character varying(3) AS piping_material_steel,
    (x."PipingMaterialCopper")::character varying(3) AS piping_material_copper,
    (x."PipingMaterialFlex")::character varying(3) AS piping_material_flex,
    (x."PipingMaterialNoPiping")::character varying(3) AS piping_material_no_piping,
    (x."PipingMaterialOther")::character varying(3) AS piping_material_other,
    (x."PipingMaterialUnknown")::character varying(3) AS piping_material_unknown,
    (x."PipingCorrosionProtectionSacrificialAnode")::character varying(7) AS piping_corrosion_protection_sacrificial_anode,
    (x."PipingCorrosionProtectionImpressedCurrent")::character varying(7) AS piping_corrosion_protection_impressed_current,
    (x."PipingLineLeakDetector")::character varying(7) AS piping_line_leak_detector,
    (x."PipingLineTestAnnual")::character varying(7) AS piping_line_test_annual,
    (x."PipingGroundwaterMonitoring")::character varying(7) AS piping_groundwater_monitoring,
    (x."PipingVaporMonitoring")::character varying(7) AS piping_vapor_monitoring,
    (x."PipingInterstitialMonitoring")::character varying(7) AS piping_interstitial_monitoring,
    (x."PipingStatisticalInventoryReconciliation")::character varying(7) AS piping_statistical_inventory_reconciliation,
    (x."PipingReleaseDetectionOther")::character varying(7) AS piping_release_detection_other,
    pw.piping_wall_type_id
   FROM (((az_ust.ust_piping x
     LEFT JOIN az_ust.erg_piping p ON (((x."FacilityID" = (p.facility_id)::text) AND ((x."TankName")::integer = p.tank_id) AND (x."CompartmentName" = (p.compartment_name)::text))))
     LEFT JOIN az_ust.v_piping_style_xwalk ps ON ((x."PipingStyle" = (ps.organization_value)::text)))
     LEFT JOIN az_ust.v_piping_wall_type_xwalk pw ON ((x."PipingWallType" = (pw.organization_value)::text)));