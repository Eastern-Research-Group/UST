create or replace function "public"."get_lookup_table_contents" as
CREATE OR REPLACE FUNCTION public.get_lookup_table_contents(v_table_name text, v_column_name text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
declare
	x record;
	v_text text := '';
begin
	for x in execute format('select %I from (select * from %I order by 1) x', v_column_name, v_table_name)
	loop
		v_text := v_text || replace(replace(x::text,'(',''),')','') || chr(10);
	end loop;
	v_text := rtrim(v_text, chr(10));
	return v_text;
end
$function$
