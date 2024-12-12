
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





select ust_element_mapping_id, organization_table_name, organization_column_name, 
deagg_table_name, deagg_column_name 
from example.ust_element_mapping 
where ust_control_id = 1 and epa_column_name = 'substance_id'

select deagg_column_name from ust_element_mapping
where deagg_column_name is not null;



CREATE OR REPLACE VIEW example.v_ust_table_population
AS SELECT x.ust_control_id,
    x.epa_table_name,
    x.epa_column_name,
    x.data_type,
    x.character_maximum_length,
    x.data_type_complete,
    x.organization_table_name,
    x.organization_column_name,
    x.programmer_comments,
    x.organization_join_table,
    x.organization_join_column,
    x.organization_join_fk,
    x.database_lookup_table,
    x.database_lookup_column,
    x.deagg_table_name,
    x.deagg_column_name,
    x.table_sort_order,
    x.column_sort_order,
    x.primary_key
   FROM ( SELECT a.ust_control_id,
            a.epa_table_name,
            a.epa_column_name,
            e.data_type,
            e.character_maximum_length,
                CASE
                    WHEN e.character_maximum_length IS NOT NULL THEN ((('::'::text || e.data_type::text) || '('::text) || e.character_maximum_length) || ')'::text
                    ELSE '::'::text || e.data_type::text
                END AS data_type_complete,
            a.organization_table_name,
            a.organization_column_name,
            a.programmer_comments,
            a.organization_join_table,
            a.organization_join_column,
            a.organization_join_fk,
            b.database_lookup_table,
            b.database_lookup_column,
            a.deagg_table_name,
            a.deagg_column_name,
            d.sort_order AS table_sort_order,
            c.sort_order AS column_sort_order,
            c.primary_key
           FROM example.ust_element_mapping a
             JOIN public.ust_elements b ON a.epa_column_name::text = b.database_column_name::text
             JOIN public.ust_elements_tables c ON b.element_id = c.element_id AND a.epa_table_name::text = c.table_name::text
             JOIN public.ust_template_data_tables d ON c.table_name::text = d.table_name::text
             JOIN information_schema.columns e ON a.epa_table_name::text = e.table_name::name AND a.epa_column_name::text = e.column_name::name AND e.table_schema::name = 'public'::name
        UNION ALL
         SELECT a.ust_control_id,
            z.epa_table_name,
            a.epa_column_name,
            e.data_type,
            e.character_maximum_length,
                CASE
                    WHEN e.character_maximum_length IS NOT NULL THEN ((('::'::text || e.data_type::text) || '('::text) || e.character_maximum_length) || ')'::text
                    ELSE '::'::text || e.data_type::text
                END AS data_type_complete,
            a.organization_table_name,
            a.organization_column_name,
            a.organization_join_fk,
            a.programmer_comments,
            a.organization_join_table,
            a.organization_join_column,
            b.database_lookup_table,
            b.database_lookup_column,
            a.deagg_table_name,
            a.deagg_column_name,
            d.sort_order AS table_sort_order,
            c.sort_order AS column_sort_order,
            c.primary_key
           FROM example.ust_element_mapping a
             JOIN public.ust_elements b ON a.epa_column_name::text = b.database_column_name::text
             JOIN public.ust_elements_tables c ON b.element_id = c.element_id AND a.epa_table_name::text = c.table_name::text
             JOIN public.ust_template_data_tables d ON c.table_name::text = d.table_name::text
             JOIN information_schema.columns e ON a.epa_table_name::text = e.table_name::name AND a.epa_column_name::text = e.column_name::name AND e.table_schema::name = 'public'::name,
            ( SELECT 'ust_tank'::character varying(100) AS epa_table_name
                UNION ALL
                 SELECT 'ust_tank_substance'::character varying(100) AS epa_table_name
                UNION ALL
                 SELECT 'ust_compartment'::character varying(100) AS epa_table_name
                UNION ALL
                 SELECT 'ust_compartment_substance'::character varying(100) AS epa_table_name
                UNION ALL
                 SELECT 'ust_piping'::character varying(100) AS epa_table_name
                UNION ALL
                 SELECT 'ust_facility_dispenser'::character varying(100) AS epa_table_name
                UNION ALL
                 SELECT 'ust_tank_dispenser'::character varying(100) AS epa_table_name
                UNION ALL
                 SELECT 'ust_compartment_dispenser'::character varying(100) AS epa_table_name) z
          WHERE a.epa_column_name::text = 'ust_id'::text) x
  ORDER BY x.ust_control_id, x.epa_table_name, x.table_sort_order, x.column_sort_order;

 
 
 select * from ust_required_view_columns 
 
 select * from example.erg_compartment_id 
 
 drop table example.erg_compartment_id ;
 


select distinct a.table_name, sort_order
 from public.ust_required_view_columns a join public.ust_template_data_tables b on a.table_name = b.table_name 
 where auto_create = 'Y' and not exists 
 (select 1 from example.ust_element_mapping c
 where ust_control_id = 1 and a.table_name = c.epa_table_name and a.column_name = c.epa_column_name)
 and (a.table_name = 'ust_compartment' or exists 
 (select 1 from example.ust_element_mapping c
 where ust_control_id = 1 and a.table_name = c.epa_table_name))
 order by sort_order;
 

select * from ust_required_view_columns a join public.ust_template_data_tables b on a.table_name = b.table_name 
 where auto_create = 'Y'

 select * from example.ust_element_mapping 
where ust_control_id = 1 and epa_table_name = 'ust_tank' 

select * 
from example.v_ust_element_mapping_joins
where ust_control_id = 1 
and epa_table_name in ('ust_tank','ust_compartment')
and organization_join_table is not null
and organization_table_name not like '%Lookup'
order by table_sort_order, column_sort_order;

update example.ust_element_mapping 
set organization_column_name = 'Tank Name'
where ust_element_mapping_id = 25;

--ust_tank
update example.ust_element_mapping 
set organization_join_table = 'Tanks',
	organization_join_column = 'Facility Id',
	organization_join_fk = 'facility_id',
	organization_join_column2 = 'Tank Name',
	organization_join_fk2 = 'tank_name'
where ust_element_mapping_id  = 70;

--ust_compartment
update example.ust_element_mapping 
set organization_join_table = 'erg_tank_id',
	organization_join_column = 'facility_id',
	organization_join_fk = 'facility_id',
	organization_join_column2 = 'tank_id',
	organization_join_fk2 = 'tank_id'
where ust_element_mapping_id  = 71;

select * from example.v_ust_element_mapping_joins
where ust_control_id = 1 and epa_table_name = 'ust_compartment'
order by column_sort_order;

--organization_join_table = erg_tank_id
select organization_table_name 
from example.v_ust_element_mapping_joins 
where epa_table_name = 'ust_tank' and epa_column_name = 'tank_id'

--organization_join_column = 
select * from example.v_ust_element_mapping_joins 
where epa_table_name = 'ust_tank' and epa_column_name = 'facility_id'

select organization_join_fk 
from example.v_ust_element_mapping_joins 
where organization_table_name = 'erg_tank_id' 


select * from example.v_ust_element_mapping_joins
where ust_control_id = 1 and epa_table_name = 'ust_piping'
order by column_sort_order;

select * from example.v_ust_element_mapping_joins
where ust_control_id = 1 and epa_table_name = 'ust_tank_dispenser'
order by column_sort_order;

select * from example.erg_dispenser_id;

update example.ust_control set comments = comments || '. Includes ASTs'
where ust_control_id = 1;

select * from example.ust_control 



-- public.v_ust_table_population source

CREATE OR REPLACE VIEW public.v_ust_table_population
AS SELECT x.ust_control_id,
    x.epa_table_name,
    x.epa_column_name,
    x.data_type,
    x.character_maximum_length,
    x.data_type_complete,
    x.organization_table_name,
    x.organization_column_name,
    x.programmer_comments,
    x.organization_join_table,
    x.organization_join_column,
    x.organization_join_fk,
    x.database_lookup_table,
    x.database_lookup_column,
    x.deagg_table_name,
    x.deagg_column_name,
    x.table_sort_order,
    x.column_sort_order,
    x.primary_key,
    x.organization_join_column2,
    x.organization_join_fk2,
    x.organization_join_column3,
    x.organization_join_fk3
   FROM ( SELECT a.ust_control_id,
            a.epa_table_name,
            a.epa_column_name,
            e.data_type,
            e.character_maximum_length,
                CASE
                    WHEN e.character_maximum_length IS NOT NULL THEN ((('::'::text || e.data_type::text) || '('::text) || e.character_maximum_length) || ')'::text
                    ELSE '::'::text || e.data_type::text
                END AS data_type_complete,
            a.organization_table_name,
            a.organization_column_name,
            a.programmer_comments,
            a.organization_join_table,
            a.organization_join_column,
            a.organization_join_fk,
            b.database_lookup_table,
            b.database_lookup_column,
            a.deagg_table_name,
            a.deagg_column_name,
            d.sort_order AS table_sort_order,
            c.sort_order AS column_sort_order,
            c.primary_key,
            a.organization_join_column2,
            a.organization_join_fk2,
            a.organization_join_column3,
            a.organization_join_fk3
           FROM ust_element_mapping a
             JOIN ust_elements b ON a.epa_column_name::text = b.database_column_name::text
             JOIN ust_elements_tables c ON b.element_id = c.element_id AND a.epa_table_name::text = c.table_name::text
             JOIN ust_template_data_tables d ON c.table_name::text = d.table_name::text
             JOIN information_schema.columns e ON a.epa_table_name::text = e.table_name::name AND a.epa_column_name::text = e.column_name::name AND e.table_schema::name = 'public'::name
        UNION ALL
         SELECT a.ust_control_id,
            z.epa_table_name,
            a.epa_column_name,
            e.data_type,
            e.character_maximum_length,
                CASE
                    WHEN e.character_maximum_length IS NOT NULL THEN ((('::'::text || e.data_type::text) || '('::text) || e.character_maximum_length) || ')'::text
                    ELSE '::'::text || e.data_type::text
                END AS data_type_complete,
            a.organization_table_name,
            a.organization_column_name,
            a.organization_join_fk,
            a.programmer_comments,
            a.organization_join_table,
            a.organization_join_column,
            b.database_lookup_table,
            b.database_lookup_column,
            a.deagg_table_name,
            a.deagg_column_name,
            d.sort_order AS table_sort_order,
            c.sort_order AS column_sort_order,
            c.primary_key,
            a.organization_join_column2,
            a.organization_join_fk2,
            a.organization_join_column3,
            a.organization_join_fk3
           FROM ust_element_mapping a
             JOIN ust_elements b ON a.epa_column_name::text = b.database_column_name::text
             JOIN ust_elements_tables c ON b.element_id = c.element_id AND a.epa_table_name::text = c.table_name::text
             JOIN ust_template_data_tables d ON c.table_name::text = d.table_name::text
             JOIN information_schema.columns e ON a.epa_table_name::text = e.table_name::name AND a.epa_column_name::text = e.column_name::name AND e.table_schema::name = 'public'::name,
            ( SELECT 'ust_tank'::character varying(100) AS epa_table_name
                UNION ALL
                 SELECT 'ust_tank_substance'::character varying(100) AS epa_table_name
                UNION ALL
                 SELECT 'ust_compartment'::character varying(100) AS epa_table_name
                UNION ALL
                 SELECT 'ust_compartment_substance'::character varying(100) AS epa_table_name
                UNION ALL
                 SELECT 'ust_piping'::character varying(100) AS epa_table_name
                UNION ALL
                 SELECT 'ust_facility_dispenser'::character varying(100) AS epa_table_name
                UNION ALL
                 SELECT 'ust_tank_dispenser'::character varying(100) AS epa_table_name
                UNION ALL
                 SELECT 'ust_compartment_dispenser'::character varying(100) AS epa_table_name) z
          WHERE a.epa_column_name::text = 'ust_id'::text) x
  ORDER BY x.ust_control_id, x.epa_table_name, x.table_sort_order, x.column_sort_order;


