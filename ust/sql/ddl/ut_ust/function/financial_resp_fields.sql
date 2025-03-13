create or replace function "ut_ust"."financial_resp_fields" as
CREATE OR REPLACE FUNCTION ut_ust.financial_resp_fields(p_fac_id integer, field_name character varying)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$  
Declare  
 return_val varchar;  
 l_count integer;
	
Begin  
	l_count := 0;
	if field_name = 'financial_responsibility_state_fund' then
		select count(*)
		into l_count
		from ut_ust.ut_tank where "PST_FUND" = 'Yes' 
		and facility_id=p_fac_id;
	elsif field_name = 'financial_responsibility_commercial_insurance' then
		select count(*)
		into l_count
		from ut_ust.ut_tank where "OTHERTYPE" = 'Insurance'
		and facility_id=p_fac_id;
	elsif field_name = 'financial_responsibility_guarantee' then
		select count(*)
		into l_count
		from ut_ust.ut_tank where "OTHERTYPE" = 'Guarantee' 
		and facility_id=p_fac_id;
	elsif field_name = 'financial_responsibility_self_insurance_financial_test' then
		select count(*)
		into l_count
		from ut_ust.ut_tank where "OTHERTYPE" like 'Self-insurance%'
		and facility_id=p_fac_id;
	elsif field_name = 'financial_responsibility_other_method' then
		select count(*)
		into l_count
		from ut_ust.ut_tank where "OTHERTYPE" in ('Exempt','Not Required') 
		and facility_id=p_fac_id;	
	end if;


	if l_count > 0 then
		return_val = 'Yes';
	else
		return_val = 'No';
	end if;
	
   return return_val;  
End;  
$function$
