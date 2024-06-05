--run from the ust_va schema and assumes the ustpipematerials, usttankpipereleasedetection, and tanks tables have been reloaded with fresh data.


--remove existing data in ust_piping
delete from ust_piping where ust_compartment_id in (select ust_compartment_id from ust_compartment where ust_tank_id in (select ust_tank_id from public.ust_tank where ust_facility_id in (select ust_facility_id from ust_facility where ust_control_id = 8)));

--remove a few bad records with null index (unique IDs) 
delete from va_ust.ustpipematerials where index is null;


insert
	into
	ust_piping(ust_compartment_id,
	piping_id,
	piping_style_id,
	piping_material_frp,
	piping_material_gal_steel,
	piping_material_copper,
	piping_material_flex,
	piping_material_other,
	piping_material_unknown,
	piping_line_leak_detector,
	piping_automated_intersticial_monitoring,
	piping_groundwater_monitoring,
	piping_vapor_monitoring,
	piping_statistical_inventory_reconciliation,
	pipe_secondary_containment_other)
select
	*
from
	vw_va_ust_pipe;

commit;


/*select * from v_ust_facility_type_mapping where ust_control_id='8';
select * from v_ust_owner_type_mapping where ust_control_id='8';
select * from v_ust_tank_status_mapping where ust_control_id='8';
select * from v_ust_tank where  ust_control_id = 8;*/