----------------------------------------------------------------------------------------------------------

create view ma_release.v_ust_release as
select distinct
    "LUSTID"::character varying(50) as release_id, 
    "FederallyReportableRelease"::character varying(7) as federally_reportable_release, 
    "SiteName"::character varying(200) as site_name, 
    "SiteAddress"::character varying(100) as site_address, 
    "SiteCity"::character varying(100) as site_city, 
    "Zipcode"::character varying(10) as zipcode, 
    "County"::character varying(100) as county, 
    state as state, 
    "EPARegion"::integer as epa_region, 
    facility_type_id as facility_type_id, 
    "latitude"::double precision as latitude, 
    "longitude"::double precision as longitude, 
    coordinate_source_id as coordinate_source_id, 
    release_status_id as release_status_id, 
    "ReportedDate"::date as reported_date, 
    "NFADate"::date as nfa_date, 
    "MediaImpactedSoil"::character varying(3) as media_impacted_soil, 
    "MediaImpactedGroundwater"::character varying(3) as media_impacted_groundwater, 
    "MediaImpactedSurfaceWater"::character varying(3) as media_impacted_surface_water, 
    release_discovered_id as release_discovered_id, 
    "ClosedWithContamination"::character varying(7) as closed_with_contamination, 
    "MilitaryDODSite"::character varying(7) as military_dod_site 
from ma_release."vw_releases" a
    left join ma_release.v_coordinate_source_xwalk b on a."CoordinateSource" = b.organization_value
    left join ma_release.v_facility_type_xwalk c on a."FACILITY TYPE" = c.organization_value
    left join ma_release.v_release_discovered_xwalk d on a."HowReleaseDetected" = d.organization_value
    left join ma_release.v_release_status_xwalk e on a."LUSTStatus" = e.organization_value
    left join ma_release.v_state_xwalk f on a."State" = f.organization_value
;
----------------------------------------------------------------------------------------------------------

create view ma_release.v_ust_release_cause as
select distinct
    cause_id as cause_id, 
    "LUSTID"::character varying(50) as release_id 
from ma_release."vw_release_causes" a
    left join ma_release.v_cause_xwalk b on a."cause" = b.organization_value
;
----------------------------------------------------------------------------------------------------------

create view ma_release.v_ust_release_corrective_action_strategy as
select distinct
    corrective_action_strategy_id as corrective_action_strategy_id, 
    "LUSTID"::character varying(50) as release_id 
from ma_release."vw_release_corrective_action_strategy" a
    left join ma_release.v_corrective_action_strategy_xwalk b on a."corrective_action_strategy" = b.organization_value
;
----------------------------------------------------------------------------------------------------------

create view ma_release.v_ust_release_source as
select distinct
    source_id as source_id, 
    "LUSTID"::character varying(50) as release_id 
from ma_release."vw_release_sources" a
    left join ma_release.v_source_xwalk b on a."SourceOfRelease" = b.organization_value
;
----------------------------------------------------------------------------------------------------------




CREATE OR REPLACE VIEW ma_release.vw_release_substances
AS SELECT DISTINCT a."LUSTID",
    a.substance_released,
    sum(a.quantity_released) as quantity_released,
    a.unit
   FROM ( SELECT releases."LUSTID",
            releases."SubstanceReleased1" AS substance_released,
                CASE
                    WHEN releases."QuantityReleased1" = 'UNKNOWN'::text THEN NULL::double precision
                    ELSE replace(releases."QuantityReleased1", '"'::text, ''::text)::double precision
                END AS quantity_released,
            releases."Unit1" AS unit
           FROM ma_release.releases
          WHERE releases."SubstanceReleased1" IS NOT NULL
        UNION ALL
         SELECT releases."LUSTID",
            releases."SubstanceReleased2",
            releases."QuantityReleased2",
            releases."Unit2"
           FROM ma_release.releases
          WHERE releases."SubstanceReleased2" IS NOT NULL
        UNION ALL
         SELECT releases."LUSTID",
            releases."SubstanceReleased3",
            releases."AmountReleased3",
            releases."Unit3"
           FROM ma_release.releases
          WHERE releases."SubstanceReleased3" IS NOT NULL
        UNION ALL
         SELECT releases."LUSTID",
            releases."SubstanceReleased4",
            releases."AmountReleased4",
            releases."Unit4"
           FROM ma_release.releases
          WHERE releases."SubstanceReleased4" IS NOT NULL
        UNION ALL
         SELECT historical_releases."LUSTID",
            historical_releases."SubstanceReleased1" AS substance_released,
            historical_releases."QuantityReleased1" AS quantity_released,
            historical_releases."Unit1" AS unit
           FROM ma_release.historical_releases
          WHERE historical_releases."SubstanceReleased1" IS NOT NULL
        UNION ALL
         SELECT historical_releases."LUSTID",
            historical_releases."SubstanceReleased2",
            historical_releases."QuantityReleased2",
            historical_releases."Unit2"::text AS "Unit2"
           FROM ma_release.historical_releases
          WHERE historical_releases."SubstanceReleased2" IS NOT NULL
        UNION ALL
         SELECT historical_releases."LUSTID",
            historical_releases."SubstanceReleased3",
            historical_releases."AmountReleased3",
            historical_releases."Unit3"::text AS "Unit3"
           FROM ma_release.historical_releases
          WHERE historical_releases."SubstanceReleased3" IS NOT NULL) a
group by a."LUSTID", substance_released, unit;


create or replace view ma_release.vw_duplicate_substances as 
select distinct a."LUSTID", a.substance_released
from  ma_release.vw_release_substances a join  ma_release.vw_release_substances b 
 on a."LUSTID" = b."LUSTID" and a.substance_released = b.substance_released 
 and (a.quantity_released < b.quantity_released
 	or (a.quantity_released is null and b.quantity_released is not null)
 	or (a.quantity_released is not null and b.quantity_released is null))
 	union all 
  select '2-0019186', 'Petroleum product';
 	
 select * from ma_release.vw_release_substances where "LUSTID" = '2-0019186'
 
drop view  ma_release.v_ust_release_substance
create or replace view ma_release.v_ust_release_substance as
select distinct
	 a."LUSTID"::character varying(50) as release_id ,
    substance_id as substance_id, 
    case when c."LUSTID" is not null then null else "quantity_released"::double precision end as quantity_released, 
    case when c."LUSTID" is not null then null else "unit"::character varying(20) end as unit 
from ma_release."vw_release_substances" a
    left join ma_release.v_substance_xwalk b on a."substance_released" = b.organization_value
    left join  ma_release.vw_duplicate_substances c on a."LUSTID" = c."LUSTID" and a.substance_released = c.substance_released
;

select * from ma_release.vw_release_substances where "LUSTID" = '1-0001063'
1-0001063	Other	29.0	UG/M3
1-0001063	Petroleum product	651.0	UG/M3
1-0001063	Petroleum product	6260.0	UG/M3
1-0001063	Petroleum product	9100.0	UG/M3

select * from ma_release.releases where "LUSTID" = '1-0001063'


select * from ma_release.historical_releases  where "LUSTID" = '1-0001063'


select * from public.release_view_key_columns 
				  where view_name = 'v_ust_release_substance' order by sort_order

select release_id, substance_id, count(*) 
from ma_release.v_ust_release_substance 
group by release_id, substance_id
having count(*) > 1;

1-0010149	46	2
2-0019186	44	2
3-0032379	24	2


select * from  ma_release.v_ust_release_substance
where release_id in ( '2-0019186')
order by 1;


				  
				  
----------------------------------------------------------------------------------------------------------

select * from lock_monitor;