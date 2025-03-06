create or replace function "sd_ust"."getmaxcompartment" as
CREATE OR REPLACE FUNCTION sd_ust.getmaxcompartment(p_fac_id character varying, p_tank_id double precision)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$  
Declare  
 return_val int4;  
	
Begin  
	
	select max("TankCompartmentNumber")::int4 max_count
	into return_val
	from sd_ust.tanks
	where "FacilityNumber" = p_fac_id
	and "TankNumber" = p_tank_id;
	
	
   return return_val;  
End;  
$function$
