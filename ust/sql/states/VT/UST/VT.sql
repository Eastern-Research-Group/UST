insert into ust_control (organization_id, date_received, date_processed, data_source)
values ('VT', '2024-08-09', current_date, 'EPA Template populated by the state, some mapping done by ERG')
returning ust_control_id;

update ust_control 
set organization_compartment_flag = 'Y'
where ust_control_id = 26

-- element mapping
--ust_facility: This table is REQUIRED
--NOTE: facility_id is a required field. If Facility ID does not exist in the source data, STOP and talk to the state. 
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_facility','facility_id','facility','FacilityID',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments)
values (26,'ust_facility','facility_name','facility','FacilityName',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_facility','owner_type_id','facility','OwnerType',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_facility','facility_type1','facility','FacilityType1',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_facility','facility_address1','facility','FacilityAddress1',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_facility','facility_city','facility','FacilityCity',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_facility','facility_county','facility','FacilityCounty',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_facility','facility_zip_code','facility','FacilityZipCode',null);
--NOTE: facility_state is a required field but is not always populated in the state's data because the
--source database may assume all facilities are in the state. This column will be added to the v_ust_facility view 
--in a later step if it is not mapped here
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_facility','facility_state','facility','FacilityState',null);
--NOTE: EPA region is rarely populated in the state data, other than TrUSTD (the tribal database)
--so it won't often be mapped here, but it will be added to view v_ust_facility later. 
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_facility','facility_epa_region','facility','FacilityEPARegion',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_facility','facility_latitude','facility','FacilityLatitude',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_facility','facility_longitude','facility','FacilityLongitude',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_facility','coordinate_source_id','facility','null','All rows were marked Unknown by the state, we assume they do not track the data. Please verify this is the correct strategy');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_facility','facility_owner_company_name','facility','FacilityOwnerCompanyName',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_facility','facility_operator_company_name','facility','FacilityOperatorCompanyName',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_facility','financial_responsibility_obtained','facility','null','All rows were marked Unknown by the state, we assume they do not track the data. Please verify this is the correct strategy');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_facility','financial_responsibility_bond_rating_test','facility','FinancialResponsibilityBondRatingTest',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_facility','financial_responsibility_commercial_insurance','facility','FinancialResponsibilityCommercialInsurance',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_facility','financial_responsibility_guarantee','facility','FinancialResponsibilityGuarantee',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_facility','financial_responsibility_letter_of_credit','facility','FinancialResponsibilityLetterOfCredit',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_facility','financial_responsibility_local_government_financial_test','facility','FinancialResponsibilityLocalGovernmentFinancialTest',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_facility','financial_responsibility_risk_retention_group','facility','FinancialResponsibilityRiskRetentionGroup',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_facility','financial_responsibility_self_insurance_financial_test','facility','FinancialResponsibilitySelfInsuranceFinancialTest',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_facility','financial_responsibility_state_fund','facility','FinancialResponsibilityStateFund',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_facility','financial_responsibility_surety_bond','facility','FinancialResponsibilitySuretyBond',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_facility','financial_responsibility_trust_fund','facility','FinancialResponsibilityTrustFund',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_facility','ust_reported_release','facility','USTReportedRelease',null);

