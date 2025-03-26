------------------------------------------------------------------------------------------------------------------------------------------------------------------------



create or replace view me_ust.v_ust_facility as
 WITH latest_tank_status AS (
         SELECT (tanks."REGISTRATION NUMBER")::text AS facility_id,
            tanks."TANK STATUS DATE",
            tanks."LATITUDE",
            tanks."LONGITUDE",
            row_number() OVER (PARTITION BY (tanks."REGISTRATION NUMBER")::text ORDER BY tanks."TANK STATUS DATE" DESC, tanks."LATITUDE" desc nulls last) AS row_num
           FROM me_ust.tanks
        )
 SELECT DISTINCT (x."REGISTRATION NUMBER")::text AS facility_id,
    x."FACILITY NAME" AS facility_name,
    ft.facility_type_id AS facility_type1,
    x."FACILITY STREET ADDRESS" AS facility_address1,
    x."FACILITY CITY" AS facility_city,
    'ME'::text AS facility_state,
    1 AS facility_epa_region,
    lt."LATITUDE" AS facility_latitude,
    lt."LONGITUDE" AS facility_longitude,
    x."OWNER NAME" AS facility_owner_company_name,
    x."OPERATOR NAME" AS facility_operator_company_name
   FROM ((me_ust.tanks x
     JOIN latest_tank_status lt ON ((((x."REGISTRATION NUMBER")::text = lt.facility_id) AND (lt.row_num = 1))))
     LEFT JOIN me_ust.v_facility_type_xwalk ft ON ((x."FACILITY USE CODE" = (ft.organization_value)::text)))
 where x."REGISTRATION NUMBER"::varchar(50) not in (select facility_id from me_ust.erg_unregulated_facilities);



create or replace view me_ust.v_ust_tank as
 SELECT DISTINCT (x."REGISTRATION NUMBER")::text AS facility_id,
    (x."TANK NUMBER")::integer AS tank_id,
    tl.tank_location_id,
    ts.tank_status_id,
        CASE
            WHEN (x."FED REGULATED" = 'Y'::text) THEN 'Yes'::text
            WHEN (x."FED REGULATED" = 'N'::text) THEN 'No'::text
            ELSE NULL::text
        END AS federally_regulated,
        CASE
            WHEN ((x."TANK STATUS" = 'REMOVED'::text) AND (NULLIF(x."TANK STATUS DATE", ' '::text) IS NOT NULL)) THEN (NULLIF(x."TANK STATUS DATE", ' '::text))::date
            WHEN ((x."TANK STATUS" = 'ABANDONED_IN_PLACE'::text) AND (NULLIF(x."TANK STATUS DATE", ' '::text) IS NOT NULL)) THEN (NULLIF(x."TANK STATUS DATE", ' '::text))::date
            ELSE NULL::date
        END AS tank_closure_date,
    (NULLIF(x."DATE TANK INSTALLED", ' '::text))::date AS tank_installation_date,
    tm.tank_material_description_id,
        CASE
            WHEN (tm.tank_material_description_id = ANY (ARRAY[5, 6])) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_sacrificial_anode
   FROM (((me_ust.tanks x
     LEFT JOIN me_ust.v_tank_location_xwalk tl ON ((x."TANK ABOVE BELOW" = (tl.organization_value)::text)))
     LEFT JOIN me_ust.v_tank_status_xwalk ts ON ((x."TANK STATUS" = (ts.organization_value)::text)))
     LEFT JOIN me_ust.v_tank_material_description_xwalk tm ON ((x."TANK MATERIAL LABEL" = (tm.organization_value)::text)))
  WHERE (x."TANK STATUS" <> ALL (ARRAY['ACTIVE_NON_REGULATED'::text, 'NEVER_INSTALLED'::text, 'PLANNED'::text, 'TRANSFER'::text]))
 and not exists
	(select 1 from me_ust.erg_unregulated_tanks unreg
	where x."REGISTRATION NUMBER"::varchar(50) = unreg.facility_id and x."TANK NUMBER"::int = unreg.tank_id);


CREATE OR REPLACE VIEW me_ust.v_ust_tank_substance AS
SELECT DISTINCT 
    x."REGISTRATION NUMBER"::character varying(50)  AS facility_id,
    x."TANK NUMBER"::integer AS tank_id,
    s.substance_id
FROM me_ust.tanks x
    JOIN me_ust.v_substance_xwalk s ON x."PRODUCT STORED" = s.organization_value
WHERE s.substance_id is not null 
AND x."TANK STATUS" not in ('ACTIVE_NON_REGULATED', 'NEVER_INSTALLED', 'PLANNED', 'TRANSFER')
AND NOT EXISTS 
  (SELECT 1 FROM me_ust.erg_unregulated_tanks unreg
   WHERE x."REGISTRATION NUMBER"::character varying(50) = unreg.facility_id AND x."TANK NUMBER"::integer = unreg.tank_id);   


