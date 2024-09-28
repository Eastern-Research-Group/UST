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
from ----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    "Tank Type"::integer as tank_location_id,      -- Exclude if = AST
    "Tank Status Desc"::integer as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date
from ----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    "Tank Type"::integer as tank_location_id,      -- Exclude if = AST
    "Tank Status Desc"::integer as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date
from ----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    "Tank Type"::integer as tank_location_id,      -- Exclude if = AST
    "Tank Status Desc"::integer as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date
from ----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    "Tank Type"::integer as tank_location_id,      -- Exclude if = AST
    "Tank Status Desc"::integer as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date
from ----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    "Tank Type"::integer as tank_location_id,      -- Exclude if = AST
    "Tank Status Desc"::integer as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date
from ----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    "Tank Type"::integer as tank_location_id,      -- Exclude if = AST
    "Tank Status Desc"::integer as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date
from ----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    "Tank Type"::integer as tank_location_id,      -- Exclude if = AST
    "Tank Status Desc"::integer as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date
from ----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    "Tank Type"::integer as tank_location_id,      -- Exclude if = AST
    "Tank Status Desc"::integer as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date
from ----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    "Tank Type"::integer as tank_location_id,      -- Exclude if = AST
    "Tank Status Desc"::integer as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date
from ----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    "Tank Type"::integer as tank_location_id,      -- Exclude if = AST
    "Tank Status Desc"::integer as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date
from ----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    "Tank Type"::integer as tank_location_id,      -- Exclude if = AST
    "Tank Status Desc"::integer as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date
from ----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    "Tank Type"::integer as tank_location_id,      -- Exclude if = AST
    "Tank Status Desc"::integer as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date
from ----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    "Tank Type"::integer as tank_location_id,      -- Exclude if = AST
    "Tank Status Desc"::integer as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date
from ----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    "Tank Type"::integer as tank_location_id,      -- Exclude if = AST
    "Tank Status Desc"::integer as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date
from ----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    "Tank Type"::integer as tank_location_id,      -- Exclude if = AST
    "Tank Status Desc"::integer as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date
from ----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    "Tank Type"::integer as tank_location_id,      -- Exclude if = AST
    "Tank Status Desc"::integer as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date
from ----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    "Tank Type"::integer as tank_location_id,      -- Exclude if = AST
    "Tank Status Desc"::integer as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date,
----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    "Tank Type"::integer as tank_location_id,      -- Exclude if = AST
    "Tank Status Desc"::integer as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date,
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
from ----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    "Tank Type"::integer as tank_location_id,      -- Exclude if = AST
    "Tank Status Desc"::integer as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date
from ----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    "Tank Type"::integer as tank_location_id,      -- Exclude if = AST
    "Tank Status Desc"::integer as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date
from ----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    "Tank Type"::integer as tank_location_id,      -- Exclude if = AST
    "Tank Status Desc"::integer as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date,
----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    "Tank Type"::integer as tank_location_id,      -- Exclude if = AST
    "Tank Status Desc"::integer as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date,
----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    "Tank Type"::integer as tank_location_id,      -- Exclude if = AST
    "Tank Status Desc"::integer as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date,
----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    "Tank Type"::integer as tank_location_id,      -- Exclude if = AST
    "Tank Status Desc"::integer as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date,
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
from ----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    "Tank Type"::integer as tank_location_id,      -- Exclude if = AST
    "Tank Status Desc"::integer as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date
from ----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    "Tank Type"::integer as tank_location_id,      -- Exclude if = AST
    "Tank Status Desc"::integer as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date
from ----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    "Tank Type"::integer as tank_location_id,      -- Exclude if = AST
    "Tank Status Desc"::integer as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date
from ----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    "Tank Type"::integer as tank_location_id,      -- Exclude if = AST
    "Tank Status Desc"::integer as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date
from ----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    "Tank Type"::integer as tank_location_id,      -- Exclude if = AST
    "Tank Status Desc"::integer as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date