-- public.v_ust_table_population_sql source

 drop view v_ust_table_population_sql;
CREATE OR REPLACE VIEW public.v_ust_table_population_sql
AS SELECT v_ust_table_population.ust_control_id,
    v_ust_table_population.epa_table_name,
    v_ust_table_population.epa_column_name,
    v_ust_table_population.programmer_comments,
    v_ust_table_population.data_type,
    v_ust_table_population.character_maximum_length,
    v_ust_table_population.organization_table_name,
    v_ust_table_population.organization_column_name,
    ('"'::text || v_ust_table_population.organization_table_name::text) || '"'::text AS organization_table_name_qtd,
    ('"'::text || v_ust_table_population.organization_column_name::text) || '"'::text AS organization_column_name_qtd,
        CASE
            WHEN v_ust_table_population.database_lookup_column IS NOT NULL THEN ((v_ust_table_population.epa_column_name::text || ' as '::text) || v_ust_table_population.epa_column_name::text) || ','::text
            ELSE ((((('"'::text || v_ust_table_population.organization_column_name::text) || '"'::text) || v_ust_table_population.data_type_complete) || ' as '::text) || v_ust_table_population.epa_column_name::text) || ','::text
        END AS selected_column,
    v_ust_table_population.organization_join_table,
    v_ust_table_population.organization_join_column,
    v_ust_table_population.organization_join_fk,
    v_ust_table_population.organization_join_column2,
    v_ust_table_population.organization_join_fk2,
    v_ust_table_population.organization_join_column3,
    v_ust_table_population.organization_join_fk3,
    ('"'::text || v_ust_table_population.organization_join_table::text) || '"'::text AS organization_join_table_qtd,
    ('"'::text || v_ust_table_population.organization_join_column::text) || '"'::text AS organization_join_column_qtd,
    ('"'::text || v_ust_table_population.organization_join_fk::text) || '"'::text AS organization_join_fk_qtd,
    ('"'::text || v_ust_table_population.organization_join_column2::text) || '"'::text AS organization_join_column_qtd2,
    ('"'::text || v_ust_table_population.organization_join_fk2::text) || '"'::text AS organization_join_fk_qtd2,
    ('"'::text || v_ust_table_population.organization_join_column3::text) || '"'::text AS organization_join_column_qtd3,
    ('"'::text || v_ust_table_population.organization_join_fk3::text) || '"'::text AS organization_join_fk_qtd3,
    v_ust_table_population.database_lookup_table,
    v_ust_table_population.database_lookup_column,
    v_ust_table_population.deagg_table_name,
    v_ust_table_population.deagg_column_name,
    v_ust_table_population.table_sort_order,
    v_ust_table_population.column_sort_order,
    v_ust_table_population.primary_key
   FROM v_ust_table_population;

  
  
  -- public.v_release_table_population source

CREATE OR REPLACE VIEW public.v_release_table_population
AS SELECT x.release_control_id,
    x.epa_table_name,
    x.epa_column_name,
    x.data_type,
    x.character_maximum_length,
    x.data_type_complete,
    x.organization_table_name,
    x.organization_column_name,
    x.programmer_comments,
    x.organization_join_table,
    x.organization_join_column,
    x.organization_join_fk,
    x.database_lookup_table,
    x.database_lookup_column,
    x.deagg_table_name,
    x.deagg_column_name,
    x.table_sort_order,
    x.column_sort_order,
    x.primary_key,
    x.organization_join_column2,
    x.organization_join_fk2,
    x.organization_join_column3,
    x.organization_join_fk3
   FROM ( SELECT a.release_control_id,
            a.epa_table_name,
            a.epa_column_name,
            e.data_type,
            e.character_maximum_length,
                CASE
                    WHEN e.character_maximum_length IS NOT NULL THEN ((('::'::text || e.data_type::text) || '('::text) || e.character_maximum_length) || ')'::text
                    ELSE '::'::text || e.data_type::text
                END AS data_type_complete,
            a.organization_table_name,
            a.organization_column_name,
            a.programmer_comments,
            a.organization_join_table,
            a.organization_join_column,
            a.organization_join_fk,
            b.database_lookup_table,
            b.database_lookup_column,
            a.deagg_table_name,
            a.deagg_column_name,
            d.sort_order AS table_sort_order,
            c.sort_order AS column_sort_order,
            c.primary_key,
            a.organization_join_column2, 
            a.organization_join_fk2, 
            a.organization_join_column3, 
            a.organization_join_fk3
            FROM release_element_mapping a
             JOIN release_elements b ON a.epa_column_name::text = b.database_column_name::text
             JOIN release_elements_tables c ON b.element_id = c.element_id AND a.epa_table_name::text = c.table_name::text
             JOIN release_template_data_tables d ON c.table_name::text = d.table_name::text
             JOIN information_schema.columns e ON a.epa_table_name::text = e.table_name::name AND a.epa_column_name::text = e.column_name::name AND e.table_schema::name = 'public'::name
        UNION ALL
         SELECT a.release_control_id,
            z.epa_table_name,
            a.epa_column_name,
            e.data_type,
            e.character_maximum_length,
                CASE
                    WHEN e.character_maximum_length IS NOT NULL THEN ((('::'::text || e.data_type::text) || '('::text) || e.character_maximum_length) || ')'::text
                    ELSE '::'::text || e.data_type::text
                END AS data_type_complete,
            a.organization_table_name,
            a.organization_column_name,
            a.programmer_comments,
            a.organization_join_table,
            a.organization_join_column,
            a.organization_join_fk,
            b.database_lookup_table,
            b.database_lookup_column,
            a.deagg_table_name,
            a.deagg_column_name,
            d.sort_order AS table_sort_order,
            c.sort_order AS column_sort_order,
            c.primary_key,
            a.organization_join_column2, 
            a.organization_join_fk2, 
            a.organization_join_column3, 
            a.organization_join_fk3            
           FROM release_element_mapping a
             JOIN release_elements b ON a.epa_column_name::text = b.database_column_name::text
             JOIN release_elements_tables c ON b.element_id = c.element_id AND a.epa_table_name::text = c.table_name::text
             JOIN release_template_data_tables d ON c.table_name::text = d.table_name::text
             JOIN information_schema.columns e ON a.epa_table_name::text = e.table_name::name AND a.epa_column_name::text = e.column_name::name AND e.table_schema::name = 'public'::name,
            ( SELECT 'ust_release_substance'::character varying(100) AS epa_table_name
                UNION ALL
                 SELECT 'ust_release_source'::character varying(100) AS "varchar"
                UNION ALL
                 SELECT 'ust_release_cause'::character varying(100) AS "varchar"
                UNION ALL
                 SELECT 'ust_release_corrective_action_strategy'::character varying(100) AS "varchar") z
          WHERE a.epa_column_name::text = 'release_id'::text) x
  ORDER BY x.release_control_id, x.epa_table_name, x.table_sort_order, x.column_sort_order;
  
 
 
 -- public.v_release_table_population_sql source

 drop view v_release_table_population_sql;
CREATE OR REPLACE VIEW public.v_release_table_population_sql
AS SELECT v_release_table_population.release_control_id,
    v_release_table_population.epa_table_name,
    v_release_table_population.epa_column_name,
    v_release_table_population.programmer_comments,
    v_release_table_population.data_type,
    v_release_table_population.character_maximum_length,
    v_release_table_population.organization_table_name,
    v_release_table_population.organization_column_name,
    ('"'::text || v_release_table_population.organization_table_name::text) || '"'::text AS organization_table_name_qtd,
    ('"'::text || v_release_table_population.organization_column_name::text) || '"'::text AS organization_column_name_qtd,
        CASE
            WHEN v_release_table_population.database_lookup_column IS NOT NULL THEN ((v_release_table_population.epa_column_name::text || ' as '::text) || v_release_table_population.epa_column_name::text) || ','::text
            ELSE ((((('"'::text || v_release_table_population.organization_column_name::text) || '"'::text) || v_release_table_population.data_type_complete) || ' as '::text) || v_release_table_population.epa_column_name::text) || ','::text
        END AS selected_column,
    v_release_table_population.organization_join_table,
    v_release_table_population.organization_join_column,
	v_release_table_population.organization_join_fk,
    v_release_table_population.organization_join_column2,
	v_release_table_population.organization_join_fk2,
    v_release_table_population.organization_join_column3,
	v_release_table_population.organization_join_fk3,
	('"'::text || v_release_table_population.organization_join_table::text) || '"'::text AS organization_join_table_qtd,
    ('"'::text || v_release_table_population.organization_join_column::text) || '"'::text AS organization_join_column_qtd,
    ('"'::text || v_release_table_population.organization_join_fk::text) || '"'::text AS organization_join_fk_qtd,
    ('"'::text || v_release_table_population.organization_join_column2::text) || '"'::text AS organization_join_column_qtd2,
    ('"'::text || v_release_table_population.organization_join_fk2::text) || '"'::text AS organization_join_fk_qtd2,
    ('"'::text || v_release_table_population.organization_join_column3::text) || '"'::text AS organization_join_column_qtd3,
    ('"'::text || v_release_table_population.organization_join_fk3::text) || '"'::text AS organization_join_fk_qtd3,    
    v_release_table_population.database_lookup_table,
    v_release_table_population.database_lookup_column,
    v_release_table_population.deagg_table_name,
    v_release_table_population.deagg_column_name,
    v_release_table_population.table_sort_order,
    v_release_table_population.column_sort_order,
    v_release_table_population.primary_key
   FROM v_release_table_population;

select a."Facility Id",
	   a."Tank Name",
	   c.compartment_id 
from example."Tanks" a 
	left join example.erg_tank_id b on a."Facility Id" = b.facility_id and a."Tank Name" = b.tank_name 
	left join example.erg_compartment_id c on b.facility_id = c.facility_id and b.tank_id = c.tank_id;
--	left join example.v_compartment_status_xwalk d on b."Tank Status Desc"

select * from example.erg_compartment_id order by 1, 3, 5;

	select * from example.v_compartment_status_xwalk ;
	
select * from example.erg_tank_id;


select * from example.erg_compartment_id ;



drop view public.v_ust_element_mapping_joins;
create or replace view public.v_ust_element_mapping_joins as
select epa_table_name, epa_column_name, 
       organization_table_name, organization_column_name, 
       organization_join_table, 
       organization_join_column, organization_join_fk,
       organization_join_column2, organization_join_fk2,
       organization_join_column3, organization_join_fk3,
       deagg_table_name, deagg_column_name, 
       database_lookup_table, database_lookup_column,
       ust_element_mapping_id, ust_control_id, 
       programmer_comments,
       b.sort_order as table_sort_order, d.sort_order as column_sort_order
from public.ust_element_mapping a left join public.ust_element_table_sort_order b 
		on a.epa_table_name = b.table_name	
	left join public.ust_elements c 
		on a.epa_column_name = c.database_column_name 
	left join public.ust_elements_tables d 
		on c.element_id = d.element_id and b.table_name = d.table_name;

	drop view example.v_ust_element_mapping_joins;
	
create or replace view example.v_ust_element_mapping_joins as
select epa_table_name, epa_column_name, 
       organization_table_name, organization_column_name, 
       organization_join_table, 
       organization_join_column, organization_join_fk,
       organization_join_column2, organization_join_fk2,
       organization_join_column3, organization_join_fk3,
       deagg_table_name, deagg_column_name, 
       database_lookup_table, database_lookup_column,
       ust_element_mapping_id, ust_control_id, 
       programmer_comments,
       b.sort_order as table_sort_order, d.sort_order as column_sort_order
from example.ust_element_mapping a left join public.ust_element_table_sort_order b 
		on a.epa_table_name = b.table_name	
	left join public.ust_elements c 
		on a.epa_column_name = c.database_column_name 
	left join public.ust_elements_tables d 
		on c.element_id = d.element_id and b.table_name = d.table_name;	
	
	
	drop view v_release_element_mapping_joins;
