create or replace view "mp_ust"."v_ust_compartment" as
 SELECT DISTINCT x.deq_id AS facility_id,
    x.tank_id,
    c.compartment_id,
    (x.tank_size)::integer AS compartment_capacity_gallons,
        CASE
            WHEN (x.spill_overflow_corrosion_protection ~~ '%Ball Float%'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_ball_float_valve,
        CASE
            WHEN (x.spill_overflow_corrosion_protection ~~ '%Alarm%'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_high_level_alarm,
        CASE
            WHEN (x.spill_overflow_corrosion_protection ~~ '%Flapper device%'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_other,
    ts.compartment_status_id
   FROM ((mp_ust.erg_mp_ust_tanks x
     JOIN mp_ust.erg_compartment c ON (((x.deq_id = (c.facility_id)::text) AND (x.tank_id = c.tank_id))))
     LEFT JOIN mp_ust.v_compartment_status_xwalk ts ON ((x.status = (ts.organization_value)::text)));