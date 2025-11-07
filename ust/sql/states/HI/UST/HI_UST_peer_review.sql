


/*********** v_ust_tank ***********/
--There are 3322 rows in hi_ust.v_ust_tank that do not exist in public.v_ust_tank

select * from hi_ust.v_ust_tank a
where not exists
	(select 1 from public.v_ust_tank b
	where a.facility_id = b."FacilityID" and a.tank_id = b."TankID")
order by a.facility_id,a.tank_id;

--View definition for hi_ust.v_ust_tank:
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    (x."TankID")::integer AS tank_id,
    x."AltTankID" AS tank_name,
    ts.tank_status_id,
        CASE
            WHEN (x."Exempt" = true) THEN 'No'::text
            WHEN (x."Exempt" = false) THEN 'Yes'::text
            ELSE NULL::text
        END AS federally_regulated,
        CASE
            WHEN (x."EmergGenSoleUse" = true) THEN 'Yes'::text
            WHEN (x."EmergGenSoleUse" = false) THEN 'No'::text
            ELSE NULL::text
        END AS emergency_generator,
        CASE
            WHEN (mt.multi_tank_count > 1) THEN 'Yes'::text
            ELSE 'No'::text
        END AS multiple_tanks,
    (x."DateClosed")::date AS tank_closure_date,
    (x."InstalledDate")::date AS tank_installation_date,
        CASE
            WHEN (x."Compartment" = true) THEN 'Yes'::text
            WHEN (x."Compartment" = false) THEN 'No'::text
            ELSE NULL::text
        END AS compartmentalized_ust,
    tm.tank_material_description_id,
        CASE
            WHEN (x."TankCorrosionProtectionSacrificialAnodes" = false) THEN 'No'::text
            WHEN (x."TankCorrosionProtectionSacrificialAnodes" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_sacrificial_anode,
        CASE
            WHEN (x."TankCorrosionProtectionImpressedCurrent" = false) THEN 'No'::text
            WHEN (x."TankCorrosionProtectionImpressedCurrent" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_impressed_current,
        CASE
            WHEN (x."TankCorrosionProtectionNonCorrodible" = false) THEN 'No'::text
            WHEN (x."TankCorrosionProtectionNonCorrodible" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_cathodic_not_required,
        CASE
            WHEN (x."TankCorrosionProtectionInteriorLining" = false) THEN 'No'::text
            WHEN (x."TankCorrosionProtectionInteriorLining" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_interior_lining,
    sc.tank_secondary_containment_id
   FROM ((((hi_ust."tblTank" x
     LEFT JOIN hi_ust.v_tank_status_xwalk ts ON ((x."TankStatusDesc" = (ts.organization_value)::text)))
     LEFT JOIN ( SELECT "tblTank"."FacilityID",
            count("tblTank"."TankID") AS multi_tank_count
           FROM hi_ust."tblTank"
          GROUP BY "tblTank"."FacilityID") mt ON ((x."FacilityID" = mt."FacilityID")))
     LEFT JOIN hi_ust.v_tank_material_description_xwalk tm ON ((x."TankMatDesc" = (tm.organization_value)::text)))
     LEFT JOIN hi_ust.v_tank_secondary_containment_xwalk sc ON ((x."TankModsDesc" = (sc.organization_value)::text)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM hi_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id)))));


/*********** v_ust_tank_substance ***********/
--There are 3322 rows in hi_ust.v_ust_tank_substance that do not exist in public.v_ust_tank_substance

select * from hi_ust.v_ust_tank_substance a
where not exists
	(select 1 from public.v_ust_tank_substance b join public.substances c on b."Substance" = c.substance
	where a.facility_id = b."FacilityID" and a.tank_id = b."TankID" and a.substance_id = c."substance_id")
order by a.facility_id,a.tank_id,a.substance_id;

--View definition for hi_ust.v_ust_tank_substance:
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    (x."TankID")::integer AS tank_id,
        CASE
            WHEN (s.substance_id IS NULL) THEN 47
            ELSE s.substance_id
        END AS substance_id
   FROM (hi_ust."tblTank" x
     LEFT JOIN hi_ust.v_substance_xwalk s ON ((x."SubstanceDesc" = (s.organization_value)::text)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM hi_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id)))));


