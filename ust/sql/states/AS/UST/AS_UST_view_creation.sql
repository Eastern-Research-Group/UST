----------------------------------------------------------------------------------------------------------

-- WARNINGS
-- Generated SQL failed validation for ust_facility: syntax error at or near ","
LINE 34:  case when a."USTReportedRelease" = None, then null else 'a....
                                                 ^


create or replace view as_ust.v_ust_facility as
select distinct
    a."FacilityID"::character varying(50) as facility_id,
    a."FacilityName"::character varying(100) as facility_name,
    owner_type_id as owner_type_id,
    facility_type_id as facility_type1,
    a."FacilityAddress1"::character varying(100) as facility_address1,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case
    when a."FacilityAddress2" = NA then null
    else 'a."FacilityAddress2"'
    end as facility_address2,
    a."FacilityCity"::character varying(100) as facility_city,
    a."FacilityCounty"::character varying(100) as facility_county,
    a."FacilityZipCode"::character varying(10) as facility_zip_code,
    facility_state as facility_state,
    9::integer as facility_epa_region,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case
    when a."FacilityTribalSite" = NA then null
    else 'a."FacilityTribalSite"'
    end as facility_tribal_site,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case
    when a."FacilityTribe" = NA then null
    else 'a."FacilityTribe"'
    end as facility_tribe,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    CASE WHEN a."FacilityLatitude" ~ '[SW]$' THEN -regexp_replace(coord, '[^0-9.]', '', 'g')::numeric ELSE regexp_replace(coord, '[^0-9.]', '', 'g')::numeric END AS facility_latitude,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    CASE WHEN 'FacilityLatitude' ~ '[SW]$' THEN -regexp_replace(coord, '[^0-9.]', '', 'g')::numeric ELSE regexp_replace(coord, '[^0-9.]', '', 'g')::numeric END AS facility_latitude,
    a."FacilityOwnerCompanyName"::character varying(100) as facility_owner_company_name,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when a."USTReportedRelease" = None, then null else 'a."USTReportedRelease"' then 'Yes'::character varying(7) else null end as ust_reported_release,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when "USTReportedRelease" = NA, then null else '"USTReportedRelease"' then a."AssociatedLUSTID"::character varying(40) else null end as associated_ust_release_id
from as_ust."facility" a
    left join as_ust.v_facility_type_xwalk b on a."FacilityType1" = b.organization_value
    left join as_ust.v_owner_type_xwalk c on a."OwnerType" = c.organization_value
    left join as_ust.v_state_xwalk d on a."FacilityState" = d.organization_value
where not exists
    (select 1 from as_ust.erg_unregulated_facilities unreg
    where nullif(trim(a."FacilityID"::text), '') = unreg.facility_id)
and coalesce(b.exclude_from_query, 'N') <> 'Y'
and coalesce(c.exclude_from_query, 'N') <> 'Y'
and coalesce(d.exclude_from_query, 'N') <> 'Y'

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
----------------------------------------------------------------------------------------------------------

-- WARNINGS
-- Overriding query_logic for ust_tank.federally_regulated with standardized recipe SQL.
-- Overriding query_logic for ust_tank.emergency_generator with standardized recipe SQL.
-- Overriding query_logic for ust_tank.airport_hydrant_system with standardized recipe SQL.
-- Overriding query_logic for ust_tank.compartmentalized_ust with standardized recipe SQL.
-- Generated SQL failed validation for ust_tank: column "na" does not exist
LINE 11:  when a."FieldConstructed" = NA then null
                                      ^


