------------------------------------------------------------------------------------------------------------------------------------------------------------------------



create or replace view hi_ust.v_ust_facility as
 WITH release_id AS (
         SELECT l."FacilityId" AS facility_id,
            l."AltEventId",
            l."Date reported",
            l."LUSTLatestStatusDate",
            row_number() OVER (PARTITION BY l."FacilityId" ORDER BY l."Date reported" DESC, l."LUSTLatestStatusDate" DESC, l."AltEventId" DESC NULLS LAST) AS row_num
           FROM hi_ust."tblLUSTSite" l
        ), owner_type AS (
         SELECT ca."FacilityID" AS facility_id,
            ca."EndDate",
            ca."StartDate",
            ca."Owner Type:",
            row_number() OVER (PARTITION BY ca."FacilityID" ORDER BY ca."EndDate" DESC, ca."StartDate" DESC, ca."Owner Type:" DESC NULLS LAST) AS row_num
           FROM hi_ust."tblContactAffiliation" ca
        ), financial_responsibility AS (
         SELECT fr."FacilityID",
            max(
                CASE
                    WHEN (fr."FRType" = ANY (ARRAY['commercial insurance'::text, 'Insurance'::text, 'nsurance'::text])) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS financial_responsibility_commercial_insurance,
            max(
                CASE
                    WHEN (fr."FRType" = 'Guarantee'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS financial_responsibility_guarantee,
            max(
                CASE
                    WHEN (fr."FRType" = 'Letter of Credit'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS financial_responsibility_letter_of_credit,
            max(
                CASE
                    WHEN (fr."FRType" ~~ 'Local Gov_t Bond Rating'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS financial_responsibility_local_government_financial_test,
            max(
                CASE
                    WHEN (fr."FRType" = 'Risk Retention Group'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS financial_responsibility_risk_retention_group,
            max(
                CASE
                    WHEN (fr."FRType" = 'Self Insured'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS financial_responsibility_self_insurance_financial_test,
            max(
                CASE
                    WHEN (fr."FRType" = 'State Fund'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS financial_responsibility_state_fund,
            max(
                CASE
                    WHEN (fr."FRType" = 'Surety Bond'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS financial_responsibility_surety_bond,
            max(
                CASE
                    WHEN (fr."FRType" = 'Trust Fund'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS financial_responsibility_trust_fund,
            max(
                CASE
                    WHEN (fr."FRType" = 'Other'::text) THEN 'Yes'::text
                    ELSE NULL::text
                END) AS financial_responsibility_other_method
           FROM hi_ust."tblFacilityFR" fr
          GROUP BY fr."FacilityID"
        )
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    x."Facility Name" AS facility_name,
    ot.owner_type_id,
    ft.facility_type_id AS facility_type1,
        CASE
            WHEN (x."FacilityID" = '9101061'::bigint) THEN 'Honolulu International Airport 200 Rodgers Blvd'::text
            ELSE x."Street Address"
        END AS facility_address1,
        CASE
            WHEN (z."City" = 'ZipCode Unknown'::text) THEN NULL::text
            ELSE z."City"
        END AS facility_city,
        CASE
            WHEN (z."City" = 'Zipcode Unknown'::text) THEN NULL::text
            ELSE z."County"
        END AS facility_county,
        CASE
            WHEN (z."ZIP Code" = '99999'::text) THEN NULL::text
            ELSE z."ZIP Code"
        END AS facility_zip_code,
        CASE
            WHEN (s.facility_state IS NULL) THEN 'HI'::character varying
            ELSE s.facility_state
        END AS facility_state,
    x."LatitudeMeasure" AS facility_latitude,
    x."LongitudeMeasure" AS facility_longitude,
    cs.coordinate_source_id,
    co."OrganizationFormalName" AS facility_owner_company_name,
        CASE
            WHEN ((fr_agg.financial_responsibility_commercial_insurance IS NOT NULL) OR (fr_agg.financial_responsibility_guarantee IS NOT NULL) OR (fr_agg.financial_responsibility_letter_of_credit IS NOT NULL) OR (fr_agg.financial_responsibility_local_government_financial_test IS NOT NULL) OR (fr_agg.financial_responsibility_risk_retention_group IS NOT NULL) OR (fr_agg.financial_responsibility_self_insurance_financial_test IS NOT NULL) OR (fr_agg.financial_responsibility_state_fund IS NOT NULL) OR (fr_agg.financial_responsibility_surety_bond IS NOT NULL) OR (fr_agg.financial_responsibility_trust_fund IS NOT NULL) OR (fr_agg.financial_responsibility_other_method IS NOT NULL)) THEN 'Yes'::text
            ELSE NULL::text
        END AS financial_responsibility_obtained,
    fr_agg.financial_responsibility_commercial_insurance,
    fr_agg.financial_responsibility_guarantee,
    fr_agg.financial_responsibility_letter_of_credit,
    fr_agg.financial_responsibility_local_government_financial_test,
    fr_agg.financial_responsibility_risk_retention_group,
    fr_agg.financial_responsibility_self_insurance_financial_test,
    fr_agg.financial_responsibility_state_fund,
    fr_agg.financial_responsibility_surety_bond,
    fr_agg.financial_responsibility_trust_fund,
    fr_agg.financial_responsibility_other_method,
        CASE
            WHEN (r."AltEventId" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS ust_reported_release,
    r."AltEventId" AS associated_ust_release_id
   FROM (((((((((hi_ust."tblFacility" x
     LEFT JOIN owner_type o ON (((x."FacilityID" = o.facility_id) AND (o.row_num = 1))))
     LEFT JOIN hi_ust.v_owner_type_xwalk ot ON ((o."Owner Type:" = (ot.organization_value)::text)))
     LEFT JOIN hi_ust.v_facility_type_xwalk ft ON ((x."Facility Description" = (ft.organization_value)::text)))
     LEFT JOIN hi_ust."tlkpZIP" z ON ((x."ZIP Linkage" = (z."ZIP ID")::double precision)))
     LEFT JOIN hi_ust.v_state_xwalk s ON ((z."State" = (s.organization_value)::text)))
     LEFT JOIN hi_ust."tblContactOrganization" co ON ((x."Owner ID" = (co."OwnerId")::double precision)))
     LEFT JOIN financial_responsibility fr_agg ON ((x."FacilityID" = fr_agg."FacilityID")))
     LEFT JOIN release_id r ON (((x."FacilityID" = r.facility_id) AND (r.row_num = 1))))
     LEFT JOIN hi_ust.v_coordinate_source_xwalk cs ON ((x."HorizontalCollectionMethodName" = (cs.organization_value)::text)))
  WHERE (NOT (((x."FacilityID")::character varying(50))::text IN ( SELECT erg_unregulated_facilities.facility_id
           FROM hi_ust.erg_unregulated_facilities)))
 and FR."FacilityID"::varchar(50) not in (select facility_id from hi_ust.erg_unregulated_facilities);



create or replace view hi_ust.v_ust_tank as
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
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id)))))
 and not exists
	(select 1 from hi_ust.erg_unregulated_tanks unreg
	where x."FacilityID"::varchar(50) = unreg.facility_id and x."TankID"::int = unreg.tank_id);



create or replace view hi_ust.v_ust_tank_substance as
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
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id)))))
 and not exists
	(select 1 from hi_ust.erg_unregulated_tanks unreg
	where x."FacilityID"::varchar(50) = unreg.facility_id and x."TankID"::int = unreg.tank_id);



create or replace view hi_ust.v_ust_compartment as
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
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id)))))
 and not exists
	(select 1 from hi_ust.erg_unregulated_tanks unreg
	where x."FacilityID"::varchar(50) = unreg.facility_id and x."TankID"::int = unreg.tank_id);



create or replace view hi_ust.v_ust_piping as
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
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id)))))
 and not exists
	(select 1 from hi_ust.erg_unregulated_tanks unreg
	where x."FacilityID"::varchar(50) = unreg.facility_id and x."TankID"::int = unreg.tank_id);