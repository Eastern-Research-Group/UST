--ust_facility: This table is REQUIRED
--NOTE: facility_id is a required field. If Facility ID does not exist in the source data, STOP and talk to the state. 
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_facility','facility_id','facility','FacilityID',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments)
values (27,'ust_facility','facility_name','facility','FacilityName',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_facility','owner_type_id','facility','OwnerType',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_facility','facility_type1','facility','FacilityType1',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_facility','facility_type2','faciltiy','FacilityType2',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_facility','facility_address1','facility','FacilityAddress1',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_facility','facility_address2','facility','FacilityAddress2',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_facility','facility_city','facility','FacilityCity',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_facility','facility_county','facility','FacilityCounty',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_facility','facility_zip_code','facility','FacilityZipCode',null);
--NOTE: facility_state is a required field but is not always populated in the state's data because the
--source database may assume all facilities are in the state. This column will be added to the v_ust_facility view 
--in a later step if it is not mapped here
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_facility','facility_state','facility','FacilityState',null);
--NOTE: EPA region is rarely populated in the state data, other than TrUSTD (the tribal database)
--so it won't often be mapped here, but it will be added to view v_ust_facility later. 
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_facility','facility_epa_region','facility','FacilityEPARegion',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_facility','facility_latitude','facility','FacilityLatitude',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_facility','facility_longitude','facility','FacilityLongitude',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_facility','coordinate_source_id','facility','FacilityCoordinateSource',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_facility','facility_owner_company_name','facility','FacilityOwnerCompanyName',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_facility','financial_responsibility_obtained','facility','FinancialResponsibilityObtained',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_facility','financial_responsibility_bond_rating_test','facility','FinancialResponsibilityBondRatingTest',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_facility','financial_responsibility_commercial_insurance','facility','FinancialResponsibilityCommercialInsurance',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_facility','financial_responsibility_guarantee','facility','FinancialResponsibilityGuarantee',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_facility','financial_responsibility_letter_of_credit','facility','FinancialResponsibilityLetterOfCredit',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_facility','financial_responsibility_local_government_financial_test','facility','FinancialResponsibilityLocalGovernmentFinancialTest',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_facility','financial_responsibility_risk_retention_group','facility','FinancialResponsibilityRiskRetentionGroup',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_facility','financial_responsibility_self_insurance_financial_test','facility','FinancialResponsibilitySelfInsuranceFinancialTest',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_facility','financial_responsibility_state_fund','facility','FinancialResponsibilityStateFund',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_facility','financial_responsibility_surety_bond','facility','FinancialResponsibilitySuretyBond',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_facility','financial_responsibility_trust_fund','facility','FinancialResponsibilityTrustFund',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_facility','financial_responsibility_other_method','facility','FinancialResponsibilityOtherMethod',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_facility','ust_reported_release','facility','USTReportedRelease',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_facility','associated_ust_release_id','facility','AssociatedLUSTID',null);

--ust_tank: This table is REQUIRED.
--At a mimimum we need a Tank ID (or Tank Name) and Tank Status. If these fields don't exist in the source data, stop and talk to EPA and/or the state. 
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_tank','facility_id','tank','FacilityID',null);
--NOTE: Tank ID is required, but we can create it in a later step as long as Tank Name exists in the source data.
--Tank ID must be an INTEGER (or able to be converted to an integer). 
--If the source data contains a column called Tank ID but it contains alphanumeric values, map it to EPA column tank_name instead of tank_id.
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_tank','tank_id','tank','TankID',null);
--NOTE: Either tank_id or tank_name (or both) must be mapped. Use tank_id for numeric fields and tank_name for alphanumeric/text fields. 
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_tank','tank_name','tank','TankName',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_tank','tank_location_id','tank','TankLocation',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_tank','tank_status_id','tank','TankStatus',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_tank','federally_regulated','tank','FederallyRegulated',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_tank','field_constructed','tank','FieldConstructed',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_tank','emergency_generator','tank','EmergencyGenerator',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_tank','airport_hydrant_system','tank','AirportHydrantSystem',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_tank','multiple_tanks','tank','MultipleTanks',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_tank','tank_closure_date','tank','TankClosureDate',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_tank','tank_installation_date','tank','TankInstallationDate',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_tank','null','tank','CompartmentalizedUST','All values were unknown. Assumed state did not record data');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_tank','tank_material_description_id','tank','TankMaterialDescription',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_tank','tank_corrosion_protection_sacrificial_anode','tank','TankCorrosionProtectionSacrificailAnode',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_tank','tank_corrosion_protection_impressed_current','tank','TankCorrosionProtectionImpressedCurrent',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_tank','tank_corrosion_protection_cathodic_not_required','tank','TankCorrosionProtectionNotRequired',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_tank','tank_corrosion_protection_interior_lining','tank','TankCorrosionProtectionInteriorLining',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_tank','null','tank','TankcorrosionProtectionOther','All values were unknown. Assumed state did not record data');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_tank','null','tank','TankCorrosionProtectionUnknown','All values were unknown. Assumed state did not record data');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_tank','tank_secondary_containment_id','tank','TankSecondaryContainment',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_tank','cert_of_installation','tank','CertOfInstallation',null);

