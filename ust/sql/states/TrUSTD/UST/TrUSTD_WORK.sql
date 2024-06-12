select * from trustd.ust_inspection;

select * from trustd.ut_facility;

select * from trustd.ut_land_use_type;

select * from trustd.ut_land_use_hist where land_location_id in (
select land_location_id from trustd.ut_land_use_hist
where end_date is null group by land_location_id having count(*) > 1)
order by land_location_id;

select distinct lat_lon_source from trustd.ut_land_location;




select land_location_id from (
select land_location_id, max(date_observed) as date_observed from trustd.ut_land_owner_hist 
where end_date is null group by land_location_id
) group by land_location_id having count(*) > 1;

select d.land_location_id, c.* from trustd.ut_land_owner c join 
(select a.land_owner_id, a.land_location_id from trustd.ut_land_owner_hist a join 
(select land_location_id, max(date_observed) as date_observed from trustd.ut_land_owner_hist 
where end_date is null group by land_location_id) b on a.land_location_id = b.land_location_id) d on c.land_owner_id = d.land_owner_id;


select d.facility_id, c.* from trustd.ut_facility_owner c join 
(select a.facility_owner_id, a.facility_id from trustd.ut_facility_owner_hist a join 
(select facility_id, max(date_observed) as date_observed from trustd.ut_facility_owner_hist 
where end_date is null group by facility_id) b on a.facility_id = b.facility_id) d on c.facility_owner_id = d.facility_owner_id;

select * from trustd.ut_financial_responsibility;

select distinct fr_type from trustd.ut_financial_responsibility order by 1;

select * from  trustd.ut_financial_responsibility where facility_id in (
select facility_id from trustd.ut_financial_responsibility  group by facility_id having count(*) > 1)
order by facility_id;
Self Insured
Guarantee
Trust Fund

select f.facility_id,
    (select 'Yes' from trustd.ut_financial_responsibility fr where fr_type = 'Guarantee' and fr.facility_id = f.facility_id) as "FinancialResponsibilityGuarantee"
