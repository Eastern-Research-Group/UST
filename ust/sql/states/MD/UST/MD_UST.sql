------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Update the control table 

--EITHER:
--use insert_control.py to insert into public.ust_control
--OR:


--the script above returned a new ust_control_id of 11 for this dataset:
select * from public.ust_control where ust_control_id = 16;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------





------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Upload the state data 
/* 
EITHER:
script import_data_file_files.py will create the correct schema (if it doesn't yet exist), 
then upload all .xlsx, .xls, .csv, and .txt in the specified directory to this schema. 
To run, set these variables:

organization_id = 'MD' 
# Enter a directory (not a path to a specific file) for ust_path and ust_path
# Set to None if not applicable
ust_path = 'C:\Users\JChilton\repo\UST\ust\sql\states\SD\UST' 
overwrite_table = False 


load the rease data too to populate a field fields in UST from it
release_path = r'C:\Users\JChilton\OneDrive - Eastern Research Group\Desktop\UST\MD\Release\CASES 04-03-24\CASES 04-03-24'

OR:
manually in the database, create schema md_ust if it does not exist, then manually upload the state data
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--combine/join the imported tables


drop table md_facility1;

create table md_facility1 as
select * from "UST-B-Facility-1"
union
select * from "UST-C-Facility-2";

drop table md_facility2;

create table md_facility2 as 
select * from  "UST-D-FR-1" 
union select * from "UST-E-FR-2";

create table  md_facility_combined as
select a.*, b."Finance",
b."SelfInsurance",
b."Insurance",
b."RiskRetention",
b."Guarantee",
b."SuretyBond",
b."LtrCredit",
b."StateFunds",
b."TrustFunds",
b."OtherFinance",
b."StandByTrustFund",
b."LocGovInsurancePool",
b."LocGovBondRating",
b."LocGovFinancialTest",
b."LocGovGuarantee",
b."FinanceOther",
b."FRNotListed" from md_facility1 a
join md_facility2 b on a."FacilityID" = b."FacilityID";


create index mf_idx on md_ust.md_facility_combined ( "FacilityID" );
analyze md_ust.md_facility_combined ;


drop  table md_supp_tank_data;

create table md_supp_tank_data as
select * from md_ust."PIA-UST_Facilities_AA-AL"
union
select * from md_ust."PIA-UST_Facilities_BA-BC"
union
select * from md_ust."PIA-UST_Facilities_CA-GA"
union
select * from md_ust."PIA-UST_Facilities_HA-MO"
union
select * from md_ust."PIA-UST_Facilities_PG-QA"
union
select * from md_ust."PIA-UST_Facilities_SM-WO";


drop table md_tank_preload;

create table md_tank_preload as
select * from "UST-F-Tank-1"
union
select * from "UST-G-Tank-2"
union
select * from "UST-H-Tank-3"
union
select * from "UST-I-Tank-4"
union
select * from "UST-J-Tank-5"
union
select * from "UST-K-Tank-6";


drop table md_tanks_combined;
create table md_tanks_combined
as 
select a.*, b."TankModsDesc", b."DateClosed", b."ClosureStatusDesc"
from md_tank_preload a
left join md_supp_tank_data b on a."FacilityID" = b."FacilityID" and a."TankID"=b."TankID" and b."Compartment" = a."tblCompartment_Compartment";

create index mt_idx on md_ust.md_tanks_combined ( "FacilityID" );
create index mt_idx2 on md_ust.md_tanks_combined ( "TankID" );
create index mt_idx3 on md_ust.md_tanks_combined ( "tblCompartment_Compartment" );
analyze md_ust.md_tanks_combined ;


select * from md_release."All_Cases_Request_10" where "RELEASE" = 'YES' and "CODE" like 'B%' and "REG_NUMBER" is not null

ALTER TABLE  "UST-A-Owners" RENAME TO md_owner; 

drop table md_release_linkages;
create table md_release_linkages as
select "CASE_NO" release_id, "REG_NUMBER" ust_facility_id, "DATE_OPEN" date_open  from md_release."All_Cases_Request_10" where "RELEASE" = 'YES' and "CODE" like 'B%' and "REG_NUMBER" is not null
union
select "CASE_NO" release_id, "REG_NUMBER" ust_facility_id, "DATE_OPEN" date_open  from md_release."All_Cases_Request_11" where "RELEASE" = 'YES' and "CODE" like 'B%' and "REG_NUMBER" is not null
union
select "CASE_NO" release_id, "REG_NUMBER" ust_facility_id, "DATE_OPEN" date_open  from md_release."All_Cases_Request_12" where "RELEASE" = 'YES' and "CODE" like 'B%' and "REG_NUMBER" is not null
union
select "CASE_NO" release_id, "REG_NUMBER" ust_facility_id, "DATE_OPEN" date_open  from md_release."All_Cases_Request_13" where "RELEASE" = 'YES' and "CODE" like 'B%' and "REG_NUMBER" is not null
union
select "CASE_NO" release_id, "REG_NUMBER" ust_facility_id, "DATE_OPEN" date_open  from md_release."All_Cases_Request_14" where "RELEASE" = 'YES' and "CODE" like 'B%' and "REG_NUMBER" is not null
union
select "CASE_NO" release_id, "REG_NUMBER" ust_facility_id, "DATE_OPEN" date_open  from md_release."All_Cases_Request__1" where "RELEASE" = 'YES' and "CODE" like 'B%' and "REG_NUMBER" is not null
union
select "CASE_NO" release_id, "REG_NUMBER" ust_facility_id, "DATE_OPEN" date_open  from md_release."All_Cases_Request__2" where "RELEASE" = 'YES' and "CODE" like 'B%' and "REG_NUMBER" is not null
union
select "CASE_NO" release_id, "REG_NUMBER" ust_facility_id, "DATE_OPEN" date_open  from md_release."All_Cases_Request__3" where "RELEASE" = 'YES' and "CODE" like 'B%' and "REG_NUMBER" is not null
union
select "CASE_NO" release_id, "REG_NUMBER" ust_facility_id, "DATE_OPEN" date_open  from md_release."All_Cases_Request__4" where "RELEASE" = 'YES' and "CODE" like 'B%' and "REG_NUMBER" is not null
union
select "CASE_NO" release_id, "REG_NUMBER" ust_facility_id, "DATE_OPEN" date_open  from md_release."All_Cases_Request__5" where "RELEASE" = 'YES' and "CODE" like 'B%' and "REG_NUMBER" is not null
union
select "CASE_NO" release_id, "REG_NUMBER" ust_facility_id, "DATE_OPEN" date_open  from md_release."All_Cases_Request__6" where "RELEASE" = 'YES' and "CODE" like 'B%' and "REG_NUMBER" is not null
union
select "CASE_NO" release_id, "REG_NUMBER" ust_facility_id, "DATE_OPEN" date_open  from md_release."All_Cases_Request__7" where "RELEASE" = 'YES' and "CODE" like 'B%' and "REG_NUMBER" is not null
union
select "CASE_NO" release_id, "REG_NUMBER" ust_facility_id, "DATE_OPEN" date_open  from md_release."All_Cases_Request__8" where "RELEASE" = 'YES' and "CODE" like 'B%' and "REG_NUMBER" is not null
union
select "CASE_NO" release_id, "REG_NUMBER" ust_facility_id, "DATE_OPEN" date_open  from md_release."All_Cases_Request__9" where "RELEASE" = 'YES' and "CODE" like 'B%' and "REG_NUMBER" is not null;


select * from   md_release."All_Cases_Request_10";
--tables to use
select * from md_facility_combined; --distinct fac
select * from md_release_linkages; --release to ust ID linkages
select * from md_tanks_combined; --distinct compartment + tank
select * from md_owner; --distinct owner list


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Generate SQL statements to do the inserts into ust_element_mapping. 
Run the query below, paste the results into your console, then do a global replace of 9 for the ust_control_id 
Next, go through each generated SQL statement and do the following:
If there is no matching column in the state's data, delete the SQL statement 
If there is a matching column in the state's data, update the tanks and ORG_COL_NAME variables to match the state's data 
If you have questions or comments, replace the "null" with your comment. 
After you have updated all the SQL statements, run them to update the database. 
*/
select * from public.v_ust_element_summary_sql;

