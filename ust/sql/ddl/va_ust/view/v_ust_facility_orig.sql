create or replace view "va_ust"."v_ust_facility_orig" as
 SELECT DISTINCT (a."FAC_ID")::character varying(50) AS facility_id,
    (a."FAC_NAME")::character varying(100) AS facility_name,
        CASE
            WHEN (c.facility_type_id = 22) THEN 7
            ELSE (va_ust.get_owner_type(a."FAC_ID"))::integer
        END AS owner_type_id,
    c.facility_type_id AS facility_type1,
    (a."FAC_ADDR1")::character varying(100) AS facility_address1,
    (a."FAC_ADDR2")::character varying(100) AS facility_address2,
    (a."FAC_CITY")::character varying(100) AS facility_city,
    (a."NAME")::character varying(100) AS facility_county,
    (a."FAC_ZIP5")::character varying(10) AS facility_zip_code,
    (a."Lat")::double precision AS facility_latitude,
    (a."Lon")::double precision AS facility_longitude,
    (va_ust.get_owner_name(a."FAC_ID"))::character varying(100) AS facility_owner_company_name,
    'VA'::text AS facility_state,
    3 AS facility_epa_region
   FROM ((va_ust.registered_petroleum_tank_facilities a
     LEFT JOIN va_ust.owner_data od ON (((a."FAC_ID")::text = (od."Fac_Id")::text)))
     LEFT JOIN va_ust.v_facility_type_xwalk c ON (((a."FAC_TYPE")::text = (c.organization_value)::text)))
  WHERE ((((a."FAC_ACTIVE_UST")::integer > 0) OR ((a."FAC_INACTIVE_UST")::integer > 0)) AND ((a."FAC_FED_REG_YN")::text = 'Y'::text));