create view public.v_release_element_mapping_joins as
select epa_table_name, epa_column_name, 
       organization_table_name, organization_column_name, 
       organization_join_table, 
       organization_join_column, organization_join_fk,
       organization_join_column2, organization_join_fk2,
       organization_join_column3, organization_join_fk3,
       deagg_table_name, deagg_column_name, 
       database_lookup_table, database_lookup_column,       
       release_element_mapping_id, release_control_id, 
       programmer_comments,
       b.sort_order as table_sort_order, d.sort_order as column_sort_order
from public.release_element_mapping a left join public.release_element_table_sort_order b 
		on a.epa_table_name = b.table_name	
	left join public.release_elements c 
		on a.epa_column_name = c.database_column_name 
	left join public.release_elements_tables d 
		on c.element_id = d.element_id and b.table_name = d.table_name;
	
	
	
select * from ust_elements_tables 

select * from ust_elements;

 
select 
from example.ust_element_mapping 
where ust_control_id = 1
and epa_table_name = 'ust_compartment' 
 
select * from example.erg_compartment_id ;
 
 
select table_name from information_schema.tables 
where table_schema = 'example' and table_name like 'erg%id'
order by 1



select epa_column_name from 
(select distinct epa_table_name, epa_column_name, table_sort_order, column_sort_order
from example.v_ust_needed_mapping 
where ust_control_id = 1) x





CREATE OR REPLACE VIEW example.v_ust_table_population
AS SELECT x.ust_control_id,
    x.epa_table_name,
    x.epa_column_name,
    x.data_type,
    x.character_maximum_length,
    x.data_type_complete,
    x.organization_table_name,
    x.organization_column_name,
    x.programmer_comments,
    x.organization_join_table,
    x.organization_join_column,
    x.organization_join_fk,
    x.database_lookup_table,
    x.database_lookup_column,
    x.deagg_table_name,
    x.deagg_column_name,
    x.table_sort_order,
    x.column_sort_order,
    x.primary_key,
    x.organization_join_column2,
    x.organization_join_fk2,
    x.organization_join_column3,
    x.organization_join_fk3
   FROM ( SELECT a.ust_control_id,
            a.epa_table_name,
            a.epa_column_name,
            e.data_type,
            e.character_maximum_length,
                CASE
                    WHEN e.character_maximum_length IS NOT NULL THEN ((('::'::text || e.data_type::text) || '('::text) || e.character_maximum_length) || ')'::text
                    ELSE '::'::text || e.data_type::text
                END AS data_type_complete,
            a.organization_table_name,
            a.organization_column_name,
            a.programmer_comments,
            a.organization_join_table,
            a.organization_join_column,
            a.organization_join_fk,
            b.database_lookup_table,
            b.database_lookup_column,
            a.deagg_table_name,
            a.deagg_column_name,
            d.sort_order AS table_sort_order,
            c.sort_order AS column_sort_order,
            c.primary_key,
            a.organization_join_column2,
            a.organization_join_fk2,
            a.organization_join_column3,
            a.organization_join_fk3
           FROM example.ust_element_mapping a
             left JOIN public.ust_elements b ON a.epa_column_name::text = b.database_column_name::text
             left JOIN public.ust_elements_tables c ON b.element_id = c.element_id AND a.epa_table_name::text = c.table_name::text
             left JOIN public.ust_template_data_tables d ON c.table_name::text = d.table_name::text
             left JOIN information_schema.columns e ON a.epa_table_name::text = e.table_name::name AND a.epa_column_name::text = e.column_name::name AND e.table_schema::name = 'public'::name
        UNION ALL
         SELECT a.ust_control_id,
            z.epa_table_name,
            a.epa_column_name,
            e.data_type,
            e.character_maximum_length,
                CASE
                    WHEN e.character_maximum_length IS NOT NULL THEN ((('::'::text || e.data_type::text) || '('::text) || e.character_maximum_length) || ')'::text
                    ELSE '::'::text || e.data_type::text
                END AS data_type_complete,
            a.organization_table_name,
            a.organization_column_name,
            a.organization_join_fk,
            a.programmer_comments,
            a.organization_join_table,
            a.organization_join_column,
            b.database_lookup_table,
            b.database_lookup_column,
            a.deagg_table_name,
            a.deagg_column_name,
            d.sort_order AS table_sort_order,
            c.sort_order AS column_sort_order,
            c.primary_key,
            a.organization_join_column2,
            a.organization_join_fk2,
            a.organization_join_column3,
            a.organization_join_fk3
           FROM example.ust_element_mapping a
             left JOIN public.ust_elements b ON a.epa_column_name::text = b.database_column_name::text
             left JOIN public.ust_elements_tables c ON b.element_id = c.element_id AND a.epa_table_name::text = c.table_name::text
             left JOIN public.ust_template_data_tables d ON c.table_name::text = d.table_name::text
             left JOIN information_schema.columns e ON a.epa_table_name::text = e.table_name::name AND a.epa_column_name::text = e.column_name::name AND e.table_schema::name = 'public'::name,
            ( SELECT 'ust_tank'::character varying(100) AS epa_table_name
                UNION ALL
                 SELECT 'ust_tank_substance'::character varying(100) AS epa_table_name
                UNION ALL
                 SELECT 'ust_compartment'::character varying(100) AS epa_table_name
                UNION ALL
                 SELECT 'ust_compartment_substance'::character varying(100) AS epa_table_name
                UNION ALL
                 SELECT 'ust_piping'::character varying(100) AS epa_table_name
                UNION ALL
                 SELECT 'ust_facility_dispenser'::character varying(100) AS epa_table_name
                UNION ALL
                 SELECT 'ust_tank_dispenser'::character varying(100) AS epa_table_name
                UNION ALL
                 SELECT 'ust_compartment_dispenser'::character varying(100) AS epa_table_name) z
          WHERE a.epa_column_name::text = 'ust_id'::text) x
  ORDER BY x.ust_control_id, x.epa_table_name, x.table_sort_order, x.column_sort_order;


-- public.v_ust_table_population_sql source

CREATE OR REPLACE VIEW example.v_ust_table_population_sql
AS SELECT v_ust_table_population.ust_control_id,
    v_ust_table_population.epa_table_name,
    v_ust_table_population.epa_column_name,
    v_ust_table_population.programmer_comments,
    v_ust_table_population.data_type,
    v_ust_table_population.character_maximum_length,
    v_ust_table_population.organization_table_name,
    v_ust_table_population.organization_column_name,
    ('"'::text || v_ust_table_population.organization_table_name::text) || '"'::text AS organization_table_name_qtd,
    ('"'::text || v_ust_table_population.organization_column_name::text) || '"'::text AS organization_column_name_qtd,
        CASE
            WHEN v_ust_table_population.database_lookup_column IS NOT NULL THEN ((v_ust_table_population.epa_column_name::text || ' as '::text) || v_ust_table_population.epa_column_name::text) || ','::text
            ELSE ((((('"'::text || v_ust_table_population.organization_column_name::text) || '"'::text) || v_ust_table_population.data_type_complete) || ' as '::text) || v_ust_table_population.epa_column_name::text) || ','::text
        END AS selected_column,
    v_ust_table_population.organization_join_table,
    v_ust_table_population.organization_join_column,
    v_ust_table_population.organization_join_fk,
    v_ust_table_population.organization_join_column2,
    v_ust_table_population.organization_join_fk2,
    v_ust_table_population.organization_join_column3,
    v_ust_table_population.organization_join_fk3,
    ('"'::text || v_ust_table_population.organization_join_table::text) || '"'::text AS organization_join_table_qtd,
    ('"'::text || v_ust_table_population.organization_join_column::text) || '"'::text AS organization_join_column_qtd,
    ('"'::text || v_ust_table_population.organization_join_fk::text) || '"'::text AS organization_join_fk_qtd,
    ('"'::text || v_ust_table_population.organization_join_column2::text) || '"'::text AS organization_join_column_qtd2,
    ('"'::text || v_ust_table_population.organization_join_fk2::text) || '"'::text AS organization_join_fk_qtd2,
    ('"'::text || v_ust_table_population.organization_join_column3::text) || '"'::text AS organization_join_column_qtd3,
    ('"'::text || v_ust_table_population.organization_join_fk3::text) || '"'::text AS organization_join_fk_qtd3,
    v_ust_table_population.database_lookup_table,
    v_ust_table_population.database_lookup_column,
    v_ust_table_population.deagg_table_name,
    v_ust_table_population.deagg_column_name,
    v_ust_table_population.table_sort_order,
    v_ust_table_population.column_sort_order,
    v_ust_table_population.primary_key
   FROM example.v_ust_table_population;

select * from information_schema.columns


select * from example.v_ust_table_population_sql
where ust_control_id = 1
and epa_table_name = 'ust_tank'

select * from example.ust_element_mapping 
where epa_table_name = 'ust_tank'

select * from example.v_ust_table_population
where ust_control_id = 1
and epa_table_name = 'ust_tank'



select organization_column_name, organization_join_table, 
 organization_join_column, organization_join_fk,
 organization_join_column2, organization_join_fk2,
 organization_join_column3, organization_join_fk3
 from example.v_ust_table_population_sql
 where ust_control_id = 1 
 and epa_table_name = 'ust_tank' and organization_table_name = 'Tanks';



			column_id = existing_col[13]
			column_name = existing_col[0]
			selected_column = existing_col[5]
			programmer_comments = existing_col[14]

			
select 
from example.ust_element_mapping 
where a.ust_control_id = 1 and a.epa_table_name = 'ust_tank'
			
select column_sort_order as column_id, 
	epa_column_name as column_name,
	programmer_comments
from example.v_ust_element_mapping_joins 
where ust_control_id = 1 and epa_table_name = 'ust_tank';


select case when  
from example.v_ust_element_mapping_joins 
where epa_table_name = 'ust_tank' and epa_column_name = 'tank_id'
order by column_sort_order




select * from (
 select distinct organization_table_name table_name, 'org_table' as table_type, 1 as sort_order
 from example.v_ust_table_population_sql
 where ust_control_id = 1 and epa_table_name = 'ust_tank' and primary_key = 'Y' and organization_table_name not like 'erg%id'
 union all 
 select distinct organization_table_name table_name, 'org_table' as table_type, 2 as sort_order
 from example.v_ust_table_population_sql
 where ust_control_id = 1 and epa_table_name = 'ust_tank' and (primary_key is null or organization_table_name like 'erg%id') 
 and organization_table_name not in 
 (select organization_table_name from example.v_ust_table_population_sql
 where ust_control_id = 1 and epa_table_name = 'ust_tank' and primary_key = 'Y')
 union all 
 select distinct deagg_table_name, 'deagg_table' as table_type, 2 as sort_order 
 from example.v_ust_table_population_sql
 where ust_control_id = 1 and epa_table_name = 'ust_tank' 
 union all 
 select distinct organization_join_table, 'join_table' as table_type, 3 as sort_order 
 from example.v_ust_table_population_sql
 where ust_control_id = 1 and epa_table_name = 'ust_tank' 
 union all 
 select distinct database_lookup_table, 'lookup_table' as table_type, 4 as sort_order 
 from example.v_ust_table_population_sql
 where ust_control_id = 1 and epa_table_name = 'ust_tank') x
 where table_name is not null 
 order by sort_order;

create or replace view example.v_ust_mapped_table_types as
select ust_control_id, epa_table_name, organization_table_name, 'key' as table_type
from example.v_ust_table_population_sql
where primary_key = 'Y' and organization_table_name not like 'erg%id'
and organization_table_name is not null
union all 
select ust_control_id, epa_table_name, organization_table_name, 'id' as table_type
from example.v_ust_table_population_sql
where organization_table_name like 'erg%id'
and organization_table_name is not null
union all 
select ust_control_id, epa_table_name, organization_table_name, 'org' as table_type
from example.v_ust_table_population_sql
where primary_key <> 'Y' 
and organization_table_name is not null
union all 
select ust_control_id, epa_table_name, organization_join_table, 'join' as table_type
from example.v_ust_table_population_sql
where primary_key <> 'Y' 
and organization_join_table is not null
union all 
select ust_control_id, epa_table_name, database_lookup_table, 'lookup' as table_type
from example.v_ust_table_population_sql
where database_lookup_table is not null
union all 
select ust_control_id, epa_table_name, deagg_table_name, 'deagg' as table_type
from example.v_ust_table_population_sql
where deagg_table_name is not null;

