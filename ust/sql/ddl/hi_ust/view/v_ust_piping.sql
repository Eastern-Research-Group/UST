create or replace view "hi_ust"."v_ust_piping" as
 SELECT DISTINCT (x."FacilityID")::character varying(50) AS facility_id,
    t.tank_id,
    t.compartment_id,
    (t.piping_id)::character varying(50) AS piping_id,
    ps.piping_style_id,
        CASE
            WHEN (x."PipeMatDesc" = 'Copper'::text) THEN 'Yes'::text
            WHEN (x."PipeMatDesc" IS NULL) THEN NULL::text
            ELSE 'No'::text
        END AS piping_material_copper,
        CASE
            WHEN (x."PipeMatDesc" = 'Flexible Plastic'::text) THEN 'Yes'::text
            WHEN (x."PipeMatDesc" IS NULL) THEN NULL::text
            ELSE 'No'::text
        END AS piping_material_flex,
        CASE
            WHEN (x."PipeMatDesc" = 'Fiberglass Reinforced Plastic'::text) THEN 'Yes'::text
            WHEN (x."PipeMatDesc" IS NULL) THEN NULL::text
            ELSE 'No'::text
        END AS piping_material_frp,
        CASE
            WHEN (x."PipeMatDesc" = 'GALVANIZED STEEL'::text) THEN 'Yes'::text
            WHEN (x."PipeMatDesc" = 'Galvanized Steel'::text) THEN 'Yes'::text
            WHEN (x."PipeMatDesc" IS NULL) THEN NULL::text
            ELSE 'No'::text
        END AS piping_material_gal_steel,
        CASE
            WHEN (x."PipeMatDesc" = 'No Piping'::text) THEN 'Yes'::text
            WHEN (x."PipeMatDesc" IS NULL) THEN NULL::text
            ELSE 'No'::text
        END AS piping_material_no_piping,
        CASE
            WHEN (x."PipeMatDesc" = 'Other'::text) THEN 'Yes'::text
            WHEN (x."PipeMatDesc" = 'Not Listed'::text) THEN 'Yes'::text
            WHEN (x."PipeMatDesc" IS NULL) THEN NULL::text
            ELSE 'No'::text
        END AS piping_material_other,
        CASE
            WHEN (x."PipeMatDesc" = 'BARE STEEL'::text) THEN 'Yes'::text
            WHEN (x."PipeMatDesc" = 'Bare Steel'::text) THEN 'Yes'::text
            WHEN (x."PipeMatDesc" IS NULL) THEN NULL::text
            ELSE 'No'::text
        END AS piping_material_steel,
        CASE
            WHEN (x."PipeMatDesc" = 'Unknown'::text) THEN 'Yes'::text
            WHEN (x."PipeMatDesc" = 'UNKNOWN'::text) THEN 'Yes'::text
            WHEN (x."PipeMatDesc" IS NULL) THEN NULL::text
            ELSE 'No'::text
        END AS piping_material_unknown,
        CASE
            WHEN (x."PipeModDesc" = 'Double-Walled'::text) THEN 2
            WHEN (x."PipeModDesc" IS NULL) THEN 3
            ELSE NULL::integer
        END AS piping_wall_type_id,
        CASE
            WHEN (x."PipingCorrosionProtectionSacrificialAnode" = true) THEN 'Yes'::text
            WHEN (x."PipingCorrosionProtectionSacrificialAnode" = false) THEN 'No'::text
            ELSE NULL::text
        END AS piping_corrosion_protection_sacrificial_anode,
        CASE
            WHEN (x."PipingReleaseDetectionOther" = true) THEN 'Yes'::text
            WHEN (x."PipingReleaseDetectionOther" = false) THEN 'No'::text
            ELSE NULL::text
        END AS piping_release_detection_other,
        CASE
            WHEN (x."PipingStatisticalInventoryReconciliation" = true) THEN 'Yes'::text
            WHEN (x."PipingStatisticalInventoryReconciliation" = false) THEN 'No'::text
            ELSE NULL::text
        END AS piping_statistical_inventory_reconciliation,
        CASE
            WHEN (x."PipingCorrosionProtectionImpressedCurrent" = true) THEN 'Yes'::text
            WHEN (x."PipingCorrosionProtectionImpressedCurrent" = false) THEN 'No'::text
            ELSE NULL::text
        END AS piping_corrosion_protection_impressed_current,
        CASE
            WHEN (x."PipingLineLeakDetector" = true) THEN 'Yes'::text
            WHEN (x."PipingLineLeakDetector" = false) THEN 'No'::text
            ELSE NULL::text
        END AS piping_line_leak_detector,
        CASE
            WHEN (x."PipingLineTestAnnual" = true) THEN 'Yes'::text
            WHEN (x."PipingLineTestAnnual" = false) THEN 'No'::text
            ELSE NULL::text
        END AS piping_line_test_annual,
        CASE
            WHEN (x."PipingGroundwaterMonitoring" = true) THEN 'Yes'::text
            WHEN (x."PipingGroundwaterMonitoring" = false) THEN 'No'::text
            ELSE NULL::text
        END AS piping_groundwater_monitoring,
        CASE
            WHEN (x."PipingVaporMonitoring" = true) THEN 'Yes'::text
            WHEN (x."PipingVaporMonitoring" = false) THEN 'No'::text
            ELSE NULL::text
        END AS piping_vapor_monitoring,
        CASE
            WHEN (x."PipingStyle" = 'Safe Suction'::text) THEN 'Yes'::text
            WHEN (x."PipingStyle" = 'SAFE SUCTION'::text) THEN 'Yes'::text
            WHEN (x."PipingStyle" IS NULL) THEN NULL::text
            ELSE 'No'::text
        END AS safe_suction,
        CASE
            WHEN (x."PipingStyle" = 'U.S. Suction'::text) THEN 'Yes'::text
            WHEN (x."PipingStyle" = 'U.S. SUCTION'::text) THEN 'Yes'::text
            WHEN (x."PipingStyle" IS NULL) THEN NULL::text
            ELSE 'No'::text
        END AS american_suction
   FROM ((hi_ust.piping x
     JOIN hi_ust.erg_piping_id t ON (((((x."FacilityID")::character varying(50))::text = (t.facility_id)::text) AND (((x."TankID")::character varying(50))::text = (t.tank_name)::text))))
     LEFT JOIN hi_ust.v_piping_style_xwalk ps ON ((x."PipingStyle" = (ps.organization_value)::text)));