--Oregon SQL Server:
select 'select * from ' + table_name + ';' 
from information_schema.tables 
where table_name not like 'DEL%' and table_name not like '%log'
and table_name not like 'TEMP%'
and table_type = 'BASE TABLE'
order by 1;


drop table TEMP_erg_tables;
create table TEMP_erg_tables (table_name varchar(100) not null primary key, exported varchar(1));


insert into TEMP_erg_tables (table_name) values ('ComplianceInspection');
insert into TEMP_erg_tables (table_name) values ('ConstructionType');
insert into TEMP_erg_tables (table_name) values ('ContactType');
insert into TEMP_erg_tables (table_name) values ('Decommission');
insert into TEMP_erg_tables (table_name) values ('DecommissionedTank');
insert into TEMP_erg_tables (table_name) values ('Facility');
insert into TEMP_erg_tables (table_name) values ('FinancialResponsibility');
insert into TEMP_erg_tables (table_name) values ('FinancialResponsibilityType');
insert into TEMP_erg_tables (table_name) values ('FRMechanismType');
insert into TEMP_erg_tables (table_name) values ('InspectionStatusType');
insert into TEMP_erg_tables (table_name) values ('InspectionType');
insert into TEMP_erg_tables (table_name) values ('OverfillDeviceType');
insert into TEMP_erg_tables (table_name) values ('PipeManufacture');
insert into TEMP_erg_tables (table_name) values ('PipingMaterialType');
insert into TEMP_erg_tables (table_name) values ('PipingType');
insert into TEMP_erg_tables (table_name) values ('ReleaseDetectionType');
insert into TEMP_erg_tables (table_name) values ('SpillDeviceType');
insert into TEMP_erg_tables (table_name) values ('SubstanceType');
insert into TEMP_erg_tables (table_name) values ('Tank');
insert into TEMP_erg_tables (table_name) values ('TankConstruction');
insert into TEMP_erg_tables (table_name) values ('TankManufacture');
insert into TEMP_erg_tables (table_name) values ('TankPipingMaterial');
insert into TEMP_erg_tables (table_name) values ('TankPipingType');
insert into TEMP_erg_tables (table_name) values ('TankReleaseDetection');
insert into TEMP_erg_tables (table_name) values ('TankStatusType');
insert into TEMP_erg_tables (table_name) values ('TankSubstance');

-------------------------------------------------------------------------------------------------------------------
--ERG Postgres


select * from information_schema.