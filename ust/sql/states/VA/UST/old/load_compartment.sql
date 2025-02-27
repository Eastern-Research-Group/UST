--run from the ust_va schema and assumes the usttankpipereleasedetection and tanks tables have been reloaded with fresh data.

--remove existing data in ust_compartment
delete from ust_compartment where ust_tank_id in (select ust_tank_id from public.ust_tank where ust_facility_id in (select ust_facility_id from ust_facility where ust_control_id = 8));

--remove a few bad records with null index (unique IDs) 
delete from va_ust.usttankpipereleasedetection where index is null;

update tanks set capacity=null where capacity = '';

insert into public.ust_compartment (ust_tank_id,
compartment_id,
compartment_status_id,
compartment_capacity_gallons,
overfill_prevention_ball_float_valve,
overfill_prevention_flow_shutoff_device,
overfill_prevention_high_level_alarm,
overfill_prevention_other,
overfill_prevention_not_required,
spill_bucket_installed,
spill_prevention_other,
spill_prevention_not_required,
tank_automatic_tank_gauging_release_detection,
automatic_tank_gauging_continuous_leak_detection,
tank_manual_tank_gauging,
tank_statistical_inventory_reconciliation,
tank_tightness_testing,
tank_inventory_control,
tank_groundwater_monitoring,
tank_vapor_monitoring
)
select * from vw_va_ust_compartment 
;

commit;


--select * from ust_compartment where ust_tank_id in (select ust_tank_id from public.ust_tank where ust_facility_id in (select ust_facility_id from ust_facility where ust_control_id = 8));