/*you can run this SQL so you can copy and paste table and column names into the SQL statements generated by the query above
select table_name, column_name from information_schema.columns 
where table_schema = 'md_ust' order by table_name, ordinal_position;
*/
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (16,'ust_compartment_substance','compartment_id','erg_compartment','compartment_id',null,null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (16,'ust_piping','piping_id','erg_piping','piping_id',null,null);


insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (16,'ust_facility','facility_type1','md_supp_tank_data','FacilityDesc',null,null);

select * from ust_element_mapping where ust_control_id = 16 order by epa_table_name ;
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_facility','facility_id','md_facility_combined','FacilityID',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_facility','facility_name','md_facility_combined','LocName',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_facility','facility_address1','md_facility_combined','LocStr',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_facility','facility_city','md_facility_combined','City',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_facility','facility_county','md_facility_combined','County',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_facility','facility_zip_code','md_facility_combined','ZIP',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_facility','facility_owner_company_name','md_owner','Name',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_facility','financial_responsibility_obtained','md_facility_combined','Finance','Please verify');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_facility','financial_responsibility_bond_rating_test','md_facility_combined','LocGovBondRating','Please verify');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_facility','financial_responsibility_commercial_insurance','md_facility_combined','Insurance',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_facility','financial_responsibility_guarantee','md_facility_combined','Guarantee',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_facility','financial_responsibility_letter_of_credit','md_facility_combined','LtrCredit',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_facility','financial_responsibility_local_government_financial_test','md_facility_combined','LocGovFinancialTest',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_facility','financial_responsibility_risk_retention_group','md_facility_combined','RiskRetention',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_facility','financial_responsibility_self_insurance_financial_test','md_facility_combined','SelfInsurance',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_facility','financial_responsibility_state_fund','md_facility_combined','StateFunds',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_facility','financial_responsibility_surety_bond','md_facility_combined','SuretyBond',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_facility','financial_responsibility_trust_fund','md_facility_combined','StandByTrustFund','Please verify');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_facility','financial_responsibility_other_method','md_facility_combined','FinanceOther',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_facility','ust_reported_release','md_release_linkages','ust_facility_id','Where there is linkage found');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_facility','associated_ust_release_id','md_release_linkages','release_id',null);

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_tank','facility_id','md_tanks_combined','FacilityID',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_tank','tank_id','md_tanks_combined','TankID',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_tank','tank_status_id','md_tanks_combined','TankStatusDesc',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_tank','tank_closure_date','md_tanks_combined','DateClosed',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_tank','tank_installation_date','md_tanks_combined','DateInstalled',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_tank','compartmentalized_ust','md_tanks_combined','tblCompartment_Compartment','Where tblCompartment_Compartment <> A');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_tank','number_of_compartments','md_tanks_combined','tblCompartment_Compartment','Count total compartments for the tank');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_tank','tank_material_description_id','md_tanks_combined','TankMatDesc',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_tank','tank_secondary_containment_id','md_tanks_combined','TankModsDesc',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_tank','airport_hydrant_system','md_tanks_combined','TankMatDesc','where TankMatDesc=Airport Hydrant System');

select * from ust_element_mapping where  ust_control_id  = 16;

update ust_element_mapping
set epa_column_name = 'tank_corrosion_protection_interior_lining'
where ust_control_id  = 16
and epa_column_name = 'TankCorrosionProtectionInteriorLining';


select  from ust_tank
TankCorrosionProtectionInteriorLining

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_tank_substance','facility_id','md_tanks_combined','FacilityID',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_tank_substance','tank_id','md_tanks_combined','TankID',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_tank_substance','substance_id','md_tanks_combined','SubstanceDesc',null);

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_compartment','facility_id','md_tanks_combined','FacilityID',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_compartment','tank_id','md_tanks_combined','TankID',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_compartment','compartment_name','md_tanks_combined','tblCompartment_Compartment',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_compartment','compartment_status_id','md_tanks_combined','TankStatusDesc',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_compartment','compartment_capacity_gallons','md_tanks_combined','Gallons',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_compartment_substance','facility_id','md_tanks_combined','FacilityID',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_compartment_substance','tank_id','md_tanks_combined','TankID',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_compartment_substance','substance_id','md_tanks_combined','SubstanceDesc',null);


insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_piping','facility_id','md_tanks_combined','FacilityID',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_piping','tank_id','md_tanks_combined','TankID',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_piping','piping_material_frp','md_tanks_combined','PipeMatDesc',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_piping','piping_material_gal_steel','md_tanks_combined','PipeMatDesc',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_piping','piping_material_stainless_steel','md_tanks_combined','PipeMatDesc',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_piping','piping_material_steel','md_tanks_combined','PipeMatDesc',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_piping','piping_material_copper','md_tanks_combined','PipeMatDesc',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_piping','piping_material_flex','md_tanks_combined','PipeMatDesc',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_piping','piping_material_no_piping','md_tanks_combined','PipeMatDesc',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_piping','piping_material_other','md_tanks_combined','PipeMatDesc',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (16,'ust_piping','piping_material_unknown','md_tanks_combined','PipeMatDesc',null);


--Step 6: Map the source data values to EPA values 