create or replace view as_ust.v_ust_tank as
select distinct
    nullif(trim(a."FacilityID"::text), '')::character varying(50) as facility_id,
    b."tank_id"::integer as tank_id,
    a."TankName"::character varying(50) as tank_name,
    tank_location_id as tank_location_id,
    tank_status_id as tank_status_id,
    case when lower(nullif(trim(a."FederallyRegulated"::text), '')) in ('true', 't', 'yes', 'y', '1', '1.0') then 'Yes'::text when lower(nullif(trim(a."FederallyRegulated"::text), '')) in ('false', 'f', 'no', 'n', '0', '0.0') then 'No'::text else null::text end as federally_regulated,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case
    when a."FieldConstructed" = NA then null
    else 'a."FieldConstructed"'
    end as field_constructed,
    case when lower(nullif(trim(a."EmergencyGenerator"::text), '')) in ('true', 't', 'yes', 'y', '1', '1.0') then 'Yes'::text when lower(nullif(trim(a."EmergencyGenerator"::text), '')) in ('false', 'f', 'no', 'n', '0', '0.0') then 'No'::text else null::text end as emergency_generator,
    case when lower(nullif(trim(a."AirportHydrantSystem"::text), '')) in ('true', 't', 'yes', 'y', '1', '1.0', 'airport hydrant system') then 'Yes'::text when lower(nullif(trim(a."AirportHydrantSystem"::text), '')) in ('false', 'f', 'no', 'n', '0', '0.0') then 'No'::text else null::text end as airport_hydrant_system,
    a."MultipleTanks"::character varying(7) as multiple_tanks,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case
    when a."TankClosureDate" = NA then null else 'a."TankClosureDate"'
    end as tank_closure_date,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    CASE WHEN a."TankInstallationDate" ~ '^\d{4}$' THEN to_date(a."TankInstallationDate", 'YYYY') WHEN a."TankInstallationDate" ~ '^[A-Za-z]{3}-\d{2}$' THEN to_date(a."TankInstallationDate", 'Mon-YY') WHEN trim(a."TankInstallationDate") ~ '^[A-Za-z]{3} \d{4}$' THEN to_date(trim(a."TankInstallationDate"), 'Mon YYYY') END AS tank_installation_date,
    case when nullif(trim(a."CompartmentalizedUST"::text), '') ~ '^[+-]?\d+(\.0+)?$' and (nullif(trim(a."CompartmentalizedUST"::text), ''))::numeric > 1 then 'Yes'::text when nullif(trim(a."CompartmentalizedUST"::text), '') ~ '^[+-]?\d+(\.0+)?$' then 'No'::text else null::text end as compartmentalized_ust,
    a."NumberOfCompartments"::integer as number_of_compartments,
    tank_material_description_id as tank_material_description_id,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case
    when a."TankCorrosionProtectionSacrificialAnode" = NA then null else 'a."TankCorrosionProtectionSacrificialAnode"'
    end as tank_corrosion_protection_sacrificial_anode,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case
    when a."TankCorrosionProtectionImpressedCurrent" = NA then null else 'a."TankCorrosionProtectionImpressedCurrent"'
    end as tank_corrosion_protection_impressed_current,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case
    when a."TankCorrosionProtectionCathodicNotRequired" = NA then null else 'a."TankCorrosionProtectionCathodicNotRequired"'
    end as tank_corrosion_protection_cathodic_not_required,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case
    when a."TankCorrosionProtectionInteriorLining" = NA then null else 'a."TankCorrosionProtectionInteriorLining"'
    end as tank_corrosion_protection_interior_lining,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case
    when a."TankCorrosionProtectionOther" = NA then null else 'a."TankCorrosionProtectionOther"'
    end as tank_corrosion_protection_other,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case
    when a."TankCorrosionProtectionUnknown" = NA then null else 'a."TankCorrosionProtectionUnknown"'
    end as tank_corrosion_protection_unknown,
    tank_secondary_containment_id as tank_secondary_containment_id,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case
    when a."CertOfInstallationOther" = NA then null else 'a."CertOfInstallationOther"'
    end as cert_of_installation_other
from as_ust."tank" a
    left join as_ust."erg_tank_id" b on a."FacilityID" = b."facility_id" and a."TankName" = b."tank_name" 
    left join as_ust.v_tank_location_xwalk c on a."TankLocation" = c.organization_value
    left join as_ust.v_tank_material_description_xwalk d on a."TankMaterialDescription" = d.organization_value
    left join as_ust.v_tank_secondary_containment_xwalk e on a."TankSecondaryContainment" = e.organization_value
    left join as_ust.v_tank_status_xwalk f on a."TankStatus" = f.organization_value
where not exists
    (select 1 from as_ust.erg_unregulated_facilities unreg_fac
    where nullif(trim(a."FacilityID"::text), '') = unreg_fac.facility_id)
