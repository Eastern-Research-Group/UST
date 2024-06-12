set scan off;


select * from trustd.ut_land_use_type;




select distinct f.land_location_id as "FacilityID", 
	f.facility_desc as "FacilityName",  
    case when luh1.land_use_type_desc in ('Utilities','Commercial Airport or Airline','Industrial','Truck/Transporter',
                                        'Railroad', 'Commercial','Petroleum Distributor','Auto Dealership','Casino',
                                        'Contractor','Hospital','Marina') then 'Commercial'
         when luh1.land_use_type_desc = 'Federal Non-Military' then 'Federal Government - Non Military'
         when luh1.land_use_type_desc = 'Local Government' then 'Local Government'
         when luh1.land_use_type_desc = 'Federal Military' then 'Military'
         when luh1.land_use_type_desc in ('Aircraft Owner','Farm','Private') then 'Private'
         when luh1.land_use_type_desc = 'State Government' then 'State Government - Non Military' else null end as "OwnerType",
    case when luh1.land_use_type_desc = 'Farm' then 'Agricultural/farm'         
         when luh1.land_use_type_desc = 'Auto Dealership' then 'Auto dealership/auto maintenance & repair'         
         when luh1.land_use_type_desc in ('Aircraft Owner','Commercial Airport or Airline') then 'Aviation/airport'         
         when luh1.land_use_type_desc = 'Petroleum Distributor' then 'Bulk plant storage/petroleum distributor'         
         when luh1.land_use_type_desc = 'Commercial' then 'Commercial'         
         when luh1.land_use_type_desc = 'Contractor' then 'Contractor'         
         when luh1.land_use_type_desc = 'Hospital' then 'Hospital'         
         when luh1.land_use_type_desc = 'Industrial' then 'Industrial'         
         when luh1.land_use_type_desc in ('Federal Military','Other','Federal Non-Military','State Government',
                                        'Local Government','Casino','Marina','Private') then 'Other'         
         when luh1.land_use_type_desc = 'Railroad' then 'Railroad'         
         when luh1.land_use_type_desc = 'Residential' then 'Residential'         
         when luh1.land_use_type_desc = 'Gas Station' then 'Retail fuel sales'         
         when luh1.land_use_type_desc = 'School' then 'School'         
         when luh1.land_use_type_desc = 'Truck/Transporter' then 'Trucking/transport/fleet operation'         
         when luh1.land_use_type_desc = 'Not Listed' then 'Unknown'         
         when luh1.land_use_type_desc = 'Utilities' then 'Utility' else null end as "FacilityType1",
    case when luh2.land_use_type_desc = 'Farm' then 'Agricultural/farm'         
         when luh2.land_use_type_desc = 'Auto Dealership' then 'Auto dealership/auto maintenance & repair'         
         when luh2.land_use_type_desc in ('Aircraft Owner','Commercial Airport or Airline') then 'Aviation/airport'         
         when luh2.land_use_type_desc = 'Petroleum Distributor' then 'Bulk plant storage/petroleum distributor'         
         when luh2.land_use_type_desc = 'Commercial' then 'Commercial'         
         when luh2.land_use_type_desc = 'Contractor' then 'Contractor'         
         when luh2.land_use_type_desc = 'Hospital' then 'Hospital'         
         when luh2.land_use_type_desc = 'Industrial' then 'Industrial'         
         when luh2.land_use_type_desc in ('Federal Military','Other','Federal Non-Military','State Government',
                                        'Local Government','Casino','Marina','Private') then 'Other'         
         when luh2.land_use_type_desc = 'Railroad' then 'Railroad'         
         when luh2.land_use_type_desc = 'Residential' then 'Residential'         
         when luh2.land_use_type_desc = 'Gas Station' then 'Retail fuel sales'         
         when luh2.land_use_type_desc = 'School' then 'School'         
         when luh2.land_use_type_desc = 'Truck/Transporter' then 'Trucking/transport/fleet operation'         
         when luh2.land_use_type_desc = 'Not Listed' then 'Unknown'         
         when luh2.land_use_type_desc = 'Utilities' then 'Utility' else null end as "FacilityType2",
         ll.address_1 as "FacilityAddress1", ll.address_2 as "FacilityAddress2", ll.city as "FacilityCity",
         ll.zip as "FacilityZipCode", ll.county as "FacilityCounty", ll.phone as "FacilityPhoneNumber", ll.state as "FacilityState",
         case when r.region_key like 'R%' then replace(r.region_key,'R') end as "FacilityEPARegion",
         case when ll.tribe_owned in ('True','TRUE','Y') or ll.tribe_id is not null then 'Yes' 
              when ll.tribe_owned in ('False','FALSE','N') then 'No' else null end as "FacilityTribe", 
         case when ll.tribe is not null and t.current_name is null then ll.tribe 
              when t.current_name is not null then t.current_name else null end as "FacilityTribeName",
         ll.latitude as "FacilityLatitude", ll.longitude as "FacilityLongitude", 
         case when ll.lat_lon_source like 'GPS%' then 'GPS' 
              when ll.lat_lon_source = 'Estimation' then 'Map Interpolation'
              when ll.lat_lon_source is not null then 'Other' end as "FacilityCoordinateSource",
         substr(fo.responsible_entity_name,1,100) as "FacilityOwnerCompanyName", 
         fo.address_1 as "FacilityOwnerAddress1", 
         fo.address_2 as "FacilityOwnerAddress2",
         fo.city as "FacilityOwnerCity",
         fo.county as "FacilityOwnerCounty", 
         fo.zip as "FacilityOwnerZipCode",
         fo.state as "FacilityOwnerState", 
         fo.phone as "FacilityOwnerPhoneNumber",
         fo.email_addr as "FacilityOwnerEmail",
         --1:MANY between facility and operator; currently using highest operator ID     
         substr(fop.facility_operator_name,1,100) as "FacilityOperatorCompanyName", 
         fop.address_1 as "FacilityOperatorAddress1",
		 fop.address_2 as "FacilityOperatorAddress2",
         fop.city as "FacilityOperatorCity", 
         fop.county as "FacilityOperatorCounty", 
         fop.zip as "FacilityOperatorZipCode",
         fop.state as "FacilityOperatorState",
         fop.phone as "FacilityOperatorPhoneNumber",
         (select distinct 'Yes' from trustd.ut_financial_responsibility fr where fr_type = 'Local Govt. Bond Rating Test' and fr.facility_id = f.facility_id) as "FinancialResponsibilityBondRatingTest",
         (select distinct 'Yes' from trustd.ut_financial_responsibility fr where fr_type = 'Insurance' and fr.facility_id = f.facility_id) as "FinancialResponsibilityCommercialInsurance",
         (select distinct 'Yes' from trustd.ut_financial_responsibility fr where fr_type = 'Guarantee' and fr.facility_id = f.facility_id) as "FinancialResponsibilityGuarantee",
         (select distinct 'Yes' from trustd.ut_financial_responsibility fr where fr_type = 'Letter of Credit' and fr.facility_id = f.facility_id) as "FinancialResponsibilityLetterOfCredit",
         (select distinct 'Yes' from trustd.ut_financial_responsibility fr where fr_type = 'Local Govt. Financial Test' and fr.facility_id = f.facility_id) as "FinancialResponsibilityLocalGovernmentFinancialTest",
         (select distinct 'Yes' from trustd.ut_financial_responsibility fr where fr_type = 'Risk Retention Group' and fr.facility_id = f.facility_id) as "FinancialResponsibilityRiskRetentionGroup",
         (select distinct 'Yes' from trustd.ut_financial_responsibility fr where fr_type = 'Self Insured' and fr.facility_id = f.facility_id) as "FinancialResponsibilitySelfInsuranceFinancialTest",
         (select distinct 'Yes' from trustd.ut_financial_responsibility fr where fr_type = 'State Fund' and fr.facility_id = f.facility_id) as "FinancialResponsibilityStateFund",
         (select distinct 'Yes' from trustd.ut_financial_responsibility fr where fr_type = 'Surety Bond' and fr.facility_id = f.facility_id) as "FinancialResponsibilitySuretyBond",
         (select distinct 'Yes' from trustd.ut_financial_responsibility fr where fr_type in ('Trust Fund','Standby Trust Fund') and fr.facility_id = f.facility_id) as "FinancialResponsibilityTrustFund",
         (select listagg(fr_type,'; ') within group (order by fr_type) as fr_type from trustd.ut_financial_responsibility fr where fr_type not in 
            ('Guarantee','Insurance','Letter of Credit','Local Govt. Bond Rating Test','Local Govt. Financial Test','Risk Retention Group',
             'Self Insured','Standby Trust Fund','State Fund','Surety Bond','Trust Fund','Govt. Entity: Federal Covered','Govt. Entity: State Covered') and fr.facility_id = f.facility_id) as "FinancialResponsibilityOtherMethod",
         (select distinct 'Yes' from trustd.ut_financial_responsibility fr where fr_type like 'Govt. Entity%' and fr.facility_id = f.facility_id) as "FinancialResponsibilityNotRequired",
         ts.tank_name as "TankID", 
         'Yes' as "FederallyRegulated", --we are excluding those that are FALSE.
         tsc.compartment_name as "CompartmentID",
         case when ts.tank_status = 'Abandoned' then 'Abandoned'
              when ts.tank_status = 'Currently in Use' then 'Currently in use' 
              when ts.closure_status_desc = 'Tank closed in place' then 'Closed (in place)' 
              when ts.closure_status_desc like 'Tank removed%' then 'Closed (removed from ground)' 
              when ts.tank_status = 'Temporarily Out of Use' then 'Temporarily out of service' end as "TankStatus",
        case when ta.tank_attributes like '%:13:%' then 'Yes' end as "ManifoldedTanks",
        ts.date_closed as "ClosureDate", ts.date_installed as "InstallationDate",
        case when tscc.num_compartments > 1 or ts.tank_attributes like '%14%' then 'Yes' when  tscc.num_compartments = 1 then 'No' end as "CompartmentalizedUST",
        tscc.num_compartments as "NumberOfCompartments",
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
             when sub.substances = 11 then 'Unknown'
             when sub.substances in (42,56,57,60) then 'Unknown aviation gas or jet fuel'
             when sub.substances = 41 then 'Petroleum product'
             when sub.substances = 6 then 'Used oil/waste oil' end as "CompartmentSubstanceStored",
        ts.tank_capacity as "TankCapacityGallons", --assume unit is gallons
        tsc.compartment_capacity as "CompartmentCapacityGallons", --assume unit is gallons
        case when ta.tank_attributes like '%:11:%' then 'Yes' end as "ExcavationLiner",
        case when ta.tank_attributes like '%:43:%' then 'Single' 
             when ta.tank_attributes like '%:12:%' then 'Double' 
             when ta.tank_attributes like '%:41:%' then 'Triple' end as "TankWallType",
        case when ta.tank_attributes like '%:8:%' then 'Fiberglass reinforced plastic' 
             when ta.tank_attributes like '%:1:%' then 'Asphalt coated or bare steel'  
             when ta.tank_attributes like '%:6:%' then 'Composite/Cclad (steel w/fiberglass reinforced plastic)' 
             when ta.tank_attributes like '%:7:%' then 'Concrete' 
             when ta.tank_attributes like '%:19:%' then 'Epoxy coated steel' 
             when ta.tank_attributes like '%:4:%' or ta.tank_attributes like '%:5:%' then 'Coated and cathodically protected steel' 
             when ta.tank_attributes like '%:18:%' then 'Cathodically protected steel (without coating)' 
             when ta.tank_attributes like '%:9:%' then 'Jacketed steel' 
             when ta.tank_attributes like '%:17:%' then 'Other' 
             when ta.tank_attributes like '%:16:%' then 'Unknown' end as "MaterialDescription",
        case when upper(ts.tank_repaired) = 'TRUE' then 'Yes' when upper(ts.tank_repaired) = 'FALSE' then 'No' end as "TankRepaired", ts.repair_date as "TankRepairDate",
        case when pa.piping_attributes like '%:1:%' then 'Steel' 
             when pa.piping_attributes like '%:5:%' then 'Copper' 
             when pa.piping_attributes like '%:3:%' then 'Fiberglass reinforced plastic' 
             when pa.piping_attributes like '%:2:%' then 'Galvanized steel' 
             when pa.piping_attributes like '%:4:%' then 'Flex piping' 
             when pa.piping_attributes like '%:13:%' then 'No piping' 
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
        case when trd.tank_release_detections like '%:7:%' then 'Yes' end as "InterstitialMonitoringUnknonwType",
        case when trd.tank_release_detections like '%:4:%' then 'Yes' end as "AutomaticTankGauging", --if this is "Yes", AutomaticTankGaugingReleaseDetection and AutomaticTankGaugingContinuousLeakDetection are supposed to be required but cannot be answered
        case when trd.tank_release_detections like '%:1:%' then 'Yes' end as "ManualTankGauging",
        case when trd.tank_release_detections like '%:9:%' then 'Yes' end as "StatisticalInventoryReconciliation",
        case when trd.tank_release_detections like '%:2:%' then 'Yes' end as "TankTightnessTesting",
        case when trd.tank_release_detections like '%:6:%' then 'Yes' end as "GroundwaterMonitoring",
        case when trd.tank_release_detections like '%:5:%' then 'Yes' end as "VaporMonitoring",
        case when trd.tank_release_detections like '%:9:%' then 'Yes' end as "GroundwaterMonitoring",
        case when trd.tank_release_detections like '%:21:%' then 'Yes' end as "ElectronicLineLeakDetector",
        case when trd.tank_release_detections like '%:22:%' then 'Yes' end as "MechanicalLineLeakDetector",
        case when r.release_id is not null then 'Yes' end as "USTReportedRelease",
        r.release_id as "AssociatedLUSTID" --!! does release_id relate to a LUST ID?
