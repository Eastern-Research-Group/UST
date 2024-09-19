SELECT * FROM ust_control where ust_control_id = 11;

update public.ust_control 
set comments = 'State reports number of compartments per tank but only reports at tank level. Some tanks have multiple statuses, substances, etc. which we assume are due to multiple tanks. Multiple values are delimited by a newline.'
where ust_control_id = 11;

update public.ust_control set date_processed = '2024-06-21'
where ust_control_id = 11;

select column_name from information_schema.columns 
where table_name = 'ust_control' and table_schema = 'public'
order by ordinal_position ;

create view v_ust_control_summary as 
select ust_control_id, 1 sort_order, 'organization_id' as summary_item, organization_id as summary_detail from public.ust_control 
union all 
select ust_control_id, 2 sort_order, 'date_received' as summary_item, cast(date_received as varchar) as summary_detail from public.ust_control 
union all 
select ust_control_id, 3 sort_order, 'date_processed' as summary_item, cast(date_processed as varchar) as summary_detail from public.ust_control 
union all 
select ust_control_id, 4 sort_order, 'data_source' as summary_item, data_source as summary_detail from public.ust_control 
union all 
select ust_control_id, 5 sort_order, 'comments' as summary_item, comments as summary_detail from public.ust_control 


create view v_release_control_summary as 
select release_control_id, 1 sort_order, 'organization_id' as summary_item, organization_id as summary_detail from public.release_control 
union all 
select release_control_id, 2 sort_order, 'date_received' as summary_item, cast(date_received as varchar) as summary_detail from public.release_control 
union all 
select release_control_id, 3 sort_order, 'date_processed' as summary_item, cast(date_processed as varchar) as summary_detail from public.release_control 
union all 
select release_control_id, 4 sort_order, 'data_source' as summary_item, data_source as summary_detail from public.release_control 
union all 
select release_control_id, 5 sort_order, 'comments' as summary_item, comments as summary_detail from public.release_control 




SELECT count(*)







create table facility_dispenser (
	facility_dispenser_id integer not null generated always as identity, 
	ust_facility_id integer not null, 
	dispenser_id varchar(50) not null, 
	dispenser_udc varchar(7), 
	dispenser_udc_wall_type_id integer	
);
alter table facility_dispenser add constraint facility_dispenser_pk 
	primary key (facility_dispenser_id);
alter table facility_dispenser add constraint facility_dispenser_fac_fk 
	foreign key (ust_facility_id)
	references ust_facility(ust_facility_id);
alter table facility_dispenser add constraint facility_dispenser_dispwt_fk 
	foreign key (dispenser_udc_wall_type_id)
	references dispenser_udc_wall_types(dispenser_udc_wall_type_id);


create table tank_dispenser (
	tank_dispenser_id integer not null generated always as identity, 
	ust_tank_id integer not null, 
	dispenser_id varchar(50) not null, 
	dispenser_udc varchar(7), 
	dispenser_udc_wall_type_id integer	
);
alter table tank_dispenser add constraint tank_dispenser_pk 
	primary key (tank_dispenser_id);
alter table tank_dispenser add constraint tank_dispenser_tank_fk 
	foreign key (ust_tank_id)
	references ust_tank(ust_tank_id);
alter table tank_dispenser add constraint tank_dispenser_dispwt_fk 
	foreign key (dispenser_udc_wall_type_id)
	references dispenser_udc_wall_types(dispenser_udc_wall_type_id);

create table compartment_dispenser (
	compartment_dispenser_id integer not null generated always as identity, 
	ust_compartment_id integer not null, 
	dispenser_id varchar(50) not null, 
	dispenser_udc varchar(7), 
	dispenser_udc_wall_type_id integer	
);
alter table compartment_dispenser add constraint compartment_dispenser_pk 
	primary key (compartment_dispenser_id);
alter table compartment_dispenser add constraint compartment_dispenser_tank_fk 
	foreign key (ust_compartment_id)
	references ust_compartment(ust_compartment_id);
alter table compartment_dispenser add constraint tank_dispenser_dispwt_fk 
	foreign key (dispenser_udc_wall_type_id)
	references dispenser_udc_wall_types(dispenser_udc_wall_type_id);

alter table facility_dispenser rename to ust_facility_dispenser;
alter table tank_dispenser rename to ust_tank_dispenser;
alter table compartment_dispenser rename to ust_compartment_dispenser;