/*********** v_ust_compartment ***********/
--There are 3322 rows in hi_ust.v_ust_compartment that do not exist in public.v_ust_compartment

select * from hi_ust.v_ust_compartment a
where not exists
	(select 1 from public.v_ust_compartment b
	where a.facility_id = b."FacilityID" and a.tank_id = b."TankID" and a.compartment_id = b."CompartmentID")
order by a.facility_id,a.tank_id,a.compartment_id;

--View definition for hi_ust.v_ust_compartment:
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    (x."TankID")::integer AS tank_id,
    c.compartment_id,
    cs.compartment_status_id,
    (x."TankCapacity")::integer AS compartment_capacity_gallons,
        CASE
            WHEN (x."OverfillBallFloat" = false) THEN 'No'::text
            WHEN (x."OverfillBallFloat" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_ball_float_valve,
        CASE
            WHEN (x."OverfillFlapper" = false) THEN 'No'::text
            WHEN (x."OverfillFlapper" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_flow_shutoff_device,
        CASE
            WHEN (x."OverfillAlarm" = false) THEN 'No'::text
            WHEN (x."OverfillAlarm" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_high_level_alarm,
        CASE
            WHEN (x."SpillInstalled" = false) THEN 'No'::text
            WHEN (x."SpillInstalled" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS spill_bucket_installed,
        CASE
            WHEN (x."TankInterstitialDblWalled" = false) THEN 'No'::text
            WHEN (x."TankInterstitialDblWalled" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_interstitial_monitoring,
        CASE
            WHEN (x."TankATG" = false) THEN 'No'::text
            WHEN (x."TankATG" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_automatic_tank_gauging_release_detection,
        CASE
            WHEN (x."TankManualGauge" = false) THEN 'No'::text
            WHEN (x."TankManualGauge" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_manual_tank_gauging,
        CASE
            WHEN (x."TankSIR" = false) THEN 'No'::text
            WHEN (x."TankSIR" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_statistical_inventory_reconciliation,
        CASE
            WHEN (x."TankTightness" = false) THEN 'No'::text
            WHEN (x."TankTightness" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_tightness_testing,
        CASE
            WHEN (x."TankInventoryControl" = false) THEN 'No'::text
            WHEN (x."TankInventoryControl" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_inventory_control,
        CASE
            WHEN (x."TankGWMonitor" = false) THEN 'No'::text
            WHEN (x."TankGWMonitor" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_groundwater_monitoring,
        CASE
            WHEN (x."TankVaporMonitor" = false) THEN 'No'::text
            WHEN (x."TankVaporMonitor" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_vapor_monitoring,
        CASE
            WHEN (x."TankLDOther" = false) THEN 'No'::text
            WHEN (x."TankLDOther" = true) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_other_release_detection
   FROM ((hi_ust."tblTank" x
     JOIN hi_ust.erg_compartment_id c ON ((((x."FacilityID")::text = (c.facility_id)::text) AND ((x."TankID")::text = (c.tank_id)::text) AND (x."AltTankID" = (c.tank_name)::text))))
     LEFT JOIN hi_ust.v_compartment_status_xwalk cs ON ((x."TankStatusDesc" = (cs.organization_value)::text)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM hi_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id)))));


/*********** v_ust_piping ***********/
--There are 3322 rows in hi_ust.v_ust_piping that do not exist in public.v_ust_piping

select * from hi_ust.v_ust_piping a
where not exists
	(select 1 from public.v_ust_piping b
	where a.facility_id = b."FacilityID" and a.tank_id = b."TankID" and a.compartment_id = b."CompartmentID" and a.piping_id = b."PipingID")
order by a.facility_id,a.tank_id,a.compartment_id,a.piping_id;

--View definition for hi_ust.v_ust_piping:
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
     LEFT JOIN hi_ust.v_piping_wall_type_xwalk pwt ON ((x."PipeModDesc" = (pwt.organization_value)::text)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM hi_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id)))));