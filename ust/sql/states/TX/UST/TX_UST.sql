create table "TX_UST".table_columns (table_name varchar(30), column_name varchar(100), column_number int, column_length int);

insert into "TX_UST".table_columns values ('tanks','ust_id', 1, 8);
insert into "TX_UST".table_columns values ('tanks','facility_id', 2, 8);
insert into "TX_UST".table_columns values ('tanks','facility_number', 3, 6);
insert into "TX_UST".table_columns values ('tanks','tank_id', 4, 10);
insert into "TX_UST".table_columns values ('tanks','number_of_compartments', 5,2);
insert into "TX_UST".table_columns values ('tanks','tank_installation_date', 6, 10);
insert into "TX_UST".table_columns values ('tanks','tank_registration_date', 7, 10);
insert into "TX_UST".table_columns values ('tanks','tank_capacity_gallons', 8, 8);
insert into "TX_UST".table_columns values ('tanks','tank_status', 9, 30);
insert into "TX_UST".table_columns values ('tanks','tank_status_begin_date', 10, 10);
insert into "TX_UST".table_columns values ('tanks','is_empty', 11, 1);
insert into "TX_UST".table_columns values ('tanks','tank_regulatory_status', 12, 30);
insert into "TX_UST".table_columns values ('tanks','tank_internal_protection_date', 13, 10);
insert into "TX_UST".table_columns values ('tanks','tank_single_wall', 14, 1);
insert into "TX_UST".table_columns values ('tanks','tank_double_wall', 15, 1);
insert into "TX_UST".table_columns values ('tanks','piping_single_wall', 16, 1);
insert into "TX_UST".table_columns values ('tanks','piping_double_wall', 17, 1);
insert into "TX_UST".table_columns values ('tanks','tank_jacket', 18, 1);
insert into "TX_UST".table_columns values ('tanks','tank_synthetic_trench_liner', 19, 1);
insert into "TX_UST".table_columns values ('tanks','tank_rigid_trench_liner', 20, 1);
insert into "TX_UST".table_columns values ('tanks','piping_jacket', 21, 1);
insert into "TX_UST".table_columns values ('tanks','piping_synthetic_trench_liner', 22, 1);
insert into "TX_UST".table_columns values ('tanks','piping_rigid_trench_liner', 23, 1);
insert into "TX_UST".table_columns values ('tanks','piping_type', 24, 1);
insert into "TX_UST".table_columns values ('tanks','tank_material_steel', 25, 1);
insert into "TX_UST".table_columns values ('tanks','tank_material_frp', 26, 1);
insert into "TX_UST".table_columns values ('tanks','tank_material_composite', 27, 1);
insert into "TX_UST".table_columns values ('tanks','tank_material_concrete', 28, 1);
insert into "TX_UST".table_columns values ('tanks','tank_material_jacketed', 29, 1);
insert into "TX_UST".table_columns values ('tanks','tank_material_coated', 30, 1);
insert into "TX_UST".table_columns values ('tanks','piping_material_steel', 31, 1);
insert into "TX_UST".table_columns values ('tanks','piping_material_frp', 32, 1);
insert into "TX_UST".table_columns values ('tanks','piping_material_concrete', 33, 1);
insert into "TX_UST".table_columns values ('tanks','piping_material_jacketed', 34, 1);
insert into "TX_UST".table_columns values ('tanks','piping_material_flex_pipe', 35, 1);
insert into "TX_UST".table_columns values ('tanks','piping_connector_shear_valve', 36, 1);
insert into "TX_UST".table_columns values ('tanks','piping_connector_swing_joint', 37, 1);
insert into "TX_UST".table_columns values ('tanks','piping_connector_flex', 38, 1);
insert into "TX_UST".table_columns values ('tanks','tank_corrosion_external_dielectric', 39, 1);
insert into "TX_UST".table_columns values ('tanks','tank_corrosion_cathodic_factory', 40, 1);
insert into "TX_UST".table_columns values ('tanks','tank_corrosion_cathodic_field', 41, 1);
insert into "TX_UST".table_columns values ('tanks','tank_corrosion_composite', 42, 1);
insert into "TX_UST".table_columns values ('tanks','tank_corrosion_coated', 43, 1);
insert into "TX_UST".table_columns values ('tanks','tank_corrosion_frp', 44, 1);
insert into "TX_UST".table_columns values ('tanks','tank_corrosion_external_jacket', 45, 1);
insert into "TX_UST".table_columns values ('tanks','tank_corrosion_not_required', 46, 1);
insert into "TX_UST".table_columns values ('tanks','piping_corrosion_external_dielectric', 47, 1);
insert into "TX_UST".table_columns values ('tanks','piping_corrosion_cathodic_factory', 48, 1);
insert into "TX_UST".table_columns values ('tanks','piping_corrosion_cathodic_field', 49, 1);
insert into "TX_UST".table_columns values ('tanks','piping_corrosion_frp', 50, 1);
insert into "TX_UST".table_columns values ('tanks','piping_corrosion_flex', 51, 1);
insert into "TX_UST".table_columns values ('tanks','piping_corrosion_isolated', 52, 1);
insert into "TX_UST".table_columns values ('tanks','piping_corrosion_dual', 53, 1);
insert into "TX_UST".table_columns values ('tanks','piping_corrosion_not_required', 54, 1);
insert into "TX_UST".table_columns values ('tanks','tank_corrosion_compliance_flag', 55, 1);
insert into "TX_UST".table_columns values ('tanks','piping_corrosion_compliance_flag', 56, 1);
insert into "TX_UST".table_columns values ('tanks','tank_corrosion_variance', 57, 1);
insert into "TX_UST".table_columns values ('tanks','piping_corrosion_variance', 58, 1);
insert into "TX_UST".table_columns values ('tanks','temporarily_out_of_service', 59, 1);
insert into "TX_UST".table_columns values ('tanks','technical_compliance_flag', 60, 1);
insert into "TX_UST".table_columns values ('tanks','tank_tested_flag', 61, 1);
insert into "TX_UST".table_columns values ('tanks','installation_signature_date', 62, 10);

