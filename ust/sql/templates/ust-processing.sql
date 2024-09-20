
 alter table ust_element_mapping add organization_join_column2 varchar(100);
 alter table ust_element_mapping add organization_join_column3 varchar(100);
 alter table ust_element_mapping add organization_join_fk2 varchar(100);
 alter table ust_element_mapping add organization_join_fk3 varchar(100);
 
 alter table release_element_mapping add organization_join_column2 varchar(100);
 alter table release_element_mapping add organization_join_column3 varchar(100);
 alter table release_element_mapping add organization_join_fk2 varchar(100);
 alter table release_element_mapping add organization_join_fk3 varchar(100);


select * from ust_element_mapping
where ust_control_id = 18 and epa_table_name = 'ust_tank'
and epa_column_name = 'tank_id';
 1175

 select * from ust_element_mapping
where ust_control_id = 18 and epa_table_name = 'ust_tank'
and epa_column_name = 'tank_name';

 
select * from ca_ust.erg_tank_id2;

select * from ca_ust.erg_tank_id;



update ust_element_mapping
set organization_join_column = 'facility_id',
	organization_join_column2 = 'tank_name',
	organization_join_fk = 'CERS ID',
	organization_join_fk2 = 'CERS TankID'
where ust_element_mapping_id = 1175

create schema example;

select * from ust_element_mapping
where ust_control_id = 18 and epa_table_name = 'ust_piping';

select * from ust_control;

-- public.ust_control definition

-- Drop table

-- DROP TABLE public.ust_control;

CREATE TABLE example.ust_control (
	ust_control_id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	organization_id varchar(10) NULL,
	date_received date NULL,
	date_processed date NULL,
	data_source text NULL,
	"comments" text NULL,
	organization_compartment_flag varchar(1) NULL,
	CONSTRAINT ust_control_org_comp_flag_chk CHECK (((organization_compartment_flag)::text = ANY (ARRAY['Y'::text, 'N'::text]))),
	CONSTRAINT ust_control_pkey PRIMARY KEY (ust_control_id)
);
CREATE INDEX ust_control_organization_id_idx ON example.ust_control USING btree (organization_id);


drop table example."Facilities";
create table example."Facilities" 
	("Facility ID" varchar(100),
	 "Facility Name" varchar(100),
	 "Address" varchar(100),
	 "City" varchar(100),
	 "Zip Code" int,
	 "Latitude" float,
	 "Longitude" float,
	 "Owner Name" varchar(100)
	 );
	
drop table example."Tanks";
create table example."Tanks" 
	("Facility Id" varchar(100),
	"Tank Name" varchar(100),
	"Tank Status Id" varchar(100),
	"Closure Date" date,
	"Installation Date" date,
	"Tank Substance" varchar(100)
	);
alter table example."Tanks" add "Tank Type" varchar(100);




drop table example.erg_tank_id ;
create table example.erg_tank_id (facility_id varchar(100),
tank_name varchar(100),
tank_id  int generated always as identity);

drop table example."Tank Piping";
create table example."Tank Piping" (
	"Facility Id" varchar(100),
	"Tank Name" varchar(100),
	"Piping Style Id" int,
	"Piping Material Id" int
);

select * from piping_styles ;

create table example."Piping Style Lookup" 
("Piping Style Id" int, "Piping Style Desc" varchar(100));

create table example."Piping Material Lookup" 
("Piping Material Id" int, "Piping Material Desc" varchar(100));



insert into example.ust_control (organization_id, date_received, date_processed, organization_compartment_flag)
values ('XX', now(), now(), 'N');

update example.ust_control set comments = 'Example data for element mapping'

update example.ust_control set organization_id = 'XX'

select * from example.ust_control;

select * from example."Facilities"

insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (ZZ,'ust_facility','facility_id','ORG_TAB_NAME','ORG_COL_NAME',null);



insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_facility','facility_id','Facilities','Facility ID',null);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_facility','facility_id','Facilities','Facility ID',null);
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_facility','facility_name','Facilities','Facility Name',null);
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_facility','facility_address1','Facilities','Address',null);
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_facility','facility_city','Facilities','City',null);
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_facility','facility_zip_code','Facilities','Zip Code',null);
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_facility','facility_latitude','Facilities','Latitude',null);
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_facility','facility_longitude','Facilities','Longitude',null);
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_facility','facility_owner_company_name','Facilities','Owner Name',null);

