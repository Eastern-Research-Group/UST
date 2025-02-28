create or replace function "public"."get_current_mapping_id" as
CREATE OR REPLACE FUNCTION public.get_current_mapping_id(ust_or_lust text, in_state text, in_element_name text)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
declare
	v_mapping_date date;
	v_id integer;
begin
	if upper(ust_or_lust) = 'UST' then
		select max(mapping_date) into v_mapping_date
		from ust_element_db_mapping 
		where state = in_state and element_name = in_element_name;
	
		select min(id) into v_id from ust_element_db_mapping 
		where state = in_state and element_name = in_element_name and mapping_date = v_mapping_date;
	else 
		select max(mapping_date) into v_mapping_date
		from lust_element_db_mapping 
		where state = in_state and element_name = in_element_name;
	
		select min(id) into v_id from lust_element_db_mapping 
		where state = in_state and element_name = in_element_name and mapping_date = v_mapping_date;		
	end if;

	return v_id;
end;
$function$