select * from information_schema.columns 
where table_schema = 'public' and column_name like 'dispenser%'
order by table_name, ordinal_position ;

dispenser_id	26		YES	character varying	50
dispenser_udc	27		YES	character varying	7
dispenser_udc_wall_type_id	28		YES	integer	

select * from ust_elements where element_name like 'Disp%'
123	DispenserID
124	DispenserUDC
125	DispenserUDCWallType

select * from ust_elements_tables 
where element_id between 123 and 125;

select * from ust_elements_tables
where table_name = 'ust_compartment' order by sort_order;

insert into ust_elements_tables (element_id, table_name, sort_order)
values (1, 'ust_facility_dispenser', 1);
insert into ust_elements_tables (element_id, table_name, sort_order)
values (123, 'ust_facility_dispenser', 2);
insert into ust_elements_tables (element_id, table_name, sort_order)
values (124, 'ust_facility_dispenser', 3);
insert into ust_elements_tables (element_id, table_name, sort_order)
values (125, 'ust_facility_dispenser', 4);

insert into ust_elements_tables (element_id, table_name, sort_order)
values (1, 'ust_tank_dispenser', 1);
insert into ust_elements_tables (element_id, table_name, sort_order)
values (35, 'ust_tank_dispenser', 2);
insert into ust_elements_tables (element_id, table_name, sort_order)
values (36, 'ust_tank_dispenser', 3);
insert into ust_elements_tables (element_id, table_name, sort_order)
values (123, 'ust_tank_dispenser', 4);
insert into ust_elements_tables (element_id, table_name, sort_order)
values (124, 'ust_tank_dispenser', 5);
insert into ust_elements_tables (element_id, table_name, sort_order)
values (125, 'ust_tank_dispenser', 6);

insert into ust_elements_tables (element_id, table_name, sort_order)
values (1, 'ust_compartment_dispenser', 1);
insert into ust_elements_tables (element_id, table_name, sort_order)
values (35, 'ust_compartment_dispenser', 2);
insert into ust_elements_tables (element_id, table_name, sort_order)
values (36, 'ust_compartment_dispenser', 3);
insert into ust_elements_tables (element_id, table_name, sort_order)
values (58, 'ust_compartment_dispenser', 4);
insert into ust_elements_tables (element_id, table_name, sort_order)
values (59, 'ust_compartment_dispenser', 5);
insert into ust_elements_tables (element_id, table_name, sort_order)
values (123, 'ust_compartment_dispenser', 6);
insert into ust_elements_tables (element_id, table_name, sort_order)
values (124, 'ust_compartment_dispenser', 7);
insert into ust_elements_tables (element_id, table_name, sort_order)
values (125, 'ust_compartment_dispenser', 8);




CREATE OR REPLACE VIEW public.v_ust_facility_dispenser
AS 
SELECT c.ust_control_id,
	c.facility_id AS "FacilityID",
	d.dispenser_id AS "DispenserID",
	d.dispenser_udc AS "DispenserUDC",
	dw.dispenser_udc_wall_type AS "DispenserUDCWallType"
FROM ust_facility c
	join ust_facility_dispenser d on c.ust_facility_id = d.ust_facility_id
	left join dispenser_udc_wall_types dw on d.dispenser_udc_wall_type_id = dw.dispenser_udc_wall_type_id;



CREATE OR REPLACE VIEW public.v_ust_tank_dispenser
AS 
SELECT c.ust_control_id,
    c.facility_id AS "FacilityID",
    b.tank_id AS "TankID",
    b.tank_name AS "TankName",
    d.dispenser_id AS "DispenserID",
    d.dispenser_udc AS "DispenserUDC",
    dw.dispenser_udc_wall_type AS "DispenserUDCWallType"
FROM ust_tank b
   	join ust_facility c on b.ust_facility_id = c.ust_facility_id 
	join ust_tank_dispenser d on b.ust_tank_id = d.ust_tank_id
	left join dispenser_udc_wall_types dw on d.dispenser_udc_wall_type_id = dw.dispenser_udc_wall_type_id;


