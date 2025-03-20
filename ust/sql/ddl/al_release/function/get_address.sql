create or replace function "al_release"."get_address" as
CREATE OR REPLACE FUNCTION al_release.get_address(search_string text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
declare
	i integer;
	address text;
begin 
	select get_first_index(search_string, ',') - 1 into i;
	select trim(substring(search_string for i)) into address;
	return address;
end
$function$
