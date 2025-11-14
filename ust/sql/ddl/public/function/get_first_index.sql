create or replace function "public"."get_first_index" as
CREATE OR REPLACE FUNCTION public.get_first_index(search_string text, search_char text)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
declare
	i integer;
begin 
	select position(search_char in search_string) into i;
	return i;
end
$function$
