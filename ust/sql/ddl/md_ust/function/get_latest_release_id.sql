create or replace function "md_ust"."get_latest_release_id" as
CREATE OR REPLACE FUNCTION md_ust.get_latest_release_id(p_ust_facility_id character varying)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$  
Declare  
 return_val varchar;  
f record;
Begin  
   FOR f IN
     select release_id from md_ust.md_release_linkages where ust_facility_id = p_ust_facility_id order by date_open
   LOOP
		return_val := f.release_id;
	end loop;

	
   return return_val;  
End;  
$function$
