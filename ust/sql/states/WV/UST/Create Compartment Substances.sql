delete from erg_comp_substances;

insert into wv_ust.erg_comp_substances (facility_id ,tank_id,compartment_id,substance)
select
	t."Facility#",
    t."Tank Id",
    c.compartment,
    COALESCE(s.substance, 'Unknown') AS substance
FROM wv_ust."USTTanksPublic" t
CROSS JOIN LATERAL generate_series(1, t."Compartments") AS c(compartment)
LEFT JOIN LATERAL (
    SELECT
        trim(value) AS substance
    FROM unnest(
        string_to_array(
            regexp_replace(t."Substance", E'\r\n?', E'\n', 'g'),
            E'\n'
        )
    ) WITH ORDINALITY AS u(value, position)
    WHERE position = c.compartment
) s ON TRUE
ORDER BY
    t."Tank Id",
    c.compartment;

CREATE TABLE wv_ust.erg_piping_id (
	facility_id varchar(50) NULL,
	tank_id int4 NULL,
	compartment_id int4 NULL,
	piping_id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL
);

insert into wv_ust.erg_piping_id (facility_id, tank_id, compartment_id)
select distinct "Facility#"::varchar(50), "Tank Id"::int, c."compartment_id"::int from wv_ust."USTTanksPublic" x left join wv_ust.erg_comp_substances c on x."Facility#" = c.facility_id and x."Tank Id" = c.tank_id;


create or replace view wv_ust.v_erg_facility
as select distinct 
	coalesce(f."Facility Id", t."Facility#") as "Facility Id",
	coalesce(f."Facility Name", t."Facility Name") as "Facility Name",
	f."Owner Type",
	f."Facility Type",
	coalesce(f."Address", t."Street Address") as "Address",
	coalesce(f."City", t."City") as "City",
	coalesce(f."County", t."County") as "County",
	coalesce(f."Zip", t."Zip") as "Zip",
	coalesce(f."Owner Name", t."Owner Name") as "Owner Name"
from wv_ust."AllFacilitiesDetails" f
full outer join wv_ust."USTTanksPublic" t on f."Facility Id" = t."Facility#";