select * from "TX_UST".table_columns where table_name = 'tanks' order by column_number;

select column_name || ' varchar(' || column_length || '),' from "TX_UST".table_columns where table_name = 'tanks' order by column_number;

create table "TX_UST".tanks (ust_id varchar(8) primary key,
facility_id varchar(8),
facility_number varchar(6),
tank_id varchar(10),
number_of_compartments varchar(2),
tank_installation_date varchar(10),
tank_registration_date varchar(10),
tank_capacity_gallons varchar(8),
tank_status varchar(30),
tank_status_begin_date varchar(10),
is_empty varchar(1),
tank_regulatory_status varchar(30),
tank_internal_protection_date varchar(10),
tank_single_wall varchar(1),
tank_double_wall varchar(1),
piping_single_wall varchar(1),
piping_double_wall varchar(1),
tank_jacket varchar(1),
tank_synthetic_trench_liner varchar(1),
tank_rigid_trench_liner varchar(1),
piping_jacket varchar(1),
piping_synthetic_trench_liner varchar(1),
piping_rigid_trench_liner varchar(1),
piping_type varchar(1),
tank_material_steel varchar(1),
tank_material_frp varchar(1),
tank_material_composite varchar(1),
tank_material_concrete varchar(1),
tank_material_jacketed varchar(1),
tank_material_coated varchar(1),
piping_material_steel varchar(1),
piping_material_frp varchar(1),
piping_material_concrete varchar(1),
piping_material_jacketed varchar(1),
piping_material_flex_pipe varchar(1),
piping_connector_shear_valve varchar(1),
piping_connector_swing_joint varchar(1),
piping_connector_flex varchar(1),
tank_corrosion_external_dielectric varchar(1),
tank_corrosion_cathodic_factory varchar(1),
tank_corrosion_cathodic_field varchar(1),
tank_corrosion_composite varchar(1),
tank_corrosion_coated varchar(1),
tank_corrosion_frp varchar(1),
tank_corrosion_external_jacket varchar(1),
tank_corrosion_not_required varchar(1),
piping_corrosion_external_dielectric varchar(1),
piping_corrosion_cathodic_factory varchar(1),
piping_corrosion_cathodic_field varchar(1),
piping_corrosion_frp varchar(1),
piping_corrosion_flex varchar(1),
piping_corrosion_isolated varchar(1),
piping_corrosion_dual varchar(1),
piping_corrosion_not_required varchar(1),
tank_corrosion_compliance_flag varchar(1),
piping_corrosion_compliance_flag varchar(1),
tank_corrosion_variance varchar(1),
piping_corrosion_variance varchar(1),
temporarily_out_of_service varchar(1),
technical_compliance_flag varchar(1),
tank_tested_flag varchar(1),
installation_signature_date varchar(10));


