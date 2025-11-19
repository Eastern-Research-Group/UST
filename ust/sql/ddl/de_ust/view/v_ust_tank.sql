create or replace view "de_ust"."v_ust_tank" as
 SELECT DISTINCT ON (x."TankID") x."FacilityID" AS facility_id,
    (x."TankID")::integer AS tank_id,
    x."TankName" AS tank_name,
    tl.tank_location_id,
    ts.tank_status_id,
    x."FederallyRegulated" AS federally_regulated,
    x."FieldConstructed" AS field_constructed,
    x."EmergencyGenerator" AS emergency_generator,
    x."AirportHydrantSystem" AS airport_hydrant_system,
    x."MultipleTanks" AS multiple_tanks,
    (x."TankClosureDate")::date AS tank_closure_date,
    (x."TankInstallationDate")::date AS tank_installation_date,
    x."CompartmentalizedUST" AS compartmentalized_ust,
    (x."NumberOfCompartments")::integer AS number_of_compartments,
    tm.tank_material_description_id,
    x."TankCorrosionProtectionSacrificialAnode" AS tank_corrosion_protection_sacrificial_anode,
    x."TankCorrosionProtectionImpressedCurrent" AS tank_corrosion_protection_impressed_current,
    x."TankCorrosionProtectionCathodicNotRequired" AS tank_corrosion_protection_cathodic_not_required,
    x."TankCorrosionProtectionInteriorLining" AS tank_corrosion_protection_interior_lining,
    x."TankCorrosionProtectionOther" AS tank_corrosion_protection_other,
    x."TankCorrosionProtectionUnknown" AS tank_corrosion_protection_unknown,
    sc.tank_secondary_containment_id,
    c.cert_of_installation_id
   FROM (((((de_ust.tank x
     LEFT JOIN de_ust.v_cert_of_installation_xwalk c ON ((x."CertOfInstallation" = (c.organization_value)::text)))
     LEFT JOIN de_ust.v_tank_location_xwalk tl ON ((x."TankLocation" = (tl.organization_value)::text)))
     LEFT JOIN de_ust.v_tank_status_xwalk ts ON ((x."TankStatus" = (ts.organization_value)::text)))
     LEFT JOIN de_ust.v_tank_material_description_xwalk tm ON ((x."TankMaterialDescription" = (tm.organization_value)::text)))
     LEFT JOIN de_ust.v_tank_secondary_containment_xwalk sc ON ((x."TankSecondaryContainment" = (sc.organization_value)::text)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM de_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id)))));