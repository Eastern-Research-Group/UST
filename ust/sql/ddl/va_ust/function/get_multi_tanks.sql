create or replace function "va_ust"."get_multi_tanks" as
CREATE OR REPLACE FUNCTION va_ust.get_multi_tanks(p_tank_facility_id character varying)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$  
Declare  
 return_val varchar;  
 l_count integer;
	
Begin  
	select count(distinct tank_number)
	into l_count
	from va_ust.tanks 
	where tank_facility_id = p_tank_facility_id;

	if l_count > 1 then
		return_val = 'Yes';
	else
		return_val = 'No';
	end if;
	
   return return_val;  
End;  
$function$