CREATE OR REPLACE VIEW public.v_ust_compartment_dispenser
AS 
SELECT c.ust_control_id,
    c.facility_id AS "FacilityID",
    b.tank_id AS "TankID",
    b.tank_name AS "TankName",
    a.compartment_id AS "CompartmentID",
    a.compartment_name AS "CompartmentName",
    d.dispenser_id AS "DispenserID",
    d.dispenser_udc AS "DispenserUDC",
    dw.dispenser_udc_wall_type AS "DispenserUDCWallType"
FROM ust_compartment a 
	join ust_tank b on a.ust_tank_id = b.ust_tank_id 
   	join ust_facility c on b.ust_facility_id = c.ust_facility_id 
	join ust_tank_dispenser d on b.ust_tank_id = d.ust_tank_id
	left join dispenser_udc_wall_types dw on d.dispenser_udc_wall_type_id = dw.dispenser_udc_wall_type_id;


select * from ust_template_data_tables 

insert into ust_template_data_tables (table_name, view_name, template_tab_name, sort_order)
values ('ust_facility_dispenser', 'v_ust_facility_dispenser', 'Facility Dispenser', 7);
insert into ust_template_data_tables (table_name, view_name, template_tab_name, sort_order)
values ('ust_tank_dispenser', 'v_ust_tank_dispenser', 'Tank Dispenser', 8);
insert into ust_template_data_tables (table_name, view_name, template_tab_name, sort_order)
values ('ust_compartment_dispenser', 'v_ust_compartment_dispenser', 'Compartment Dispenser', 9);



CREATE OR REPLACE VIEW public.v_ust_table_population
AS SELECT x.ust_control_id,
    x.epa_table_name,
    x.epa_column_name,
    x.data_type,
    x.character_maximum_length,
    x.data_type_complete,
    x.organization_table_name,
    x.organization_column_name,
    x.programmer_comments,
    x.organization_join_table,
    x.organization_join_column,
    x.database_lookup_table,
    x.database_lookup_column,
    x.deagg_table_name,
    x.deagg_column_name,
    x.table_sort_order,
    x.column_sort_order
   FROM ( SELECT a.ust_control_id,
            a.epa_table_name,
            a.epa_column_name,
            e.data_type,
            e.character_maximum_length,
                CASE
                    WHEN e.character_maximum_length IS NOT NULL THEN ((('::'::text || e.data_type::text) || '('::text) || e.character_maximum_length) || ')'::text
                    ELSE '::'::text || e.data_type::text
                END AS data_type_complete,
            a.organization_table_name,
            a.organization_column_name,
            a.programmer_comments,
            a.organization_join_table,
            a.organization_join_column,
            b.database_lookup_table,
            b.database_lookup_column,
            a.deagg_table_name,
            a.deagg_column_name,
            d.sort_order AS table_sort_order,
            c.sort_order AS column_sort_order
           FROM ust_element_mapping a
             JOIN ust_elements b ON a.epa_column_name::text = b.database_column_name::text
             JOIN ust_elements_tables c ON b.element_id = c.element_id AND a.epa_table_name::text = c.table_name::text
             JOIN ust_template_data_tables d ON c.table_name::text = d.table_name::text
             JOIN information_schema.columns e ON a.epa_table_name::text = e.table_name::name AND a.epa_column_name::text = e.column_name::name AND e.table_schema::name = 'public'::name
        UNION ALL
         SELECT a.ust_control_id,
            z.epa_table_name,
            a.epa_column_name,
            e.data_type,
            e.character_maximum_length,
                CASE
                    WHEN e.character_maximum_length IS NOT NULL THEN ((('::'::text || e.data_type::text) || '('::text) || e.character_maximum_length) || ')'::text
                    ELSE '::'::text || e.data_type::text
                END AS data_type_complete,
            a.organization_table_name,
            a.organization_column_name,
            a.programmer_comments,
            a.organization_join_table,
            a.organization_join_column,
            b.database_lookup_table,
            b.database_lookup_column,
            a.deagg_table_name,
            a.deagg_column_name,
            d.sort_order AS table_sort_order,
            c.sort_order AS column_sort_order
           FROM ust_element_mapping a
             JOIN ust_elements b ON a.epa_column_name::text = b.database_column_name::text
             JOIN ust_elements_tables c ON b.element_id = c.element_id AND a.epa_table_name::text = c.table_name::text
             JOIN ust_template_data_tables d ON c.table_name::text = d.table_name::text
             JOIN information_schema.columns e ON a.epa_table_name::text = e.table_name::name AND a.epa_column_name::text = e.column_name::name AND e.table_schema::name = 'public'::name,
            ( SELECT 'ust_tank'::character varying(100) AS epa_table_name
                UNION ALL
                 SELECT 'ust_tank_substance'::character varying(100) AS epa_table_name
                UNION ALL
                 SELECT 'ust_compartment'::character varying(100) AS epa_table_name
                UNION ALL
                 SELECT 'ust_compartment_substance'::character varying(100) AS epa_table_name
                UNION ALL
                 SELECT 'ust_piping'::character varying(100) AS epa_table_name
                 union all select 'ust_facility_dispenser':: varchar(100) as epa_table_name
                 union all select 'ust_tank_dispenser':: varchar(100) as epa_table_name
                 union all select 'ust_compartment_dispenser':: varchar(100) as epa_table_name) z
          WHERE a.epa_column_name::text = 'ust_id'::text) x
  ORDER BY x.ust_control_id, x.epa_table_name, x.table_sort_order, x.column_sort_order;
  
 
 
 
 create or replace view "public"."v_ust_table_row_count" as
 SELECT v_ust_facility.ust_control_id,
    1 AS sort_order,
    'ust_facility'::text AS table_name,
    count(*) AS num_rows
   FROM v_ust_facility
  GROUP BY v_ust_facility.ust_control_id
