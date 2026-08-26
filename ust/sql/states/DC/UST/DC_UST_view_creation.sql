----------------------------------------------------------------------------------------------------------

-- WARNINGS
-- Overriding query_logic for ust_tank.compartmentalized_ust with standardized recipe SQL.
-- Generated SQL failed validation for ust_tank: syntax error at or near "join"
LINE 15:  case when left join ( select "TankID", count("CompartmentID...
                         ^


create or replace view dc_ust.v_ust_tank as
select distinct
    nullif(trim(a."FacilityID"::text), '')::character varying(50) as facility_id,
    a."TankName"::integer as tank_id,
    a."TankID"::character varying(50) as tank_name,
    tank_location_id as tank_location_id,
    tank_status_id as tank_status_id,
    a."FederallyRegulated"::character varying(7) as federally_regulated,
    a."EmergencyGenerator"::character varying(7) as emergency_generator,
    a."MultipleTanks"::character varying(7) as multiple_tanks,
    a."TankClosureDate"::date as tank_closure_date,
    a."TankInstallationDate"::date as tank_installation_date,
    case when nullif(trim(a."CompartmentID"::text), '') ~ '^[+-]?\d+(\.0+)?$' and (nullif(trim(a."CompartmentID"::text), ''))::numeric > 1 then 'Yes'::text when nullif(trim(a."CompartmentID"::text), '') ~ '^[+-]?\d+(\.0+)?$' then 'No'::text else null::text end as compartmentalized_ust,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when left join ( select "TankID", count("CompartmentID") as comp_count
            from "compartment"
            group by "TankID"
        ) c on "TankID" = c."TankID" then a."CompartmentID"::integer else null end as number_of_compartments,
    tank_material_description_id as tank_material_description_id,
    a."TankCorrosionProtectionSacrificialAnode"::character varying(7) as tank_corrosion_protection_sacrificial_anode,
    a."TankCorrosionProtectionImpressedCurrent"::character varying(7) as tank_corrosion_protection_impressed_current,
    a."TankCorrosionProtectionCathodicNotRequired"::character varying(7) as tank_corrosion_protection_cathodic_not_required,
    a."TankCorrosionProtectionInteriorLining"::character varying(7) as tank_corrosion_protection_interior_lining,
    a."TankCorrosionProtectionOther"::character varying(7) as tank_corrosion_protection_other,
    a."TankCorrosionProtectionUnknown"::character varying(7) as tank_corrosion_protection_unknown,
    tank_secondary_containment_id as tank_secondary_containment_id,
    cert_of_installation_id as cert_of_installation_id
from dc_ust."tank" a
    left join dc_ust.v_cert_of_installation_xwalk c on a."CertOfInstallation" = c.organization_value
    left join dc_ust.v_tank_location_xwalk d on a."TankLocation" = d.organization_value
    left join dc_ust.v_tank_material_description_xwalk e on a."TankMaterialDescription" = e.organization_value
    left join dc_ust.v_tank_secondary_containment_xwalk f on a."TankSecondaryContainment" = f.organization_value
    left join dc_ust.v_tank_status_xwalk g on a."TankStatus" = g.organization_value
where not exists
    (select 1 from dc_ust.erg_unregulated_facilities unreg_fac
    where nullif(trim(a."FacilityID"::text), '') = unreg_fac.facility_id)
and not exists
    (select 1 from dc_ust.erg_unregulated_tanks unreg_tank
    where nullif(trim(a."FacilityID"::text), '') = unreg_tank.facility_id and case when nullif(trim(a."TankName"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."TankName"::text), '')::integer else null::integer end = unreg_tank.tank_id)
and exists
    (select 1 from dc_ust.v_ust_facility parent
    where parent.facility_id = nullif(trim(a."FacilityID"::text), ''))

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
