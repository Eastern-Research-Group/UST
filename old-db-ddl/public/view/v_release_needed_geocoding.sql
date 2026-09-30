CREATE OR REPLACE VIEW public.v_release_needed_geocoding AS
 SELECT b.ust_release_id,
    c.organization_id,
    a."ReleaseID",
    a."SiteName",
    a."SiteAddress",
    a."SiteAddress2",
    a."SiteCity",
    a."Zipcode",
    a."County",
    a."State",
    a."Latitude",
    a."Longitude",
    a."CoordinateSource",
    a.release_control_id
   FROM v_ust_release a
     JOIN ust_release b ON a.release_control_id = b.release_control_id AND a."ReleaseID"::text = b.release_id::text
     JOIN release_control c ON a.release_control_id = c.release_control_id
  WHERE a."Latitude" IS NULL OR scale(a."Latitude"::numeric) < 3 OR a."Longitude" IS NULL OR scale(a."Longitude"::numeric) < 3;
