create schema mi_ust;

drop table mi_ust.locationTankStoredSubstance;
drop table mi_ust.locationTank;
drop table mi_ust.locationRelease;
drop table mi_ust.facilityType;
drop table mi_ust.location;

create table mi_ust.location (locationid bigint primary key, sitename varchar(4000), facilityid varchar(4000),
	latitude float, longitude float, countyid int, county_name varchar(4000),
	horizontalCollectionMethodId int, horizontalCollectionMethoddescription varchar(4000),
	Addressid int, fullAddress varchar(4000), city varchar(4000),zipCode varchar(4000), 
	stateid int, state_name varchar(4000),
	townshipId int, townshipname varchar(4000), api_page_number int);
	
create table mi_ust.facilityType (facilityType_pk int primary key generated always as identity,
	locationid bigint not null references mi_ust.location(locationid),
	id int, businesstypeid int, name varchar(4000), isactive boolean, isreserved boolean); 

create table mi_ust.locationRelease (locationRelease_pk int primary key generated always as identity,
	locationid bigint not null references mi_ust.location(locationid),
	locationReleaseId int, releaseTypeId int, releaselocationId int, releaseId varchar(4000), releaseDiscoveredDate date, 
	isInstitutionalControls boolean, isApprovedProjectCompletion boolean, isClosedWithStateFunds boolean, 
	entryDate date, reporteddate date, releastypeid int, releasetypename varchar(4000), 
	laraLocationReleaseId int, hasLandResourceUseRestrictions boolean); 

create table mi_ust.locationTank (locationTank_pk int primary key generated always as identity,
	locationid bigint not null references mi_ust.location(locationid),
	locationTankId int, locationtank_locationid int, tankstatusid int, tankid varchar(4000), 
	capacity float, installationdate date, registrationdate date, tagged varchar(4000), 
	compartments boolean, changeinservice boolean, newInstallChangeOrUpgrade boolean, 
	tankFilledWithInertMaterial boolean, tankWasRemovedFromGround boolean, tankstatusname varchar(4000)); 

create table mi_ust.locationTankStoredSubstance (locationTankStoredSubstance_pk int primary key generated always as identity,
	locationTank_pk int not null references mi_ust.locationTank(locationTank_pk),
	locationTankStoredSubstanceId bigint, locationtankid int, storedSubstanceTypeId int, substance_name varchar(4000),
	isAvailableForCoverSheetSubmittals boolean);

alter table mi_ust.facilitytype add constraint facilitytype_unique unique (locationid, name);
alter table mi_ust.locationrelease add constraint locationrelease_unique unique (locationid, locationreleaseid);
alter table mi_ust.locationtankstoredsubstance add constraint locationtankstoredsubstance_unique 
	unique (locationtank_pk, locationtankstoredsubstanceid);
alter table mi_ust.locationtank add constraint locationtank_unique unique (locationid, tankid);

----------------------------------------------------------------------------------------------------------------------------
--Substances 
select a.locationid, a.sitename, a.facilityid, 
	b.name as facility_type_name, d.*, e.*
--	d.tankid, d.tankstatusname, e.substance_name
from mi_ust.location a 
	left join mi_ust.facilitytype b on a.locationid = b.locationid 
	left join mi_ust.locationtank d on a.locationid = d.locationid 
	left join mi_ust.locationtankstoredsubstance e on d.locationtank_pk = e.locationtank_pk
order by a.locationid, d.tankid, e.substance_name;

--Releases
select a.locationid, a.sitename, a.facilityid, 
	b.name as facility_type_name, c.*
	--c.releaseid, c.releasetypename, c.releaseDiscoveredDate
from mi_ust.location a 
	left join mi_ust.facilitytype b on a.locationid = b.locationid 
	left join mi_ust.locationrelease c on a.locationid = c.locationid
order by a.locationid, c.releaseid;

	
----------------------------------------------------------------------------------------------------------------------------
select count(*), 'location' as table_name from mi_ust.location union all 
select count(*), 'facilitytype' as table_name from mi_ust.facilitytype union all 
select count(*), 'locationrelease' as table_name from mi_ust.locationrelease union all 
select count(*), 'locationtank' as table_name from mi_ust.locationtank union all  
select count(*), 'locationtankstoredsubstance' as table_name from mi_ust.locationtankstoredsubstance; 


---------------------------------------------------------------------------------------------------------
--delete from mi_ust.locationRelease;
--delete from mi_ust.locationTankStoredSubstance;
--delete from mi_ust.locationTank;
--delete from mi_ust.facilityType;
--delete from mi_ust.location;