select * from "TX_UST".tanks;

select count(*) from "TX_UST".tanks;
186607

---------------------------------------------------------------------------------------------------------------------------
insert into "TX_UST".table_columns values ('compartments','', 1, );


insert into "TX_UST".table_columns values ('compartments','ust_compartment_id', 1,8 );
insert into "TX_UST".table_columns values ('compartments','ust_id', 2,8 );
insert into "TX_UST".table_columns values ('compartments','facility_id', 3,6 );
insert into "TX_UST".table_columns values ('compartments','tank_id', 4,10 );
insert into "TX_UST".table_columns values ('compartments','compartment_id', 5,1 );
insert into "TX_UST".table_columns values ('compartments','capacity_gallons', 6,8 );
insert into "TX_UST".table_columns values ('compartments','substance_stored1', 7,30 );
insert into "TX_UST".table_columns values ('compartments','substance_stored2', 8,30 );
insert into "TX_UST".table_columns values ('compartments','substance_stored3', 9,30 );
insert into "TX_UST".table_columns values ('compartments','compartment_rd_vapor_monitoring', 10,1 );
insert into "TX_UST".table_columns values ('compartments','compartment_rd_gw_monitoring', 11,1 );
insert into "TX_UST".table_columns values ('compartments','compartment_rd_secondary_monitoring', 12,1 );
insert into "TX_UST".table_columns values ('compartments','compartment_rd_automatic_tank_gauge', 13,1 );
insert into "TX_UST".table_columns values ('compartments','compartment_rd_interstitial_monitoring', 14,1 );
insert into "TX_UST".table_columns values ('compartments','compartment_rd_manual_tank_gauge', 15,1 );
insert into "TX_UST".table_columns values ('compartments','compartment_rd_monthly_tank_gauge', 16,1 );
insert into "TX_UST".table_columns values ('compartments','compartment_rd_sir', 17,1 );
insert into "TX_UST".table_columns values ('compartments','piping_rd_vapor_monitoring', 18,1 );
insert into "TX_UST".table_columns values ('compartments','piping_rd_gw_monitoring', 19,1 );
insert into "TX_UST".table_columns values ('compartments','piping_rd_secondary_monitoring', 20,1 );
insert into "TX_UST".table_columns values ('compartments','piping_rd_interstitial_monitoring', 21,1 );
insert into "TX_UST".table_columns values ('compartments','piping_rd_monthly_testing', 22,1 );
insert into "TX_UST".table_columns values ('compartments','piping_rd_annual_tightness_testing', 23,1 );
insert into "TX_UST".table_columns values ('compartments','piping_rd_triennial_tightness_testing', 24,1 );
insert into "TX_UST".table_columns values ('compartments','piping_rd_auto_line_leak_detector', 25,1 );
insert into "TX_UST".table_columns values ('compartments','piping_rd_sir', 26,1 );
insert into "TX_UST".table_columns values ('compartments','piping_rd_exempt', 27,1 );
insert into "TX_UST".table_columns values ('compartments','sp_tight_fill_container_bucket_sump', 28,1 );
insert into "TX_UST".table_columns values ('compartments','sp_factory_container_bucket_sump', 29,1 );
insert into "TX_UST".table_columns values ('compartments','sp_delivery_shutoff_valve', 30,1 );
insert into "TX_UST".table_columns values ('compartments','sp_flow_restrictor', 31,1 );
insert into "TX_UST".table_columns values ('compartments','sp_alarm', 32,1 );
insert into "TX_UST".table_columns values ('compartments','sp_na', 33,1 );
insert into "TX_UST".table_columns values ('compartments','compartment_rd_compliance_flag', 34,1 );
insert into "TX_UST".table_columns values ('compartments','piping_rd_compliance_flag', 35,1 );
insert into "TX_UST".table_columns values ('compartments','sp_compliance_flag', 36,1 );
insert into "TX_UST".table_columns values ('compartments','compartment_rd_variance', 37,1 );
insert into "TX_UST".table_columns values ('compartments','piping_rd_variance', 38,1 );
insert into "TX_UST".table_columns values ('compartments','sp_variance', 39,1 );
insert into "TX_UST".table_columns values ('compartments','stage1_vapor_recovery', 40,30 );
insert into "TX_UST".table_columns values ('compartments','stage1_installation_date', 41,10 );

