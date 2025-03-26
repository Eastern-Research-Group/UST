CREATE OR REPLACE VIEW ga_release.v_ust_release
AS SELECT DISTINCT x."FacilityID"::character varying(50) AS facility_id,
    	case 
    		when x."LUSTID" is not null then x."LUSTID"::character varying(50)
    		else b.release_id
    	end as release_id,
    x."SiteName"::character varying(200) AS site_name,
    x."SiteAddress"::character varying(100) AS site_address,
    x."SiteCity"::character varying(100) AS site_city,
    x."Zipcode"::character varying(10) AS zipcode,
    x."County"::character varying(100) AS county,
    s.state,
    	case 
    		when x."EPARegion" = 'Region 4'::text then '4'::int
    		else null
    	end as epa_region,
    ft.facility_type_id,
    x."Latitude" AS latitude,
    x."Longitude" AS longitude,
    rs.release_status_id,
    x."ReportedDate"::date AS reported_date,
    x."NFADate"::date AS nfa_date,
        CASE
            WHEN x."MilitaryDoDSite" = 'YES' THEN 'Yes'::text
            WHEN x."MilitaryDoDSite" = 'NO'::text THEN 'No'::text
            ELSE null
        END AS military_dod_site
   FROM ga_release.release x
     LEFT JOIN ga_release.v_state_xwalk s ON x."State" = s.organization_value::text
     LEFT JOIN ga_release.v_release_status_xwalk rs ON x."LUSTStatus" = rs.organization_value::text
     LEFT JOIN ga_release.v_facility_type_xwalk ft ON x."FacilityType" = ft.organization_value::text
     left join ga_release.erg_release_id b on x."FacilityID" = b.facility_id;