--ust_tank: This table is REQUIRED.
--At a mimimum we need a Tank ID (or Tank Name) and Tank Status. If these fields don't exist in the source data, stop and talk to EPA and/or the state. 
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_tank','facility_id','tank','FacilityID',null);
--NOTE: Tank ID is required, but we can create it in a later step as long as Tank Name exists in the source data.
--Tank ID must be an INTEGER (or able to be converted to an integer). 
--If the source data contains a column called Tank ID but it contains alphanumeric values, map it to EPA column tank_name instead of tank_id.
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_tank','tank_id','tank','TankID',null);
--NOTE: Either tank_id or tank_name (or both) must be mapped. Use tank_id for numeric fields and tank_name for alphanumeric/text fields. 
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_tank','tank_name','tank','TankName',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_tank','tank_location_id','tank','TankLocation',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_tank','tank_status_id','tank','TankStatus',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_tank','federally_regulated','tank','FederallyRegulated',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_tank','field_constructed','tank','null','All rows were marked Unknown by the state, we assume they do not track the data. Please verify this is the correct strategynull');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_tank','emergency_generator','tank','EmergencyGenerator',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_tank','airport_hydrant_system','tank','null','All rows were marked Unknown by the state, we assume they do not track the data. Please verify this is the correct strategy');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_tank','multiple_tanks','tank','MultipleTanks',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_tank','tank_installation_date','tank','TankInstallationDate',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_tank','compartmentalized_ust','tank','CompartmentalizedUST',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_tank','number_of_compartments','tank','NumberOfCompartments',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_tank','tank_material_description_id','tank','TankMaterialDescription',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_tank','tank_corrosion_protection_sacrificial_anode','tank','TankCorrosionProtectionSacrificialAnode',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_tank','tank_corrosion_protection_impressed_current','tank','TankCorrosionProtectionImpressedCurrent',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_tank','tank_corrosion_protection_cathodic_not_required','tank','TankCorrosionProtectionCathodicNotRequired',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_tank','tank_corrosion_protection_interior_lining','tank','TankCorrosionProtectionInteriorLining',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_tank','tank_corrosion_protection_other','tank','TankCorrosionProtectionOther',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_tank','tank_corrosion_protection_unknown','tank','null','All rows were marked Unknown by the state, we assume they do not track the data. Please verify this is the correct strategy');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_tank','tank_secondary_containment_id','tank','TankSecondaryContainment',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_tank','cert_of_installation','tank','null','All rows were marked Unknown by the state, we assume they do not track the data. Please verify this is the correct strategy');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_tank','cert_of_installation_other','tank','null','All rows were marked Unknown by the state, we assume they do not track the data. Please verify this is the correct strategy');

--ust_compartment: This table is REQUIRED. 
--If the state does not report compartment data, we will be creating a Compartment ID for it in a later step. 
--Look for these data elements in the tank data for states that don't report compartments. 
--Compartment Status is required; copy the Tank Status mapping for Compartment Status data for states 
--that don't report compartments or do report compartments but don't have a separate compartment status. 
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_compartment','facility_id','compartment','FacilityID',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_compartment','tank_id','compartment','TankID',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_compartment','tank_name','compartment','TankName',null);
--NOTE: Compartment ID must be an INTEGER (or able to be converted to an integer). 
--If the source data contains a column called Compartment ID but it contains alphanumeric values, map it to EPA column compartment_name instead of compartment_id.
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_compartment','compartment_id','compartment','CompartmentID',null);
--NOTE: Use compartment_id for numeric fields and compartment_name for alphanumeric/text fields. 
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_compartment','compartment_name','compartment','CompartmentName',null);
--NOTE: Compartment Status is a required field. If the state does not report compartments, use the same element mapping as Tank Status
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_compartment','compartment_status_id','compartment','CompartmentStatus',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_compartment','compartment_capacity_gallons','compartment','CompartmentCapacityGallons',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_compartment','overfill_prevention_ball_float_valve','compartment','OverfillPreventionBallFloatValve',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_compartment','overfill_prevention_flow_shutoff_device','compartment','OverfillPreventionFlowShutoffDevice',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_compartment','overfill_prevention_high_level_alarm','compartment','OverfillPreventionHighLevelAlarm',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_compartment','overfill_prevention_other','compartment','OverfillPreventionOther',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_compartment','overfill_prevention_unknown','compartment','OverfillPreventionUnknown',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_compartment','overfill_prevention_not_required','compartment','OverfillPreventionNotRequired',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_compartment','spill_bucket_installed','compartment','SpillBucketInstalled',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_compartment','concrete_berm_installed','compartment','ConcreteBermInstalled',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_compartment','spill_prevention_other','compartment','SpillPreventionOther',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_compartment','spill_prevention_not_required','compartment','SpillPreventionNotRequired',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_compartment','spill_bucket_wall_type_id','compartment','SpillBucketWallType',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_compartment','tank_interstitial_monitoring','compartment','TankInterstitialMonitoring',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_compartment','tank_automatic_tank_gauging_release_detection','compartment','TankAutomaticTankGaugingReleaseDetection',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_compartment','automatic_tank_gauging_continuous_leak_detection','compartment','null','All rows were marked Unknown by the state, we assume they do not track the data. Please verify this is the correct strategy');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_compartment','tank_manual_tank_gauging','compartment','TankManualTankGauging',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_compartment','tank_statistical_inventory_reconciliation','compartment','TankStatisticalInventoryReconciliation',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_compartment','tank_tightness_testing','compartment','null','All rows were marked Unknown by the state, we assume they do not track the data. Please verify this is the correct strategy');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_compartment','tank_inventory_control','compartment','null','All rows were marked Unknown by the state, we assume they do not track the data. Please verify this is the correct strategy');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_compartment','tank_groundwater_monitoring','compartment','null','All rows were marked Unknown by the state, we assume they do not track the data. Please verify this is the correct strategy');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_compartment','tank_vapor_monitoring','compartment','null','All rows were marked Unknown by the state, we assume they do not track the data. Please verify this is the correct strategy');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_compartment','tank_subpart_k_tightness_testing','compartment','null','All rows were marked Unknown by the state, we assume they do not track the data. Please verify this is the correct strategy');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_compartment','tank_subpart_k_other','compartment','null','All rows were marked Unknown by the state, we assume they do not track the data. Please verify this is the correct strategy');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_compartment','tank_other_release_detection','compartment','null','All rows were marked Unknown by the state, we assume they do not track the data. Please verify this is the correct strategy');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_compartment_substance','facility_id','compartment','FacilityID',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_compartment_substance','tank_id','compartment','CompartmentSubstanceStored',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_compartment_substance','compartment_id','compartment','CompartmentID',null);

