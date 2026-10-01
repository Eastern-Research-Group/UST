


/*********** v_ust_facility ***********/


--View definition for as_ust.v_ust_facility:
 SELECT DISTINCT TRIM(BOTH FROM a."FacilityID") AS facility_id,
    (a."FacilityName")::character varying(100) AS facility_name,
    c.owner_type_id,
    b.facility_type_id AS facility_type1,
    (a."FacilityAddress1")::character varying(100) AS facility_address1,
    (a."FacilityCity")::character varying(100) AS facility_city,
    (a."FacilityCounty")::character varying(100) AS facility_county,
    (a."FacilityZipCode")::character varying(10) AS facility_zip_code,
    d.facility_state,
    9 AS facility_epa_region,
        CASE
            WHEN ((a."FacilityLatitude")::text ~ '[SW]$'::text) THEN (- (regexp_replace((a."FacilityLatitude")::text, '[^0-9.]'::text, ''::text, 'g'::text))::double precision)
            ELSE (regexp_replace((a."FacilityLatitude")::text, '[^0-9.]'::text, ''::text, 'g'::text))::double precision
        END AS facility_latitude,
        CASE
            WHEN ((a."FacilityLongitude")::text ~ '[SW]$'::text) THEN (- (regexp_replace((a."FacilityLongitude")::text, '[^0-9.]'::text, ''::text, 'g'::text))::double precision)
            ELSE (regexp_replace((a."FacilityLongitude")::text, '[^0-9.]'::text, ''::text, 'g'::text))::double precision
        END AS facility_longitude,
    (a."FacilityOwnerCompanyName")::character varying(100) AS facility_owner_company_name,
        CASE
            WHEN (TRIM(BOTH FROM a."USTReportedRelease") = 'None'::text) THEN NULL::character varying
            ELSE a."USTReportedRelease"
        END AS ust_reported_release
   FROM (((as_ust.facility a
     LEFT JOIN as_ust.v_facility_type_xwalk b ON (((a."FacilityType1")::text = (b.organization_value)::text)))
     LEFT JOIN as_ust.v_owner_type_xwalk c ON (((a."OwnerType")::text = (c.organization_value)::text)))
     LEFT JOIN as_ust.v_state_xwalk d ON (((a."FacilityState")::text = (d.organization_value)::text)));;




/*********** v_ust_tank ***********/


