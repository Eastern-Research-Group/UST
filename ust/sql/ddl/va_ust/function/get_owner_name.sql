create or replace function "va_ust"."get_owner_name" as
CREATE OR REPLACE FUNCTION va_ust.get_owner_name(fac_id character varying)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$  
Declare  
 return_id varchar;  
 return_name varchar;
	
Begin  
	select max("Owner_ID")
	into return_id
	from va_ust.owner_data
	where "Fac_Id" = fac_id;

	select "Owner_Name"
	into return_name
	from va_ust.owner_data
	where "Owner_ID" = return_id;

   return return_name;  
End;  
$function$
