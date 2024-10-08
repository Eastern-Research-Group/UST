----------------------------------------------------------------------------------------------------------

create view example.v_ust_piping as
select distinct
    a."Facility Id"::character varying(50) as facility_id, 
    b."tank_id"::integer as tank_id,       -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    a."Tank Name"::character varying(50) as tank_name, 
    "piping_id"::character varying(50) as piping_id,       -- This required field is not present in the source data. Table erg_piping_id was created by ERG so the data can conform to the EPA template structure.
    "Piping Material Desc"::character varying(3) as piping_material_frp,       -- if "Piping Material Desc" = "Fiberglass Reinforced Plastic" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_stainless_steel,       -- if "Piping Material Desc" = "Stainless Steel" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_steel,       -- if "Piping Material Desc" = "Steel" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_copper,       -- if "Piping Material Desc" = "Copper" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_flex,       -- if "Piping Material Desc" = "Flex Piping" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_other       -- if "Piping Material Desc" = "Other" then "Yes"
from example."Tank Piping" a
    left join example."erg_tank_id" b on a."Facility Id" = b."facility_id" and a."Tank Name" = b."tank_name" 
    left join example."erg_compartment_id" c on a."facility_id" = c."facility_id" and a."tank_id" = c."tank_id" 
    left join example."erg_piping_id" d on c."facility_id" = d."facility_id" and c."tank_id" = d."tank_id" and c."compartment_id" = d."compartment_id" 
    left join example."Piping Material Lookup" e on a."Piping Material Id" = e."Piping Material ID" 
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------

create view example.v_ust_piping as
select distinct
    a."Facility Id"::character varying(50) as facility_id, 
    b."tank_id"::integer as tank_id,       -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    a."Tank Name"::character varying(50) as tank_name, 
    "piping_id"::character varying(50) as piping_id,       -- This required field is not present in the source data. Table erg_piping_id was created by ERG so the data can conform to the EPA template structure.
    "piping_id"::character varying(50) as piping_id,       -- This required field is not present in the source data. Table erg_piping_id was created by ERG so the data can conform to the EPA template structure.
    "Piping Material Desc"::character varying(3) as piping_material_frp,       -- if "Piping Material Desc" = "Fiberglass Reinforced Plastic" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_stainless_steel,       -- if "Piping Material Desc" = "Stainless Steel" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_steel,       -- if "Piping Material Desc" = "Steel" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_copper,       -- if "Piping Material Desc" = "Copper" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_flex,       -- if "Piping Material Desc" = "Flex Piping" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_other       -- if "Piping Material Desc" = "Other" then "Yes"
from example."Tank Piping" a
    left join example."erg_tank_id" b on a."Facility Id" = b."facility_id" and a."Tank Name" = b."tank_name" 
    left join example."erg_compartment_id" c on a."facility_id" = c."facility_id" and a."tank_id" = c."tank_id" 
    left join example."erg_piping_id" d on c."facility_id" = d."facility_id" and c."tank_id" = d."tank_id" and c."compartment_id" = d."compartment_id" 
    left join example."Piping Material Lookup" e on a."Piping Material Id" = e."Piping Material ID" 
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------

create view example.v_ust_piping as
select distinct
    a."Facility Id"::character varying(50) as facility_id, 
    b."tank_id"::integer as tank_id,       -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    a."Tank Name"::character varying(50) as tank_name, 
    c."compartment_id"::integer as compartment_id,       -- This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.
    "piping_id"::character varying(50) as piping_id,       -- This required field is not present in the source data. Table erg_piping_id was created by ERG so the data can conform to the EPA template structure.
    "Piping Material Desc"::character varying(3) as piping_material_frp,       -- if "Piping Material Desc" = "Fiberglass Reinforced Plastic" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_stainless_steel,       -- if "Piping Material Desc" = "Stainless Steel" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_steel,       -- if "Piping Material Desc" = "Steel" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_copper,       -- if "Piping Material Desc" = "Copper" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_flex,       -- if "Piping Material Desc" = "Flex Piping" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_other       -- if "Piping Material Desc" = "Other" then "Yes"
from example."Tank Piping" a
    left join example."erg_tank_id" b on a."Facility Id" = b."facility_id" and a."Tank Name" = b."tank_name" 
    left join example."erg_compartment_id" c on a."facility_id" = c."facility_id" and a."tank_id" = c."tank_id" 
    left join example."erg_piping_id" d on c."facility_id" = d."facility_id" and c."tank_id" = d."tank_id" and c."compartment_id" = d."compartment_id" 
    left join example."Piping Material Lookup" e on a."Piping Material Id" = e."Piping Material ID" 
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------

