


/*********** v_ust_release ***********/
--There are 53 rows in dc_release.v_ust_release that do not exist in public.v_ust_release

select * from dc_release.v_ust_release a
where not exists
	(select 1 from public.v_ust_release b
	where a.release_id = b."ReleaseID")
order by a.release_id;

select * from release_control where organization_id = 'DC'

select count(*) from dc_release.v_ust_release 

select count(*) 
from v_ust_release where release_control_id = 18;



--View definition for dc_release.v_ust_release:
 SELECT DISTINCT (x."Facility ID")::text AS facility_id,
        CASE
            WHEN ((x."LUSTID" = 2017009) AND (x."Facility ID" = 5005491)) THEN '2025005'::text
            ELSE (x."LUSTID")::text
        END AS release_id,
    x."Federally Reportable Release" AS federally_reportable_release,
    x."Site Name" AS site_name,
    x."Site Address" AS site_address,
    x."Site City" AS site_city,
    (x."Zipcode")::text AS zipcode,
    s.state,
    ft.facility_type_id,
    (x."EPARegion")::integer AS epa_region,
    x."Latitude" AS latitude,
    x."Longitude" AS longitude,
    cs.coordinate_source_id,
    rs.release_status_id,
    (x."Reported Date")::date AS reported_date,
    (x."NFADate")::date AS nfa_date,
    x."Media Impacted Soil" AS media_impacted_soil,
    x."Media Impacted Groundwater" AS media_impacted_groundwater,
    x."Media Impacted Surface Water" AS media_impacted_surface_water,
    x."Military Do DSite" AS military_dod_site
   FROM (((((dc_release.release x
     LEFT JOIN dc_release.v_state_xwalk s ON ((x."State" = (s.organization_value)::text)))
     LEFT JOIN dc_release.erg_facility_types eft ON (((x."Facility ID")::text = (eft.facility_id)::text)))
     LEFT JOIN dc_release.v_facility_type_xwalk ft ON ((eft.facility_type1 = (ft.organization_value)::text)))
     LEFT JOIN dc_release.v_coordinate_source_xwalk cs ON ((x."Coordinate Source" = (cs.organization_value)::text)))
     LEFT JOIN dc_release.v_release_status_xwalk rs ON ((x."LUSTStatus" = (rs.organization_value)::text)))
  WHERE (NOT ((x."LUSTID")::text IN ( SELECT erg_unregulated_releases.release_id
           FROM dc_release.erg_unregulated_releases)));


/*********** v_ust_release_substance ***********/
--There are 68 rows in dc_release.v_ust_release_substance that do not exist in public.v_ust_release_substance

select * from dc_release.v_ust_release_substance a
where not exists
	(select 1 from public.v_ust_release_substance b join public.substances c on b."SubstanceReleased" = c.substance
	where a.release_id = b."ReleaseID" and a.substance_id = c."substance_id")
order by a.release_id,a.substance_id;

--View definition for dc_release.v_ust_release_substance:
 SELECT DISTINCT (x."LUSTID")::text AS release_id,
    s.substance_id,
    x."Quantity Released1" AS quantity_released,
    x."Unit1" AS unit
   FROM (dc_release.release x
     LEFT JOIN dc_release.v_substance_xwalk s ON ((x."Substance Released1" = (s.organization_value)::text)))
  WHERE ((x."Substance Released1" IS NOT NULL) AND (NOT ((x."LUSTID")::text IN ( SELECT erg_unregulated_releases.release_id
           FROM dc_release.erg_unregulated_releases))));


/*********** v_ust_release_source ***********/
--There are 68 rows in dc_release.v_ust_release_source that do not exist in public.v_ust_release_source

select * from dc_release.v_ust_release_source a
where not exists
	(select 1 from public.v_ust_release_source b join public.sources c on b."SourceOfRelease" = c.source
	where a.release_id = b."ReleaseID" and a.source_id = c."source_id")
order by a.release_id,a.source_id;

--View definition for dc_release.v_ust_release_source:
 SELECT DISTINCT (x."LUSTID")::text AS release_id,
    s.source_id
   FROM (dc_release.release x
     LEFT JOIN dc_release.v_source_xwalk s ON ((x."Source Of Release1" = (s.organization_value)::text)))
  WHERE (NOT ((x."LUSTID")::text IN ( SELECT erg_unregulated_releases.release_id
           FROM dc_release.erg_unregulated_releases)));


/*********** v_ust_release_cause ***********/
--There are 68 rows in dc_release.v_ust_release_cause that do not exist in public.v_ust_release_cause

select * from dc_release.v_ust_release_cause a
where not exists
	(select 1 from public.v_ust_release_cause b join public.causes c on b."CauseOfRelease" = c.cause
	where a.release_id = b."ReleaseID" and a.cause_id = c."cause_id")
order by a.release_id,a.cause_id;

--View definition for dc_release.v_ust_release_cause:
 SELECT DISTINCT (x."LUSTID")::text AS release_id,
    c.cause_id
   FROM (dc_release.release x
     LEFT JOIN dc_release.v_cause_xwalk c ON ((x."Cause Of Release1" = (c.organization_value)::text)))
  WHERE (NOT ((x."LUSTID")::text IN ( SELECT erg_unregulated_releases.release_id
           FROM dc_release.erg_unregulated_releases)));