/* 
 * Table public.ust_element_value_mapping documents the mapping of the source data element
 * values to EPA's lookup values. 
 * This table needs to be populated for all data elements mapped above where the EPA column 
 * has a lookup table. 
 * The following query will tell you which columns you need to perform this exercise for. 
 * (If no rows are returned, make sure you actually ran the SQL statements above after 
 * manipulating them!)

select epa_column_name from 
	(select distinct epa_table_name, epa_column_name, table_sort_order, column_sort_order
	from public.v_ust_needed_mapping 
	where ust_control_id = 16 and mapping_complete = 'N'
	order by table_sort_order, column_sort_order) x;
 
 * To generate the SQL that will assist you in doing the value mapping, run the script 
 * generate_value_mapping_sql.py. Set the following variables before running the script:
 
ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = ZZ                 # Enter an integer that is the ust_control_id or release_control_id
only_incomplete = True   		# Boolean, defaults to True. Set to False to output mapping for all columns regardless if mapping was previously done. 
overwrite_existing = False      # Boolean, defaults to False. Set to True to overwrite existing generated SQL file. If False, will append an existing file.
 
 * This script will output a SQL file (located by default in the repo at 
 * /ust/sql/XX/UST/XX_UST_value_mapping.sql). Open the generated file in your database console 
 * and step through it.  
 * 
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--facility_type1

--select distinct "FacilityDesc" from md_ust."md_supp_tank_data" where "FacilityDesc" is not null order by 1;
/* Organization values are:

Air Taxi (Airline)
Apartment/Condo
Auto Dealership
Church
Commercial
Contractor
Educational
Exempt Commercial
Farm
Federal Military
Federal Non-Military
Fire/Rescue/Ambulance
Gas Station
Health Care
Hotel/Motel
Industrial
Local Government
Marina
Not Listed
Office
Other
Petroleum Distributor
Railroad
Residential
Restaurant
State Government
Store
Truck/Transporter
Utilities
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2916, 'Air Taxi (Airline)', 'Aviation/airport (non-rental car)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2916, 'Apartment/Condo', 'Residential', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2916, 'Auto Dealership', 'Auto dealership/auto maintenance & repair', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2916, 'Church', 'Other', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2916, 'Commercial', 'Commercial', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2916, 'Contractor', 'Contractor', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2916, 'Educational', 'School', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2916, 'Exempt Commercial', 'Commercial', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2916, 'Farm', 'Agricultural/farm', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2916, 'Federal Military', 'Military', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2916, 'Federal Non-Military', 'Federal government, non-military', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2916, 'Fire/Rescue/Ambulance', 'State/local government', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2916, 'Gas Station', 'Retail fuel sales (non-marina)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2916, 'Health Care', 'Hospital (or other medical)', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2916, 'Hotel/Motel', 'Commercial', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2916, 'Industrial', 'Industrial', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2916, 'Local Government', 'State/local government', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2916, 'Marina', 'Marina', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2916, 'Not Listed', 'Unknown', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2916, 'Office', 'Commercial', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2916, 'Other', 'Other', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2916, 'Petroleum Distributor', 'Bulk plant storage/petroleum distributor', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2916, 'Railroad', 'Railroad', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2916, 'Residential', 'Residential', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2916, 'Restaurant', 'Commercial', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2916, 'State Government', 'State/local government', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2916, 'Store', 'Commercial', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2916, 'Truck/Transporter', 'Trucking/transport/fleet operation', null);
insert into public.ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments)
values (2916, 'Utilities', 'Utility', null);

--select facility_type from public.facility_types;
/* Valid EPA values are:

Agricultural/farm
Auto dealership/auto maintenance & repair
Aviation/airport (non-rental car)
Bulk plant storage/petroleum distributor
Commercial
Contractor
Hospital (or other medical)
Industrial
Marina
Railroad
Rental Car
Residential
Retail fuel sales (non-marina)
School
Telecommunication facility
Trucking/transport/fleet operation
Utility
Wholesale
Other
Unknown
Federal government, non-military
Military
State/local government

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_ust_element_mapping
where epa_column_name = 'facility_type1'
and lower(organization_value) like lower('%store%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_ust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_ust_element_mapping
 * to do mapping, check public.facility_types to find the updated epa_value.
 */





------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 7: Send the substance mapping (if it exists) for review by an ERG chemical expert 

/*
 * Run script export_substance_mapping.py to export the substance mapping and email it to John Wilhelmi,
 * who will send it along to a chemical expert at ERG to review it for possible hazardous substances.  
 * The script will automatically send the email through Outlook if you are on an ERG computer and
 * have the python module pypiwin32 installed in your environment. 
 * (Note: If the script is unable to send the email automatically (check your Sent folder), please
 * manually attach the file (located at /ust/python/exports/mapping/XX/UST/) and send an email 
 * to John.Wilhelmi@erg.com, CCing Victoria and Renae. 
 * 
 * Set these variables in the script: 
 
ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = ZZ                 # Enter an integer that is the ust_control_id or release_control_id
send_email = True				# Boolean; defaults to True. If True, will use Outlook to automatically email the generated file for ERG review. 

# These variables can usually be left unset. This script will generate an Excel file in the appropriate state folder in the repo under /ust/python/exports/mapping.
# This file directory and its contents are excluded from pushes to the repo by .gitignore.
export_file_path = None
export_file_dir = None
export_file_name = None

*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 8: Create the value mapping crosswalk views

/* 
 * Run script org_mapping_xwalks.py to create crosswalk views for all lookup tables.
 * Set these variables in the script:
 
ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = ZZ                 # Enter an integer that is the ust_control_id or release_control_id
  
 * To see the crosswalk views after running the script:

select table_name 
from information_schema.tables 
where table_schema = lower('XX_ust') and table_type = 'VIEW'
and table_name like '%_xwalk' order by 1;

*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 9: Create unique identifiers if they don't exist

/* 
 * Run script create_missing_id_columns.py to identify if any required columns (e.g. Tank ID, Compartment ID, etc.)
 * are missing and to create an ERG table containing generated IDs if necessary. 
 * Set these variables in the script:

ust_or_release = 'ust' 			 # Valid values are 'ust' or 'release' 
control_id = ZZ                  # Enter an integer that is the ust_control_id
drop_existing = False 		     # Boolean, defaults to False. Set to True to drop the table if it exists before creating it new.
write_sql = True                 # Boolean, defaults to True. If True, writes a SQL script recording the queries it ran to generate the tables.
overwrite_sql_file = False       # Boolean, defaults to False. Set to True to overwrite an existing SQL file if it exists. This parameter has no effect if write_sql = False. 

 * By default, this script will generate any required ID columns, update the public.ust_element_mapping table,
 * and export a SQL file (located by default in the repo at /ust/sql/XX/UST/XX_UST_id_column_generation.sql).
 * You do NOT need to run the SQL in the generated file, however, if the script encounters errors or if you
 * are unable to write the views in the next step because the script did not correctly create the ID
 * generation tables, you can review this SQL file and make changes as needed to fix the data. If you do
 * need to make changes to generated ID tables, be sure to accurately update public.ust_element_mapping table,
 * including making robust comments in the programmer_comments columns.

*/
--check to see if the script generated any tables 
select epa_table_name, epa_column_name, organization_table_name 
from public.v_ust_element_mapping a join public.ust_template_data_tables b 
	on a.epa_table_name = b.table_name 
where ust_control_id = ZZ and organization_table_name like 'erg%'
order by sort_order;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 10: Write the views that convert the source data to the EPA format

/** THIS SECTION UNDER CONSTRUCTION!!! 
 * 
 * Please write the views manually (refer to the views in other state schemas for the basic structure)
 * for now.  
 * 
 * 
 * **/

/* UNDER CONSTRUCTION!!!!
 * Run script create_view_sql.py to create the BASIC STRUCTURE of the views that will be used to
 * populate the templates. 
 * WARNING! The queries generated by the script are a STARTING PLACE for the developers but will 
 * in most cases need to be manually manipulated to correctly select the data. 
 * 
*/

--Remind yourself if there are any state-level business rules you need to take into consideration
--when writing the views (such as excluding AST, for example).
select comments from public.ust_control where ust_control_id = ZZ;



-- md_ust.v_ust_facility source