from ----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    "Tank Type"::integer as tank_location_id,      -- Exclude if = AST
    "Tank Status Desc"::integer as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date
from ----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    "Tank Type"::integer as tank_location_id,      -- Exclude if = AST
    "Tank Status Desc"::integer as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date
from ----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    "Tank Type"::integer as tank_location_id,      -- Exclude if = AST
    "Tank Status Desc"::integer as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    "Tank Type"::integer as tank_location_id,      -- Exclude if = AST
    "Tank Status Desc"::integer as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date
from ----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    "Tank Type"::integer as tank_location_id,      -- Exclude if = AST
    "Tank Status Desc"::integer as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date
from example."Tanks" a
    left join example."erg_tank_id" b on a."Facility Id" = b."facility_id"  and a."Tank Name" = b."tank_name" 
    left join example."Tank Status Lookup" c on a."Tank Status Id" = c."Tank Status ID" 
    left join example.v_tank_status_xwalk d on a."Tank Status Desc" = d.organization_value
    left join example.v_tank_location_xwalk e on a."Tank Type" = e.organization_value----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    tank_location_id as tank_location_id,      -- Exclude if = AST
    tank_status_id as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date
from example."Tanks" a
    left join example."erg_tank_id" b on a."Facility Id" = b."facility_id"  and a."Tank Name" = b."tank_name" 
    left join example."Tank Status Lookup" c on a."Tank Status Id" = c."Tank Status ID" 
    left join example.v_tank_status_xwalk d on a."Tank Status Desc" = d.organization_value
    left join example.v_tank_location_xwalk e on a."Tank Type" = e.organization_value----------------------------------------------------------------------------------------------------------
from example."Tanks" a
    left join example."erg_tank_id" b on a."Facility Id" = b."facility_id"  and a."Tank Name" = b."tank_name" 
    left join example."Tank Status Lookup" c on a."Tank Status Id" = c."Tank Status ID" 
    left join example.v_tank_status_xwalk d on a."Tank Status Desc" = d.organization_value
    left join example.v_tank_location_xwalk e on a."Tank Type" = e.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE----------------------------------------------------------------------------------------------------------
from example."Tanks" a
    left join example."erg_tank_id" b on a."Facility Id" = b."facility_id"  and a."Tank Name" = b."tank_name" 
    left join example."Tank Status Lookup" c on a."Tank Status Id" = c."Tank Status ID" 
    left join example.v_tank_status_xwalk d on a."Tank Status Desc" = d.organization_value
    left join example.v_tank_location_xwalk e on a."Tank Type" = e.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from example."Tanks" a
    left join example."erg_tank_id" b on a."Facility Id" = b."facility_id"  and a."Tank Name" = b."tank_name" 
    left join example."Tank Status Lookup" c on a."Tank Status Id" = c."Tank Status ID" 
    left join example.v_tank_status_xwalk d on a."Tank Status Desc" = d.organization_value
    left join example.v_tank_location_xwalk e on a."Tank Type" = e.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE----------------------------------------------------------------------------------------------------------
from example."Tanks" a
    left join example."erg_tank_id" b on a."Facility Id" = b."facility_id"  and a."Tank Name" = b."tank_name" 
    left join example."Tank Status Lookup" c on a."Tank Status Id" = c."Tank Status ID" 
    left join example.v_tank_status_xwalk d on a."Tank Status Desc" = d.organization_value
    left join example.v_tank_location_xwalk e on a."Tank Type" = e.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from example."Tanks" a
    left join example."erg_tank_id" b on a."Facility Id" = b."facility_id"  and a."Tank Name" = b."tank_name" 
    left join example."Tank Status Lookup" c on a."Tank Status Id" = c."Tank Status ID" 
    left join example.v_tank_status_xwalk d on c."Tank Status Desc" = d.organization_value
    left join example.v_tank_location_xwalk e on a."Tank Type" = e.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name,
    tank_location_id as tank_location_id,      -- Exclude if = AST
    tank_status_id as tank_status_id,
    "Closure Date"::date as tank_closure_date,
    "Install Date"::date as tank_installation_date
