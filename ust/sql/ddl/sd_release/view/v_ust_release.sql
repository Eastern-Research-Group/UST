create or replace view "sd_release"."v_ust_release" as
 SELECT DISTINCT (x.siteid)::character varying(50) AS facility_id,
    (x.id)::character varying(50) AS release_id,
        CASE (x.regulated)::character varying(7)
            WHEN 'true'::text THEN 'Yes'::text
            ELSE 'No'::text
        END AS federally_reportable_release,
    (x.site_name)::character varying(200) AS site_name,
    (x.street)::character varying(100) AS site_address,
    (x.city)::character varying(100) AS site_city,
    (x.zip_code)::character varying(10) AS zipcode,
    (x.county)::character varying(100) AS county,
    ft.facility_type_id,
    (x.latitude)::double precision AS latitude,
    (x.longitude)::double precision AS longitude,
    rs.release_status_id,
    (x.date_rep)::date AS reported_date,
    (x.date_close)::date AS nfa_date,
    8 AS epa_region,
    'SD'::text AS state
   FROM ((sd_release.spill_reports_all x
     LEFT JOIN sd_release.v_release_status_xwalk rs ON (((x.status)::text = (rs.organization_value)::text)))
     LEFT JOIN sd_release.v_facility_type_xwalk ft ON (((x.proptype)::text = (ft.organization_value)::text)))
  WHERE (((x.sor_type)::text = 'UST'::text) AND ((x.regulated)::text = 'true'::text) AND ((x.cause_type)::text <> ALL ((ARRAY['no Release'::character varying, 'No Release'::character varying])::text[])))
UNION
 SELECT DISTINCT (x.siteid)::character varying(50) AS facility_id,
    (x.id)::character varying(50) AS release_id,
        CASE (x.regulated)::character varying(7)
            WHEN 'true'::text THEN 'Yes'::text
            ELSE 'No'::text
        END AS federally_reportable_release,
    (x.site_name)::character varying(200) AS site_name,
    (x.street)::character varying(100) AS site_address,
    (x.city)::character varying(100) AS site_city,
    (x.zip_code)::character varying(10) AS zipcode,
    (x.county)::character varying(100) AS county,
    ft.facility_type_id,
    (x.latitude)::double precision AS latitude,
    (x.longitude)::double precision AS longitude,
    rs.release_status_id,
    (x.date_rep)::date AS reported_date,
    (x.date_close)::date AS nfa_date,
    8 AS epa_region,
    'SD'::text AS state
   FROM ((sd_release.spill_reports_all x
     LEFT JOIN sd_release.v_release_status_xwalk rs ON (((x.status)::text = (rs.organization_value)::text)))
     LEFT JOIN sd_release.v_facility_type_xwalk ft ON (((x.proptype)::text = (ft.organization_value)::text)))
  WHERE (((x.sor_type)::text = 'UST'::text) AND ((x.regulated)::text = 'true'::text) AND ((x.cause_type)::text = ANY ((ARRAY['no Release'::character varying, 'No Release'::character varying])::text[])) AND ((x.site_type)::text = 'ATP'::text));