--run from the ust_va schema and assumes the tanks table has been reloaded with fresh data.


--remove existing data in ust_tank
delete from public.ust_tank where ust_facility_id in (select ust_facility_id from ust_facility where ust_control_id = 8);


--remove a few bad records with null index (unique IDs) 
delete from va_ust.tanks where index is null;

--update some bad dates that got imported using string field types
update va_ust.tanks  set install_date = null where install_date = '';
update va_ust.tanks  set date_closed = null where date_closed = '';



insert into ust_tank (ust_facility_id,tank_id,tank_name,tank_status_id,federally_regulated,multiple_tanks,tank_closure_date, tank_installation_date, emergency_generator)
select  * 
from vw_va_ust_tank;

commit;

--select * from public.ust_tank where ust_facility_id in (select ust_facility_id from ust_facility where ust_control_id = 8);