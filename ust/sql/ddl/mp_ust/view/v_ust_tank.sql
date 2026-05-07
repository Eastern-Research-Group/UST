create or replace view "mp_ust"."v_ust_tank" as
 SELECT DISTINCT x.tank_id,
    ts.tank_status_id,
        CASE
            WHEN (lower(x.tanks_status_notes) ~~ '%emerg%'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS emergency_generator,
        CASE
            WHEN (x.total_tanks_at_site > 2) THEN 'Yes'::text
            ELSE NULL::text
        END AS multiple_tanks,
    to_date(x.tank_install_date, 'YYYY (Mon)'::text) AS tank_installation_date,
        CASE
            WHEN (x."COMPARTMENT_TK" = 'Y'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS compartmentalized_ust,
    tm.tank_material_description_id,
    sc.tank_secondary_containment_id,
    (x.tanks_status_notes)::character varying(4000) AS tank_comment,
    (x.deq_id)::character varying(50) AS facility_id
   FROM (((mp_ust.erg_mp_ust_tanks x
     LEFT JOIN mp_ust.v_tank_status_xwalk ts ON ((x.status = (ts.organization_value)::text)))
     LEFT JOIN mp_ust.v_tank_material_description_xwalk tm ON ((x.tank_type = (tm.organization_value)::text)))
     LEFT JOIN mp_ust.v_tank_secondary_containment_xwalk sc ON ((x.secondary_containment = (sc.organization_value)::text)));