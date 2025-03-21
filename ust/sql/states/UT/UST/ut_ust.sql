

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Update the control table 
 
--EITHER:
--use insert_control.py to insert into public.ust_control
--OR:

Filter by where (ut_tank."SUBSTANCED" = 'Heating Oil' and  ut_facility."FACILITYDE" = 'Petroleum Distributor') and ut_tank."TANKSTATUS" not in ('Install in Process') and ut_tank."FEDERALREG" =Yes and ut_facility."TANK" = 1 AND ut_facility."OPENREGAST" = 0 AND ut_facility."REGAST" = 0.  For the facility layer data, used ArcGIS Pro to pull in the facility layer and ran the convert coordinate notation on the lat/longs, then exported as a CSV for integration into the database.

--the script above returned a new ust_control_id of 11 for this dataset:
select * from public.ust_control where ust_control_id = 19;


Filter by where (ut_tank."SUBSTANCED" = 'Heating Oil' or ut_facility."FACILITYDE" = 'Petroleum Distributor') and ut_tank."TANKSTATUS" not in ('Install in Process') and ut_tank."FEDERALREG" =Yes and ut_facility."TANK" = 1 AND ut_facility."OPENREGAST" = 0 AND ut_facility."REGAST" = 0.  For the facility layer data, used ArcGIS Pro to pull in the facility layer and ran the convert coordinate notation on the lat/longs, then exported as a CSV for integration into the database.

select  * from ut_tank  a where "SUBSTANCED" = 'Heating Oil'
and facility_id in (select facility_id from ut_facility b 
where "FACILITYDE" = 'Petroleum Distributor'  and b."FACILITYDE" = 'Petroleum Distributor'
				         );


 WHERE y."TANK" = 1 AND y."OPENREGAST" = 0 and y."FACILITYDE" = 'Petroleum Distributor'
				          AND y."REGAST" = 0));


 WHERE y."TANK" = 1 AND y."OPENREGAST" = 0 and y."FACILITYDE" = 'Petroleum Distributor'
				          AND y."REGAST" = 0));
				         
18601

SELECT DISTINCT x.facility_id::character varying(50) AS facility_id,
    x.tank_id::integer AS tank_id,
    vtsx.tank_status_id,
    x."FEDERALREG"::character varying(7) AS federally_regulated,
    x."TANKEMERGE"::character varying(7) AS emergency_generator,
    x."DATECLOSE"::date AS tank_closure_date,
    x."DATEINSTAL"::date AS tank_installation_date,
    vtmdx.tank_material_description_id,
        CASE x."TANKMATDES"
            WHEN 'Impressed Current Cathodic Protection'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_impressed_current,
        CASE x."TANKMODSDE"
            WHEN 'Lined Interior'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_interior_lining,
    s.tank_secondary_containment_id,
        CASE
            WHEN vtmdx.tank_material_description_id = ANY (ARRAY[4, 5, 6]) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_sacrificial_anode,
    x."TANKMODSDE"
   FROM ut_ust.ut_tank x
     LEFT JOIN ut_ust.v_tank_status_xwalk vtsx ON vtsx.organization_value::text = TRIM(BOTH FROM (x."TANKSTATUS" || ' '::text) || COALESCE(x."CLOSURESTA", ''::text))
     LEFT JOIN ut_ust.v_tank_material_description_xwalk vtmdx ON vtmdx.organization_value::text = x."TANKMATDES"
     LEFT JOIN ut_ust.v_tank_secondary_containment_xwalk s ON s.organization_value::text = x."TANKMODSDE"
     LEFT JOIN ut_ust.erg_substance esm ON esm.facility_id = x.facility_id AND esm.tank_id = x.tank_id
  WHERE x."FEDERALREG" = 'Yes'::text
  and (x."SUBSTANCED" <> 'Heating Oil' or x."SUBSTANCED" is null)
  AND x."TANKSTATUS" <> 'Install in Process'::text 
  AND (x.facility_id IN ( SELECT y.facility_id
				           FROM ut_ust.ut_facility y
				          WHERE y."TANK" = 1 AND y."OPENREGAST" = 0
				          AND y."REGAST" = 0))
				          
union 

SELECT DISTINCT x.facility_id::character varying(50) AS facility_id,
    x.tank_id::integer AS tank_id,
    vtsx.tank_status_id,
    x."FEDERALREG"::character varying(7) AS federally_regulated,
    x."TANKEMERGE"::character varying(7) AS emergency_generator,
    x."DATECLOSE"::date AS tank_closure_date,
    x."DATEINSTAL"::date AS tank_installation_date,
    vtmdx.tank_material_description_id,
        CASE x."TANKMATDES"
            WHEN 'Impressed Current Cathodic Protection'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_impressed_current,
        CASE x."TANKMODSDE"
            WHEN 'Lined Interior'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_interior_lining,
    s.tank_secondary_containment_id,
        CASE
            WHEN vtmdx.tank_material_description_id = ANY (ARRAY[4, 5, 6]) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_sacrificial_anode,
    x."TANKMODSDE"
   FROM ut_ust.ut_tank x
     LEFT JOIN ut_ust.v_tank_status_xwalk vtsx ON vtsx.organization_value::text = TRIM(BOTH FROM (x."TANKSTATUS" || ' '::text) || COALESCE(x."CLOSURESTA", ''::text))
     LEFT JOIN ut_ust.v_tank_material_description_xwalk vtmdx ON vtmdx.organization_value::text = x."TANKMATDES"
     LEFT JOIN ut_ust.v_tank_secondary_containment_xwalk s ON s.organization_value::text = x."TANKMODSDE"
     LEFT JOIN ut_ust.erg_substance esm ON esm.facility_id = x.facility_id AND esm.tank_id = x.tank_id
  WHERE x."FEDERALREG" = 'Yes'::text
  and x."SUBSTANCED" = 'Heating Oil'
  AND x."TANKSTATUS" <> 'Install in Process'::text 
  AND (x.facility_id IN ( SELECT y.facility_id
				           FROM ut_ust.ut_facility y
				          WHERE y."TANK" = 1 AND y."OPENREGAST" = 0 and y."FACILITYDE" = 'Petroleum Distributor'
				          AND y."REGAST" = 0));

Downloaded layers for https://opendata.gis.utah.gov/datasets/utah::utah-petroleum-storage-tanks/about (CSV) and https://opendata.gis.utah.gov/datasets/utah-petroleum-storage-tank-facilities/about (added as a new layer in ArcGIS Pro).

Filter by  ut_facility."TANK" = 1 AND ut_facility."OPENREGAST" = 0 AND ut_facility."REGAST" = 0.  For the facility layer data, used ArcGIS Pro to pull in the facility layer and ran the convert coordinate notation on the lat/longs, then exported as a CSV for integration into the database.

update  public.ust_control 
set comments = 'Filter by ut_tank."FEDERALREG" =Yes and ut_facility."TANK" = 1 AND ut_facility."OPENREGAST" = 0 AND ut_facility."REGAST" = 0.  For the facility layer data, used ArcGIS Pro to pull in the facility layer and ran the convert coordinate notation on the lat/longs, then exported as a CSV for integration into the database.'
where  ust_control_id = 19;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------


select * from ut_tank where "SUBSTANCED"='Gas/Diesel'

select * from ut_tank_ust where facility_id = '9392';

31

select  * from ut_tank  a where "SUBSTANCED" = 'Heating Oil'
and facility_id in (select facility_id from ut_facility b 
where "FACILITYDE" = 'Petroleum Distributor');

