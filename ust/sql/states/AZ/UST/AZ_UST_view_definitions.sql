------------------------------------------------------------------------------------------------------------------------------------------------------------------------



create or replace view az_ust.v_ust_facility as
 SELECT DISTINCT (a."FacilityID")::character varying(50) AS facility_id,
    (a."FacilityName")::character varying(100) AS facility_name,
    d.owner_type_id,
    c.facility_type_id AS facility_type1,
    (a."FacilityAddress1")::character varying(100) AS facility_address1,
    (a."FacilityCity")::character varying(100) AS facility_city,
    (a."FacilityCounty")::character varying(100) AS facility_county,
    (a."FacilityZipCode")::character varying(10) AS facility_zip_code,
    e.facility_state,
    (a."FacilityEPARegion")::integer AS facility_epa_region,
    (a."FacilityTribalSite")::character varying(3) AS facility_tribal_site,
    a."FacilityLatitude" AS facility_latitude,
    a."FacilityLongitude" AS facility_longitude,
    (a."FacilityOwnerCompanyName")::character varying(100) AS facility_owner_company_name,
    (a."FacilityOperatorCompanyName")::character varying(100) AS facility_operator_company_name,
    (a."FinancialResponsibilityObtained")::character varying(7) AS financial_responsibility_obtained,
    (a."FinancialResponsibilityBondRatingTest")::character varying(3) AS financial_responsibility_bond_rating_test,
    (a."FinancialResponsibilityCommercialInsurance")::character varying(3) AS financial_responsibility_commercial_insurance,
    (a."FinancialResponsibilityGuarantee")::character varying(3) AS financial_responsibility_guarantee,
    (a."FinancialResponsibilityLetterOfCredit")::character varying(3) AS financial_responsibility_letter_of_credit,
    (a."FinancialResponsibilityLocalGovernmentFinancialTest")::character varying(3) AS financial_responsibility_local_government_financial_test,
    (a."FinancialResponsibilityRiskRetentionGroup")::character varying(3) AS financial_responsibility_risk_retention_group,
    (a."FinancialResponsibilitySelfInsuranceFinancialTest")::character varying(3) AS financial_responsibility_self_insurance_financial_test,
    (a."FinancialResponsibilityStateFund")::character varying(3) AS financial_responsibility_state_fund,
    (a."FinancialResponsibilitySuretyBond")::character varying(3) AS financial_responsibility_surety_bond,
    (a."FinancialResponsibilityTrustFund")::character varying(3) AS financial_responsibility_trust_fund,
    (a."FinancialResponsibilityOtherMethod")::character varying(500) AS financial_responsibility_other_method
   FROM ((((az_ust.ust_facility a
     LEFT JOIN az_ust.erg_facility_type_mapping b ON ((a."FacilityID" = b."FacilityID")))
     LEFT JOIN facility_types c ON (((b.epa_value)::text = (c.facility_type)::text)))
     LEFT JOIN az_ust.v_owner_type_xwalk d ON ((a."OwnerType" = (d.organization_value)::text)))
     LEFT JOIN az_ust.v_state_xwalk e ON ((a."FacilityState" = (e.organization_value)::text)))
 where a."FacilityID"::varchar(50) not in (select facility_id from az_ust.erg_unregulated_facilities);



create or replace view az_ust.v_ust_tank as
 SELECT DISTINCT (a."FacilityID")::character varying(50) AS facility_id,
    (a."TankName")::integer AS tank_id,
    (a."TankName")::character varying(50) AS tank_name,
    b.tank_location_id,
    e.tank_status_id,
    (a."FederallyRegulated")::character varying(7) AS federally_regulated,
    (a."FieldConstructed")::character varying(7) AS field_constructed,
    (a."EmergencyGenerator")::character varying(7) AS emergency_generator,
    (a."AirportHydrantSystem")::character varying(7) AS airport_hydrant_system,
    (a."TankClosureDate")::date AS tank_closure_date,
    (a."TankInstallationDate")::date AS tank_installation_date,
    (a."CompartmentalizedUST")::character varying(7) AS compartmentalized_ust,
    (a."NumberOfCompartments")::integer AS number_of_compartments,
    c.tank_material_description_id,
    (a."TankCorrosionProtectionSacrificialAnode")::character varying(7) AS tank_corrosion_protection_sacrificial_anode,
    (a."TankCorrosionProtectionImpressedCurrent")::character varying(7) AS tank_corrosion_protection_impressed_current,
    (a."TankCorrosionProtectionInteriorLining")::character varying(7) AS tank_corrosion_protection_interior_lining,
    d.tank_secondary_containment_id
   FROM ((((az_ust.ust_tank a
     LEFT JOIN az_ust.v_tank_location_xwalk b ON ((a."TankLocation" = (b.organization_value)::text)))
     LEFT JOIN az_ust.v_tank_material_description_xwalk c ON ((a."TankMaterialDescription" = (c.organization_value)::text)))
     LEFT JOIN az_ust.v_tank_secondary_containment_xwalk d ON ((a."TankSecondaryContainment" = (d.organization_value)::text)))
     LEFT JOIN az_ust.v_tank_status_xwalk e ON ((a."TankStatus" = (e.organization_value)::text)))
 where not exists
	(select 1 from az_ust.erg_unregulated_tanks unreg
	where a."FacilityID"::varchar(50) = unreg.facility_id and a."TankName"::int = unreg.tank_id);