--ust_piping: This table is OPTIONAL, do not map if there is no piping data in the source data
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','facility_id','piping','FacilityID',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','tank_id','piping','TankID',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','tank_name','piping','TankName',null);
--NOTE: Piping ID is a required field but if there is no INTEGER field in the source data that uniquely identifies each
--piping run per Facility/Tank (non-compartment states) or Facility/Tank/Compartment (compartment states),
--we will be constructing a Piping ID in a later step so don't map it now.
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','piping_id','piping','PipingID',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','piping_style_id','piping','PipingStyle',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','safe_suction','piping','null','All rows were marked Unknown by the state, we assume they do not track the data. Please verify this is the correct strategy');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','american_suction','piping','null','All rows were marked Unknown by the state, we assume they do not track the data. Please verify this is the correct strategy');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','high_pressure_or_bulk_piping','piping','null','All rows were marked Unknown by the state, we assume they do not track the data. Please verify this is the correct strategy');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','piping_material_frp','piping','PipingMaterialFRP',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','piping_material_gal_steel','piping','PipingMaterialGalSteel',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','piping_material_stainless_steel','piping','PipingMaterialStainlessSteel',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','piping_material_steel','piping','PipingMaterialSteel',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','piping_material_copper','piping','PipingMaterialCopper',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','piping_material_flex','piping','PipingMaterialFlex',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','piping_material_no_piping','piping','PipingMaterialNoPiping',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','piping_material_other','piping','PipingMaterialOther',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','piping_material_unknown','piping','PipingMaterialUnknown',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','piping_flex_connector','piping','PipingFlexConnector',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','piping_corrosion_protection_sacrificial_anode','piping','PipingCorrosionProtectionSacrificialAnode',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','piping_corrosion_protection_impressed_current','piping','PipingCorrosionProtectionImpressedCurrent',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','piping_corrosion_protection_cathodic_not_required','piping','PipingCorrosionProtectionCathodicNotRequired',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','piping_corrosion_protection_other','piping','PipingCorrosionProtectionOther',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','piping_corrosion_protection_unknown','piping','PipingCorrosionProtectionUnknown',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','piping_line_leak_detector','piping','PipingLineLeakDetector',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','piping_automated_intersticial_monitoring','piping','PipingAutomatedIntersticialMonitoring',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','piping_line_test_annual','piping','PipingLineTestAnnual',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','piping_line_test3yr','piping','PipingLineTest3yr',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','piping_groundwater_monitoring','piping','null','All rows were marked Unknown by the state, we assume they do not track the data. Please verify this is the correct strategy');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','piping_vapor_monitoring','piping','null','All rows were marked Unknown by the state, we assume they do not track the data. Please verify this is the correct strategy');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','piping_interstitial_monitoring','piping','PipingInterstitialMonitoring',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','piping_statistical_inventory_reconciliation','piping','null','All rows were marked Unknown by the state, we assume they do not track the data. Please verify this is the correct strategy');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','piping_release_detection_other','piping','null','All rows were marked Unknown by the state, we assume they do not track the data. Please verify this is the correct strategy');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','piping_subpart_k_line_test','piping','null','All rows were marked Unknown by the state, we assume they do not track the data. Please verify this is the correct strategy');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','piping_subpart_k_other','piping','null','All rows were marked Unknown by the state, we assume they do not track the data. Please verify this is the correct strategy');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','pipe_tank_top_sump','piping','PipeTankTopSump',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','pipe_tank_top_sump_wall_type_id','piping','null','All rows were marked Unknown by the state, we assume they do not track the data. Please verify this is the correct strategy');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','piping_wall_type_id','piping','null','All rows were marked Unknown by the state, we assume they do not track the data. Please verify this is the correct strategy');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','pipe_trench_liner','piping','null','All rows were marked Unknown by the state, we assume they do not track the data. Please verify this is the correct strategy');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','pipe_secondary_containment_other','piping','null','All rows were marked Unknown by the state, we assume they do not track the data. Please verify this is the correct strategy');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (26,'ust_piping','pipe_secondary_containment_unknown','piping','null','All rows were marked Unknown by the state, we assume they do not track the data. Please verify this is the correct strategy');

