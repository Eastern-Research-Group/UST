


/*********** v_ust_release ***********/


--View definition for sd_release.v_ust_release:
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
  WHERE (NOT (((x.id)::character varying(50))::text IN ( SELECT erg_unregulated_releases.release_id
           FROM sd_release.erg_unregulated_releases)));;




/*********** v_ust_release_substance ***********/


--View definition for sd_release.v_ust_release_substance:
 SELECT DISTINCT (x.id)::character varying(50) AS release_id,
    s.substance_id,
    (x.amount)::double precision AS quantity_released,
    (x.units)::character varying(20) AS unit
   FROM ((sd_release.spill_reports_all x
     JOIN sd_release.erg_material_datarows_deagg d ON (((x.id)::text = (d.id)::text)))
     JOIN sd_release.v_substance_xwalk s ON (((d.material)::text = (s.organization_value)::text)))
  WHERE ((s.substance_id IS NOT NULL) AND (NOT (((x.id)::character varying(50))::text IN ( SELECT erg_unregulated_releases.release_id
           FROM sd_release.erg_unregulated_releases))) AND (NOT (EXISTS ( SELECT 1
           FROM sd_release.erg_unregulated_substances unregsub
          WHERE ((((d.id)::character varying(50))::text = (unregsub.release_id)::text) AND ((d.material)::text = (unregsub.organization_substance)::text))))));;




/*********** v_ust_release_cause ***********/


--View definition for sd_release.v_ust_release_cause:
 SELECT DISTINCT b.cause_id,
    (x.id)::character varying(50) AS release_id
   FROM (sd_release.spill_reports_all x
     JOIN sd_release.v_cause_xwalk b ON (((x.cause_type)::text = (b.organization_value)::text)))
  WHERE (NOT (((x.id)::character varying(50))::text IN ( SELECT erg_unregulated_releases.release_id
           FROM sd_release.erg_unregulated_releases)));;

