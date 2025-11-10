create or replace view "az_ust"."v_ust_piping" as
 SELECT DISTINCT (a."FacilityID")::character varying(50) AS facility_id,
    (a."TankName")::integer AS tank_id,
    d.compartment_id,
    (d.piping_id)::character varying(50) AS piping_id,
    b.piping_style_id,
    (a."PipingMaterialFRP")::character varying(3) AS piping_material_frp,
    (a."PipingMaterialSteel")::character varying(3) AS piping_material_steel,
    (a."PipingMaterialCopper")::character varying(3) AS piping_material_copper,
    (a."PipingMaterialFlex")::character varying(3) AS piping_material_flex,
    (a."PipingMaterialNoPiping")::character varying(3) AS piping_material_no_piping,
    (a."PipingMaterialOther")::character varying(3) AS piping_material_other,
    (a."PipingMaterialUnknown")::character varying(3) AS piping_material_unknown,
    (a."PipingCorrosionProtectionSacrificialAnode")::character varying(7) AS piping_corrosion_protection_sacrificial_anode,
    (a."PipingCorrosionProtectionImpressedCurrent")::character varying(7) AS piping_corrosion_protection_impressed_current,
    (a."PipingLineLeakDetector")::character varying(7) AS piping_line_leak_detector,
    (a."PipingLineTestAnnual")::character varying(7) AS piping_line_test_annual,
    (a."PipingGroundwaterMonitoring")::character varying(7) AS piping_groundwater_monitoring,
    (a."PipingVaporMonitoring")::character varying(7) AS piping_vapor_monitoring,
    (a."PipingInterstitialMonitoring")::character varying(7) AS piping_interstitial_monitoring,
    (a."PipingStatisticalInventoryReconciliation")::character varying(7) AS piping_statistical_inventory_reconciliation,
    (a."PipingReleaseDetectionOther")::character varying(7) AS piping_release_detection_other,
    c.piping_wall_type_id
   FROM (((az_ust.ust_piping a
     JOIN az_ust.erg_piping_id d ON (((a."FacilityID" = (d.facility_id)::text) AND ((a."TankName")::text = (d.tank_name)::text) AND (a."CompartmentName" = (d.compartment_name)::text))))
     LEFT JOIN az_ust.v_piping_style_xwalk b ON ((a."PipingStyle" = (b.organization_value)::text)))
     LEFT JOIN az_ust.v_piping_wall_type_xwalk c ON ((a."PipingWallType" = (c.organization_value)::text)))
  WHERE ((EXISTS ( SELECT 1
           FROM az_ust.erg_v_ust_tank x
          WHERE ((a."FacilityID" = (x.facility_id)::text) AND (a."TankName" = x.tank_id)))) AND (NOT (EXISTS ( SELECT 1
           FROM az_ust.erg_unregulated_tanks unreg
          WHERE ((((a."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((a."TankName")::integer = unreg.tank_id))))));