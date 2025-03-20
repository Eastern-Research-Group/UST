create or replace function "nh_ust"."load_facility_types" as
CREATE OR REPLACE PROCEDURE nh_ust.load_facility_types()
 LANGUAGE plpgsql
AS $procedure$  
Declare  
 l_count numeric := 0;  
 f record := null;
Begin  
	
	FOR f IN (SELECT a."SITE_NUMBER" site_number, a."FACILITY_TYPE" facility_type
              FROM facilities  a)
    LOOP 
    	l_count := 0;
        select count(*) into l_count from erg_facility_types where site_number = f.site_number and fac_type1 <> f.facility_type ;
      	
        if l_count > 0 then
			update erg_facility_types
			set fac_type2 = f.facility_type
			where site_number = f.site_number;
        else
        	insert into erg_facility_types values (f.site_number, f.facility_type, null);
      	end if;
       
    END LOOP;
	
	
End;  
$procedure$
