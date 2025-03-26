update ust_element_mapping
set --organization_table_name = 'tbltank' 
--organization_column_name = 'insatllationID',
organization_join_table = 'tbltankcompartment',
organization_join_column = 'tankCompartmentID',
query_logic = ''
where ust_element_mapping_id = 2765;

delete from ust_element_mapping
where ust_element_mapping_id = 2758;

update ust_element_mapping
	set organization_table_name = 'tbltank',
	organization_column_name = 'ustID'
where ust_element_mapping_id = 2743;

create or replace view ia_ust.v_cert_install_table
as select distinct
	ci."tankID",
	ci."installationID",
	row_number() over (
		partition by ci."tankID"
		order by ci."createdDate" desc, ci."lastChanged" desc
	) as row_num
	from ia_ust.treltanktoinstallation ci;


create or replace view ia_ust.v_tank_corrosion_table
as select distinct 
	ep."tankID",
	ep."externalProtectionID"
	row_number() over (
		partition by ep."tankID"
		order by ep."lastChanged" desc
	) as row_num
	from ia_ust.treltanktoexternalprote ep;

create or replace view ia_ust.v_tank_closure_table
as select distinct
	td."tankID",
	td."tankDate",
	row_number() over (
		partition by td."tankID"
		order by td."tankDate" desc, td."lastChanged" desc
	) as row_num
	from ia_ust.tbltankdates td
	where td."dateTypeID" in (7,8);

create or replace view ia_ust.v_tank_install_table
as select distinct
	td."tankID",
	td."tankDate",
	row_number() over (
		partition by td."tankID"
		order by td."tankDate" desc, td."lastChanged" desc
	) as row_num
	from ia_ust.tbltankdates td
	where td."dateTypeID" in (4);

create or replace view ia_ust.v_tank_statuses_table
as select distinct 
	tus."ustID",
	ts."statusDescription",
	row_number() over (
		partition by tus."ustID"
		order by tus."statusStartDate" desc, tus."lastChanged" desc
	) as row_num
	from ia_ust.trelusttostatus tus
		inner join ia_ust.tlkstatus ts on tus."statusID" = ts."statusID";
	
create or replace view ia_ust.v_multiple_tank_table
as select distinct
	

create or replace view ia_ust.v_owner_table_name
as select distinct 
	o."orgName" as orgName, 
	au."ustID" as ustID, 
	au."affTypeID" as affTypeID,
	row_number() over (
		partition by au."ustID"
		order by au."startDate" desc, au."lastChanged" desc
	) as row_num
	from ia_ust.trelAffToUST au 
		inner join ia_ust.tblaffiliation af on au."affID" = af."affID" 
		inner join ia_ust.tblorganization o on af."orgID" = o."orgID"
	where au."affTypeID" in (1,25);

create or replace view ia_ust.v_operator_table_name
as select distinct 
	o."orgName" as orgName, 
	au."ustID" as ustID, 
	au."affTypeID" as affTypeID,
	row_number() over (
		partition by au."ustID"
		order by au."startDate" desc, au."lastChanged" desc
	) as row_num
	from ia_ust.trelAffToUST au 
		inner join ia_ust.tblaffiliation af on au."affID" = af."affID" 
		inner join ia_ust.tblorganization o on af."orgID" = o."orgID"
	where au."affTypeID" in (4,23,24);

create or replace view ia_ust.v_release_table
as select distinct
	lu."ustID" as ustID,
	lu."lustID" as lustID,
	row_number() over (
		partition by lu."ustID"
		order by lu."startDate" desc
	) as row_num
	from ia_ust.tbllustsite lu;
	
drop table if exists il_ust.erg_unregulated_tanks;

select * from v_ust_tank
where tank_id = 1346723399;

insert into il_ust.erg_unregulated_tanks
 select x.facility_id, tank_id 
 from (select facility_id, tank_id, sum(compartment_capacity_gallons) as tank_capacity_gallons 
 from il_ust.v_ust_compartment group by facility_id, tank_id) x 
 join None on x.facility_id = f.facility_id 
 where tank_capacity_gallons < 1100
 on conflict do nothing;
	
select * from ia_ust.v_owner_table_name
order by "ustid";

select * from ust_element_mapping
where ust_element_mapping_id = 2050;

update ust_element_mapping
set epa_column_name = 'cert_of_installation_id'
where ust_element_mapping_id = 2050;

select facility_id, tank_id, compartment_id, substance_id, count(*) num_rows from il_ust.v_ust_compartment_substance 
 group by facility_id, tank_id, compartment_id, substance_id having count(*) > 1;