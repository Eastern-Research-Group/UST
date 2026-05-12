create or replace function "md_ust"."get_compartment_data" as
CREATE OR REPLACE FUNCTION md_ust.get_compartment_data(p_ust_facility_id bigint, p_tank_id bigint)
 RETURNS bigint
 LANGUAGE plpgsql
AS $function$  
Declare  
 return_val int8 ;  
f record;
Begin  
   FOR f IN
     select distinct "tblCompartment_Compartment" as compart_name from md_ust.md_tanks_combined where "FacilityID" = p_ust_facility_id and "TankID" = p_tank_id order by compart_name
   loop
	   if f.compart_name = 'E' then 
			return_val := 5;
		elsif f.compart_name = 'D' then 
			return_val := 4;
		elsif f.compart_name = 'C' then 
			return_val := 3;
		elsif f.compart_name = 'B'  then 
			return_val := 2;
		elsif f.compart_name = 'A' then 
			return_val := 1;
		end if;
	end loop;

	
   return return_val;  
End;  
$function$
