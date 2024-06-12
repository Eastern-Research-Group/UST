create user ust_user with encrypted  password 'ust_wolf';

create database SC_UST;
grant all privileges on database SC_UST to ust_user;

select * from public."FOI_Inventory";

select * from public."FOI_FR_Report"
where site_num not in (select "Site ID" from public."FOI_Inventory");

select * from public."FOI_Inventory"
where "Site ID" not in (select site_num from public."FOI_FR_Report");

select distinct type_code from public."FOI_FR_Report" order by 1;

select distinct "Bill" from public."FOI_Inventory" order by 1;

select distinct "RO" from public."FOI_Inventory" order by 1;

select count(*) from public."FOI_FR_Report";
4109
select count(*) from public."Sites_with_FR";
4109

select * from public."FOI_FR_Report" where site_num not in 
	(select site_num from public."Sites_with_FR");

select i."Site ID", i."Facility", fr.facility_name
from public."FOI_Inventory" i join public."Sites_with_FR" fr on i."Site ID" = fr.site_num
where i."Facility" <> fr.facility_name
order by 1;

select * from public."FOI_Inventory" where "Site ID" like '%00002';
"P-00002"	"ABBEVILLE MAINTENANCE FACILITY"	"127 MCGOWAN AVE"	"ABBEVILLE"	"SC DEPARTMENT OF TRANSPORTATION"

select * from public."Sites_with_FR" where site_num like '%00002';

select i."Site ID", i."Street", fr.local_fac_addr_1
from public."FOI_Inventory" i join public."Sites_with_FR" fr on i."Site ID" = fr.site_num
where i."Street" <> fr.local_fac_addr_1
order by 1;

select distinct mech_desc from public."Sites_with_FR" order by 1;

select * from public."FOI_Inventory"

select * from public."Overfill_Prevention_no_record_yet_08_02_21";

alter table public."Spill_Prevention_" rename to "Spill_Prevention";

select count(*) from public."Spill_Prevention";
9671
select count(*) from public."Overfill_Prevention";
9968

select count(*) from (select distinct site_num from public."Spill_Prevention") a;
3045
select count(*) from (select distinct site_num from public."Overfill_Prevention") a;
3117

select * from public."Overfill_Prevention"

select * from public."Spill_Prevention" where site_num  in (select site_num from public."Overfill_Prevention");



select vc.*, op.capacity_gal, sp.capacity_gal
from v_compartments vc join public."Overfill_Prevention" op 
		on vc.site_num = op.site_num and vc.tank_num = op.tank_num and vc.compartment_number = op.compartment_number
	join public."Spill_Prevention" sp 
		on vc.site_num = sp.site_num and vc.tank_num = sp.tank_num and vc.compartment_number = sp.compartment_number
where op.capacity_gal < sp.capacity_gal;

select status_code, count(*) from public."Overfill_Prevention"  group by status_code;
"CIU"	9928   Currently In Use
"POS"	5      Permanently Out-of-Service
"EOU"	35     Extended Out-of-Use

select chemical_desc, count(*) from public."Overfill_Prevention"  group by chemical_desc;

select vc.*, op.chemical_desc, sp.chemical_desc
from v_compartments vc join public."Overfill_Prevention" op 
		on vc.site_num = op.site_num and vc.tank_num = op.tank_num and vc.compartment_number = op.compartment_number
	join public."Spill_Prevention" sp 
		on vc.site_num = sp.site_num and vc.tank_num = sp.tank_num and vc.compartment_number = sp.compartment_number
where op.chemical_desc is not null and op.chemical_desc < sp.chemical_desc;

select replace(right('P-00002',-1),'-','#');

select * from public.v_compartment_info order by 1;
"#00002"

select distinct chemical_desc from public.v_compartment_info order by 1;


select * from public."FOI_Inventory" order by 1;

select * from public."Overfill_Prevention";

select * from public."Spill_Prevention" order by 1;
"#00002"

select cas_no, count(*) from public."Overfill_Prevention" group by cas_no order by 1;

select * from information_schema.columns where table_schema = 'public' and lower(column_name) like '%date%';

