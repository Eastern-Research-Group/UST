CREATE OR REPLACE VIEW public.v_ust_needed_geocoding AS
 SELECT b.ust_facility_id,
    c.organization_id,
    a."FacilityID",
    a."FacilityName",
    a."FacilityAddress1",
    a."FacilityAddress2",
    a."FacilityCity",
    a."FacilityState",
    a."FacilityZipCode",
    a."FacilityCounty",
    a."FacilityLatitude",
    a."FacilityLongitude",
    a."FacilityCoordinateSource",
    a.ust_control_id
   FROM v_ust_facility a
     JOIN ust_facility b ON a.ust_control_id = b.ust_control_id AND a."FacilityID"::text = b.facility_id::text
     JOIN ust_control c ON a.ust_control_id = c.ust_control_id
  WHERE a."FacilityLatitude" IS NULL OR scale(a."FacilityLatitude"::numeric) < 3 OR a."FacilityLongitude" IS NULL OR scale(a."FacilityLongitude"::numeric) < 3;