UNION ALL
 SELECT v_ust_tank.ust_control_id,
    2 AS sort_order,
    'ust_tank'::text AS table_name,
    count(*) AS num_rows
   FROM v_ust_tank
  GROUP BY v_ust_tank.ust_control_id
UNION ALL
 SELECT v_ust_tank_substance.ust_control_id,
    3 AS sort_order,
    'ust_tank_substance'::text AS table_name,
    count(*) AS num_rows
    
    
    
    
    
    select * from information_schema.columns
where column_name like 'Disp%'

drop view v_ust_table_row_count ;

drop view v_ust_facility;
create or replace view "public"."v_ust_facility" as
 SELECT a.ust_control_id,
    a.facility_id AS "FacilityID",
    a.facility_name AS "FacilityName",
    ot.owner_type AS "OwnerType",
    ft.facility_type AS "FacilityType1",
    ft2.facility_type AS "FacilityType2",
    a.facility_address1 AS "FacilityAddress1",
    a.facility_address2 AS "FacilityAddress2",
    a.facility_city AS "FacilityCity",
    a.facility_county AS "FacilityCounty",
    a.facility_zip_code AS "FacilityZipCode",
    a.facility_state AS "FacilityState",
    a.facility_epa_region AS "FacilityEPARegion",
    a.facility_tribal_site AS "FacilityTribalSite",
    a.facility_tribe AS "FacilityTribe",
    a.facility_latitude AS "FacilityLatitude",
    a.facility_longitude AS "FacilityLongitude",
    cs.coordinate_source AS "FacilityCoordinateSource",
    a.facility_owner_company_name AS "FacilityOwnerCompanyName",
    a.facility_operator_company_name AS "FacilityOperatorCompanyName",
    a.financial_responsibility_obtained AS "FinancialResponsibilityObtained",
    a.financial_responsibility_bond_rating_test AS "FinancialResponsibilityBondRatingTest",
    a.financial_responsibility_commercial_insurance AS "FinancialResponsibilityCommercialInsurance",
    a.financial_responsibility_guarantee AS "FinancialResponsibilityGuarantee",
    a.financial_responsibility_letter_of_credit AS "FinancialResponsibilityLetterOfCredit",
    a.financial_responsibility_local_government_financial_test AS "FinancialResponsibilityLocalGovernmentFinancialTest",
    a.financial_responsibility_risk_retention_group AS "FinancialResponsibilityRiskRetentionGroup",
    a.financial_responsibility_self_insurance_financial_test AS "FinancialResponsibilitySelfInsuranceFinancialTest",
    a.financial_responsibility_state_fund AS "FinancialResponsibilityStateFund",
    a.financial_responsibility_surety_bond AS "FinancialResponsibilitySuretyBond",
    a.financial_responsibility_trust_fund AS "FinancialResponsibilityTrustFund",
    a.financial_responsibility_other_method AS "FinancialResponsibilityOtherMethod",
    a.ust_reported_release AS "USTReportedRelease",
    a.associated_ust_release_id AS "AssociatedUSTReleaseID"
   FROM ust_facility a
     LEFT JOIN owner_types ot ON a.owner_type_id = ot.owner_type_id
     LEFT JOIN coordinate_sources cs on a.coordinate_source_id = cs.coordinate_source_id
     LEFT JOIN facility_types ft ON a.facility_type1 = ft.facility_type_id
     LEFT JOIN facility_types ft2 ON a.facility_type2 = ft2.facility_type_id;

    
    drop view v_ust_tank