create table public.mapped_table_types (table_type varchar(15) not null primary key, sort_order int);

insert into  public.mapped_table_types values ('key', 1);
insert into  public.mapped_table_types values ('id', 2);
insert into  public.mapped_table_types values ('org', 3);
insert into  public.mapped_table_types values ('join', 4);
insert into  public.mapped_table_types values ('lookup', 5);
insert into  public.mapped_table_types values ('deag', 6);

select organization_table_name, table_type, x.sort_order,
	chr(96 + row_number() over (partition by 'a' order by x.sort_order)::int) as alias
from 
(select organization_table_name, min(sort_order) as sort_order 
from example.v_ust_mapped_table_types a join public.mapped_table_types b on a.table_type = b.table_type
where ust_control_id = 1 and epa_table_name = 'ust_tank'
group by organization_table_name) x join public.mapped_table_types y on x.sort_order = y.sort_order 
order by x.sort_order, organization_table_name;

select * from example.v_ust_mapped_table_types
where epa_table_name = 'ust_tank'

select * from example.v_ust_table_population_sql 

select * from example.v_ust_element_mapping_joins
where epa_table_name = 'ust_tank'


select * from example.v_ust_mapped_table_types



select distinct organization_table_name, 'id_table', 2 as sort_order  
from example.v_ust_table_population_sql
where ust_control_id = 1 and epa_table_name = 'ust_tank' 
and organization_table_name like 'erg%id' and organization_table_name is not null
union all
select distinct organization_table_name, 'org_table', 3 as sort_order  
from example.v_ust_table_population_sql
where ust_control_id = 1 and epa_table_name = 'ust_tank' 
and organization_join_table is null and deagg_table_name is null
and primary_key <> 'Y'  and organization_table_name is not null
union all
select distinct organization_join_table, 'join_table', 4 as sort_order  
from example.v_ust_table_population_sql
where ust_control_id = 1 and epa_table_name = 'ust_tank'
and organization_join_table is not null
union all
select distinct database_lookup_table, 'lookup_table', 5 as sort_order  
from example.v_ust_table_population_sql
where ust_control_id = 1 and epa_table_name = 'ust_tank'
and database_lookup_table is not null
union all
select distinct deagg_table_name, 'deagg_table', 6 as sort_order  
from example.v_ust_table_population_sql
where ust_control_id = 1 and epa_table_name = 'ust_tank'
and deagg_table_name is not null



select * from example.v_ust_table_population_sql
where epa_table_name = 'ust_tank'

	select organization_table_name, min(sort_order) sort_order from 
	

	group by organization_table_name;

select * from example.v_ust_element_mapping_joins 
where epa_table_name = 'ust_tank_substance'




select distinct organization_column_name, 
	organization_join_table, 
	organization_join_column, organization_join_fk,
	organization_join_column2, organization_join_fk2,
	organization_join_column3, organization_join_fk3,
	organization_column_name,
	database_lookup_column
	

select * from example.v_ust_element_mapping_joins 
where ust_control_id = 1 and epa_table_name = 'ust_tank_substance'
order by column_sort_order 	



/*
data_table_name = 'Tanks' 			# Enter a string containing organization table name that contains the aggregated data 
data_table_pk_cols = ['Facility Id','Tank Name'] 		# Python list of column names FROM THE SOURCE DATA that the new table should be grouped by, for example, in UST, substances may be grouped by ['FacilityID','TankID'] or ['FacilityID','TankID','CompartmentID'] 
data_deagg_column_name = 'Tank Substance' 	# Column name FROM THE SOURCE DATA that contains the aggregated values 
delimiter = ', ' 				# Defaults to ', '; delimiter from the column beging deaggregated in the source table. Use '\n' for hard returns.
deagg_table_name = 'erg_tank_substance_deagg'           # Deagg table name generated by deagg_example.py. It will begin with an 'erg_' prefix. Check column deagg_table_name in table ust_element_mapping or release_element_mapping if you don't know it. (deagg_example.py will set this value.)
*/

select epa_table_name
from example.ust_element_mapping 
where organization_table_name = 'Tanks' 
and organization_column_name = 'Tank Substance'
ust_tank_substance

select * from example.ust_element_mapping 
where epa_table_name = 'ust_tank_substance'




select distinct
	"Tank Name"::character varying(50) as tank_name,
	"Facility Id"::character varying(50) as facility_id,
	"tank_id"::integer as tank_id,	  -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
	substance_id as substance_id	  -- Source data contains multiple substances per row, delimited with a comma and space
from example."Tanks" a
	left join example."erg_tank_id" b on a."Facility Id" = b."facility_id"  and a."Tank Name" = b."tank_name" 
	left join example.v_substance_xwalk c on a."Tank Substance" = c.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;


select column_sort_order as column_id, 
 epa_column_name, organization_column_name, 
 selected_column, programmer_comments
 from example.v_ust_table_population_sql
 where ust_control_id = 1 and epa_table_name = 'ust_tank_substance'
 and column_sort_order is not null
 order by column_sort_order ;


create view example.v_ust_tank_substance as
select distinct
	"Facility Id"::character varying(50) as facility_id, 
	"tank_id"::integer as tank_id, 	  -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
	substance_id as substance_id 	  -- Source data contains multiple substances per row, delimited with a comma and space
from example."Tanks" a
	left join example."erg_tank_id" b on a."Facility Id" = b."facility_id"  and a."Tank Name" = b."tank_name" 
	left join example.v_substance_xwalk c on a."Tank Substance" = c.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;


select distinct
	"Facility Id"::character varying(50) as facility_id, 
	"tank_id"::integer as tank_id, 	  -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
	"Tank Name"::character varying(50) as tank_name, 
	"compartment_id"::integer as compartment_id, 	  -- This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.
	compartment_status_id as compartment_status_id 	  -- State does not report compartments; copied from Tank Status
from example."Tanks" a 
	left join example.erg_compartment_id b on a."Facility Id" = b.facility_id and a."Tank Name" = b.tank_name
	left join example."Tank Status Lookup" c on a."Tank Status Id" = c."Tank Status ID" 
	left join example.v_compartment_status_xwalk d on c."Tank Status Desc" = d.organization_value

	
	
from example."Tanks" a
	left join example."erg_tank_id" d on b."facility_id" = d."facility_id"  and b."tank_id" = d."tank_id" 
  	left join example."erg_compartment_id" b on d."facility_id" = b."facility_id"  and d."tank_id" = b."tank_id" 
	left join example."Tank Status Lookup" c on a."Tank Status Id" = c."Tank Status ID" 
	left join example.v_compartment_status_xwalk e on c."Tank Status Desc" = e.organization_value
  

select * from example.ust_element_mapping 
where epa_table_name = 'ust_compartment'
	

select distinct epa_column_name, epa_table_name 
from example.ust_element_mapping 
  where ust_control_id = 1 and epa_column_name in ('tank_id','tank_name')
  order by epa_column_name desc
	

select organization_table_name, table_type,
	chr(96 + row_number() over (partition by 'a' order by x.sort_order)::int) as alias
from 
	(select organization_table_name, min(sort_order) as sort_order 
	from example.v_ust_mapped_table_types a join public.mapped_table_types b on a.table_type = b.table_type
	where ust_control_id = 1 and epa_table_name = 'ust_compartment'
group by organization_table_name) x join public.mapped_table_types y on x.sort_order = y.sort_order 
order by alias  
  
  
  
  
	select * from example.erg_compartment_id

select * from example.ust_element_mapping 
where epa_table_name = 'ust_compartment'

delete from example.ust_element_mapping 
where ust_element_mapping_id = 81


select distinct
	"Facility Id"::character varying(50) as facility_id, 
	tank_id as tank_id,
	"Tank Name"::character varying(50) as tank_name, 
	"compartment_id"::integer as compartment_id, 	  -- This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.
	compartment_status_id as compartment_status_id 	  -- State does not report compartments; copied from Tank Statu
from example."Tanks" a
	left join example."erg_tank_id" b on a."Facility Id" = b."facility_id" and a."Tank Name" = b."tank_name" 
	left join example."erg_compartment_id" c on b."facility_id" = c."facility_id" and b."tank_id" = c."tank_id" 
	left join example."Tank Status Lookup" d on a."Tank Status Id" = d."Tank Status ID" 
	left join example.v_compartment_status_xwalk e on d."Tank Status Desc" = e.organization_value
	

	
create view example.v_ust_compartment as
select distinct
	"Facility Id"::character varying(50) as facility_id, 
	"Tank Name"::character varying(50) as tank_name, 
	"compartment_id"::integer as compartment_id, 	  -- This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.
	compartment_status_id as compartment_status_id 	  -- State does not report compartments; copied from Tank Status
from example."Tanks" a
	left join example."erg_tank_id" b on a."Facility Id" = b."facility_id" and a."Tank Name" = b."tank_name" 
	left join example."erg_compartment_id" c on b."facility_id" = c."facility_id" and b."tank_id" = c."tank_id" 
	left join example."Tank Status Lookup" d on a."Tank Status Id" = d."Tank Status ID" 
	left join example.v_compartment_status_xwalk e on d."Tank Status Desc" = e.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE
;	

select column_sort_order, a.column_name, a.data_type, a.character_maximum_length
 from information_schema.columns a join public.ust_required_view_columns b 
 on a.table_name = b.information_schema_table_name and a.column_name = b.column_name
 where table_schema = 'public' and b.table_name = 'ust_compartment' 
 and b.column_name not in 
 (select epa_column_name from example.v_ust_element_mapping_joins
 where ust_control_id = 1 and epa_table_name = 'ust_compartment')
 order by column_sort_order;


select column_sort_order as column_id, 
 epa_column_name, organization_column_name, 
 selected_column, programmer_comments
 from example.v_ust_table_population_sql
 where ust_control_id = 1 and epa_table_name = 'ust_compartment'
 and column_sort_order is not null
 order by column_sort_order ;

select * from example.v_ust_table_population 
where epa_table_name = 'ust_compartment'

select * from example.v_ust_element_mapping_joins
where epa_table_name = 'ust_compartment'


select * from public.ust_required_view_columns
where table_name = 'ust_compartment' 

select * from information_schema.columns where table_name = 'ust_required_view_columns'


alter table ust_required_view_columns add information_schema_table_name varchar(100);


alter table ust_required_view_columns add column_sort_order int;

update ust_required_view_columns set column_sort_order = 1 where column_name = 'facility_id';
update ust_required_view_columns set column_sort_order = 2 where column_name = 'tank_id';
update ust_required_view_columns set column_sort_order = 3 where column_name = 'compartment_id';

select * from public.ust_required_view_columns
order by table_name, column_sort_order;

update ust_required_view_columns set column_sort_order = 4 where table_name = 'ust_compartment' and column_name = 'compartment_status_id';
update ust_required_view_columns set column_sort_order = 4 where table_name = 'ust_compartment_substance' and column_name = 'substance_id';
update ust_required_view_columns set column_sort_order = 4 where table_name = 'ust_compartment_dispenser' and column_name = 'dispenser_id';
update ust_required_view_columns set column_sort_order = 2 where table_name = 'ust_facility' and column_name = 'facility_state';
update ust_required_view_columns set column_sort_order = 2 where table_name = 'ust_facility_dispenser' and column_name = 'dispenser_id';
update ust_required_view_columns set column_sort_order = 4 where table_name = 'ust_piping' and column_name = 'piping_id';
update ust_required_view_columns set column_sort_order = 3 where table_name = 'ust_tank_dispenser' and column_name = 'dispenser_id';
update ust_required_view_columns set column_sort_order = 3 where table_name = 'ust_tank_substance' and column_name = 'substance_id';
update ust_required_view_columns set column_sort_order = 3 where table_name = 'ust_tank' and column_name = 'tank_status_id';

insert into ust_required_view_columns  values ('ust_compartment_dispenser','compartment_id','N','ust_compartment',3);