create or replace view me_ust.v_ust_compartment as
 SELECT DISTINCT (x."REGISTRATION NUMBER")::text AS facility_id,
    (x."TANK NUMBER")::integer AS tank_id,
    (x."CHAMBER ID")::integer AS compartment_id,
    cs.compartment_status_id,
    (x."VOLUME IN GALLONS")::integer AS compartment_capacity_gallons,
        CASE
            WHEN (x."TANK LEAK DETECTION" = 'AUTOMATIC_TANK_GAUGE'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS automatic_tank_gauging_continuous_leak_detection,
        CASE
            WHEN (x."TANK LEAK DETECTION" = 'AUTOMATIC_TANK_GAUGE'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_automatic_tank_gauging_release_detection,
        CASE
            WHEN (x."TANK LEAK DETECTION" = 'CONTINUOUS_GROUNDWATER_MON'::text) THEN 'Yes'::text
            WHEN (x."TANK LEAK DETECTION" = 'MANUAL_GROUNDWATER_SAMPLE'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_groundwater_monitoring,
        CASE
            WHEN (x."TANK LEAK DETECTION" = 'SIA_INVENTORY_ANALYSIS'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_inventory_control,
        CASE
            WHEN (x."TANK LEAK DETECTION" <> ALL (ARRAY['AUTOMATIC_TANK_GAUGE'::text, 'MONTHLY_SIR'::text, 'SIA_INVENTORY_ANALYSIS'::text, 'CONTINUOUS_GROUNDWATER_MON'::text, 'CONTINUOUS_VAPOR_GAUGE'::text, 'UNKNOWN'::text, 'NONE'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_other_release_detection,
        CASE
            WHEN (x."TANK LEAK DETECTION" = 'MONTHLY_SIR'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_statistical_inventory_reconciliation,
        CASE
            WHEN (x."TANK LEAK DETECTION" = 'CONTINUOUS_VAPOR_MONITORING'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_vapor_monitoring,
        CASE
            WHEN (x."OVERFILL PROTECTION" = 'SPILL CONTAINMENT'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS spill_bucket_installed,
        CASE
            WHEN (x."OVERFILL PROTECTION" = ANY (ARRAY['VENT_BALL'::text, 'VENT_WHISTLE'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_high_level_alarm,
        CASE
            WHEN (x."OVERFILL PROTECTION" = 'UNKNOWN'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_unknown,
        CASE
            WHEN (x."OVERFILL PROTECTION" = ANY (ARRAY['PRESSURE_DROP_TUBE'::text, 'DROP_TUBE'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_flow_shutoff_device,
        CASE
            WHEN (x."OVERFILL PROTECTION" = 'LEVEL_GAUGE'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_ball_float_valve,
        CASE
            WHEN (x."OVERFILL PROTECTION" = ANY (ARRAY['ELECTRONIC'::text, 'MECHANICAL'::text, 'MECH_ELEC'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS overfill_prevention_other
   FROM (me_ust.tanks x
     LEFT JOIN me_ust.v_compartment_status_xwalk cs ON ((x."TANK STATUS LABEL" = (cs.organization_value)::text)))
  WHERE (x."TANK STATUS LABEL" <> ALL (ARRAY['ACTIVE NON-REGULATED'::text, 'NEVER INSTALLED'::text, 'PLANNED FOR INSTALLATION'::text, 'TRANSFER'::text]))
 and not exists
	(select 1 from me_ust.erg_unregulated_tanks unreg
	where x."REGISTRATION NUMBER"::varchar(50) = unreg.facility_id and x."TANK NUMBER"::int = unreg.tank_id);

CREATE OR REPLACE VIEW me_ust.v_ust_compartment_substance AS
SELECT DISTINCT 
    x."REGISTRATION NUMBER"::character varying(50)  AS facility_id,
    x."TANK NUMBER"::integer AS tank_id,
    x."CHAMBER ID"::integer as compartment_id,
    s.substance_id
FROM me_ust.tanks x
    JOIN me_ust.v_substance_xwalk s ON x."PRODUCT STORED" = s.organization_value
WHERE s.substance_id is not null 
AND x."TANK STATUS" not in ('ACTIVE_NON_REGULATED', 'NEVER_INSTALLED', 'PLANNED', 'TRANSFER')
AND NOT EXISTS 
  (SELECT 1 FROM me_ust.erg_unregulated_tanks unreg
   WHERE x."REGISTRATION NUMBER"::character varying(50) = unreg.facility_id AND x."TANK NUMBER"::integer = unreg.tank_id);   



create or replace view me_ust.v_ust_piping as
 SELECT DISTINCT (x."REGISTRATION NUMBER")::text AS facility_id,
    (x."TANK NUMBER")::integer AS tank_id,
    (x."CHAMBER ID")::integer AS compartment_id,
    (t.piping_id)::text AS piping_id,
    ps.piping_style_id,
        CASE
            WHEN (x."PIPE LEAK DETECTION" = ANY (ARRAY['SEC_CONT_CONTIN_ELEC_MON'::text, 'SEC_CONT_MANUAL_MON'::text, 'SECONDARY_CONTAINMENT'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS pipe_secondary_containment_other,
        CASE
            WHEN (x."PIPE MATERIAL LABEL" = 'DOUBLE-WALLED CP STEEL'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_corrosion_protection_sacrificial_anode,
        CASE
            WHEN (x."PIPE LEAK DETECTION" = 'INLINE_LEAK_DETECTOR'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_line_leak_detector,
        CASE
            WHEN (x."PIPE MATERIAL LABEL" = ANY (ARRAY['COPPER'::text, 'COPPER WITH SECONDARY CONTAINMENT'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_copper,
        CASE
            WHEN (x."PIPE MATERIAL LABEL" = 'FLEXIBLE DOUBLE-WALLED PIPING'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_flex,
        CASE
            WHEN (x."PIPE MATERIAL LABEL" = 'GALVANIZED STEEL'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_gal_steel,
        CASE
            WHEN (x."PIPE MATERIAL LABEL" = 'NONE'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_no_piping,
        CASE
            WHEN (x."PIPE MATERIAL LABEL" = 'OTHER'::text) THEN 'Yes'::text
            WHEN (x."PIPE MATERIAL LABEL" <> ALL (ARRAY['GALVANIZED STEEL'::text, 'STAINLESS STEEL'::text, 'CARBON STEEL'::text, 'STEEL WITH CATHODIC PROTECTION'::text, 'DOUBLE-WALLED CP STEEL'::text, 'STEEL - BARE OR ASPHALT COATED'::text, 'STEEL WITH SECONDARY CONTAINMENT'::text, 'BLACK STEEL'::text, 'STEEL - BARE WITH INTERNAL LINING'::text, 'FLEXIBLE DOUBLE-WALLED PIPING'::text, 'NONE'::text])) THEN 'No'::text
            ELSE NULL::text
        END AS piping_material_other,
        CASE
            WHEN (x."PIPE MATERIAL LABEL" = 'STAINLESS STEEL'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_stainless_steel,
        CASE
            WHEN (x."PIPE MATERIAL LABEL" = ANY (ARRAY['CARBON STEEL'::text, 'STEEL WITH CATHODIC PROTECTION'::text, 'DOUBLE-WALLED CP STEEL'::text, 'STEEL - BARE OR ASPHALT COATED'::text, 'STEEL WITH SECONDARY CONTAINMENT'::text, 'BLACK STEEL'::text, 'STEEL - BARE WITH INTERNAL LINING'::text])) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_steel,
        CASE
            WHEN ((x."PIPE LEAK DETECTION" IS NOT NULL) AND (x."PIPE LEAK DETECTION" <> ALL (ARRAY['INLINE_LEAK_DETECTOR'::text, 'CONTINUOUS_VAPOR_MONITORING'::text, 'MONTHLY_SIR'::text, 'NONE'::text, 'UNKNOWN'::text]))) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_release_detection_other,
        CASE
            WHEN (x."PIPE LEAK DETECTION" = 'MONTHLY_SIR'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_statistical_inventory_reconciliation,
        CASE
            WHEN (x."PIPE LEAK DETECTION" = 'CONTINUOUS_VAPOR_MONITORING'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_vapor_monitoring
   FROM ((me_ust.tanks x
     JOIN me_ust.erg_piping_id t ON ((((x."REGISTRATION NUMBER")::text = (t.facility_id)::text) AND ((x."TANK NUMBER")::text = (t.tank_id)::text) AND ((x."CHAMBER ID")::text = (t.compartment_id)::text))))
     LEFT JOIN me_ust.v_piping_style_xwalk ps ON ((x."CHAMBER_PUMP_TYPE_LABEL" = (ps.organization_value)::text)))
 where x."TANK STATUS" not in ('ACTIVE_NON_REGULATED', 'NEVER_INSTALLED', 'PLANNED', 'TRANSFER')
 and not exists
	(select 1 from me_ust.erg_unregulated_tanks unreg
	where x."REGISTRATION NUMBER"::varchar(50) = unreg.facility_id and x."TANK NUMBER"::int = unreg.tank_id);