from trustd.ut_facility f
where f.facility_id in (1722,1723,1724);
1722

 (select d.facility_id, c.* from trustd.ut_facility_operator c join 
    (select a.facility_operator_id, a.facility_id from trustd.ut_facility_oper_hist a join 
    (select facility_id, max(ut_facility_oper_hist_id) from trustd.ut_facility_oper_hist 
    where end_date is null group by facility_id) b on a.facility_id = b.facility_id)


(select facility_id, max(date_observed) as date_observed from trustd.ut_facility_oper_hist where end_date is null group by facility_id) a

select * from 
(select d.facility_id, c.* from trustd.ut_facility_operator c join 
                (select a.facility_operator_id, a.facility_id from trustd.ut_facility_oper_hist a join 
                (select facility_id, max(ut_facility_oper_hist_id) from trustd.ut_facility_oper_hist 
                where end_date is null group by facility_id) b on a.facility_id = b.facility_id) d on c.facility_operator_id = d.facility_operator_id) 
where facility_id = 23;
 
select c.facility_id, d.* from trustd.ut_facility_operator d join        
    (select a.facility_id, facility_operator_id from trustd.ut_facility_oper_hist a join         
        (select facility_id, max(ut_facility_oper_hist_id) as ut_facility_oper_hist_id 
         from trustd.ut_facility_oper_hist where end_date is null group by facility_id) b        
            on a.ut_facility_oper_hist_id = b.ut_facility_oper_hist_id) c on c.facility_operator_id = d.facility_operator_id
where c.facility_id = 23;

select * from trustd.ut_facility_oper_hist where facility_id = 23;

select * from trustd.ut_facility_operator where facility_operator_id in (16,17,18);

(select a.land_location_id, land_use_type_id from 
                (select land_location_id, max(date_observed) from trustd.ut_land_use_hist group by land_location_id) a 
                join trustd.ut_land_use_hist b on a.land_location_id = b.land_location_id) 
                
                select * from trustd.ut_facility where facility_id = 1130;
                
select * from  trustd.ut_land_use_hist where land_location_id      = 830     

select land_location_id, land_use_type_desc, rn from trustd.ut_land_use_type a join 
    (select land_location_id, land_use_id, land_use_type_id, row_number() over (partition by land_location_id order by date_observed) rn 
    from trustd.ut_land_use_hist where end_date is null) b on a.land_use_type_id = b.land_use_type_id
where land_location_id      = 830   ;

    select * from all_tab_cols where owner = 'TRUSTD' and lower(column_name) like lower('%pipe%repair%') and table_name like 'UT%' order by table_name;

select distinct MANIFOLDED_TO from trustd.UT_TANK_SYSTEM_COMP order by 1;

select * from trustd.ut_tank_system;

select distinct OBS_PIPE_REPAIRED from TRUSTD.UT_TANK_SYSTEM

select distinct cor_prot_comment from trustd.ut_tank_system order by 1;


select distinct closure_status_desc from trustd.ut_tank_system order by 1;
select distinct closure_status_desc from trustd.ut_tank_system order by 1;
Change in service
Tank closed in place
Tank removed
Tank removed from ground
change in service

select * from trustd.ut_tank_attribute_type;

select tank_system_id, count(*) from trustd.ut_tank_system_comp group by tank_system_id having count(*) = 1;

select count(*) from trustd.ut_tank_system where tank_system_id not in (select tank_system_id from trustd.ut_tank_system_comp);

select tank_system_id, count(*) num_compartments from trustd.ut_tank_system_comp group by tank_system_id

select * from  trustd.ut_tank_system_comp

select distinct obs_pipe_mat_desc from trustd.ut_tank_system order by 1;

select * from trustd.ut_substance_type;

select * from trustd.ut_tank_system_comp where substances like '%:%';


select distinct obs_overfill_protections from trustd.ut_tank_system;

select distinct obs_spill_preventions from trustd.ut_tank_system;


select * from trustd.ut_overfill_protection_type;

select * from trustd.ut_spill_prevention_type;

select * from trustd.ut_spill_prevention_type;
1	Double Walled
21	Double Walled with Interstitial Monitoring
41	Single Walled


select * from trustd.ut_release_detection_type;

select * from trustd.ut_release_event order by release_id, release_event_type_id;

select * from trustd.ut_release_event_type;

select * from trustd.ut_release_priority;

select * from all_tab_cols where owner = 'TRUSTD' and lower(column_name) like lower('%insp%') and table_name like 'UT%' order by table_name;

select tank_system_id, LAST_MONTH_WALK_INSP_DT, LAST_ANNUAL_WALK_INSP_DT from trustd.ut_tank_system where LAST_MONTH_WALK_INSP_DT is not null or LAST_ANNUAL_WALK_INSP_DT is not null;

select * from trustd.ut_release;

select tank_system_id, regexp_substr(substances,'[^:]+',1,level) from trustd.ut_tank_system_comp where tank_system_id = 2196
connect by tank_system_id = 2196
where tank_system_id = 2196;

select regexp_substr('SMITH,ALLEN,WARD,JONES','[^,]+', 1, level) from dual
connect by regexp_substr('SMITH,ALLEN,WARD,JONES', '[^,]+', 1, level) is not null;

select trim(column_value) col1 from (select '1,2' str from dual), xmltable(('"' || replace(str, ',', '","') || '"'));


select tank_system_id, trim(column_value) substance 
from (select tank_system_id, replace(substances,':',',') substances from trustd.ut_tank_system_comp), 
    xmltable(('"' || replace(substances, ',', '","') || '"'))




select tank_system_id, trim(column_value) substance 
from (select tank_system_id, replace(substances,':',',') substances from trustd.ut_tank_system_comp), 
    xmltable(('"' || replace(substances, ',', '","') || '"'))


select case when str like '%:%' then substr(str,1,instr(str,':')-1) else str end from (select '1:2' str from dual)

select * from trustd.ut_tank_attribute_type;

select * from trustd.ut_piping_attribute_type;

select * from trustd.ut_piping_delivery_type;

select * from trustd.ut_tank_system where obs_piping_deliveries like '%:%'; 

select distinct lower(pipe_type_desc) from trustd.ut_tank_system order by 1;

select * from trustd.ut_spill_prevention_type;
1	Double Walled
21	Double Walled with Interstitial Monitoring
41	Single Walled

select distinct obs_spill_preventions from trustd.ut_tank_system order by 1;



select tank_system_id, case when tank_attributes = 12 then 'Double' when tank_attributes = 41 then 'Triple' when tank_attributes = 43 then 'Single' end as "TankWallType"
from (select tank_system_id, case when tank_attributes like '%:%' then substr(tank_attributes,1,instr(tank_attributes,':')-1) else tank_attributes end as tank_attributes
from trustd.ut_tank_system) where tank_attributes in (12,41,43)

select tank_system_id, 
    case when tank_attributes = 1 then 'Asphalt Coated or Bare Steel' 
         when tank_attributes in (2,3,18) then 'Cathodically Protected Steel (without coating)' 
         when tank_attributes in (4,5) then 'Coated and Cathodically Protected Steel'
         when tank_attributes = 6 then 'Composite/Clad (Steel w/Fiberglass Reinforced Plastic)'
         when tank_attributes = 7 then 'Concrete'
         when tank_attributes = 8 then 'Fiberglass Reinforced Plastic'
         when tank_attributes in (9,21) then 'Jacketed Steel'
         when tank_attributes = 8 then 'Fiberglass Reinforced Plastic'
         when tank_attributes = 19 then 'Epoxy Coated Steel' end as "MaterialDescription"
from (select tank_system_id, case when tank_attributes like '%:%' then substr(tank_attributes,1,instr(tank_attributes,':')-1) else tank_attributes end as tank_attributes
from trustd.ut_tank_system) where tank_attributes in (1,2,3,4,5,6,7,8,9,18,19,21)
    
select tank_system_id, obs_tank_mods_desc, tank_attributes
from trustd.ut_tank_system where lower(obs_tank_mods_desc) not like 'double%' and tank_attributes  like '%12%';

1	Manual Tank Gauging	ManualTankGauging
2	Tank Tightness Testing	TankTightnessTesting
3	Inventory Control	
4	Automatic Tank Gauging	AutomaticTankGauging
5	Vapor Monitoring	VaporMonitoring
6	Groundwater Monitoring	GroundwaterMonitoring
7	Interstitial Monitoring	
8	Statistical Inventory Reconciliation	StatisticalInventoryReconciliation



select tank_system_id, 'Yes' as "ManuaTankGauging"
from (select tank_system_id, case when obs_tank_release_detections like '%:%' then substr(obs_tank_release_detections,1,instr(obs_tank_release_detections,':')-1) else obs_tank_release_detections end as obs_tank_release_detections
     from trustd.ut_tank_system) where obs_tank_release_detections = 1

7	Interstitial Monitoring	                Interstitial Monitoring
8	Statistical Inventory Reconciliation	SIR
10	Line Tightness Testing	                Line Test
6	Groundwater Monitoring	                GW Monitoring
5	Vapor Monitoring	                    Vapor Monitoring


select distinct obs_pipe_release_detections from trustd.ut_tank_system where obs_pipe_release_detections like '%:%' order by 1;

select tank_system_id, 'Yes' as "ElectronicLineLeakDetector"
from (select tank_system_id, case when obs_pipe_release_detections like '%:%' then substr(obs_pipe_release_detections,1,instr(obs_pipe_release_detections,':')-1) else obs_pipe_release_detections end as obs_pipe_release_detections
     from trustd.ut_tank_system) where obs_pipe_release_detections = 21


select obs_pipe_release_detections, count(*) from (
select case when obs_pipe_release_detections like '%:%' then substr(obs_pipe_release_detections,1,instr(obs_pipe_release_detections,':')-1) else obs_pipe_release_detections end as obs_pipe_release_detections
from trustd.ut_tank_system) group by obs_pipe_release_detections order by 1;



select tank_system_id, 
    case when obs_piping_attributes = 1 then 'Steel' 
         when obs_piping_attributes = 2 then 'Galvanized Steel' 
         when obs_piping_attributes = 3 then 'Fiberglass Reinforced Plastic' 
         when obs_piping_attributes in (4,41) then 'Flex Piping' 
         when obs_piping_attributes = 5 then 'Copper' 
         when obs_piping_attributes = 13 then 'No Piping' end as "PipingMaterialDescription"
from (select tank_system_id, case when obs_piping_attributes like '%:%' then substr(obs_piping_attributes,1,instr(obs_piping_attributes,':')-1) else obs_piping_attributes end as obs_piping_attributes
from trustd.ut_tank_system) where obs_piping_attributes in (1,2,3,4,5,13,41)

select tank_system_id, 
    case when obs_piping_deliveries in (1,2,23) then 'Suction' 
         when obs_piping_deliveries = 3 then 'Pressure' 
         when obs_piping_deliveries = 4 then 'Non-operational ( e.g., fill line, vent line, gravity)' 
         when obs_piping_deliveries in (5,21,22) then 'Other' 
         when obs_piping_deliveries = 6 then 'Unknown' end as "PipingStyle"
from (select tank_system_id, case when obs_piping_deliveries like '%:%' then substr(obs_piping_deliveries,1,instr(obs_piping_deliveries,':')-1) else obs_piping_deliveries end as obs_piping_deliveries
from trustd.ut_tank_system) where obs_piping_deliveries in (1,2,3,4,5,6,21,22,23)








select *
from trustd.ut_facility_owner_hist a join trustd.ut_legally_responsible_entity b 
    on a.responsible_entity_id = b.responsible_entity_id
and trunc(sysdate) between trunc(coalesce(a.start_date,sysdate)) and trunc(coalesce(a.end_date,sysdate));