select distinct capacity_gal from public."Overfill_Prevention_no_record_yet_08_02_21" where cast(capacity_gal as varchar) like '%.%'

select distinct overfill_method from public."Overfill_Prevention" order by 1;

select distinct spill_prevent from public."Spill_Prevention" order by 1;

select * from public.lwmopc_20211013;
2
6
13
19
23
27
31
36

select * from public.ustleak_20211013;
"UST-00002"
"UST-00003"
"UST-00005"
"UST-00006"
"UST-00013"
"UST-00019"
"UST-00023"


select convert_site_num_int('2123e');

select count(*) from (select distinct site_num from public.lwmopc_20211013) a;
3979
select count(*) from (select distinct site_num from public.ustleak_20211013) a;
6477



select count(*)
from public.lwmopc_20211013 a left join public.ustleak_20211013 b on convert_site_num_int(a.site_num) = b.site_num 
where b.site_num is null;


select * from public.ustleak_20211013;


create or replace view public.v_compartments as
select distinct site_num, tank_num, compartment_number
from
	(select site_num, tank_num, compartment_number from public."Overfill_Prevention" union all
	select site_num, tank_num, compartment_number from public."Spill_Prevention" union all
	select site_num, tank_num, compartment_number from public."Overfill_Prevention_no_record_yet_08_02_21" union all
	select site_num, tank_num, compartment_number from public."Spill_Prevention_no_record_yet_08_02_21") a;
	
create or replace view public.v_compartment_info as
select vc.*, 
	case when op.capacity_gal is not null and op.capacity_gal >= coalesce(sp.capacity_gal,0) then op.capacity_gal 
		 when sp.capacity_gal is not null and sp.capacity_gal >= coalesce(opnr.capacity_gal,0) then sp.capacity_gal
		 when opnr.capacity_gal is not null and opnr.capacity_gal >= coalesce(spnr.capacity_gal,0) then cast(opnr.capacity_gal as bigint)
		else cast(spnr.capacity_gal as bigint) end as capacity_gal,
	case when op.status_code is not null then op.status_code 
	     when sp.status_code is not null then sp.status_code
		 when opnr.status_code is not null then opnr.status_code else spnr.status_code end as status_code,
	case when op.chemical_desc is not null then op.chemical_desc 
		 when sp.chemical_desc is not null then sp.chemical_desc 
		 when opnr.chemical_desc is not null then opnr.chemical_desc else spnr.chemical_desc end as chemical_desc,
	case when op.cas_no is not null then op.cas_no 
	     when sp.cas_no is not null then sp.cas_no 
		 when opnr.cas_no is not null then opnr.cas_no else spnr.cas_no end as cas_no
from public.v_compartments vc left join public."Overfill_Prevention" op 
		on vc.site_num = op.site_num and vc.tank_num = op.tank_num and vc.compartment_number = op.compartment_number
	left join public."Spill_Prevention" sp 
		on vc.site_num = sp.site_num and vc.tank_num = sp.tank_num and vc.compartment_number = sp.compartment_number
	left join public."Overfill_Prevention_no_record_yet_08_02_21" opnr
		on vc.site_num = opnr.site_num and vc.tank_num = opnr.tank_num and vc.compartment_number = opnr.compartment_number
	left join public."Spill_Prevention_no_record_yet_08_02_21" spnr
		on vc.site_num = spnr.site_num and vc.tank_num = spnr.tank_num and vc.compartment_number = spnr.compartment_number;

create or replace view v_tank_compartments as
select site_num, tank_num, count(*) as number_of_compartments from v_compartments
group by site_num, tank_num;

create or replace view v_overfill as
select vc.site_num, vc.tank_num, vc.compartment_number, 
	case when op.overfill_method is not null then op.overfill_method else opnr.overfill_method end as overfill_method,
-- 	case when op.overfill_prevention is not null then op.overfill_prevention else opnr.overfill_prevention end as overfill_prevention,
	case when op.chemical_desc is not null then op.chemical_desc else opnr.chemical_desc end as chemical_desc,
	case when op.cas_no is not null then op.cas_no else opnr.cas_no end as cas_no
