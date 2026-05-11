create or replace function "public"."get_last_index" as
CREATE OR REPLACE FUNCTION public.get_last_index(search_string text, search_char text)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
declare
	i integer;
begin 
	select length(search_string) - position(search_char in reverse_string(search_string)) + 1 into i;
	return i;
end
$function$