create or replace view "public"."v_ust_tank" as
 SELECT c.ust_control_id,
    c.facility_id AS "FacilityID",
    b.tank_id AS "TankID",
    b.tank_name AS "TankName",
    tl.tank_location AS "TankLocation",
    ts.tank_status AS "TankStatus",
    b.federally_regulated AS "FederallyRegulated",
    b.field_constructed AS "FieldConstructed",
    b.emergency_generator AS "EmergencyGenerator",
    b.airport_hydrant_system AS "AirportHydrantSystem",
    b.multiple_tanks AS "MultipleTanks",
    b.tank_closure_date AS "TankClosureDate",
    b.tank_installation_date AS "TankInstallationDate",
    b.compartmentalized_ust AS "CompartmentalizedUST",
    b.number_of_compartments AS "NumberOfCompartments",
    tm.tank_material_description AS "TankMaterialDescription",
    b.tank_corrosion_protection_sacrificial_anode AS "TankCorrosionProtectionSacrificialAnode",
    b.tank_corrosion_protection_impressed_current AS "TankCorrosionProtectionImpressedCurrent",
    b.tank_corrosion_protection_cathodic_not_required AS "TankCorrosionProtectionCathodicNotRequired",
    b.tank_corrosion_protection_interior_lining AS "TankCorrosionProtectionInteriorLining",
    b.tank_corrosion_protection_other AS "TankCorrosionProtectionOther",
    b.tank_corrosion_protection_unknown AS "TankCorrosionProtectionUnknown",
    tc.tank_secondary_containment AS "TankSecondaryContainment",
    ci.cert_of_installation AS "CertOfInstallation",
    b.cert_of_installation_other AS "CertOfInstallationOther"
   FROM ust_tank b
     JOIN ust_facility c ON b.ust_facility_id = c.ust_facility_id
     LEFT JOIN tank_locations tl ON b.tank_location_id = tl.tank_location_id
     LEFT JOIN tank_material_descriptions tm ON b.tank_material_description_id = tm.tank_material_description_id
     LEFT JOIN tank_secondary_containments tc ON b.tank_secondary_containment_id = tc.tank_secondary_containment_id
     LEFT JOIN tank_statuses ts ON b.tank_status_id = ts.tank_status_id
     LEFT JOIN cert_of_installations ci ON b.cert_of_installation_id = ci.cert_of_installation_id;
    
  
    drop view v_ust_compartment
