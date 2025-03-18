create or replace view "me_ust"."v_ust_facility" as
 WITH latest_tank_status AS (
         SELECT (tanks."REGISTRATION NUMBER")::text AS facility_id,
            tanks."TANK STATUS DATE",
            tanks."LATITUDE",
            tanks."LONGITUDE",
            row_number() OVER (PARTITION BY (tanks."REGISTRATION NUMBER")::text ORDER BY tanks."TANK STATUS DATE" DESC, tanks."LATITUDE" DESC) AS row_num
           FROM me_ust.tanks
        )
 SELECT DISTINCT (x."REGISTRATION NUMBER")::text AS facility_id,
    x."FACILITY NAME" AS facility_name,
    ft.facility_type_id AS facility_type1,
    x."FACILITY STREET ADDRESS" AS facility_address1,
    x."FACILITY CITY" AS facility_city,
    'ME'::text AS facility_state,
    1 AS facility_epa_region,
    lt."LATITUDE" AS facility_latitude,
    lt."LONGITUDE" AS facility_longitude,
    x."OWNER NAME" AS facility_owner_company_name,
    x."OPERATOR NAME" AS facility_operator_company_name
   FROM ((me_ust.tanks x
     JOIN latest_tank_status lt ON ((((x."REGISTRATION NUMBER")::text = lt.facility_id) AND (lt.row_num = 1))))
     LEFT JOIN me_ust.v_facility_type_xwalk ft ON ((x."FACILITY USE CODE" = (ft.organization_value)::text)));