CREATE OR REPLACE VIEW md_ust.v_ust_facility
AS SELECT DISTINCT x."FacilityID"::character varying(50) AS facility_id,
    x."LocName"::character varying(100) AS facility_name,
    x."LocStr"::character varying(100) AS facility_address1,
    x."City"::character varying(100) AS facility_city,
    x."County"::character varying(100) AS facility_county,
    x."ZIP"::character varying(10) AS facility_zip_code,
    mo."Name"::character varying(100) AS facility_owner_company_name,
        CASE
            WHEN x."Finance" IS TRUE THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_obtained,
        CASE
            WHEN x."LocGovBondRating" IS TRUE THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_bond_rating_test,
        CASE
            WHEN x."Insurance" IS TRUE THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_commercial_insurance,
        CASE
            WHEN x."Guarantee" IS TRUE THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_guarantee,
        CASE
            WHEN x."LtrCredit" IS TRUE THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_letter_of_credit,
        CASE
            WHEN x."LocGovFinancialTest" IS TRUE THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_local_government_financial_test,
        CASE
            WHEN x."RiskRetention" IS TRUE THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_risk_retention_group,
        CASE
            WHEN x."SelfInsurance" IS TRUE THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_self_insurance_financial_test,
        CASE
            WHEN x."StateFunds" IS TRUE THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_state_fund,
        CASE
            WHEN x."SuretyBond" IS TRUE THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_surety_bond,
        CASE
            WHEN x."StandByTrustFund" IS TRUE THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_trust_fund,
    x."FinanceOther"::character varying(500) AS financial_responsibility_other_method,
        CASE
            WHEN rl.ust_facility_id IS NOT NULL THEN 'Yes'::text
            ELSE NULL::text
        END AS ust_reported_release,
    md_ust.get_latest_release_id(rl.ust_facility_id::character varying)::character varying(40) AS associated_ust_release_id,
    'MD'::text AS facility_state,
    3 AS facility_epa_region,
    facility_type_id as facility_type1
   FROM md_ust.md_facility_combined x
   	left join md_ust.md_supp_tank_data z on x."FacilityID" = z."FacilityID"
   	left join md_ust.v_facility_type_xwalk ft on z."FacilityDesc" = ft.organization_value 
     LEFT JOIN md_ust.md_owner mo ON x."OwnerID" = mo."OwnerID"
     LEFT JOIN md_ust.md_release_linkages rl ON x."FacilityID"::character varying::text = rl.ust_facility_id::character varying::text;

    select * from v_facility_type_xwalk;
    select * from md_supp_tank_data;
    select count(*) from v_ust_facility;  --20314
    
    select * from v_ust_facility where facility_type1 is not null;
   
   select * from md_facility_combined x
    join md_ust.md_supp_tank_data z on x."FacilityID" = z."FacilityID"
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 11: QA the views 

/* 
 * Run script qa_check.py to check that the views you have written to populate the main data tables
 * adhere to all business and logic rules.  
 * Set these variables in the script:

ust_or_release = 'ust' 			 # Valid values are 'ust' or 'release' 
control_id = ZZ                  # Enter an integer that is the ust_control_id

 * This script will check the views you just created in the state schema for the following:
 * 1) Missing views - will check that if you created a child view (for example, v_ust_compartment), that the parent view(s) (for example, v_ust_tank)
 *    exist. 
 * 2) Counts of child tables that have too few rows (for example, v_ust_compartment should have at least as many rows as v_ust_tank because
 *    every tank should have at least one compartment). 
 * 3) Missing join columns to parent tables. For example, v_ust_compartment must contain facility_id and tank_id in order to be able to join it
 *    to its parent tables. 
 * 4) Missing required columns. 
 * 5) Required columns that exist but contain null values. 
 * 6) Extraneous columns - will check for any columns in the views that don't match a column in the equivalent EPA table. This will help identify
 *    typos or other errors. 
 * 7) Non-unique rows. To resolve any cases where the counts are greater than 0, check that you did a "select distinct" when creating these views.
 *    Then check for bad joins.  
 * 8) Bad data types - will check for columns in the view where either the data type is different than the EPA column, or (for character columns) 
 *    if the length of the state value is too long to fit into the EPA column. If the data is too long to fit in the EPA column, this may indicate 
 *    an error in your code or mapping, OR it may mean you need to truncate the state's value to fit the EPA format. 
 * 9) Failed check constraints. 
 * 10) Columns that exist in the view that were not mapped in ust_element_mapping. 
 * 11) Bad mapping values. To resolve any cases where bad mapping values exist, examine the specific row(s) in public.ust_element_value_mapping 
 *     and ensure the epa_value exists in the associated lookup table. 
 *
 * The script will also provide the counts of rows in v_ust_facility, v_ust_tank, v_ust_compartment, and v_ust_piping (if these views exist) -
 * ensure these counts make sense! 
 *   
 * The script will export a QAQC spreadsheet to the repo at 
 * /ust/python/exports/QAQC/XX/UST/XX_UST_QAQC_yyyymmddsssss.xlsx 
 * (in additional to printing to the screen and logs). If there are errors, re-write the views above, 
 * then re-run the qa script, and proceed when all errors have been resolved. 
 * 
*/

--------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 12: Insert data into the EPA schema 

/*
 * Run script populate_epa_data_tables.py to insert data into the main data tables in the public schema 
 * (ust_facility, ust_tank, ust_tank_substance, ust_compartment, ust_compartment_substance, ust_piping,
 * ust_facility_dispenser, ust_tank_dispenser, and/or ust_compartment_dispenser) using the views you 
 * wrote in Step 9 above. 
 * 
 * Set these variables in the script: 
 
ust_or_release = 'ust' 			 # Valid values are 'ust' or 'release' 
control_id = ZZ                  # Enter an integer that is the ust_control_id
delete_existing = False 		 # can set to True if there is existing UST data you need to delete before inserting new

 * Do a quick sanity check of number of rows inserted:
*/
select table_name, num_rows 
from v_ust_table_row_count
where ust_control_id = 16
order by sort_order;

 SELECT DISTINCT d.ust_control_id,
    d.facility_id AS "FacilityID",
    c.tank_id AS "TankID"--,
  --  c.tank_name AS "TankName",
  --  b.compartment_id AS "CompartmentID"--,
 --   b.compartment_name AS "CompartmentName"--,
--    s.substance AS "Substance",
   -- a.substance_comment AS "SubstanceComment"
   FROM public.ust_compartment_substance a
     left JOIN public.ust_compartment b ON a.ust_compartment_id = b.ust_compartment_id
     left JOIN public.ust_tank c ON b.ust_tank_id = c.ust_tank_id
     left JOIN public.ust_facility d ON c.ust_facility_id = d.ust_facility_id
  --   JOIN public.ust_tank_substance ts ON a.ust_tank_substance_id = ts.ust_tank_substance_id
  --   JOIN public.substances s ON ts.substance_id = s.substance_id
    where d.ust_control_id = 16;
  
   
									select distinct ust_tank_substance_id, ust_compartment_id , a.compartment_id, d.compartment_id, c.ust_tank_id,c.tank_id ,c.tank_name, a.*
									from md_ust.v_ust_compartment_substance a 
										   join (select ust_facility_id, facility_id from public.ust_facility where ust_control_id = 16) b
											on a.facility_id = b.facility_id
										  join public.ust_tank c on b.ust_facility_id = c.ust_facility_id and a.tank_id = c.tank_id
										  join public.ust_compartment d on c.ust_tank_id = d.ust_tank_id --and a.compartment_id = d.compartment_id
									 join public.ust_tank_substance e on c.ust_tank_id = e.ust_tank_id and a.substance_id = e.substance_id 
									 where c.ust_tank_id = 4589206;
		
		

										select distinct ust_facility_id, tank_id, tank_status_id, airport_hydrant_system, tank_closure_date, tank_installation_date, compartmentalized_ust, number_of_compartments, tank_material_description_id, tank_secondary_containment_id, tank_corrosion_protection_impressed_current, tank_corrosion_protection_interior_lining, tank_corrosion_protection_sacrificial_anode from md_ust.v_ust_tank a 
										join (select ust_facility_id, facility_id from public.ust_facility where ust_control_id = 16) b
											on a.facility_id = b.facility_id


											
											-- md_ust.v_ust_compartment_substance source


--------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 13: Export populated EPA template

/*
 * Run script export_template.py to generate a populated EPA template that will be sent first to OUST
 * for review, then to the state for review.
 * 
 * Set these variables in the script: 

ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = ZZ                 # Enter an integer that is the ust_control_id or release_control_id

 * 
 * This script will output an Excel file (located by default in the repo at 
 * /ust/python/exports/epa_templates/XX/UST/XX_UST_template_yyyymmddsssss.xlsx). 
 * Before uploading this file in Step 14, open it to make sure it was generated correctly.
 * 
*/

--------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 14: Export control table summary