select * from ut_facility where facility_id='770'; 

select * from erg_substance_mapping;

drop table erg_substance_mapping

create table erg_substance_mapping as
select distinct facility_id, tank_id,  case when ("SUBSTANCED" = 'Gas/Diesel' and "SUBSTANCET" = 'Diesel #2 (U.L.S.)') then 'Diesel fuel (b-unknown)' else "SUBSTANCED" end "SUBSTANCED"
from ut_tank;

insert into ut_ust.erg_substance

select distinct facility_id, tank_id, "SUBSTANCED", "SUBSTANCET", 
          case when "SUBSTANCET" in ('Diesel #2 (U.L.S.)','Off-road Diesel') then "SUBSTANCET"
                when "SUBSTANCED" = 'Gas/Diesel' and "SUBSTANCET" is not null then "SUBSTANCET"
                when "SUBSTANCED" = 'Gas/Diesel' and "SUBSTANCET" is null then 'Petroleum product'
                when "SUBSTANCED" is null and "SUBSTANCET" is not null then "SUBSTANCET" 
                when "SUBSTANCET" is null and "SUBSTANCED" is not null then "SUBSTANCED" 
                when "SUBSTANCED" is not null and "SUBSTANCET" is not null then "SUBSTANCED" || ' ' || "SUBSTANCET"
          else null end as substance

from ut_ust.ut_tank



CREATE OR REPLACE VIEW ut_ust.ut_tank_ust
AS SELECT ut_tank."ï»¿OBJECTID",
    ut_tank.facility_id,
    ut_tank.tank_id,
    ut_tank."ALTTANKID",
    ut_tank."FEDERALREG",
    ut_tank."ABOVETANK",
    ut_tank."REGAST",
    ut_tank."TANKEMERGE",
    ut_tank."TANKSTATUS",
    ut_tank."TANKCAPACI",
    esm."SUBSTANCED",
    ut_tank."SUBSTANCET",
    ut_tank."TANKMATDES",
    ut_tank."TANKMODSDE",
    ut_tank."PIPEMATDES",
    ut_tank."PIPEMODDES",
    ut_tank."DATEINSTAL",
    ut_tank."DATECLOSE",
    ut_tank."CLOSURESTA",
    ut_tank."INCOMPLIAN",
    ut_tank."PST_FUND",
    ut_tank."OTHERTYPE",
    ut_tank."FORKLIFT_HASH"
   FROM ut_ust.ut_tank ut_tank
   left join ut_ust.erg_substance_mapping esm on esm.facility_id = ut_tank.facility_id and esm.tank_id=ut_tank.tank_id
  WHERE (ut_tank.facility_id IN ( SELECT ut_facility_ust.facility_id
           FROM ut_ust.ut_facility_ust));

          
          select distinct "TANKSTATUS"
          from ut_ust.ut_tank order by 1;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Upload the state data 
/* 
EITHER:
script import_data_file_files.py will create the correct schema (if it doesn't yet exist), 
then upload all .xlsx, .xls, .csv, and .txt in the specified directory to this schema. 
To run, set these variables:

organization_id = 'UT' 
# Enter a directory (not a path to a specific file) for ust_path and ust_path
# Set to None if not applicable
ust_path = 'C:\Users\JChilton\repo\UST\ust\sql\states\SD\UST' 
overwrite_table = False 


load the rease data too to populate a field fields in UST from it
release_path = r'C:\Users\JChilton\OneDrive - Eastern Research Group\Desktop\UST\MD\Release\CASES 04-03-24\CASES 04-03-24'

OR:
manually in the database, create schema ut_ust if it does not exist, then manually upload the state data
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------


alter table "TankPST_-34420683542140719" rename to ut_tank;
alter table "fac" rename to ut_facility;

ALTER TABLE ut_facility
  RENAME COLUMN "FacilityID" TO facility_id;

ALTER TABLE ut_tank
  RENAME COLUMN "FACILITYID" TO facility_id;

 ALTER TABLE ut_tank
  RENAME COLUMN "TANKID" TO tank_id;

 
select count(distinct facility_id) from ut_facility_ust; --6088
select  distinct facility_id , tank_id from ut_tank_ust ; --18653


select * from ut_facility_ust;


select distinct "TANKMATDES" from ut_ust.ut_tank_ust  order by 1;
select distinct "TANKMATDES","TANKMODSDE" from ut_ust.ut_tank_ust  order by 1;
Cathodic Protection
Double-Walled
Excavation Liner

Secondary Containment


Asphalt Coated or Bare Steel
Cathodically Prot. Steel
Composite (Steel w/ FRP)
Concrete
Epoxy Coated Steel (STIP2)
Fiberglass Reinforced Plastic
Galvanic Cathodic Protection (STIP3)
Impressed Current Cathodic Protection
Not Listed
Other
Polyethylene Tank Jacket
Unknown
select * from public.tank_secondary_containments tsc ;

update ut_tank_ust 
set "SUBSTANCED" = 'Unknown'
where "SUBSTANCED" is null  and "SUBSTANCET" is null;



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
where table_schema = 'ut_ust' order by table_name, ordinal_position;
*/
--delete from ust_element_mapping where ust_control_id = 19 and epa_column_name in ('tank_id','compartment_id','piping_id');

select * from ust_element_mapping where ust_control_id = 19    order by epa_Table_name,epa_column_name;
delete from erg_substance;

select * from erg_substance where substance='Gas/Diesel';
Gas/Diesel	Diesel #2 (U.L.S.)	Gas/Diesel Diesel #2 (U.L.S.)

insert into erg_substance
select distinct facility_id, tank_id, "SUBSTANCED", "SUBSTANCET", 
	case when "SUBSTANCED" is null and "SUBSTANCET" is not null then "SUBSTANCET" 
	     when "SUBSTANCET" is null and "SUBSTANCED" is not null then "SUBSTANCED" 
	     when "SUBSTANCED" is not null and "SUBSTANCET" is not null then "SUBSTANCED" || ' ' || "SUBSTANCET"
	     else null end as substance
from ut_ust.ut_tank x
  where  x."FEDERALREG" = 'Yes'::text AND x."TANKSTATUS" <> 'Install in Process'::text AND (x.facility_id IN ( SELECT y.facility_id
           FROM ut_ust.ut_facility y
          WHERE y."TANK" = 1 AND y."OPENREGAST" = 0 AND y."REGAST" = 0));
         ;
19815

select tank_corrosion_protection_other  from public.ust_tank;


select count(*) from erg_substance 18638
select * from erg_substance where substance='Gas/Diesel';


select * from ust_element_mapping where ust_element_mapping_id =2607;

select distinct "PIPEMODDES" from ut_tank order by 1;

select * from erg_piping_cp_fields

update ust_element_mapping set query_logic='
create table erg_piping_cp_other_fields as
select  distinct facility_id,tank_id,"ALTTANKID",
''Yes'' piping_corrosion_protection_other,
"PIPEMATDES",
"PIPEMODDES"
from ut_tank
where "PIPEMATDES" = ''Other (CP met)'' or "PIPEMODDES" = ''Cathodically Protected'';
'
where ust_element_mapping_id =2607;




select distinct "PIPEMATDES" from ut_ust.ut_tank order by 1 ;

select * from  erg_piping_cp_sacrificial_anode;;
select facility_id, tank_id, "ALTTANKID" from ut_tank group by facility_id, tank_id, "ALTTANKID" having count(*) > 1;

