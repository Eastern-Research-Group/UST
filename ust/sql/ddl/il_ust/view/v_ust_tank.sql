create or replace view "il_ust"."v_ust_tank" as
 SELECT DISTINCT (x."FacilityID")::text AS facility_id,
    (x."TankID")::integer AS tank_id,
    (x."TankName")::character varying(50) AS tank_name,
    tl.tank_location_id,
    ts.tank_status_id,
    x."FederallyRegulated" AS federally_regulated,
    x."FieldConstructed" AS field_constructed,
    x."EmergencyGenerator" AS emergency_generator,
    x."AirportHydrantSystem" AS airport_hydrant_system,
    x."MultipleTanks" AS multiple_tanks,
    (x."TankClosureDate")::date AS tank_closure_date,
    (x."TankInstallationDate")::date AS tank_installation_date,
    tm.tank_material_description_id,
    x."TankCorrosionProtectionSacrificailAnode" AS tank_corrosion_protection_sacrificial_anode,
    x."TankCorrosionProtectionImpressedCurrent" AS tank_corrosion_protection_impressed_current,
    x."TankCorrosionProtectionNotRequired" AS tank_corrosion_protection_cathodic_not_required,
    x."TankCorrosionProtectionInteriorLining" AS tank_corrosion_protection_interior_lining,
    tsc.tank_secondary_containment_id,
    coi.cert_of_installation_id
   FROM (((((il_ust.tank x
     LEFT JOIN il_ust.v_tank_location_xwalk tl ON ((x."TankLocation" = (tl.organization_value)::text)))
     LEFT JOIN il_ust.v_tank_status_xwalk ts ON ((x."TankStatus" = (ts.organization_value)::text)))
     LEFT JOIN il_ust.v_tank_material_description_xwalk tm ON ((x."TankMaterialDescription" = (tm.organization_value)::text)))
     LEFT JOIN il_ust.v_tank_secondary_containment_xwalk tsc ON ((x."TankSecondaryContainment" = (tsc.organization_value)::text)))
     LEFT JOIN il_ust.v_cert_of_installation_xwalk coi ON ((x."CertOfInstallation" = (coi.organization_value)::text)))
  WHERE ((NOT (EXISTS ( SELECT 1
           FROM il_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id))))) AND (NOT (EXISTS ( SELECT 1
           FROM il_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id))))));