create or replace view "public"."v_ust_compartment" as
 SELECT c.ust_control_id,
    c.facility_id AS "FacilityID",
    b.tank_id AS "TankID",
    b.tank_name AS "TankName",
    a.compartment_id AS "CompartmentID",
    a.compartment_name AS "CompartmentName",
    cs.compartment_status AS "CompartmentStatus",
    s.substance AS "CompartmentSubstanceStored",
    ts.substance_casno AS "CompartmentSubstanceCASNO",
    a.compartment_capacity_gallons AS "CompartmentCapacityGallons",
    a.overfill_prevention_ball_float_valve AS "OverfillPreventionBallFloatValve",
    a.overfill_prevention_flow_shutoff_device AS "OverfillPreventionFlowShutoffDevice",
    a.overfill_prevention_high_level_alarm AS "OverfillPreventionHighLevelAlarm",
    a.overfill_prevention_other AS "OverfillPreventionOther",
    a.overfill_prevention_unknown AS "OverfillPreventionUnknown",
    a.overfill_prevention_not_required AS "OverfillPreventionNotRequired",
    a.spill_bucket_installed AS "SpillBucketInstalled",
    a.concrete_berm_installed AS "ConcreteBermInstalled",
    a.spill_prevention_other AS "SpillPreventionOther",
    a.spill_prevention_not_required AS "SpillPreventionNotRequired",
    sb.spill_bucket_wall_type AS "SpillBucketWallType",
    a.tank_interstitial_monitoring AS "TankInterstitialMonitoring",
    a.tank_automatic_tank_gauging_release_detection AS "TankAutomaticTankGaugingReleaseDetection",
    a.automatic_tank_gauging_continuous_leak_detection AS "AutomaticTankGaugingContinuousLeakDetection",
    a.tank_manual_tank_gauging AS "TankManualTankGauging",
    a.tank_statistical_inventory_reconciliation AS "TankStatisticalInventoryReconciliation",
    a.tank_tightness_testing AS "TankTightnessTesting",
    a.tank_inventory_control AS "TankInventoryControl",
    a.tank_groundwater_monitoring AS "TankGroundwaterMonitoring",
    a.tank_vapor_monitoring AS "TankVaporMonitoring",
    a.tank_subpart_k_tightness_testing AS "TankSubpartKTightnessTesting",
    a.tank_subpart_k_other AS "TankSubpartKOther",
    a.tank_other_release_detection AS "TankOtherReleaseDetection"
   FROM ust_compartment a
     JOIN ust_tank b ON a.ust_tank_id = b.ust_tank_id
     JOIN ust_facility c ON b.ust_facility_id = c.ust_facility_id
     LEFT JOIN ust_compartment_substance csb ON a.ust_compartment_id = csb.ust_compartment_id
     LEFT JOIN ust_tank_substance ts ON csb.ust_tank_substance_id = ts.ust_tank_substance_id
     LEFT JOIN substances s ON ts.substance_id = s.substance_id
     LEFT JOIN compartment_statuses cs ON cs.compartment_status_id = a.compartment_status_id
     LEFT JOIN spill_bucket_wall_types sb ON sb.spill_bucket_wall_type_id = a.spill_bucket_wall_type_id;    
    
create or replace view "public"."v_ust_table_row_count" as
 SELECT v_ust_facility.ust_control_id,
    1 AS sort_order,
    'ust_facility'::text AS table_name,
    count(*) AS num_rows
   FROM v_ust_facility
  GROUP BY v_ust_facility.ust_control_id
UNION ALL
 SELECT v_ust_tank.ust_control_id,
    2 AS sort_order,
    'ust_tank'::text AS table_name,
    count(*) AS num_rows
   FROM v_ust_tank
  GROUP BY v_ust_tank.ust_control_id
UNION ALL
 SELECT v_ust_tank_substance.ust_control_id,
    3 AS sort_order,
    'ust_tank_substance'::text AS table_name,
    count(*) AS num_rows
   FROM v_ust_tank_substance
  GROUP BY v_ust_tank_substance.ust_control_id
UNION ALL
 SELECT v_ust_compartment.ust_control_id,
    4 AS sort_order,
    'ust_compartment'::text AS table_name,
    count(*) AS num_rows
   FROM v_ust_compartment
  GROUP BY v_ust_compartment.ust_control_id
UNION ALL
 SELECT v_ust_compartment_substance.ust_control_id,
    5 AS sort_order,
    'ust_compartment_substance'::text AS table_name,
    count(*) AS num_rows
   FROM v_ust_compartment_substance
  GROUP BY v_ust_compartment_substance.ust_control_id
UNION ALL
 SELECT v_ust_piping.ust_control_id,
    6 AS sort_order,
    'ust_piping'::text AS table_name,
    count(*) AS num_rows
   FROM v_ust_piping
  GROUP BY v_ust_piping.ust_control_id
UNION ALL
 SELECT v_ust_facility_dispenser.ust_control_id,
    7 AS sort_order,
    'ust_facility_dispenser'::text AS table_name,
    count(*) AS num_rows
   FROM v_ust_facility_dispenser
  GROUP BY v_ust_facility_dispenser.ust_control_id
UNION ALL
 SELECT v_ust_tank_dispenser.ust_control_id,
    7 AS sort_order,
    'ust_tank_dispenser'::text AS table_name,
    count(*) AS num_rows
   FROM v_ust_tank_dispenser
  GROUP BY v_ust_tank_dispenser.ust_control_id
  UNION ALL
 SELECT v_ust_compartment_dispenser.ust_control_id,
    8 AS sort_order,
    'ust_compartment_dispenser'::text AS table_name,
    count(*) AS num_rows
   FROM v_ust_compartment_dispenser
  GROUP BY v_ust_compartment_dispenser.ust_control_id;
    
    