WHEN c."PIPEMATDES" = ANY (ARRAY[Not Listed::text, Other::text]) THEN Yes::text
            ELSE NULL::text
select   "ALTTANKID" from ut_tank;

WHEN c."PIPEMATDES" ~~ Other%::text THEN Yes::text
            ELSE NULL::text
select * from ust_element_mapping where epa_column_name

select * from ut_tank_ust group by facility_id,tank_id having count(*) > 1;

select distinct "TANKMATDES" from ut_tank order by 1;

select * from ust_element_mapping where ust_control_id= 19 order by epa_table_name,epa_column_name ;

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic,inferred_value_comment) values (19,'ust_tank','tank_corrosion_protection_other','ut_tank','TANKMATDES',null,'where TANKMATDES = Epoxy Coated Steel (STIP2)','Inferred from tank material');

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_tank','tank_id','ust_tank','tank_id',null);

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_facility','facility_id','ut_facility_ust','facility_id',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_facility','facility_name','ut_facility_ust','LOCNAME',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_facility','facility_type1','ut_facility_ust','FACILITYDE',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_facility','facility_address1','ut_facility_ust','LOCSTR',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_facility','facility_city','ut_facility_ust','LOCCITY',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_facility','facility_county','ut_facility_ust','LOCCOUNTY',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_facility','facility_zip_code','ut_facility_ust','LOCZIP',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_facility','facility_latitude','ut_facility_ust','DDLat',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_facility','facility_longitude','ut_facility_ust','DDLon',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_facility','coordinate_source_id','ut_facility_ust','UTMDESC',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_facility','facility_owner_company_name','ut_facility_ust','OWNERNAME',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_facility','ust_reported_release','ut_facility_ust','RELEASE','where RELEASE > 0');

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_tank','facility_id','ut_tank_ust','facility_id',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_tank','tank_name','ut_tank_ust','tank_id',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_tank','tank_status_id','ut_tank_ust','TANKSTATUS||'' ''||CLOSURESTA','Concat these two fields together to get more detailed information.');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_tank','federally_regulated','ut_tank_ust','FEDERALREG',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_tank','emergency_generator','ut_tank_ust','TANKEMERGE',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_tank','multiple_tanks','ut_tank_ust','tank_id','count distinct tank_id grouped by facility_id');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_tank','tank_closure_date','ut_tank_ust','DATECLOSE',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_tank','tank_installation_date','ut_tank_ust','DATEINSTAL',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_tank','tank_material_description_id','ut_tank_ust','TANKMATDES',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_tank','tank_corrosion_protection_interior_lining','ut_tank_ust','TANKMODSDE','where TANKMODSDE = Lined Interior');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_tank','tank_corrosion_protection_impressed_current','ut_tank_ust','TANKMATDES','where TANKMODSDE = Impressed Current Cathodic Protection');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_tank','tank_secondary_containment_id','ut_tank_ust','TANKMODSDE',null);


insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_tank_substance','facility_id','ut_tank_ust','facility_id',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_tank_substance','tank_id','ut_tank_ust','tank_id',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_tank_substance','substance_id','ut_tank_ust','SUBSTANCED||'' ''||SUBSTANCET','Concat these two fields together to get more detailed information. If both fields are null then populate Unknown value.');

select * from ust_element_mapping where epa_column_name = 'compartment_id' and ust_control_id=19;

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_compartment','facility_id','ut_tank_ust','facility_id',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_compartment','tank_id','ut_tank_ust','tank_id',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_compartment','compartment_id','ut_tank_ust','tank_id','Reusing tank_id here because it is a 1-1 unique relationship');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_compartment','compartment_status_id','ut_tank_ust','TANKSTATUS||'' ''||CLOSURESTA','Concat these two fields together to get more detailed information.');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_compartment','compartment_capacity_gallons','ut_tank_ust','TANKCAPACI',null);

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (19,'ust_compartment','compartment_name','ut_tank','ALTTANKID',null,null);

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_compartment','tank_id','ust_tank','tank_id',null);



insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_piping','facility_id','ut_tank_ust','facility_id',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_piping','tank_id','ut_tank_ust','tank_id',null);
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_piping','piping_id','erg_piping','piping_id','This required field is not present in the source data. Table erg_piping was created by ERG so the data can conform to the EPA template structure.');

insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_piping','piping_material_frp','ut_tank_ust','PIPEMATDES','where PIPEMATDES = Fiberglass Reinforced Plastic');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_piping','piping_material_gal_steel','ut_tank_ust','PIPEMATDES','where PIPEMATDES = Galvanized Steel');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_piping','piping_material_steel','ut_tank_ust','PIPEMATDES',' where PIPEMATDES = Bare Steel');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_piping','piping_material_copper','ut_tank_ust','PIPEMATDES','where PIPEMATDES = Copper');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_piping','piping_material_flex','ut_tank_ust','PIPEMATDES','where PIPEMATDES = Flexible Plastic');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_piping','piping_material_no_piping','ut_tank_ust','PIPEMATDES','where PIPEMATDES = No Piping');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_piping','piping_material_other','ut_tank_ust','PIPEMATDES','where PIPEMATDES like Other%');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_piping','piping_material_unknown','ut_tank_ust','PIPEMATDES','Please verify - where PIPEMATDES in (Not Listed, Unknown)' );
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) values (19,'ust_piping','pipe_secondary_containment_other','ut_tank_ust','PIPEMODDES','Please verify - where PIPEMODDES = (Secondary Containment)');


insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, query_logic,epa_comments) values (19,'ust_piping','piping_wall_type_id','ut_tank','PIPEMODDES','where PIPEMODDES = Double Wall','Where pipemoddes is double wall then pipe wall type is double wall');


select * from ust_element_mapping where ust_control_id = 19 order by epa_table_name;

update ust_element_mapping
set query_logic = 'select distinct facility_id, tank_id, "SUBSTANCED", "SUBSTANCET", 
	case when "SUBSTANCED" is null and "SUBSTANCET" is not null then "SUBSTANCET" 
	     when "SUBSTANCET" is null and "SUBSTANCED" is not null then "SUBSTANCED" 
	     when "SUBSTANCED" is not null and "SUBSTANCET" is not null then "SUBSTANCED" || '' '' || "SUBSTANCET"
	     else null end as substance
from ut_ust.ut_tank x
where  x."FEDERALREG" = ''Yes''::text AND (x.facility_id IN ( SELECT y.facility_id
           FROM ut_ust.ut_facility y
          WHERE y."TANK" = 1 AND y."OPENREGAST" = 0 AND y."REGAST" = 0)); '
where ust_element_mapping_id = '1324';


 
select distinct "PIPEMODDES"  from ut_tank order by 1;
select * from ust_element_mapping where ust_control_id = 19 order by epa_table_name;

insert into public.ust_element_mapping
	 (ust_control_id, epa_table_name, epa_column_name, 
	 organization_table_name, organization_column_name, 
	 query_logic, inferred_value_comment,epa_comments)
values(19, 'ust_piping', 'piping_corrosion_protection_sacrificial_anode', 'ut_tank', 'PIPEMATDES, PIPEMODES', 
	 'when ("PIPEMATDES" = ''Other (CP met)'' or "PIPEMODES" = ''Cathodically Protected'') then ''Yes'' else null', 'Inferred from ut_tank.PIPEMATDES and ut_tank.PIPEMODES','NOTE:  Piping material description also has Corrosion Protection data that needs to be mapped to the Piping CP fields.  Where Pipemoddes is cathodically protected then PipingCorrosionProtectionSacrificialAnode = Yes. PIPEMATDES Other (CP Met) to be mapped to Piping CP Other.  ')