from example."Tanks" a
    left join example."erg_tank_id" b on a."Facility Id" = b."facility_id"  and a."Tank Name" = b."tank_name" 
    left join example."Tank Status Lookup" c on a."Tank Status Id" = c."Tank Status ID" 
    left join example.v_tank_status_xwalk d on c."Tank Status Desc" = d.organization_value
    left join example.v_tank_location_xwalk e on a."Tank Type" = e.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank_substance as
select distinct
    "Tank Name"::character varying(50) as tank_name,
    "Facility Id"::character varying(50) as facility_id,
    substance_id as substance_id,      -- Source data contains multiple substances per row, delimited with a comma and space
from ----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank_substance as
select distinct
    "Tank Name"::character varying(50) as tank_name,
    "Facility Id"::character varying(50) as facility_id,
    substance_id as substance_id,      -- Source data contains multiple substances per row, delimited with a comma and space
from ----------------------------------------------------------------------------------------------------------
from example."Tanks" a
    left join example."erg_tank_id" b on a."Facility Id" = b."facility_id"  and a."Tank Name" = b."tank_name" 
    left join example.v_substance_xwalk c on a."Tank Substance" = c.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank_substance as
select distinct
    "Tank Name"::character varying(50) as tank_name,
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    substance_id as substance_id,      -- Source data contains multiple substances per row, delimited with a comma and space
from example."Tanks" a
    left join example."erg_tank_id" b on a."Facility Id" = b."facility_id"  and a."Tank Name" = b."tank_name" 
    left join example.v_substance_xwalk c on a."Tank Substance" = c.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank_substance as
select distinct
----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank_substance as
select distinct
    "Tank Name"::character varying(50) as tank_name,
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    substance_id as substance_id,      -- Source data contains multiple substances per row, delimited with a comma and space
from example."Tanks" a
    left join example."erg_tank_id" b on a."Facility Id" = b."facility_id"  and a."Tank Name" = b."tank_name" 
    left join example.v_substance_xwalk c on a."Tank Substance" = c.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank_substance as
select distinct
----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank_substance as
select distinct
    "Tank Name"::character varying(50) as tank_name,
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    substance_id as substance_id,      -- Source data contains multiple substances per row, delimited with a comma and space
from example."Tanks" a
    left join example."erg_tank_id" b on a."Facility Id" = b."facility_id"  and a."Tank Name" = b."tank_name" 
    left join example.v_substance_xwalk c on a."Tank Substance" = c.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank_substance as
select distinct
----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank_substance as
select distinct
----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank_substance as
select distinct
----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank_substance as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,      -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    substance_id as substance_id,      -- Source data contains multiple substances per row, delimited with a comma and space
from example."Tanks" a
    left join example."erg_tank_id" b on a."Facility Id" = b."facility_id"  and a."Tank Name" = b."tank_name" 
    left join example.v_substance_xwalk c on a."Tank Substance" = c.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank_substance as
select distinct
    "Facility Id"::character varying(50) as facility_id,    "tank_id"::integer as tank_id,    substance_id as substance_
from example."Tanks" a
    left join example."erg_tank_id" b on a."Facility Id" = b."facility_id"  and a."Tank Name" = b."tank_name" 
    left join example.v_substance_xwalk c on a."Tank Substance" = c.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank_substance as
select distinct
    "Facility Id"::character varying(50) as facility_id,    "tank_id"::integer as tank_id,    substance_id as substance_i
from example."Tanks" a
    left join example."erg_tank_id" b on a."Facility Id" = b."facility_id"  and a."Tank Name" = b."tank_name" 
    left join example.v_substance_xwalk c on a."Tank Substance" = c.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank_substance as
select distinct
    "Facility Id"::character varying(50) as facility_id,    "tank_id"::integer as tank_id,    substance_id as substance_i
