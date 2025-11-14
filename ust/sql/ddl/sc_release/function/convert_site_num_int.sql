create or replace function "sc_release"."convert_site_num_int" as
CREATE OR REPLACE FUNCTION sc_release.convert_site_num_int(site_num bigint)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
declare v_site_num text;
begin
	v_site_num = cast(site_num as text);
	case length(v_site_num) 
		when 1 then v_site_num = 'UST-0000' || v_site_num; 
		when 2 then v_site_num = 'UST-000' || v_site_num; 
		when 3 then v_site_num = 'UST-00' || v_site_num; 
		when 4 then v_site_num = 'UST-0' || v_site_num;
	else v_site_num = 'UST-' || v_site_num;	
	end case;
	return v_site_num;
end;
$function$
