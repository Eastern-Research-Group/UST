create or replace function "public"."get_data_view_counts" as
CREATE OR REPLACE FUNCTION public.get_data_view_counts(p_schema_name character varying)
 RETURNS TABLE(view_name text, numrows bigint)
 LANGUAGE plpgsql
AS $function$
declare
	ust_or_release text := 'ust';
	loop_sql text;
	v_sql text := '';
	x record;
begin
	if p_schema_name like '%release' then
		ust_or_release := 'release';
	end if;
	loop_sql := format('select view_name, sort_order from information_schema.tables a join public.%I_template_data_tables b on a.table_name = b.view_name 
                        where a.table_schema = ''%I'' order by sort_order', ust_or_release, p_schema_name);
	for x in 
		execute loop_sql
	loop
		v_sql := v_sql || 'select ''' || x.view_name || ''' as view_name, count(*) as numrows,' || x.sort_order || ' as sort_order from ' || p_schema_name || '.' || x.view_name || ' union all ' ;
	end loop;
	v_sql := 'select view_name, numrows from (' || left(v_sql, -length(' union all')) || ') x order by sort_order';
	return query execute v_sql; 
end
$function$