on conflict (ust_control_id, epa_table_name, epa_column_name) 
do update set organization_table_name = excluded.organization_table_name,
              organization_column_name = excluded.organization_column_name,
              query_logic = excluded.query_logic,
              inferred_value_comment = excluded.inferred_value_comment;


update  ust_element_mapping set programmer_comments  = null where ust_control_id=19 and programmer_comments='Please verify - where PIPEMODDES = (Secondary Containment)';


update ust_element_mapping set programmer_comments='Please verify.  This data is provided at the tank instead of facility level. The same facility can have yes and no values for this field. ERG decided to set the value to Yes for the Facility if any tank data had a Yes value, otherwise No is selected.'
where ust_control_id=19 and upper(organization_column_name) like '%PST_FUND%';



insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic,epa_comments) values (19,'ust_facility','financial_responsibility_state_fund','ut_tank_ust','PST_FUND',null,null,'UT is a state fund state so Y in this field = FR State Fund');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (19,'ust_facility','financial_responsibility_guarantee','ut_tank_ust','OTHERTYPE',null,'where OTHERTYPE = Guarantee');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (19,'ust_facility','financial_responsibility_commercial_insurance','ut_tank_ust','OTHERTYPE',null,'where OTHERTYPE = Insurance');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (19,'ust_facility','financial_responsibility_self_insurance_financial_test','ut_tank_ust','OTHERTYPE',null,'where OTHERTYPE like Self-insurance%');
insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) values (19,'ust_facility','financial_responsibility_other_method','ut_tank_ust','OTHERTYPE','Please confirm','where OTHERTYPE in Exempt,Not Required ');


insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic,epa_comments) values (19,'ust_piping','piping_corrosion_protection_other','ut_tank_ust','PIPEMODDES','Please confirm I did this latest mapping correctly.','where PIPEMODDES = Cathodically Protected','This field has CP data as well as secondary containment data.  For Other(CP met), map to Piping CP Other');


------------------------------------------------------------------------------------------------------------------------------------------------------------------------

select distinct "PIPEMODDES" from ut_tank_ust order by 1	;
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
	where ust_control_id = 19 and mapping_complete = 'N'
	order by table_sort_order, column_sort_order) x;
/*



*/


--piping_wall_type_id
select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 19 and epa_column_name = 'piping_wall_type_id';

select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 2823 || ', ''' || "PIPEMODDES" || ''', '''', null);'
from ut_ust."ut_tank" order by 1;

insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (2823, 'Double-Walled', 'Double walled', null);

select * from public.piping_wall_types pwt 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--substance_id
select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 19 and epa_column_name = 'substance_id';

--paste the insert_sql from the first row below, then run the query:
select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 1324 || ', ''' || "substance" || ''', '''', null);'
from ut_ust."erg_substance" order by 1;

select distinct "SUBSTANCED"
from ut_tank_ust
order by 1;


insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments,epa_comments) values (1324, 'Gas/Diesel', 'Petroleum product', 'The only record that gets through the initial filtering on the tanks table and there is no supplemental information about it so defaulting to petroleum.','Only 2 are currently in use.  One indicates in the other substance column that it is diesel but the other tank gives no additional info.  Use Diesel for the one with Diesel in Other Substance Column and Petroleum Product for other since we don’t know if it is gas or diesel. ');

select * from ust_element_value_mapping where ust_element_mapping_id = 1324;

select distinct state_value, epa_value
from archive.v_ust_element_mapping 
where lower(state_value) like lower('%used%oil%')
order by 1, 2;


select * from public.substances s  where (substance) like '%Petroleum%';

select * from ust_element_value_mapping where ust_element_mapping_id= 1324;

select * from public.substances s  where substance = 'Diesel fuel (ASTM D975), can contain 0-5% biodiesel';

insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1324, 'Diesel B5 Biodiesel', '95% renewable diesel, 5% biodiesel', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1324, 'Diesel B99 Biodiesel', '99.9 percent renewable diesel, 0.01% biodiesel', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1324, 'Diesel Bio-Diesel', 'Diesel fuel (b-unknown)', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1324, 'Diesel Diesel #1', 'Diesel fuel (b-unknown)', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1324, 'Diesel Diesel #2 (L.S.)', 'Diesel fuel (b-unknown)', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1324, 'Diesel Diesel #2 (U.L.S.)', 'Diesel fuel (b-unknown)', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1324, 'Diesel Off-road Diesel', 'Off-road diesel/dyed diesel', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1324, 'Diesel Regular', 'Diesel fuel (b-unknown)', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1324, 'Gasohol E85 (85% ethonal, 15% gasoline)', 'E-85/Flex Fuel (E51-E83)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1324, 'Gasoline Diesel #2 (U.L.S.)', 'Diesel fuel (b-unknown)', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1324, 'Gasoline E10 (10% Ethanol, 90 % Gas)', 'Gasoline E-10 (E1-E10)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1324, 'Gasoline E15 (15% Ethanol, 85% Gas)', 'Gasoline E-15 (E-11-E15)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1324, 'Gasoline E85 (85% ethonal, 15% gasoline)', 'E-85/Flex Fuel (E51-E83)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1324, 'Gasoline High Octane (Racing)', 'E-85/Flex Fuel (E51-E83)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1324, 'Gasoline Midgrade', 'Gasoline (unknown type)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1324, 'Gasoline Non-Ethanol', 'Gasoline (non-ethanol)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1324, 'Gasoline Premium', 'Gasoline (unknown type)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1324, 'Gasoline Regular', 'Gasoline (unknown type)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1324, 'Unknown ', 'Unknown', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1324, 'Av Gas ', 'Aviation gasoline', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1324, 'DEF - Diesel Exhaust Fluid ', 'Diesel exhaust fluid (DEF, not federally regulated)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1324, 'Diesel ', 'Diesel fuel (b-unknown)', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1324, 'Fuel Additive ', 'Gasoline (unknown type)', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1324, 'Gas/Diesel ', 'Diesel fuel (b-unknown)', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1324, 'Gasohol ', 'Ethanol blend gasoline (e-unknown)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1324, 'Gasoline ', 'Gasoline (unknown type)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1324, 'Hazardous Substance ', 'Hazardous substance', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1324, 'Heating Oil ', 'Heating/fuel oil # unknown', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1324, 'Jet Fuel ', 'Unknown aviation gas or jet fuel', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1324, 'Kerosene ', 'Kerosene', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1324, 'Mixture ', 'Other or mixture', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1324, 'New Oil ', 'Lube/motor oil (new)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1324, 'Not Listed ', 'Unknown', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1324, 'Other ', 'Other or mixture', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1324, 'Used Oil ', 'Used oil/waste oil', null);


insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1324, 'Jet Fuel ', 'Unknown aviation gas or jet fuel', null);

update ust_element_value_mapping set epa_value = 'Jet fuel A' where organization_value = 'Jet Fuel ';


select * from ust_element_value_mapping where ust_element_mapping_id = 1324;


select * from public.substances s where
--compartment_status_id
select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 19 and epa_column_name = 'compartment_status_id';


select distinct "TANKSTATUS", "CLOSURESTA" from ut_ust."ut_tank_ust";


select * from ust_element_value_mapping where ust_element_mapping_id = 1310;

insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1310, 'Currently In Use ', 'Currently in use', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1310, 'Install in Process ', 'Other', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1310, 'Permanently Out of Use ', 'Closed (general)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1310, 'Permanently Out of Use Change in service', 'Closed (general)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1310, 'Permanently Out of Use Change in Service', 'Closed (general)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1310, 'Permanently Out of Use Pre 1974 Status', 'Closed (general)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1310, 'Permanently Out of Use Tank closed in place', 'Closed (in place)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1310, 'Permanently Out of Use Tank Closed in Place', 'Closed (in place)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1310, 'Permanently Out of Use Tank removed from ground', 'Closed (removed from ground)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1310, 'Permanently Out of Use Tank Removed from Ground', 'Closed (removed from ground)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1310, 'Temporarily Out of Use ', 'Temporarily out of service', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1310, 'Temporarily Out of Use Change in service', 'Temporarily out of service', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1310, 'Temporarily Out of Use Tank closed in place', 'Temporarily out of service', null);


select * from ust_element_value_mapping where ust_element_mapping_id =1310;

--tank_secondary_containment_id
select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 19 and epa_column_name = 'tank_secondary_containment_id';

--paste the insert_sql from the first row below, then run the query:
select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 1303 || ', ''' || "TANKMODSDE" || ''', '''', null);'
from ut_ust."ut_tank_ust" order by 1;

insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1303, 'Cathodic Protection', 'Other', 'MAPPING NEEDED');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1303, 'Double-Walled', 'Double wall', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1303, 'Excavation Liner', 'Excavation liner', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1303, 'Lined Interior', 'Other', 'MAPPING NEEDED');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1303, 'Secondary Containment', 'Other', 'MAPPING NEEDED');


select * from ust_element_mapping where  ust_element_mapping_id = 1303;
select * from ust_element_value_mapping where  ust_element_mapping_id = 1303;

select * from  archive.v_ust_element_mapping  where element_name like '%SecondaryContainment%';
select distinct state_value, epa_value
from archive.v_ust_element_mapping 
where lower(state_value) like lower('%cathodic%')
order by 1, 2;


select * from public.tank_secondary_containments tsc 

--facility_type1
select distinct 'select distinct "' || organization_column_name || '" from ut_ust."' || organization_table_name || '" order by 1;'
from v_ust_needed_mapping 
where ust_control_id = 19 and epa_column_name = 'facility_type1';



select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 19 and epa_column_name = 'facility_type1';

--paste the insert_sql from the first row below, then run the query:
select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 1282 || ', ''' || "FACILITYDE" || ''', '''', null);'
from ut_ust."ut_facility_ust" order by 1;

insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1282, 'Air Taxi (Airline)', 'Aviation/airport (non-rental car)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1282, 'Aircraft Owner', 'Aviation/airport (non-rental car)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1282, 'Auto Dealership', 'Auto dealership/auto maintenance & repair', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1282, 'Commercial', 'Commercial', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1282, 'Contractor', 'Contractor', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1282, 'Farm', 'Agricultural/farm', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1282, 'Federal Military', 'Military', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1282, 'Federal Non-Military', 'Federal government, non-military', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1282, 'Former Gas Station', 'Retail fuel sales (non-marina)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1282, 'FORMER GAS STATION', 'Retail fuel sales (non-marina)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1282, 'Gas Station', 'Retail fuel sales (non-marina)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1282, 'Industrial', 'Industrial', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1282, 'Local Government', 'State/local government', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1282, 'Not Listed', 'Unknown', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1282, 'Other', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1282, 'Petroleum Distributor', 'Bulk plant storage/petroleum distributor', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1282, 'Railroad', 'Railroad', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1282, 'Residential', 'Residential', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1282, 'State Government', 'State/local government', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1282, 'Truck/Transporter', 'Trucking/transport/fleet operation', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1282, 'Utilities', 'Utility', null);


select * from ust_element_value_mapping where ust_element_mapping_id =1282 and organization_value='Not Listed';

--coordinate_source_id
select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 19 and epa_column_name = 'coordinate_source_id';

--paste the insert_sql from the first row below, then run the query:
select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 1289 || ', ''' || "UTMDESC" || ''', '''', null);'
from ut_ust."ut_facility_ust" order by 1;


insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1289, 'Digital Topographic Map', 'Map interpolation', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1289, 'Guess - Need to verify', 'Unknown', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1289, 'Hand Held GPS with Base Station Corrections', 'GPS', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1289, 'Orthoquad (DOQ) 1 meter Image', 'Other', 'Please verify');

select * from public.coordinate_sources cs 



--tank_status_id
select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 19 and epa_column_name = 'tank_status_id';


select distinct "TANKSTATUS", "CLOSURESTA" from ut_ust."ut_tank_ust";

--paste the insert_sql from the first row below, then run the query:
select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 1294 || ', ''' || "TANKSTATUS"||' '||COALESCE ("CLOSURESTA",'') || ''', '''', null);'
from ut_ust."ut_tank_ust" order by 1;


select * from ust_element_value_mapping where ust_element_mapping_id = 1294;


insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1294, 'Currently In Use ', 'Currently in use', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1294, 'Install in Process ', 'Other', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1294, 'Permanently Out of Use ', 'Closed (general)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1294, 'Permanently Out of Use Change in service', 'Closed (general)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1294, 'Permanently Out of Use Change in Service', 'Closed (general)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1294, 'Permanently Out of Use Pre 1974 Status', 'Closed (general)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1294, 'Permanently Out of Use Tank closed in place', 'Closed (in place)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1294, 'Permanently Out of Use Tank Closed in Place', 'Closed (in place)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1294, 'Permanently Out of Use Tank removed from ground', 'Closed (removed from ground)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1294, 'Permanently Out of Use Tank Removed from Ground', 'Closed (removed from ground)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1294, 'Temporarily Out of Use ', 'Temporarily out of service', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1294, 'Temporarily Out of Use Change in service', 'Temporarily out of service', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1294, 'Temporarily Out of Use Tank closed in place', 'Temporarily out of service', null);

select * from public.tank_statuses ts 


--tank_material_description_id
select insert_sql 
from v_ust_needed_mapping_insert_sql 
where ust_control_id = 19 and epa_column_name = 'tank_material_description_id';


--paste the insert_sql from the first row below, then run the query:
select distinct 
	'insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (' || 1300 || ', ''' || "TANKMATDES" || ''', '''', null);'
from ut_ust."ut_tank_ust" order by 1;

insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1300, 'Asphalt Coated or Bare Steel', 'Asphalt coated or bare steel', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1300, 'Cathodically Prot. Steel', 'Cathodically protected steel (without coating)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1300, 'Composite (Steel w/ FRP)', 'Composite/clad (steel w/fiberglass reinforced plastic)', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1300, 'Concrete', 'Concrete', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1300, 'Epoxy Coated Steel (STIP2)', 'Epoxy coated steel', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1300, 'Fiberglass Reinforced Plastic', 'Fiberglass reinforced plastic', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1300, 'Galvanic Cathodic Protection (STIP3)', 'Cathodically protected steel (without coating)', 'Please verify');
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1300, 'Impressed Current Cathodic Protection', 'Coated and cathodically protected steel', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1300, 'Not Listed', 'Unknown', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1300, 'Other', 'Other', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1300, 'Polyethylene Tank Jacket', 'Jacketed steel', null);
insert into ust_element_value_mapping (ust_element_mapping_id, organization_value, epa_value, programmer_comments) values (1300, 'Unknown', 'Unknown', null);



