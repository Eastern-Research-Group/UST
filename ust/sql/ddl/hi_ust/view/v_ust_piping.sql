create or replace view "hi_ust"."v_ust_piping" as
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    (x."TankID")::integer AS tank_id,
    c.compartment_id,
    (p.piping_id)::text AS piping_id,
    ps.piping_style_id,
        CASE
            WHEN (x."PipeTypeDesc" = 'Safe Suction'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS safe_suction,
        CASE
            WHEN (x."PipeTypeDesc" = 'U.S. Suction'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS american_suction,
    pwt.piping_wall_type_id,
        CASE
            WHEN (x."PipeMatDesc" = 'Fiberglass Reinforced Plastic'::text) THEN 'Yes'::text
            WHEN (x."PipeMatDesc" IS NULL) THEN NULL::text
            ELSE NULL::text
        END AS piping_material_frp,
        CASE
            WHEN (x."PipeMatDesc" = 'GALVANIZED STEEL'::text) THEN 'Yes'::text
            WHEN (x."PipeMatDesc" = 'Galvanized Steel'::text) THEN 'Yes'::text
            WHEN (x."PipeMatDesc" IS NULL) THEN NULL::text
            ELSE NULL::text
        END AS piping_material_gal_steel,
        CASE
            WHEN (x."PipeMatDesc" = 'BARE STEEL'::text) THEN 'Yes'::text
            WHEN (x."PipeMatDesc" = 'Bare Steel'::text) THEN 'Yes'::text
            WHEN (x."PipeMatDesc" IS NULL) THEN NULL::text
            ELSE NULL::text
        END AS piping_material_steel,
        CASE
            WHEN (x."PipeMatDesc" = 'Copper'::text) THEN 'Yes'::text
            WHEN (x."PipeMatDesc" IS NULL) THEN NULL::text
            ELSE NULL::text
        END AS piping_material_copper,
        CASE
            WHEN (x."PipeMatDesc" = 'Flexible Plastic'::text) THEN 'Yes'::text
            WHEN (x."PipeMatDesc" IS NULL) THEN NULL::text
            ELSE NULL::text
        END AS piping_material_flex,
        CASE
            WHEN (x."PipeMatDesc" = 'No Piping'::text) THEN 'Yes'::text
            WHEN (x."PipeMatDesc" IS NULL) THEN NULL::text
            ELSE NULL::text
        END AS piping_material_no_piping,
        CASE
            WHEN (x."PipeMatDesc" = 'Other'::text) THEN 'Yes'::text
            WHEN (x."PipeMatDesc" IS NULL) THEN NULL::text
            ELSE NULL::text
        END AS piping_material_other,
        CASE
            WHEN (x."PipeMatDesc" = 'Unknown'::text) THEN 'Yes'::text
            WHEN (x."PipeMatDesc" = 'UNKNOWN'::text) THEN 'Yes'::text
            WHEN (x."PipeMatDesc" IS NULL) THEN NULL::text
            ELSE NULL::text
        END AS piping_material_unknown,
        CASE
            WHEN (x."PipeCorrosionProtectionSacrificialAnodes" = false) THEN 'No'::text
            WHEN (x."PipeCorrosionProtectionSacrificialAnodes" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_corrosion_protection_sacrificial_anode,
        CASE
            WHEN (x."PipeCorrosionProtectionImpressedCurrent" = false) THEN 'No'::text
            WHEN (x."PipeCorrosionProtectionImpressedCurrent" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_corrosion_protection_impressed_current,
        CASE
            WHEN (x."PipeCorrosionProtectionNonCorrodible" = false) THEN 'No'::text
            WHEN (x."PipeCorrosionProtectionNonCorrodible" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_corrosion_protection_cathodic_not_required,
        CASE
            WHEN (x."PipeAutoLineLeakDetection" = false) THEN 'No'::text
            WHEN (x."PipeAutoLineLeakDetection" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_line_leak_detector,
        CASE
            WHEN (x."PipeGWMonitoring" = false) THEN 'No'::text
            WHEN (x."PipeGWMonitoring" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_groundwater_monitoring,
        CASE
            WHEN (x."PipeVaporMonitoring" = false) THEN 'No'::text
            WHEN (x."PipeVaporMonitoring" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_vapor_monitoring,
        CASE
            WHEN (x."PipeInterstitialDblWalled" = false) THEN 'No'::text
            WHEN (x."PipeInterstitialDblWalled" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_interstitial_monitoring,
        CASE
            WHEN (x."PipeSIR" = false) THEN 'No'::text
            WHEN (x."PipeSIR" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_statistical_inventory_reconciliation,
        CASE
            WHEN (x."PipeLDOther" = false) THEN 'No'::text
            WHEN (x."PipeLDOther" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_release_detection_other
   FROM ((((hi_ust."tblTank" x
     JOIN hi_ust.erg_compartment_id c ON ((((x."FacilityID")::text = (c.facility_id)::text) AND ((x."TankID")::text = (c.tank_id)::text) AND (x."AltTankID" = (c.tank_name)::text))))
     JOIN hi_ust.erg_piping_id p ON ((((x."FacilityID")::text = (c.facility_id)::text) AND ((x."TankID")::text = (c.tank_id)::text) AND (x."AltTankID" = (c.tank_name)::text) AND ((c.compartment_id)::text = (p.compartment_id)::text))))
     LEFT JOIN hi_ust.v_piping_style_xwalk ps ON ((x."PipeTypeDesc" = (ps.organization_value)::text)))
     LEFT JOIN hi_ust.v_piping_wall_type_xwalk pwt ON ((x."PipeModDesc" = (pwt.organization_value)::text)));