select * from ust_element_mapping 
where ust_control_id = 18 and epa_column_name = 'tank_id'

select * from example.ust_element_mapping;

insert into example."Facilities" 
values ('ABCD1234', 'Gomez Gas', '123 Main St.', 'Berkeley', '95294', 37.871666, -122.272781, 'Gomez Gasoline Incorporated');
insert into example."Facilities" 
values ('WXYZ8877', 'Gas Station #1', '7654 40th St', 'Santa Cruz', '98765', 36.974117, 122.030792, 'Luna Petrol');

create table example."Tank Status Lookup" ("Tank Status Id" int, "Tank Status Desc" varchar(100));

select * from tank_statuses 

insert into example."Tank Status Lookup" values (1, 'Open');
insert into example."Tank Status Lookup" values (2, 'Temporarily Closed');
insert into example."Tank Status Lookup" values (3, 'Closed');

select * from substances;

insert into example."Tanks"
values ('ABCD1234','Tank #1',3,null,'1978-06-04','Leaded Gasoline');
insert into example."Tanks"
values ('ABCD1234','Tank #2',1,null,'2000-05-24','Unleaded Gasoline, Antifreeze, Racing Gasoline');
insert into example."Tanks"
values ('ABCD1234','Tank #3',1,null,'2018-09-15','Premium Gasoline, Motor Oil');

insert into example."Tanks"
values ('WXYZ8877','A',1,null,'1999-11-23','Premium Gasoline, Used Motor Oil');
insert into example."Tanks"
values ('WXYZ8877','B',2,null,'2003-11-24','Diesel');
insert into example."Tanks"
values ('WXYZ8877','C',1,null,'2016-03-17','Diesel','AST');

update example."Tanks" set "Tank Type" = 'UST' where "Tank Type" is null;


alter table example."Tanks" alter column "Tank Status Id" type int using "Tank Status Id"::int;


create table example.erg_substance_deagg (
 erg_substance_deagg_id int generated always as identity,
 "Substance" text,
 constraint erg_substance_deagg_unique unique ("Substance"))
 
insert into  example.erg_substance_deagg ("Substance") values ('Diesel');
insert into  example.erg_substance_deagg ("Substance") values ('Antifreeze');
insert into  example.erg_substance_deagg ("Substance") values ('Racing Gasoline');
insert into  example.erg_substance_deagg ("Substance") values ('Premium Gasoline');
insert into  example.erg_substance_deagg ("Substance") values ('Unleaded Gasoline');
insert into  example.erg_substance_deagg ("Substance") values ('Used Motor Oil');
insert into  example.erg_substance_deagg ("Substance") values ('Motor Oil');
insert into  example.erg_substance_deagg ("Substance") values ('Leaded Gasoline');
 
create table example.erg_substance_datarows_deagg (
 "Facility Id" varchar(100),
 "Tank Name" varchar(100),
 "Substance" varchar(100)
);

update example."Tanks" set "Closure Date" = '2024-04-13' where "Tank Status Id" = 3;

select * from example."Tanks"

insert into example.erg_substance_datarows_deagg values ('ABCD1234','Tank #1','Leaded Gasoline');
insert into example.erg_substance_datarows_deagg values ('ABCD1234','Tank #2','Unleaded Gasoline');
insert into example.erg_substance_datarows_deagg values ('ABCD1234','Tank #2','Antifreeze');
insert into example.erg_substance_datarows_deagg values ('ABCD1234','Tank #2','Racing Gasoline');
insert into example.erg_substance_datarows_deagg values ('ABCD1234','Tank #3','Premium Gasoline');
insert into example.erg_substance_datarows_deagg values ('ABCD1234','Tank #3','Motor Oil');
insert into example.erg_substance_datarows_deagg values ('WXYZ8877','A','Premium Gasoline');
insert into example.erg_substance_datarows_deagg values ('WXYZ8877','A','Used Motor Oil');
insert into example.erg_substance_datarows_deagg values ('WXYZ8877','B','Diesel');

