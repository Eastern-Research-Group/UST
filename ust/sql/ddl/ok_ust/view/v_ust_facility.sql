create or replace view "ok_ust"."v_ust_facility" as
 SELECT DISTINCT (a.facility_id)::character varying(50) AS facility_id,
    (a."Name")::character varying(100) AS facility_name,
    e.owner_type_id,
    d.facility_type_id AS facility_type1,
    (a."Address")::character varying(100) AS facility_address1,
    (a."Address2")::character varying(100) AS facility_address2,
    (a."City")::character varying(100) AS facility_city,
    (a."Zip")::character varying(10) AS facility_zip_code,
        CASE
            WHEN (a."Trust land" IS TRUE) THEN 'Yes'::text
            ELSE 'No'::text
        END AS facility_tribal_site,
    (a."Tribe")::character varying(200) AS facility_tribe,
    a."Latitude" AS facility_latitude,
    a."Longitude" AS facility_longitude,
    (y."Name")::character varying(100) AS facility_owner_company_name,
    'OK'::text AS facility_state,
    6 AS facility_epa_region
   FROM ((((ok_ust."OK_UST_Facility_Data" a
     LEFT JOIN ok_ust.v_facility_type_xwalk d ON ((a."Type" = (d.organization_value)::text)))
     LEFT JOIN ok_ust."OK_UST_Owner_Data" y ON ((a."OwnerID" = y."Owner ID")))
     LEFT JOIN ok_ust.v_owner_type_xwalk e ON ((y."Type" = (e.organization_value)::text)))
     JOIN ok_ust.erg_compartments_deduplicated z ON ((a.facility_id = z."FacilityID")))
  WHERE (NOT (((a.facility_id)::character varying(50))::text IN ( SELECT erg_unregulated_facilities.facility_id
           FROM ok_ust.erg_unregulated_facilities)));