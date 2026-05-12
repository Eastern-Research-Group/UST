create or replace view "as_ust"."v_ust_facility" as
 SELECT DISTINCT (a."FacilityID")::character varying(50) AS facility_id,
    (a."FacilityName")::character varying(100) AS facility_name,
    d.owner_type_id,
    c.facility_type_id AS facility_type1,
    (a."FacilityAddress1")::character varying(100) AS facility_address1,
    (a."FacilityCity")::character varying(100) AS facility_city,
    (a."FacilityCounty")::character varying(100) AS facility_county,
    (a."FacilityZipCode")::character varying(10) AS facility_zip_code,
    e.facility_state,
    (replace(a."FacilityEPARegion", 'REGION '::text, ''::text))::integer AS facility_epa_region,
    ((substr(a."FacilityLatitude", 1, 8))::double precision * ('-1'::integer)::double precision) AS facility_latitude,
    ((substr(a."FacilityLongitude", 1, 9))::double precision * ('-1'::integer)::double precision) AS facility_longitude,
    b.coordinate_source_id,
    (a."FacilityOwnerCompanyName")::character varying(100) AS facility_owner_company_name,
    (a."FacilityOperatorCompanyName")::character varying(100) AS facility_operator_company_name
   FROM ((((as_ust."Facility" a
     LEFT JOIN as_ust.v_coordinate_source_xwalk b ON ((a."FacilityCoordinateSource" = (b.organization_value)::text)))
     LEFT JOIN as_ust.v_facility_type_xwalk c ON ((a."FacilityType1" = (c.organization_value)::text)))
     LEFT JOIN as_ust.v_owner_type_xwalk d ON ((a."OwnerType" = (d.organization_value)::text)))
     LEFT JOIN as_ust.v_state_xwalk e ON ((a."FacilityState" = (e.organization_value)::text)));