alter table ust_facility drop column dispenser_id;
alter table ust_facility drop column dispenser_udc;
alter table ust_facility drop column dispenser_udc_wall_type_id;

alter table ust_tank drop column dispenser_id;
alter table ust_tank drop column dispenser_udc;
alter table ust_tank drop column dispenser_udc_wall_type_id;

alter table ust_compartment drop column dispenser_id;
alter table ust_compartment drop column dispenser_udc;
alter table ust_compartment drop column dispenser_udc_wall_type_id;

   FROM v_ust_tank_substance
  GROUP BY v_ust_tank_substance.ust_control_id
UNION ALL
 SELECT v_ust_compartment.ust_control_id,
    4 AS sort_order,
    'ust_compartment'::text AS table_name,
    count(*) AS num_rows
   FROM v_ust_compartment
  GROUP BY v_ust_compartment.ust_control_id
UNION ALL
 SELECT v_ust_compartment_substance.ust_control_id,
    5 AS sort_order,
    'ust_compartment_substance'::text AS table_name,
    count(*) AS num_rows
   FROM v_ust_compartment_substance
  GROUP BY v_ust_compartment_substance.ust_control_id
UNION ALL
 SELECT v_ust_piping.ust_control_id,
    6 AS sort_order,
    'ust_piping'::text AS table_name,
    count(*) AS num_rows
   FROM v_ust_piping
  GROUP BY v_ust_piping.ust_control_id
UNION ALL
 SELECT v_ust_facility_dispenser.ust_control_id,
    7 AS sort_order,
    'ust_facility_dispenser'::text AS table_name,
    count(*) AS num_rows
   FROM v_ust_facility_dispenser
  GROUP BY v_ust_facility_dispenser.ust_control_id
UNION ALL
 SELECT v_ust_tank_dispenser.ust_control_id,
    7 AS sort_order,
    'ust_tank_dispenser'::text AS table_name,
    count(*) AS num_rows
   FROM v_ust_tank_dispenser
  GROUP BY v_ust_tank_dispenser.ust_control_id
  ;
  
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 select * from v_release_element_mapping 
 
select organization_id, epa_column_name, organization_value, epa_value, programmer_comments 
from v_release_element_mapping 
where organization_id = 'NH'
order by 1, 2, 3;
 
select organization_id, epa_column_name, organization_value, epa_value, programmer_comments 
from v_release_element_mapping 
where organization_id = 'SD'
order by 1, 2, 3;

select * from sd_release.spill_reports_all ;

select * from v_release_element_mapping where organization_value like '%MTBE%'

select * from v_ust_element_mapping where organization_value like '%MTBE%'


--redo SD exluding all where sor_type <> 'UST'
--map MTBE to other
--SD LUST - map gas stations to gas station not commercial (nope - they said commercial)




 
 select * from facility_types 
 
 
 select * from release_element_mapping 
 
 alter table ust_element_mapping add organization_join_column2 varchar(100);
 alter table ust_element_mapping add organization_join_column3 varchar(100);
 alter table ust_element_mapping add organization_join_fk2 varchar(100);
 alter table ust_element_mapping add organization_join_fk3 varchar(100);
 
 alter table release_element_mapping add organization_join_column2 varchar(100);
 alter table release_element_mapping add organization_join_column3 varchar(100);
 alter table release_element_mapping add organization_join_fk2 varchar(100);
 alter table release_element_mapping add organization_join_fk3 varchar(100);


select * from ust_element_mapping
where ust_control_id = 18 and epa_table_name = 'ust_tank'
and epa_column_name = 'tank_id';
 1175

 select * from ust_element_mapping
where ust_control_id = 18 and epa_table_name = 'ust_tank'
and epa_column_name = 'tank_name';

 
select * from ca_ust.erg_tank_id2;

select * from ca_ust.erg_tank_id;



update ust_element_mapping
set organization_join_column = 'facility_id',
	organization_join_column2 = 'tank_name',
	organization_join_fk = 'CERS ID',
	organization_join_fk2 = 'CERS TankID'
where ust_element_mapping_id = 1175

create schema example;

select * from ust_element_mapping
where ust_control_id = 18 and epa_table_name = 'ust_piping';

select * from ust_control;

-- public.ust_control definition

-- Drop table

-- DROP TABLE public.ust_control;

