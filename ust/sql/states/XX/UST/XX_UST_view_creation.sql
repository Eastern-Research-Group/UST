----------------------------------------------------------------------------------------------------------

create view example.v_ust_facility as
select distinct
    "Facility ID"::character varying(50) as facility_id,
    "Facility Name"::character varying(100) as facility_name,
    "Address"::character varying(100) as facility_address1,
    "City"::character varying(100) as facility_city,
    "Zip Code"::character varying(10) as facility_zip_code,
    'XX'::character varying as facility_state,
    None::integer as facility_epa_region,
    "Latitude"::double precision as facility_latitude,
    "Longitude"::double precision as facility_longitude,
    "Owner Name"::character varying(100) as facility_owner_company_name
from example."Facilities" a;

----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    tank_location_id as tank_location_id,      -- Exclude if = AST
    tank_status_id as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date
from ----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    tank_location_id as tank_location_id,      -- Exclude if = AST
    tank_status_id as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date
from ----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    tank_location_id as tank_location_id,      -- Exclude if = AST
    tank_status_id as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date
from 
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    "Tank Type"::integer as tank_location_id,      -- Exclude if = AST
    "Tank Status Desc"::integer as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date
from 