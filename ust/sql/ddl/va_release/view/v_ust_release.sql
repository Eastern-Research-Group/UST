create or replace view "va_release"."v_ust_release" as
 SELECT DISTINCT (d.rst_fac_id)::character varying(50) AS facility_id,
    (b.pollution_complaint_pc_number)::character varying(50) AS release_id,
    (b.federally_regulated_ust)::character varying(7) AS federally_reportable_release,
    (b.site_name_)::character varying(200) AS site_name,
    (b.address_1_)::character varying(100) AS site_address,
    (b.city_)::character varying(100) AS site_city,
    (b.zip_5)::character varying(10) AS zipcode,
    (b.county)::character varying(100) AS county,
    (d.lat)::double precision AS latitude,
    (d.lon)::double precision AS longitude,
    rs.release_status_id,
    (b.release_reported_date)::date AS reported_date,
    (b.case_closed_date)::date AS nfa_date,
    3 AS epa_region,
    'VA'::text AS state
   FROM ((((va_release.release_txt b
     LEFT JOIN va_release.petroleum_release_sites d ON (((b.pollution_complaint_pc_number)::text = (d.pcnum)::text)))
     LEFT JOIN va_ust.registered_petroleum_tank_facilities c ON (((b.ceds_fac_id)::text = (c."CEDS_FAC_ID")::text)))
     LEFT JOIN va_release.v_facility_type_xwalk ft ON (((c."FAC_TYPE")::text = (ft.organization_value)::text)))
     LEFT JOIN va_release.v_release_status_xwalk rs ON (((b.case_status)::text = (rs.organization_value)::text)))
  WHERE ((b.federally_regulated_ust)::text = 'Yes'::text);