select * from ust_element_value_mapping where ust_element_mapping_id =1300;



select distinct state_value, epa_value
from archive.v_ust_element_mapping 
where lower(state_value) like lower('%stip3%')
order by 1, 2;

select * from public.tank_material_descriptions tmd ; 


------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--check if there is any more mapping to do
select distinct epa_table_name, epa_column_name
from v_ust_needed_mapping 
where ust_control_id = 19 and mapping_complete = 'N'
order by 1, 2;

--check if any of the mapping is bad:
select database_lookup_table, epa_value 
from v_ust_bad_mapping 
where ust_control_id = 19 order by 1, 2;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*Step 1: create crosswalk views for columns that use a lookup table
run script org_mapping_xwalks.py to create crosswalk views for all lookup tables 
see new views:*/
select table_name 
from information_schema.tables 
where table_schema = 'ut_ust' and table_type = 'VIEW'
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


-- ut_ust.v_tank_status_xwalk source

select distinct facility_id, tank_id, "TANKSTATUS", "CLOSURESTA", 
	case when "CLOSURESTA" is null and "TANKSTATUS" is not null then "TANKSTATUS" 
	     when "TANKSTATUS" is null and "CLOSURESTA" is not null then "CLOSURESTA" 
	     when "TANKSTATUS" is not null and "CLOSURESTA" is not null then "TANKSTATUS" || ' ' || "CLOSURESTA"
	     else null end as tank_status
into ut_ust.erg_tank_status
from ut_ust.ut_tank_ust

CREATE OR REPLACE VIEW ut_ust.v_tank_status_xwalk
AS SELECT a.organization_value,
    a.epa_value,
    b.tank_status_id
   FROM v_ust_element_mapping a
     LEFT JOIN tank_statuses b ON a.epa_value::text = b.tank_status::text
  WHERE a.ust_control_id = 19 AND a.epa_column_name::text = 'tank_status_id'::text;
 

--Step 2: see the EPA tables we need to populate, and in what order
select distinct epa_table_name, table_sort_order
from v_ust_table_population 
where ust_control_id = 19
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
select comments from ust_control where ust_control_id = 19;
--Filter by  ut_facility."TANK" = 1 AND ut_facility."OPENREGAST" = 0 AND ut_facility."REGAST" = 0. 

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
	deagg_table_name, deagg_column_name , query_logic
from v_ust_table_population_sql
where ust_control_id = 19 and epa_table_name = 'ust_facility'
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
drop view ut_ust.v_ust_facility;

-- ut_ust.v_ust_facility source


  create index ut_idx on   ut_ust.ut_tank ( "PST_FUND");
   create index ut_idx2 on   ut_ust.ut_tank ( facility_id);
  --6088  
-- ut_ust.v_ust_facility source

CREATE OR REPLACE VIEW ut_ust.v_ust_facility
AS SELECT DISTINCT x.facility_id::character varying(50) AS facility_id,
    x."LOCNAME"::character varying(100) AS facility_name,
    a.facility_type_id AS facility_type1,
    x."LOCSTR"::character varying(100) AS facility_address1,
    x."LOCCITY"::character varying(100) AS facility_city,
    x."LOCCOUNTY"::character varying(100) AS facility_county,
    x."LOCZIP"::character varying(10) AS facility_zip_code,
    x."DDLat" AS facility_latitude,
    x."DDLon" AS facility_longitude,
    b.coordinate_source_id,
    x."OWNERNAME"::character varying(100) AS facility_owner_company_name,
    max(c."PST_FUND") AS financial_responsibility_state_fund,
    max(
        CASE
            WHEN c."OTHERTYPE" = 'Insurance'::text THEN 'Yes'::text
            ELSE NULL::text
        END) AS financial_responsibility_commercial_insurance,
    max(
        CASE
            WHEN c."OTHERTYPE" ~~ 'Self-insurance%'::text THEN 'Yes'::text
            ELSE NULL::text
        END) AS financial_responsibility_self_insurance_financial_test,
    max(
        CASE
            WHEN c."OTHERTYPE" = 'Guarantee'::text THEN 'Yes'::text
            ELSE NULL::text
        END) AS financial_responsibility_guarantee,
    max(
        CASE
            WHEN (c."OTHERTYPE" <> ALL (ARRAY['Exempt'::text, 'Not Required'::text])) AND c."OTHERTYPE" IS NOT NULL THEN 'Yes'::text
            WHEN c."OTHERTYPE" = 'Exempt'::text OR c."OTHERTYPE" = 'Not Required'::text THEN 'N/A'::text
            ELSE NULL::text
        END) AS financial_responsibility_obtained,
        CASE
            WHEN x."RELEASE" <> '0'::bigint THEN 'Yes'::text
            ELSE NULL::text
        END AS ust_reported_release,
    'UT'::text AS facility_state,
    8 AS facility_epa_region
   FROM ut_ust.ut_facility x
     LEFT JOIN ut_ust.v_facility_type_xwalk a ON a.organization_value::text = x."FACILITYDE"
     LEFT JOIN ut_ust.v_coordinate_source_xwalk b ON b.organization_value::text = x."UTMDESC"
     JOIN ut_ust.ut_tank c ON c.facility_id = x.facility_id AND (c."OTHERTYPE" IS NOT NULL OR c."PST_FUND" IS NOT NULL)
  WHERE x."TANK" = 1 AND x."OPENREGAST" = 0 AND x."REGAST" = 0
  GROUP BY x.facility_id, x."LOCNAME", a.facility_type_id, x."LOCSTR", x."LOCCITY", x."LOCCOUNTY", x."LOCZIP", x."DDLat", x."DDLon", b.coordinate_source_id, x."OWNERNAME", x."RELEASE";
 
 
    select *  from ut_tank a 
   join ut_tank b on a.facility_id=b.facility_id 
  where a."PST_FUND" = 'Yes' and b."PST_FUND" = 'No';
    
select ut_ust.pst_fund(1) val,"PST_FUND" from ut_tank where  facility_id=1;

select facility_id, "OTHERTYPE"  from ut_tank where "OTHERTYPE" is not null;


--review: 
select * from ut_ust.v_ust_facility;
select count(*) from ut_ust.v_ust_facility;
--6088
--------------------------------------------------------------------------------------------------------------------------
--now repeat for each data table:

--ust_tank 
select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, data_type, character_maximum_length,
	programmer_comments, database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 19 and epa_table_name = 'ust_tank'
order by column_sort_order;

/*be sure to do select distinct if necessary!
NOTE: ADD facility_id::character varying(50)!!!!
NOTE: tank_id (integer) is a required field - if the state data does not contain an integer field
      that uniquely identifies the tank, you must generate one (see Compartments below for how to do this).
*/


drop view ut_ust.v_ust_tank;


select distinct "FEDERALREG" from ut_tank_ust where "FEDERALREG" ='Yes';


-- ut_ust.v_ust_tank source

-- ut_ust.v_ust_tank source



insert into ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic,inferred_value_comment) values (19,'ust_tank','tank_corrosion_protection_other','ut_tank','TANKMATDES',null,'where TANKMATDES = Epoxy Coated Steel (STIP2)','Inferred from tank material');


-- ut_ust.v_ust_tank source

