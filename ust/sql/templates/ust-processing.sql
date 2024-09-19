
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
values ('ABCD1234', 'Gas Station #1', '123 Main St.', '')

create table example.erg_substance_deagg (
 erg_substance_deagg_id int generated always as identity,
 "Substance" text,
 constraint erg_substance_deagg_unique unique ("Substance"))
 
create table example.erg_substance_datarows_deagg (
 "Facility Id" varchar(100),
 "Tank Name" varchar(100),
 "Substance" varchar(100)
);


select * from information_schema.tables 
where table_name like '%deagg%'



select * from ust_element_mapping 
where deagg_table_name is not null;

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
(ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_tank','tank_status_id','Tanks','Tank Status Id',null);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_tank','tank_closure_date','Tanks','Closure Date',null);

insert into example.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (1,'ust_tank','tank_installation_date','Tanks','Install Date',null);





delete from example.ust_element_mapping 
where epa_table_name = 'ust_tank'

select * from example.ust_element_mapping order by 1;