/*
 * Run script control_table_summary.py to generate a high-level overview of the data for OUST's review. 
 * 
 * Set these variables in the script: 

ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = ZZ                 # Enter an integer that is the ust_control_id or release_control_id

 * 
 * This script will output an Excel file (located by default in the repo at 
 * /ust/python/exports/control_table_summaries/XX/UST/XX_UST_control_table_summary_yyyymmddsssss.xlsx). 
 * Before uploading this file in Step 14, open it to make sure it was generated correctly.
 * 
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--Step 15: Upload exported files to EPA Teams

/* 
 * Upload the following three files to the appropriate state folder on the EPA Teams site at 
 * https://usepa.sharepoint.com/:f:/r/sites/USTFinder2ASTSWMO/Shared%20Documents/General/02%20-%20Draft%20Mapped%20Templates?csf=1&web=1&e=fp1koB
 * (Documents > General > 02 - Draft Mapped Templates)
 * 
 * 1) Populated EPA template: /ust/python/exports/epa_templates/XX/UST/XX_UST_template_yyyymmddsssss.xlsx
 * 2) QAQC file: /ust/python/exports/QAQC/XX/UST/XX_UST_QAQC_yyyymmddsssss.xlsx
 * 3) Control table summary file: /ust/python/exports/control_table_summaries/XX/UST/XX_UST_control_table_summary_yyyymmddsssss.xlsx
 *
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--Step 16: Request peer review and make any suggested changes

/* 
 * All templates must be peer reviewed before sending to OUST. Currently Renae and Jim are available for peer reviews.
 * Send a Teams message to both Renae and Jim asking who is available to do a review. Set the status to 
 * "ERG Peer Review" in the Jira ticket and assign it to whichever developer agreed to perform the review. 
 * 
 * If the reviewing developer suggested any changes to your mapping or logic, follow these steps:
 * 
 * 1) Make suggested changes in the database. 
 * 2) If necessary, update the views you created in Step 9. 
 * 3) If you made any changes to the views you created in Step 9, re-run Step 10 to QA the views. 
 * 4) Rerun Step 11 to re-insert the data into the EPA schema. Remember to set the delete_existing variable 
 *    in the script to True (it defaults to False) to delete the data before re-inserting it. 
 * 5) Rerun Step 12 to export a new populated template. 
 * 6) If you made any changes to ust_control, rerun Step 13 to export a new control table summary file. 
 * 7) Rerun Step 14 to re-upload all new exports to the EPA Teams site. 
 * 8) Add a comment to the Jira ticket noting you've made the changes and are ready for another review.
 *    Assign the ticket back to the original reviewer and make sure the status is ERG Peer Review if not already.
 *    Be sure to @ the reviewer in the ticket comment so they are aware they need to take action. 
 * 9) Repeat these steps until the reviewer approves the template for sending to OUST. 
 * 
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--Step 17: Export source data (if necessary)

/* 
 * OUST has requested that ERG make all source data available to them to assist in their review. If the 
 * state sent ERG Excel or CSV files, or a populated EPA template, Victoria will upload the source data to 
 * the EPA Teams site and you can skip this step. If, however, you had to download files from a state website, 
 * or if you retrieved the state data from an API, or if the state sent a database we extracted data from, or 
 * if for any other reason the source data was not uploaded to the EPA Teams site in the 
 * Documents > General > 01 - UST Source Data > XX > State-Provided Source Data folder, you must export the 
 * tables from the ERG database to CSV files and upload them to the EPA Teams site at
 * Documents > General > 01 - UST Source Data > XX > ERG Source Data folder. 
 * 
 * To export the source data from the database, run script export_source_data.py
 * 
 * Set these variables in the script: 
 * 
ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = ZZ                 # Enter an integer that is the ust_control_id or release_control_id
all_tables = True               # Boolean, defaults to True. If True will export all source data tables; if False will only export those referenced in ust_element_mapping or release_element_mapping.
tables_to_exclude = []          # Python list of strings; defaults to empty list. Populate with table names in the organization schema that should be excluded from the export. (NOTE: ERG-created tables will not be exported regardless of the values in this list.)
empty_export_dir = True         # Boolean, defaults to True. If True, will delete all files in the export directory before proceeding. If False, will not delete any files, but will overwrite any that have the same name as the generated file name. 

 * 
 * This script will output a CSV file for each table in the state schema (the default export location is 
 * in the repo at /ust/python/exports/source_data/XX/UST). 
 * After exporting the files, upload them to the appropriate state folder on the EPA Teams site at
 * https://usepa.sharepoint.com/:f:/r/sites/USTFinder2ASTSWMO/Shared%20Documents/General/01%20-%20UST%20Source%20Data?csf=1&web=1&e=7GtcsH
 * 
*/

--old script

/*
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--see what columns in which table we need to map
/*
see what mapping hasn't yet been done for this dataset 
we'll be going through each of the results of this query below
so for each value of epa_column_name from this query result, there will be a 
section below where we generate SQL to perform the mapping 
*/
select epa_table_name, epa_column_name 
from 
	(select distinct epa_table_name, epa_column_name, table_sort_order, column_sort_order
	from v_ust_needed_mapping 
	where ust_control_id = 16 and mapping_complete = 'N'
	order by table_sort_order, column_sort_order) x;
