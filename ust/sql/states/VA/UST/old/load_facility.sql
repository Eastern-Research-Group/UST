--run from the ust_va schema and assumes the registered_petroleum_tank_facilities table has been reloaded with fresh data.

--remove existing data in ust_facility
delete from public.ust_facility where ust_control_id = 8;

--remove AST data
delete from va_ust."registered_petroleum_tank_facilities" where "FAC_ACTIVE_UST" = '0' and "FAC_INACTIVE_UST" = '0';

ANALYZE va_ust."registered_petroleum_tank_facilities";

--query mapping tables for this control ID
--select * from public.ust_element_mapping where ust_control_id =8;
--select * from public.v_ust_available_mapping where ust_control_id =8;

insert
	into
	public.ust_facility(facility_id,
	owner_type_id,
	facility_name,
	facility_type1,
	facility_address1,
	facility_address2,
	facility_city,
	facility_zip_code,
	facility_state,
	facility_latitude,
	facility_longitude,
	facility_owner_company_name,
	ust_control_id,
	facility_epa_region) 
select
	*
from
	vw_va_ust_facility;

commit;


--select * from ust_facility where ust_control_id =8;