from example."Tanks" a
    left join example."erg_tank_id" b on a."Facility Id" = b."facility_id"  and a."Tank Name" = b."tank_name" 
    left join example.v_substance_xwalk c on a."Tank Substance" = c.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank_substance as
select distinct
    "Facility Id"::character varying(50) as facility_id,    "tank_id"::integer as tank_id,    substance_id as substance_
from example."Tanks" a
    left join example."erg_tank_id" b on a."Facility Id" = b."facility_id"  and a."Tank Name" = b."tank_name" 
    left join example.v_substance_xwalk c on a."Tank Substance" = c.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank_substance as
select distinct
    "Facility Id"::character varying(50) as facility_id,    "tank_id"::integer as tank_id,    substance_id as substance_i
from example."Tanks" a
    left join example."erg_tank_id" b on a."Facility Id" = b."facility_id"  and a."Tank Name" = b."tank_name" 
    left join example.v_substance_xwalk c on a."Tank Substance" = c.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank_substance as
select distinct
    "Facility Id"::character varying(50) as facility_id,
    "tank_id"::integer as tank_id,
    substance_id as substance_id
from example."Tanks" a
    left join example."erg_tank_id" b on a."Facility Id" = b."facility_id"  and a."Tank Name" = b."tank_name" 
    left join example.v_substance_xwalk c on a."Tank Substance" = c.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank_substance as
select distinct
----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank_substance as
select distinct
    "Facility Id"::character varying(50) as facility_id, 
    "tank_id"::integer as tank_id,       -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    substance_id as substance_id,       -- Source data contains multiple substances per row, delimited with a comma and space
from example."Tanks" a
    left join example."erg_tank_id" b on a."Facility Id" = b."facility_id"  and a."Tank Name" = b."tank_name" 
    left join example.v_substance_xwalk c on a."Tank Substance" = c.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------

create view example.v_ust_tank_substance as
select distinct
    "Facility Id"::character varying(50) as facility_id, 
    "tank_id"::integer as tank_id,       -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    substance_id as substance_id       -- Source data contains multiple substances per row, delimited with a comma and space
from example."Tanks" a
    left join example."erg_tank_id" b on a."Facility Id" = b."facility_id"  and a."Tank Name" = b."tank_name" 
    left join example.v_substance_xwalk c on a."Tank Substance" = c.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------

create view example.v_ust_compartment as
select distinct
    "Facility Id"::character varying(50) as facility_id, 
    "tank_id"::integer as tank_id,       -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    "Tank Name"::character varying(50) as tank_name, 
    "compartment_id"::integer as compartment_id,       -- This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.
    compartment_status_id as compartment_status_id       -- State does not report compartments; copied from Tank Statu
from example."Tanks" a
    left join example."erg_tank_id" b on a."Facility Id" = b."facility_id"  and a."Tank Name" = b."tank_name" 
    left join example."erg_compartment_id" c on b."facility_id" = c."facility_id"  and b."tank_id" = c."tank_id" 
    left join example."Tank Status Lookup" d on a."Tank Status Id" = d."Tank Status ID" 
    left join example.v_compartment_status_xwalk e on d."Tank Status Desc" = e.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------

create view example.v_ust_compartment as
select distinct
    "Facility Id"::character varying(50) as facility_id, 
    "Tank Name"::character varying(50) as tank_name, 
    "compartment_id"::integer as compartment_id,       -- This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.
    compartment_status_id as compartment_status_id       -- State does not report compartments; copied from Tank Statu
from example."Tanks" a
    left join example."erg_compartment_id" b on a."facility_id" = b."facility_id"  and a."tank_id" = b."tank_id" 
    left join example."Tank Status Lookup" c on a."Tank Status Id" = c."Tank Status ID" 
    left join example.v_compartment_status_xwalk d on c."Tank Status Desc" = d.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------
from example."Tanks" a
    left join example."erg_compartment_id" b on a."facility_id" = b."facility_id"  and a."tank_id" = b."tank_id" 
    left join example."Tank Status Lookup" c on a."Tank Status Id" = c."Tank Status ID" 
    left join example.v_compartment_status_xwalk d on c."Tank Status Desc" = d.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------
