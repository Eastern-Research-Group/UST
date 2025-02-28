create or replace view "nh_ust"."v_ust_compartment" as
 SELECT DISTINCT et.facility_id,
    et.tank_id,
    c.compartment_id,
    ts.compartment_status_id,
    (x."CAPACITY")::integer AS compartment_capacity_gallons,
        CASE
            WHEN ((TRIM(BOTH FROM upper(x."OVERFILL_TYPE")) ~~ '%BALL%FLOAT%'::text) OR (x."OVERFILL_TYPE" ~~ '%BALL%FLT%'::text)) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_ball_float_valve,
        CASE
            WHEN (TRIM(BOTH FROM upper(x."OVERFILL_TYPE")) ~~ '%FLOW SHUTOFF - FLAPPER VALVE%'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_flow_shutoff_device,
        CASE
            WHEN (TRIM(BOTH FROM upper(x."OVERFILL_TYPE")) ~~ '%ALARM%'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_high_level_alarm,
        CASE
            WHEN (TRIM(BOTH FROM upper(x."OVERFILL_TYPE")) = ANY (ARRAY['61-F-STOP'::text, 'COAXIAL FLAPPER VALVE'::text, 'MULTIPLE STAGE FLAPPER VALVE'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_other,
        CASE
            WHEN (TRIM(BOTH FROM upper(x."OVERFILL_TYPE")) = 'NONE'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_not_required,
        CASE
            WHEN (x."SPILL_INSTALLED_DATE" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS spill_bucket_installed,
        CASE
            WHEN (TRIM(BOTH FROM upper(x."RELEASE_DETECTION_TANK_TYPE")) = 'AUTO TANK GAUGE'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_automatic_tank_gauging_release_detection,
        CASE
            WHEN (TRIM(BOTH FROM upper(x."RELEASE_DETECTION_TANK_TYPE")) = 'AUTO TANK GAUGE'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS automatic_tank_gauging_continuous_leak_detection,
        CASE
            WHEN (TRIM(BOTH FROM upper(x."RELEASE_DETECTION_TANK_TYPE")) = 'MANUAL TANK GAUGING'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_manual_tank_gauging,
        CASE
            WHEN (x."TANK_TIGHTNESS_TEST_DATE" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_tightness_testing,
        CASE
            WHEN (TRIM(BOTH FROM upper(x."RELEASE_DETECTION_TANK_TYPE")) = ANY (ARRAY['AMPRODOX'::text, 'ARIZONA INSTRUMENT'::text, 'CARDINAL VACUUM'::text, 'CONTROL SYSTEMS'::text, 'EBW BULK / STIK II'::text, 'EMCO WHEATON (OPW)'::text, 'ENVIRONMENTAL SYSTEMS'::text, 'EVO - FRANKLIN FUELS'::text, 'GILBARCO'::text, 'IN SITU'::text, 'IN TANK MONITOR'::text, 'INCON'::text, 'LEAK X MINI'::text, 'MCG 1100'::text, 'MONITORING WELL'::text, 'NEPONSET CONTROLS'::text, 'OMNTEC'::text, 'OPW FUEL MGT SYS'::text, 'OTHER'::text, 'OWENS CORNING'::text, 'PETROMETER'::text, 'PETROVEND'::text, 'PNEUMERCATOR'::text, 'POLLULERT'::text, 'PREFERRED UTILITIES'::text, 'TIDEL SYSTEMS INC'::text, 'VEEDER ROOT'::text, 'WARWICK CONTROLS'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_other_release_detection
   FROM (((nh_ust.tanks x
     JOIN nh_ust.erg_tank et ON ((((et.facility_id)::integer = x."FACILITY_ID") AND ((et.tank_name)::text = x."TANK_NUMBER"))))
     JOIN nh_ust.erg_compartment c ON ((((et.facility_id)::text = (c.facility_id)::text) AND (et.tank_id = c.tank_id))))
     LEFT JOIN nh_ust.v_compartment_status_xwalk ts ON ((x."STATUS" = (ts.organization_value)::text)));