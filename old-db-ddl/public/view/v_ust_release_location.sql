CREATE OR REPLACE VIEW public.v_ust_release_location AS
 SELECT a.ust_release_id,
    a.release_id,
        CASE
            WHEN b.ust_release_id IS NOT NULL THEN 'geocode'::text
            ELSE 'organization'::text
        END AS location_source,
    a.site_address,
    a.site_address2,
    a.site_city,
    a.county,
    a.zipcode,
    a.state,
    a.latitude,
    a.longitude,
    b.street_address AS geocoded_address,
    b.city AS geocoded_city,
    b.subregion AS geocoded_subregion,
        CASE
            WHEN b.zip_extension IS NOT NULL AND b.zip_code IS NOT NULL THEN ((b.zip_code::character varying(5)::text || '-'::text) || b.zip_extension::character varying(4)::text)::character varying
            ELSE b.zip_code::character varying(10)
        END AS geocoded_zip,
    b.region_abbreviation AS geocoded_state,
    b.latitude AS geocoded_latitude,
    b.longitude AS geocoded_longitude
   FROM ust_release a
     LEFT JOIN ust_release_geocode b ON a.ust_release_id = b.ust_release_id;
