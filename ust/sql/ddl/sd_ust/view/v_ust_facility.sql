create or replace view "sd_ust"."v_ust_facility" as
 SELECT DISTINCT (a."FacilityNumber")::character varying(50) AS facility_id,
    (a."FacilityName")::character varying(100) AS facility_name,
    (a."FacilityAddress1Text")::character varying(100) AS facility_address1,
    (a."FacilityAddress2Text")::character varying(100) AS facility_address2,
    (a."FacilityCity")::character varying(100) AS facility_city,
    (a."FacilityCounty")::character varying(100) AS facility_county,
    (a."FacilityZipCode")::character varying(10) AS facility_zip_code,
    'SD'::text AS facility_state,
    8 AS facility_epa_region,
    (a."FacilityLatitudeValue")::double precision AS facility_latitude,
    a."FacilityLongitudeValue" AS facility_longitude,
    b.coordinate_source_id,
    (a."OwnerName")::character varying(100) AS facility_owner_company_name
   FROM (sd_ust.tanks a
     LEFT JOIN sd_ust.v_coordinate_source_xwalk b ON ((a."FacilityMethodDescription" = (b.organization_value)::text)))
  WHERE ((a."FacilityType" = 'UST'::text) AND (a."FacilityNumber" <> ALL (ARRAY['02-00149'::text, '56-00015'::text])))
UNION
 SELECT DISTINCT (a."FacilityNumber")::character varying(50) AS facility_id,
    (a."FacilityName")::character varying(100) AS facility_name,
    (a."FacilityAddress1Text")::character varying(100) AS facility_address1,
    (a."FacilityAddress2Text")::character varying(100) AS facility_address2,
    (a."FacilityCity")::character varying(100) AS facility_city,
    (a."FacilityCounty")::character varying(100) AS facility_county,
    (a."FacilityZipCode")::character varying(10) AS facility_zip_code,
    'SD'::text AS facility_state,
    8 AS facility_epa_region,
    (a."FacilityLatitudeValue")::double precision AS facility_latitude,
    a."FacilityLongitudeValue" AS facility_longitude,
    b.coordinate_source_id,
    (a."OwnerName")::character varying(100) AS facility_owner_company_name
   FROM (sd_ust.tanks a
     LEFT JOIN sd_ust.v_coordinate_source_xwalk b ON ((a."FacilityMethodDescription" = (b.organization_value)::text)))
  WHERE ((a."FacilityType" = 'UST'::text) AND (a."FacilityNumber" = ANY (ARRAY['02-00149'::text, '56-00015'::text])) AND (a."FacilityZipCode" IS NOT NULL) AND (a."FacilityLatitudeValue" <> '0'::text));