from public.v_compartments vc 
	left join (select site_num, tank_num, compartment_number, overfill_method, overfill_prevention, chemical_desc, cas_no from public."Overfill_Prevention") op
		on vc.site_num = op.site_num and vc.tank_num = op.tank_num and vc.compartment_number = op.compartment_number
	left join (select site_num, tank_num, compartment_number, overfill_method, overfill_prevention, chemical_desc, cas_no from public."Overfill_Prevention_no_record_yet_08_02_21") opnr
		on vc.site_num = opnr.site_num and vc.tank_num = opnr.tank_num and vc.compartment_number = opnr.compartment_number;

create or replace view v_spill as
select vc.site_num, vc.tank_num, vc.compartment_number, 
	case when sp.spill_prevent is not null then sp.spill_prevent else spnr.spill_prevent end as spill_prevent,
	case when sp.chemical_desc is not null then sp.chemical_desc else spnr.chemical_desc end as chemical_desc,
	case when sp.cas_no is not null then sp.cas_no else spnr.cas_no end as cas_no
from public.v_compartments vc 
	left join (select site_num, tank_num, compartment_number, spill_prevent, chemical_desc, cas_no from public."Spill_Prevention") sp
		on vc.site_num = sp.site_num and vc.tank_num = sp.tank_num and vc.compartment_number = sp.compartment_number
	left join (select site_num, tank_num, compartment_number, spill_prevent, chemical_desc, cas_no from public."Spill_Prevention_no_record_yet_08_02_21") spnr
		on vc.site_num = spnr.site_num and vc.tank_num = spnr.tank_num and vc.compartment_number = spnr.compartment_number;

create function convert_site_num_int(site_num bigint)
returns text as $$
declare v_site_num text;
begin
	v_site_num = cast(site_num as text);
	case length(v_site_num) 
		when 1 then v_site_num = 'UST-0000' || v_site_num; 
		when 2 then v_site_num = 'UST-000' || v_site_num; 
		when 3 then v_site_num = 'UST-00' || v_site_num; 
		when 4 then v_site_num = 'UST-0' || v_site_num;
	else v_site_num = 'UST-' || v_site_num;	
	end case;
	return v_site_num;
end;
$$  language plpgsql

create or replace view v_release_num as
select a.site_num, a.release_num
from public.ustleak_20211013 a 
	left join (select site_num, max(release_date) as release_date from public.ustleak_20211013 group by site_num) b
		on a.site_num = b.site_num and a.release_date = b.release_date;


create or replace view v_ust as
select i."Site ID" as "FacilityID",
	i."Facility" as "FacilityName",
	i."Street" as "FacilityAddress1",
	i."City" as "FacilityCity",
	i."Phone" as "FacilityPhoneNumber",
	'SC' as "FacilityState",
	'4' as "FacilityEPARegion",
	i."Latitude" as "FacilityLatitude",
	i."Longitude" as "FacilityLongitude",
	fr.tank_owner_name as "FacilityOwnerName",
	fr.address_1 as "FacilityOwnerAddress1",
	fr.city as "FacilityOwnerCity",
	fr.zip_code as "FacilityOwnerZipCode",
	fr.state_code as "FacilityOwnerState",
	case when fr.mech_desc = 'LG Bond Rating Test' then 'Yes' end as "FinancialResponsibilityBondRatingTest",
	case when fr.mech_desc = 'Environmental Insurance' then 'Yes' end as "FinancialResponsibilityCommercialInsurance",
	case when fr.mech_desc = 'Guarantee' then 'Yes' end as "FinancialResponsibilityGuarantee",
	case when fr.mech_desc = 'Letter of Credit' then 'Yes' end as "FinancialResponsibilityLetterOfCredit",
	case when fr.mech_desc like '%Self Insurance%' then 'Yes' end as "FinancialResponsibilitySelfInsuranceFinancialTest",
	case when fr.mech_desc = 'Surety Bond' then 'Yes' end as "FinancialResponsibilitySuretyBond",
	case when fr.mech_desc like '%Trust Fund%' then 'Yes' end as "FinancialResponsibilityTrustFund",
	case when fr.mech_desc = 'None' then fr.mech_desc end as "FinancialResponsibilityOtherMethod",	
	ci.tank_num as "TankID",
	ci.compartment_number as "CompartmentID",
	case when ci.status_code = 'CIU' then 'Currently in use'
	     when ci.status_code = 'POS' then 'Closed (status unknown)'
		 when ci.status_code = 'EOU' then 'Temporarily out of service' end as "TankStatus",
	case when tc.number_of_compartments > 1 then 'Yes' end as "CompartmentalizedUST",
	tc.number_of_compartments as "NumberOfCompartments",
	case when number_of_compartments = 1 then 'Petroleum product' end as "TankSubstanceStored",
	case when number_of_compartments > 1 then 'Petroleum product' end as "CompartmentSubstanceStored",
	case when number_of_compartments = 1 then capacity_gal end as "TankCapacityGallons",
	case when number_of_compartments > 1 then capacity_gal end as "CompartmentCapacityGallons",
	case when vo.overfill_method like '%DT%' then 'Yes' end as "AutomaticShutoffDevice",
	case when vo.overfill_method like '%AL%' then 'Yes' end as "OverfillAlarm",
	case when vo.overfill_method like '%BF%' then 'Yes' end as "BallFloatValve",
	case when r.site_num is not null then 'Yes' end as "USTReportedRelease",
	r.release_num as "AssociatedLUSTID"