create view example.v_ust_piping as
select distinct
    a."Facility Id"::character varying(50) as facility_id, 
    b."tank_id"::integer as tank_id,       -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    a."Tank Name"::character varying(50) as tank_name, 
    c."compartment_id"::integer as compartment_id,       -- This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.
    "piping_id"::character varying(50) as piping_id,       -- This required field is not present in the source data. Table erg_piping_id was created by ERG so the data can conform to the EPA template structure.
    "Piping Material Desc"::character varying(3) as piping_material_frp,       -- if "Piping Material Desc" = "Fiberglass Reinforced Plastic" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_stainless_steel,       -- if "Piping Material Desc" = "Stainless Steel" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_steel,       -- if "Piping Material Desc" = "Steel" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_copper,       -- if "Piping Material Desc" = "Copper" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_flex,       -- if "Piping Material Desc" = "Flex Piping" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_other       -- if "Piping Material Desc" = "Other" then "Yes"
from example."Tank Piping" a
    left join example."erg_tank_id" b on a."Facility Id" = b."facility_id" and a."Tank Name" = b."tank_name" 
    left join example."erg_compartment_id" c on a."facility_id" = c."facility_id" and a."tank_id" = c."tank_id" 
    left join example."erg_piping_id" d on c."facility_id" = d."facility_id" and c."tank_id" = d."tank_id" and c."compartment_id" = d."compartment_id" 
    left join example."Piping Material Lookup" e on a."Piping Material Id" = e."Piping Material ID" 
    left join example."Tanks" f on a."Tank Status Id" = f."Tank Status ID" 
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------

create view example.v_ust_piping as
select distinct
    a."Facility Id"::character varying(50) as facility_id, 
    b."tank_id"::integer as tank_id,       -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    a."Tank Name"::character varying(50) as tank_name, 
    c."compartment_id"::integer as compartment_id,       -- This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.
    "piping_id"::character varying(50) as piping_id,       -- This required field is not present in the source data. Table erg_piping_id was created by ERG so the data can conform to the EPA template structure.
    "Piping Material Desc"::character varying(3) as piping_material_frp,       -- if "Piping Material Desc" = "Fiberglass Reinforced Plastic" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_stainless_steel,       -- if "Piping Material Desc" = "Stainless Steel" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_steel,       -- if "Piping Material Desc" = "Steel" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_copper,       -- if "Piping Material Desc" = "Copper" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_flex,       -- if "Piping Material Desc" = "Flex Piping" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_other       -- if "Piping Material Desc" = "Other" then "Yes"
from example."Tank Piping" a
    left join example."erg_tank_id" b on a."Facility Id" = b."facility_id" and a."Tank Name" = b."tank_name" 
    left join example."erg_compartment_id" c on a."facility_id" = c."facility_id" and a."tank_id" = c."tank_id" 
    left join example."erg_piping_id" d on c."facility_id" = d."facility_id" and c."tank_id" = d."tank_id" and c."compartment_id" = d."compartment_id" 
    left join example."Piping Material Lookup" e on a."Piping Material Id" = e."Piping Material ID" 
    left join example."Tanks" f on a."Tank Status Id" = f."Tank Status ID" 
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------

create view example.v_ust_piping as
select distinct
    a."Facility Id"::character varying(50) as facility_id, 
    b."tank_id"::integer as tank_id,       -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    a."Tank Name"::character varying(50) as tank_name, 
    c."compartment_id"::integer as compartment_id,       -- This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.
    "piping_id"::character varying(50) as piping_id,       -- This required field is not present in the source data. Table erg_piping_id was created by ERG so the data can conform to the EPA template structure.
    "Piping Material Desc"::character varying(3) as piping_material_frp,       -- if "Piping Material Desc" = "Fiberglass Reinforced Plastic" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_stainless_steel,       -- if "Piping Material Desc" = "Stainless Steel" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_steel,       -- if "Piping Material Desc" = "Steel" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_copper,       -- if "Piping Material Desc" = "Copper" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_flex,       -- if "Piping Material Desc" = "Flex Piping" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_other       -- if "Piping Material Desc" = "Other" then "Yes"
