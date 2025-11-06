create or replace view "nh_ust"."v_ust_compartment" as
 SELECT DISTINCT eci.facility_id,
    eci.tank_id,
    eci.compartment_id,
    c.compartment_status_id,
    (a."CAPACITY")::integer AS compartment_capacity_gallons,
        CASE
            WHEN ((a."OVERFILL_TYPE" ~~ '%BALL%FLOAT%'::text) OR (a."OVERFILL_TYPE" ~~ '%BALL%FLT%'::text)) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_ball_float_valve,
        CASE
            WHEN ((a."OVERFILL_TYPE" ~~ '%FLAPPER%'::text) OR (a."OVERFILL_TYPE" = ' 61-F-STOP'::text)) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_flow_shutoff_device,
        CASE
            WHEN (a."OVERFILL_TYPE" ~~ '%ALARM%'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_high_level_alarm,
        CASE
            WHEN (a."OVERFILL_TYPE" = 'NONE'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_not_required,
        CASE
            WHEN (a."SPILL_INSTALLED_DATE" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS spill_bucket_installed,
        CASE
            WHEN (a."RELEASE_DETECTION_TANK_TYPE" = ANY (ARRAY['OWENS CORNING'::text, 'OMNTEC'::text, 'OPW FUEL MGT SYS'::text, 'OWENS CORNING'::text, 'PNEUMERCATOR'::text, 'PREFERRED UTILITIES'::text, 'VEEDER ROOT'::text, 'EBW BULK / STIK II'::text, 'EMCO WHEATON (OPW)'::text, 'EVO – FRANKLIN FUELS'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_interstitial_monitoring,
        CASE
            WHEN (a."RELEASE_DETECTION_TANK_TYPE" = ANY (ARRAY['AUTO TANK GAUGE'::text, 'EMCO WHEATON (OPW)'::text, 'EVO - FRANKLIN FUELS'::text, 'GILBARCO'::text, 'INCON'::text, 'OMNTEC'::text, 'OPW FUEL MGT SYS'::text, 'PETROMETER'::text, 'PNEUMERCATOR'::text, 'VEEDER ROOT'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_automatic_tank_gauging_release_detection,
        CASE
            WHEN (a."RELEASE_DETECTION_TANK_TYPE" = ANY (ARRAY['EBW BULK / STIK II'::text, 'EMCO WHEATON (OPW)'::text, 'EVO - FRANKLIN FUELS'::text, 'OMNTEC'::text, 'OPW FUEL MGT SYS'::text, 'VEEDER ROOT'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS automatic_tank_gauging_continuous_leak_detection,
        CASE
            WHEN (a."RELEASE_DETECTION_TANK_TYPE" = 'MANUAL TANK GAUGING'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_manual_tank_gauging,
        CASE
            WHEN (a."RELEASE_DETECTION_TANK_TYPE" = ANY (ARRAY['MONITORING WELL'::text, 'VEEDER ROOT'::text, 'PREFERRED UTILITIES'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_groundwater_monitoring,
        CASE
            WHEN (a."RELEASE_DETECTION_TANK_TYPE" = 'MONITORING WELL'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_vapor_monitoring,
        CASE
            WHEN (a."RELEASE_DETECTION_TANK_TYPE" = 'WARWICK CONTROLS'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_other_release_detection
   FROM (((((nh_ust.tanks a
     JOIN nh_ust.facilities b ON (((a."FACILITY_ID" = b."FACILITY_ID") AND (b."FACILITY_TYPE" <> 'PROPOSED FACILITY'::text))))
     JOIN nh_ust.erg_tank_id eti ON (((a."FACILITY_ID" = (eti.facility_id)::integer) AND (a."TANK_NUMBER" = (eti.tank_name)::text))))
     JOIN nh_ust.erg_compartment_id eci ON ((eti.tank_id = eci.tank_id)))
     LEFT JOIN nh_ust.erg_tank_status_values etsv ON (((a."FACILITY_ID" = etsv."FACILITY_ID") AND (a."TANK_NUMBER" = etsv."TANK_NUMBER"))))
     LEFT JOIN nh_ust.v_compartment_status_xwalk c ON ((etsv.tank_status = (c.organization_value)::text)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM nh_ust.erg_unregulated_tanks unreg
          WHERE ((((a."FACILITY_ID")::character varying(50))::text = (unreg.facility_id)::text) AND (eti.tank_id = unreg.tank_id)))));