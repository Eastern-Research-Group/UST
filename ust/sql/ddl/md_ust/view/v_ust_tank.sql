create or replace view "md_ust"."v_ust_tank" as
 SELECT DISTINCT (x."FacilityID")::character varying(50) AS facility_id,
    (x."TankID")::integer AS tank_id,
    vtsx.tank_status_id,
        CASE
            WHEN (x."TankMatDesc" = 'Airport Hydrant System'::text) THEN 'Yes'::text
            ELSE 'No'::text
        END AS airport_hydrant_system,
    (x."DateClosed")::date AS tank_closure_date,
    (x."DateInstalled")::date AS tank_installation_date,
        CASE
            WHEN (md_ust.get_compartment_data(x."FacilityID", x."TankID") = 1) THEN 'No'::text
            ELSE 'Yes'::text
        END AS compartmentalized_ust,
    (md_ust.get_compartment_data(x."FacilityID", x."TankID"))::integer AS number_of_compartments,
    vtmdx.tank_material_description_id,
    vtscx.tank_secondary_containment_id,
        CASE
            WHEN (x."TankMatDesc" ~~ '%Impressed Current%'::text) THEN 'Yes'::text
            ELSE 'No'::text
        END AS tank_corrosion_protection_impressed_current,
        CASE
            WHEN (x."TankMatDesc" ~~ '%Lined Interior%'::text) THEN 'Yes'::text
            ELSE 'No'::text
        END AS tank_corrosion_protection_interior_lining,
        CASE
            WHEN (x."TankMatDesc" = ANY (ARRAY['Cathodically Protected Steel (Supplemental Anodes Added)'::text, 'Cathodically Protected Steel (Coating w/CP - Galvanic)'::text])) THEN 'Yes'::text
            ELSE 'No'::text
        END AS tank_corrosion_protection_sacrificial_anode
   FROM (((md_ust.md_tanks_combined x
     LEFT JOIN md_ust.v_tank_status_xwalk vtsx ON (((vtsx.organization_value)::text = x."TankStatusDesc")))
     LEFT JOIN md_ust.v_tank_material_description_xwalk vtmdx ON (((vtmdx.organization_value)::text = x."TankMatDesc")))
     LEFT JOIN md_ust.v_tank_secondary_containment_xwalk vtscx ON (((vtscx.organization_value)::text = x."TankModsDesc")));