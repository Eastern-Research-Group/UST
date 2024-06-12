ts
obs_piping_attributes
obs_piping_deliveries
ut_tank_system


select * from all_tab_cols a where table_name like 'UT%' and column_name like 'RESPONSIBLE_ENTITY%'
and exists
    (select 1 from all_tab_cols b where a.table_name = b.table_name and b.column_name = 'FACILITY_ID');

select * From trustd.UT_FACILITY_OWNER_HIST where end_date is not null;


(select c.facility_id, d.* from trustd.ut_facility_owner d join        
    (select a.facility_id, facility_owner_id from trustd.ut_facility_owner_hist a join         
        (select facility_id, max(ut_facility_owner_hist_id) as ut_facility_owner_hist_id 
         from trustd.ut_facility_owner_hist where end_date is null group by facility_id) b        
            on a.ut_facility_owner_hist_id = b.ut_facility_owner_hist_id) c on c.facility_owner_id = d.facility_owner_id) fo
            
select facility_id, date_observed from trustd.ut_facility_owner_hist where facility_id in
    (select facility_id from trustd.ut_facility_owner_hist group by facility_id having count(*) > 1)
order by 1, 2;
            
            
            
(select listagg(rei.responsible_entity_name, ',') within group (order  by rei.responsible_entity_name) 
        from ut_facility_owner_hist foh
           , ut_legally_responsible_entity rei
       where foh.facility_id = fac.facility_id
         and rei.responsible_entity_id = foh.responsible_entity_id
         and trunc(sysdate) between trunc(coalesce(foh.start_date,sysdate)) and trunc(coalesce(foh.end_date,sysdate))
) as facility_owner


select *
from ut_facility_owner_hist a join ut_legally_responsible_entity b on a.responsible_entity_id = b.responsible_entity_id
and trunc(sysdate) bewteen trunc(coalesce(a.start_date,sysdate)) and trunc(coalesce(a.end_date,sysdate));