create or replace view "hi_ust"."v_ust_tank" as
 SELECT DISTINCT (x."FacilityID")::character varying(50) AS facility_id,
    t.tank_id,
    (x."TankID")::character varying(50) AS tank_name,
        CASE
            WHEN (x."EmergencyGenerator" = true) THEN 'Yes'::text
            WHEN (x."EmergencyGenerator" = false) THEN 'No'::text
            ELSE NULL::text
        END AS emergency_generator,
        CASE
            WHEN (x."MultipleTanks" = true) THEN 'Yes'::text
            WHEN (x."MultipleTanks" = false) THEN 'No'::text
            ELSE NULL::text
        END AS multiple_tanks,
        CASE
            WHEN (x."TankCorrosionProtectionCathodicNotRequired" = true) THEN 'Yes'::text
            WHEN (x."TankCorrosionProtectionCathodicNotRequired" = false) THEN 'No'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_cathodic_not_required,
        CASE
            WHEN (x."TankCorrosionProtectionInteriorLining" = true) THEN 'Yes'::text
            WHEN (x."TankCorrosionProtectionInteriorLining" = false) THEN 'No'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_interior_lining,
    ts.tank_status_id,
        CASE
            WHEN (x."FederallyRegulated" = true) THEN 'Yes'::text
            WHEN (x."FederallyRegulated" = false) THEN 'No'::text
            ELSE NULL::text
        END AS federally_regulated,
        CASE
            WHEN (x."FieldConstructed" = 'true'::text) THEN 'Yes'::text
            ELSE NULL::text
        END AS field_constructed,
        CASE
            WHEN (x."AirportHydrantSystem" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS airport_hydrant_system,
    (x."TankClosureDate")::date AS tank_closure_date,
    (x."TankInstallationDate")::date AS tank_installation_date,
        CASE
            WHEN (x."CompartmentalizedUST" = true) THEN 'Yes'::text
            WHEN (x."CompartmentalizedUST" = false) THEN 'No'::text
            ELSE NULL::text
        END AS compartmentalized_ust,
    tmd.tank_material_description_id,
        CASE
            WHEN (x."TankCorrosionProtectionSacrificialAnode" = true) THEN 'Yes'::text
            WHEN (x."TankCorrosionProtectionSacrificialAnode" = false) THEN 'No'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_sacrificial_anode,
        CASE
            WHEN (x."TankCorrosionProtectionImpressedCurrent" = true) THEN 'Yes'::text
            WHEN (x."TankCorrosionProtectionImpressedCurrent" = false) THEN 'No'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_impressed_current,
    tsc.tank_secondary_containment_id
   FROM ((((hi_ust.tank x
     JOIN hi_ust.erg_tank_id t ON (((((x."FacilityID")::character varying(50))::text = (t.facility_id)::text) AND (((x."TankID")::character varying(50))::text = (t.tank_name)::text))))
     LEFT JOIN hi_ust.v_tank_status_xwalk ts ON ((x."TankStatus" = (ts.organization_value)::text)))
     LEFT JOIN hi_ust.v_tank_material_description_xwalk tmd ON ((x."TankMaterialDescription" = (tmd.organization_value)::text)))
     LEFT JOIN hi_ust.v_tank_secondary_containment_xwalk tsc ON ((x."TankSecondaryContainment" = (tsc.organization_value)::text)));