from example."Tank Piping" a
    left join example."erg_tank_id" b on b."Facility Id" = b."facility_id" and b."Tank Name" = b."tank_name" 
    left join example."erg_compartment_id" c on c."facility_id" = c."facility_id" and c."tank_id" = c."tank_id" 
    left join example."erg_piping_id" d on c."facility_id" = d."facility_id" and c."tank_id" = d."tank_id" and c."compartment_id" = d."compartment_id" 
    left join example."Piping Material Lookup" e on a."Piping Material Id" = e."Piping Material ID" 
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------

create view example.v_ust_piping as
select distinct
    a."Facility Id"::character varying(50) as facility_id, 
    b."tank_id"::integer as tank_id,       -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    a."Tank Name"::character varying(50) as tank_name, 
    c."compartment_id"::integer as compartment_id,       -- This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.
    "piping_id"::character varying(50) as piping_id,       -- This required field is not present in the source data. Table erg_piping_id was created by ERG so the data can conform to the EPA template structure.
    "Piping Material Desc"::character varying(3) as piping_material_frp,       -- if "Piping Material Desc" = "Fiberglass Reinforced Plastic" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_stainless_steel,       -- if "Piping Material Desc" = "Stainless Steel" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_steel,       -- if "Piping Material Desc" = "Steel" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_copper,       -- if "Piping Material Desc" = "Copper" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_flex,       -- if "Piping Material Desc" = "Flex Piping" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_other       -- if "Piping Material Desc" = "Other" then "Yes"
from example."Tank Piping" a
    left join example."erg_tank_id" b on f."Facility Id" = b."facility_id" and f."Tank Name" = b."tank_name" 
    left join example."erg_compartment_id" c on b."facility_id" = c."facility_id" and b."tank_id" = c."tank_id" 
    left join example."erg_piping_id" d on c."facility_id" = d."facility_id" and c."tank_id" = d."tank_id" and c."compartment_id" = d."compartment_id" 
    left join example."Piping Material Lookup" e on a."Piping Material Id" = e."Piping Material ID" 
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------

create view example.v_ust_piping as
select distinct
    a."Facility Id"::character varying(50) as facility_id, 
    b."tank_id"::integer as tank_id,       -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    a."Tank Name"::character varying(50) as tank_name, 
    c."compartment_id"::integer as compartment_id,       -- This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.
    "piping_id"::character varying(50) as piping_id,       -- This required field is not present in the source data. Table erg_piping_id was created by ERG so the data can conform to the EPA template structure.
    "Piping Material Desc"::character varying(3) as piping_material_frp,       -- if "Piping Material Desc" = "Fiberglass Reinforced Plastic" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_stainless_steel,       -- if "Piping Material Desc" = "Stainless Steel" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_steel,       -- if "Piping Material Desc" = "Steel" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_copper,       -- if "Piping Material Desc" = "Copper" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_flex,       -- if "Piping Material Desc" = "Flex Piping" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_other       -- if "Piping Material Desc" = "Other" then "Yes"
from example."Tank Piping" a
    left join example."erg_compartment_id" c on b."facility_id" = c."facility_id" and b."tank_id" = c."tank_id" 
    left join example."erg_piping_id" d on c."facility_id" = d."facility_id" and c."tank_id" = d."tank_id" and c."compartment_id" = d."compartment_id" 
    left join example."Piping Material Lookup" e on a."Piping Material Id" = e."Piping Material ID" 
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------

create view example.v_ust_piping as
select distinct
    a."Facility Id"::character varying(50) as facility_id, 
    b."tank_id"::integer as tank_id,       -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    a."Tank Name"::character varying(50) as tank_name, 
    c."compartment_id"::integer as compartment_id,       -- This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.
    "piping_id"::character varying(50) as piping_id,       -- This required field is not present in the source data. Table erg_piping_id was created by ERG so the data can conform to the EPA template structure.
    "Piping Material Desc"::character varying(3) as piping_material_frp,       -- if "Piping Material Desc" = "Fiberglass Reinforced Plastic" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_stainless_steel,       -- if "Piping Material Desc" = "Stainless Steel" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_steel,       -- if "Piping Material Desc" = "Steel" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_copper,       -- if "Piping Material Desc" = "Copper" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_flex,       -- if "Piping Material Desc" = "Flex Piping" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_other       -- if "Piping Material Desc" = "Other" then "Yes"
from example."Tank Piping" a
    left join example."erg_compartment_id" c on b."facility_id" = c."facility_id" and b."tank_id" = c."tank_id" 
    left join example."erg_piping_id" d on c."facility_id" = d."facility_id" and c."tank_id" = d."tank_id" and c."compartment_id" = d."compartment_id" 
    left join example."Piping Material Lookup" e on a."Piping Material Id" = e."Piping Material ID" 
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------

