create or replace view "sd_ust"."v_ust_facility" as
 SELECT DISTINCT (x."FacilityNumber")::character varying(50) AS facility_id,
    (x."FacilityName")::character varying(100) AS facility_name,
    (x."FacilityAddress1Text")::character varying(100) AS facility_address1,
    (x."FacilityAddress2Text")::character varying(100) AS facility_address2,
    (x."FacilityCity")::character varying(100) AS facility_city,
    (x."FacilityCounty")::character varying(100) AS facility_county,
    (x."FacilityZipCode")::character varying(10) AS facility_zip_code,
    'SD'::text AS facility_state,
    (x."FacilityLatitudeValue")::double precision AS facility_latitude,
    x."FacilityLongitudeValue" AS facility_longitude,
    (x."OwnerName")::character varying(100) AS facility_owner_company_name,
    8 AS facility_epa_region,
    cs.coordinate_source_id
   FROM (sd_ust.tanks x
     LEFT JOIN sd_ust.v_coordinate_source_xwalk cs ON ((x."FacilityMethodDescription" = (cs.organization_value)::text)))
  WHERE (x."FacilityType" = 'UST'::text);