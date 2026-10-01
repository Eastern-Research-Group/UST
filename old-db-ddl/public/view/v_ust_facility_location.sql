CREATE OR REPLACE VIEW public.v_ust_facility_location AS
 SELECT a.ust_facility_id,
    a.facility_id,
        CASE
            WHEN b.ust_facility_id IS NOT NULL THEN 'geocode'::text
            ELSE 'organization'::text
        END AS location_source,
    a.facility_address1,
    a.facility_address2,
    a.facility_city,
    a.facility_county,
    a.facility_zip_code,
    a.facility_state,
    a.facility_latitude,
    a.facility_longitude,
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
   FROM ust_facility a
     LEFT JOIN ust_facility_geocode b ON a.ust_facility_id = b.ust_facility_id;
