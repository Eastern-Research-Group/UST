create table ia_ust.erg_tank_status
as select "tankID", y.compartment_status 
from
	(select a."tankID", min(e.status_hierarchy) as status_hierarchy
	from ia_ust.tbltankcompartment a 
		join ia_ust.trelcomptostatus b on a."tankCompartmentID" = b."tankCompartmentID" 
		join ia_ust.tlkcompstatus c on b."compStatusID" = c."compStatusID" 
		left join 
			(select organization_value, epa_value from public.v_ust_element_mapping
			where ust_control_id = 32 and epa_column_name ='compartment_status_id') d 
				on c."statusDescription" = d.organization_value
		left join public.compartment_statuses e on d.epa_value = e.compartment_status 
	where b."statusEndDate" is null and epa_value is not null
	group by a."tankID") x 
	join public.compartment_statuses y on x.status_hierarchy = y.status_hierarchy
order by 1;