--ust_tank_substance: This table is OPTIONAL (but most states will have data)
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_tank_substance','facility_id','compartment','FacilityID',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_tank_substance','tank_id','compartment','TankID',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_tank_substance','tank_name','compartment','TankName',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_tank_substance','substance_id','compartment','CompartmentSubstanceStored',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_tank_substance','substance_casno','compartment','CompartmentSubstanceCASNO',null);
--NOTE: States that report at the compartment level will likely have substance data at the compartment level
--This will be tracked in table ust_compartment_substance, but all of the columns in that table will be mapped elsewhere
--so there is no mapping required for that table. 

--ust_compartment: This table is REQUIRED. 
--If the state does not report compartment data, we will be creating a Compartment ID for it in a later step. 
--Look for these data elements in the tank data for states that don't report compartments. 
--Compartment Status is required; copy the Tank Status mapping for Compartment Status data for states 
--that don't report compartments or do report compartments but don't have a separate compartment status. 
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_compartment','facility_id','compartment','FacilityID',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_compartment','tank_id','compartment','TankID',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_compartment','tank_name','compartment','TankName',null);
--NOTE: Compartment ID must be an INTEGER (or able to be converted to an integer). 
--If the source data contains a column called Compartment ID but it contains alphanumeric values, map it to EPA column compartment_name instead of compartment_id.
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_compartment','compartment_id','compartment','CompartmentID',null);
--NOTE: Use compartment_id for numeric fields and compartment_name for alphanumeric/text fields. 
--NOTE: Compartment Status is a required field. If the state does not report compartments, use the same element mapping as Tank Status
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_compartment','compartment_status_id','compartment','CompartmentStatus',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_compartment','compartment_capacity_gallons','compartment','CompartmentCapacityGallons',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_compartment','overfill_prevention_ball_float_valve','compartment','OverfillPreventionBallFloatValve',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_compartment','overfill_prevention_flow_shutoff_device','compartment','OverfillPreventionFlowShutoffDevice',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_compartment','overfill_prevention_high_level_alarm','compartment','OverfillPreventionHighLevelAlarm',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_compartment','overfill_prevention_other','compartment','OverfillPreventionOther',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_compartment','overfill_prevention_unknown','compartment','OverfillPreventionUnknown',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_compartment','overfill_prevention_not_required','compartment','OverfillPreventionNotRequired',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_compartment','spill_bucket_installed','compartment','SpillBucketInstalled',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_compartment','spill_prevention_other','compartment','SpillPreventionOther',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_compartment','spill_prevention_not_required','compartment','SpillPreventionNotRequired',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_compartment','spill_bucket_wall_type_id','compartment','SpillBucketWallType',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_compartment','tank_interstitial_monitoring','compartment','TankInterstitialMonitoring',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_compartment','tank_automatic_tank_gauging_release_detection','compartment','TankAutomaticTankGaugingReleaseDetection',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_compartment','automatic_tank_gauging_continuous_leak_detection','compartment','AutomaticTankGaugingContinuousLeakDetection',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_compartment','tank_manual_tank_gauging','compartment','TankManualTankGauging',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_compartment','tank_statistical_inventory_reconciliation','compartment','TankStatisticalInventoryReconciliation',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_compartment','tank_tightness_testing','compartment','TankTightnessTesting',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_compartment','tank_inventory_control','compartment','TankInventoryControl',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_compartment','tank_groundwater_monitoring','compartment','TankGroundwaterMonitoring',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_compartment','tank_vapor_monitoring','compartment','TankVaporMonitoring',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_compartment','tank_subpart_k_tightness_testing','compartment','TankSubpartKTightnessTesting',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_compartment','tank_subpart_k_other','compartment','TankSubpartKOther',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_compartment','tank_other_release_detection','compartment','TankOtherReleaseDetection',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_compartment_substance','facility_id','compartment','FacilityID',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_compartment_substance','tank_id','compartment','TankID',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_compartment_substance','compartment_id','compartment','CompartmentID',null);