select column_name || ' varchar(' || column_length || '),' from "TX_UST".table_columns where table_name = 'compartments' order by column_number;

create table "TX_UST".compartments (
ust_compartment_id varchar(8),
ust_id varchar(8),
facility_id varchar(6),
tank_id varchar(10),
compartment_id varchar(1),
capacity_gallons varchar(8),
substance_stored1 varchar(30),
substance_stored2 varchar(30),
substance_stored3 varchar(30),
compartment_rd_vapor_monitoring varchar(1),
compartment_rd_gw_monitoring varchar(1),
compartment_rd_secondary_monitoring varchar(1),
compartment_rd_automatic_tank_gauge varchar(1),
compartment_rd_interstitial_monitoring varchar(1),
compartment_rd_manual_tank_gauge varchar(1),
compartment_rd_monthly_tank_gauge varchar(1),
compartment_rd_sir varchar(1),
piping_rd_vapor_monitoring varchar(1),
piping_rd_gw_monitoring varchar(1),
piping_rd_secondary_monitoring varchar(1),
piping_rd_interstitial_monitoring varchar(1),
piping_rd_monthly_testing varchar(1),
piping_rd_annual_tightness_testing varchar(1),
piping_rd_triennial_tightness_testing varchar(1),
piping_rd_auto_line_leak_detector varchar(1),
piping_rd_sir varchar(1),
piping_rd_exempt varchar(1),
sp_tight_fill_container_bucket_sump varchar(1),
sp_factory_container_bucket_sump varchar(1),
sp_delivery_shutoff_valve varchar(1),
sp_flow_restrictor varchar(1),
sp_alarm varchar(1),
sp_na varchar(1),
compartment_rd_compliance_flag varchar(1),
piping_rd_compliance_flag varchar(1),
sp_compliance_flag varchar(1),
compartment_rd_variance varchar(1),
piping_rd_variance varchar(1),
sp_variance varchar(1),
stage1_vapor_recovery varchar(30),
stage1_installation_date varchar(10));

select * From "TX_UST".compartments;

select count(*) From "TX_UST".compartments;
198792

----------------------------------------------------------------------------------------------------