/*
ust_tank	tank_status_id
ust_tank	tank_material_description_id
ust_tank	tank_secondary_containment_id
ust_tank_substance	substance_id
ust_compartment	compartment_status_id
ust_compartment_substance	substance_id
*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--check the state's data 
select distinct 'select distinct "' || organization_column_name || '" from md_ust."' || organization_table_name || '" order by 1;'
from v_ust_needed_mapping 
where ust_control_id = 16 and epa_column_name = 'tank_status_id';

select distinct "TankStatusDesc" from md_ust."md_tanks_combined" order by 1;

select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 16 and epa_column_name = 'compartment_status_id';

--paste the insert_sql from the first row below, then run the query:
select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 1045 || ', ''' || "TankStatusDesc" || ''', '''', null);'
from md_ust."md_tanks_combined" order by 1;

delete from ust_element_value_mapping where ust_element_mapping_id = 1058 and ust_element_value_mapping_id= 853;


select * from ust_element_value_mapping where ust_element_mapping_id = 1058 and ust_element_value_mapping_id= 853;

--tank
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1045, 'Currently In Use', 'Currently in use', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1045, 'Permanently Out of Use', 'Closed (general)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1045, 'Permanently Out Of Use', 'Closed (general)', null);

insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1045, 'Temporarily Out Of Use', 'Temporarily out of service', null);;


--compartment
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1058, 'Currently In Use', 'Currently in use', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1058, 'Permanently Out of Use', 'Closed (general)', null);

insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1058, 'Permanently Out Of Use', 'Closed (general)', null);

insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1058, 'Temporarily Out Of Use', 'Temporarily out of service', null);;


--substance id

select distinct 'select distinct "' || organization_column_name || '" from md_ust."' || organization_table_name || '" order by 1;'
from v_ust_needed_mapping 
where ust_control_id = 16 and epa_column_name = 'substance_id';

select distinct "SubstanceDesc" from md_ust."md_tanks_combined" order by 1;


select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 16 and epa_column_name = 'substance_id';

select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 1062 || ', ''' || "SubstanceDesc" || ''', '''', null);'
from md_ust."md_tanks_combined" order by 1;


select * from public.substances where lower(substance) like  lower('%Used%');

select state_value,epa_value 
from archive.v_ust_element_mapping 
where lower(element_name) like lower('%substance%')
and lower(state_value) like lower('%Not Listed%');

select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 1054 || ', ''' || "SubstanceDesc" || ''', '''', null);'
from md_ust."md_tanks_combined" order by 1;

select * from ust_element_value_mapping where ust_element_mapping_id = 1054 and organization_value ='Methanol';

update  ust_element_value_mapping 
set programmer_comments=null,
epa_value = 'Hazardous substance',
epa_comments = 'Hazardous substance' 
where ust_element_mapping_id = 1054 and organization_value ='Methanol';
--tank sub

select * from public.substances s where lower(substance) like '%aviation%';


insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1054, 'Aviation', 'Aviation gasoline', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1054, 'Bio-Diesel', 'Diesel fuel (b-unknown)', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1054, 'Diesel', 'Diesel fuel (b-unknown)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1054, 'Ethanol E-85', 'E-85/Flex Fuel (E51-E83)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1054, 'Gasohol', 'Ethanol blend gasoline (e-unknown)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1054, 'Gasoline', 'Gasoline (unknown type)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1054, 'Hazardous Substance', 'Hazardous substance', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1054, 'Heating Oil', 'Heating/fuel oil # unknown', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1054, 'Kerosene', 'Kerosene', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1054, 'Lube Oil', 'Lube/motor oil (new)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1054, 'Methanol', 'Petroleum product', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1054, 'Mixture', 'Other or mixture', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1054, 'Not Listed', 'Other or mixture', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1054, 'Other', 'Other or mixture', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1054, 'Other-Fed', 'Other or mixture', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1054, 'Unknown', 'Unknown', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1054, 'Used Oil', 'Used oil/waste oil', null);

--compartment sub
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1062, 'Aviation', 'Aviation gasoline', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1062, 'Bio-Diesel', 'Diesel fuel (b-unknown)', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1062, 'Diesel', 'Diesel fuel (b-unknown)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1062, 'Ethanol E-85', 'E-85/Flex Fuel (E51-E83)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1062, 'Gasohol', 'Ethanol blend gasoline (e-unknown)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1062, 'Gasoline', 'Gasoline (unknown type)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1062, 'Hazardous Substance', 'Hazardous substance', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1062, 'Heating Oil', 'Heating/fuel oil # unknown', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1062, 'Kerosene', 'Kerosene', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1062, 'Lube Oil', 'Lube/motor oil (new)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1062, 'Methanol', 'Petroleum product', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1062, 'Mixture', 'Other or mixture', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1062, 'Not Listed', 'Other or mixture', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1062, 'Other', 'Other or mixture', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1062, 'Other-Fed', 'Other or mixture', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1062, 'Unknown', 'Unknown', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1062, 'Used Oil', 'Used oil/waste oil', null);



--tank_material_description_id

select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 16 and epa_column_name = 'tank_material_description_id';

select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 1050 || ', ''' || "TankMatDesc" || ''', '''', null);'
from md_ust."md_tanks_combined" order by 1;


select * from public.tank_material_descriptions ;

select distinct state_value, epa_value
from archive.v_ust_element_mapping 
where lower(element_name) like lower('%pip%style%')
and lower(state_Value) like '%Hydrant%'
order by 1, 2;

select * from ust_element_value_mapping where ust_element_mapping_id = '1050' and organization_value  = 'Cathodically Protected Steel (Coating w/CP - Galvanic)';


update ust_element_value_mapping 
set programmer_comments = null,
epa_comments = 'Correct'
where ust_element_mapping_id = '1050' and organization_value  = 'Polyethylene Tank Jacket';

insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1050, 'Airport Hydrant System', 'Other', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1050, 'Asphalt Coated or Bare Steel', 'Asphalt coated or bare steel', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1050, 'Cathodically Protected Steel (Coating w/CP - Galvanic)', 'Coated and cathodically protected steel',  'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1050, 'Cathodically Protected Steel (CP Steel - Impressed Current)', 'Coated and cathodically protected steel',  'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1050, 'Cathodically Protected Steel (Supplemental Anodes Added)', 'Coated and cathodically protected steel',  'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1050, 'Composite (Steel w/ FRP)', 'Composite/clad (steel w/fiberglass reinforced plastic)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1050, 'Concrete', 'Concrete', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1050, 'Epoxy Coated Steel', 'Epoxy coated steel', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1050, 'Fiberglass Reinforced Plastic', 'Fiberglass reinforced plastic', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1050, 'Not Listed', 'Unknown', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1050, 'Other', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1050, 'Polyethylene Tank Jacket', 'Jacketed steel', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1050, 'Unknown', 'Unknown', null);

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--tank_secondary_containment_id


select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 16 and epa_column_name = 'tank_secondary_containment_id';


select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 1051 || ', ''' || "TankModsDesc" || ''', '''', null);'
from md_ust."md_tanks_combined" order by 1;

select * from public.tank_secondary_containments tsc ;


select distinct state_value, epa_value
from archive.v_ust_element_mapping 
where lower(element_name) like lower('%containment%')
and lower(state_Value) like '%Lined Interior%'
order by 1, 2;

insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1051, 'Double-Walled', 'Double wall', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1051, 'Excavation Liner', 'Excavation liner', null);

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--check if there is any more mapping to do
select distinct epa_table_name, epa_column_name
from v_ust_needed_mapping 
where ust_control_id = 16 and mapping_complete = 'N'
order by 1, 2;

--check if any of the mapping is bad:
select database_lookup_table, epa_value 
from v_ust_bad_mapping 
where ust_control_id = 16 order by 1, 2;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*Step 1: create crosswalk views for columns that use a lookup table
run script org_mapping_xwalks.py to create crosswalk views for all lookup tables 
see new views:*/
select table_name 
from information_schema.tables 
where table_schema = 'md_ust' and table_type = 'VIEW'
and table_name like '%_xwalk' order by 1;
/*
v_coordinate_source_xwalk
v_piping_style_xwalk
v_piping_wall_type_xwalk
v_state_xwalk
v_substance_xwalk
v_tank_material_description_xwalk
v_tank_status_xwalk
*/

--Step 2: see the EPA tables we need to populate, and in what order
select distinct epa_table_name, table_sort_order
from v_ust_table_population 
where ust_control_id = 16
order by table_sort_order;
/*
ust_facility
ust_tank
ust_tank_substance
ust_compartment
*/

/*Step 3: check if there where any dataset-level comments you need to incorporate:
in this case we need to ignore the aboveground storage tanks,
so add this to the where clause of the ust_release view */
select comments from ust_control where ust_control_id = 16;

/*Step 4: work through the tables in order, using the information you collected 
to write views that can be used to populate the data tables 
NOTE! The view queried below (v_ust_table_population_sql) contains columns that help
      construct the select sql for the insertion views, but will require manual 
      oversight and manipulation by you! 
      In particular, check out the organization_join_table and organization_join_column 
      are used!!*/
select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, data_type, character_maximum_length,
	programmer_comments, database_lookup_table, database_lookup_column,
	organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 16 and epa_table_name = 'ust_facility'
order by column_sort_order;

/*Step 5: use the information from the queries above to create the view:
!!! NOTE look at the programmer_comments column to adjust the view if necessary
!!! NOTE also sometimes you need to explicitly cast data types so they match the EPA data tables
!!! NOTE also you may get errors related to data conversion when trying to compile the view
    you are creating here. This is good because it alerts you the data you are trying to
    insert is not compatible with the EPA format. Fix these errors before proceeding! 
!!! NOTE: Remember to do "select distinct" if necessary
!!! NOTE: Some states do not include State or EPA Region in their database, but it is generally
    safe for you to insert these yourself, so add them! (facility_state is a required field! */
drop view md_ust.v_ust_facility;

