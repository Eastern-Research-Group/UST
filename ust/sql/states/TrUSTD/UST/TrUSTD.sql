set scan off;

select f.facility_id as "FacilityID", f.facility_desc as "FacilityName",
    case when luh1.land_use_type_id in (6,7,8,9,11,12,15,17,19,20,21,22) then 'Commercial'
         when luh1.land_use_type_id = 4 then 'Federal Government - Non Military'
         when luh1.land_use_type_id = 14 then 'Local Government'
         when luh1.land_use_type_id = 2 then 'Military'
         when luh1.land_use_type_id in (3,5,23) then 'Private'
         when luh1.land_use_type_id = 13 then 'State Government - Non Military' else null end as "OwnerType",
    case when luh1.land_use_type_id = 5 then 'Agricultural/Farm'         
         when luh1.land_use_type_id = 17 then 'Auto Dealership/Auto Maintenance & Repair'         
         when luh1.land_use_type_id in (3,7) then 'Aviation/Airport'         
         when luh1.land_use_type_id = 15 then 'Bulk Plant Storage/Petroleum Distributor'         
         when luh1.land_use_type_id = 12 then 'Commercial'         
         when luh1.land_use_type_id = 20 then 'Contractor'         
         when luh1.land_use_type_id = 21 then 'Hospital'         
         when luh1.land_use_type_id = 8 then 'Industrial'         
         when luh1.land_use_type_id in (2,4,10,13,14,19,22,23) then 'Other'         
         when luh1.land_use_type_id = 11 then 'Railroad'         
         when luh1.land_use_type_id = 18 then 'Residential'         
         when luh1.land_use_type_id = 1 then 'Retail Fuel Sales'         
         when luh1.land_use_type_id = 24 then 'School'         
         when luh1.land_use_type_id = 9 then 'Trucking/Transport/Fleet Operation'         
         when luh1.land_use_type_id = 16 then 'Unknown'         
         when luh1.land_use_type_id = 6 then 'Utility' else null end as "FacilityType1",
    case when luh2.land_use_type_id = 5 then 'Agricultural/Farm'         
         when luh2.land_use_type_id = 17 then 'Auto Dealership/Auto Maintenance & Repair'         
         when luh2.land_use_type_id in (3,7) then 'Aviation/Airport'         
         when luh2.land_use_type_id = 15 then 'Bulk Plant Storage/Petroleum Distributor'         
         when luh2.land_use_type_id = 12 then 'Commercial'         
         when luh2.land_use_type_id = 20 then 'Contractor'         
         when luh2.land_use_type_id = 21 then 'Hospital'         
         when luh2.land_use_type_id = 8 then 'Industrial'         
         when luh2.land_use_type_id in (2,4,10,13,14,19,22,23) then 'Other'         
         when luh2.land_use_type_id = 11 then 'Railroad'         
         when luh2.land_use_type_id = 18 then 'Residential'         
         when luh2.land_use_type_id = 1 then 'Retail Fuel Sales'         
         when luh2.land_use_type_id = 24 then 'School'         
         when luh2.land_use_type_id = 9 then 'Trucking/Transport/Fleet Operation'         
         when luh2.land_use_type_id = 16 then 'Unknown'         
         when luh2.land_use_type_id = 6 then 'Utility' else null end as "FacilityType2",
         ll.address_1 as "FacilityAddress1", ll.address_2 as "FacilityAddress2", ll.city as "FacilityCity",
         ll.zip as "FacilityZipCode", ll.county as "FacilityCounty", ll.phone as "FacilityPhoneNumber", ll.state as "FacilityState",
         case when ll.tribe_owned in ('True','TRUE','Y') or ll.tribe_id is not null then 'Yes' 
              when ll.tribe_owned in ('False','FALSE','N') then 'No' else null end as "FacilityTribe", 
         case when ll.tribe is not null and t.current_name is null then ll.tribe 
              when t.current_name is not null then t.current_name else null end as "FacilityTribeName",
         ll.latitude as "FacilityLatitude", ll.longitude as "FacilityLongitude", 
         case when ll.lat_lon_source like 'GPS%' then 'GPS' 
              when ll.lat_lon_source = 'Estimation' then 'Map Interpolation'
              when ll.lat_lon_source is not null then 'Other' end as "FacilityCoordinateSource",
         --1:MANY between facility and owner; currently using highest owner ID     
         substr(fo.facility_owner_name,1,40) as "FacilityOwnerLastName", --some of these are company names
         fo.address_1 as "FacilityOwnerAddress1", fo.address_2 as "FacilityOwnerAddress2",
         fo.city as "FacilityOwnerCity", fo.county as "FacilityOwnerCounty", fo.zip as "FacilityOwnerZipCode",
         fo.state as "FacilityOwnerState", fo.phone as "FacilityOwnerPhoneNumber",
         --1:MANY between facility and operator; currently using highest operator ID     
         substr(fop.facility_operator_name,1,40) as "FacilityOperatorLastName", --some of these are company names
         fop.address_1 as "FacilityOperatorAddress1", fop.address_2 as "FacilityOperatorAddress2",
         fop.city as "FacilityOperatorCity", fop.county as "FacilityOperatorCounty", fop.zip as "FacilityOperatorZipCode",
         fop.state as "FacilityOperatorState", fop.phone as "FacilityOperatorPhoneNumber",
         (select distinct 'Yes' from trustd.ut_financial_responsibility fr 
          where fr_type = 'Local Govt. Bond Rating Test' and fr.facility_id = f.facility_id) as "FinancialResponsibilityBondRatingTest",
         (select distinct 'Yes' from trustd.ut_financial_responsibility fr 
          where fr_type = 'Insurance' and fr.facility_id = f.facility_id) as "FinancialResponsibilityCommercialInsurance",
         (select distinct 'Yes' from trustd.ut_financial_responsibility fr 
          where fr_type = 'Guarantee' and fr.facility_id = f.facility_id) as "FinancialResponsibilityGuarantee",
         (select distinct 'Yes' from trustd.ut_financial_responsibility fr
          where fr_type = 'Letter of Credit' and fr.facility_id = f.facility_id) as "FinancialResponsibilityLetterOfCredit",
         (select distinct 'Yes' from trustd.ut_financial_responsibility fr 
          where fr_type = 'Local Govt. Financial Test' and fr.facility_id = f.facility_id) as "FinancialResponsibilityLocalGovernmentFinancialTest",
         (select distinct 'Yes' from trustd.ut_financial_responsibility fr 
          where fr_type = 'Risk Retention Group' and fr.facility_id = f.facility_id) as "FinancialResponsibilityRiskRetentionGroup",
         (select distinct 'Yes' from trustd.ut_financial_responsibility fr 
          where fr_type = 'Self Insured' and fr.facility_id = f.facility_id) as "FinancialResponsibilitySelfInsuranceFinancialTest",
         (select distinct 'Yes' from trustd.ut_financial_responsibility fr 
          where fr_type = 'State Fund' and fr.facility_id = f.facility_id) as "FinancialResponsibilityStateFund",
         (select distinct 'Yes' from trustd.ut_financial_responsibility fr 
          where fr_type = 'Surety Bond' and fr.facility_id = f.facility_id) as "FinancialResponsibilitySuretyBond",
         (select distinct 'Yes' from trustd.ut_financial_responsibility fr 
          where fr_type in ('Trust Fund','Standby Trust Fund') and fr.facility_id = f.facility_id) as "FinancialResponsibilityTrustFund",
         (select listagg(fr_type,'; ') within group (order by fr_type) as fr_type from trustd.ut_financial_responsibility fr where fr_type not in 
            ('Guarantee','Insurance','Letter of Credit','Local Govt. Bond Rating Test','Local Govt. Financial Test','Risk Retention Group',
             'Self Insured','Standby Trust Fund','State Fund','Surety Bond','Trust Fund','Govt. Entity: Federal Covered','Govt. Entity: State Covered') 
             and fr.facility_id = f.facility_id) as "FinancialResponsibilityOtherMethod",
         (select distinct 'Yes' from trustd.ut_financial_responsibility fr 
          where fr_type like 'Govt. Entity%' and fr.facility_id = f.facility_id) as "FinancialResponsibilityNotRequired",
         ts.tank_name as "TankID", 
         case when ts.federal_regulated_tank = 'TRUE' then 'Yes' when ts.federal_regulated_tank = 'FALSE' then 'No' end as "FederallyRegulated",
         tsc.compartment_name as "CompartmentID",
         case when ts.tank_status = 'Abandoned' then 'Abandoned'
              when ts.tank_status = 'Currently in Use' then 'Currently in use' 
              when ts.closure_status_desc = 'Tank closed in place' then 'Closed (in place)' 
              when ts.closure_status_desc like 'Tank removed%' then 'Closed (removed from ground)' 
              when ts.tank_status = 'Temporarily Out of Use' then 'Temporarily out of service' end as "TankStatus",
        case when tsc.manifolded_to is not null then 'Yes' end as "ManifoldedTanks",
        case when upper(ts.ast) = 'TRUE' then 'Yes' when upper(ts.ast) = 'FALSE' then 'No' end as "MultipleTanks",
        ts.date_closed as "ClosureDate", ts.date_installed as "InstallationDate",
        case when tscc.num_compartments > 1 or ts.tank_attributes like '%14%' then 'Yes' when  tscc.num_compartments = 1 then 'No' end as "CompartmentalizedUST",
        tscc.num_compartments as "NumberOfCompartments",
        case when lower(ts.substance_desc) = 'diesel' then 'Diesel fuel (b-unknown)'
             when lower(ts.substance_desc) = 'gasohol' then 'Ethanol blend gasoline (e-unknown)'
             when lower(ts.substance_desc) = 'gasoline' then 'Gasoline (unknown type)'
             when lower(ts.substance_desc) = 'hazardous substance' then 'Hazardous substance'
             when lower(ts.substance_desc) = 'kerosene' then 'Kerosene'
             when lower(ts.substance_desc) = 'heating oil' then 'Heating/fuel oil # unknown'
             when lower(ts.substance_desc) in ('other','other substance','mixture','gasoline/diesel','not listed') then 'Other'
             when lower(ts.substance_desc) = 'used oil' then 'Used oil/waste oil' end as "TankSubstanceStored",
        case when sub.substances = 3 then '00% biodiesel (not federally regulated)'    
             when sub.substances = 8 then 'Diesel blend containing greater than 20% and less than 99% biodiesel'
             when sub.substances = 2 then 'Diesel fuel (b-unknown)'
             when sub.substances in (22,23) then 'Ethanol blend gasoline (e-unknown)'
             when sub.substances = 21 then 'Gasoline (non-ethanol)'
             when sub.substances in (1,7) then 'Gasoline E-10 (E1-E10)'
             when sub.substances = 9 then 'Hazardous substance'
             when sub.substances in (5,43) then 'Heating/fuel oil # unknown'
             when sub.substances = 58 then 'Jet fuel A'
             when sub.substances = 59 then 'Jet fuel B'
             when sub.substances = 4 then 'Kerosene'
             when sub.substances in (55,62) then 'Lube/motor oil (new)'
             when sub.substances in (10,12,13,44,54,61) then 'Other'
             when sub.substances in (11,41) then 'Unknown'
             when sub.substances in (42,56,57,60) then 'Unknown aviation gas or jet fuel'
             when sub.substances = 41 then 'Petroleum product'
             when sub.substances = 6 then 'Used oil/waste oil' end as "CompartmentSubstanceStored",
        ts.tank_capacity as "TankCapacityGallons", --assume unit is gallons
        tsc.compartment_capacity as "CompartmentCapacityGallons", --assume unit is gallons
        case when ta.tank_attributes like '%:11:%' then 'Yes' end as "ExcavationLiner",
        case when ta.tank_attributes like '%:43:%' then 'Single' 
             when ta.tank_attributes like '%:12:%' then 'Double' 
             when ta.tank_attributes like '%:41:%' then 'Triple' end as "TankWallType",
        case when ta.tank_attributes like '%:8:%' then 'Fiberglass Reinforced Plastic' 
             when ta.tank_attributes like '%:1:%' then 'Asphalt Coated or Bare Steel'  
             when ta.tank_attributes like '%:6:%' then 'Composite/Clad (Steel w/Fiberglass Reinforced Plastic)' 
             when ta.tank_attributes like '%:7:%' then 'Concrete' 
             when ta.tank_attributes like '%:19:%' then 'Epoxy Coated Steel' 
             when ta.tank_attributes like '%:4:%' or ta.tank_attributes like '%:5:%' then 'Coated and Cathodically Protected Steel' 
             when ta.tank_attributes like '%:18:%' then 'Cathodically Protected Steel (without coating)' 
             when ta.tank_attributes like '%:9:%' then 'Jacketed Steel' 
             when ta.tank_attributes like '%:17:%' then 'Other' 
             when ta.tank_attributes like '%:16:%' then 'Unknown' end as "MaterialDescription",
        case when upper(ts.tank_repaired) = 'TRUE' then 'Yes' when upper(ts.tank_repaired) = 'FALSE' then 'No' end as "TankRepaired", ts.repair_date as "TankRepairDate",
        case when pa.piping_attributes like '%:1:%' then 'Steel' 
             when pa.piping_attributes like '%:5:%' then 'Copper' 
             when pa.piping_attributes like '%:3:%' then 'Fiberglass Reinforced Plastic' 
             when pa.piping_attributes like '%:2:%' then 'Galvanized Steel' 
             when pa.piping_attributes like '%:4:%' then 'Flex Piping' 
             when pa.piping_attributes like '%:13:%' then 'No Piping' 
             when pa.piping_attributes like '%:11:%' then 'Unknown' 
             when pa.piping_attributes like '%:12:%' then 'Other' end as "PipingMaterialDescription",
        case when ps.piping_deliveries like '%:1:%' or ps.piping_deliveries like '%:2:%' or ps.piping_deliveries like '%:23:%' then 'Suction'
             when ps.piping_deliveries like '%:3:%' then 'Pressure'
             when ps.piping_deliveries like '%:4:%' then 'Non-operational ( e.g., fill line, vent line, gravity)'
             when ps.piping_deliveries like '%:6:%' or ps.piping_deliveries like '%:22:%' then 'Unknown'
             when ps.piping_deliveries like '%:5:%' or  ps.piping_deliveries like '%:21:%' then 'Other' end as "PipingStyle",
        case when pa.piping_attributes like '%:8:%' then 'Double Walled' end as "PipingWallType",
        case when upper(tsc.pipe_repaired) = 'TRUE' then 'Yes' when upper(tsc.pipe_repaired) = 'FALSE' then 'No' end as "PipingRepaired",
        case when ta.tank_attributes like '%:2:%' or ta.tank_attributes like '%:4:%'  then 'Yes' end as "TankCorrosionProtectionImpressedCurrent",
        case when ta.tank_attributes like '%:3:%' or ta.tank_attributes like '%:5:%'  then 'Yes' end as "TankCorrosionProtectionSacrificialAnode",
        case when pa.piping_attributes like '%:6:%' then 'Yes' end as "PipingCorrosionProtectionImpressedCurrent",
        case when pa.piping_attributes like '%:7:%' then 'Yes' end as "PipingCorrosionProtectionSacrificialAnode",
        case when tsc.overfill_protections like '%1%' or tsc.overfill_protections like '%6%' then 'Yes' end as "AutomaticShutoffDevice",
        case when tsc.overfill_protections like '%3%' then 'Yes' end as "OverfillAlarm",
        case when tsc.overfill_protections like '%2%' or tsc.overfill_protections like '%5%' then 'Yes' end as "BallFloatValve",
        case when upper(tsc.spill_installed) = 'TRUE' then 'Yes' when upper(tsc.spill_installed) = 'FALSE' or tsc.spill_installed = 'Exempt due to small delivery' then 'No' end as "SpillBucketInstalled",
        case when tsc.spill_preventions in (1,21) then 'Double' when tsc.spill_preventions = 41 then 'Single' end as "SpillBucketWallType",
        case when trd.tank_release_detections like '%:4:%' then 'Yes' end as "AutomaticTankGauging", --if this is "Yes", AutomaticTankGaugingReleaseDetection and AutomaticTankGaugingContinuousLeakDetection are supposed to be required but cannot be answered
        case when trd.tank_release_detections like '%:1:%' then 'Yes' end as "ManualTankGauging",
        case when trd.tank_release_detections like '%:9:%' then 'Yes' end as "StatisticalInventoryReconciliation",
        case when trd.tank_release_detections like '%:6:%' then 'Yes' end as "GroundwaterMonitoring",
        case when trd.tank_release_detections like '%:5:%' then 'Yes' end as "VaporMonitoring",
        case when trd.tank_release_detections like '%:9:%' then 'Yes' end as "GroundwaterMonitoring",
        case when r.release_id is not null then 'Yes' end as "USTReportedRelease",
        r.release_id as "AssociatedLUSTID" --!! does release_id related to a LUST ID? Does it need to?