and not exists
    (select 1 from as_ust.erg_unregulated_tanks unreg_tank
    where nullif(trim(a."FacilityID"::text), '') = unreg_tank.facility_id and case when nullif(trim(a."tank_id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."tank_id"::text), '')::integer else null::integer end = unreg_tank.tank_id)
and exists
    (select 1 from as_ust.v_ust_facility parent
    where parent.facility_id = nullif(trim(a."FacilityID"::text), ''))
and coalesce(c.exclude_from_query, 'N') <> 'Y'
and coalesce(d.exclude_from_query, 'N') <> 'Y'
and coalesce(e.exclude_from_query, 'N') <> 'Y'
and coalesce(f.exclude_from_query, 'N') <> 'Y'

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
----------------------------------------------------------------------------------------------------------

-- WARNINGS
-- Generated SQL failed validation for ust_tank_substance: column "na" does not exist
LINE 8:  when a."CompartmentSubstanceCASNO" = NA then null else 'a."...
                                              ^


create or replace view as_ust.v_ust_tank_substance as
select distinct
    nullif(trim(a."FacilityID"::text), '')::character varying(50) as facility_id,
    case when nullif(trim(b."tank_id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(b."tank_id"::text), '')::integer else null::integer end as tank_id,
    substance_id as substance_id,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case
    when a."CompartmentSubstanceCASNO" = NA then null else 'a."CompartmentSubstanceCASNO"'
    end as substance_casno
from as_ust."compartment" a
    left join as_ust."erg_tank_id" b on nullif(trim(a."FacilityID"::text), '') = nullif(trim(b."facility_id"::text), '') 
    left join as_ust.v_substance_xwalk c on a."CompartmentSubstanceStored" = c.organization_value
where substance_id is not null and not exists
    (select 1 from as_ust.erg_unregulated_facilities unreg_fac
    where nullif(trim(a."FacilityID"::text), '') = unreg_fac.facility_id)
and not exists
    (select 1 from as_ust.erg_unregulated_tanks unreg_tank
    where nullif(trim(a."FacilityID"::text), '') = unreg_tank.facility_id and case when nullif(trim(a."tank_id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."tank_id"::text), '')::integer else null::integer end = unreg_tank.tank_id)
and exists
    (select 1 from as_ust.v_ust_facility parent
    where parent.facility_id = nullif(trim(a."FacilityID"::text), ''))
and coalesce(c.exclude_from_query, 'N') <> 'Y'

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
----------------------------------------------------------------------------------------------------------

-- WARNINGS
-- Overriding query_logic for ust_compartment.spill_bucket_installed with standardized recipe SQL.
-- Overriding query_logic for ust_compartment.tank_automatic_tank_gauging_release_detection with standardized recipe SQL.
-- Overriding query_logic for ust_compartment.tank_manual_tank_gauging with standardized recipe SQL.
-- Overriding query_logic for ust_compartment.tank_tightness_testing with standardized recipe SQL.
-- Overriding query_logic for ust_compartment.tank_inventory_control with standardized recipe SQL.
-- Overriding query_logic for ust_compartment.tank_other_release_detection with standardized recipe SQL.
-- Generated SQL failed validation for ust_compartment: syntax error at or near "prevention"
LINE 28: ...a."OverfillPreventionNotRequired" = No - overfill prevention...
                                                              ^


create or replace view as_ust.v_ust_compartment as
select distinct
    nullif(trim(a."FacilityID"::text), '')::character varying(50) as facility_id,
    case when nullif(trim(b."tank_id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(b."tank_id"::text), '')::integer else null::integer end as tank_id,
    c."compartment_id"::integer as compartment_id,
    a."CompartmentID"::character varying(50) as compartment_name,
    compartment_status_id as compartment_status_id,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case
    when a."CompartmentCapacityGallons" = NA then null else 'a."CompartmentCapacityGallons"'
    end as compartment_capacity_gallons,
    a."OverfillPreventionBallFloatValve"::character varying(7) as overfill_prevention_ball_float_valve,
    a."OverfillPreventionFlowShutoffDevice"::character varying(7) as overfill_prevention_flow_shutoff_device,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case
    when a."OverfillPreventionHighLevelAlarm" = Y then 'Yes' when a."OverfillPreventionHighLevelAlarm" = N then 'No' else null
    end as overfill_prevention_high_level_alarm,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case
    when a."OverfillPreventionOther" = NA then null else 'a."OverfillPreventionOther"'
    end as overfill_prevention_other,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case
    when a."OverfillPreventionUnknown" = NA then null else 'a."OverfillPreventionUnknown"'
    end as overfill_prevention_unknown,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case
    when a."OverfillPreventionNotRequired" = No - overfill prevention is required then 'No' else null
    end as overfill_prevention_not_required,
    case when lower(nullif(trim(a."SpillBucketInstalled"::text), '')) in ('true', 't', 'yes', 'y', '1', '1.0') then 'Yes'::text when lower(nullif(trim(a."SpillBucketInstalled"::text), '')) in ('false', 'f', 'no', 'n', '0', '0.0') then 'No'::text else null::text end as spill_bucket_installed,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case
    when a."ConcreteBermInstalled" = Y then 'Yes' when a."ConcreteBermInstalled" = N the No else null
    end as concrete_berm_installed,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case
    when a."SpillPreventionOther" = NA then null else 'a."SpillPreventionOther"'
    end as spill_prevention_other,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case
    when a."SpillPreventionNotRequired" = No - spill prevention is required then 'No' else 'a."SpillPreventionNotRequired"'
    end as spill_prevention_not_required,
    case when lower(nullif(trim(a."TankAutomaticTankGaugingReleaseDetection"::text), '')) in ('in-tank monitor', 'automatic tank gauging') then 'Yes'::text else null::text end as tank_automatic_tank_gauging_release_detection,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case
    when a."AutomaticTankGaugingContinuousLeakDetection" = Y then 'Yes' when a."AutomaticTankGaugingContinuousLeakDetection" = N then 'No'
    else null
    end as automatic_tank_gauging_continuous_leak_detection,
    case when lower(nullif(trim(a."TankManualTankGauging"::text), '')) in ('manual gauging') then 'Yes'::text else null::text end as tank_manual_tank_gauging,
    case when lower(nullif(trim(a."TankTightnessTesting"::text), '')) in ('tightness testing', 'tanktightnesstesting') then 'Yes'::text else null::text end as tank_tightness_testing,
    case when lower(nullif(trim(a."TankInventoryControl"::text), '')) in ('inventory control') then 'Yes'::text else null::text end as tank_inventory_control,
    case when lower(nullif(trim(a."TankOtherReleaseDetection"::text), '')) in ('other') then 'Yes'::text else null::text end as tank_other_release_detection
from as_ust."compartment" a
    left join as_ust."erg_tank_id" b on nullif(trim(a."FacilityID"::text), '') = nullif(trim(b."facility_id"::text), '') 
    left join as_ust."erg_compartment_id" c on a."TankName" = c."tank_name" and a."CompartmentName" = c."compartment_name" 
    left join as_ust.v_compartment_status_xwalk d on a."CompartmentStatus" = d.organization_value
where not exists
    (select 1 from as_ust.erg_unregulated_facilities unreg_fac
    where nullif(trim(a."FacilityID"::text), '') = unreg_fac.facility_id)
and not exists
    (select 1 from as_ust.erg_unregulated_tanks unreg_tank
    where nullif(trim(a."FacilityID"::text), '') = unreg_tank.facility_id and case when nullif(trim(a."tank_id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."tank_id"::text), '')::integer else null::integer end = unreg_tank.tank_id)
and exists
    (select 1 from as_ust.v_ust_facility parent
    where parent.facility_id = nullif(trim(a."FacilityID"::text), ''))
and coalesce(d.exclude_from_query, 'N') <> 'Y'

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
----------------------------------------------------------------------------------------------------------

-- WARNINGS
-- Overriding query_logic for ust_piping.piping_material_frp with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_material_gal_steel with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_material_stainless_steel with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_material_steel with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_material_copper with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_material_flex with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_material_no_piping with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_material_unknown with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_corrosion_protection_sacrificial_anode with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_line_leak_detector with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_line_test_annual with standardized recipe SQL.
-- Overriding query_logic for ust_piping.piping_release_detection_other with standardized recipe SQL.
-- Overriding query_logic for ust_piping.pipe_secondary_containment_other with standardized recipe SQL.
-- Overriding query_logic for ust_piping.pipe_secondary_containment_unknown with standardized recipe SQL.
-- Generated SQL failed validation for ust_piping: syntax error at or near "a"
LINE 36:  case when whem a."PipingCorrosionProtectionCathodicNotRequi...
                         ^


create or replace view as_ust.v_ust_piping as
select distinct
    nullif(trim(a."FacilityID"::text), '')::character varying(50) as facility_id,
    case when nullif(trim(b."tank_id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(b."tank_id"::text), '')::integer else null::integer end as tank_id,
    case when nullif(trim(c."compartment_id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(c."compartment_id"::text), '')::integer else null::integer end as compartment_id,
    a."PipingID"::character varying(50) as piping_id,
    piping_style_id as piping_style_id,
    a."SafeSuction"::character varying(7) as safe_suction,
    a."AmericanSuction"::character varying(7) as american_suction,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case
    when a."HighPressureOrBulkPiping" = N then 'No' when a."HighPressureOrBulkPiping" = Y then 'Yes' else null
    end as high_pressure_or_bulk_piping,
    case when lower(nullif(trim(a."PipingMaterialFRP"::text), '')) like '%fiberglass%' then 'Yes'::text else null::text end as piping_material_frp,
    case when lower(nullif(trim(a."PipingMaterialGalSteel"::text), '')) in ('galvanized steel', 'steel - bare/galv') then 'Yes'::text else null::text end as piping_material_gal_steel,
    case when lower(nullif(trim(a."PipingMaterialStainlessSteel"::text), '')) in ('stainless steel', 'pipingmaterialstainlesssteel') then 'Yes'::text else null::text end as piping_material_stainless_steel,
    case when lower(nullif(trim(a."PipingMaterialSteel"::text), '')) in ('black steel', 'cath. protection', 'cath. steel', 'coated steel', 'steel', 'steel/aboveground', 'steel/cont', 'bare steel', 'steel isolated') then 'Yes'::text else null::text end as piping_material_steel,
    case when lower(nullif(trim(a."PipingMaterialCopper"::text), '')) in ('copper', 'copper -corr. prot.', 'copper isolated') then 'Yes'::text else null::text end as piping_material_copper,
    case when lower(nullif(trim(a."PipingMaterialFlex"::text), '')) in ('dw ameron', 'dw apt', 'dw environ', 'dw flex', 'dw marinaflex', 'dw opw', 'dw poly', 'sw ameron', 'sw apt', 'sw flex', 'total containment', 'flexible', 'flexible plastic', 'flex piping') then 'Yes'::text else null::text end as piping_material_flex,
    case when lower(nullif(trim(a."PipingMaterialNoPiping"::text), '')) in ('none', 'not applicable', 'pipingmaterialnopiping', 'no piping') then 'Yes'::text else null::text end as piping_material_no_piping,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case
    when a."PipingMaterialOther" = NA then null else 'a."PipingMaterialOther"'
    end as piping_material_other,
    case when lower(nullif(trim(a."PipingMaterialUnknown"::text), '')) in ('unknown') then 'Yes'::text else null::text end as piping_material_unknown,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case
    when a."PipingFlexConnector" = N then 'No' when a."PipingFlexConnector" = Y then 'Yes' else null
    end as piping_flex_connector,
    case when lower(nullif(trim(a."PipingCorrosionProtectionSacrificialAnode"::text), '')) in ('cath. protection', 'cath. steel') then 'Yes'::text else null::text end as piping_corrosion_protection_sacrificial_anode,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case
    when a."PipingCorrosionProtectionImpressedCurrent" = NA then null else 'a."PipingCorrosionProtectionImpressedCurrent"'
    end as piping_corrosion_protection_impressed_current,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case when whem a."PipingCorrosionProtectionCathodicNotRequired" = Y then 'Yes' when a."PipingCorrosionProtectionCathodicNotRequired" = N then 'No' else null then 'Yes'::character varying(7) else null end as piping_corrosion_protection_cathodic_not_required,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case
    when a."PipingCorrosionProtectionOther" = NA then null else 'a."PipingCorrosionProtectionOther"'
    end as piping_corrosion_protection_other,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case
    when a."PipingCorrosionProtectionUnknown" = Y then 'Yes' when a."PipingCorrosionProtectionUnknown" = N then 'No' when a."PipingCorrosionProtectionUnknown" = NA then null
    else null
    end as piping_corrosion_protection_unknown,
    case when lower(nullif(trim(a."PipingLineLeakDetector"::text), '')) in ('campo/miller lld', 'electronic lld', 'incon lld', 'mechanical lld', 'ppm 4000') then 'Yes'::text else null::text end as piping_line_leak_detector,
    case when lower(nullif(trim(a."PipingLineTestAnnual"::text), '')) in ('tightness testing') then 'Yes'::text else null::text end as piping_line_test_annual,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case
    when a."PipingLineTest3yr" = Y then 'Yes' when a."PipingLineTest3yr" = N then 'No' else null
    end as piping_line_test3yr,
    case when lower(nullif(trim(a."PipingReleaseDetectionOther"::text), '')) in ('double walled') then 'Yes'::text else null::text end as piping_release_detection_other,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case
    when a."PipingSubpartKLineTest" = NA then null else 'a."PipingSubpartKLineTest"'
    end as piping_subpart_k_line_test,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case
    when a."PipingSubpartKOther" = NA then null else 'a."PipingSubpartKOther"'
    end as piping_subpart_k_other,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case
    when a."PipeTankTopSump" = Y then 'Yes' when a."PipeTankTopSump" = N then 'No' else null
    end as pipe_tank_top_sump,
    piping_wall_type_id as piping_wall_type_id,
    -- AUTO-COMPILED FROM QUERY_LOGIC
    case
    when a."PipeTrenchLiner" = NA then null else 'a."PipeTrenchLiner"'
    end as pipe_trench_liner,
    case when lower(nullif(trim(a."PipeSecondaryContainmentOther"::text), '')) in ('secondary containment', 'concrete containment') then 'Yes'::text else null::text end as pipe_secondary_containment_other,
    case when lower(nullif(trim(a."PipeSecondaryContainmentUnknown"::text), '')) in ('unknown') then 'Yes'::text else null::text end as pipe_secondary_containment_unknown
from as_ust."piping" a
    left join as_ust."erg_tank_id" b on nullif(trim(a."FacilityID"::text), '') = nullif(trim(b."facility_id"::text), '') 
    left join as_ust."erg_compartment_id" c on a."CompartmentName" = c."compartment_name" 
    left join as_ust.v_piping_style_xwalk d on a."PipingStyle" = d.organization_value
    left join as_ust.v_piping_wall_type_xwalk e on a."PipingWallType" = e.organization_value
where not exists
    (select 1 from as_ust.erg_unregulated_facilities unreg_fac
    where nullif(trim(a."FacilityID"::text), '') = unreg_fac.facility_id)
and not exists
    (select 1 from as_ust.erg_unregulated_tanks unreg_tank
    where nullif(trim(a."FacilityID"::text), '') = unreg_tank.facility_id and case when nullif(trim(a."tank_id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."tank_id"::text), '')::integer else null::integer end = unreg_tank.tank_id)
and exists
    (select 1 from as_ust.v_ust_facility parent
    where parent.facility_id = nullif(trim(a."FacilityID"::text), ''))
and coalesce(d.exclude_from_query, 'N') <> 'Y'
and coalesce(e.exclude_from_query, 'N') <> 'Y'

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
----------------------------------------------------------------------------------------------------------

-- WARNINGS
-- Overriding query_logic for ust_compartment_dispenser.dispenser_udc with standardized recipe SQL.
-- Skipping SQL validation for ust_compartment_dispenser because manual placeholders remain.

create or replace view as_ust.v_ust_compartment_dispenser as
select distinct
    nullif(trim(a."FacilityID"::text), '')::character varying(50) as facility_id,
    case when nullif(trim(b."tank_id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(b."tank_id"::text), '')::integer else null::integer end as tank_id,
    case when nullif(trim(c."compartment_id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(c."compartment_id"::text), '')::integer else null::integer end as compartment_id,
    ????::character varying(50) as dispenser_id,
    case when lower(nullif(trim(a."DispenserUDC"::text), '')) in ('true', 't', 'yes', 'y', '1', '1.0') then 'Yes'::text when lower(nullif(trim(a."DispenserUDC"::text), '')) in ('false', 'f', 'no', 'n', '0', '0.0') then 'No'::text else null::text end as dispenser_udc
from as_ust."compartment" a
    left join as_ust."erg_tank_id" b on nullif(trim(a."FacilityID"::text), '') = nullif(trim(b."facility_id"::text), '') 
    left join as_ust."erg_compartment_id" c on a."CompartmentName" = c."compartment_name" 
where not exists
    (select 1 from as_ust.erg_unregulated_facilities unreg_fac
    where nullif(trim(a."FacilityID"::text), '') = unreg_fac.facility_id)
and not exists
    (select 1 from as_ust.erg_unregulated_tanks unreg_tank
    where nullif(trim(a."FacilityID"::text), '') = unreg_tank.facility_id and case when nullif(trim(a."tank_id"::text), '') ~ '^[+-]?\d+$' then nullif(trim(a."tank_id"::text), '')::integer else null::integer end = unreg_tank.tank_id)
and exists
    (select 1 from as_ust.v_ust_facility parent
    where parent.facility_id = nullif(trim(a."FacilityID"::text), ''))

-- ADD ADDITIONAL SQL HERE IF NECESSARY
;
