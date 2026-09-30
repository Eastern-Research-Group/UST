CREATE OR REPLACE VIEW public.v_all_needed_geocoding AS
 SELECT 'ust'::text AS ust_or_release,
    v_ust_needed_geocoding.ust_facility_id AS id,
    v_ust_needed_geocoding.organization_id,
    v_ust_needed_geocoding."FacilityID" AS entity_id,
    v_ust_needed_geocoding."FacilityName" AS entity_name,
    v_ust_needed_geocoding."FacilityAddress1" AS address,
    v_ust_needed_geocoding."FacilityAddress2" AS address2,
    v_ust_needed_geocoding."FacilityCity" AS city,
    v_ust_needed_geocoding."FacilityZipCode" AS zip,
    v_ust_needed_geocoding."FacilityCounty" AS county,
    v_ust_needed_geocoding."FacilityState" AS state,
    v_ust_needed_geocoding."FacilityLatitude" AS latitude,
    v_ust_needed_geocoding."FacilityLongitude" AS longitude,
    v_ust_needed_geocoding."FacilityCoordinateSource" AS coordinate_source,
    v_ust_needed_geocoding.ust_control_id AS control_id
   FROM v_ust_needed_geocoding
UNION ALL
 SELECT 'release'::text AS ust_or_release,
    v_release_needed_geocoding.ust_release_id AS id,
    v_release_needed_geocoding.organization_id,
    v_release_needed_geocoding."ReleaseID" AS entity_id,
    v_release_needed_geocoding."SiteName" AS entity_name,
    v_release_needed_geocoding."SiteAddress" AS address,
    v_release_needed_geocoding."SiteAddress2" AS address2,
    v_release_needed_geocoding."SiteCity" AS city,
    v_release_needed_geocoding."Zipcode" AS zip,
    v_release_needed_geocoding."County" AS county,
    v_release_needed_geocoding."State" AS state,
    v_release_needed_geocoding."Latitude" AS latitude,
    v_release_needed_geocoding."Longitude" AS longitude,
    v_release_needed_geocoding."CoordinateSource" AS coordinate_source,
    v_release_needed_geocoding.release_control_id AS control_id
   FROM v_release_needed_geocoding;