select * into az_ust.erg_v_ust_tank from az_ust.v_ust_tank;

select * from az_ust.erg_v_ust_tank;

alter table az_ust.erg_v_ust_tank add constraint erg_v_ust_tank_pk primary key (facility_id, tank_id);

select * from az_ust.erg_compartment_id ;

alter table az_ust.erg_compartment_id add constraint erg_compartment_id_pk primary key (facility_id, tank_id, compartment_id);

create index erg_compartment_id_idx on az_ust.erg_compartment_id (facility_id, tank_name, compartment_name);

drop view az_ust.v_ust_tank_substance;
create or replace view az_ust.v_ust_tank_substance as
 SELECT DISTINCT (a."FacilityID")::character varying(50) AS facility_id,
    (a."TankName")::integer AS tank_id,
    c.substance_id
   FROM ((az_ust.ust_compartment a
     JOIN az_ust.erg_compartment_id b ON (((a."FacilityID" = (b.facility_id)::text) AND ((a."TankName")::text = (b.tank_name)::text) AND (a."CompartmentName" = (b.compartment_name)::text))))
     LEFT JOIN az_ust.v_substance_xwalk c ON ((a."CompartmentSubstanceStored" = (c.organization_value)::text)))
 where c.substance_id is not null 
 and exists (select 1 from az_ust.erg_v_ust_tank x where a."FacilityID" = x.facility_id and a."TankName" = x.tank_id)
 and  not exists
	(select 1 from az_ust.erg_unregulated_tanks unreg
	where a."FacilityID"::varchar(50) = unreg.facility_id and a."TankName"::int = unreg.tank_id);



select * from az_ust.ust_compartment where "FacilityID" = '0-000104'

drop view az_ust.v_ust_compartment;

create or replace view az_ust.v_ust_compartment as
 SELECT DISTINCT (b."FacilityID")::character varying(50) AS facility_id,
    (b."TankName")::integer AS tank_id,  a.compartment_id,
    (b."CompartmentName")::character varying(50) AS compartment_name,
    c.compartment_status_id,
    (b."CompartmentCapacityGallons")::integer AS compartment_capacity_gallons,
    (b."OverfillPreventionBallFloatValve")::character varying(7) AS overfill_prevention_ball_float_valve,
    (b."OverfillPreventionFlowShutoffDevice")::character varying(7) AS overfill_prevention_flow_shutoff_device,
    (b."OverfillPreventionHighLevelAlarm")::character varying(7) AS overfill_prevention_high_level_alarm,
    (b."SpillBucketInstalled")::character varying(3) AS spill_bucket_installed,
    (b."ConcreteBermInstalled")::character varying(3) AS concrete_berm_installed,
    (b."TankInterstitialMonitoring")::character varying(7) AS tank_interstitial_monitoring,
    (b."TankAutomaticTankGaugingReleaseDetection")::character varying(7) AS tank_automatic_tank_gauging_release_detection,
    (b."TankManualTankGauging")::character varying(7) AS tank_manual_tank_gauging,
    (b."TankStatisticalInventoryReconciliation")::character varying(7) AS tank_statistical_inventory_reconciliation,
    (b."TankTightnessTesting")::character varying(7) AS tank_tightness_testing,
    (b."TankInventoryControl")::character varying(7) AS tank_inventory_control,
    (b."TankGroundwaterMonitoring")::character varying(7) AS tank_groundwater_monitoring,
    (b."TankVaporMonitoring")::character varying(7) AS tank_vapor_monitoring
   FROM az_ust.erg_compartment_id a
     LEFT JOIN az_ust.ust_compartment b ON b."FacilityID" = a.facility_id::text AND b."TankName"::text = a.tank_name::text
     	and a.compartment_name = b."CompartmentName"
     LEFT JOIN az_ust.v_compartment_status_xwalk c ON b."CompartmentStatus" = c.organization_value::text
 where
 exists (select 1 from az_ust.v_ust_tank x where a."FacilityID" = x.facility_id and a."TankName" = x.tank_id)
 and not exists
	(select 1 from az_ust.erg_unregulated_tanks unreg
	where b."FacilityID"::varchar(50) = unreg.facility_id and b."TankID"::int = unreg.tank_id);


select * from az_ust.erg_compartment_id where facility_id = '0-000066' and tank_id = 8; 
COMPARTMENT A	9301
COMPARTMENT B	29319