--View definition for as_ust.v_ust_tank:
 SELECT DISTINCT (NULLIF(TRIM(BOTH FROM (a."FacilityID")::text), ''::text))::character varying(50) AS facility_id,
    ("right"((a."TankName")::text, 1))::integer AS tank_id,
    a."TankName" AS tank_name,
    c.tank_location_id,
    f.tank_status_id,
        CASE
            WHEN (lower(NULLIF(TRIM(BOTH FROM (a."FederallyRegulated")::text), ''::text)) = ANY (ARRAY['true'::text, 't'::text, 'yes'::text, 'y'::text, '1'::text, '1.0'::text])) THEN 'Yes'::text
            WHEN (lower(NULLIF(TRIM(BOTH FROM (a."FederallyRegulated")::text), ''::text)) = ANY (ARRAY['false'::text, 'f'::text, 'no'::text, 'n'::text, '0'::text, '0.0'::text])) THEN 'No'::text
            ELSE NULL::text
        END AS federally_regulated,
    (a."MultipleTanks")::character varying(7) AS multiple_tanks,
        CASE
            WHEN ((a."TankInstallationDate")::text ~ '^\d{4}$'::text) THEN to_date((a."TankInstallationDate")::text, 'YYYY'::text)
            WHEN ((a."TankInstallationDate")::text ~ '^[A-Za-z]{3}-\d{2}$'::text) THEN to_date((a."TankInstallationDate")::text, 'Mon-YY'::text)
            WHEN (TRIM(BOTH FROM a."TankInstallationDate") ~ '^[A-Za-z]{3} \d{4}$'::text) THEN to_date(TRIM(BOTH FROM a."TankInstallationDate"), 'Mon YYYY'::text)
            ELSE NULL::date
        END AS tank_installation_date,
        CASE
            WHEN ((a."CompartmentalizedUST")::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((a."CompartmentalizedUST")::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS compartmentalized_ust,
    a."NumberOfCompartments" AS number_of_compartments,
    d.tank_material_description_id,
    e.tank_secondary_containment_id
   FROM ((((as_ust.tank a
     LEFT JOIN as_ust.v_tank_location_xwalk c ON (((a."TankLocation")::text = (c.organization_value)::text)))
     LEFT JOIN as_ust.v_tank_material_description_xwalk d ON (((a."TankMaterialDescription")::text = (d.organization_value)::text)))
     LEFT JOIN as_ust.v_tank_secondary_containment_xwalk e ON (((a."TankSecondaryContainment")::text = (e.organization_value)::text)))
     LEFT JOIN as_ust.v_tank_status_xwalk f ON (((a."TankStatus")::text = (f.organization_value)::text)));;




/*********** v_ust_tank_substance ***********/


--View definition for as_ust.v_ust_tank_substance:
 SELECT DISTINCT (NULLIF(TRIM(BOTH FROM (a."FacilityID")::text), ''::text))::character varying(50) AS facility_id,
    ("right"((a."TankName")::text, 1))::integer AS tank_id,
    c.substance_id
   FROM (as_ust.compartment a
     LEFT JOIN as_ust.v_substance_xwalk c ON (((a."CompartmentSubstanceStored")::text = (c.organization_value)::text)));;




/*********** v_ust_compartment ***********/


--View definition for as_ust.v_ust_compartment:
 SELECT DISTINCT (TRIM(BOTH FROM (a."FacilityID")::text))::character varying(50) AS facility_id,
    ("right"((a."TankName")::text, 1))::integer AS tank_id,
    1 AS compartment_id,
    a."CompartmentName" AS compartment_name,
    d.compartment_status_id,
    (a."OverfillPreventionBallFloatValve")::character varying(7) AS overfill_prevention_ball_float_valve,
    (a."OverfillPreventionFlowShutoffDevice")::character varying(7) AS overfill_prevention_flow_shutoff_device,
        CASE
            WHEN ((a."OverfillPreventionHighLevelAlarm")::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((a."OverfillPreventionHighLevelAlarm")::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS overfill_prevention_high_level_alarm,
        CASE
            WHEN ((a."OverfillPreventionNotRequired")::text = 'No - overfill prevention is required'::text) THEN 'No'::text
            ELSE NULL::text
        END AS overfill_prevention_not_required,
        CASE
            WHEN (lower(NULLIF(TRIM(BOTH FROM (a."SpillBucketInstalled")::text), ''::text)) = ANY (ARRAY['true'::text, 't'::text, 'yes'::text, 'y'::text, '1'::text, '1.0'::text])) THEN 'Yes'::text
            WHEN (lower(NULLIF(TRIM(BOTH FROM (a."SpillBucketInstalled")::text), ''::text)) = ANY (ARRAY['false'::text, 'f'::text, 'no'::text, 'n'::text, '0'::text, '0.0'::text])) THEN 'No'::text
            ELSE NULL::text
        END AS spill_bucket_installed,
        CASE
            WHEN ((a."ConcreteBermInstalled")::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((a."ConcreteBermInstalled")::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS concrete_berm_installed,
        CASE
            WHEN ((a."SpillPreventionNotRequired")::text = 'No - spill prevention is required'::text) THEN 'No'::character varying
            ELSE a."SpillPreventionNotRequired"
        END AS spill_prevention_not_required,
        CASE
            WHEN ((a."TankAutomaticTankGaugingReleaseDetection")::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((a."TankAutomaticTankGaugingReleaseDetection")::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS tank_automatic_tank_gauging_release_detection,
        CASE
            WHEN ((a."AutomaticTankGaugingContinuousLeakDetection")::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((a."AutomaticTankGaugingContinuousLeakDetection")::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS automatic_tank_gauging_continuous_leak_detection,
        CASE
            WHEN ((a."TankManualTankGauging")::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((a."TankManualTankGauging")::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS tank_manual_tank_gauging,
        CASE
            WHEN ((a."TankTightnessTesting")::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((a."TankTightnessTesting")::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS tank_tightness_testing,
        CASE
            WHEN ((a."TankInventoryControl")::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((a."TankInventoryControl")::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS tank_inventory_control
   FROM (as_ust.compartment a
     LEFT JOIN as_ust.v_compartment_status_xwalk d ON (((a."CompartmentStatus")::text = (d.organization_value)::text)));;




/*********** v_ust_compartment_substance ***********/


--View definition for as_ust.v_ust_compartment_substance:
 SELECT DISTINCT a."FacilityID" AS facility_id,
    ("right"((a."TankName")::text, 1))::integer AS tank_id,
    1 AS compartment_id,
    c.substance_id
   FROM (as_ust.compartment a
     LEFT JOIN as_ust.v_substance_xwalk c ON (((a."CompartmentSubstanceStored")::text = (c.organization_value)::text)));;




/*********** v_ust_piping ***********/


--View definition for as_ust.v_ust_piping:
 SELECT DISTINCT a."FacilityID" AS facility_id,
    ("right"((a."TankName")::text, 1))::integer AS tank_id,
    1 AS compartment_id,
    a."PipingID" AS piping_id,
    d.piping_style_id,
    (a."SafeSuction")::character varying(7) AS safe_suction,
    (a."AmericanSuction")::character varying(7) AS american_suction,
        CASE
            WHEN ((a."HighPressureOrBulkPiping")::text = 'N'::text) THEN 'No'::text
            WHEN ((a."HighPressureOrBulkPiping")::text = 'Y'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS high_pressure_or_bulk_piping,
        CASE
            WHEN ((a."PipingMaterialFRP")::text = 'N'::text) THEN 'No'::text
            WHEN ((a."PipingMaterialFRP")::text = 'Y'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_frp,
        CASE
            WHEN ((a."PipingMaterialGalSteel")::text = 'N'::text) THEN 'No'::text
            WHEN ((a."PipingMaterialGalSteel")::text = 'Y'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_gal_steel,
        CASE
            WHEN ((a."PipingMaterialStainlessSteel")::text = 'N'::text) THEN 'No'::text
            WHEN ((a."PipingMaterialStainlessSteel")::text = 'Y'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_stainless_steel,
        CASE
            WHEN ((a."PipingMaterialSteel")::text = 'N'::text) THEN 'No'::text
            WHEN ((a."PipingMaterialSteel")::text = 'Y'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_steel,
        CASE
            WHEN ((a."PipingMaterialCopper")::text = 'N'::text) THEN 'No'::text
            WHEN ((a."PipingMaterialCopper")::text = 'Y'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_copper,
        CASE
            WHEN ((a."PipingMaterialFlex")::text = 'N'::text) THEN 'No'::text
            WHEN ((a."PipingMaterialFlex")::text = 'Y'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_flex,
        CASE
            WHEN ((a."PipingFlexConnector")::text = 'N'::text) THEN 'No'::text
            WHEN ((a."PipingFlexConnector")::text = 'Y'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_flex_connector,
        CASE
            WHEN (TRIM(BOTH FROM a."PipingCorrosionProtectionSacrificialAnode") = 'NA'::text) THEN NULL::text
            ELSE NULL::text
        END AS piping_corrosion_protection_sacrificial_anode,
        CASE
            WHEN (TRIM(BOTH FROM a."PipingCorrosionProtectionImpressedCurrent") = 'NA'::text) THEN NULL::text
            ELSE NULL::text
        END AS piping_corrosion_protection_impressed_current,
        CASE
            WHEN ((a."PipingCorrosionProtectionCathodicNotRequired")::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((a."PipingCorrosionProtectionCathodicNotRequired")::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS piping_corrosion_protection_cathodic_not_required,
        CASE
            WHEN (TRIM(BOTH FROM a."PipingCorrosionProtectionOther") = 'NA'::text) THEN NULL::text
            ELSE NULL::text
        END AS piping_corrosion_protection_other,
        CASE
            WHEN ((a."PipingCorrosionProtectionUnknown")::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((a."PipingCorrosionProtectionUnknown")::text = 'N'::text) THEN 'No'::text
            WHEN (TRIM(BOTH FROM a."PipingCorrosionProtectionUnknown") = 'NA'::text) THEN NULL::text
            ELSE NULL::text
        END AS piping_corrosion_protection_unknown,
        CASE
            WHEN ((a."PipingLineLeakDetector")::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((a."PipingLineLeakDetector")::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS piping_line_leak_detector,
        CASE
            WHEN ((a."PipingLineTestAnnual")::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((a."PipingLineTestAnnual")::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS piping_line_test_annual,
        CASE
            WHEN ((a."PipingLineTest3yr")::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((a."PipingLineTest3yr")::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS piping_line_test3yr,
        CASE
            WHEN ((a."PipingReleaseDetectionOther")::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((a."PipingReleaseDetectionOther")::text = 'NA'::text) THEN NULL::text
            ELSE NULL::text
        END AS piping_release_detection_other,
        CASE
            WHEN ((a."PipeTankTopSump")::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((a."PipeTankTopSump")::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS pipe_tank_top_sump,
    e.piping_wall_type_id,
        CASE
            WHEN (TRIM(BOTH FROM a."PipeTrenchLiner") = 'NA'::text) THEN NULL::text
            ELSE NULL::text
        END AS pipe_trench_liner,
        CASE
            WHEN (TRIM(BOTH FROM a."PipeSecondaryContainmentOther") = 'NA'::text) THEN NULL::text
            ELSE NULL::text
        END AS pipe_secondary_containment_other,
        CASE
            WHEN (TRIM(BOTH FROM a."PipeSecondaryContainmentUnknown") = 'NA'::text) THEN NULL::text
            ELSE NULL::text
        END AS pipe_secondary_containment_unknown
   FROM ((as_ust.piping a
     LEFT JOIN as_ust.v_piping_style_xwalk d ON (((a."PipingStyle")::text = (d.organization_value)::text)))
     LEFT JOIN as_ust.v_piping_wall_type_xwalk e ON (((a."PipingWallType")::text = (e.organization_value)::text)));;




/*********** v_ust_compartment_dispenser ***********/


--View definition for as_ust.v_ust_compartment_dispenser:
 SELECT DISTINCT (NULLIF(TRIM(BOTH FROM (a."FacilityID")::text), ''::text))::character varying(50) AS facility_id,
    ("right"((a."TankName")::text, 1))::integer AS tank_id,
    1 AS compartment_id,
    '1'::text AS dispenser_id,
        CASE
            WHEN (lower(NULLIF(TRIM(BOTH FROM (a."DispenserUDC")::text), ''::text)) = ANY (ARRAY['true'::text, 't'::text, 'yes'::text, 'y'::text, '1'::text, '1.0'::text])) THEN 'Yes'::text
            WHEN (lower(NULLIF(TRIM(BOTH FROM (a."DispenserUDC")::text), ''::text)) = ANY (ARRAY['false'::text, 'f'::text, 'no'::text, 'n'::text, '0'::text, '0.0'::text])) THEN 'No'::text
            ELSE NULL::text
        END AS dispenser_udc
   FROM ((as_ust.compartment a
     LEFT JOIN as_ust.erg_tank_id b ON (((NULLIF(TRIM(BOTH FROM (a."FacilityID")::text), ''::text) = NULLIF(TRIM(BOTH FROM (b.facility_id)::text), ''::text)) AND (TRIM(BOTH FROM a."TankName") = TRIM(BOTH FROM b.tank_name)))))
     LEFT JOIN as_ust.erg_compartment_id c ON (((TRIM(BOTH FROM a."CompartmentName") = TRIM(BOTH FROM c.compartment_name)) AND (TRIM(BOTH FROM b.tank_name) = TRIM(BOTH FROM c.tank_name)))));;

