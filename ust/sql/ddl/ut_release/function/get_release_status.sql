create or replace function "ut_release"."get_release_status" as
CREATE OR REPLACE FUNCTION ut_release.get_release_status(p_lust_key bigint)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$  
Declare  
  rec record := null;
  return_val varchar(4000) := null;
	
Begin  	
	
	select "NFAFORM", "CLOSURETYPE","DATECLOSE"
	into rec
	from ut_lust 
	where "LUSTKEY" = p_lust_key;	
	
	--"CLOSURETYPE","DATECLOSE","NFAFORM"
	if  rec."NFAFORM" = '< RCL/MCL' and rec."DATECLOSE" is not null then 
		return_val := 'No further action';
	elsif rec."NFAFORM" = '< RCL/MCL' and rec."DATECLOSE" is null then 
		return_val := 'Active: corrective action';
	elsif trim(lower(rec."NFAFORM")) = '<blank>' and rec."DATECLOSE" is not null then 
		return_val := 'No further action';
	elsif trim(lower(rec."NFAFORM")) = 'closeout checklist' and rec."DATECLOSE" is not null then 
		return_val := 'No further action';
	elsif trim(lower(rec."NFAFORM")) = 'closeout checklist' and rec."DATECLOSE" is null then 
		return_val := 'Active: corrective action';
	elsif trim(lower(rec."NFAFORM")) = 'internal closeout memo' and rec."DATECLOSE" is not null and rec."DATECLOSE" is not null  then  --requires discussion with UT
		return_val := 'No further action';
	elsif trim(rec."NFAFORM") = 'null' and rec."DATECLOSE" is not null and (rec."CLOSURETYPE" is null or lower(trim(rec."CLOSURETYPE")) not like '%transfer%') then  --requires discussion with UT
		return_val := 'No further action';
	elsif trim(rec."NFAFORM") = 'null' and rec."DATECLOSE" is null and (rec."CLOSURETYPE" is null or lower(trim(rec."CLOSURETYPE")) not like '%transfer%') then  --requires discussion with UT
		return_val := 'Active: corrective action';
	elsif trim(rec."NFAFORM") = 'null' and lower(trim(rec."CLOSURETYPE"))  like '%transfer%' then  --requires discussion with UT
		return_val := 'Other';
	elsif trim(lower(rec."NFAFORM")) = 'risk assessment' and rec."DATECLOSE" is not null then 
		return_val := 'No further action';
	elsif trim(lower(rec."NFAFORM")) = 'risk assessment' and rec."DATECLOSE" is null then 
		return_val := 'Active: corrective action';
	elsif trim(lower(rec."NFAFORM")) = 'tier 1 worksheet' and rec."DATECLOSE" is not null then 
		return_val := 'No further action';
	elsif trim(lower(rec."NFAFORM")) = 'tier 1 worksheet' and rec."DATECLOSE" is null then 
		return_val := 'Active: corrective action';
	elsif trim(lower(rec."NFAFORM")) = 'tier 1 worksheet w/ supp. info' and rec."DATECLOSE" is not null then 
		return_val := 'No further action';
	elsif trim(lower(rec."NFAFORM")) = 'tier 1 worksheet w/ supp. info' and rec."DATECLOSE" is null then 
		return_val := 'Active: corrective action';
	elsif trim(lower(rec."NFAFORM")) = 'tier 2 risk assessment' and rec."DATECLOSE" is not null then 
		return_val := 'No further action';
	elsif trim(lower(rec."NFAFORM")) = 'tier 2 risk assessment' and rec."DATECLOSE" is null then 
		return_val := 'Active: corrective action';
	elsif trim(lower(rec."NFAFORM")) = 'tier 2 w/institutional controls' and rec."DATECLOSE" is not null then 
		return_val := 'No further action';
	elsif trim(lower(rec."NFAFORM")) = 'tier 2 w/institutional controls' and rec."DATECLOSE" is null then 
		return_val := 'Active: corrective action';
	elsif trim(lower(rec."NFAFORM")) = 'tier 2 worksheet' and rec."DATECLOSE" is not null then 
		return_val := 'No further action';
	elsif trim(lower(rec."NFAFORM")) = 'tier 2 worksheet' and rec."DATECLOSE" is null then 
		return_val := 'Active: corrective action';
	elsif trim(lower(rec."NFAFORM")) = 'transfer - dwq' and rec."DATECLOSE" is not null then --requires discussion with UT
		return_val := 'No further action';
	elsif trim(lower(rec."NFAFORM")) = 'transfer - dwq' and rec."DATECLOSE" is null then --requires discussion with UT
		return_val := 'Other';
	elsif trim(lower(rec."NFAFORM")) like 'ust nfa%' then
		return_val := 'No further action';
	end if;
	

	
   return return_val;  
End;  
$function$