from example."Tanks" a
    left join example."erg_compartment_id" b on a."facility_id" = b."facility_id"  and a."tank_id" = b."tank_id" 
    left join example."Tank Status Lookup" c on a."Tank Status Id" = c."Tank Status ID" 
    left join example.v_compartment_status_xwalk d on c."Tank Status Desc" = d.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------
from example."Tanks" a
    left join example."erg_tank_id" b on a."Facility Id" = b."facility_id"  and a."Tank Name" = b."tank_name" 
    left join example."Tank Status Lookup" c on a."Tank Status Id" = c."Tank Status ID" 
    left join example.v_tank_status_xwalk d on c."Tank Status Desc" = d.organization_value
    left join example.v_tank_location_xwalk e on a."Tank Type" = e.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------
from example."Tanks" a
    left join example."erg_tank_id" b on a."Facility Id" = b."facility_id"  and a."Tank Name" = b."tank_name" 
    left join example."Tank Status Lookup" c on a."Tank Status Id" = c."Tank Status ID" 
    left join example.v_tank_status_xwalk d on c."Tank Status Desc" = d.organization_value
    left join example.v_tank_location_xwalk e on a."Tank Type" = e.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from example."Tanks" a
    left join example."erg_compartment_id" b on d."facility_id" = b."facility_id"  and d."tank_id" = b."tank_id" 
    left join example."Tank Status Lookup" c on a."Tank Status Id" = c."Tank Status ID" 
    left join example."erg_tank_id" d on b."facility_id" = d."facility_id"  and b."tank_id" = d."tank_id" 
    left join example.v_compartment_status_xwalk e on c."Tank Status Desc" = e.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------
from example."Tanks" a
    left join example."erg_compartment_id" b on d."facility_id" = b."facility_id"  and d."tank_id" = b."tank_id" 
    left join example."Tank Status Lookup" c on a."Tank Status Id" = c."Tank Status ID" 
    left join example."erg_tank_id" d on b."facility_id" = d."facility_id"  and b."tank_id" = d."tank_id" 
    left join example.v_compartment_status_xwalk e on c."Tank Status Desc" = e.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from example."Tanks" a
    left join example."erg_compartment_id" b on d."facility_id" = b."facility_id"  and d."tank_id" = b."tank_id" 
    left join example."Tank Status Lookup" c on a."Tank Status Id" = c."Tank Status ID" 
    left join example."erg_tank_id" d on b."facility_id" = d."facility_id"  and b."tank_id" = d."tank_id" 
    left join example.v_compartment_status_xwalk e on c."Tank Status Desc" = e.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------
from example."Tanks" a
    left join example."erg_compartment_id" b on d."facility_id" = b."facility_id"  and d."tank_id" = b."tank_id" 
    left join example."Tank Status Lookup" c on a."Tank Status Id" = c."Tank Status ID" 
    left join example."erg_tank_id" d on b."facility_id" = d."facility_id"  and b."tank_id" = d."tank_id" 
    left join example.v_compartment_status_xwalk e on c."Tank Status Desc" = e.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from example."Tanks" a
    left join example."erg_tank_id" b on c."facility_id" = b."facility_id"  and c."tank_id" = b."tank_id" 
    left join example."erg_compartment_id" c on b."facility_id" = c."facility_id"  and b."tank_id" = c."tank_id" 
    left join example."Tank Status Lookup" d on a."Tank Status Id" = d."Tank Status ID" 
    left join example.v_compartment_status_xwalk e on d."Tank Status Desc" = e.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from ----------------------------------------------------------------------------------------------------------
from example."Tanks" a
    left join example."erg_tank_id" b on b."Facility Id" = b."facility_id"  and b."Tank Name" = b."tank_name" 
    left join example."erg_compartment_id" c on b."facility_id" = c."facility_id"  and b."tank_id" = c."tank_id" 
    left join example."Tank Status Lookup" d on a."Tank Status Id" = d."Tank Status ID" 
    left join example.v_compartment_status_xwalk e on d."Tank Status Desc" = e.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------