insert into ust_required_view_columns  values ('ust_compartment_substance','compartment_id','N','ust_compartment',3);

select 'update ust_required_view_columns set information_schema_table_name = '''' where table_name = ''' || 
	table_name || ''' and column_name = ''' || column_name || ''';'
from ust_required_view_columns
order by 1;

update ust_required_view_columns set information_schema_table_name = 'ust_facility' where column_name = 'facility_id';
update ust_required_view_columns set information_schema_table_name = 'ust_tank' where column_name = 'tank_id';
update ust_required_view_columns set information_schema_table_name = 'ust_compartment' where column_name = 'compartment_id';

update ust_required_view_columns set information_schema_table_name = table_name where information_schema_table_name is null;
	
select * from example.ust_element_mapping 
where epa_table_name = 'ust_compartment'
and organization_join_table = 'erg_tank_id'
	
select distinct organization_table_name, organization_join_table, 
 organization_join_column, organization_join_fk,
 organization_join_column2, organization_join_fk2,
 organization_join_column3, organization_join_fk3,
 organization_column_name
 from example.v_ust_element_mapping_joins
 where ust_control_id = 1 and epa_table_name = 'ust_tank' 
 and organization_table_name = 'erg_tank_id'
 order by 1, 2, 3;


select organization_table_name, table_type,
chr(96 + row_number() over (partition by 'a' order by x.sort_order)::int) as alias
  from 
	(select organization_table_name, min(sort_order) as sort_order 
	from example.v_ust_mapped_table_types a join public.mapped_table_types b on a.table_type = b.table_type
	where ust_control_id = 1 and epa_table_name = 'ust_compartment'
group by organization_table_name) x join public.mapped_table_types y on x.sort_order = y.sort_order 
order by alias	
	

select * from  example.v_ust_mapped_table_types
where epa_table_name = 'ust_compartment'

select * from example.ust_element_mapping 
where epa_table_name = 'ust_compartment'


 SELECT v_ust_table_population_sql.ust_control_id,
    v_ust_table_population_sql.epa_table_name,
    v_ust_table_population_sql.organization_join_table AS organization_table_name,
    'join'::text AS table_type
   FROM example.v_ust_table_population_sql
  WHERE COALESCE(v_ust_table_population_sql.primary_key, 'N'::character varying, 'Y'::character varying)::text <> 'Y'::text AND v_ust_table_population_sql.organization_join_table IS NOT NULL


  
select * from example.v_ust_table_population_sql 
where epa_table_name = 'ust_compartment'


select * from example.v_ust_table_population 
where epa_table_name = 'ust_tank'

select * from example.v_ust_table_population 
where epa_table_name = 'ust_piping'


select distinct organization_table_name, organization_join_table, 
 organization_join_column, organization_join_fk,
 organization_join_column2, organization_join_fk2,
 organization_join_column3, organization_join_fk3,
 organization_column_name
 from example.v_ust_element_mapping_joins
 where ust_control_id = 1 
 and epa_table_name = 'ust_compartment' 
 and organization_join_table= 'erg_tank_id'
 order by 1, 2, 3;


select organization_table_name, table_type,
chr(96 + row_number() over (partition by 'a' order by x.sort_order)::int) as alias
  from 
	(select organization_table_name, min(sort_order) as sort_order 
	from example.v_ust_mapped_table_types a join public.mapped_table_types b on a.table_type = b.table_type
	where ust_control_id = 1 and epa_table_name = 'ust_compartment'
group by organization_table_name) x join public.mapped_table_types y on x.sort_order = y.sort_order 
order by alias	
	

select * from example.v_ust_mapped_table_types

select organization_table_name, table_type,
					chr(96 + row_number() over (partition by 'a' order by x.sort_order)::int) as alias
				  from 
					(select organization_table_name, min(sort_order) as sort_order 
					from example.v_ust_mapped_table_types a join public.mapped_table_types b on a.table_type = b.table_type
					where ust_control_id = 1 and epa_table_name = 'ust_compartment'
					group by organization_table_name) x join public.mapped_table_types y on x.sort_order = y.sort_order 
					order by alias
					
					
		select * from public.mapped_table_types order by 2;

update public.mapped_table_types set sort_order = sort_order +1 where sort_order > 1;
insert into public.mapped_table_types values ('id-join',2);

update public.mapped_table_types set sort_order = 2 where table_type = 'id'

select organization_table_name, table_type,
	chr(96 + row_number() over (partition by 'a' order by x.sort_order)::int) as alias
  from 
	(select organization_table_name, min(sort_order) as sort_order 
	from example.v_ust_mapped_table_types a join public.mapped_table_types b on a.table_type = b.table_type
	where ust_control_id = 1 and epa_table_name = 'ust_compartment'
	group by organization_table_name) x join public.mapped_table_types y on x.sort_order = y.sort_order 
	order by alias
                
	
select * from  public.mapped_table_types order by 2;
	
update  public.mapped_table_types  set sort_order = 6 where table_type = 'deagg';
update  public.mapped_table_types  set sort_order = 7 where table_type = 'lookup';


update  public.mapped_table_types  set sort_order = 3 where table_type = 'id'

select * from example.v_ust_mapped_table_types
where  ust_control_id = 1 and epa_table_name = 'ust_compartment'

-- example.v_ust_mapped_table_types source

CREATE OR REPLACE VIEW example.v_ust_mapped_table_types_all
AS SELECT v_ust_table_population_sql.ust_control_id,
    v_ust_table_population_sql.epa_table_name,
    v_ust_table_population_sql.organization_table_name,
    'key'::text AS table_type,
    1 as sort_order
   FROM example.v_ust_table_population_sql
  WHERE COALESCE(v_ust_table_population_sql.primary_key, 'N'::character varying, 'Y'::character varying)::text = 'Y'::text AND v_ust_table_population_sql.organization_table_name::text !~~ 'erg%id'::text AND v_ust_table_population_sql.organization_table_name IS NOT NULL
UNION all 
 SELECT v_ust_table_population_sql.ust_control_id,
    v_ust_table_population_sql.epa_table_name,
    v_ust_table_population_sql.organization_join_table,
    'id-join'::text AS table_type,
    2 as sort_order
   FROM example.v_ust_table_population_sql
  WHERE v_ust_table_population_sql.organization_join_table::text ~~ 'erg%id'::text AND v_ust_table_population_sql.organization_join_table IS NOT NULL
  UNION ALL
 SELECT v_ust_table_population_sql.ust_control_id,
    v_ust_table_population_sql.epa_table_name,
    v_ust_table_population_sql.organization_table_name,
    'id'::text AS table_type,
    3 as sort_order
   FROM example.v_ust_table_population_sql
  WHERE v_ust_table_population_sql.organization_table_name::text ~~ 'erg%id'::text AND v_ust_table_population_sql.organization_table_name IS NOT NULL
UNION ALL
 SELECT v_ust_table_population_sql.ust_control_id,
    v_ust_table_population_sql.epa_table_name,
    v_ust_table_population_sql.organization_table_name,
    'org'::text AS table_type,
    4 as sort_order
   FROM example.v_ust_table_population_sql
  WHERE COALESCE(v_ust_table_population_sql.primary_key, 'N'::character varying, 'Y'::character varying)::text <> 'Y'::text AND v_ust_table_population_sql.organization_table_name IS NOT NULL
UNION ALL
 SELECT v_ust_table_population_sql.ust_control_id,
    v_ust_table_population_sql.epa_table_name,
    v_ust_table_population_sql.organization_join_table AS organization_table_name,
    'join'::text AS table_type,
    5 as sort_order
   FROM example.v_ust_table_population_sql
  --WHERE COALESCE(v_ust_table_population_sql.primary_key, 'N'::character varying, 'Y'::character varying)::text <> 'Y'::text AND 
  where v_ust_table_population_sql.organization_join_table IS NOT NULL
UNION ALL
 SELECT v_ust_table_population_sql.ust_control_id,
    v_ust_table_population_sql.epa_table_name,
    v_ust_table_population_sql.deagg_table_name AS organization_table_name,
    'deagg'::text AS table_type,
    6 as sort_order
   FROM example.v_ust_table_population_sql
  WHERE v_ust_table_population_sql.deagg_table_name IS NOT NULL
 UNION ALL
 SELECT v_ust_table_population_sql.ust_control_id,
    v_ust_table_population_sql.epa_table_name,
    v_ust_table_population_sql.database_lookup_table AS organization_table_name,
    'lookup'::text AS table_type,
    7 as sort_order
   FROM example.v_ust_table_population_sql
  WHERE v_ust_table_population_sql.database_lookup_table IS NOT NULL ;

 
 select distinct deagg_column_name 
 
 select *
 from example.v_ust_element_mapping_joins
 where ust_control_id = 1 and epa_table_name = 'ust_tank_substance' 
 and deagg_table_name = 'erg_tank_substance_datarows_deagg';
 
select * from example.ust_element_mapping 
where epa_table_name = 'ust_tank_substance' 

select * from example.erg_tank_substance_datarows_deagg;

update example.ust_element_mapping 
 set deagg_table_name = 'erg_tank_substance_datarows_deagg', 
	organization_join_table = 'Tanks' , 
	organization_join_column = 'Facility Id',
	organization_join_fk = 'Facility Id',
	organization_join_column2 = 'Tank Name', 
	organization_join_fk2 = 'Tank Name' 
where ust_control_id = 1 and deagg_table_name = 'erg_tank_substance_datarows_deagg';


select distinct
	a."Facility Id"::character varying(50) as facility_id, 
	b."tank_id"::integer as tank_id, 	  -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
	substance_id as substance_id 	  -- Source data contains multiple substances per row, delimited with a comma and space.
from example."Tanks" a
	left join example."erg_tank_id" b on a."Facility Id" = b."facility_id" and a."Tank Name" = b."tank_name" 
	left join example."erg_tank_substance_datarows_deagg" c on a."Facility Id" = c."Facility Id" and a."Tank Name" = c."Tank Name" 
	left join example.v_substance_xwalk d on c."Tank Substance" = d.organization_value
order by 1, 2;	
	

select * from example.ust_element_mapping where epa_table_name = 'ust_piping'


drop view example.v_ust_mapped_table_types;
create or replace view example.v_ust_mapped_table_types as
select a.ust_control_id, a.epa_table_name, a.organization_table_name, b.table_type
from 
	(select ust_control_id, epa_table_name, organization_table_name, min(sort_order) as sort_order
	from example.v_ust_mapped_table_types_all
	group by ust_control_id, epa_table_name, organization_table_name) a 
	join example.v_ust_mapped_table_types_all b 
		on a.ust_control_id = b.ust_control_id and a.epa_table_name = b.epa_table_name 
		and a.organization_table_name = b.organization_table_name and a.sort_order = b.sort_order;

	
where epa_table_name = 'ust_compartment'



create view example.v_ust_tank_substance as
select distinct
	"Tank Name"::character varying(50) as tank_name,
	"Facility Id"::character varying(50) as facility_id,
	substance_id as substance_id,	  -- Source data contains multiple substances per row, delimited with a comma and space
from example."Tanks" a
	left join example."erg_tank_id" b on a."Facility Id" = b."facility_id" and a."Tank Name" = b."tank_name" 
	left join example.erg_tank_substance_deagg c on a."Tank Substance" = b."Tank Substance" 

	select * from example.erg_tank_substance_deagg;

select * from example.ust_element_mapping 
where epa_table_name = 'ust_tank_substance'


select distinct
	"Facility Id"::character varying(50) as facility_id,
	"tank_id"::integer as tank_id,	  -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
	"Tank Name"::character varying(50) as tank_name,
	tank_location_id as tank_location_id,	  -- Exclude if = AST
	tank_status_id as tank_status_id,
	"Closure Date"::date as tank_closure_date,
	"Install Date"::date as tank_installation_date
from example."Tanks" a
	left join example."erg_tank_id" b on a."Facility Id" = b."facility_id"  and a."Tank Name" = b."tank_name" 
	left join example."Tank Status Lookup" c on a."Tank Status Id" = c."Tank Status ID" 
	left join example.v_tank_status_xwalk d on c."Tank Status Desc" = d.organization_value
	left join example.v_tank_location_xwalk e on a."Tank Type" = e.organization_value
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE


select distinct
	a."Facility Id"::character varying(50) as facility_id, 
	a."Tank Name"::character varying(50) as tank_name, 
	"piping_id"::character varying(50) as piping_id, 	  -- This required field is not present in the source data. Table erg_piping_id was created by ERG so the data can conform to the EPA template structure.
--	"Piping Material Desc"::character varying(3) as piping_material_frp, 	  -- if "Piping Material Desc" = "Fiberglass Reinforced Plastic" then "Yes"
--	"Piping Material Desc"::character varying(3) as piping_material_stainless_steel, 	  -- if "Piping Material Desc" = "Stainless Steel" then "Yes"
--	"Piping Material Desc"::character varying(3) as piping_material_steel, 	  -- if "Piping Material Desc" = "Steel" then "Yes"
--	"Piping Material Desc"::character varying(3) as piping_material_copper, 	  -- if "Piping Material Desc" = "Copper" then "Yes"
--	"Piping Material Desc"::character varying(3) as piping_material_flex, 	  -- if "Piping Material Desc" = "Flex Piping" then "Yes"
--	"Piping Material Desc"::character varying(3) as piping_material_other 	  -- if "Piping Material Desc" = "Other" then "Yes"
from example."Tanks" a
	left join example."erg_tank_id" b on c."facility_id" = b."facility_id" and c."tank_id" = b."tank_id" 
	left join example."erg_compartment_id" c on b."facility_id" = c."facility_id" and b."tank_id" = c."tank_id" 
	left join example."Piping Material Lookup" e on f."Piping Material Id" = e."Piping Material ID" 
	left join example."Tank Piping" f on e."Piping Material Id" = f."Piping Material ID" 



select * from example.ust_element_mapping 
where epa_table_name = 'ust_piping'



select a.table_name, column_sort_order, a.column_name, a.data_type, a.character_maximum_length
from information_schema.columns a join public.ust_required_view_columns b 
	on a.table_name = b.information_schema_table_name and a.column_name = b.column_name
where table_schema = 'public' and b.table_name = 'ust_piping' 
and b.column_name not in 
	(select epa_column_name from example.v_ust_element_mapping_joins
	where ust_control_id = 1 and epa_table_name =  'ust_piping' )
order by column_sort_order

select * from public.ust_required_view_columns
where table_name = 'ust_piping' 
order by column_sort_order;


select column_sort_order as column_id, 
					epa_column_name, organization_column_name, 
					selected_column, programmer_comments,
					organization_table_name
			from example.v_ust_table_population_sql
			where ust_control_id = 1 and epa_table_name = 'ust_piping_id'
--			and column_sort_order is not null
			order by column_sort_order


select * from example.ust_element_mapping 
where epa_table_name = 'ust_piping'

select * from example.ust_element_mapping 
where epa_table_name = 'ust_compartment'


select distinct
	a."Facility Id"::character varying(50) as facility_id, 
	b."tank_id"::integer as tank_id, 	  -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
	a."Tank Name"::character varying(50) as tank_name, 
	"piping_id"::character varying(50) as piping_id, 	  -- This required field is not present in the source data. Table erg_piping_id was created by ERG so the data can conform to the EPA template structure.
	"Piping Material Desc"::character varying(3) as piping_material_frp, 	  -- if "Piping Material Desc" = "Fiberglass Reinforced Plastic" then "Yes"
	"Piping Material Desc"::character varying(3) as piping_material_stainless_steel, 	  -- if "Piping Material Desc" = "Stainless Steel" then "Yes"
	"Piping Material Desc"::character varying(3) as piping_material_steel, 	  -- if "Piping Material Desc" = "Steel" then "Yes"
	"Piping Material Desc"::character varying(3) as piping_material_copper, 	  -- if "Piping Material Desc" = "Copper" then "Yes"
	"Piping Material Desc"::character varying(3) as piping_material_flex, 	  -- if "Piping Material Desc" = "Flex Piping" then "Yes"
	"Piping Material Desc"::character varying(3) as piping_material_other 	  -- if "Piping Material Desc" = "Other" then "Yes"
from example."Tanks" a
	left join example."erg_tank_id" b on c."facility_id" = b."facility_id" and c."tank_id" = b."tank_id" 
	left join example."erg_compartment_id" c on b."facility_id" = c."facility_id" and b."tank_id" = c."tank_id" 
	left join example."Piping Material Lookup" e on f."Piping Material Id" = e."Piping Material ID" 
	left join example."Tank Piping" f on e."Piping Material Id" = f."Piping Material ID" 





select distinct
	a."Facility Id"::character varying(50) as facility_id, 
	b."tank_id"::integer as tank_id, 	  -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
	a."Tank Name"::character varying(50) as tank_name, 
	"piping_id"::character varying(50) as piping_id--, 	  -- This required field is not present in the source data. Table erg_piping_id was created by ERG so the data can conform to the EPA template structure.
--	"Piping Material Desc"::character varying(3) as piping_material_frp, 	  -- if "Piping Material Desc" = "Fiberglass Reinforced Plastic" then "Yes"
--	"Piping Material Desc"::character varying(3) as piping_material_stainless_steel, 	  -- if "Piping Material Desc" = "Stainless Steel" then "Yes"
--	"Piping Material Desc"::character varying(3) as piping_material_steel, 	  -- if "Piping Material Desc" = "Steel" then "Yes"
--	"Piping Material Desc"::character varying(3) as piping_material_copper, 	  -- if "Piping Material Desc" = "Copper" then "Yes"
--	"Piping Material Desc"::character varying(3) as piping_material_flex, 	  -- if "Piping Material Desc" = "Flex Piping" then "Yes"
--	"Piping Material Desc"::character varying(3) as piping_material_other 	  -- if "Piping Material Desc" = "Other" then "Yes"
from example."Tanks" a
	left join example."erg_tank_id" b on a."Facility Id" = b."facility_id" and a."Tank Name" = b."tank_name" 
	left join example."erg_compartment_id" c on b."facility_id" = c."facility_id" and b."tank_id" = c."tank_id" 
	left join example."Piping Material Lookup" e on f."Piping Material Id" = e."Piping Material ID" 
	left join example."Tank Piping" f on e."Piping Material Id" = f."Piping Material ID" 
	
--ust_compartment	
Tanks                          key     a
erg_tank_id                id-join     b
erg_compartment_id              id     c
Tank Status Lookup             org     d
compartment_statuses        lookup     e

--ust_piping 
Tanks                          key     a
erg_tank_id                id-join     b
erg_compartment_id              id     c
erg_piping_id                   id     d
Piping Material Lookup         org     e
Tank Piping                   join     f

select * from example.erg_piping_id

select * from example.ust_element_mapping 
where epa_table_name = 'ust_piping'

select distinct organization_table_name, organization_join_table, 
					organization_join_column, organization_join_fk,
					organization_join_column2, organization_join_fk2,
					organization_join_column3, organization_join_fk3,
					organization_column_name
from example.v_ust_element_mapping_joins
where ust_control_id = 1 and epa_table_name = 'ust_piping'
and organization_table_name = '' 
order by 1, 2, 3

select distinct organization_table_name, organization_join_table, 
 organization_join_column, organization_join_fk,
 organization_join_column2, organization_join_fk2,
 organization_join_column3, organization_join_fk3,
 organization_column_name
 from example.v_ust_element_mapping_joins
 where ust_control_id = 1 and epa_table_name = 'ust_piping' 
 and organization_table_name = 'erg_piping_id'
 order by 1, 2, 3;

select * from example.ust_element_mapping 
where epa_table_name = 'ust_piping' 
 and organization_table_name = 'erg_piping_id'
 order by 1, 2, 3;

select * from example.ust_element_mapping 
where epa_table_name = 'ust_piping' 


select * from example.ust_element_mapping 
where organization_table_name  = 'erg_compartment_id' 



--update create_missign_id_example.py, the if statement where = 'ust_piping':
--need join column info!!


from example."Tanks" a
	left join example."erg_tank_id" b on a."Facility Id" = b."facility_id" and a."Tank Name" = b."tank_name" 
	left join example."erg_compartment_id" c on b."facility_id" = c."facility_id" and b."tank_id" = c."tank_id" 
	left join example."Tank Status Lookup" d on a."Tank Status Id" = d."Tank Status ID" 
	left join example.v_compartment_status_xwalk e on d."Tank Status Desc" = e.organization_value

	

select epa_table_name, epa_column_name, organization_table_name, organization_column_name,
	organization_join_table, organization_join_column, organization_join_fk,
	organization_join_column2, organization_join_fk2,
	organization_join_column3, organization_join_fk3
from example.ust_element_mapping 
where (epa_table_name = 'ust_piping' and organization_table_name = 'erg_piping_id')
or (epa_table_name = 'ust_compartment' and organization_table_name = 'erg_compartment_id');

	
	select epa_table_name, epa_column_name, organization_table_name, organization_column_name,
		organization_join_table, organization_join_column, organization_join_fk,
		organization_join_column2, organization_join_fk2,
		organization_join_column3, organization_join_fk3
	from example.ust_element_mapping 
	where epa_table_name = 'ust_piping' and epa_column_name = 'compartment_id'


select distinct epa_column_name, organization_table_name, organization_join_table, 
 organization_join_column, organization_join_fk,
 organization_join_column2, organization_join_fk2,
 organization_join_column3, organization_join_fk3,
 organization_column_name
 from example.v_ust_element_mapping_joins
 where ust_control_id = 1 and epa_table_name = 'ust_piping' 
 --and organization_table_name = 'Tank Piping'
 order by 1, 2, 3;	

select * from example.ust_element_mapping 
where epa_table_name = 'ust_piping';

update example.ust_element_mapping 
set organization_table_name = 'Tank Piping'
where ust_element_mapping_id in (22, 23)

select organization_table_name, table_type,
					chr(96 + row_number() over (partition by 'a' order by x.sort_order)::int) as alias
from 
	(select organization_table_name, min(sort_order) as sort_order 
	from example.v_ust_mapped_table_types a join public.mapped_table_types b on a.table_type = b.table_type
	where ust_control_id = 1 and epa_table_name = 'ust_piping'
group by organization_table_name) x join public.mapped_table_types y on x.sort_order = y.sort_order 
order by alias

select * from public.mapped_table_types order by 2;

create table public.generated_table_sort_order (table_name varchar(100) primary key, 	
 sort_order int);

insert into public.generated_table_sort_order values ('erg_facility_id', 1);
insert into public.generated_table_sort_order values ('erg_tank_id', 2);
insert into public.generated_table_sort_order values ('erg_compartment_id', 3);
insert into public.generated_table_sort_order values ('erg_piping_id', 4);

select * from example.ust_element_mapping 
where organization_table_name = 'Tank Piping'

select * from example.v_ust_mapped_table_types 
where organization_table_name = 'Tank Piping'

select * from example.ust_element_mapping 
where organization_join_table = 'Tank Piping'

select * 
from example.ust_element_mapping 
where epa_table_name = 'ust_piping'

select * from example."Tank Piping"

select a.*, epa_column_name, epa_table_name, b.sort_order 
from example.ust_element_mapping a join public.ust_element_table_sort_order b 
	on a.epa_table_name = b.table_name
where ust_control_id = 1 and epa_column_name in ('tank_id','tank_name')
and epa_table_name = 'ust_piping'
order by epa_column_name desc, b.sort_order 

select * from ust_element_table_sort_order order by sort_order;

select distinct organization_table_name from example.ust_element_mapping
where ust_control_id = 1 and epa_table_name = 'ust_piping' and epa_column_name = 'tank_name'


select * from example.ust_element_mapping 
where epa_table_name = 'ust_piping' and epa_column_name = 'tank_name'


select organization_table_name, organization_column_name, organization_join_table, 
	organization_join_column, organization_join_fk, 
	organization_join_column2, organization_join_fk2,   
	organization_join_column3, organization_join_fk3
from example.ust_element_mapping 
where epa_table_name = 'ust_piping' and epa_column_name in ('tank_id','tank_name')

select distinct
	a."Facility Id"::character varying(50) as facility_id, 
	b."tank_id"::integer as tank_id, 	  -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
	a."Tank Name"::character varying(50) as tank_name, 
	c.compartment_id,
	"piping_id"::character varying(50) as piping_id--, 	  -- This required field is not present in the source data. Table erg_piping_id was created by ERG so the data can conform to the EPA template structure.
--	"Piping Material Desc"::character varying(3) as piping_material_frp, 	  -- if "Piping Material Desc" = "Fiberglass Reinforced Plastic" then "Yes"
--	"Piping Material Desc"::character varying(3) as piping_material_stainless_steel, 	  -- if "Piping Material Desc" = "Stainless Steel" then "Yes"
--	"Piping Material Desc"::character varying(3) as piping_material_steel, 	  -- if "Piping Material Desc" = "Steel" then "Yes"
--	"Piping Material Desc"::character varying(3) as piping_material_copper, 	  -- if "Piping Material Desc" = "Copper" then "Yes"
--	"Piping Material Desc"::character varying(3) as piping_material_flex, 	  -- if "Piping Material Desc" = "Flex Piping" then "Yes"
--	"Piping Material Desc"::character varying(3) as piping_material_other 	  -- if "Piping Material Desc" = "Other" then "Yes"
from example."Tank Piping" a
	left join example."erg_tank_id" b on a."Facility Id" = b."facility_id" and a."Tank Name" = b."tank_name" 
	left join example."erg_compartment_id" c on b."facility_id" = c."facility_id" and b."tank_id" = c."tank_id" 
	left join example."erg_piping_id" d on c."facility_id" = d."facility_id" and c."tank_id" = d."tank_id" and c."compartment_id" = d."compartment_id" 
	left join example."Piping Material Lookup" e on a."Piping Material Id" = e."Piping Material ID" 

	
	select distinct epa_table_name, table_sort_order
			from example.v_ust_table_population 
			where ust_control_id = 1
			order by table_sort_order
ust_facility	1
ust_tank	2
ust_tank_substance	3



select column_sort_order as column_id, 
 epa_column_name, organization_column_name, 
 selected_column, programmer_comments,
 organization_table_name
 from example.v_ust_table_population_sql
 where ust_control_id = 1 and epa_table_name = 'ust_piping'
 and column_sort_order is not null
 order by column_sort_order ;

select * from example.v_ust_table_population
where ust_control_id = 1 and epa_table_name = 'ust_piping'


ust_compartment	4
ust_piping	6
ust_tank_dispenser	8
ust_compartment_dispenser	9
ust_piping	
ust_tank_substance	
		
select * from ust_template_data_tables;	

select * from ust_template_data_tables

select * from example.v_ust_table_population where table_sort_order is null;

ust_piping	compartment_id
ust_tank_substance	tank_name

compartment_id	erg_compartment_id	compartment_id

select * from example.ust_element_mapping where epa_table_name = 'ust_piping'


select *
from  example."Tank Piping" a
left join example."erg_tank_id" b on a."Facility Id" = b."facility_id" and a."Tank Name" = b."tank_name" 
left join example."erg_compartment_id" c on a."facility_id" = c."facility_id" and a."tank_id" = c."tank_id" 
	

select distinct epa_column_name, organization_table_name, organization_join_table, 
 organization_join_column, organization_join_fk,
 organization_join_column2, organization_join_fk2,
 organization_join_column3, organization_join_fk3,
 organization_column_name
 from example.v_ust_element_mapping_joins
 where ust_control_id = 1 and epa_table_name = 'ust_piping' 
 --and organization_table_name = 'Tank Piping'
 order by 1, 2, 3;	



--add environmental audit to how release detected (for DET), update tn_release  to other
--add release comment field, repairs in how release detected in tn_release
















select distinct
	a."Facility Id"::character varying(50) as facility_id, 
	b."tank_id"::integer as tank_id, 	  -- This required field is not present in the source data. Table erg_tank_id was created by ERG so the data can conform to the EPA template structure.
	a."Tank Name"::character varying(50) as tank_name, 
	c."compartment_id"::integer as compartment_id, 	  -- This required field is not present in the source data. Table erg_compartment_id was created by ERG so the data can conform to the EPA template structure.
	"piping_id"::character varying(50) as piping_id, 	  -- This required field is not present in the source data. Table erg_piping_id was created by ERG so the data can conform to the EPA template structure.
	"Piping Material Desc"::character varying(3) as piping_material_frp, 	  -- if "Piping Material Desc" = "Fiberglass Reinforced Plastic" then "Yes"
	"Piping Material Desc"::character varying(3) as piping_material_stainless_steel, 	  -- if "Piping Material Desc" = "Stainless Steel" then "Yes"
	"Piping Material Desc"::character varying(3) as piping_material_steel, 	  -- if "Piping Material Desc" = "Steel" then "Yes"
	"Piping Material Desc"::character varying(3) as piping_material_copper, 	  -- if "Piping Material Desc" = "Copper" then "Yes"
	"Piping Material Desc"::character varying(3) as piping_material_flex, 	  -- if "Piping Material Desc" = "Flex Piping" then "Yes"
	"Piping Material Desc"::character varying(3) as piping_material_other 	  -- if "Piping Material Desc" = "Other" then "Yes"
from example."Tank Piping" a
--	left join example."erg_tank_id" b on c."facility_id" = b."facility_id" and c."tank_id" = b."tank_id" 
	left join example."erg_tank_id" b on a."Facility Id" = b."facility_id" and a."Tank Name" = b."tank_name" 
--	left join example."erg_compartment_id" c on d."facility_id" = c."facility_id" and d."tank_id" = c."tank_id" and d."compartment_id" = c."compartment_id" 
	left join example."erg_compartment_id" c on b."facility_id" = c."facility_id" and b."tank_id" = c."tank_id"  
	left join example."erg_piping_id" d on c."facility_id" = d."facility_id" and c."tank_id" = d."tank_id" and c."compartment_id" = d."compartment_id"
	left join example."Piping Material Lookup" e on a."Piping Material Id" = e."Piping Material ID" ;
where -- ADD ADDITIONAL SQL HERE BASED ON PROGRAMMER COMMENTS, OR REMOVE WHERE CLAUSE

select * from example.erg_tank_id 


Tank Piping                    key     a
erg_tank_id                id-join     b
erg_compartment_id         id-join     c
erg_piping_id                   id     d
Piping Material Lookup         org     e

select * from example.ust_element_mapping
where epa_table_name = 'ust_piping';




select organization_table_name, table_type,
		chr(96 + row_number() over (partition by 'a' order by x.sort_order, z.sort_order)::int) as alias
from 
	(select organization_table_name, min(sort_order) as sort_order 
	from example.v_ust_mapped_table_types a join public.mapped_table_types b on a.table_type = b.table_type
	where ust_control_id = 1 and epa_table_name = 'ust_piping'
	group by organization_table_name) x 
	join public.mapped_table_types y on x.sort_order = y.sort_order 
	left join public.generated_table_sort_order z on x.organization_table_name = z.table_name
order by alias

Tank Piping	key	a
erg_tank_id	id-join	b
erg_compartment_id	id-join	c
erg_piping_id	id	d
Piping Material Lookup	org	e




select 'comment on table ' || table_name || ' is '''';'
from information_schema.tables where table_schema = 'public'
order by 1;