from public."FOI_Inventory" i left join public."Sites_with_FR" fr on i."Site ID" = fr.site_num
	left join public.v_compartment_info ci on replace(right(i."Site ID",-1),'-','#') = ci.site_num
	left join public.v_tank_compartments tc on ci.site_num = tc.site_num and ci.tank_num = tc.tank_num
	left join public.v_overfill vo on ci.site_num = vo.site_num and ci.tank_num = vo.tank_num and ci.compartment_number = vo.compartment_number
	left join v_release_num r on replace(right(i."Site ID",-1),'-','UST-') = r.site_num;



select * from v_ust order by "FacilityID", "TankID", "CompartmentID";

select column_name from information_schema.columns where table_name = 'v_ust' order by ordinal_position;

---------------------------------------------------------------------------------------------------------------------------------------
select * from public.lwmopc_20211013 order by site_num;
select * from public.ustleak_20211013 order by site_num;


"facil_name"	"facil_address"	"facil_city"	"facil_state"	"facil_zip"
"ABBEVILLE MAINTENANCE FACILITY"	"127 MCGOWAN AVE"	"ABBEVILLE"	"SC"	"29620"

select * from public."FOI_Inventory" i where "Site ID" like '%00002';


select site_num, facil_name, release_num, release_date
from public.ustleak_20211013 order by site_num;
"site_num"	"facil_name"	"release_num"
"UST-00002"	"ABBEVILLE MAINTENANCE FACILITY"	1	"13-Nov-92"
"UST-00003"	"ABBEVILLE COUNTY SCHOOL DISTRICT"	1	"18-Nov-98"
"UST-00005"	"ABBEVILLE COUNTY SCHOOL BUS SHOP"	1	"16-Dec-98"
"UST-00006"	"ABBEVILLE CITY OF"	1	"7-Oct-86"
"UST-00013"	"BIGELOW SANFORD INC ROCKY RIVER"	1	"2-Jul-93"
"UST-00019"	"SEABOARD SYSTEM RR"	1	"30-Dec-91"
"UST-00023"	"PANTRY 606"	1	"26-May-05"

select cast(site_num as text) from public.lwmopc_20211013 a;

create view v_lwmopc as
select case when length(cast(site_num as text)) = 1 then 'UST-0000' || cast(site_num as text) 
            when length(cast(site_num as text)) = 2 then 'UST-000' || cast(site_num as text) 
            when length(cast(site_num as text)) = 3 then 'UST-00' || cast(site_num as text) 
            when length(cast(site_num as text)) = 4 then 'UST-0' || cast(site_num as text) 
			else 'UST-' || cast(site_num as text) end as site_num_long,
	a.* from public.lwmopc_20211013 a;

select site_num, fac_name, release_num
from public.lwmopc_20211013 order by site_num;

select count(*) from public.lwmopc_20211013;
4293
select count(*) from public.ustleak_20211013;
7330