select * from example.erg_substance_datarows_deagg;

select * from example."Tank Piping";

alter table example."Tank Piping" drop column "Piping Style Id"

select * from piping_material;


insert into example."Piping Material Lookup" values (1, 'Fiberglass Reinforced Plastic');
insert into example."Piping Material Lookup" values (2, 'Copper');
insert into example."Piping Material Lookup" values (3, 'Stainless Steel');
insert into example."Piping Material Lookup" values (4, 'Steel');
insert into example."Piping Material Lookup" values (5, 'Flex Piping');
insert into example."Piping Material Lookup" values (6, 'Other');

insert into example."Tank Piping" values ('ABCD1234', 'Tank #1',4);
insert into example."Tank Piping" values ('ABCD1234', 'Tank #2',1);
insert into example."Tank Piping" values ('ABCD1234', 'Tank #2',3);
insert into example."Tank Piping" values ('ABCD1234', 'Tank #2',6);
insert into example."Tank Piping" values ('ABCD1234', 'Tank #3',2);
insert into example."Tank Piping" values ('WXYZ8877', 'A',6);
insert into example."Tank Piping" values ('WXYZ8877', 'B',5);
insert into example."Tank Piping" values ('WXYZ8877', 'B',1);

drop table example."Piping Style Lookup"

select * from example.erg_tank_id;

insert into example.erg_tank_id (facility_id, tank_name) values ('ABCD1234','Tank #1');
insert into example.erg_tank_id (facility_id, tank_name) values ('ABCD1234','Tank #2');
insert into example.erg_tank_id (facility_id, tank_name) values ('ABCD1234','Tank #3');
insert into example.erg_tank_id (facility_id, tank_name) values ('WXYZ8877','A');
insert into example.erg_tank_id (facility_id, tank_name) values ('WXYZ8877','B');

select * from example.ust_element_mapping;


CREATE OR REPLACE VIEW example.v_tank_status_xwalk
AS SELECT a.organization_value,
    a.epa_value,
    b.tank_status_id
   FROM example.v_ust_element_mapping a
     LEFT JOIN public.tank_statuses b ON a.epa_value::text = b.tank_status::text
  WHERE a.ust_control_id = 1 AND a.epa_column_name::text = 'tank_status_id'::text;


---------------------------------------------------------------
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_tank','facility_id','Tanks','Facility Id',null);

insert into example.ust_element_mapping 
(ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name,
programmer_comments, 
organization_join_table, organization_join_column, organization_join_column2,
organization_join_fk, organization_join_fk2) 
values
(1,'ust_tank','tank_id','erg_tank_id','tank_id',
'This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.',
'Tanks', 'Facility Id', 'Tank Name', 'facility_id', 'tank_name');

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_tank','tank_name','Tanks','Tank Name',null);

insert into example.ust_element_mapping 
(ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name,
	organization_join_table, organization_join_column, organization_join_fk) 
values (1,'ust_tank','tank_status_id','Tank Status Lookup','Tank Status Desc', 'Tanks','Tank Status Id','Tank Status ID');

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_tank','tank_closure_date','Tanks','Closure Date',null);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_tank','tank_installation_date','Tanks','Install Date',null);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_tank','tank_location_id','Tanks','Tank Type','Exclude if = AST');

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_tank_substance','facility_id','Tanks','Facility Id',null);
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_tank_substance','tank_name','Tanks','Tank Name',null);
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name,
	programmer_comments, deagg_table_name, deagg_column_name) 
values (1,'ust_tank_substance','substance_id','Tanks','Tank Substance','Source data contains multiple substances per row, delimited with a comma and space.',
'erg_substance_datarows_deagg','Substance'
);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_piping','facility_id','Tanks','Facility Id',null);
insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_piping','tank_name','Tanks','Tank Name',null);


insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_piping','tank_name','Tanks','Tank Name',null);


select * from example."Piping Material Lookup" 
1	Fiberglass Reinforced Plastic
2	Copper
3	Stainless Steel
4	Steel
5	Flex Piping
6	Other

select  8f

delete from example.ust_element_mapping 
where epa_table_name = 'ust_tank'

select * from example.ust_element_mapping order by 1;



