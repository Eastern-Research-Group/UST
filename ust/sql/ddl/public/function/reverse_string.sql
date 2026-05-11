create or replace function "public"."reverse_string" as
CREATE OR REPLACE FUNCTION public.reverse_string(text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
declare
    reversed_string text;
    incoming alias for $1;
begin
	reversed_string = '''';
	for i in reverse char_length(incoming)..1 loop
		reversed_string = reversed_string || substring(incoming from i for 1);
	end loop;
return reversed_string;
end
$function$
