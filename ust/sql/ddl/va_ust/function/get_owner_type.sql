create or replace function "va_ust"."get_owner_type" as
CREATE OR REPLACE FUNCTION va_ust.get_owner_type(fac_id character varying)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$  
Declare  
 return_id varchar;  
 return_type1 varchar;
 return_type_id varchar;
	
Begin  
	select max("Owner_ID")
	into return_id
	from va_ust.owner_data
	where "Fac_Id" = fac_id;

	select "Owner_Type"
	into return_type1
	from va_ust.owner_data
	where "Owner_ID" = return_id;

	select owner_type_id
	into return_type_id
	from va_ust.v_owner_type_xwalk
	where organization_value = return_type1;

   return return_type_id;  
End;  
$function$