-- update query logic
update ust_element_mapping
set query_logic = 'When AutomaticTankGaugingContinuousLeakDetection = Yes then Yes, else Unknown'
where ust_control_id = 26 and organization_column_name = 'AutomaticTankGaugingContinuousLeakDetection';

update ust_element_mapping
set query_logic = 'When SpillBucketInstalled = Yes then Yes, when SpillBucketInstalled = No then No, else Unknown'
where ust_control_id = 26 and organization_column_name = 'SpillBucketInstalled';

update ust_element_mapping
set query_logic = 'When TankAutomaticTankGaugingReleaseDetection = Yes then Yes, when TankAutomaticTankGaugingReleaseDetection = No then No, else Unknown'
where ust_control_id = 26 and organization_column_name = 'TankAutomaticTankGaugingReleaseDetection';

update ust_element_mapping
set query_logic = 'When PipingLineLeakDetector not null then Yes, else Unknown'
where ust_control_id = 26 and organization_column_name = 'PipingLineLeakDetector';

update ust_element_mapping 
set programmer_comments = 'State only gave the year, so the dates are set to January 1st of the given year.'
where ust_control_id = 26 and organization_column_name = 'TankInstallationDate';

-- element value mapping
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--owner_type_id

--select distinct "OwnerType" from vt_ust."facility" where "OwnerType" is not null order by 1;
/* Organization values are:

Bulk
Industrial/Commercial
Institutional
Retail
Service Station
State
Town
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1835, 'Bulk', 'Other', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1835, 'Industrial/Commercial', 'Commercial', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1835, 'Institutional', 'Private', 'Please Verify; Mapped by ERG ');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1835, 'Retail', 'Commercial', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1835, 'Service Station', 'Commercial', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1835, 'State', 'State Government - Non Military', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1835, 'Town', 'Local Government', null);

--select owner_type from public.owner_types;
/* Valid EPA values are:

Federal Government - Non Military
State Government - Non Military
Local Government
Commercial
Private
Military
Other
Tribal Government

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'owner_type_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check public.owner_types to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--facility_type1

--select distinct "FacilityType1" from vt_ust."facility" where "FacilityType1" is not null order by 1;
/* Organization values are:

Commercial
Municipal
Retail
Wombat
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1836, 'Commercial', 'Commercial', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1836, 'Municipal', 'State/local government', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1836, 'Retail', 'Commercial', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1836, 'Wombat', 'Other', 'Please Verify; Mapped by ERG');

--select facility_type from public.facility_types;
/* Valid EPA values are:

Agricultural/farm
Auto dealership/auto maintenance & repair
Aviation/airport (non-rental car)
Bulk plant storage/petroleum distributor
Commercial
Contractor
Hospital (or other medical)
Industrial
Marina
Railroad
Rental Car
Residential
Retail fuel sales (non-marina)
School
Telecommunication facility
Trucking/transport/fleet operation
Utility
Wholesale
Other
Unknown
Federal government, non-military
Military
State/local government

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'facility_type1'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check public.facility_types to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--facility_state

--select distinct "FacilityState" from vt_ust."facility" where "FacilityState" is not null order by 1;
/* Organization values are:

Vt
VT
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1841, 'Vt', 'VT', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1841, 'VT', 'VT', null);

--select state from public.states;
/* Valid EPA values are:

AK
AL
AR
AS
AZ
CA
CO
CT
DC
DE
FL
GA
GU
HI
IA
ID
IL
IN
KS
KY
LA
MA
MD
ME
MI
MN
MO
MP
MS
MT
NC
ND
NE
NH
NJ
NM
NV
NY
OH
OK
OR
PA
PR
RI
SC
SD
TN
TT
TX
UT
VA
VI
VT
WA
WI
WV
WY

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'facility_state'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check public.states to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--tank_location_id

--select distinct "TankLocation" from vt_ust."tank" where "TankLocation" is not null order by 1;
/* Organization values are:

Aboveground (tank bottom abovegrade)
Underground (entirely buried)
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1863, 'Aboveground (tank bottom abovegrade)', 'Aboveground (tank bottom abovegrade)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1863, 'Underground (entirely buried)', 'Underground (entirely buried)', null);

--select tank_location from public.tank_locations;
/* Valid EPA values are:

Underground (entirely buried)
Partially buried
Aboveground (tank bottom abovegrade)
Aboveground (tank bottom on-grade)
Unknown
Other

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'tank_location_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check public.tank_locations to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--tank_status_id

--select distinct "TankStatus" from vt_ust."tank" where "TankStatus" is not null order by 1;
/* Organization values are:

ACTIVE
PULLED
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1864, 'ACTIVE', 'Currently in use', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1864, 'PULLED', 'Closed (removed from ground)', 'Please Verify; Mapped by ERG');

--select tank_status from public.tank_statuses;
/* Valid EPA values are:

Currently in use
Temporarily out of service
Closed (removed from ground)
Closed (in place)
Closed (general)
Abandoned
Other
Unknown

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'tank_status_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check public.tank_statuses to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--tank_material_description_id

--select distinct "TankMaterialDescription" from vt_ust."tank" where "TankMaterialDescription" is not null order by 1;
/* Organization values are:

Fiberglass jacketed steel
Fiberglass jacketed steel lined
Fiberglass reinforced plastic
Lined steel with impressed current system
Polyethylene jacketed steel
Polyethylene jacketed steel lined
Protected fiberthane steel tank
Protected steel
Protected steel fiberglass lined
Protected Steel Lined Supp anodes
Protected Steel with supplemental anodes
PSteel with impressed current
Unprotected Steel
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1873, 'Fiberglass jacketed steel', 'Jacketed steel', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1873, 'Fiberglass jacketed steel lined', 'Jacketed steel', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1873, 'Fiberglass reinforced plastic', 'Fiberglass reinforced plastic', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1873, 'Lined steel with impressed current system', 'Composite/clad (steel w/fiberglass reinforced plastic)', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1873, 'Polyethylene jacketed steel', 'Jacketed steel', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1873, 'Polyethylene jacketed steel lined', 'Jacketed steel', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1873, 'Protected fiberthane steel tank', 'Cathodically protected steel (without coating)', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1873, 'Protected steel', 'Cathodically protected steel (without coating)', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1873, 'Protected steel fiberglass lined', 'Composite/clad (steel w/fiberglass reinforced plastic)', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1873, 'Protected Steel Lined Supp anodes', 'Cathodically protected steel (without coating)', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1873, 'Protected Steel with supplemental anodes', 'Cathodically protected steel (without coating)', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1873, 'PSteel with impressed current', 'Cathodically protected steel (without coating)', 'Please Verify; Mapped by ERG');
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1873, 'Unprotected Steel', 'Steel (NEC)', 'Please Verify; Mapped by ERG');

--select tank_material_description from public.tank_material_descriptions;
/* Valid EPA values are:

Fiberglass reinforced plastic
Asphalt coated or bare steel
Composite/clad (steel w/fiberglass reinforced plastic)
Epoxy coated steel
Coated and cathodically protected steel
Cathodically protected steel (without coating)
Jacketed steel
Steel (NEC)
Concrete
Other
Unknown

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'tank_material_description_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check public.tank_material_descriptions to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--tank_secondary_containment_id

--select distinct "TankSecondaryContainment" from vt_ust."tank" where "TankSecondaryContainment" is not null order by 1;
/* Organization values are:

Double wall
Jacketed
Unknown
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1880, 'Double wall', 'Double wall', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1880, 'Jacketed', 'Jacketed', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1880, 'Unknown', 'Unknown', null);

--select tank_secondary_containment from public.tank_secondary_containments;
/* Valid EPA values are:

Single wall
Double wall
Triple wall
Jacketed
Excavation liner
Vault
Tank-within-a-tank retrofit (UL standard 1856)
Other
Unknown

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'tank_secondary_containment_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check public.tank_secondary_containments to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--compartment_status_id

--select distinct "CompartmentStatus" from vt_ust."compartment" where "CompartmentStatus" is not null order by 1;
/* Organization values are:

ACTIVE
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1888, 'ACTIVE', 'Currently in use', null);

--select compartment_status from public.compartment_statuses;
/* Valid EPA values are:

Currently in use
Temporarily out of service
Closed (removed from ground)
Closed (in place)
Closed (general)
Other
Unknown
Abandoned

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'compartment_status_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check public.compartment_statuses to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--spill_bucket_wall_type_id

--select distinct "SpillBucketWallType" from vt_ust."compartment" where "SpillBucketWallType" is not null order by 1;
/* Organization values are:

Double-Walled
Single-Walled
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1900, 'Double-Walled', 'Double', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1900, 'Single-Walled', 'Single', null);

--select spill_bucket_wall_type from public.spill_bucket_wall_types;
/* Valid EPA values are:

Single
Double
Unknown

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'spill_bucket_wall_type_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check public.spill_bucket_wall_types to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--piping_style_id

--select distinct "PipingStyle" from vt_ust."piping" where "PipingStyle" is not null order by 1;
/* Organization values are:

Non-Operational
Pressure
Suction
Unknown
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1920, 'Non-Operational', 'Non-operational (e.g., fill line, vent line, gravity)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1920, 'Pressure', 'Pressure', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1920, 'Suction', 'Suction', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (1920, 'Unknown', 'Unknown', null);

--select piping_style from public.piping_styles;
/* Valid EPA values are:

Suction
Pressure
Hydrant
Non-operational (e.g., fill line, vent line, gravity)
Other
Unknown
No piping

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'piping_style_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check public.piping_styles to find the updated epa_value.
 */

