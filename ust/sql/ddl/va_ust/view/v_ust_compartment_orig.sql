create or replace view "va_ust"."v_ust_compartment_orig" as
 SELECT DISTINCT b.tank_facility_id AS facility_id,
    (b.index)::integer AS tank_id,
    (a.index)::integer AS compartment_id,
    c.compartment_status_id,
    (b.capacity)::integer AS compartment_capacity_gallons,
        CASE
            WHEN ((a.overfill_type)::text = ANY (ARRAY[('ALARM-BALL FLOAT'::character varying)::text, ('BALL FLOAT'::character varying)::text, ('AUTOMATIC SHUTOFF-BALL FLOAT'::character varying)::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_ball_float_valve,
        CASE
            WHEN ((a.overfill_type)::text = ANY (ARRAY[('AUTOMATIC SHUTOFF'::character varying)::text, ('AUTOMATIC SHUTOFF-BALL FLOAT'::character varying)::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_flow_shutoff_device,
        CASE
            WHEN ((a.overfill_type)::text = ANY (ARRAY[('ALARM-BALL FLOAT'::character varying)::text, ('ALARM'::character varying)::text, ('ALARM-AUTOMATIC SHUTOFF'::character varying)::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_high_level_alarm,
        CASE
            WHEN ((a.overfill_type)::text = 'OTHER'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_other,
        CASE
            WHEN ((a.overfill_type)::text = 'NONE'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_not_required,
        CASE
            WHEN ((a.spill_device_installed)::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((a.spill_device_installed)::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS spill_bucket_installed,
        CASE
            WHEN ((a.overfill_other_specify)::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((a.overfill_other_specify)::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS spill_prevention_other,
        CASE
            WHEN ((a.overfill_other_specify)::text = ANY (ARRAY[('Not Required'::character varying)::text, ('Not required'::character varying)::text])) THEN 'Yes'::text
            ELSE 'No'::text
        END AS spill_prevention_not_required,
    d.spill_bucket_wall_type_id,
        CASE
            WHEN ((a.tank_rd_im_secondary_containment)::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((a.tank_rd_im_secondary_containment)::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS tank_interstitial_monitoring,
        CASE
            WHEN ((a.tank_rd_atg)::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((a.tank_rd_atg)::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS tank_automatic_tank_gauging_release_detection,
        CASE
            WHEN ((a.tank_rd_manual_gauging)::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((a.tank_rd_manual_gauging)::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS tank_manual_tank_gauging,
        CASE
            WHEN ((a.tank_rd_sir)::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((a.tank_rd_sir)::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS tank_statistical_inventory_reconciliation,
        CASE
            WHEN ((a.tank_rd_tightness_testing)::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((a.tank_rd_tightness_testing)::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS tank_tightness_testing,
        CASE
            WHEN ((a.tank_rd_inventory_control)::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((a.tank_rd_inventory_control)::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS tank_inventory_control,
        CASE
            WHEN ((a.tank_rd_groundwater_monitoring)::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((a.tank_rd_groundwater_monitoring)::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS tank_groundwater_monitoring,
        CASE
            WHEN ((a.tank_rd_vapor_monitoring)::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((a.tank_rd_vapor_monitoring)::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS tank_vapor_monitoring,
        CASE
            WHEN ((a.tank_rd_other)::text = 'Y'::text) THEN 'Yes'::text
            WHEN ((a.tank_rd_other)::text = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS tank_other_release_detection
   FROM ((((va_ust.usttankpipereleasedetection a
     JOIN va_ust.tanks b ON ((((a.tank_facility_id)::text = (b.tank_facility_id)::text) AND ((a.tank_number)::text = (b.tank_number)::text) AND ((a.tank_owner_id)::text = (b.tank_owner_id)::text))))
     LEFT JOIN va_ust.erg_tank_spill_bucket_wall z ON ((((a.index)::text = (z.index)::text) AND ((a.tank_number)::text = (z.tank_number)::text) AND ((a.tank_facility_id)::text = (z.tank_facility_id)::text))))
     LEFT JOIN va_ust.v_compartment_status_xwalk c ON (((a.tank_status)::text = (c.organization_value)::text)))
     LEFT JOIN va_ust.v_spill_bucket_wall_type_xwalk d ON ((z.tank_spill_bucket_wall = (d.organization_value)::text)))
  WHERE (((a.tank_type)::text = 'UST'::text) AND ((b.federally_regulated_tank)::text = 'Yes'::text));