insert into "TX_UST".table_columns values ('facilities','facility_id', 1,8 );
insert into "TX_UST".table_columns values ('facilities','additional_id', 2,15 );
insert into "TX_UST".table_columns values ('facilities','facility_number', 3,6 );
insert into "TX_UST".table_columns values ('facilities','facility_name', 4,60 );
insert into "TX_UST".table_columns values ('facilities','facility_type', 5,30 );
insert into "TX_UST".table_columns values ('facilities','facility_begin_date', 6,10 );
insert into "TX_UST".table_columns values ('facilities','facility_status', 7,30 );
insert into "TX_UST".table_columns values ('facilities','facility_exempt_status', 8,1 );
insert into "TX_UST".table_columns values ('facilities','records_offsite', 9,1 );
insert into "TX_UST".table_columns values ('facilities','ust_financial_assurance_required', 10,1 );
insert into "TX_UST".table_columns values ('facilities','number_active_usts', 11,4 );
insert into "TX_UST".table_columns values ('facilities','number_active_asts', 12,4 );
insert into "TX_UST".table_columns values ('facilities','site_address', 13,50 );
insert into "TX_UST".table_columns values ('facilities','site_city', 14,30 );
insert into "TX_UST".table_columns values ('facilities','site_state', 15,2 );
insert into "TX_UST".table_columns values ('facilities','site_zip', 16,5 );
insert into "TX_UST".table_columns values ('facilities','site_zip_extension', 17,4 );
insert into "TX_UST".table_columns values ('facilities','site_location_description', 18,256 );
insert into "TX_UST".table_columns values ('facilities','site_location_nearest_city', 19,35 );
insert into "TX_UST".table_columns values ('facilities','site_location_county', 20,35 );
insert into "TX_UST".table_columns values ('facilities','site_location_tceq_region', 21,2 );
insert into "TX_UST".table_columns values ('facilities','site_location_zip', 22,5 );
insert into "TX_UST".table_columns values ('facilities','facility_contact_first_name', 23,15 );
insert into "TX_UST".table_columns values ('facilities','facility_contact_middle_name', 24,15 );
insert into "TX_UST".table_columns values ('facilities','facility_contact_last_name', 25,28 );
insert into "TX_UST".table_columns values ('facilities','facility_contact_title', 26,60 );
insert into "TX_UST".table_columns values ('facilities','facility_contact_organization_name', 27,100 );
insert into "TX_UST".table_columns values ('facilities','facility_contact_mailing_address', 28,50 );
insert into "TX_UST".table_columns values ('facilities','facility_contact_mailing_address_internal', 29,50 );
insert into "TX_UST".table_columns values ('facilities','facility_contact_mailing_city', 30,30 );
insert into "TX_UST".table_columns values ('facilities','facility_contact_mailing_state', 31,2 );
insert into "TX_UST".table_columns values ('facilities','facility_contact_mailing_zip', 32,5 );
insert into "TX_UST".table_columns values ('facilities','facility_contact_mailing_zip_extension', 33,4 );
insert into "TX_UST".table_columns values ('facilities','facility_contact_mailing_area_code', 34,3 );
insert into "TX_UST".table_columns values ('facilities','facility_contact_mailing_phone_number', 35,7 );
insert into "TX_UST".table_columns values ('facilities','facility_contact_mailing_phone_extension', 36,5 );
insert into "TX_UST".table_columns values ('facilities','facility_contact_fax_area_code', 37,3 );
insert into "TX_UST".table_columns values ('facilities','facility_contact_fax_number', 38,7 );
insert into "TX_UST".table_columns values ('facilities','facility_contact_fax_extension', 39,5 );
insert into "TX_UST".table_columns values ('facilities','facility_contact_email', 40,50 );
insert into "TX_UST".table_columns values ('facilities','facility_address_deliverable', 41,1 );
insert into "TX_UST".table_columns values ('facilities','application_received_date', 42,10 );
insert into "TX_UST".table_columns values ('facilities','signature_date', 43,10 );
insert into "TX_UST".table_columns values ('facilities','signature_first_name', 44,15 );
insert into "TX_UST".table_columns values ('facilities','signature_middle_name', 45,15 );
insert into "TX_UST".table_columns values ('facilities','signature_last_name', 46,28 );
insert into "TX_UST".table_columns values ('facilities','signature_title', 47,60 );
insert into "TX_UST".table_columns values ('facilities','signature_role', 48,35 );
insert into "TX_UST".table_columns values ('facilities','signature_company', 49,100 );
insert into "TX_UST".table_columns values ('facilities','enforcement_action', 50,1 );
insert into "TX_UST".table_columns values ('facilities','enforcement_action_date', 51,10 );
insert into "TX_UST".table_columns values ('facilities','facility_not_inspectable', 52,1 );
insert into "TX_UST".table_columns values ('facilities','facility_not_inspectable_reason1', 53,30 );
insert into "TX_UST".table_columns values ('facilities','facility_not_inspectable_reason2', 54,30 );

select column_name || ' varchar(' || column_length || '),' from "TX_UST".table_columns where table_name = 'facilities' order by column_number;

create table "TX_UST".facilities (
facility_id varchar(8),
additional_id varchar(15),
facility_number varchar(6),
facility_name varchar(60),
facility_type varchar(30),
facility_begin_date varchar(10),
facility_status varchar(30),
facility_exempt_status varchar(1),
records_offsite varchar(1),
ust_financial_assurance_required varchar(1),
number_active_usts varchar(4),
number_active_asts varchar(4),
site_address varchar(50),
site_city varchar(30),
site_state varchar(2),
site_zip varchar(5),
site_zip_extension varchar(4),
site_location_description varchar(256),
site_location_nearest_city varchar(35),
site_location_county varchar(35),
site_location_tceq_region varchar(2),
site_location_zip varchar(5),
facility_contact_first_name varchar(15),
facility_contact_middle_name varchar(15),
facility_contact_last_name varchar(28),
facility_contact_title varchar(60),
facility_contact_organization_name varchar(100),
facility_contact_mailing_address varchar(50),
facility_contact_mailing_address_internal varchar(50),
facility_contact_mailing_city varchar(30),
facility_contact_mailing_state varchar(2),
facility_contact_mailing_zip varchar(5),
facility_contact_mailing_zip_extension varchar(4),
facility_contact_mailing_area_code varchar(3),
facility_contact_mailing_phone_number varchar(7),
facility_contact_mailing_phone_extension varchar(5),
facility_contact_fax_area_code varchar(3),
facility_contact_fax_number varchar(7),
facility_contact_fax_extension varchar(5),
facility_contact_email varchar(50),
facility_address_deliverable varchar(1),
application_received_date varchar(10),
signature_date varchar(10),
signature_first_name varchar(15),
signature_middle_name varchar(15),
signature_last_name varchar(28),
signature_title varchar(60),
signature_role varchar(35),
signature_company varchar(100),
enforcement_action varchar(1),
enforcement_action_date varchar(10),
facility_not_inspectable varchar(1),
facility_not_inspectable_reason1 varchar(30),
facility_not_inspectable_reason2 varchar(30));


