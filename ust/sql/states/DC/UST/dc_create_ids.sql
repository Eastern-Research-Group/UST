CREATE TABLE dc_ust.erg_compartment_id (
	facility_id varchar(50) NULL,
	tank_name varchar(50) NULL,
	tank_id int4 NULL,
	compartment_name varchar(50) NULL,
	compartment_id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL
);

CREATE TABLE dc_ust.erg_tank_id (
	facility_id varchar(50) NULL,
	tank_name varchar(50) NULL,
	tank_id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL
);

CREATE TABLE dc_ust.erg_piping_id (
	facility_id varchar(50) NULL,
	tank_name varchar(50) NULL,
	tank_id int4 NULL,
	compartment_name varchar(50) NULL,
	compartment_id int4 NULL,
	piping_id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL
);

CREATE TABLE dc_ust.erg_dispenser_id (
	dispenser_id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 20 CACHE 1 NO CYCLE) NOT NULL,
	facility_id varchar NULL
);

INSERT INTO dc_ust.erg_tank_id (facility_id, tank_name)
SELECT distinct "FacilityID", "TankID" 
FROM dc_ust.tank
where "FacilityID" is not null and "TankID" is not null;

insert into dc_ust.erg_compartment_id (facility_id, tank_name, tank_id, compartment_name)
select distinct x."FacilityID", x."TankID", t.tank_id, x."CompartmentID"
from dc_ust.compartment x
	join dc_ust.erg_tank_id t on x."FacilityID"::text = t.facility_id::text and x."TankID"::text = t.tank_name::text
where x."FacilityID" is not null;

insert into dc_ust.erg_piping_id (facility_id, tank_name, tank_id, compartment_name, compartment_id)
select distinct x."FacilityID", x."TankID", t.tank_id, x."CompartmentID", c.compartment_id
from dc_ust.piping x
	join dc_ust.erg_compartment_id c on x."FacilityID"::text = c.facility_id::text and x."CompartmentID"::text = c.compartment_name::text 
	join dc_ust.erg_tank_id t on x."FacilityID"::text = t.facility_id::text and x."TankID"::text = t.tank_name::text;
	
insert into dc_ust.erg_dispenser_id (facility_id)
select distinct "FacilityID"
from dc_ust.dispenser 
where "FacilityID" is not null