CREATE OR REPLACE VIEW ut_ust.v_ust_tank
AS SELECT DISTINCT x.facility_id::character varying(50) AS facility_id,
    x.tank_id::integer AS tank_id,
    vtsx.tank_status_id,
    x."FEDERALREG"::character varying(7) AS federally_regulated,
    x."TANKEMERGE"::character varying(7) AS emergency_generator,
    x."DATECLOSE"::date AS tank_closure_date,
    x."DATEINSTAL"::date AS tank_installation_date,
    vtmdx.tank_material_description_id,
        CASE x."TANKMATDES"
            WHEN 'Impressed Current Cathodic Protection'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_impressed_current,
        CASE x."TANKMODSDE"
            WHEN 'Lined Interior'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_interior_lining,
    s.tank_secondary_containment_id,
        CASE
            WHEN vtmdx.tank_material_description_id = ANY (ARRAY[5, 6]) THEN 'Yes'::text
            ELSE NULL::text
        END AS tank_corrosion_protection_sacrificial_anode,
        case x."TANKMATDES" when 'Epoxy Coated Steel (STIP2)' then 'Yes' else null end as tank_corrosion_protection_other
   FROM ut_ust.ut_tank x
     LEFT JOIN ut_ust.v_tank_status_xwalk vtsx ON vtsx.organization_value::text = TRIM(BOTH FROM (x."TANKSTATUS" || ' '::text) || COALESCE(x."CLOSURESTA", ''::text))
     LEFT JOIN ut_ust.v_tank_material_description_xwalk vtmdx ON vtmdx.organization_value::text = x."TANKMATDES"
     LEFT JOIN ut_ust.v_tank_secondary_containment_xwalk s ON s.organization_value::text = x."TANKMODSDE"
     LEFT JOIN ut_ust.erg_substance esm ON esm.facility_id = x.facility_id AND esm.tank_id = x.tank_id
  WHERE x."FEDERALREG" = 'Yes'::text AND x."TANKSTATUS" <> 'Install in Process'::text AND (x.facility_id IN ( SELECT y.facility_id
           FROM ut_ust.ut_facility y
          WHERE y."TANK" = 1 AND y."OPENREGAST" = 0 AND y."REGAST" = 0));
         
         
         select count(*)
   FROM ut_ust.ut_tank c
     JOIN ut_ust.erg_piping t ON c.facility_id::integer = t.facility_id AND c.tank_id = t.tank_id
  WHERE c."FEDERALREG" = 'Yes'::text AND (c.facility_id IN ( SELECT y.facility_id
           FROM ut_ust.ut_facility y
          WHERE y."TANK" = 1 AND y."OPENREGAST" = 0 AND y."REGAST" = 0))
         and ("TANKMATDES"= 'Impressed Current Cathodic Protection') ;

        
        select distinct "TANKMATDES" from ut_ust.ut_tank

select count(*) from ut_ust.v_ust_tank where tank_corrosion_protection_impressed_current  is not null;


         select * from v_tank_material_description_xwalk order by 3;
       
select distinct "TANKMATDES" from ut_ust.ut_tank order by 1;



  SELECT DISTINCT x.facility_id::character varying(50) AS facility_id,
    x.tank_id::integer AS tank_id,
    vtsx.tank_status_id
   FROM ut_ust.ut_tank_ust x
     LEFT JOIN ut_ust.v_tank_status_xwalk vtsx ON vtsx.organization_value::text = trim(((x."TANKSTATUS" || ' '::text) || COALESCE(x."CLOSURESTA", ''::text)))
    WHERE x."FEDERALREG" = 'Yes'::text and x.facility_id=10 and x.tank_id=3;

select * from v_ust_tank where facility_id='10';

select ((x."TANKSTATUS" || ' '::text) || COALESCE(x."CLOSURESTA", ''::text)) from ut_tank_ust x where facility_id=10 and tank_id=3;

select * from v_tank_status_xwalk where organization_value = 'Permanently Out of Use';


select facility_id,tank_id from v_ust_tank group by facility_id,tank_id  having count(*) > 1; 
18601

--------------------------------------------------------------------------------------------------------------------------
--ust_tank_substance

select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, data_type, character_maximum_length,
	programmer_comments, database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 19 and epa_table_name = 'ust_tank_substance'
order by column_sort_order;


/*be sure to do select distinct if necessary!
NOTE: ADD facility_id::character varying(50) and tank_id::int!!!!
*/

Number of null rows for required column ust_tank_substance.substance_id


CREATE OR REPLACE VIEW ut_ust.v_ust_tank_substance
AS SELECT DISTINCT x.facility_id::character varying(50) AS facility_id,
    x.tank_id,
    sx.substance_id
   FROM ut_ust.erg_substance x
     LEFT JOIN ut_ust.v_substance_xwalk sx ON x.substance=sx.organization_value
    where sx.substance_id is not null;
   
   
         
    select * from ut_ust.erg_substance group by substance having count(*) > 1;
   
   select organization_value from v_substance_xwalk group by organization_value having count;
   
   select * from ut_ust.v_substance_xwalk;

select count(*) from v_ust_tank_substance where substance_id is null;

select * from v_substance_xwalk

select * from v_substance_xwalk where organization_value ='Gas/Diesel';
select * from v_ust_tank_substance where substance_id=44;

select count(*) from ut_ust.v_ust_tank_substance;
--18638
select * from v_ust_tank_substance;

--------------------------------------------------------------------------------------------------------------------------
--ust_compartment
select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, data_type, character_maximum_length,
	programmer_comments, database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 19 and epa_table_name = 'ust_compartment'
order by column_sort_order;

/* be sure to do select distinct if necessary!
NOTE: ADD facility_id::character varying(50) and tank_id::int!!!!
NOTE: compartment_id (integer) is a required field - if the state data does not contain an integer field
      that uniquely identifies the compartment, you must generate one. 
      In this case, the state does not store compartment data, so we will generate the compartment ID
      Prefix any tables you create in the state schema that did not come from the source data with "erg_"! */
delete from ut_ust.erg_compartment

drop table ut_ust.erg_compartment;

select count(*) from erg_compartment
create table ut_ust.erg_compartment (facility_id int,  tank_id int, compartment_id int generated always as identity);

insert into ut_ust.erg_compartment (facility_id,tank_id)
select  facility_id, tank_id  
from ut_ust.ut_tank  x  
     WHERE x."FEDERALREG" = 'Yes'::text AND (x.facility_id IN ( SELECT y.facility_id
           FROM ut_ust.ut_facility y
          WHERE y."TANK" = 1 AND y."OPENREGAST" = 0 AND y."REGAST" = 0));
         
         
-- ut_ust.v_ust_compartment source

-- ut_ust.v_ust_compartment source

CREATE OR REPLACE VIEW ut_ust.v_ust_compartment
AS SELECT DISTINCT y.facility_id::character varying(50) AS facility_id,
    x.tank_id::integer AS tank_id,
    y.compartment_id,
    vtsx.compartment_status_id,
    x."TANKCAPACI"::integer AS compartment_capacity_gallons
   FROM ut_ust.ut_tank x
     JOIN ut_ust.erg_compartment y ON y.facility_id = x.facility_id::integer AND y.tank_id = x.tank_id
     LEFT JOIN ut_ust.v_compartment_status_xwalk vtsx ON vtsx.organization_value::text = TRIM(BOTH FROM (x."TANKSTATUS" || ' '::text) || COALESCE(x."CLOSURESTA", ''::text))
  WHERE x."FEDERALREG" = 'Yes'::text AND (x.facility_id IN ( SELECT y_1.facility_id
           FROM ut_ust.ut_facility y_1
          WHERE y_1."TANK" = 1 AND y_1."OPENREGAST" = 0 AND y_1."REGAST" = 0));