create view example.v_ust_piping as
select distinct
    a."Facility Id"::character varying(50) as facility_id, 
    b."tank_id"::integer as tank_id,       -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    a."Tank Name"::character varying(50) as tank_name, 
    c."compartment_id"::integer as compartment_id,       -- This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.
    "piping_id"::character varying(50) as piping_id,       -- This required field is not present in the source data. Table erg_piping_id was created by ERG so the data can conform to the EPA template structure.
    "Piping Material Desc"::character varying(3) as piping_material_frp,       -- if "Piping Material Desc" = "Fiberglass Reinforced Plastic" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_stainless_steel,       -- if "Piping Material Desc" = "Stainless Steel" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_steel,       -- if "Piping Material Desc" = "Steel" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_copper,       -- if "Piping Material Desc" = "Copper" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_flex,       -- if "Piping Material Desc" = "Flex Piping" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_other       -- if "Piping Material Desc" = "Other" then "Yes"
from example."Tank Piping" a
    left join example."erg_compartment_id" c on b."facility_id" = c."facility_id" and b."tank_id" = c."tank_id" 
    left join example."erg_piping_id" d on c."facility_id" = d."facility_id" and c."tank_id" = d."tank_id" and c."compartment_id" = d."compartment_id" 
    left join example."Piping Material Lookup" e on a."Piping Material Id" = e."Piping Material ID" 
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------

create view example.v_ust_piping as
select distinct
    a."Facility Id"::character varying(50) as facility_id, 
    b."tank_id"::integer as tank_id,       -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    a."Tank Name"::character varying(50) as tank_name, 
    c."compartment_id"::integer as compartment_id,       -- This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.
    "piping_id"::character varying(50) as piping_id,       -- This required field is not present in the source data. Table erg_piping_id was created by ERG so the data can conform to the EPA template structure.
    "Piping Material Desc"::character varying(3) as piping_material_frp,       -- if "Piping Material Desc" = "Fiberglass Reinforced Plastic" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_stainless_steel,       -- if "Piping Material Desc" = "Stainless Steel" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_steel,       -- if "Piping Material Desc" = "Steel" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_copper,       -- if "Piping Material Desc" = "Copper" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_flex,       -- if "Piping Material Desc" = "Flex Piping" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_other       -- if "Piping Material Desc" = "Other" then "Yes"
from example."Tank Piping" a
    left join example."erg_compartment_id" c on b."facility_id" = c."facility_id" and b."tank_id" = c."tank_id" 
    left join example."erg_piping_id" d on c."facility_id" = d."facility_id" and c."tank_id" = d."tank_id" and c."compartment_id" = d."compartment_id" 
    left join example."Piping Material Lookup" e on a."Piping Material Id" = e."Piping Material ID" 
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;----------------------------------------------------------------------------------------------------------

create view example.v_ust_piping as
select distinct
    a."Facility Id"::character varying(50) as facility_id, 
    b."tank_id"::integer as tank_id,       -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
    a."Tank Name"::character varying(50) as tank_name, 
    c."compartment_id"::integer as compartment_id,       -- This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.
    "piping_id"::character varying(50) as piping_id,       -- This required field is not present in the source data. Table erg_piping_id was created by ERG so the data can conform to the EPA template structure.
    "Piping Material Desc"::character varying(3) as piping_material_frp,       -- if "Piping Material Desc" = "Fiberglass Reinforced Plastic" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_stainless_steel,       -- if "Piping Material Desc" = "Stainless Steel" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_steel,       -- if "Piping Material Desc" = "Steel" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_copper,       -- if "Piping Material Desc" = "Copper" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_flex,       -- if "Piping Material Desc" = "Flex Piping" then "Yes"
    "Piping Material Desc"::character varying(3) as piping_material_other       -- if "Piping Material Desc" = "Other" then "Yes"
from example."Tank Piping" a
    left join example."erg_tank_id" b on c."facility_id" = b."facility_id" and c."tank_id" = b."tank_id" 
    left join example."erg_compartment_id" c on d."facility_id" = c."facility_id" and d."tank_id" = c."tank_id" and d."compartment_id" = c."compartment_id" 
    left join example."erg_piping_id" d on c."facility_id" = d."facility_id" and c."tank_id" = d."tank_id" and c."compartment_id" = d."compartment_id" 
    left join example."Piping Material Lookup" e on a."Piping Material Id" = e."Piping Material ID" 
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;