-- create views
CREATE OR REPLACE VIEW vt_ust.v_ust_facility
AS SELECT DISTINCT x."FacilityID"::character varying(50) AS facility_id,
	x."FacilityName"::character varying(100) AS facility_name,
	ft.facility_type_id AS facility_type1,
	ot.owner_type_id,
	x."FacilityAddress1"::character varying(100) AS facility_address1,
	x."FacilityCity"::character varying(100) AS facility_city,
	x."FacilityCounty"::character varying(50) AS facility_county,
	x."FacilityZipCode"::character varying(10) AS facility_zip_code,
	s.facility_state,
	x."FacilityEPARegion"::int4 as facility_epa_region,
	x."FacilityLatitude" AS facility_latitude,
	x."FacilityLongitude" AS facility_longitude,
	x."FacilityOwnerCompanyName"::character varying(100) AS facility_owner_company_name,
	x."FacilityOperatorCompanyName" as facility_operator_company_name,
	x."FinancialResponsibilityBondRatingTest" as financial_responsibility_bond_rating_test,
	x."FinancialResponsibilityCommercialInsurance" as financial_responsibility_commercial_insurance,
	x."FinancialResponsibilityGuarantee" as financial_responsibility_guarantee,
	x."FinancialResponsibilityLetterOfCredit" as financial_responsibility_letter_of_credit,
	x."FinancialResponsibilityLocalGovernmentFinancialTest" as financial_responsibility_local_government_financial_test,
	x."FinancialResponsibilityRiskRetentionGroup" as financial_responsibility_risk_retention_group,
	x."FinancialResponsibilitySelfInsuranceFinancialTest" as financial_responsibility_self_insurance_financial_test,
	x."FinancialResponsibilityStateFund" as financial_responsibility_state_fund,
	x."FinancialResponsibilitySuretyBond" as financial_responsibility_surety_bond,
	x."FinancialResponsibilityTrustFund" as financial_responsibility_trust_fund,
	x."USTReportedRelease" as ust_reported_release