select count(*) from ut_ust.v_ust_compartment ;
18638
select * from v_ust_compartment;


--------------------------------------------------------------------------------------------------------------------------
--ust_piping


select organization_table_name_qtd, organization_column_name_qtd,
	selected_column, programmer_comments, 
	database_lookup_table, database_lookup_column,
	--organization_join_table_qtd, organization_join_column_qtd,
	deagg_table_name, deagg_column_name 
from v_ust_table_population_sql
where ust_control_id = 19 and epa_table_name = 'ust_piping'
order by column_sort_order;


drop table ut_ust.erg_piping;

delete from erg_piping;
create table ut_ust.erg_piping (facility_id int,  tank_id int, compartment_id int, piping_id int generated always as identity);
insert into ut_ust.erg_piping (facility_id,tank_id,compartment_id)
select  facility_id, tank_id,compartment_id  from ut_ust.erg_compartment ;


drop view v_ust_piping;
-- ut_ust.v_ust_piping source

-- ut_ust.v_ust_piping source

CREATE OR REPLACE VIEW ut_ust.v_ust_piping
AS SELECT DISTINCT t.piping_id::character varying(50) AS piping_id,
    c.facility_id::character varying(50) AS facility_id,
    t.tank_id,
    t.compartment_id,
        CASE c."PIPEMATDES"
            WHEN 'Fiberglass Reinforced Plastic'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_frp,
        CASE c."PIPEMATDES"
            WHEN 'Galvanized Steel'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_gal_steel,
        CASE c."PIPEMATDES"
            WHEN 'Bare Steel'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_steel,
        CASE c."PIPEMATDES"
            WHEN 'Copper'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_copper,
        CASE c."PIPEMATDES"
            WHEN 'Flexible Plastic'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_flex,
        CASE c."PIPEMATDES"
            WHEN 'No Piping'::text THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_no_piping,
        CASE
            WHEN c."PIPEMATDES" = ANY (ARRAY['Other'::text, 'Not Listed'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_other,
        CASE
            WHEN c."PIPEMATDES" = ANY (ARRAY['Unknown'::text]) THEN 'Yes'::text
            ELSE NULL::text
        END AS piping_material_unknown,
        case when c."PIPEMODDES" = 'Secondary Containment' then 'Yes' else null end as  pipe_secondary_containment_other,
        "piping_corrosion_protection_sacrificial_anode"::character varying(7) as piping_corrosion_protection_sacrificial_anode,
        epcof.piping_corrosion_protection_other, 
        piping_wall_type_id as piping_wall_type_id        
   FROM ut_ust.ut_tank c
     JOIN ut_ust.erg_piping t ON c.facility_id::integer = t.facility_id AND c.tank_id = t.tank_id
     left join ut_ust.erg_piping_cp_fields epcf on c.facility_id::integer  = epcf.facility_id  AND c.tank_id = epcf.tank_id
     left join ut_ust.erg_piping_cp_other_fields epcof on c.facility_id::integer  = epcof.facility_id  AND c.tank_id = epcof.tank_id     
     LEFT JOIN ut_ust.v_piping_wall_type_xwalk s ON s.organization_value::text = c."PIPEMODDES"
     WHERE c."FEDERALREG" = 'Yes'::text AND (c.facility_id IN ( SELECT y.facility_id
           FROM ut_ust.ut_facility y
          WHERE y."TANK" = 1 AND y."OPENREGAST" = 0 AND y."REGAST" = 0));
         
select * from erg_piping_cp_other_fields;
         select distinct "PIPEMATDES" from ut_tank order by 1;
        
select * from ut_ust.v_ust_piping;



select * from ust_element_mapping where ust_control_id = 19    order by epa_Table_name;



select * from ut_ust.v_ust_piping;
select count(*) from ut_ust.v_ust_piping; 18638

select count(*)
   FROM ut_ust.ut_tank c
     JOIN ut_ust.erg_piping t ON c.facility_id::integer = t.facility_id AND c.tank_id = t.tank_id
  WHERE c."FEDERALREG" = 'Yes'::text AND (c.facility_id IN ( SELECT y.facility_id
           FROM ut_ust.ut_facility y
          WHERE y."TANK" = 1 AND y."OPENREGAST" = 0 AND y."REGAST" = 0))
         and ("PIPEMODDES" = 'Cathodically Protected' and "PIPEMATDES"= 'Galvanized Steel') ;

        
        select distinct "PIPEMODDES" from ut_ust.ut_tank

select count(*) from ut_ust.v_ust_piping where piping_corrosion_protection_sacrificial_anode is not null;
264
--------------------------------------------------------------------------------------------------------------------------

select * from ust_element_mapping where epa_column_name = 'facility_state';


--see older QA stuff at bottom commented out


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Step 5: Check for lookup data that needs to be deaggregated 

/* 
 * Some states store data with multiple values in a single row, for example, 
 * a tank with multiple substances in one row. Before proceeding, we need 
 * to deaggregate this data by creating an ERG table that contains a single
 * value per row.
 * 
 * Run script generate_deagg_code.py to look for state data that may be
 * in this format, and then perform the deaggregation if necessary. 
 * Set the following variables before running the script:
 
ust_or_release = 'ust' 			# valid values are 'ust' or 'release'
control_id = ZZ                 # Enter an integer that is the ust_control_id or release_control_id
only_incomplete = True 			# Boolean, set to True to restrict the output to EPA columns that have not yet been value mapped or False to output mapping for all columns

 * If - and only if - this script identifies possible aggregrated data, it will output SQL file in the repo at
 * /ust/sql/XX/UST/XX_UST_deagg.sql). Open the generated file in your database console and step through it.  
 * If no file is produced, proceed to the next step. 
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
	where ust_control_id = 19 and mapping_complete = 'N'
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
where ust_control_id = 19 and organization_table_name like 'erg%'
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
where ust_control_id = 19
order by sort_order;


select  facility_id,tank_id,substance_id from ut_ust.v_ust_tank_substance group by  facility_id,tank_id,substance_id having count(*) > 1;

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


/*
--QA/QC

--check that you didn't miss any columns when creating the data population views:
--if any rows are returned by this query, fix the appropriate view by adding the missing columns!
select epa_table_name, epa_column_name, 
	organization_table_name, organization_column_name, 
	organization_join_table, organization_join_column, 
	deagg_table_name, deagg_column_name
from v_ust_missing_view_mapping a
where ust_control_id = 19
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

The script will also provide the counts of rows in ut_ust.v_ust_facility, ut_ust.v_ust_tank, ut_ust.v_ust_compartment, and
   ut_ust.v_ust_piping (if these views exist) - ensure these counts make sense! 
   
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
where ust_control_id = 19 
order by sort_order;
/*
ust_facility	6088
ust_tank	18638
ust_tank_substance	18638
ust_compartment	18638
ust_piping	18638
*/

select count(*) from v_ust_tank;
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



--------------------------------------------------------------------------------------------------------------------------




	select distinct ust_tank_id, compartment_id, compartment_status_id, compartment_capacity_gallons,c.tank_id
	from ut_ust.v_ust_compartment a 
		join (select ust_facility_id, facility_id from public.ust_facility where ust_control_id = 19) b
			on a.facility_id = b.facility_id
		join public.ust_tank c on b.ust_facility_id = c.ust_facility_id and a.tank_id = c.tank_id
		
		
		;
		
	*/