select site_num_long, release_num, fac_name
from public.v_lwmopc b where not exists
	(select 1 from public.ustleak_20211013 a
	where a.site_num = b.site_num_long and a.release_num = b.release_num);
[54 rows]
"UST-00036"	1	"HICKORY POINT CALHOUN FALLS"
"UST-00105"	2	"QUICK PANTRY 101"
"UST-00332"	1	"INTERSTATE TRUCK TERMINAL INC"
"UST-00416"	1	"SAMS TEXACO"

select site_num, release_num, facil_name
from public.ustleak_20211013 where site_num = 'UST-00416';
"UST-00036"	2	"HICKORY POINT CALHOUN FALLS"
"UST-00105"		"QUICK PANTRY 101"
"UST-00332"	2	"INTERSTATE TRUCK TERMINAL INC"
"UST-00416"	2	"SAMS TEXACO"

drop view public.v_lwmopc;


select * from public.lwmopc_20211013 order by site_num;
select * from public.ustleak_20211013 order by site_num;

select * from information_schema.columns where column_name like '%lon%' 
and table_schema = 'public' and table_name in ('lwmopc_20211013','ustleak_20211013')
order by table_name, column_name;

select site_num, confirmed_date, cleanup_complete_date, cleanup_compl_mcl_date, suspect_nfaed_date
from public.ustleak_20211013;

select site_num, confirmed_date, cleanup_complete_date, cleanup_compl_mcl_date, suspect_nfaed_date
from public.ustleak_20211013
where suspect_nfaed_date is null and (cleanup_complete_date is not null or cleanup_compl_mcl_date is not null);

select * from public.lwmopc_20211013;

select column_name from information_schema.columns
where table_name = 'lwmopc_20211013' and column_name like 'soil%' and column_name not like '%on' 
order by ordinal_position;

select * from  public.ustleak_20211013;

select * from public."Overfill_Prevention" where chemical_desc is not null;


select * from public.lwmopc_20211013
where cleanup_complete_date is null and cleanup_compl_mcl_date is null and cnfa = 'Y';


create or replace view v_chemical_desc as 
select distinct site_num, tank_num, compartment_number, cas_no, chemical_desc,
	case when chemical_desc like 'DEF%' then 'Diesel exhaust fluid (DEF, not federally regulated)'
	 when lower(chemical_desc) like '%diesel%' then 'Diesel fuel (b-unknown)'
	 when lower(chemical_desc) like '%plus%' then 'Ethanol blend gasoline (e-unknown)'
	 when (lower(chemical_desc) like '%90 rec%' or lower(chemical_desc) like '%non%eth%' or lower(chemical_desc) like '%eth%free%'
			 or lower(chemical_desc) like '%pure%max%' or upper(chemical_desc) like '%E0%' or upper(chemical_desc) like '%E-0%'
			 or chemical_desc = 'EO' or lower(chemical_desc) like 'mogas%') or lower(chemical_desc) like '%rul%#%1' then 'Gasoline (non-ethanol)'
	 when chemical_desc like 'E%10' then 'Gasoline E-10 (E1-E10)'
	 when (lower(chemical_desc) like '%oxide%' or lower(chemical_desc) like 'ultrazol%' or cas_no is not null) then 'Other' 
	 when chemical_desc is not null then 'Unknown' end as epa_substance
from (select site_num, tank_num, compartment_number, cas_no, chemical_desc from v_overfill union all
      select site_num, tank_num, compartment_number, cas_no, chemical_desc from v_spill) a;

create or replace view v_epa_substances as
select a.*, row_number() over (partition by site_num order by epa_substance) rn 
from (select distinct replace(site_num,'#','UST-') site_num, epa_substance 
	  from v_chemical_desc where epa_substance is not null) a;

create or replace view v_epa_substances_cross as
select a.site_num, 
	a.epa_substance substance1, b.epa_substance substance2, c.epa_substance substance3, d.epa_substance substance4, e.epa_substance substance5