select * from "TX_UST".facilities;

select count(*) from "TX_UST".facilities;
81758

---------------------------------------------------------------------------------------------------------------------------

insert into "TX_UST".table_columns values ('financial_assurance','financial_assurance_id', 1,8 );
insert into "TX_UST".table_columns values ('financial_assurance','facility_id', 2,8 );
insert into "TX_UST".table_columns values ('financial_assurance','facility_number', 3,6 );
insert into "TX_UST".table_columns values ('financial_assurance','form_received_date', 4,10 );
insert into "TX_UST".table_columns values ('financial_assurance','mechanism_type', 5,30 );
insert into "TX_UST".table_columns values ('financial_assurance','mechanism_type_other', 6,30 );
insert into "TX_UST".table_columns values ('financial_assurance','multiple_mechanism_types', 7,1 );
insert into "TX_UST".table_columns values ('financial_assurance','issuer_name', 8,50 );
insert into "TX_UST".table_columns values ('financial_assurance','issuer_phone_country_code', 9,5 );
insert into "TX_UST".table_columns values ('financial_assurance','issuer_phone_area_code', 10,3 );
insert into "TX_UST".table_columns values ('financial_assurance','issuer_phone_number', 11,7 );
insert into "TX_UST".table_columns values ('financial_assurance','issuer_phone_extension', 12,5 );
insert into "TX_UST".table_columns values ('financial_assurance','policy_or_mechanism_number', 13,30 );
insert into "TX_UST".table_columns values ('financial_assurance','coverage_effective_begin date', 14,10 );
insert into "TX_UST".table_columns values ('financial_assurance','coverage_expiration_date', 15,10 );
insert into "TX_UST".table_columns values ('financial_assurance','coverage_amount_per_occurrence', 16,30 );
insert into "TX_UST".table_columns values ('financial_assurance','coverage_amount_per_annual_aggregate', 17,30 );
insert into "TX_UST".table_columns values ('financial_assurance','insurance_premium_prepaid', 18,1 );
insert into "TX_UST".table_columns values ('financial_assurance','first_party_corrective_action_met', 19,1 );
insert into "TX_UST".table_columns values ('financial_assurance','third_party_financial_assurance_met_flag', 20,1 );
insert into "TX_UST".table_columns values ('financial_assurance','proof_of_financial assurance flag', 21,1 );
insert into "TX_UST".table_columns values ('financial_assurance','meets_financial_assurance_requirements_flag', 22,1 );



select column_name || ' varchar(' || column_length || '),' from "TX_UST".table_columns where table_name = 'financial_assurance' order by column_number;

create table "TX_UST".financial_assurance (
financial_assurance_id varchar(8),
facility_id varchar(8),
facility_number varchar(6),
form_received_date varchar(10),
mechanism_type varchar(30),
mechanism_type_other varchar(30),
multiple_mechanism_types varchar(1),
issuer_name varchar(50),
issuer_phone_country_code varchar(5),
issuer_phone_area_code varchar(3),
issuer_phone_number varchar(7),
issuer_phone_extension varchar(5),
policy_or_mechanism_number varchar(30),
coverage_effective_begin_date varchar(10),
coverage_expiration_date varchar(10),
coverage_amount_per_occurrence varchar(30),
coverage_amount_per_annual_aggregate varchar(30),
insurance_premium_prepaid varchar(1),
first_party_corrective_action_met varchar(1),
third_party_financial_assurance_met_flag varchar(1),
proof_of_financial_assurance_flag varchar(1),
meets_financial_assurance_requirements_flag varchar(1));

select * from "TX_UST".financial_assurance;

select count(*) from "TX_UST".financial_assurance;
403596




