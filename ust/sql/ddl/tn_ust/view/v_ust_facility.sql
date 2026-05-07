create or replace view "tn_ust"."v_ust_facility" as
 SELECT DISTINCT (a."FACILITY_ID_UST")::character varying(50) AS facility_id,
    (a."FACILITY_NAME")::character varying(100) AS facility_name,
    d.owner_type_id,
    c.facility_type_id AS facility_type1,
    (a."FACILITY_ADDRESS1")::character varying(100) AS facility_address1,
    (a."FACILITY_ADDRESS2")::character varying(100) AS facility_address2,
    (a."FACILITY_CITY")::character varying(100) AS facility_city,
    (a."FACILITY_ZIP")::character varying(10) AS facility_zip_code,
    z."LATITUDE" AS facility_latitude,
    z."LONGITUDE" AS facility_longitude,
    (a."OWNER_NAME")::character varying(100) AS facility_owner_company_name,
        CASE
            WHEN (tes."Facilityid" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS ust_reported_release,
    (tes.release_id)::character varying(40) AS associated_ust_release_id,
    4 AS facility_epa_region,
    'TN'::text AS facility_state
   FROM ((((((tn_ust.tn_facilities a
     JOIN tn_ust.tn_compartments tc ON (((a."FACILITY_ID_UST" = tc."Facility Id Ust") AND ((tc."Regulated Status" = 'Regulated'::text) OR (tc."Regulated Status" IS NULL)))))
     LEFT JOIN tn_ust.erg_lust_sites tes ON ((((a."FACILITY_ID_UST")::character varying(100))::text = tes."Facilityid")))
     LEFT JOIN tn_ust.erg_owner_type b ON ((a."FACILITY_ID_UST" = b."FACILITY_ID_UST")))
     LEFT JOIN tn_ust.erg_coordinates_combined z ON ((a."FACILITY_ID_UST" = z."FACILITY_ID")))
     LEFT JOIN tn_ust.v_facility_type_xwalk c ON ((a."FACILITY_TYPE" = (c.organization_value)::text)))
     LEFT JOIN tn_ust.v_owner_type_xwalk d ON ((b.owner_type_converted = (d.organization_value)::text)))
  WHERE (NOT (((a."FACILITY_ID_UST")::character varying(50))::text IN ( SELECT erg_unregulated_facilities.facility_id
           FROM tn_ust.erg_unregulated_facilities)));