----------------------------------------------------------------------------------------------------------

create view hi_ust.v_ust_facility as
select distinct
    "FacilityID"::character varying(50) as facility_id, 
    "FacilityName"::character varying(100) as facility_name, 
    owner_type_id as owner_type_id, 
    facility_type_id as facility_type1, 
    "FacilityAddress1"::character varying(100) as facility_address1, 
    "FacilityAddress2"::character varying(100) as facility_address2, 
    "FacilityCity"::character varying(100) as facility_city, 
    "FacilityCounty"::character varying(100) as facility_county, 
    "FacilityZipCode"::character varying(10) as facility_zip_code, 
    facility_state as facility_state, 
    --9::integer as facility_epa_region,
    "LatitudeMeasure"::double precision as facility_latitude, 
    "LongitudeMeasure"::double precision as facility_longitude, 
    coordinate_source_id as coordinate_source_id, 
    "FacilityOwnerCompanyName"::character varying(100) as facility_owner_company_name, 
    "FinancialResponsibilityObtained"::character varying(7) as financial_responsibility_obtained, 
    "AssociatedLUSTID"::character varying(40) as associated_ust_release_id 
from hi_ust."facility" a
    left join hi_ust.v_coordinate_source_xwalk b on a."HorizontalCollectionMethodName" = b.organization_value
    left join hi_ust.v_facility_type_xwalk c on a."FacilityType1" = c.organization_value
    left join hi_ust.v_owner_type_xwalk d on a."OwnerType" = d.organization_value
    left join hi_ust.v_state_xwalk e on a."FacilityState" = e.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------

create view hi_ust.v_ust_tank as
select distinct
    "tank_id"::integer as tank_id,       -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "TankID"::character varying(50) as tank_name, 
    tank_status_id as tank_status_id, 
    "FederallyRegulated"::character varying(7) as federally_regulated, 
    "FieldConstructed"::character varying(7) as field_constructed, 
    "EmergencyGenerator"::character varying(7) as emergency_generator, 
    "AirportHydrantSystem"::character varying(7) as airport_hydrant_system, 
    "MultipleTanks"::character varying(7) as multiple_tanks, 
    "TankClosureDate"::date as tank_closure_date, 
    "TankInstallationDate"::date as tank_installation_date, 
    "CompartmentalizedUST"::character varying(7) as compartmentalized_ust, 
    tank_material_description_id as tank_material_description_id, 
    "TankCorrosionProtectionSacrificialAnode"::character varying(7) as tank_corrosion_protection_sacrificial_anode, 
    "TankCorrosionProtectionImpressedCurrent"::character varying(7) as tank_corrosion_protection_impressed_current, 
    "TankCorrosionProtectionCathodicNotRequired"::character varying(7) as tank_corrosion_protection_cathodic_not_required, 
    "TankCorrosionProtectionInteriorLining"::character varying(7) as tank_corrosion_protection_interior_lining, 
    tank_secondary_containment_id as tank_secondary_containment_id 
from hi_ust."erg_tank_id" a
    left join hi_ust.v_tank_material_description_xwalk c on b."TankMaterialDescription" = c.organization_value
    left join hi_ust.v_tank_secondary_containment_xwalk d on b."TankSecondaryContainment" = d.organization_value
    left join hi_ust.v_tank_status_xwalk e on b."TankStatus" = e.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;