CREATE TABLE example.ust_control (
	ust_control_id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	organization_id varchar(10) NULL,
	date_received date NULL,
	date_processed date NULL,
	data_source text NULL,
	"comments" text NULL,
	organization_compartment_flag varchar(1) NULL,
	CONSTRAINT ust_control_org_comp_flag_chk CHECK (((organization_compartment_flag)::text = ANY (ARRAY['Y'::text, 'N'::text]))),
	CONSTRAINT ust_control_pkey PRIMARY KEY (ust_control_id)
);
CREATE INDEX ust_control_organization_id_idx ON example.ust_control USING btree (organization_id);


drop table example."Facilities";
create table example."Facilities" 
	("Facility ID" varchar(100),
	 "Facility Name" varchar(100),
	 "Address" varchar(100),
	 "City" varchar(100),
	 "Zip Code" int,
	 "Latitude" float,
	 "Longitude" float,
	 "Owner Name" varchar(100)
	 );
	
drop table example."Tanks";
create table example."Tanks" 
	("Facility Id" varchar(100),
	"Tank Name" varchar(100),
	"Tank Status Id" varchar(100),
	"Closure Date" date,
	"Installation Date" date,
	"Tank Substance" varchar(100)
	);
drop table example.erg_tank_id ;
create table example.erg_tank_id (facility_id varchar(100),
tank_name varchar(100),
tank_id  int generated always as identity);

drop table example."Tank Piping";
create table example."Tank Piping" (
	"Facility Id" varchar(100),
	"Tank Name" varchar(100),
	"Piping Style Id" int,
	"Piping Material Id" int
);

select * from piping_styles ;

create table example."Piping Style Lookup" 
("Piping Style Id" int, "Piping Style Desc" varchar(100));

create table example."Piping Material Lookup" 
("Piping Material Id" int, "Piping Material Desc" varchar(100));



insert into example.ust_control (organization_id, date_received, date_processed, organization_compartment_flag)
values ('XX', now(), now(), 'N');

update example.ust_control set comments = 'Example data for element mapping'

update example.ust_control set organization_id = 'XX'

select * from example.ust_control;

select * from example."Facilities"

insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (ZZ,'ust_facility','facility_id','ORG_TAB_NAME','ORG_COL_NAME',null);



insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_facility','facility_id','Facilities','Facility ID',null);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_facility','facility_id','Facilities','Facility ID',null);
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_facility','facility_name','Facilities','Facility Name',null);
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_facility','facility_address1','Facilities','Address',null);
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_facility','facility_city','Facilities','City',null);
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_facility','facility_zip_code','Facilities','Zip Code',null);
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_facility','facility_latitude','Facilities','Latitude',null);
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_facility','facility_longitude','Facilities','Longitude',null);
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_facility','facility_owner_company_name','Facilities','Owner Name',null);

select * from ust_element_mapping 
where ust_control_id = 18 and epa_column_name = 'tank_id'

select * from example.ust_element_mapping;

insert into example."Facilities" 
values ('ABCD1234', 'Gas Station #1', '123 Main St.', '')

create table example.erg_substance_deagg (
 erg_substance_deagg_id int generated always as identity,
 "Substance" text,
 constraint erg_substance_deagg_unique unique ("Substance"))
 
create table example.erg_substance_datarows_deagg (
 "Facility Id" varchar(100),
 "Tank Name" varchar(100),
 "Substance" varchar(100)
);


select * from information_schema.tables 
where table_name like '%deagg%'



select * from ust_element_mapping 
where deagg_table_name is not null;

---------------------------------------------------------------
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_tank','facility_id','Tanks','Facility Id',null);

insert into example.ust_element_mapping 
(ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name,
programmer_comments, 
organization_join_table, organization_join_column, organization_join_column2,
organization_join_fk, organization_join_fk2) 
values
(1,'ust_tank','tank_id','erg_tank_id','tank_id',
'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
'Tanks', 'Facility Id', 'Tank Name', 'facility_id', 'tank_name');

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_tank','tank_name','Tanks','Tank Name',null);

insert into example.ust_element_mapping 
(ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_tank','tank_status_id','Tanks','Tank Status Id',null);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_tank','tank_closure_date','Tanks','Closure Date',null);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_tank','tank_installation_date','Tanks','Install Date',null);





delete from example.ust_element_mapping 
where epa_table_name = 'ust_tank'

select * from example.ust_element_mapping order by 1;



