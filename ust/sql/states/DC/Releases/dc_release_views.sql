create or replace view dc_release.v_ust_release
as select distinct x."Facility ID"::text as facility_id,
	case 
		when x."LUSTID" = 2017009 and x."Facility ID" = 5005491 then '2025005'
		else x."LUSTID"::text
	end as release_id,
	x."Federally Reportable Release" as federally_reportable_release,
	x."Site Name" as site_name,
	x."Site Address" as site_address,
	x."Site City" as site_city,
	x."Zipcode"::text as zipcode,
	s.state,
	ft.facility_type_id,
	x."EPARegion"::int4 as epa_region,
	x."Latitude" as latitude,
	x."Longitude" as longitude,
	cs.coordinate_source_id,
	rs.release_status_id,
	x."Reported Date"::date as reported_date,
	x."NFADate"::date as nfa_date,
	x."Media Impacted Soil" as media_impacted_soil,
	x."Media Impacted Groundwater" as media_impacted_groundwater,
	x."Media Impacted Surface Water" as media_impacted_surface_water,
	x."Military Do DSite" as military_dod_site
from dc_release."release" x
	left join dc_release.v_state_xwalk s on x."State" = s.organization_value::text 
	left join dc_release.v_facility_type_xwalk ft on x."Facility Type" = ft.organization_value::text
	left join (select "FACILITYID", "FacilityType1", "OwnerType"
		from dc_ust.facility) f on x."Facility ID" = f."FACILITYID"
	left join dc_release.v_coordinate_source_xwalk cs on x."Coordinate Source" = cs.organization_value::text
	left join dc_release.v_release_status_xwalk rs on x."LUSTStatus" = rs.organization_value::text;
	
create or replace view dc_release.v_ust_release_substance
as select distinct x."LUSTID"::text as release_id,
	case 
		when s.substance_id is null then 47::int4
		else s.substance_id
	end as substance_id,
	x."Quantity Released1"::float8 as quantity_released,
	x."Unit1" as unit
from dc_release."release" x
	left join dc_release.v_substance_xwalk s on x."Substance Released1" = s.organization_value::text;
	
create or replace view dc_release.v_ust_release_source
as select distinct x."LUSTID"::text as release_id,
	s.source_id
from dc_release."release" x
	left join dc_release.v_source_xwalk s on x."Source Of Release1" = s.organization_value::text;
	
create or replace view dc_release.v_ust_release_cause
as select distinct x."LUSTID"::text as release_id,
c.cause_id
from dc_release."release" x
	left join dc_release.v_cause_xwalk c on x."Cause Of Release1" = c.organization_value::text;
	
create or replace view dc_release.v_ust_release_corrective_action_strategy
as select distinct x."LUSTID"::text as release_id,
case 
	when cas.corrective_action_strategy_id is null then 31::int4 
	else cas.corrective_action_strategy_id
end as corrective_action_strategy_id,
x."Corrective Action Strategy1Start Date"::date as corrective_action_strategy_start_date
from dc_release."release" x
	left join dc_release.v_corrective_action_strategy_xwalk cas on x."Corrective Action Strategy1" = cas.organization_value::text