drop view  az_ust.v_ust_compartment_substance
create or replace view az_ust.v_ust_compartment_substance as
 SELECT a."FacilityID" AS facility_id,
    (a."TankName")::integer AS tank_id,
    b.compartment_id,
    c.substance_id
   FROM ((az_ust.ust_compartment a
     JOIN az_ust.erg_compartment_id b ON (((a."FacilityID" = (b.facility_id)::text) AND ((a."TankName")::text = (b.tank_name)::text) AND (a."CompartmentName" = (b.compartment_name)::text))))
     LEFT JOIN az_ust.v_substance_xwalk c ON ((a."CompartmentSubstanceStored" = (c.organization_value)::text)))
 where c.substance_id is not null 
and  exists (select 1 from az_ust.v_ust_tank x where a."FacilityID" = x.facility_id and a."TankName" = x.tank_id)
 and not exists
	(select 1 from az_ust.erg_unregulated_tanks unreg
	where a."FacilityID"::varchar(50) = unreg.facility_id and b."tank_id"::int = unreg.tank_id);


drop view  az_ust.v_ust_piping

create or replace view az_ust.v_ust_piping as
 SELECT DISTINCT (a."FacilityID")::character varying(50) AS facility_id,
    (a."TankName")::integer AS tank_id,
    d.compartment_id,
    (d.piping_id)::character varying(50) AS piping_id,
    b.piping_style_id,
    (a."PipingMaterialFRP")::character varying(3) AS piping_material_frp,
    (a."PipingMaterialSteel")::character varying(3) AS piping_material_steel,
    (a."PipingMaterialCopper")::character varying(3) AS piping_material_copper,
    (a."PipingMaterialFlex")::character varying(3) AS piping_material_flex,
    (a."PipingMaterialNoPiping")::character varying(3) AS piping_material_no_piping,
    (a."PipingMaterialOther")::character varying(3) AS piping_material_other,
    (a."PipingMaterialUnknown")::character varying(3) AS piping_material_unknown,
    (a."PipingCorrosionProtectionSacrificialAnode")::character varying(7) AS piping_corrosion_protection_sacrificial_anode,
    (a."PipingCorrosionProtectionImpressedCurrent")::character varying(7) AS piping_corrosion_protection_impressed_current,
    (a."PipingLineLeakDetector")::character varying(7) AS piping_line_leak_detector,
    (a."PipingLineTestAnnual")::character varying(7) AS piping_line_test_annual,
    (a."PipingGroundwaterMonitoring")::character varying(7) AS piping_groundwater_monitoring,
    (a."PipingVaporMonitoring")::character varying(7) AS piping_vapor_monitoring,
    (a."PipingInterstitialMonitoring")::character varying(7) AS piping_interstitial_monitoring,
    (a."PipingStatisticalInventoryReconciliation")::character varying(7) AS piping_statistical_inventory_reconciliation,
    (a."PipingReleaseDetectionOther")::character varying(7) AS piping_release_detection_other,
    c.piping_wall_type_id
   FROM (((az_ust.ust_piping a
     JOIN az_ust.erg_piping_id d ON (((a."FacilityID" = (d.facility_id)::text) AND ((a."TankName")::text = (d.tank_name)::text) AND (a."CompartmentName" = (d.compartment_name)::text))))
     LEFT JOIN az_ust.v_piping_style_xwalk b ON ((a."PipingStyle" = (b.organization_value)::text)))
     LEFT JOIN az_ust.v_piping_wall_type_xwalk c ON ((a."PipingWallType" = (c.organization_value)::text)))
 where 
  exists (select 1 from az_ust.v_ust_tank x where a."FacilityID" = x.facility_id and a."TankName" = x.tank_id)
and not exists 
 (select 1 from az_ust.erg_unregulated_tanks unreg
	where a."FacilityID"::varchar(50) = unreg.facility_id and a."TankID"::int = unreg.tank_id);
	


Unmapped elements in v_ust_tank_substance	tank_id
Unmapped elements in v_ust_compartment_substance	substance_id


select distinct epa_column_name, organization_table_name, organization_column_name, column_sort_order, ust_element_mapping_id 
from v_ust_element_mapping 
where ust_control_id = 14 and epa_table_name = 'ust_tank_substance'
order by column_sort_order



insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (14,'ust_tank_substance','tank_id','ust_compartment','tank_name',null,null);

update ust_element_mapping set organization_column_name = 'TankName' where ust_element_mapping_id = 3348;


insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic)
values (14,'ust_compartment_substance','facility_id','ust_compartment','FacilityID',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (14,'ust_compartment_substance','tank_id','ust_compartment','TankName',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (14,'ust_compartment_substance','tank_name','ust_compartment','TankName',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (14,'ust_compartment_substance','compartment_id','erg_compartment_id','compartment_id',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (14,'ust_compartment_substance','compartment_name','ust_compartment','CompartmentName',null,null);
--NOTE: substance_id is not in EPA table public.ust_compartment_substance, however, this element must be mapped if you are mapping this table, 
--and the mapped column MUST included in the v_ust_compartment_substance view in the state schema as a not null column. 
--Additionally, the facility/tank/substance combination MUST also exist in the v_ust_tank_substance view, which is a parent of this table. 
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (14,'ust_compartment_substance','substance_id','ust_compartment','CompartmentSubstanceStored',null,null);
