create or replace function "al_release"."get_zip_code" as
CREATE OR REPLACE FUNCTION al_release.get_zip_code(search_string text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
declare
	i integer;
	zip text;
begin 
	if search_string like '%AL' then
		return null;
	end if;
	select get_last_index(search_string, ' ') + 2 into i;
	select substring(search_string from i) into zip;
	return zip;
end
$function$
