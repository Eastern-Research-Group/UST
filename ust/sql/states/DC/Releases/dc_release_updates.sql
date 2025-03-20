select "FACILITYID", "FacilityType1", "OwnerType"
from dc_ust.facility f
where f."FACILITYID" in (select r."Facility ID" from dc_release."release" r where r."Facility Type" = 'Other')

create or replace view dc_release.erg_facility_types as
	select distinct x."FACILITYID",
	
	from dc_release.release x
		left join (select "FACILITYID", "FacilityType1", "OwnerType"
			from dc_releaseease.facility f)	