select element_name, database_column_name, database_lookup_table, database_lookup_column 
from ust_elements order by 1;

select * from v_release_available_mapping 

comment on table causes is 'Lookup table for Cause (Release).';
comment on table cert_of_installations is 'Lookup table for Certification of Installation (UST).';
comment on table compartment_statuses is 'Lookup for Compartment Status (UST). Compartment Status and Tank Status have the same lookup values.';
comment on table coordinate_sources is 'Lookup for Coordinate Source (UST).';
comment on table corrective_action_strategies is 'Lookup for Corrective Action Strategy (Release).';
comment on table dispenser_udc_wall_types is 'Lookup for Dispenser UDC Wall Type (UST).';
comment on table epa_regions is 'Lookup for EPA Region (UST).';
comment on table facility_types is 'Lookup for Facility Type (UST).';
comment on table generated_table_sort_order is 'Sort order for tables created by ERG to create Facility IDs, Tank IDs, Compartment IDs, and Piping IDs when these required columns don''t exist in the source data. (UST).';
comment on table release_discovered  is 'Lookup table for Release Discovered (Release).';
comment on table mapped_table_types is 'Sort order by table type (key, org, join, id-join, id, deagg, and lookup); used by Python script to build the where clause of the views of source data that populate the base UST and Release tables.';
comment on table owner_types is 'Lookup table for Facility Owner (UST).';
comment on table performance_measures_release is 'Performance measure numbers for Releases as extracted from OUST publications. A comparison of these numbers to the processed templates is included in the review materials sent to OUST. A Python script exists to refresh this data.';
comment on table performance_measures_ust is 'Performance measure numbers for UST as extracted from OUST publications. A comparison of these numbers to the processed templates is included in the review materials sent to OUST. A Python script exists to refresh this data.';
comment on table pipe_tank_top_sump_wall_types is 'Lookup table for Piping Tank Top Sump Wall Type (UST).';
comment on table piping_styles is 'Lookup table for Piping Style (UST).';
comment on table piping_wall_types is 'Lookup table for Piping Wall Type (UST).';
comment on table release_control is 'Control table for Release submissions.';
comment on table release_element_mapping is 'Data element mapping table for Releases.';
comment on table release_element_table_sort_order is 'Sort order for EPA Releases template data tables; used by the Python script that exports a populated template.';
comment on table release_element_value_mapping is 'Data element value mapping table for Releases.';
comment on table release_elements is 'Information about Release data elements. This table can be used to construct the Reference tab of the EPA template and also includes a mapping from template element name to database column name, and where applicable, the associated lookup table.';
comment on table release_elements_tables is 'Maps the Releases template elements/database columns to the template data table(s) they are in; includes a sort order, which is used by the Python script that exports populated EPA templates.';
comment on table release_required_view_columns is 'Contains the required Release elements that must be included in the views of source data that populate the template data tables.';
comment on table release_statuses is 'Lookup table for Release Status (Release).';
comment on table release_template_data_tables is 'Maps the EPA Releases template data tables to the names of the source data views that populate them, and template tab name, and the sort order. Used by the Python script that exports a populated EPA template.';
comment on table release_template_lookup_tables is 'Maps the Release lookup tables to their ID and description column names and contains a sort order for them. Used by the Python script that exports a populated template.';
comment on table sources is 'Lookup table for Sources (Release).';
comment on table spill_bucket_wall_types is 'Lookup table for Spill Bucket Wall Type (UST).';
comment on table states is 'Lookup table for State (UST and Release).';
comment on table substances is 'Lookup table for Substance (UST: Tank/Compartment Substance Stored; Release: Substance Released).';
comment on table tank_locations is 'Lookup table for Tank Location (UST).';
comment on table tank_material_descriptions is 'Lookup table for Tank Material Description (UST).';
comment on table tank_secondary_containments is 'Lookup table for Tank Secondary Containment (UST).';
comment on table tank_statuses is 'Lookup table for Tank Status (UST). Compartment Status and Tank Status have the same lookup values.';
comment on table ust_compartment is 'Data table for Compartment in the UST template. This table must be populated with at least one compartment per tank, even for organizations that don''t report at the compartment level.';
comment on table ust_compartment_dispenser is 'Data table for Compartment Dispenser in the UST template. Dispensers can be organized by facility, tank, and/or compartment within the source data. This table stores data organized by compartment.';
comment on table ust_compartment_substance is 'Data table for Compartment Substance in the UST template. This table is only populated if the organization reports at the compartment level and the source data includes specific mapping between compartment and substance (as opposed to tank and substance).';
comment on table ust_control is 'Control table for UST submissions.';
comment on table ust_element_lookup_tables is 'Maps the UST lookup tables to their ID and description column names and contains a sort order for them. Used by the Python script that exports a populated template.';
comment on table ust_element_mapping is 'Data element mapping table for UST.';
comment on table ust_element_table_sort_order is 'Sort order for EPA UST template data tables; used by the Python script that exports a populated template.';
comment on table ust_element_value_mapping is 'Data element value mapping table for UST.';
comment on table ust_elements is 'Information about UST data elements. This table can be used to construct the Reference tab of the EPA template and also includes a mapping from template element name to database column name, and where applicable, the associated lookup table.';
comment on table ust_elements_tables is 'Maps the UST template elements/database columns to the template data table(s) they are in; includes a sort order, which is used by the Python script that exports populated EPA templates.';
comment on table ust_facility is 'Data table for Facility in the UST template, which is the parent of all other UST data tables.';
comment on table ust_facility_dispenser is 'Data table for Facility Dispenser in the UST template. Dispensers can be organized by facility, tank, and/or compartment within the source data. This table stores data organized by facility.';
comment on table ust_piping is 'Data table for Piping in the UST template. Population is this table is optional and is only applicable if piping data exists in the source data.';
comment on table ust_release is 'Data table for Releases in the Release template, which is the parent of all other Release data tables.';
comment on table ust_release_cause is 'Data table for Causes in the Release template. Population of the table is optional and is only applicable if cause exists in the source data.';
comment on table ust_release_corrective_action_strategy is 'Data table for Corrective Action Strategies in the Release template. Population of the table is optional and is only applicable if corrective action strategy exists in the source data.';
comment on table ust_release_source is 'Data table for Sources in the Release template. Population of the table is optional and is only applicable if source exists in the source data.';
comment on table ust_release_substance is 'Data table for Substance Released in the Release template. Population of the table is optional and is only applicable if substance released exists in the source data.';
comment on table ust_required_view_columns is 'Contains the required UST elements that must be included in the views of source data that populate the template data tables.';
comment on table ust_tank is 'Data table for Tank in the UST template. There should be at least one tank per facility.';
comment on table ust_tank_dispenser is 'Data table for Tank Dispenser in the UST template. Dispensers can be organized by facility, tank, and/or compartment within the source data. This table stores data organized by tank.';
comment on table ust_tank_substance is 'Data table for Tank Substance in the UST template. This table should be populated for all organizations that have substance data, regardless of whether the organization reports at the tank or compartment level. Table ust_compartment_substance is a child of this table and should be populated only for organizations that report at the compartment level and map substances to specific compartments.';
comment on table ust_template_data_tables is 'Maps the EPA UST template data tables to the names of the source data views that populate them, and template tab name, and the sort order. Used by the Python script that exports a populated EPA template.';
comment on table ust_template_lookup_tables is 'Maps the UST lookup tables to their ID and description column names and contains a sort order for them. Used by the Python script that exports a populated template.';

