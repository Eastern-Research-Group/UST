
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




create view public.v_ust_element_mapping_joins as
select epa_table_name, epa_column_name, 
       organization_table_name, organization_column_name, 
       organization_join_table, 
       organization_join_column, organization_join_fk,
       organization_join_column2, organization_join_fk2,
       organization_join_column3, organization_join_fk3,
       ust_element_mapping_id, ust_control_id, 
       b.sort_order as table_sort_order, d.sort_order as column_sort_order
from public.ust_element_mapping a left join public.ust_element_table_sort_order b 
		on a.epa_table_name = b.table_name	
	left join public.ust_elements c 
		on a.epa_column_name = c.database_column_name 
	left join public.ust_elements_tables d 
		on c.element_id = d.element_id and b.table_name = d.table_name;

create view public.v_release_element_mapping_joins as
select epa_table_name, epa_column_name, 
       organization_table_name, organization_column_name, 
       organization_join_table, 
       organization_join_column, organization_join_fk,
       organization_join_column2, organization_join_fk2,
       organization_join_column3, organization_join_fk3,
       release_element_mapping_id, release_control_id, 
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


select * from example.v_ust_element_mapping_joins 
where epa_table_name = 'ust_tank'
order column_sort_order




