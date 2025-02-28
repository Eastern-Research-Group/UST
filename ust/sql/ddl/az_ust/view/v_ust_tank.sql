create or replace view "az_ust"."v_ust_tank" as
 SELECT DISTINCT (x."FacilityID")::character varying(50) AS facility_id,
    (x."TankName")::integer AS tank_id,
    (x."TankName")::character varying(50) AS tank_name,
    tl.tank_location_id,
    ts.tank_status_id,
    (x."FederallyRegulated")::character varying(7) AS federally_regulated,
    (x."FieldConstructed")::character varying(7) AS field_constructed,
    (x."EmergencyGenerator")::character varying(7) AS emergency_generator,
    (x."AirportHydrantSystem")::character varying(7) AS airport_hydrant_system,
    (x."TankClosureDate")::date AS tank_closure_date,
    (x."TankInstallationDate")::date AS tank_installation_date,
    (x."CompartmentalizedUST")::character varying(7) AS compartmentalized_ust,
    (x."NumberOfCompartments")::integer AS number_of_compartments,
    md.tank_material_description_id,
    (x."TankCorrosionProtectionSacrificialAnode")::character varying(7) AS tank_corrosion_protection_sacrificial_anode,
    (x."TankCorrosionProtectionImpressedCurrent")::character varying(7) AS tank_corrosion_protection_impressed_current,
    (x."TankCorrosionProtectionInteriorLining")::character varying(7) AS tank_corrosion_protection_interior_lining,
    sc.tank_secondary_containment_id
   FROM ((((az_ust.ust_tank x
     LEFT JOIN az_ust.v_tank_location_xwalk tl ON ((x."TankLocation" = (tl.organization_value)::text)))
     LEFT JOIN az_ust.v_tank_status_xwalk ts ON ((x."TankStatus" = (ts.organization_value)::text)))
     LEFT JOIN az_ust.v_tank_material_description_xwalk md ON ((x."TankMaterialDescription" = (md.organization_value)::text)))
     LEFT JOIN az_ust.v_tank_secondary_containment_xwalk sc ON ((x."TankSecondaryContainment" = (sc.organization_value)::text)));