from (select site_num, epa_substance from v_epa_substances where rn = 1) a 
	left join (select site_num, epa_substance from v_epa_substances where rn = 2) b on a.site_num = b.site_num
	left join (select site_num, epa_substance from v_epa_substances where rn = 3) c on a.site_num = c.site_num
	left join (select site_num, epa_substance from v_epa_substances where rn = 4) d on a.site_num = d.site_num
	left join (select site_num, epa_substance from v_epa_substances where rn = 5) e on a.site_num = e.site_num;


create or replace view v_lust as
select a.site_num as "FacilityID", a.release_num as "LUSTID", 
	a.facil_name as "SiteName", a.facil_address as "SiteAddress", a.facil_city as "SiteCity",
	a.facil_zip as "ZipCode", 'SC' as "State", '4' as "EPARegion",
	b.lat_decimal as "Latitude", b.long_decimal as "Longitude",
	case when a.cleanup_complete_date is null and a.cleanup_compl_mcl_date is null then 'Active' --is this accurate?
	     when a.cleanup_complete_date is not null or a.cleanup_compl_mcl_date is not null or a.suspect_nfaed_date is not null then 'No Further Action'
		 else 'Unknown' end as "LUSTStatus",
	a.confirmed_date as "ReportedDate",
	case when a.suspect_nfaed_date is not null then a.suspect_nfaed_date --this could all probably come from suspect_nfaed_date but there is one row where cleanup_compl_mcl_date is not null and suspect_nfaed_date is null
	     when a.cleanup_complete_date is not null then a.cleanup_complete_date
		 when a.cleanup_compl_mcl_date is not null then a.cleanup_compl_mcl_date
	end as "NFADate",
	case when soil_contam_present = 'Y' or soil_contam_present_on = 'Y' then 'Yes' --first column is off-site; second is onsite; is this the best way to get one value from both columns?
	     when soil_contam_present = 'U' or soil_contam_present_on = 'U' then 'Unknown'
		 when soil_contam_present = 'N' or soil_contam_present_on = 'N' then 'No' end as "MediaImpactedSoil",
	case when gw_contam_present = 'Y' or gw_contam_present_on = 'Y' then 'Yes' --first column is off-site; second is onsite; is this the best way to get one value from both columns?
	     when gw_contam_present = 'U' or gw_contam_present_on = 'U' then 'Unknown'
		 when gw_contam_present = 'N' or gw_contam_present_on = 'N' then 'No' end as "MediaImpactedGroundwater",
	case when sw_contam_present = 'Y' or sw_contam_present_on = 'Y' then 'Yes' --first column is off-site; second is onsite; is this the best way to get one value from both columns?
	     when sw_contam_present = 'U' or sw_contam_present_on = 'U' then 'Unknown'
		 when sw_contam_present = 'N' or sw_contam_present_on = 'N' then 'No' end as "MediaImpactedSurfaceWater",
	c.substance1 as "SubstanceReleased1", --this is just a substance associated with the tank in the UST data; didn't come from LUST so not sure it's actually what leaked, especially for sites with multiple tanks 
	c.substance2 as "SubstanceReleased2", --this is just a substance associated with the tank in the UST data; didn't come from LUST so not sure it's actually what leaked, especially for sites with multiple tanks 
	c.substance2 as "SubstanceReleased3", --this is just a substance associated with the tank in the UST data; didn't come from LUST so not sure it's actually what leaked, especially for sites with multiple tanks 
	c.substance2 as "SubstanceReleased4", --this is just a substance associated with the tank in the UST data; didn't come from LUST so not sure it's actually what leaked, especially for sites with multiple tanks 
	c.substance2 as "SubstanceReleased5", --this is just a substance associated with the tank in the UST data; didn't come from LUST so not sure it's actually what leaked, especially for sites with multiple tanks 
	case when b.cleanup_complete_date is null and b.cleanup_compl_mcl_date is null and b.cnfa = 'Y' then 'Yes' end as "ClosedWithContamination"
from public.ustleak_20211013 a left join public.lwmopc_20211013 b on a.site_num = convert_site_num_int(b.site_num) and a.release_num = b.release_num
	left join v_epa_substances_cross c on a.site_num = c.site_num;
	
	
select * from v_lust order by "FacilityID", "LUSTID";

select column_name from information_schema.columns where table_name = 'v_lust' order by ordinal_position;