from trustd.ut_facility f left join trustd.ut_land_location ll on f.land_location_id = ll.land_location_id
    left join (select land_location_id, land_use_type_desc from 
				(select a.land_location_id, b.land_use_type_desc,
					row_number() over (partition by a.land_location_id order by a.date_observed) rn 
			     from trustd.ut_land_use_hist a join trustd.ut_land_use_type b on a.land_use_type_id = b.land_use_type_id
			     where a.end_date is null) w where rn = 1) luh1 on ll.land_location_id = luh1.land_location_id
    left join (select land_location_id, land_use_type_desc from 
				(select a.land_location_id, b.land_use_type_desc,
					row_number() over (partition by a.land_location_id order by a.date_observed) rn 
			     from trustd.ut_land_use_hist a join trustd.ut_land_use_type b on a.land_use_type_id = b.land_use_type_id
			     where a.end_date is null) w where rn = 2) luh2 on ll.land_location_id = luh2.land_location_id
    left join trustd.ut_tribes t on ll.tribe_id = t.tribe_id
    left join trustd.st_regions r on t.region_id = r.region_id
    left join (select * from (select fh.facility_id, lre.responsible_entity_name, lre.address_1, lre.address_2, 
    							     lre.city, lre.state, lre.zip, lre.county, lre.phone, lre.email_addr,
       				            	 row_number() over (partition by fh.facility_id order by fh.end_date desc nulls first, 
       				            							fh.date_observed desc nulls last, fh.ut_facility_owner_hist_id desc) rn
			  				 from ut_facility_owner_hist fh 
			  				 	join ut_legally_responsible_entity lre on lre.responsible_entity_id = fh.responsible_entity_id) lre
			  				 where rn = 1) fo on f.facility_id = fo.facility_id 
    left join (select c.facility_id, d.* from trustd.ut_facility_operator d join        
                (select a.facility_id, facility_operator_id from trustd.ut_facility_oper_hist a join         
                    (select facility_id, max(ut_facility_oper_hist_id) as ut_facility_oper_hist_id 
                     from trustd.ut_facility_oper_hist where end_date is null group by facility_id) b        
                        on a.ut_facility_oper_hist_id = b.ut_facility_oper_hist_id) c on c.facility_operator_id = d.facility_operator_id) fop
            on f.facility_id = fop.facility_id    
    left join trustd.ut_tank_system ts on f.facility_id = ts.facility_id
    left join trustd.ut_tank_system_comp tsc on ts.tank_system_id = tsc.tank_system_id
    left join (select tank_system_id, count(*) num_compartments from trustd.ut_tank_system_comp group by tank_system_id) tscc on tsc.tank_system_id = tscc.tank_system_id
    left join (select tank_system_id, ':' || tank_attributes || ':' as tank_attributes from trustd.ut_tank_system) ta on ts.tank_system_id = ta.tank_system_id
    left join (select tank_system_id, ':' || piping_attributes || ':' as piping_attributes from trustd.ut_tank_system_comp) pa on ts.tank_system_id = pa.tank_system_id
    left join (select tank_system_id, ':' || piping_deliveries || ':' as piping_deliveries from trustd.ut_tank_system_comp) ps on ts.tank_system_id = ps.tank_system_id
    left join (select tank_system_id, ':' || tank_release_detections || ':' as tank_release_detections from trustd.ut_tank_system_comp) trd on ts.tank_system_id = trd.tank_system_id
    left join (select tank_system_id, ':' || pipe_release_detections || ':' as pipe_release_detections from trustd.ut_tank_system_comp) prd on ts.tank_system_id = prd.tank_system_id
    left join (select tank_system_id, case when substances like '%:%' then substr(substances,0,instr(substances,':')-1) else substances end as substances from trustd.ut_tank_system_comp) sub on ts.tank_system_id = sub.tank_system_id
    left join (select distinct a.land_location_id, a.release_id from trustd.ut_release a 
				join (select release_id, max(event_date) from trustd.ut_release_event 
				      where release_event_type_id = 2 and release_id not in 
				      	(select release_id from trustd.ut_release_event where release_event_type_id = 6)
				      group by release_id) b on a.release_id = b.release_id) r on f.land_location_id = r.land_location_id 
