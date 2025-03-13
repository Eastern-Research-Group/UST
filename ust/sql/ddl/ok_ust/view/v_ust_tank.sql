create or replace view "ok_ust"."v_ust_tank" as
 SELECT DISTINCT (x."FacilityID")::character varying(50) AS facility_id,
    (x.tank_name)::integer AS tank_id,
    vtsx.tank_status_id,
        CASE
            WHEN (x."Manifold" IS TRUE) THEN 'Yes'::text
            ELSE 'No'::text
        END AS multiple_tanks,
    (x."ClosedDate")::date AS tank_closure_date,
    (x."InstalledDate")::date AS tank_installation_date,
        CASE
            WHEN (x."Compartments" <> ALL (ARRAY['0'::bigint, '1'::bigint])) THEN 'Yes'::text
            ELSE 'No'::text
        END AS compartmentalized_ust,
    (x."Compartments")::integer AS number_of_compartments,
    vtmdx.tank_material_description_id,
    s.tank_secondary_containment_id
   FROM ((((ok_ust."OK_UST_Data" x
     LEFT JOIN ok_ust.v_tank_status_xwalk vtsx ON (((vtsx.organization_value)::text = x."Status")))
     LEFT JOIN ok_ust.v_tank_material_description_xwalk vtmdx ON (((vtmdx.organization_value)::text = x."Tank Material")))
     LEFT JOIN ok_ust.v_tank_secondary_containment_xwalk s ON (((s.organization_value)::text = x."Tank Construction")))
     JOIN ok_ust.erg_compartments_deduplicated b ON (((x."FacilityID" = b."FacilityID") AND (x.tank_name = b."TankNumber"))));