--ust_piping: This table is OPTIONAL, do not map if there is no piping data in the source data
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_piping','facility_id','piping','FacilityID',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_piping','tank_id','piping','TankID',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_piping','tank_name','piping','TankName',null);
--NOTE: Piping ID is a required field but if there is no INTEGER field in the source data that uniquely identifies each
--piping run per Facility/Tank (non-compartment states) or Facility/Tank/Compartment (compartment states),
--we will be constructing a Piping ID in a later step so don't map it now.
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_piping','piping_id','piping','PipingID',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_piping','piping_style_id','piping','PipingStyle',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_piping','safe_suction','piping','SafeSuction',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_piping','american_suction','piping','AmericanSuction',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_piping','high_pressure_or_bulk_piping','piping','HighPressureOrBulkPiping',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_piping','piping_material_frp','piping','PipingMaterialFRP',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_piping','piping_material_gal_steel','piping','PipingMaterialGalSteel',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_piping','piping_material_stainless_steel','piping','PipingMaterialStainlessSteel',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_piping','piping_material_steel','piping','PipingMaterialSteel',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_piping','piping_material_copper','piping','PipingMaterialCopper',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_piping','piping_material_flex','piping','PipingMaterialFlex',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_piping','piping_material_no_piping','piping','PipingMaterialNoPiping',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_piping','piping_flex_connector','piping','PipingFlexConnector',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_piping','piping_corrosion_protection_sacrificial_anode','piping','PipingCorrosionProtectionSacrificialAnode',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_piping','piping_corrosion_protection_impressed_current','piping','PipingCorrosionProtectionImpressedCurrent',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_piping','piping_corrosion_protection_cathodic_not_required','piping','PipingCorrosionProtectionCathodicNotRequired',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_piping','piping_corrosion_protection_other','piping','PipingCorrosionProtectionOther',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_piping','piping_corrosion_protection_unknown','piping','PipingCorrosionProtectionUnknown',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_piping','piping_line_leak_detector','piping','PipingLineLeakDetector',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_piping','piping_automated_intersticial_monitoring','piping','PipingAutomatedIntersticialMonitoring',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_piping','piping_line_test_annual','piping','PipingLineTestAnnual',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_piping','piping_line_test3yr','piping','PipingLineTest3yr',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_piping','piping_groundwater_monitoring','piping','PipingGroundwaterMonitoring',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_piping','piping_vapor_monitoring','piping','PipingVaporMonitoring',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_piping','piping_interstitial_monitoring','piping','PipingInterstitialMonitoring','State data includes an identical column, ignored.');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_piping','null','piping','PipingStatisticalInventoryReconciliation','All values were unknown. Assumed state did not record data; State data includes an identical column, ignored.');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_piping','null','piping','PipingReleaseDetectionOther','All values were unknown. Assumed state did not record data');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_piping','piping_subpart_k_line_test','piping','PipingSubpartKLineTest',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_piping','piping_subpart_k_other','piping','PipingSubpartKOther',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_piping','pipe_tank_top_sump','piping','PipeTankTopSump',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_piping','pipe_tank_top_sump_wall_type_id','piping','PipeTankTopSumpWallType',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_piping','piping_wall_type_id','piping','PipingWallType',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_piping','null','piping','PipeTrenchLiner','All values were unknown. Assumed state did not record data');
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_piping','pipe_secondary_containment_other','piping','PipeSecondaryContainmentOther',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_piping','null','piping','PipeSecondaryContainmentUnknown','All values were unknown. Assumed state did not record data');

--ust_facility_dispenser: Map and populate this table only if the state stores dispenser data at the Facility level.
--Dispenser data is OPTIONAL.
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_facility_dispenser','facility_id','facility_dispenser','FacilityID',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_facility_dispenser','dispenser_id','facility_dispenser','DispenserID',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_facility_dispenser','dispenser_udc','facility_dispenser','DispenserUDC',null);
insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (27,'ust_facility_dispenser','dispenser_udc_wall_type','facility_dispenser','DispenserUDCWallType',null);
