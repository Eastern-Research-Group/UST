create or replace view "wv_ust"."v_ust_facility" as
 SELECT DISTINCT (x."Facility Id")::character varying(50) AS facility_id,
    (x."Facility Name")::character varying(100) AS facility_name,
    ot.owner_type_id,
    ft.facility_type_id AS facility_type1,
    (x."Address")::character varying(100) AS facility_address1,
    (x."City")::character varying(100) AS facility_city,
    (x."County")::character varying(100) AS facility_county,
    (x."Zip")::character varying(10) AS facility_zip_code,
    'WV'::text AS facility_state,
    3 AS facility_epa_region,
    (x."Owner Name")::character varying(100) AS facility_owner_company_name
   FROM ((wv_ust.facilities x
     LEFT JOIN wv_ust.v_owner_type_xwalk ot ON ((x."Owner Type" = (ot.organization_value)::text)))
     LEFT JOIN wv_ust.v_facility_type_xwalk ft ON ((x."Facility Type" = (ft.organization_value)::text)))
  WHERE (NOT (((x."Facility Id")::character varying(50))::text IN ( SELECT erg_unregulated_facilities.facility_id
           FROM wv_ust.erg_unregulated_facilities)));