FROM vt_ust.facility x
    LEFT JOIN vt_ust.v_facility_type_xwalk ft ON x."FacilityType1" = ft.organization_value::text
    LEFT JOIN vt_ust.v_owner_type_xwalk ot ON x."OwnerType" = ot.organization_value::text
    left join vt_ust.v_state_xwalk s on x."FacilityState" = s.organization_value::text;

create or replace view vt_ust.v_ust_tank
as select distinct x."FacilityID"::text as facility_id,
    x."TankID"::int4 as tank_id,
    x."TankName" as tank_name,
    tl.tank_location_id,
    ts.tank_status_id,
    x."FederallyRegulated" as federally_regulated,
    x."EmergencyGenerator" as emergency_generator,
    x."MultipleTanks" as multiple_tanks,
    case 
    	when x."TankInstallationDate" is null then null
    	else concat((floor(x."TankInstallationDate"))::text, '-01-01')::date
    end AS tank_installation_date,
    x."CompartmentalizedUST" as compartmentalized_ust,
    x."NumberOfCompartments"::int4 as number_of_compartments,
    tm.tank_material_description_id,
    x."TankCorrosionProtectionSacrificialAnode" as tank_corrosion_protection_sacrificial_anode,
    x."TankCorrosionProtectionImpressedCurrent" as tank_corrosion_protection_impressed_current,
    x."TankCorrosionProtectionCathodicNotRequired" as tank_corrosion_protection_cathodic_not_required,
    x."TankCorrosionProtectionInteriorLining" as tank_corrosion_protection_interior_lining,
    x."TankCorrosionProtectionOther" as tank_corrosion_protection_other,
    tsc.tank_secondary_containment_id