create or replace view md_ust.v_ust_facility as 
select distinct 
x."FacilityID"::character varying(50) as facility_id,
x."LocName"::character varying(100) as facility_name,
x."LocStr"::character varying(100) as facility_address1,
x."City"::character varying(100) as facility_city,
x."County"::character varying(100) as facility_county,
x."ZIP"::character varying(10) as facility_zip_code,
mo."Name"::character varying(100) as facility_owner_company_name,
case when x."Finance" is true then 'Yes' else 'No' end as financial_responsibility_obtained,
case when x."LocGovBondRating" is true then 'Yes' else 'No' end as financial_responsibility_bond_rating_test,
case when x."Insurance" is true then 'Yes' else 'No' end as financial_responsibility_commercial_insurance,
case when x."Guarantee" is true then 'Yes' else 'No' end as financial_responsibility_guarantee,
case when x."LtrCredit" is true then 'Yes' else 'No' end as financial_responsibility_letter_of_credit,
case when x."LocGovFinancialTest" is true then 'Yes' else 'No' end as financial_responsibility_local_government_financial_test,
case when x."RiskRetention" is true then 'Yes' else 'No' end as financial_responsibility_risk_retention_group,
case when x."SelfInsurance" is true then 'Yes' else 'No' end as financial_responsibility_self_insurance_financial_test,
case when x."StateFunds" is true then 'Yes' else 'No' end as financial_responsibility_state_fund,
case when x."SuretyBond" is true then 'Yes' else 'No' end as financial_responsibility_surety_bond,
case when x."StandByTrustFund" is true then 'Yes' else 'No' end as financial_responsibility_trust_fund,
"FinanceOther"::character varying(500) as financial_responsibility_other_method,
case when rl."ust_facility_id" is not null then 'Yes' end as ust_reported_release,
md_ust.get_latest_release_id(rl."ust_facility_id")::character varying(40) as associated_ust_release_id,
'MD' as facility_state,
3 as facility_epa_region
from md_ust.md_facility_combined x 
left join md_ust.md_owner mo on x."OwnerID" = mo."OwnerID"
left join md_ust.md_release_linkages rl on x."FacilityID"::varchar = rl.ust_facility_id::varchar;

create index mrl_idx on md_release_linkages(ust_facility_id);
analyze md_release_linkages

--review: 
select * from md_ust.v_ust_facility;
select count(*) from md_ust.v_ust_facility;
--20314
--------------------------------------------------------------------------------------------------------------------------
--now repeat for each data table:

--ust_tank 
select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, data_type, character_maximum_length,
	programmer_comments, database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 16 and epa_table_name = 'ust_tank'
order by column_sort_order;

/*be sure to do select distinct if necessary!
NOTE: ADD facility_id::character varying(50)!!!!
NOTE: tank_id (integer) is a required field - if the state data does not contain an integer field
      that uniquely identifies the tank, you must generate one (see Compartments below for how to do this).
*/


drop view md_Ust.v_ust_tank;

create or replace view md_ust.v_ust_tank as 
select distinct 
x."FacilityID"::character varying(50) as facility_id,
"TankID"::integer as tank_id,
tank_status_id as tank_status_id,
case when x."TankMatDesc" = 'Airport Hydrant System' then 'Yes' else 'No' end as airport_hydrant_system,
x."DateClosed"::date as tank_closure_date,
x."DateInstalled"::date as tank_installation_date,
case when md_ust.get_compartment_data("FacilityID","TankID") = 1 then 'No' else 'Yes' end as compartmentalized_ust,
md_ust.get_compartment_data("FacilityID","TankID")::integer  as number_of_compartments,
tank_material_description_id as tank_material_description_id,
tank_secondary_containment_id as tank_secondary_containment_id,
case when x."TankMatDesc" = 'Lined Interior w/ Impressed Current' then 'Yes' else 'No' end  as tank_corrosion_protection_impressed_current,
case when x."TankMatDesc" like 'Lined Interior%' then 'Yes' else 'No' end  as tank_corrosion_protection_interior_lining
from md_ust.md_tanks_combined x
left join md_ust.v_tank_status_xwalk vtsx on vtsx.organization_value = x."TankStatusDesc" 
left join md_ust.v_tank_material_description_xwalk vtmdx  on vtmdx.organization_value = x."TankMatDesc" 
left join md_ust.v_tank_secondary_containment_xwalk vtscx  on  vtscx.organization_value = x."TankModsDesc" 


select * from v_tank_status_xwalk;
Permanently Out of Use
Permanently Out Of Use

select distinct "TankStatusDesc"  from  md_ust.md_tanks_combined;

select count(*) from md_tanks_combined; 61914
select count(*) from md_ust.v_ust_tank;60847


--------------------------------------------------------------------------------------------------------------------------
--ust_tank_substance

select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, data_type, character_maximum_length,
	programmer_comments, database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 16 and epa_table_name = 'ust_tank_substance'
order by column_sort_order;
/*
"tanks"	
"Substance"	
substance_id as substance_id,	
integer			
substances	
substance	
erg_substance_deagg	
Substance
*/

/*be sure to do select distinct if necessary!
NOTE: ADD facility_id::character varying(50) and tank_id::int!!!!
*/
create or replace view md_ust.v_ust_tank_substance as 
select distinct 
	x."FacilityID"::character varying(50) as facility_id,
	x."TankID" as tank_id,
	sx.substance_id as substance_id
from md_ust.md_tanks_combined x 
join md_ust.v_substance_xwalk sx on x."SubstanceDesc" = sx.organization_value;

select * from v_ust_tank_substance;
 

select count(*) from md_ust.v_ust_tank_substance;
--61489


--------------------------------------------------------------------------------------------------------------------------
--ust_compartment
select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, data_type, character_maximum_length,
	programmer_comments, database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 16 and epa_table_name = 'ust_compartment'
order by column_sort_order;

/* be sure to do select distinct if necessary!
NOTE: ADD facility_id::character varying(50) and tank_id::int!!!!
NOTE: compartment_id (integer) is a required field - if the state data does not contain an integer field
      that uniquely identifies the compartment, you must generate one. 
      In this case, the state does not store compartment data, so we will generate the compartment ID
      Prefix any tables you create in the state schema that did not come from the source data with "erg_"! */

drop table md_ust.erg_compartment;
create table md_ust.erg_compartment (facility_id character varying(50), tank_id int, compartment_id int generated always as identity);
insert into md_ust.erg_compartment (facility_id, tank_id)
select  facility_id,tank_id from md_ust.v_ust_tank;

create or replace view md_ust.v_ust_compartment as 
select distinct 
c.facility_id as facility_id,
c.tank_id,
c.compartment_id,
x."tblCompartment_Compartment"::character varying(50) as compartment_name,
compartment_status_id as compartment_status_id,
x."Gallons"::integer as compartment_capacity_gallons
from md_ust.md_tanks_combined x  
join md_ust.erg_compartment c on x."FacilityID"::varchar = c.facility_id and x."TankID"::int = c.tank_id
left join md_ust.v_compartment_status_xwalk ts on x."TankStatusDesc" = ts.organization_value;


select count(*) from v_ust_compartment;

select * from v_ust_compartment;


--------------------------------------------------------------------------------------------------------------------------
--ust_compartment_substance

select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, data_type, character_maximum_length,
	programmer_comments, database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 16 and epa_table_name = 'ust_compartment_substance'
order by column_sort_order;
/*
"tanks"	
"Substance"	
substance_id as substance_id,	
integer			
substances	
substance	
erg_substance_deagg	
Substance
*/