where ll.land_status <> 'Not Indian Country' 
and ts.federal_regulated_tank = 'TRUE'
order by 1;


select network_service_banner from v$session_connect_info

select a.land_location_id, a.release_id, max(b.event_date) as event_date
from trustd.ut_release a join trustd.ut_release_event b on a.release_id = b.release_id
where b.release_event_type_id = 2 and a.tank_system_id is not null 
group by  a.tank_system_id, a.release_id



select distinct a.land_location_id, a.release_id from trustd.ut_release a 
	join (select release_id, max(event_date) from trustd.ut_release_event 
	     where release_event_type_id = 2 group by release_id) b  
		on a.release_id = b.release_id

select ''':' || to_char(ut_tank_attribute_type_id) || ''','':' || ut_tank_attribute_desc || ','
from trustd.ut_tank_attribute_type where active = 'Y'

select * from trustd.ut_tank_system;



select * from trustd.ut_impacted_media_type  ;

select count(*) from trustd.ut_tank_system_comp ; 


select * from trustd.ut_tank_system_comp order by 1 desc;

select * from trustd.ut_tank_system_comp where tank_system_comp_id = 40146;


select count(*) from (
	select distinct f.land_location_id as "FacilityID", ts.tank_name, tsc.compartment_name
	from  trustd.ut_facility f left join trustd.ut_land_location ll on f.land_location_id = ll.land_location_id
	 left join trustd.ut_tank_system ts on f.facility_id = ts.facility_id
    left join trustd.ut_tank_system_comp tsc on ts.tank_system_id = tsc.tank_system_id
	where ll.land_status <> 'Not Indian Country'
	and ts.federal_regulated_tank = 'TRUE'
) a;