from vt_ust.tank x
	left join vt_ust.v_tank_location_xwalk tl on x."TankLocation" = tl.organization_value::text
   	left join vt_ust.v_tank_status_xwalk ts on x."TankStatus" = ts.organization_value::text
   	left join vt_ust.v_tank_material_description_xwalk tm on x."TankMaterialDescription" = tm.organization_value::text
   	left join vt_ust.v_tank_secondary_containment_xwalk tsc on x."TankSecondaryContainment" = tsc.organization_value::text;
   	
create or replace view vt_ust.v_ust_compartment
as select distinct x."FacilityID"::text as facility_id,
	x."TankID"::int4 as tank_id,
	x."CompartmentID"::int4 as compartment_id,
	x."CompartmentName" as compartment_name,
	cs.compartment_status_id,
	floor(x."CompartmentCapacityGallons")::int4 as compartment_capacity_gallons,
	x."OverfillPreventionBallFloatValve" as overfill_prevention_ball_float_valve,
	x."OverfillPreventionFlowShutoffDevice" as overfill_prevention_flow_shutoff_device,
	x."OverfillPreventionHighLevelAlarm" as overfill_prevention_high_level_alarm,
	x."OverfillPreventionOther" as overfill_prevention_other,
	x."OverfillPreventionUnknown" as overfill_prevention_unknown,
	x."OverfillPreventionNotRequired" as overfill_prevention_not_required,
	case 
		when x."SpillBucketInstalled" = 'Yes' then 'Yes'
		when x."SpillBucketInstalled" = 'No' then 'No'
		else null
	end as spill_bucket_installed,
	x."ConcreteBermInstalled" as concrete_berm_installed,
	x."SpillPreventionOther" as spill_prevention_other,
	x."SpillPreventionNotRequired" as spill_prevention_not_required,
	sb.spill_bucket_wall_type_id,
	x."TankInterstitialMonitoring" as tank_interstitial_monitoring,
	case 
		when x."TankAutomaticTankGaugingReleaseDetection" = 'Yes' then 'Yes'
		else 'Unknown'
	end as tank_automatic_tank_gauging_release_detection,
	x."TankManualTankGauging" as tank_manual_tank_gauging,
	x."TankStatisticalInventoryReconciliation" as tank_statistical_inventory_reconciliation