from example."Tanks" a
    left join example."erg_tank_id" b on a."Facility Id" = b."facility_id" and a."Tank Name" = b."tank_name" 
    left join example."erg_compartment_id" c on b."facility_id" = c."facility_id" and b."tank_id" = c."tank_id" 
    left join example."Tank Status Lookup" d on a."Tank Status Id" = d."Tank Status ID" 
    left join example.v_compartment_status_xwalk e on d."Tank Status Desc" = e.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------
from create view example.v_ust_compartment as
select distinct
    "Facility Id"::character varying(50) as facility_id, 
    "Tank Name"::character varying(50) as tank_name, 
    "compartment_id"::integer as compartment_id,       -- This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.
    compartment_status_id as compartment_status_id       -- State does not report compartments; copied from Tank Status
example."Tanks" a
    left join example."erg_tank_id" b on a."Facility Id" = b."facility_id" and a."Tank Name" = b."tank_name" 
    left join example."erg_compartment_id" c on b."facility_id" = c."facility_id" and b."tank_id" = c."tank_id" 
    left join example."Tank Status Lookup" d on a."Tank Status Id" = d."Tank Status ID" 
    left join example.v_compartment_status_xwalk e on d."Tank Status Desc" = e.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------

create view example.v_ust_compartment as
select distinct
    "Facility Id"::character varying(50) as facility_id, 
    "Tank Name"::character varying(50) as tank_name, 
    "compartment_id"::integer as compartment_id,       -- This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.
    compartment_status_id as compartment_status_id       -- State does not report compartments; copied from Tank Status

from example."Tanks" a
    left join example."erg_tank_id" b on a."Facility Id" = b."facility_id" and a."Tank Name" = b."tank_name" 
    left join example."erg_compartment_id" c on b."facility_id" = c."facility_id" and b."tank_id" = c."tank_id" 
    left join example."Tank Status Lookup" d on a."Tank Status Id" = d."Tank Status ID" 
    left join example.v_compartment_status_xwalk e on d."Tank Status Desc" = e.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------

create view example.v_ust_compartment as
select distinct
    "Facility Id"::character varying(50) as facility_id, 
    "Tank Name"::character varying(50) as tank_name, 
    "compartment_id"::integer as compartment_id,       -- This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.
    compartment_status_id as compartment_status_id       -- State does not report compartments; copied from Tank Status
----------------------------------------------------------------------------------------------------------

create view example.v_ust_compartment as
select distinct
    "Facility Id"::character varying(50) as facility_id, 
    "Tank Name"::character varying(50) as tank_name, 
    "compartment_id"::integer as compartment_id,       -- This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.
    compartment_status_id as compartment_status_id       -- State does not report compartments; copied from Tank Status
----------------------------------------------------------------------------------------------------------

create view example.v_ust_compartment as
select distinct
    "Facility Id"::character varying(50) as facility_id, 
    "Tank Name"::character varying(50) as tank_name, 
    "compartment_id"::integer as compartment_id,       -- This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.
    compartment_status_id as compartment_status_id       -- State does not report compartments; copied from Tank Status
----------------------------------------------------------------------------------------------------------

create view example.v_ust_compartment as
select distinct
    "Facility Id"::character varying(50) as facility_id, 
    "Tank Name"::character varying(50) as tank_name, 
    "compartment_id"::integer as compartment_id,       -- This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.
    compartment_status_id as compartment_status_id       -- State does not report compartments; copied from Tank Status
----------------------------------------------------------------------------------------------------------

create view example.v_ust_compartment as
select distinct
    "Facility Id"::character varying(50) as facility_id, 
    "Tank Name"::character varying(50) as tank_name, 
    "compartment_id"::integer as compartment_id,       -- This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.
    compartment_status_id as compartment_status_id       -- State does not report compartments; copied from Tank Status
