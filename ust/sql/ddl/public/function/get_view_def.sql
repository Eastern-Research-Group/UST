create or replace function "public"."get_view_def" as
CREATE OR REPLACE FUNCTION public.get_view_def(p_view_name character varying, p_schema character varying DEFAULT 'public'::character varying)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_view_def text;   
	v_view_name  varchar := p_schema || '.' || p_view_name;
BEGIN
	select pg_get_viewdef(v_view_name) into v_view_def;
	return v_view_def;
END;
$function$