from vt_ust.compartment x
	left join vt_ust.v_compartment_status_xwalk cs on x."CompartmentStatus" = cs.organization_value::text
	left join vt_ust.v_spill_bucket_wall_type_xwalk sb on x."SpillBucketWallType" = sb.organization_value::text;

create or replace view vt_ust.v_ust_piping
as select distinct x."FacilityID"::text as facility_id,
	x."TankID" as tank_id,
	x."PipingID"::character varying(50) as piping_id,
	x."CompartmentID"::int4 as compartment_id,
	ps.piping_style_id,
	x."PipingMaterialFRP" as piping_material_frp,
	x."PipingMaterialGalSteel" as piping_material_gal_steel,
	x."PipingMaterialStainlessSteel" as piping_material_stainless_steel,
	x."PipingMaterialSteel" as piping_material_steel,
	x."PipingMaterialCopper" as piping_material_copper,
	x."PipingMaterialFlex" as piping_material_flex,
	x."PipingMaterialNoPiping" as piping_material_no_piping,
	x."PipingMaterialOther" as piping_material_other,
	x."PipingMaterialUnknown" as piping_material_unknown,
	x."PipingFlexConnector" as piping_flex_connector,
	x."PipingCorrosionProtectionSacrificialAnode" as piping_corrosion_protection_sacrificial_anode,
	x."PipingCorrosionProtectionImpressedCurrent" as piping_corrosion_protection_impressed_current,
	x."PipingCorrosionProtectionCathodicNotRequired" as piping_corrosion_protection_cathodic_not_required,
	x."PipingCorrosionProtectionOther" as piping_corrosion_protection_other,
	x."PipingCorrosionProtectionUnknown" as piping_corrosion_protection_unknown,
	case 
		when x."PipingLineLeakDetector" is not null then 'Yes'
		else 'Unknown'
	end as piping_line_leak_detector,
	x."PipingAutomatedIntersticialMonitoring" as piping_automated_intersticial_monitoring,
	x."PipingLineTestAnnual" as piping_line_test_annual,
	x."PipingLineTest3yr" as piping_line_test3yr,
	x."PipingInterstitialMonitoring" as piping_interstitial_monitoring,
	x."PipeTankTopSump" as pipe_tank_top_sump
from vt_ust.piping x
	left join vt_ust.v_piping_style_xwalk ps on x."PipingStyle" = ps.organization_value::text;