comment on view v_release_available_mapping is 'View that contains Release data columns that have been mapped in the release_element_mapping table. Used by the Python processing scripts.';
comment on view v_release_bad_mapping is 'View that contains Release data columns that have been mapped to values that don''t exist in a lookup table in the release_element_value_mapping table. Used for QC purposes.';
comment on view v_release_control_summary is 'View that pivots the data in the release_control table. Used by the Python script that exports the control table summary spreadsheet.';
comment on view v_release_element_mapping is 'View that aggregates data in the release_element_mapping and release_element_value_mapping tables.';
comment on view v_release_element_mapping_for_export is 'View that organizes the data in the release_element_mapping table for export by the Python script that exports element mapping for OUST review.';
comment on view v_release_element_mapping_joins is 'View that organizes the data in the release_element_mapping table for use by the Python script that builds the SQL for the source data views that populate the Release data tables.';
comment on view v_release_element_summary is 'View that summarizes Release data table and column names.';
comment on view v_release_element_summary_sql is 'View that generates SQL to be copied and pasted and the manually altered to populate the release_element_mapping table. Used by the Release processing SQL template.';
comment on view v_release_elements is 'View that summarizes the Release element information; used to build the Reference tab of the Release template by the Python script that exports populated templates.';
comment on view v_release_mapped_table_types is 'View that summarizes the mapping of EPA data table to organization data table from the release_element_mapping table and assigns a table type to the organization table, which is used by the Python script that generates SQL to write the views that populate the Release data tables.';
comment on view v_release_missing_view_mapping is 'View that contains element mapping in the release_element_mapping table that does not exist in the source data view that populates the Release data table. Used for QC purposes.';
comment on view v_release_needed_mapping is 'View that contains element value mapping in the release_element_value_mapping table that corresponds to a lookup table. Used by various Python processing scripts.';
comment on view v_release_needed_mapping_insert_sql is 'View that generates insert statements for release_element_value_mapping that can be copied, pasted, altered, and run by the developer.';
comment on view v_release_needed_mapping_summary is 'View that summarizes the data in the v_release_needed_mapping view.';
comment on view v_release_performance_measures is 'View that pivots the Release performance measures data for use by the Python script that exports the release control table summary to a spreadsheet.';
comment on view v_release_row_count_summary is 'View that pivots the number of rows in each of the source data view that populate the Release data tables; used by the Python script that exports the QAQC spreadsheet.';
comment on view v_release_table_population is 'View that summarizes the information in the release_element_mapping table; used by the Python script that generates SQL for the source data views that populate the Release data tables.';
comment on view v_release_table_population_sql is 'View that summarizes the data in the v_release_table_population view.';
comment on view v_release_table_row_count is 'View that counts the number of rows in the source data views that populate the Release data tables.';
comment on view v_release_used_source_tables is 'View that summarizes the Release source data tables that have been mapped to EPA template elements. Used by the Python script that exports source data to CSV files for OUST review.';
comment on view v_ust_available_mapping is 'View that contains UST data columns that have been mapped in the ust_element_mapping table. Used by the Python processing scripts.';
comment on view v_ust_bad_mapping is 'View that contains UST data columns that have been mapped to values that don''t exist in a lookup table in the ust_element_value_mapping table. Used for QC purposes.';
comment on view v_ust_compartment is 'Source data view that is used to populate the UST data table ust_compartment.';
comment on view v_ust_compartment_dispenser is 'Source data view that is used to populate the UST data table ust_compartment_dispenser.';
comment on view v_ust_compartment_status_mapping is 'View that filters UST data element value mapping for Compartment Status.';
comment on view v_ust_compartment_substance is 'Source data view that is used to populate the UST data table ust_compartment_substance.';
comment on view v_ust_control_summary is 'View that pivots the data in the ust_control table. Used by the Python script that exports the control table summary spreadsheet.';
comment on view v_ust_coordinate_source_mapping is 'View that filters UST data element value mapping for Coordinate Source.';
comment on view v_ust_element_mapping is 'View that aggregates data in the ust_element_mapping and ust_element_value_mapping tables.';
comment on view v_ust_element_mapping_for_export is 'View that organizes the data in the ust_element_mapping for export by the Python script that exports element mapping for OUST review.';
comment on view v_ust_element_mapping_joins is 'View that organizes the data in the ust_element_mapping table for use by the Python script that builds the SQL for the source data views that populate the UST data tables.';
comment on view v_ust_element_summary is 'View that summarizes UST data table and column names.';
comment on view v_ust_element_summary_sql is 'View that generates SQL to be copied and pasted and the manually altered to populate the release_element_mapping table. Used by the UST processing SQL template.';
comment on view v_ust_elements is 'View that summarizes the UST element information; used to build the Reference tab of the UST template by the Python script that exports populated templates.';
comment on view v_ust_facility is 'Source data view that is used to populate the UST data table ust_facility.';
comment on view v_ust_facility_dispenser is 'Source data view that is used to populate the UST data table ust_facility_dispenser.';
comment on view v_ust_facility_type_mapping is 'View that filters UST data element value mapping for Facility Type.';
comment on view v_ust_mapped_table_types is 'View that summarizes the mapping of EPA data table to organization data table from the ust_element_mapping table and assigns a table type to the organization table, which is used by the Python script that generates SQL to write the views that populate the UST data tables.';
comment on view v_ust_missing_view_mapping is 'View that contains element mapping in the ust_element_mapping table that does not exist in the source data view that populates the UST data table. Used for QC purposes.';
comment on view v_ust_needed_mapping is 'View that contains element value mapping in the ust_element_value_mapping table that corresponds to a lookup table. Used by various Python processing scripts.';
comment on view v_ust_needed_mapping_insert_sql is 'View that generates insert statements for ust_element_value_mapping that can be copied, pasted, altered, and run by the developer.';
comment on view v_ust_needed_mapping_summary is 'View that summarizes the data in the v_ust_needed_mapping view.';
comment on view v_ust_owner_type_mapping is 'View that filters UST data element value mapping for Owner Type.';
comment on view v_ust_performance_measures is 'View that pivots the UST performance measures data for use by the Python script that exports the UST control table summary to a spreadsheet.';
comment on view v_ust_pipe_tank_top_sump_wall_type_mapping is 'View that filters UST data element value mapping for Piping Tank Top Sump Wall Type.';
comment on view v_ust_piping is 'Source data view that is used to populate the UST data table ust_piping.';
comment on view v_ust_piping_style_mapping is 'View that filters UST data element value mapping for Piping Style.';
comment on view v_ust_piping_wall_type_mapping is 'View that filters UST data element value mapping for Piping Wall Type.';
comment on view v_ust_release is 'Source data view that is used to populate the Release data table ust_release.';
comment on view v_ust_release_cause is 'Source data view that is used to populate the Release data table ust_release_cause.';
comment on view v_ust_release_corrective_action_strategy is 'Source data view that is used to populate the Release data table ust_release_corrective_action_strategy.';
comment on view v_ust_release_source is 'Source data view that is used to populate the Release data table ust_release_source.';
comment on view v_ust_release_substance is 'Source data view that is used to populate the Release data table ust_release_substance.';
comment on view v_ust_row_count_summary is 'View that pivots the number of rows in each of the source data view that populate the UST data tables; used by the Python script that exports the QAQC spreadsheet.';
comment on view v_ust_spill_bucket_wall_type_mapping is 'View that filters UST data element value mapping for Spill Bucket Wall Type.';
comment on view v_ust_substance_mapping is 'View that filters UST data element value mapping for Substance.';
comment on view v_ust_table_population is 'View that summarizes the information in the ust_element_mapping table; used by the Python script that generates SQL for the source data views that populate the UST data tables.';
comment on view v_ust_table_population_sql is 'View that summarizes the data in the v_ust_table_population view.';
comment on view v_ust_table_row_count is 'View that counts the number of rows in the source data views that populate the UST data tables.';
comment on view v_ust_tank is 'Source data view that is used to populate the UST data table ust_tank.';
comment on view v_ust_tank_dispenser is 'Source data view that is used to populate the UST data table ust_tank_dispenser.';
comment on view v_ust_tank_location_mapping is 'View that filters UST data element value mapping for Tank Location.';
comment on view v_ust_tank_material_description_mapping is 'View that filters UST data element value mapping for Tank Material Description.';
comment on view v_ust_tank_secondary_containment_mapping is 'View that filters UST data element value mapping for Tank Secondary Containment.';
comment on view v_ust_tank_status_mapping is 'View that filters UST data element value mapping for Tank Status.';
comment on view v_ust_tank_substance is 'Source data view that is used to populate the UST data table ust_tank_substance.';
comment on view v_ust_used_source_tables is 'View that summarizes the UST source data tables that have been mapped to EPA template elements. Used by the Python script that exports source data to CSV files for OUST review.';







CREATE FUNCTION get_table_comment(
     p_relname text, p_schemaname text DEFAULT NULL
 ) RETURNS text AS $f$
    SELECT obj_description((CASE 
       WHEN strpos($1, '.')>0 THEN $1
       WHEN $2 IS NULL THEN 'public.'||$1
       ELSE $2||'.'||$1
            END)::regclass, 'pg_class');
 $f$ LANGUAGE SQL;
 

select get_table_comment('ust_elements')