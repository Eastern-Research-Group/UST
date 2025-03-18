create or replace view "ok_ust"."v_ust_facility" as
 SELECT DISTINCT (x.facility_id)::character varying(50) AS facility_id,
    (x."Name")::character varying(100) AS facility_name,
    votx.owner_type_id,
    a.facility_type_id AS facility_type1,
    (x."Address")::character varying(100) AS facility_address1,
    (x."Address2")::character varying(100) AS facility_address2,
    (x."City")::character varying(100) AS facility_city,
    (x."Zip")::character varying(10) AS facility_zip_code,
        CASE
            WHEN (x."Trust land" IS TRUE) THEN 'Yes'::text
            ELSE 'No'::text
        END AS facility_tribal_site,
    (x."Tribe")::character varying(200) AS facility_tribe,
    x."Latitude" AS facility_latitude,
    x."Longitude" AS facility_longitude,
    (y."Name")::character varying(100) AS facility_owner_company_name,
    'OK'::text AS facility_state,
    6 AS facility_epa_region
   FROM ((((ok_ust."OK_UST_Facility_Data" x
     LEFT JOIN ok_ust."OK_UST_Owner_Data" y ON ((x."OwnerID" = y."Owner ID")))
     LEFT JOIN ok_ust.v_facility_type_xwalk a ON (((a.organization_value)::text = x."Type")))
     LEFT JOIN ok_ust.erg_owner_type eot ON ((eot.facility_number = x.facility_number)))
     LEFT JOIN ok_ust.v_owner_type_xwalk votx ON (((votx.organization_value)::text = eot.owner_type)));