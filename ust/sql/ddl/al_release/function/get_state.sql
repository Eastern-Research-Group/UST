create or replace function "al_release"."get_state" as
CREATE OR REPLACE FUNCTION al_release.get_state(search_string text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
declare
	i integer;
	i2 integer;
	len integer;
	state text;
	string text;
begin 
	if search_string like '%AL' then
		string = search_string || ' ';
	else
		string = search_string;
	end if;
	select get_last_index(string, ',') + 2 into i;
	select get_last_index(string, ' ') + 2 into i2;
	select i2 - i into len;
	select trim(substring(string from i for len)) into state;
	return state;
end
$function$