/*be sure to do select distinct if necessary!
NOTE: ADD facility_id::character varying(50) and tank_id::int!!!!
*/
create or replace view md_ust.v_ust_compartment_substance as 
select distinct 
	x."FacilityID"::character varying(50) as facility_id,
	x."TankID" as tank_id,
	--sx.substance_id as substance_id,
	c.compartment_id
from md_ust.md_tanks_combined x 
--join md_ust.v_substance_xwalk sx on x."SubstanceDesc" = sx.organization_value
join md_ust.erg_compartment c on x."FacilityID"::varchar = c.facility_id and x."TankID"::int = c.tank_id
join md_ust.v_ust_tank_substance d on x."FacilityID"::varchar = c.facility_id and x."TankID"::int = c.tank_id;


select * from ust_tank_substance;
select * from v_ust_compartment_substance;
 

select count(*) from md_ust.v_ust_compartment_substance;
--61489

--------------------------------------------------------------------------------------------------------------------------
--ust_piping

delete from md_ust.erg_piping;

create table md_ust.erg_piping (facility_id character varying(50), tank_id int, compartment_id int, piping_id int generated always as identity);
insert into md_ust.erg_piping (facility_id, tank_id,compartment_id)
select facility_id,tank_id,compartment_id from md_ust.v_ust_compartment;


select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, programmer_comments, 
	database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 16 and epa_table_name = 'ust_piping'
order by column_sort_order;

drop view v_ust_piping;

create or replace view md_ust.v_ust_piping as
select  distinct
c.piping_id::varchar(50) piping_id,
c.facility_id as facility_id,
c.tank_id,
c.compartment_id,
case "PipeMatDesc" when 'Fiberglass Reinforced Plastic' then 'Yes' else 'No' end as piping_material_frp,
case when  "PipeMatDesc"  in ('Galvanized Steel','Bare or Galvanized Steel') then 'Yes' else 'No' end as piping_material_gal_steel,
case "PipeMatDesc" when 'Steel-slvd. in PVC, FRP or Plastic' then 'Yes' else 'No' end as piping_material_steel,
case  when "PipeMatDesc" in ('Copper (cathodically protected)', 'Copper','Copper sleeved in plastic') then 'Yes' else 'No' end as piping_material_copper,
case "PipeMatDesc" when 'Flexible Plastic' then 'Yes' else 'No' end as piping_material_flex,
case "PipeMatDesc" when 'No Piping' then 'Yes' else 'No' end as piping_material_no_piping,
case "PipeMatDesc" when 'Other' then 'Yes' else 'No' end as piping_material_other,
case "PipeMatDesc" when 'Unknown' then 'Yes' else 'No' end as piping_material_unknown
from md_ust.md_tanks_combined x 
join md_ust.erg_piping c on x."FacilityID"::int = c.facility_id::int  and x."TankID"::int = c.tank_id::int;


select distinct "PipeMatDesc" from md_ust.md_tanks_combined;
select count(*) from md_ust.v_ust_piping; 61993



--------------------------------------------------------------------------------------------------------------------------

--QA/QC

--check that you didn't miss any columns when creating the data population views:
--if any rows are returned by this query, fix the appropriate view by adding the missing columns!
select epa_table_name, epa_column_name, 
	organization_table_name, organization_column_name, 
	organization_join_table, organization_join_column, 
	deagg_table_name, deagg_column_name
from v_ust_missing_view_mapping a
where ust_control_id = 16
order by 1, 2;

--run Python QA/QC script

/*run script qa_check.py
set variables:
ust_or_release = 'ust' 
control_id = 11
export_file_path = None # If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_dir = None	# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_name = None	# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo

This script will check the views you just created in the state schema for the following:
1) Missing views - will check that if you created a child view (for example, v_ust_compartment), that the parent view(s) (for example, v_ust_tank)
   exist. 
2) Counts of child tables that have too few rows (for example, v_ust_compartment should have at least as many rows as v_ust_tank because
   every tank should have at least one compartment). 
3) Missing join columns to parent tables. For example, v_ust_compartment must contain facility_id and tank_id in order to be able to join it
   to its parent tables. 
4) Missing required columns. 
5) Required columns that exist but contain null values. 
6) Extraneous columns - will check for any columns in the views that don't match a column in the equivalent EPA table. This will help identify
   typos or other errors. 
7) Non-unique rows. To resolve any cases where the counts are greater than 0, check that you did a "select distinct" when creating these views.
   Then check for bad joins.  
8) Bad data types - will check for columns in the view where either the data type is different than the EPA column, or (for character columns) 
   if the length of the state value is too long to fit into the EPA column. If the data is too long to fit in the EPA column, this may indicate 
   an error in your code or mapping, OR it may mean you need to truncate the state's value to fit the EPA format. 
9) Failed check constraints. 
10) Bad mapping values. To resolve any cases where bad mapping values exist, examine the specific row(s) in public.ust_element_value_mapping 
   and ensure the epa_value exists in the associated lookup table. 

The script will also provide the counts of rows in md_ust.v_ust_facility, md_ust.v_ust_tank, md_ust.v_ust_compartment, and
   md_ust.v_ust_piping (if these views exist) - ensure these counts make sense! 
   
The script will export a QAQC spreadsheet (in additional to printing to the screen and logs). If there are errors, re-write the views above, 
then re-run the qa script, and proceed when all errors have been resolved. */



--------------------------------------------------------------------------------------------------------------------------
--insert data into the EPA schema 

/*run script populate_epa_data_tables.py	
set variables:
ust_or_release = 'ust' 
control_id = 11
delete_existing = False # can set to True if there is existing UST data you need to delete before inserting new
*/

--------------------------------------------------------------------------------------------------------------------------
--Quick sanity check of number of rows inserted:
select table_name, num_rows 
from v_ust_table_row_count
where ust_control_id = 16 
order by sort_order;
/*
ust_facility	20314
ust_tank	60847
ust_tank_substance	61489
ust_compartment	63258
ust_compartment_substance	63258
ust_piping	64351
*/


--------------------------------------------------------------------------------------------------------------------------
--export template

/*run script export_template.py
set variables:
control_id = 9
ust_or_release = 'ust' 
organization_id = None  	# Can leave as None if you specify the control_id
data_only = False 			# Set to False to export full template including mapping and reference tabs
template_only = False 		# Set to False to export data and mapping tabs as well as reference tab
export_file_path = None 	# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_dir = None		# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_name = None		# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo*/


--------------------------------------------------------------------------------------------------------------------------
--export control table  summary

/*run script control_table_summary.py
set variables:
control_id = 9
ust_or_release = 'ust' 
organization_id = None  	# Can leave as None if you specify the control_id
export_file_path = None 	# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_dir = None		# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo
export_file_name = None		# If export_file_path and export_file_dir/export_file_name are None, defaults to exporting to export directory of repo*/

--------------------------------------------------------------------------------------------------------------------------



-------------------------------------------------------------------------------------------------------------------------0-
*/

											
											
CREATE OR REPLACE VIEW md_ust.v_ust_compartment_substance
AS SELECT distinct c.facility_id, -- x."FacilityID"::character varying(50) AS facility_id,
     c.tank_id, --x."TankID" AS tank_id,
    sx.substance_id,
    c.compartment_id
   FROM md_ust.md_tanks_combined x
     JOIN md_ust.v_substance_xwalk sx ON x."SubstanceDesc" = sx.organization_value::text
     --JOIN md_ust.erg_compartment c ON x."FacilityID"::character varying::text = c.facility_id::text AND x."TankID"::integer = c.tank_id;
       JOIN md_ust.erg_compartment_id c ON x."FacilityID"::character varying::text = c.facility_id::text AND x."TankID"::integer = c.tank_id AND c.compartment_name::text = x."tblCompartment_Compartment"
 
