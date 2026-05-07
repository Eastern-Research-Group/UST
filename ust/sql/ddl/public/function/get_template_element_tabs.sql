create or replace function "public"."get_template_element_tabs" as
CREATE OR REPLACE FUNCTION public.get_template_element_tabs(v_element_id integer)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
declare 
	v_tabs text; 
begin 
	select string_agg(tab, ', ' order by sort_order) 
	into v_tabs 
	from 
		(select distinct b.template_tab_name as tab,
			b.sort_order
		from ust_elements_tables a join ust_element_table_sort_order b 
			on a.table_name  = b.table_name
	where a.element_id = v_element_id) x;
	return v_tabs;
end $function$