from trustd.ut_facility f left join trustd.ut_land_location ll on f.land_location_id = ll.land_location_id
    left join (select * from (select land_location_id, land_use_id, land_use_type_id, row_number() over (partition by land_location_id order by date_observed) rn 
              from trustd.ut_land_use_hist where end_date is null) where rn = 1) luh1 on ll.land_location_id = luh1.land_location_id
    left join (select * from (select land_location_id, land_use_id, land_use_type_id, row_number() over (partition by land_location_id order by date_observed) rn 
              from trustd.ut_land_use_hist where end_date is null) where rn = 2) luh2 on ll.land_location_id = luh2.land_location_id    
    left join trustd.ut_tribes t on ll.tribe_id = t.tribe_id
    left join (select c.facility_id, d.* from trustd.ut_facility_owner d join        
                (select a.facility_id, facility_owner_id from trustd.ut_facility_owner_hist a join         
                    (select facility_id, max(ut_facility_owner_hist_id) as ut_facility_owner_hist_id 
                     from trustd.ut_facility_owner_hist where end_date is null group by facility_id) b        
                        on a.ut_facility_owner_hist_id = b.ut_facility_owner_hist_id) c on c.facility_owner_id = d.facility_owner_id) fo
            on f.facility_id = fo.facility_id 
    left join (select c.facility_id, d.* from trustd.ut_facility_operator d join        
                (select a.facility_id, facility_operator_id from trustd.ut_facility_oper_hist a join         
                    (select facility_id, max(ut_facility_oper_hist_id) as ut_facility_oper_hist_id 
                     from trustd.ut_facility_oper_hist where end_date is null group by facility_id) b        
                        on a.ut_facility_oper_hist_id = b.ut_facility_oper_hist_id) c on c.facility_operator_id = d.facility_operator_id) fop
            on f.facility_id = fop.facility_id     
    left join trustd.ut_tank_system ts on f.facility_id = ts.facility_id
    left join trustd.ut_tank_system_comp tsc on ts.tank_system_id = tsc.tank_system_id
    left join (select tank_system_id, count(*) num_compartments from trustd.ut_tank_system_comp group by tank_system_id) tscc on ts.tank_system_id = tscc.tank_system_id
    left join (select tank_system_id, ':' || tank_attributes || ':' as tank_attributes from trustd.ut_tank_system) ta on ts.tank_system_id = ta.tank_system_id
    left join (select tank_system_id, ':' || piping_attributes || ':' as piping_attributes from trustd.ut_tank_system_comp) pa on ts.tank_system_id = pa.tank_system_id
    left join (select tank_system_id, ':' || piping_deliveries || ':' as piping_deliveries from trustd.ut_tank_system_comp) ps on ts.tank_system_id = ps.tank_system_id
    left join (select tank_system_id, ':' || tank_release_detections || ':' as tank_release_detections from trustd.ut_tank_system_comp) trd on ts.tank_system_id = trd.tank_system_id
    left join (select tank_system_id, ':' || pipe_release_detections || ':' as pipe_release_detections from trustd.ut_tank_system_comp) prd on ts.tank_system_id = prd.tank_system_id
    left join (select tank_system_id, case when substances like '%:%' then substr(substances,0,instr(substances,':')-1) else substances end as substances from trustd.ut_tank_system_comp) sub on ts.tank_system_id = sub.tank_system_id
    left join (select a.tank_system_id, a.release_id, max(b.event_date) as event_date from trustd.ut_release a join trustd.ut_release_event b on a.release_id = b.release_id
               where b.release_event_type_id = 2 and a.tank_system_id is not null group by  a.tank_system_id, a.release_id) r on ts.tank_system_id = r.tank_system_id 
    -- 1) the above join results in very few rows and may be wrong 2) release_event_type_id 2 = 'Confirmed Release', but does this mean it was a "reported release"?
;