select tank_status, count(*) from (
 	select distinct f.land_location_id as "FacilityID", ts.tank_name, tsc.compartment_name, 
		case when tank_status in ('Currently in Use','Temporarily Out of Use','Abandoned') then 'Active'
		     when tank_status = 'Permanently Out of Use' then 'Closed' end as tank_status
	from trustd.ut_facility f 
		left join trustd.ut_land_location ll on f.land_location_id = ll.land_location_id
	 	left join trustd.ut_tank_system ts on f.facility_id = ts.facility_id
		left join trustd.ut_tank_system_comp tsc on ts.tank_system_id = tsc.tank_system_id
	where ll.land_status <> 'Not Indian Country'
	and ts.federal_regulated_tank = 'TRUE'
	order by 1, 2
) group by tank_status;

Permanently Out of Use
Currently in Use
Temporarily Out of Use
Abandoned


  case when ts.tank_status = 'Abandoned' then 'Abandoned'
              when ts.tank_status = 'Currently in Use' then 'Currently in use' 
              when ts.closure_status_desc = 'Tank closed in place' then 'Closed (in place)' 
              when ts.closure_status_desc like 'Tank removed%' then 'Closed (removed from ground)' 
              when ts.tank_status = 'Temporarily Out of Use' then 'Temporarily out of service' end as "TankStatus",

select count(*) from trustd.ut_land_location

select distinct land_status from trustd.ut_land_location
Not Indian Country

Indian Land
Fee Land
Trust


--ut_facility
--ut_land_location
--ut_land_use_hist
--ut_tribes
--st_regions
--ut_facility_owner
--ut_facility_owner_hist
--ut_facility_operator
--ut_facility_oper_hist
--ut_tank_system
--ut_tank_system_comp
--ut_release
--ut_release_event
--ut_financial_responsibility


